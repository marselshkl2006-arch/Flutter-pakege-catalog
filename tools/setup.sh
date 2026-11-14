#!/usr/bin/env bash
# One-time setup: generates the platform folders (android/, linux/, web/) with YOUR Flutter SDK,
# keeps the app code from this archive, adds the INTERNET permission for Android, runs pub get.
set -euo pipefail
cd "$(dirname "$0")/.."

command -v flutter >/dev/null 2>&1 || { echo "flutter not found in PATH"; exit 1; }

KEEP="$(mktemp -d)"
cp -r lib test assets pubspec.yaml analysis_options.yaml "$KEEP"/

flutter create --project-name crates_catalog --org com.example --platforms=android,linux,web .

# flutter create may have written its own sample files: restore ours.
rm -rf lib test
cp -r "$KEEP/lib" "$KEEP/test" .
cp "$KEEP/pubspec.yaml" "$KEEP/analysis_options.yaml" .
rm -rf "$KEEP"

# Android: release builds need the INTERNET permission (flutter create only adds it for debug).
python3 - <<'PY'
from pathlib import Path
p = Path("android/app/src/main/AndroidManifest.xml")
s = p.read_text()
if "android.permission.INTERNET" not in s:
    s = s.replace("<application", '<uses-permission android:name="android.permission.INTERNET"/>\n    <application', 1)
    p.write_text(s)
    print("Android: INTERNET permission added")
PY

flutter pub get
echo
echo "Done. Run:  flutter run -d linux   |   flutter run -d <android-device>   |   flutter test"
