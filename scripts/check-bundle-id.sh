#!/bin/bash
set -euo pipefail

PROJECT_FILE="SkillsMate.xcodeproj/project.pbxproj"
INFO_PLIST="SkillsMateApp/Info.plist"

if [[ ! -f "$PROJECT_FILE" ]]; then
  echo "Missing Xcode project: $PROJECT_FILE"
  exit 1
fi

if [[ ! -f "$INFO_PLIST" ]]; then
  echo "Missing Info.plist: $INFO_PLIST"
  exit 1
fi

expected="com.skillsmate.app"
actual=$(/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" "$INFO_PLIST" 2>/dev/null || true)

if [[ "$actual" != "\$(PRODUCT_BUNDLE_IDENTIFIER)" ]]; then
  echo "CFBundleIdentifier should be \$(PRODUCT_BUNDLE_IDENTIFIER), got: $actual"
  exit 1
fi

if ! grep -q "PRODUCT_BUNDLE_IDENTIFIER = $expected;" "$PROJECT_FILE"; then
  echo "PRODUCT_BUNDLE_IDENTIFIER not set to $expected in project.pbxproj"
  exit 1
fi

echo "bundle id checks passed"
