# 🦞 XCRIMINAL

```
    ╔════════════════════════════════════════════════════════════════════════╗
    ║                                                                        ║
    ║      ██╗  ██╗ ██████╗██████╗ ██╗███╗   ███╗██╗███╗   ██╗ █████╗██╗     ║
    ║      ╚██╗██╔╝██╔════╝██╔══██╗██║████╗ ████║██║████╗  ██║██╔══██╗██║     ║
    ║       ╚███╔╝ ██║     ██████╔╝██║██╔████╔██║██║██╔██╗ ██║███████║██║     ║
    ║       ██╔██╗ ██║     ██╔══██╗██║██║╚██╔╝██║██║██║╚██╗██║██╔══██║██║     ║
    ║      ██╔╝ ██╗╚██████╗██║  ██║██║██║ ╚═╝ ██║██║██║ ╚████║██║  ██║███████╗║
    ║      ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝║
    ║                                                                        ║
    ║                    🤖 Personal AI Assistant Platform                  ║
    ║                     Multi-Channel, Open Source, Secure                ║
    ║                                                                        ║
    ╚════════════════════════════════════════════════════════════════════════╝
```

---

## 🚀 What is Xcriminal?

**Xcriminal** is a sophisticated, open-source personal AI assistant that:

- 🧠 **Runs Claude, GPT, or Gemini AI models** with automatic failover
- 💬 **Connects to 13+ messaging channels** (WhatsApp, Telegram, Slack, Discord, Signal, iMessage, etc.)
- 🔒 **100% Private & Secure** - runs locally, no data sent to third parties
- 📱 **Native Apps** - macOS, iOS, Android support with native UI
- 🌐 **Web Control Panel** - manage everything from a browser
- ⚡ **Real-time Agent** - tool calling, streaming responses, extended thinking
- 🔌 **Extensible** - plugin architecture for custom skills and channels
- 🛡️ **Security-first** - dependency scanning, backdoor detection, secret management

---

## ⚡ Quick Start (5 Minutes)

### Prerequisites
```bash
# Node.js 22+ required
node -v

# Install pnpm
npm install -g pnpm
```

### Setup
```bash
# 1. Install dependencies
pnpm install

# 2. Build project
pnpm build

# 3. Configure API keys
cp .env.example .env.local
# Edit .env.local: add ANTHROPIC_API_KEY and/or OPENAI_API_KEY

# 4. Start gateway
pnpm gateway:watch

# 5. Open web dashboard
# Visit: http://localhost:18789/apps/xcriminal
```

### Send First Message
```bash
pnpm moltbot agent --message "What's 2+2?"
```

---

## 🎯 Core Features

### Multi-Channel Messaging
```
WhatsApp  →  Telegram  →  Slack  →  Discord
    ↓          ↓           ↓          ↓
 Signal  →  iMessage  →  Gmail  →  Google Chat
    ↓          ↓           ↓          ↓
 Matrix  →   Mattermost  → Teams  →  Zalo
    ↓
Xcriminal AI Engine (Claude/GPT/Gemini)
```

### Intelligence Features
- 🧠 **Extended Thinking** - Deep reasoning for complex problems
- 💾 **Memory** - Persistent conversation history
- 🔧 **Tool Calling** - Execute commands, search web, run code
- 📄 **Document Analysis** - PDF, image, video understanding
- 🌍 **Web Search** - Real-time information lookup
- 🎨 **Multimodal** - Images, audio, video support

### Security & Privacy
```
✓ Local-first architecture (minimal cloud dependency)
✓ End-to-end encryption per channel
✓ No data persistence without explicit opt-in
✓ Dependency scanning (npm audit + Snyk)
✓ Backdoor detection (eval, child_process scanning)
✓ Secret management (.env.local isolation)
✓ TypeScript strict mode (type safety)
✓ 70% test coverage minimum
```

---

## 📦 Project Structure

```
xcriminal-bot/
├── src/                          # Source code
│   ├── cli/                      # Command-line interface
│   ├── commands/                 # CLI commands (send, onboard, etc.)
│   ├── channels/                 # Channel implementations
│   │   ├── telegram/             # Telegram adapter (grammY)
│   │   ├── slack/                # Slack adapter (Bolt)
│   │   ├── discord/              # Discord adapter (discord.js)
│   │   ├── signal/               # Signal adapter (libsignal)
│   │   ├── imessage/             # iMessage adapter (BlueBubbles)
│   │   └── ...                   # 8+ more channels
│   ├── providers/                # LLM providers
│   │   ├── anthropic/            # Claude API
│   │   ├── openai/               # GPT API
│   │   ├── google/               # Gemini API
│   │   └── fallback.ts           # Automatic failover
│   ├── gateway/                  # RPC gateway & web server
│   ├── media/                    # Image/video processing
│   ├── hooks/                    # Custom automation hooks
│   └── routing/                  # Message routing logic
├── ui/                           # Web Control Panel (Lit + Vite)
├── apps/                         # Native apps
│   ├── macos/                    # macOS Tauri + SwiftUI
│   ├── ios/                      # iOS SwiftUI
│   ├── android/                  # Android Kotlin
│   └── shared/                   # Shared app logic
├── extensions/                   # Plugin ecosystem
│   ├── msteams/                  # Microsoft Teams
│   ├── matrix/                   # Matrix protocol
│   ├── llm-task/                 # Custom LLM tasks
│   └── ...                       # 12+ extensions
├── docs/                         # Comprehensive documentation
├── test/                         # Integration tests
├── scripts/                      # Utility scripts
├── security-audit.sh             # Security verification
├── health-check.sh               # System health check
└── SETUP_AND_SECURITY.md         # Complete security guide
```

