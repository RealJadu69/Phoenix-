#!/usr/bin/env python3
import json, os, sys, subprocess, shutil, pathlib

HOME = sys.argv[1] if len(sys.argv) > 1 else os.path.expanduser("~/.phoenix")
ROOT = pathlib.Path(HOME).parent if "phoenix" in str(pathlib.Path.cwd()) else pathlib.Path.cwd()
ASSETS = ROOT / "assets"
RES = ROOT / "resources"

MENU_FILE = ASSETS / "Menu.json"
BANNER_FILE = ASSETS / "Banner.txt"

def clear():
    os.system("clear")

def print_banner():
    if BANNER_FILE.exists():
        print(BANNER_FILE.read_text())
    else:
        print("PHOENIX")

def load_menu():
    try:
        j = json.loads(MENU_FILE.read_text())
        return j.get("main_menu", [])
    except Exception:
        return []

def run_shell(script_path):
    script = str(script_path)
    if not os.path.exists(script):
        print(f"Script not found: {script}")
        return
    subprocess.call(["bash", "-lc", script])

def show_menu(menu):
    for line in menu:
        print(line)

def choice_map():
    return {
        "1": RES / "BaseTools.sh",
        "2": RES / "BaseTools.sh",  # 'Install essentials' same as base
        "3": RES / "groups" / "DevTools.sh",
        "4": RES / "groups" / "MathTools.sh",
        "5": RES / "groups" / "NetworkTools.sh",
        "6": RES / "groups" / "VisualTools.sh",
        "7": RES / "ProotInstaller.sh",
        "8": RES / "LinuxDroidInstaller.sh",
        "9": RES / "SystemHardener.sh",
        "10": None,  # Dry-run / Modules list
        "11": "exit"
    }

def list_modules():
    ml = ASSETS / "Modules.list"
    if ml.exists():
        print(ml.read_text())
    else:
        print("Modules list not found.")

def main():
    clear()
    print_banner()
    menu = load_menu()
    while True:
        show_menu(menu)
        ch = input("\nSelect option: ").strip()
        mapping = choice_map()
        target = mapping.get(ch)
        if ch == "10":
            list_modules()
            input("Press Enter to continue...")
            clear()
            continue
        if target == "exit":
            print("Goodbye.")
            break
        if target is None:
            print("Invalid choice or not implemented.")
            input("Press Enter to continue...")
            clear()
            continue
        run_shell(str(target))
        input("\nPress Enter to return to menu...")
        clear()
        print_banner()

if __name__ == "__main__":
    main()
