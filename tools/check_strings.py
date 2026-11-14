#!/usr/bin/env python3
"""Fails (exit 1) if the EN and RU ARB files do not define the same keys.

Usage: python3 tools/check_strings.py
"""
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FILES = {"en": ROOT / "assets/l10n/app_en.arb", "ru": ROOT / "assets/l10n/app_ru.arb"}


def load(path: Path) -> dict:
    if not path.exists():
        sys.exit(f"ERROR: missing file {path}")
    data = json.loads(path.read_text(encoding="utf-8"))
    return {k: v for k, v in data.items() if not k.startswith("@")}


def main() -> int:
    en, ru = load(FILES["en"]), load(FILES["ru"])
    ok = True
    for lang, own, other in (("RU", ru, en), ("EN", en, ru)):
        missing = sorted(set(other) - set(own))
        if missing:
            ok = False
            print(f"ERROR: keys missing in {lang}: {', '.join(missing)}")
    empty = sorted(k for d in (en, ru) for k, v in d.items() if not str(v).strip())
    if empty:
        ok = False
        print(f"ERROR: empty values: {', '.join(empty)}")
    if ok:
        print(f"OK: {len(en)} keys, EN and RU match")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