---

## 🔐 Security Verification

### Run Security Audit
```bash
# macOS/Linux
chmod +x security-audit.sh
./security-audit.sh

# Windows
security-audit.bat

# Expected checks:
# ✓ Node version (22+)
# ✓ Dependency vulnerabilities
# ✓ Hardcoded secrets
# ✓ Backdoor detection
# ✓ TypeScript compilation
# ✓ Test coverage
# ✓ Package integrity
```

### Vulnerability Scanning
```bash
# Check npm dependencies
npm audit

# Fix vulnerabilities
npm audit fix

# Advanced scanning (Snyk)
npm install -g snyk
snyk test
```

---

## 📚 Documentation

| Guide | Purpose |
|-------|---------|
| **[QUICKSTART.md](./QUICKSTART.md)** | 5-minute setup guide |
| **[SETUP_AND_SECURITY.md](./SETUP_AND_SECURITY.md)** | Complete setup + 12+ security tools |
| **[CONTRIBUTING.md](./CONTRIBUTING.md)** | How to contribute |
| **[SECURITY.md](./SECURITY.md)** | Security policy & disclosure |
| **[Docs Portal](https://docs.molt.bot)** | Full API documentation |

---

## 🛠️ Development

### Build & Test
```bash
# Install dependencies
pnpm install

# Type check
pnpm build

# Run linter
pnpm lint

# Format code
pnpm format

# Run tests
pnpm test              # Unit tests
pnpm test:coverage     # With coverage report
pnpm test:docker       # In Docker container
```

### Run Services
```bash
# Start gateway with hot reload
pnpm gateway:watch

# Start web UI dev server
pnpm ui:dev

# Run CLI in dev mode
pnpm dev

# Run interactive onboarding
pnpm moltbot onboard
```

---

## 🌟 Key Technologies

```
┌─────────────────────────────────────────────────────┐
│ Frontend                                            │
├──────────────────────────────────────────────────────┤
│ • Lit Element (Web Components)                      │
│ • Vite (Fast bundler)                              │
│ • TypeScript (Type safe)                           │
│ • CSS Grid (Responsive UI)                         │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ Backend                                             │
├──────────────────────────────────────────────────────┤
│ • Node.js 22+ (ESM)                                │
│ • TypeScript (Strict mode)                         │
│ • Hono (Lightweight web framework)                 │
│ • Anthropic SDK (Claude)                           │
│ • OpenAI SDK (GPT)                                 │
│ • Multiple messaging SDKs                          │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ Native                                              │
├──────────────────────────────────────────────────────┤
│ • macOS: Tauri + SwiftUI                          │
│ • iOS: SwiftUI                                     │
│ • Android: Kotlin                                  │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│ Testing & Quality                                   │
├──────────────────────────────────────────────────────┤
│ • Vitest (Fast test runner)                        │
│ • V8 Coverage (70% threshold)                      │
│ • Oxlint (Fast linter)                            │
│ • TypeScript strict mode                           │
│ • npm audit (Vulnerability scanning)               │
└─────────────────────────────────────────────────────┘
```

---

## 💬 Supported Channels

### Core Channels
| Channel | Status | Technology |
|---------|--------|-----------|
| WhatsApp | ✅ | Baileys (Web) |
| Telegram | ✅ | grammY |
| Slack | ✅ | Bolt |
| Discord | ✅ | discord.js |
| Signal | ✅ | libsignal |
| iMessage | ✅ | BlueBubbles |
| Web | ✅ | HTTP/WebSocket |
| Gmail | ✅ | Google API |
| Google Chat | ✅ | Google API |

### Extensions (Plugins)
| Extension | Status |
|-----------|--------|
| Microsoft Teams | ✅ |
| Matrix | ✅ |
| Mattermost | ✅ |
| Zalo | ✅ |
| Nostr | ✅ |
| Twitch | ✅ |
| Nextcloud Talk | ✅ |
| Voice Call | ✅ |
| Line | ✅ |

---

## 🚀 Performance

```
Gateway Startup:    ~2 seconds
First Message:      ~1-3 seconds (network dependent)
AI Response:        Streaming in real-time
Message Routing:    <100ms per message
Memory Usage:       ~150MB base + 50MB per channel
```

---

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](./CONTRIBUTING.md) for:
- Code style guide
- Testing requirements
- PR process
- Commit message format

