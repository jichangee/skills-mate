# 代码签名和公证配置指南

## 问题说明

如果安装 DMG 时出现 **"SkillsMate"已损坏，无法打开。你应该推出磁盘映像"** 的错误，这是因为应用没有经过 Apple 的代码签名和公证。

## 解决方案

### 方案 1：配置代码签名（推荐 - 用于正式发布）

#### 前置条件

1. 拥有 Apple Developer 账号（$99/年）
2. 在 Keychain Access 中创建证书签名请求（CSR）
3. 在 Apple Developer 网站创建 **Developer ID Application** 证书

#### 配置步骤

##### 1. 导出证书

```bash
# 在 macOS 上，打开 Keychain Access
# 找到你的 "Developer ID Application" 证书
# 右键 -> 导出 -> 保存为 .p12 文件，设置密码

# 将 .p12 文件转换为 base64
base64 -i Certificates.p12 | pbcopy
```

##### 2. 创建 App-Specific Password

1. 访问 [appleid.apple.com](https://appleid.apple.com)
2. 登录你的 Apple ID
3. 在 "Sign-In and Security" -> "App-Specific Passwords"
4. 生成新密码（用于公证）

##### 3. 在 GitHub 配置 Secrets

在你的 GitHub 仓库中，进入 **Settings** -> **Secrets and variables** -> **Actions**，添加以下 secrets：

| Secret 名称 | 说明 | 获取方式 |
|------------|------|---------|
| `MACOS_CERTIFICATE` | 证书的 base64 编码 | 步骤 1 中复制的内容 |
| `MACOS_CERTIFICATE_PWD` | 证书的密码 | 导出 .p12 时设置的密码 |
| `MACOS_SIGNING_IDENTITY` | 签名身份 | 通常是 "Developer ID Application: Your Name (TEAM_ID)" |
| `MACOS_TEAM_ID` | Team ID | 在 Apple Developer 网站的 Membership 页面查看 |
| `MACOS_NOTARIZATION_APPLE_ID` | Apple ID 邮箱 | 你的 Apple Developer 账号邮箱 |
| `MACOS_NOTARIZATION_PWD` | App-Specific Password | 步骤 2 中生成的密码 |

##### 4. 查找签名身份

```bash
# 在本地 macOS 上运行，查看可用的签名身份
security find-identity -v -p codesigning

# 输出示例：
# 1) XXXXXX "Developer ID Application: Your Name (TEAM123)"
```

##### 5. 推送新 tag 触发发布

```bash
git tag v1.0.1
git push origin v1.0.1
```

现在 GitHub Actions 会自动：
1. 构建应用
2. 签名应用
3. 公证应用（发送到 Apple 验证）
4. 装订公证票据
5. 创建并签名 DMG
6. 公证 DMG
7. 发布到 GitHub Release

---

### 方案 2：临时解决方案（用于测试/开发）

如果暂时没有 Apple Developer 账号，用户可以在安装后手动移除隔离标记：

#### 用户安装步骤

1. 下载并挂载 DMG
2. 将 SkillsMate.app 拖到 Applications 文件夹
3. **不要直接打开**，先打开终端运行：

```bash
# 移除隔离属性
sudo xattr -rd com.apple.quarantine /Applications/SkillsMate.app

# 或者如果应用在其他位置
sudo xattr -rd com.apple.quarantine /path/to/SkillsMate.app
```

4. 现在可以正常打开应用了

#### 在 README 中添加说明

在项目的 README.md 中添加：

```markdown
## 安装说明

### macOS 安全提示

由于此应用目前未经过 Apple 公证，首次安装时需要执行以下步骤：

1. 下载 DMG 文件
2. 打开 DMG，将 SkillsMate 拖到 Applications
3. 打开终端，运行以下命令：
   ```bash
   sudo xattr -rd com.apple.quarantine /Applications/SkillsMate.app
   ```
4. 输入你的 macOS 密码
5. 现在可以从 Applications 文件夹打开 SkillsMate

或者，你也可以：
1. 右键点击 SkillsMate.app
2. 选择 "打开"
3. 在弹出的对话框中点击 "打开"
```

---

## 验证签名

安装后可以验证应用是否已正确签名：

```bash
# 检查签名
codesign -dvv /Applications/SkillsMate.app

# 检查公证状态
spctl -a -vv /Applications/SkillsMate.app

# 检查是否有隔离属性
xattr -l /Applications/SkillsMate.app
```

## 常见问题

### Q: 公证失败怎么办？

A: 检查以下几点：
- App-Specific Password 是否正确
- Team ID 是否正确
- 应用是否有 Hardened Runtime 设置
- 是否有敏感权限需要在 entitlements 中声明

### Q: 签名后仍然提示损坏？

A: 可能原因：
- 公证未完成或失败
- 票据未装订成功
- 用户下载后文件损坏
- 检查签名：`codesign -dvv your-app.app`

### Q: 需要多久完成公证？

A: 通常 5-10 分钟，最长可能需要 30 分钟

## 参考资料

- [Apple: Notarizing macOS Software](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)
- [Apple: Code Signing Guide](https://developer.apple.com/library/archive/documentation/Security/Conceptual/CodeSigningGuide/Introduction/Introduction.html)
- [GitHub Actions: Import Codesign Certs](https://github.com/apple-actions/import-codesign-certs)
