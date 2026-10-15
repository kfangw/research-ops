#!/usr/bin/env python3
"""판정 규칙 파일을 봉인하고 검증한다.

  seal.py seal   <파일> [--note "한 줄"]   -> <파일>.seal.json 작성
  seal.py verify <파일>                    -> 봉인 유지 / 봉인 뒤 변경
"""
import argparse, hashlib, json, sys, datetime, pathlib

def sha256(p: pathlib.Path) -> str:
    h = hashlib.sha256()
    with p.open('rb') as f:
        for chunk in iter(lambda: f.read(1 << 20), b''):
            h.update(chunk)
    return h.hexdigest()

def seal(path: pathlib.Path, note: str):
    out = path.with_suffix(path.suffix + '.seal.json')
    if out.exists():
        print(f'이미 봉인됨: {out}. 다시 봉인하려면 파일을 지우고 승인기록에 이유를 남긴다.')
        return 2
    now = datetime.datetime.now(datetime.timezone.utc)
    rec = {
        'file': path.name,
        'sha256': sha256(path),
        'bytes': path.stat().st_size,
        'sealed_at_utc': now.isoformat(timespec='seconds'),
        'sealed_at_local': now.astimezone().isoformat(timespec='seconds'),
        'note': note,
    }
    out.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(f'봉인: {path.name} sha256={rec["sha256"][:16]}… {rec["sealed_at_local"]}')
    return 0

def verify(path: pathlib.Path):
    out = path.with_suffix(path.suffix + '.seal.json')
    if not out.exists():
        print(f'봉인 기록 없음: {out}')
        return 2
    rec = json.loads(out.read_text(encoding='utf-8'))
    cur = sha256(path)
    if cur == rec['sha256']:
        print(f'봉인 유지: {path.name} ({rec["sealed_at_local"]})')
        return 0
    print(f'봉인 뒤 변경: {path.name}\n  봉인 해시 {rec["sha256"]}\n  현재 해시 {cur}\n  승인기록에 변경 이유를 적어야 한다.')
    return 1

def main():
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest='cmd', required=True)
    s = sub.add_parser('seal'); s.add_argument('file'); s.add_argument('--note', default='')
    v = sub.add_parser('verify'); v.add_argument('file')
    a = ap.parse_args()
    p = pathlib.Path(a.file)
    if not p.is_file():
        print(f'파일 없음: {p}'); return 2
    return seal(p, a.note) if a.cmd == 'seal' else verify(p)

if __name__ == '__main__':
    sys.exit(main())
