# Contributing to Phantom Terminal

Thank you for your interest in contributing! 🎉

## 🐛 Bug Reports

1. Check [existing issues](https://github.com/Unknown-2829/Phanton-terminal/issues) first
2. Create a new issue with:
   - Windows & PowerShell version
   - Terminal (Windows Terminal, ConHost, etc.)
   - Steps to reproduce
   - Expected vs actual behavior

## 💡 Feature Requests

Open an issue with `[Feature]` in the title and describe:
- What you want
- Why it's useful
- How it might work

## 🔧 Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes to `PhantomStartup.ps1`
4. Test thoroughly
5. Commit: `git commit -m "Add: my feature"`
6. Push: `git push origin feature/my-feature`
7. Open a Pull Request

## 📝 Code Style

- Use 4-space indentation
- Comment complex logic
- Follow existing naming conventions (`Show-*`, `Get-*`, etc.)
- Keep functions focused and small

## 🧪 Testing

Before submitting:
```powershell
# Test fresh install
. .\PhantomStartup.ps1

# Test commands
phantom-reload
phantom-config
phantom-matrix
```

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.
