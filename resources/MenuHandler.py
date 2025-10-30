#!/usr/bin/env python3
import json, os, sys, subprocess, pathlib
from concurrent.futures import ThreadPoolExecutor, as_completed

# --- Paths ---
ROOT = pathlib.Path.cwd()
ASSETS = ROOT / "assets"
RES = ROOT / "resources"
MODULES_LIST = ASSETS / "Modules.list"
MENU_FILE = ASSETS / "Menu.json"
BANNER_FILE = ASSETS / "Banner.txt"

# --- Utilities ---
def clear():
    os.system("clear")

def print_banner():
    if BANNER_FILE.exists():
        print(BANNER_FILE.read_text())
    else:
        print("=== PHOENIX ===")

def load_menu():
    if MENU_FILE.exists():
        try:
            j = json.loads(MENU_FILE.read_text())
            return j.get("main_menu", [])
        except Exception:
            print("[PHOENIX] Failed to load menu JSON.")
            return []
    return []

def run_script(script_path):
    script = pathlib.Path(script_path)
    if not script.exists():
        print(f"[PHOENIX] Script not found: {script}")
        return
    print(f"[PHOENIX] Running {script.name} ...")
    subprocess.call(["bash", "-lc", str(script)])
    print(f"[PHOENIX] Finished {script.name}")

def run_scripts_parallel(scripts):
    """Run a list of scripts in parallel threads."""
    with ThreadPoolExecutor(max_workers=min(4, len(scripts))) as executor:
        futures = {executor.submit(run_script, s): s for s in scripts}
        for future in as_completed(futures):
            pass  # results are already printed in run_script

def show_menu(menu):
    for line in menu:
        print(line)

def list_modules():
    if MODULES_LIST.exists():
        print(MODULES_LIST.read_text())
    else:
        print("[PHOENIX] Modules list not found.")

# --- Menu choice mapping ---
def choice_map():
    return {
        "1": [RES / "BaseTools.sh"],
        "2": [RES / "BaseTools.sh"],  # essentials
        "3": [RES / "groups" / "DevTools.sh"],
        "4": [RES / "groups" / "MathTools.sh"],
        "5": [RES / "groups" / "NetworkTools.sh"],
        "6": [RES / "groups" / "VisualTools.sh"],
        "7": [RES / "ProotInstaller.sh"],
        "8": [RES / "LinuxDroidInstaller.sh"],
        "9": [RES / "SystemHardener.sh"],
        "10": "modules_list",
        "11": "exit"
    }

# --- Main ---
def main():
    clear()
    print_banner()
    menu = load_menu()
    if not menu:
        print("[PHOENIX] No menu found. Check assets/Menu.json")
        return

    while True:
        show_menu(menu)
        ch = input("\nSelect option: ").strip()
        mapping = choice_map()
        target = mapping.get(ch)

        if target == "modules_list":
            list_modules()
            input("\nPress Enter to continue...")
            clear()
            print_banner()
            continue

        if target == "exit":
            print("Goodbye.")
            break

        if not target or not all(s.exists() for s in target):
            print("[PHOENIX] Invalid choice or script(s) not found.")
            input("\nPress Enter to continue...")
            clear()
            print_banner()
            continue

        # --- Run selected scripts in parallel ---
        run_scripts_parallel(target)
        input("\nPress Enter to return to menu...")
        clear()
        print_banner()

if __name__ == "__main__":
    main()
