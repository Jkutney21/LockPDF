# 🔐 PDF Locker

> **Secure your PDFs with just a right-click!**

A sleek Windows context menu tool that instantly password-protects your PDF files. No complex software needed - just right-click and lock.

---

## ✨ Features

- 🖱️ **One-click protection** - Right-click any PDF to lock it
- 🔑 **Auto-generated passwords** - Creates secure passwords automatically
- ⚡ **Lightning fast** - Encrypts PDFs in seconds
- 🎯 **Zero configuration** - Works immediately after install
- 🧹 **Clean uninstall** - Removes completely when not needed

---

## 📽️ See It In Action

[![PDF Locker Demo](https://img.shields.io/badge/▶️-Watch%20Demo-red?style=for-the-badge)](example.mp4)

*Click above to see how easy it is to protect your PDFs!*

---

## 🚀 Installation Guide

### Prerequisites
- **Windows 10/11** (required for context menu integration)
- **Administrator privileges** (needed for registry modifications)

### Method 1: Git Clone (Recommended)
```bash
# Clone the repository
git clone https://github.com/jkutn/lockpdf.git
cd lockpdf

# Run the installer as Administrator
install.bat
```

### Method 2: Download ZIP
1. 📥 [Download the latest release](https://github.com/jkutn/lockpdf/releases)
2. 📂 Extract to any folder (e.g., `C:\Tools\lockpdf\`)
3. 🖱️ Right-click `install.bat` → **"Run as administrator"**
4. ✅ Follow the installation prompts

### What happens during installation:
- 🐍 **Python detection/installation** - Automatically installs Python if missing
- 📦 **Dependency installation** - Downloads required packages (`pypdf`)
- 🖱️ **Context menu registration** - Adds right-click option to PDF files
- 🔧 **Registry setup** - Configures Windows shell integration

### Verification
After installation, test by:
1. Right-clicking any `.pdf` file
2. Look for **"Lock PDF with Password"** in the context menu
3. If you see it, installation was successful! 🎉

---

## 🎯 Quick Usage
1. 📄 Right-click any `.pdf` file
2. 🔒 Select `Lock PDF with Password`
3. ✅ Your PDF is now encrypted!

*Dependencies (Python, pypdf) install automatically if needed.*

---

## 🗑️ Uninstall

```bash
# Remove context menu entry
uninstall.bat
```

---

## ⚠️ Security Notice

**Important:** PDF password protection provides basic security against casual access. For highly sensitive documents, consider additional encryption methods. This tool is designed for convenience, not military-grade security.

---

## 🛠️ Technical Details

- **Engine:** PyPDF2 encryption
- **Platform:** Windows (context menu integration)
- **Requirements:** Python 3.6+
- **Dependencies:** pypdf, tkinter (GUI dialogs)

---

## 📜 License

MIT License - Feel free to use, modify, and distribute.

---

<div align="center">

**Made with ❤️ for secure PDF handling**

[![Stars](https://img.shields.io/github/stars/jkutn/lockpdf?style=social)](https://github.com/jkutn/lockpdf)
[![Issues](https://img.shields.io/github/issues/jkutn/lockpdf)](https://github.com/jkutn/lockpdf/issues)

</div>
