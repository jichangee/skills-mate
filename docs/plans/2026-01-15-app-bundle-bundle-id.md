# App Bundle And Bundle ID Implementation Plan
> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.
**Goal:** 让 Xcode 运行生成标准 macOS `.app`，并设置 `PRODUCT_BUNDLE_IDENTIFIER`，消除缺少 bundle id 的系统日志。
**Architecture:** 新增一个 macOS App 的 Xcode 工程，直接编译现有 `Sources/SkillsMateApp` 代码，并通过 `Info.plist` 与 build settings 提供 bundle id。
**Tech Stack:** SwiftUI, Xcode project, macOS App target, Info.plist, bash
---

### Task 1: 添加 bundle id 验证脚本（失败用例）

**Files:**
- Create: `scripts/check-bundle-id.sh`

**Step 1: Write the failing test**
```bash
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
```

**Step 2: Run test to verify it fails**
Run: `bash scripts/check-bundle-id.sh`  
Expected: FAIL with "Missing Xcode project" or "Missing Info.plist"

**Step 3: Write minimal implementation**
N/A (this task only adds the failing test script)

**Step 4: Run test to verify it passes**
Run: `bash scripts/check-bundle-id.sh`  
Expected: STILL FAIL (project/plist not yet created)

**Step 5: Commit**
```bash
git add scripts/check-bundle-id.sh
git commit -m "test: add bundle id verification script"
```

---

### Task 2: 创建 macOS App 的 Info.plist

**Files:**
- Create: `SkillsMateApp/Info.plist`
- Test: `scripts/check-bundle-id.sh`

**Step 1: Write the failing test**
```bash
bash scripts/check-bundle-id.sh
```

**Step 2: Run test to verify it fails**
Expected: FAIL with "Missing Info.plist"

