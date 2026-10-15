#!/usr/bin/env python3
"""research-ops 스킬을 설치하고, 새 판이 있는지 확인하고, 갱신한다.

  install-skills.sh claude [프로젝트폴더]   Claude Code 스킬 폴더에 복사하고 설치 기록을 남긴다
  install-skills.sh codex  [프로젝트폴더]   Codex 스킬 폴더에 복사하고 설치 기록을 남긴다
  install-skills.sh zip <출력폴더>          스킬마다 zip (claude.ai 설정 화면에서 올린다)
  install-skills.sh list                    스킬 이름과 설명
  install-skills.sh check  [스킬폴더 ...]   설치한 판과 저장소의 새 판을 비교한다 (바꾸지 않는다)
  install-skills.sh update [스킬폴더 ...]   저장소를 받고, 사용자가 고치지 않은 스킬만 새 판으로 바꾼다

환경변수
  ONLY=a,b,c   이 스킬만 설치. research-session은 공통 규칙이라 늘 함께 넣는다
  FORCE=1      설치할 때 같은 이름의 스킬이 있으면 덮어쓴다
  CODEX_HOME   Codex 전역 폴더 (기본 ~/.codex)

설치 기록은 각 스킬 폴더의 .research-ops.json이다. 저장소 주소, 판, 커밋, 스킬마다 설치한 파일의 해시가 들어 있다.
check의 종료 코드: 0 최신, 3 새 판 있음, 1 오류.
update는 사용자가 고친 스킬(설치 때 해시와 다름)을 덮지 않고 SKILL.md.new로 둔다.
"""
import datetime, hashlib, json, os, pathlib, shutil, subprocess, sys, zipfile

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent.parent
SRC = ROOT / 'skills'
MANIFEST = '.research-ops.json'
CORE = 'research-session'


def now():
    return datetime.datetime.now().astimezone().isoformat(timespec='minutes')


def sha(p):
    return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()


def git(*args, check=True):
    r = subprocess.run(['git', '-C', str(ROOT), *args], capture_output=True, text=True)
    if check and r.returncode != 0:
        raise RuntimeError(f'git {" ".join(args)}: {r.stderr.strip()}')
    return r.stdout.strip()


def has_git():
    return (ROOT / '.git').exists()


def version_at(commit=None):
    if commit and has_git():
        try:
            return git('show', f'{commit}:VERSION').strip()
        except RuntimeError:
            return '?'
    v = ROOT / 'VERSION'
    return v.read_text().strip() if v.exists() else '?'


def all_skills():
    return sorted(d.name for d in SRC.iterdir() if (d / 'SKILL.md').is_file())


def wanted():
    only = os.environ.get('ONLY', '').replace(' ', '')
    if not only:
        return all_skills(), 'all'
    names = [CORE] + [n for n in only.split(',') if n]
    names = list(dict.fromkeys(names))
    bad = [n for n in names if not (SRC / n / 'SKILL.md').is_file()]
    if bad:
        sys.exit(f'없는 스킬: {" ".join(bad)} (아무것도 복사하지 않았다. 이름은 install-skills.sh list)')
    return names, 'only'


def dest_for(tool, project):
    if tool == 'claude':
        return pathlib.Path(project) / '.claude/skills' if project else pathlib.Path.home() / '.claude/skills'
    home = pathlib.Path(os.environ.get('CODEX_HOME', pathlib.Path.home() / '.codex'))
    return pathlib.Path(project) / '.codex/skills' if project else home / 'skills'


def load(dest):
    p = pathlib.Path(dest) / MANIFEST
    return json.loads(p.read_text(encoding='utf-8')) if p.exists() else None


