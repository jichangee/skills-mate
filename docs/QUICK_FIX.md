# 🚀 快速修复："已损坏"错误

## 问题

安装 SkillsMate 时出现：**"SkillsMate 已损坏，无法打开。你应该推出磁盘映像"**

## 🎯 立即解决（用户端）

### 最快方法：一行命令

```bash
sudo xattr -rd com.apple.quarantine /Applications/SkillsMate.app
```

输入密码后即可正常打开应用。

### 为什么出现这个错误？

- macOS Gatekeeper 安全机制
- 应用未经过 Apple 代码签名和公证
- 这**不是**病毒或恶意软件问题

---

## 🔧 永久解决（开发者端）

### 立即可用的方案

在你的 GitHub Release 说明中添加用户安装步骤：

```markdown
## ⚠️ 安装前必读

由于应用尚未公证，首次安装请运行：

​```bash
sudo xattr -rd com.apple.quarantine /Applications/SkillsMate.app
​```

或右键点击应用 -> 选择"打开" -> 再次点击"打开"
```

### 长期方案：配置代码签名

#### 需要准备（一次性）

1. **Apple Developer 账号**（$99/年）
2. **创建证书**：
   - 打开 Keychain Access
   - Certificate Assistant -> Request a Certificate
   - 在 [developer.apple.com](https://developer.apple.com) 创建 "Developer ID Application" 证书
   - 下载并导入到 Keychain

3. **导出证书**：
```bash
# 从 Keychain 导出证书为 .p12
# 然后转换为 base64
base64 -i Certificates.p12 | pbcopy
```

4. **生成 App-Specific Password**：
   - 访问 [appleid.apple.com](https://appleid.apple.com)
   - Security -> App-Specific Passwords
   - Generate Password

#### 配置 GitHub Secrets

在 GitHub 仓库的 Settings -> Secrets and variables -> Actions 中添加：

| Secret | 值 |
|--------|---|
| `MACOS_CERTIFICATE` | 证书的 base64（从步骤 3） |
| `MACOS_CERTIFICATE_PWD` | 导出 .p12 时设置的密码 |
| `MACOS_SIGNING_IDENTITY` | 如："Developer ID Application: Your Name (XXXXX)" |
| `MACOS_TEAM_ID` | 在 developer.apple.com 的 Membership 页面查看 |
| `MACOS_NOTARIZATION_APPLE_ID` | 你的 Apple ID 邮箱 |
| `MACOS_NOTARIZATION_PWD` | App-Specific Password（步骤 4） |

#### 查找签名身份

```bash
security find-identity -v -p codesigning
```

#### 完成！

配置完成后，推送新 tag 即可自动签名和公证：

```bash
git tag v1.0.1
git push origin v1.0.1
```

---

## 📋 检查清单

### 开发者

- [ ] 已更新 GitHub Actions 工作流（已完成 ✅）
- [ ] 配置了 GitHub Secrets（如有 Apple Developer 账号）
- [ ] 在 Release 说明中添加了安装步骤
- [ ] 更新了 README.md 的安装部分

### 用户

- [ ] 下载了 DMG 文件
- [ ] 将应用拖到 Applications
- [ ] 运行了 `xattr` 命令或右键打开
- [ ] 成功启动应用

---

## 🆘 还是不行？

### 检查步骤

1. **确认命令路径正确**：
```bash
# 确认应用位置
ls -la /Applications/SkillsMate.app
```

2. **检查是否有隔离属性**：
```bash
xattr -l /Applications/SkillsMate.app
# 如果看到 com.apple.quarantine，说明还需要移除
```

3. **尝试更强力的方法**：
```bash
sudo spctl --master-disable  # 临时禁用 Gatekeeper（不推荐）
# 打开应用后再启用：
sudo spctl --master-enable
```

### 开发者检查

1. **验证签名**：
```bash
codesign -dvvv /path/to/SkillsMate.app
```

2. **检查公证状态**：
```bash
spctl -a -vv /path/to/SkillsMate.app
```

3. **查看构建日志**：
   - GitHub Actions 中查看 "Build app" 和 "Notarize" 步骤
   - 确认没有错误

---

## 📚 相关文档

- [详细配置指南](./CODE_SIGNING.md) - 完整的代码签名配置步骤
- [安装说明](./INSTALLATION.md) - 用户安装指南
- [Release 模板](../.github/RELEASE_TEMPLATE.md) - 发布时使用的模板

## 🎓 了解更多

- [Apple: 公证 macOS 软件](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)
- [关于 Gatekeeper](https://support.apple.com/en-us/HT202491)
