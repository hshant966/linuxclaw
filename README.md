<![CDATA[<div align="center">

```
 ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗ ██████╗██╗      █████╗ ██╗    ██╗
 ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝██╔════╝██║     ██╔══██╗██║    ██║
 ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ ██║     ██║     ███████║██║ █╗ ██║
 ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ ██║     ██║     ██╔══██║██║███╗██║
 ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗╚██████╗███████╗██║  ██║╚███╔███╔╝
 ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝
```

### 🐧 The fastest self-hosted AI agent for Linux — built on ZeroClaw

[![Build](https://img.shields.io/badge/Build-Passing-brightgreen?style=for-the-badge&logo=github-actions&logoColor=white)](https://github.com/hshant966/linuxclaw/actions)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge&logo=opensourceinitiative&logoColor=white)](LICENSE)
[![Rust](https://img.shields.io/badge/Rust-1.75+-orange?style=for-the-badge&logo=rust&logoColor=white)](https://www.rust-lang.org/)
[![Platform](https://img.shields.io/badge/Platform-Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://kernel.org/)
[![Telegram](https://img.shields.io/badge/Telegram-Bot_Support-26A5E4?style=for-the-badge&logo=telegram&logoColor=white)](https://core.telegram.org/bots)
[![Gemini](https://img.shields.io/badge/Gemini-CLI_OAuth-8E75B2?style=for-the-badge&logo=google&logoColor=white)](https://ai.google.dev/)

<br>

**LinuxClaw** is a high-performance, self-hosted AI agent runtime purpose-built for Linux.  
It connects to your favorite LLM providers, runs tools, manages memory, and integrates with  
Telegram, Discord, Slack, Matrix, and more — all from a single Rust binary.

[Getting Started](#-quick-start) •
[Features](#-features) •
[Install](#-installation) •
[Architecture](#-architecture) •
[Contributing](#-contributing)

<br>

---

</div>

## ⚡ Why LinuxClaw?

<table>
<thead>
<tr>
<th align="left">Feature</th>
<th align="center">LinuxClaw 🐧</th>
<th align="center">OpenClaw</th>
<th align="center">ZeroClaw</th>
</tr>
</thead>
<tbody>
<tr><td><b>Default Provider</b></td><td align="center">✅ Gemini CLI OAuth</td><td align="center">OpenRouter</td><td align="center">OpenRouter</td></tr>
<tr><td><b>Open Skills</b></td><td align="center">✅ Enabled by default</td><td align="center">Opt-in</td><td align="center">Opt-in</td></tr>
<tr><td><b>Systemd Service</b></td><td align="center">✅ Included</td><td align="center">❌</td><td align="center">❌</td></tr>
<tr><td><b>Platform Focus</b></td><td align="center">🐧 Linux-first</td><td align="center">Cross-platform</td><td align="center">Cross-platform</td></tr>
<tr><td><b>Binary Size</b></td><td align="center">✅ Optimized</td><td align="center">Standard</td><td align="center">Standard</td></tr>
<tr><td><b>Memory Backends</b></td><td align="center">SQLite + Markdown</td><td align="center">SQLite + Markdown</td><td align="center">SQLite + Markdown</td></tr>
<tr><td><b>Channels</b></td><td align="center">Telegram, Discord, Slack, Matrix, Nostr, Email, IRC</td><td align="center">Same</td><td align="center">Same</td></tr>
<tr><td><b>Hardware Peripherals</b></td><td align="center">STM32, RPi GPIO</td><td align="center">STM32, RPi GPIO</td><td align="center">STM32, RPi GPIO</td></tr>
<tr><td><b>Tool System</b></td><td align="center">Shell, File, Browser, WASM, Memory</td><td align="center">Same</td><td align="center">Same</td></tr>
<tr><td><b>Security</b></td><td align="center">Landlock + seccomp + Deny-by-default</td><td align="center">Same</td><td align="center">Same</td></tr>
<tr><td><b>License</b></td><td align="center">MIT</td><td align="center">MIT</td><td align="center">MIT</td></tr>
</tbody>
</table>

## 📦 Installation

### One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/hshant966/linuxclaw/main/install.sh | bash
```

### Build from Source

```bash
git clone https://github.com/hshant966/linuxclaw.git
cd linuxclaw
cargo build --release
sudo cp target/release/linuxclaw /usr/local/bin/
```

## 🚀 Quick Start

**1. Install LinuxClaw**
```bash
curl -fsSL https://raw.githubusercontent.com/hshant966/linuxclaw/main/install.sh | bash
```

**2. Initialize configuration**
```bash
linuxclaw init
```

**3. Set your API key** (Gemini is the default provider)
```bash
export GEMINI_API_KEY="your-api-key-here"
# Or use Gemini CLI OAuth for keyless auth:
linuxclaw auth gemini
```

**4. Start chatting**
```bash
linuxclaw chat
```

**5. (Optional) Run as a daemon with systemd**
```bash
sudo cp contrib/systemd/linuxclaw.service /etc/systemd/system/
sudo systemctl enable --now linuxclaw
```

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    LinuxClaw Runtime                     │
├──────────┬──────────┬──────────┬──────────┬─────────────┤
│ Providers│ Channels │  Tools   │  Memory  │  Security   │
│──────────│──────────│──────────│──────────│─────────────│
│ Gemini   │ Telegram │ Shell    │ SQLite   │ Landlock    │
│ OpenAI   │ Discord  │ File     │ Markdown │ Seccomp     │
│ Anthropic│ Slack    │ Browser  │ Vector   │ Deny-by-    │
│ Ollama   │ Matrix   │ Memory   │ Embed    │  default    │
│ Groq     │ Nostr    │ WASM     │          │ Pairing     │
│ Cursor   │ Email    │ Process  │          │ Secrets     │
│ Custom   │ IRC      │ Schedule │          │ Policy      │
└──────────┴──────────┴──────────┴──────────┴─────────────┘
```

## 📸 Screenshots

<div align="center">

> 🚧 **Screenshots coming soon!** LinuxClaw is actively being developed.  
> Star the repo to get notified when the first screenshots drop.

</div>

## 🤝 Contributing

We welcome contributions of all kinds! Whether it's bug reports, feature requests, docs improvements, or code contributions.

```bash
# Fork, clone, and create a branch
git checkout -b feat/my-awesome-feature

# Make your changes and run tests
cargo test
cargo clippy --all-targets -- -D warnings

# Commit and open a PR
git commit -m "feat: my awesome feature"
git push origin feat/my-awesome-feature
```

See the full [contributing guide](docs/contributing/README.md) for more details.

## ⭐ Star Us

If LinuxClaw is useful to you, **please star this repo** — it helps others discover the project and motivates continued development.

<div align="center">

[![Star History Chart](https://api.star-history.com/svg?repos=hshant966/linuxclaw&type=Date)](https://star-history.com/#hshant966/linuxclaw&Date)

</div>

## 📄 License

LinuxClaw is licensed under the [MIT License](LICENSE).

Built with 🦀 Rust and ❤️ for Linux.

---

<div align="center">
<sub>LinuxClaw is a fork of <a href="https://github.com/ZeroClaw">ZeroClaw</a> — optimized for Linux-native deployments.</sub>
</div>
]]>