**Step 3: Write minimal implementation**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
</dict>
</plist>
```

**Step 4: Run test to verify it passes**
Run: `bash scripts/check-bundle-id.sh`  
Expected: FAIL with "Missing Xcode project" or bundle id missing in pbxproj

**Step 5: Commit**
```bash
git add SkillsMateApp/Info.plist
git commit -m "build: add Info.plist for app bundle"
```

---

### Task 3: 创建 Xcode 工程并设置 bundle id

**Files:**
- Create: `SkillsMate.xcodeproj/project.pbxproj`
- Modify: `scripts/check-bundle-id.sh` (if needed)
- Test: `scripts/check-bundle-id.sh`

**Step 1: Write the failing test**
```bash
bash scripts/check-bundle-id.sh
```

**Step 2: Run test to verify it fails**
Expected: FAIL with "Missing Xcode project" or "PRODUCT_BUNDLE_IDENTIFIER not set"

**Step 3: Write minimal implementation**
```pbxproj
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
		2F0B1D3F2B3A1A0100000001 /* SkillsMateApp.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2F0B1D332B3A1A0100000001 /* SkillsMateApp.swift */; };
		2F0B1D402B3A1A0100000001 /* ContentView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2F0B1D342B3A1A0100000001 /* ContentView.swift */; };
		2F0B1D412B3A1A0100000001 /* LocalSkillsView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2F0B1D352B3A1A0100000001 /* LocalSkillsView.swift */; };
		2F0B1D422B3A1A0100000001 /* MarketplaceView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2F0B1D362B3A1A0100000001 /* MarketplaceView.swift */; };
		2F0B1D432B3A1A0100000001 /* Skill.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2F0B1D372B3A1A0100000001 /* Skill.swift */; };
		2F0B1D442B3A1A0100000001 /* SkillLocation.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2F0B1D382B3A1A0100000001 /* SkillLocation.swift */; };
		2F0B1D452B3A1A0100000001 /* MarketplaceItem.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2F0B1D392B3A1A0100000001 /* MarketplaceItem.swift */; };
		2F0B1D462B3A1A0100000001 /* GitHubSkill.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2F0B1D3A2B3A1A0100000001 /* GitHubSkill.swift */; };
		2F0B1D472B3A1A0100000001 /* MarketplaceCatalog.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2F0B1D3B2B3A1A0100000001 /* MarketplaceCatalog.swift */; };
		2F0B1D482B3A1A0100000001 /* SkillsStore.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2F0B1D3C2B3A1A0100000001 /* SkillsStore.swift */; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
		2F0B1D2E2B3A1A0100000001 /* SkillsMate.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; path = SkillsMate.app; sourceTree = BUILT_PRODUCTS_DIR; };
		2F0B1D332B3A1A0100000001 /* SkillsMateApp.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/SkillsMateApp/SkillsMateApp.swift; sourceTree = SOURCE_ROOT; };
		2F0B1D342B3A1A0100000001 /* ContentView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/SkillsMateApp/Views/ContentView.swift; sourceTree = SOURCE_ROOT; };
		2F0B1D352B3A1A0100000001 /* LocalSkillsView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/SkillsMateApp/Views/LocalSkillsView.swift; sourceTree = SOURCE_ROOT; };
		2F0B1D362B3A1A0100000001 /* MarketplaceView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/SkillsMateApp/Views/MarketplaceView.swift; sourceTree = SOURCE_ROOT; };
		2F0B1D372B3A1A0100000001 /* Skill.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/SkillsMateApp/Models/Skill.swift; sourceTree = SOURCE_ROOT; };
		2F0B1D382B3A1A0100000001 /* SkillLocation.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/SkillsMateApp/Models/SkillLocation.swift; sourceTree = SOURCE_ROOT; };
		2F0B1D392B3A1A0100000001 /* MarketplaceItem.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/SkillsMateApp/Models/MarketplaceItem.swift; sourceTree = SOURCE_ROOT; };
		2F0B1D3A2B3A1A0100000001 /* GitHubSkill.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/SkillsMateApp/Models/GitHubSkill.swift; sourceTree = SOURCE_ROOT; };
		2F0B1D3B2B3A1A0100000001 /* MarketplaceCatalog.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/SkillsMateApp/Services/MarketplaceCatalog.swift; sourceTree = SOURCE_ROOT; };
		2F0B1D3C2B3A1A0100000001 /* SkillsStore.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/SkillsMateApp/Services/SkillsStore.swift; sourceTree = SOURCE_ROOT; };
		2F0B1D3D2B3A1A0100000001 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = SkillsMateApp/Info.plist; sourceTree = SOURCE_ROOT; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		2F0B1D2C2B3A1A0100000001 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		2F0B1D252B3A1A0100000001 = {
			isa = PBXGroup;
			children = (
				2F0B1D2F2B3A1A0100000001 /* App */,
				2F0B1D2D2B3A1A0100000001 /* Products */,
			);
			sourceTree = "<group>";
		};
		2F0B1D2D2B3A1A0100000001 /* Products */ = {
			isa = PBXGroup;
			children = (
				2F0B1D2E2B3A1A0100000001 /* SkillsMate.app */,
			);
			name = Products;
			sourceTree = "<group>";
		};
		2F0B1D2F2B3A1A0100000001 /* App */ = {
			isa = PBXGroup;
			children = (
				2F0B1D332B3A1A0100000001 /* SkillsMateApp.swift */,
				2F0B1D342B3A1A0100000001 /* ContentView.swift */,
				2F0B1D352B3A1A0100000001 /* LocalSkillsView.swift */,
				2F0B1D362B3A1A0100000001 /* MarketplaceView.swift */,
				2F0B1D372B3A1A0100000001 /* Skill.swift */,
				2F0B1D382B3A1A0100000001 /* SkillLocation.swift */,
				2F0B1D392B3A1A0100000001 /* MarketplaceItem.swift */,
				2F0B1D3A2B3A1A0100000001 /* GitHubSkill.swift */,
				2F0B1D3B2B3A1A0100000001 /* MarketplaceCatalog.swift */,
				2F0B1D3C2B3A1A0100000001 /* SkillsStore.swift */,
				2F0B1D3D2B3A1A0100000001 /* Info.plist */,
			);
			name = App;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		2F0B1D2B2B3A1A0100000001 /* SkillsMate */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = 2F0B1D312B3A1A0100000001 /* Build configuration list for PBXNativeTarget "SkillsMate" */;
			buildPhases = (
				2F0B1D2A2B3A1A0100000001 /* Sources */,
				2F0B1D2C2B3A1A0100000001 /* Frameworks */,
				2F0B1D2F2B3A1A0100000002 /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = SkillsMate;
			productName = SkillsMate;
			productReference = 2F0B1D2E2B3A1A0100000001 /* SkillsMate.app */;
			productType = "com.apple.product-type.application";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		2F0B1D262B3A1A0100000001 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastUpgradeCheck = 1500;
				TargetAttributes = {
					2F0B1D2B2B3A1A0100000001 = {
						CreatedOnToolsVersion = 15.0;
					};
				};
			};
			buildConfigurationList = 2F0B1D292B3A1A0100000001 /* Build configuration list for PBXProject "SkillsMate" */;
			compatibilityVersion = "Xcode 15.0";
			mainGroup = 2F0B1D252B3A1A0100000001;
			productRefGroup = 2F0B1D2D2B3A1A0100000001 /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				2F0B1D2B2B3A1A0100000001 /* SkillsMate */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		2F0B1D2F2B3A1A0100000002 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		2F0B1D2A2B3A1A0100000001 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				2F0B1D3F2B3A1A0100000001 /* SkillsMateApp.swift in Sources */,
				2F0B1D402B3A1A0100000001 /* ContentView.swift in Sources */,
				2F0B1D412B3A1A0100000001 /* LocalSkillsView.swift in Sources */,
				2F0B1D422B3A1A0100000001 /* MarketplaceView.swift in Sources */,
				2F0B1D432B3A1A0100000001 /* Skill.swift in Sources */,
				2F0B1D442B3A1A0100000001 /* SkillLocation.swift in Sources */,
				2F0B1D452B3A1A0100000001 /* MarketplaceItem.swift in Sources */,
				2F0B1D462B3A1A0100000001 /* GitHubSkill.swift in Sources */,
				2F0B1D472B3A1A0100000001 /* MarketplaceCatalog.swift in Sources */,
				2F0B1D482B3A1A0100000001 /* SkillsStore.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		2F0B1D322B3A1A0100000001 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				CODE_SIGNING_ALLOWED = NO;
				CODE_SIGNING_REQUIRED = NO;
				CODE_SIGN_IDENTITY = "-";
				DEVELOPMENT_TEAM = "";
				INFOPLIST_FILE = SkillsMateApp/Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/../Frameworks",
				);
				MACOSX_DEPLOYMENT_TARGET = 13.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.skillsmate.app;
				PRODUCT_NAME = SkillsMate;
				SDKROOT = macosx;
				SWIFT_VERSION = 5.9;
			};
			name = Debug;
		};
		2F0B1D332B3A1A0100000002 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				CODE_SIGNING_ALLOWED = NO;
				CODE_SIGNING_REQUIRED = NO;
				CODE_SIGN_IDENTITY = "-";
				DEVELOPMENT_TEAM = "";
				INFOPLIST_FILE = SkillsMateApp/Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/../Frameworks",
				);
				MACOSX_DEPLOYMENT_TARGET = 13.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.skillsmate.app;
				PRODUCT_NAME = SkillsMate;
				SDKROOT = macosx;
				SWIFT_VERSION = 5.9;
			};
			name = Release;
		};
		2F0B1D302B3A1A0100000001 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				CODE_SIGNING_ALLOWED = NO;
				CODE_SIGNING_REQUIRED = NO;
				CODE_SIGN_IDENTITY = "-";
				DEVELOPMENT_TEAM = "";
				INFOPLIST_FILE = SkillsMateApp/Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/../Frameworks",
				);
				MACOSX_DEPLOYMENT_TARGET = 13.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.skillsmate.app;
				SDKROOT = macosx;
				SWIFT_VERSION = 5.9;
			};
			name = Debug;
		};
		2F0B1D312B3A1A0100000002 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				CODE_SIGNING_ALLOWED = NO;
				CODE_SIGNING_REQUIRED = NO;
				CODE_SIGN_IDENTITY = "-";
				DEVELOPMENT_TEAM = "";
				INFOPLIST_FILE = SkillsMateApp/Info.plist;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/../Frameworks",
				);
				MACOSX_DEPLOYMENT_TARGET = 13.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.skillsmate.app;
				SDKROOT = macosx;
				SWIFT_VERSION = 5.9;
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		2F0B1D292B3A1A0100000001 /* Build configuration list for PBXProject "SkillsMate" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				2F0B1D302B3A1A0100000001 /* Debug */,
				2F0B1D312B3A1A0100000002 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Debug;
		};
		2F0B1D312B3A1A0100000001 /* Build configuration list for PBXNativeTarget "SkillsMate" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				2F0B1D322B3A1A0100000001 /* Debug */,
				2F0B1D332B3A1A0100000002 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Debug;
		};
/* End XCConfigurationList section */
	};
	rootObject = 2F0B1D262B3A1A0100000001 /* Project object */;
}
```

**Step 4: Run test to verify it passes**
Run: `bash scripts/check-bundle-id.sh`  
Expected: PASS with "bundle id checks passed"

**Step 5: Commit**
```bash
git add SkillsMate.xcodeproj/project.pbxproj
git commit -m "build: add Xcode app project with bundle id"
```

---

### Task 4: 构建与验证 Xcode 运行日志

**Files:**
- Test: `scripts/check-bundle-id.sh`

**Step 1: Write the failing test**
```bash
bash scripts/check-bundle-id.sh
```

**Step 2: Run test to verify it fails**
Expected: PASS (no failure expected; use as smoke test)

**Step 3: Write minimal implementation**
N/A

**Step 4: Run test to verify it passes**
Run: `xcodebuild -project SkillsMate.xcodeproj -scheme SkillsMate -configuration Debug build`  
Expected: BUILD SUCCEEDED

**Step 5: Commit**
```bash
git status
```