### Quick Contributions
```bash
# 1. Fork the repo
git clone https://github.com/your-fork/xcriminal-bot.git

# 2. Create feature branch
git checkout -b feature/amazing-feature

# 3. Make changes & commit
pnpm lint && pnpm build && pnpm test
git commit -m "feat: add amazing feature"

# 4. Push and create PR
git push origin feature/amazing-feature
```

---

## 📄 License

MIT License - See [LICENSE](./LICENSE) for details

Free to use for personal and commercial projects.

---

## 🔗 Links

- 📖 **Documentation**: https://docs.molt.bot
- 🐛 **Issues**: https://github.com/moltbot/moltbot/issues
- 💬 **Discussions**: https://github.com/moltbot/moltbot/discussions
- 🐦 **Twitter**: [@clawd_bot](https://twitter.com/clawd_bot)
- 🎓 **Discord Community**: [Join](https://discord.gg/clawd)

---

## ⚡ Command Cheat Sheet

```bash
# Setup & Installation
pnpm install                    # Install all dependencies
pnpm build                      # Compile TypeScript
pnpm lint                       # Check code quality
pnpm format                     # Auto-format code

# Development
pnpm gateway:watch              # Start gateway (dev mode)
pnpm ui:dev                     # Start web UI dev server
pnpm dev                        # Run CLI in dev mode

# Testing & Quality
pnpm test                       # Run all tests
pnpm test:coverage              # Test with coverage report
npm audit                       # Check vulnerabilities
npm audit fix                   # Auto-fix vulnerabilities

# Verification & Security
./security-audit.sh             # Full security audit
./health-check.sh               # System health check
pnpm moltbot onboard           # Interactive setup

# Messaging
pnpm moltbot agent --message "Hi"                  # Talk to bot
pnpm moltbot message send --to +1234567890 --text "Hello"  # Send message
pnpm moltbot channels status                       # Check channels

# Debugging
pnpm moltbot doctor             # Diagnose issues
pnpm moltbot config show        # View configuration
moltbot logs --follow           # View live logs
```

---

## 🎯 Roadmap

```
✅ Multi-channel messaging
✅ Extended thinking (Claude)
✅ Tool calling & automation
✅ Web control panel
✅ Security hardening

🔄 In Progress
  • Mobile app enhancements
  • Voice assistant
  • Real-time collaboration

📋 Planned
  • Custom model fine-tuning
  • Advanced memory features
  • Enterprise audit logging
```

---

## 💡 Tips & Tricks

### Performance Tuning
```bash
# Increase worker threads for faster builds
export UV_THREADPOOL_SIZE=32
pnpm build

# Use Bun for faster execution
bunx <tool>
bun run build
```

### Debug Mode
```bash
# Verbose logging
DEBUG=xcriminal:* pnpm gateway:watch

# Trace network calls
pnpm moltbot message send --debug
```

### Security Best Practices
```bash
# Rotate API keys regularly
rm .env.local && cp .env.example .env.local
# Edit with new keys

# Audit dependencies monthly
npm audit > audit-$(date +%Y-%m-%d).json

# Check for secret leaks
git log -p | grep -i "api_key\|password\|token"
```

---

## 🆘 Troubleshooting

### "Port 18789 already in use"
```bash
# Kill existing process
lsof -i :18789 | grep -v PID | awk '{print $2}' | xargs kill -9

# Or use different port
pnpm moltbot gateway --port 18790
```

### "npm audit shows vulnerabilities"
```bash
npm audit fix
npm audit fix --force  # If above doesn't work
pnpm build && pnpm test
```

### "Build fails"
```bash
rm -rf dist node_modules
pnpm install
pnpm build --verbose
```

See [QUICKSTART.md](./QUICKSTART.md) for more solutions.

---

```
    ╔════════════════════════════════════════════════════════════════════════╗
    ║                                                                        ║
    ║  Built with ❤️  for privacy-conscious developers everywhere           ║
    ║                                                                        ║
    ║              Ready to take control of your AI assistant?              ║
    ║                                                                        ║
    ║                   🚀 Get started in 5 minutes 🚀                      ║
    ║                                                                        ║
    ║              See QUICKSTART.md for immediate setup guide               ║
    ║                                                                        ║
    ╚════════════════════════════════════════════════════════════════════════╝
```

---

**Built for developers who value privacy, security, and control.**