def save(dest, m):
    (pathlib.Path(dest) / MANIFEST).write_text(json.dumps(m, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def repo_url():
    if not has_git():
        return '?'
    return git('remote', 'get-url', 'origin', check=False) or '?'


def head():
    return git('rev-parse', 'HEAD') if has_git() else '?'


def install(tool, project):
    names, mode = wanted()
    dest = dest_for(tool, project)
    dest.mkdir(parents=True, exist_ok=True)
    m = load(dest) or {'tool': 'research-ops', 'skills': {}}
    m.update({'repo': repo_url(), 'source': str(ROOT), 'commit': head(), 'version': version_at(),
              'installed_at': now(), 'last_check': now()})
    m['mode'] = 'all' if mode == 'all' or m.get('mode') == 'all' else 'only'
    copied, skipped = [], []
    for n in names:
        target = dest / n
        if target.exists() and os.environ.get('FORCE') != '1':
            skipped.append(n)
            if n not in m['skills']:
                m['skills'][n] = {'sha256': None, 'note': '기록 전에 설치됨. 갱신 때 사용자가 고친 것으로 다룬다'}
            continue
        if target.exists():
            shutil.rmtree(target)
        shutil.copytree(SRC / n, target)
        m['skills'][n] = {'sha256': sha(target / 'SKILL.md')}
        copied.append(n)
    save(dest, m)
    print(f'복사 {len(copied)}개: {dest}')
    if skipped:
        print(f'이미 있어 건너뜀: {" ".join(skipped)} (덮어쓰려면 FORCE=1)')
    print(f'설치 기록: {dest / MANIFEST} (판 {m["version"]}, 커밋 {m["commit"][:7]})')


def make_zip(out):
    out = pathlib.Path(out); out.mkdir(parents=True, exist_ok=True)
    names, _ = wanted()
    for n in names:
        z = out / f'{n}.zip'
        with zipfile.ZipFile(z, 'w', zipfile.ZIP_DEFLATED) as f:
            for p in sorted((SRC / n).rglob('*')):
                f.write(p, p.relative_to(SRC))
    print(f'zip {len(names)}개: {out}')
    print('claude.ai: 설정 > Capabilities > Skills > Upload skill 에서 하나씩 올린다.')
    print(f'이 zip은 판 {version_at()}, 커밋 {head()[:7]}이다. 갱신하면 zip을 다시 만들어 다시 올린다.')


def listing():
    for n in all_skills():
        d = ''
        for line in (SRC / n / 'SKILL.md').read_text(encoding='utf-8').splitlines():
            if line.startswith('description:'):
                d = line.split(':', 1)[1].strip().strip('"'); break
        print(f'{n:<24} {d[:60]}{"…" if len(d) > 60 else ""}')


def default_dests():
    cands = [dest_for('claude', None), dest_for('codex', None),
             pathlib.Path.cwd() / '.claude/skills', pathlib.Path.cwd() / '.codex/skills']
    return [d for d in dict.fromkeys(cands) if (d / MANIFEST).exists()]


def changelog_since(old_version, target):
    """target 커밋의 CHANGELOG에서 old_version 뒤의 기록. 그 판을 찾지 못하면 가장 최근 판 하나만."""
    try:
        text = git('show', f'{target}:CHANGELOG.md')
    except RuntimeError:
        return []
    sections, cur = [], None
    for line in text.splitlines():
        if line.startswith('## '):
            cur = [line]; sections.append(cur)
        elif cur is not None and line.strip():
            cur.append(line)
    out = []
    for sec in sections:
        if sec[0].split()[1] == old_version:
            return out
        out.extend(sec)
    return sections[0] if sections else []


def latest():
    if not has_git():
        return None
    git('fetch', '-q', 'origin')
    branch = git('symbolic-ref', '--short', 'refs/remotes/origin/HEAD', check=False) or 'origin/main'
    return git('rev-parse', branch), branch


def status(dest, m, target):
    """설치한 스킬마다 상태를 돌려준다."""
    rows = []
    for n, rec in sorted(m['skills'].items()):
        f = pathlib.Path(dest) / n / 'SKILL.md'
        local = sha(f) if f.exists() else None
        r = subprocess.run(['git', '-C', str(ROOT), 'show', f'{target}:skills/{n}/SKILL.md'], capture_output=True)
        new = r.stdout if r.returncode == 0 else None
        new_hash = hashlib.sha256(new).hexdigest() if new is not None else None
        rec_hash = rec.get('sha256')
        if local is None:
            st = '지워짐(설치 폴더에 없음)'
        elif new is None:
            st = '저장소에서 빠짐'
        elif local == new_hash:
            st = '최신'
        elif rec_hash is None:
            st = '기록 전 설치, 새 판과 다름'
        elif rec_hash == new_hash:
            st = '사용자가 고침, 합칠 새 판이 SKILL.md.new에 있음' if (pathlib.Path(dest) / n / 'SKILL.md.new').exists() else '사용자가 고침(새 판 없음)'
        elif local == rec_hash:
            st = '새 판 있음'
        else:
            st = '사용자가 고침, 새 판 있음'
        rows.append((n, st))
    known = set(m['skills'])
    try:
        names = [p.split('/')[1] for p in git('ls-tree', '-r', '--name-only', target, 'skills').splitlines()
                 if p.endswith('/SKILL.md')]
    except RuntimeError:
        names = []
    added = sorted(set(names) - known)
    return rows, added


def check(dests, do_update=False):
    dests = [pathlib.Path(d) for d in dests] or default_dests()
    if not dests:
        print('설치 기록(.research-ops.json)이 있는 스킬 폴더를 찾지 못했다. install-skills.sh claude 또는 codex로 설치하면 기록이 생긴다.')
        return 1
    if not has_git():
        print(f'{ROOT}는 git 클론이 아니어서 새 판을 확인할 수 없다. 저장소를 git clone으로 받아 그 안의 스크립트로 확인한다.')
        return 1
    if do_update:
        dirty = git('status', '--porcelain')
        if dirty:
            print(f'{ROOT}에 커밋하지 않은 변경이 있어 받지 않는다. 그 변경을 정리한 뒤 다시 한다.')
            return 1
    got = latest()
    target, branch = got
    if do_update:
        git('merge', '--ff-only', '-q', branch)
    rc = 0
    for dest in dests:
        m = load(dest)
        if not m:
            print(f'{dest}: 설치 기록 없음'); continue
        old_c, old_v = m.get('commit', '?'), m.get('version', '?')
        new_v = version_at(target)
        rows, added = status(dest, m, target)
        behind = [r for r in rows if r[1] in ('새 판 있음', '사용자가 고침, 새 판 있음', '기록 전 설치, 새 판과 다름')] or added
        pending = [r[0] for r in rows if 'SKILL.md.new' in r[1]]
        print(f'== 갱신 확인 | {dest} | 설치 {old_v} ({old_c[:7]}) | 저장소 {new_v} ({target[:7]}) ==')
        for n, st in rows:
            print(f'  {n:<24} {st}')
        for n in added:
            print(f'  {n:<24} 새 스킬' + (' (전체 설치라 갱신 때 넣는다)' if m.get('mode') == 'all' else ' (일부 설치라 넣지 않는다. 원하면 ONLY로 설치)'))
        if behind and not do_update:
            rc = 3
            log = changelog_since(old_v, target) if old_v != new_v else []
            if log:
                print('  바뀐 것(CHANGELOG):')
                for line in log[:40]:
                    print('    ' + line)
            print('  갱신: install-skills.sh update ' + str(dest))
        if not behind:
            print('  새 판 없음' + (f'. 합칠 차례: {" ".join(pending)} (SKILL.md.new를 합친 뒤 지운다)' if pending else ''))
        if do_update and behind:
            merge = []
            for n, st in rows:
                d = pathlib.Path(dest) / n
                if st == '새 판 있음':
                    shutil.rmtree(d); shutil.copytree(SRC / n, d)
                    m['skills'][n] = {'sha256': sha(d / 'SKILL.md')}
                elif st.startswith('사용자가 고침') or st.startswith('기록 전 설치'):
                    shutil.copyfile(SRC / n / 'SKILL.md', d / 'SKILL.md.new')
                    m['skills'][n] = {'sha256': sha(d / 'SKILL.md.new'), 'note': '사용자가 고친 판. 이 해시는 마지막으로 받은 새 판'}
                    merge.append(n)
            if m.get('mode') == 'all':
                for n in added:
                    shutil.copytree(SRC / n, pathlib.Path(dest) / n)
                    m['skills'][n] = {'sha256': sha(pathlib.Path(dest) / n / 'SKILL.md')}
            m.update({'commit': target, 'version': new_v, 'installed_at': now()})
            print(f'  갱신함: 판 {new_v} ({target[:7]})')
            if merge:
                print('  사용자가 고친 스킬은 덮지 않았다. 새 판은 각 폴더의 SKILL.md.new에 있다. 바뀐 곳을 합친 뒤 .new를 지운다: ' + ' '.join(merge))
                print('  고친 스킬을 버리고 새 판으로 바꾸려면: FORCE=1 ONLY=<이름> install-skills.sh <claude|codex> [프로젝트폴더]')
        m['last_check'] = now()
        save(dest, m)
    return rc


def main():
    a = sys.argv[1:]
    if not a:
        print(__doc__); return 1
    cmd, rest = a[0], a[1:]
    if cmd in ('claude', 'codex'):
        install(cmd, rest[0] if rest else None); return 0
    if cmd == 'zip':
        if not rest: sys.exit('출력폴더를 준다')
        make_zip(rest[0]); return 0
    if cmd == 'list':
        listing(); return 0
    if cmd == 'check':
        return check(rest)
    if cmd == 'update':
        return check(rest, do_update=True)
    print(__doc__); return 1


if __name__ == '__main__':
    try:
        sys.exit(main())
    except RuntimeError as e:
        print(f'오류: {e}', file=sys.stderr); sys.exit(1)
