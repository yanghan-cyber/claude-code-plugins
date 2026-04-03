# claude-code-plugins

Claude Code 插件市场 - 提供各种实用的 Claude Code 插件来增强你的开发体验。

## 插件列表

### auto-mode

Hook-based 自动执行模式插件。在 `acceptEdits` 权限模式下自动批准工具调用，带有危险命令保护和日志记录功能。

- **功能**: 自动批准工具调用、危险命令拦截、双级别开关控制
- **安装**: `/plugin install auto-mode@cc-plugins`

## 添加市场

```bash
/plugin marketplace add yanghan-cyber/cc-plugins
```

## 安装插件

```bash
/plugin install <plugin-name>@cc-plugins
```

## 贡献插件

欢迎提交 PR 添加新插件！插件需放在 `plugins/` 目录下，每个插件需包含 `.claude-plugin/plugin.json` 配置文件。

## 许可证

MIT