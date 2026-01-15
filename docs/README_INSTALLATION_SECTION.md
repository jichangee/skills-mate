# 这个文件包含可以添加到主 README.md 的安装部分

## 📥 安装

### macOS

#### 下载

从 [Releases](../../releases/latest) 页面下载最新的 `.dmg` 文件。

#### 安装步骤

1. 打开下载的 DMG 文件
2. 将 SkillsMate 拖到 Applications 文件夹
3. **重要**：首次打开前，需要移除 macOS 的隔离属性

打开终端，运行以下命令：

```bash
sudo xattr -rd com.apple.quarantine /Applications/SkillsMate.app
```

系统会要求输入密码（输入时不显示），输入后按回车。

现在可以从 Applications 文件夹或 Launchpad 打开 SkillsMate 了！

<details>
<summary>🤔 为什么需要这个步骤？</summary>

这是因为应用尚未经过 Apple 的公证流程。macOS 的 Gatekeeper 安全机制会阻止运行未经公证的应用。

这个命令只是移除了下载文件的隔离标记，**不会**降低系统安全性。应用本身是安全的，只是还没有通过 Apple 的验证流程。

我们正在申请 Apple Developer 账号以完成应用公证，未来版本将无需这个步骤。
</details>

<details>
<summary>替代方法：使用右键打开</summary>

如果你不想使用命令行，也可以：

1. 在 Applications 文件夹中找到 SkillsMate
2. 按住 **Control** 键点击（或右键点击）应用图标
3. 选择 **"打开"**
4. 在弹出的对话框中再次点击 **"打开"**

之后就可以正常双击打开了。
</details>

#### 系统要求

- macOS 13.0 (Ventura) 或更高版本
- Apple Silicon (M1/M2/M3) 或 Intel 处理器

#### 故障排除

如果遇到问题，请查看[详细安装指南](./docs/INSTALLATION.md)或[创建 Issue](../../issues/new)。

---

## 🔄 更新

当有新版本发布时：

1. 下载新的 DMG 文件
2. 退出正在运行的 SkillsMate
3. 将新版本拖到 Applications（覆盖旧版本）
4. 运行 `xattr` 命令（如果需要）
5. 重新打开应用

你的数据和设置会自动保留。

---

## 🗑️ 卸载

将 Applications 文件夹中的 SkillsMate 拖到废纸篓即可。

如需完全清理应用数据：

```bash
rm -rf ~/Library/Application\ Support/SkillsMate
rm -rf ~/Library/Caches/com.yourcompany.SkillsMate
```
