# 🐦 Phoenix
**The ultimate modular Termux environment builder.**  
Phoenix automates setup, optimization, and package installation with speed, safety, and style.  
From essentials to dev tools and proot systems — build your perfect Termux in minutes, not hours.

---

## ⚙️ Features
- 🔥 Fully modular structure — add or remove tool groups anytime.  
- ⚡ Parallel downloads and installations for speed.  
- 🧠 Smart dependency checks — installs only what’s missing.  
- 🛡️ Automatic safety hardening and storage permission setup.  
- 🐍 Bash + Python hybrid core for flexibility and performance.  
- 🌍 Multi-language ready — easy to expand or localize.  

---

## 📲 Installation

**Requirements:**  
- Termux (latest version)  
- Internet connection  
- Git installed (`pkg install git -y`)

Then run the following:

```bash
pkg update -y && pkg upgrade -y
pkg install git python -y
git clone https://github.com/RealJadu69/Phoenix
cd phoenix
bash setup.sh
