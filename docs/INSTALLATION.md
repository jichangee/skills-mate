# SkillsMate 安装指南

## macOS 安装

### 下载

从 [Releases](https://github.com/yourusername/skills-mate/releases) 页面下载最新的 `.dmg` 文件。

### 安装步骤

#### 方法 1：标准安装（推荐）

1. 双击下载的 `.dmg` 文件
2. 将 **SkillsMate** 图标拖动到 **Applications** 文件夹
3. 打开 **Launchpad** 或 **Applications** 文件夹
4. 点击 **SkillsMate** 启动应用

#### 方法 2：如果遇到"已损坏"错误

如果打开应用时看到 **"SkillsMate 已损坏，无法打开"** 的提示，请按照以下步骤操作：

##### 选项 A：使用右键打开（最简单）

1. 在 Applications 文件夹中找到 SkillsMate
2. **按住 Control 键点击**（或右键点击）应用图标
3. 选择 **"打开"**
4. 在弹出的对话框中再次点击 **"打开"**
5. 之后可以正常双击打开

##### 选项 B：移除隔离属性（推荐）

打开 **终端**（Terminal.app），运行以下命令：

```bash
sudo xattr -rd com.apple.quarantine /Applications/SkillsMate.app
```

系统会要求输入你的 macOS 密码（输入时不会显示）。之后应用就可以正常打开了。

##### 选项 C：在系统设置中允许

1. 尝试打开应用（会显示错误）
2. 打开 **系统设置** > **隐私与安全性**
3. 滚动到底部，找到 "SkillsMate 已被阻止使用" 的提示
4. 点击 **"仍要打开"**

### 为什么会出现这个错误？

这是 macOS 的安全机制（Gatekeeper）。当前版本的 SkillsMate 还未经过 Apple 的公证流程，因此系统会显示警告。这不意味着应用有害，只是还未通过 Apple 的验证流程。

我们正在努力完成 Apple 公证，之后的版本将不会再有这个问题。

### 卸载

如需卸载 SkillsMate：

1. 打开 **Applications** 文件夹
2. 将 **SkillsMate** 拖动到废纸篓
3. 清空废纸篓

如需完全清理：

```bash
# 删除应用数据（可选）
rm -rf ~/Library/Application\ Support/SkillsMate
rm -rf ~/Library/Caches/com.yourcompany.SkillsMate
rm -rf ~/Library/Preferences/com.yourcompany.SkillsMate.plist
```

## 系统要求

- macOS 13.0 (Ventura) 或更高版本
- Apple Silicon (M1/M2/M3) 或 Intel 处理器

## 故障排除

### 应用无法启动

1. 确认你的 macOS 版本是 13.0 或更高
2. 尝试右键打开应用（按住 Control 点击）
3. 查看控制台日志：打开 **控制台.app**，搜索 "SkillsMate"

### 权限问题

如果应用需要访问某些文件或文件夹，系统会弹出权限请求对话框。请根据需要授予权限。

### 需要帮助？

如果遇到问题，请：
1. 查看 [Issues](https://github.com/yourusername/skills-mate/issues) 页面
2. 创建新的 Issue 描述你的问题
3. 包含你的 macOS 版本和错误信息

## 更新

当有新版本发布时：
1. 下载新的 `.dmg` 文件
2. 退出正在运行的 SkillsMate
3. 将新版本拖到 Applications 文件夹（覆盖旧版本）
4. 重新打开应用

你的数据和设置会被保留。
