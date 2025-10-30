#!/usr/bin/env python3
import os
import sys
import subprocess

# --- Root directory handling ---
if len(sys.argv) > 1:
    ROOT_DIR = sys.argv[1]
else:
    ROOT_DIR = os.path.dirname(os.path.abspath(__file__))

RES_DIR = os.path.join(ROOT_DIR, 'resources')
GROUPS_DIR = os.path.join(RES_DIR, 'groups')

# --- Validate groups folder ---
if not os.path.isdir(GROUPS_DIR):
    print(f"[ERROR] Groups directory not found at {GROUPS_DIR}")
    sys.exit(1)

# --- Gather all shell scripts ---
scripts = [f for f in os.listdir(GROUPS_DIR) if f.endswith('.sh')]
scripts.sort()

def pretty_name(filename):
    """Make filenames user-friendly for menu display."""
    name = filename.replace('.sh', '')
    result = ''
    for i, c in enumerate(name):
        if c.isupper() and i != 0 and name[i - 1].islower():
            result += ' '
        result += c
    return result.strip().capitalize()

menu_items = [{"name": pretty_name(f), "script": os.path.join(GROUPS_DIR, f)} for f in scripts]
menu_items.append({"name": "Exit", "script": None})

# --- Menu loop ---
while True:
    os.system('clear')
    print("=== ⚡ Phoenix Interactive Menu ⚡ ===\n")
    for idx, item in enumerate(menu_items, 1):
        print(f"{idx}. {item['name']}")
    print()

    try:
        choice = int(input("Select an option: "))
        if choice < 1 or choice > len(menu_items):
            raise ValueError
    except ValueError:
        print("\nInvalid choice. Press Enter to retry.")
        input()
        continue

    selected = menu_items[choice - 1]
    if selected['script'] is None:
        print("\nExiting Phoenix. Goodbye!")
        break

    # --- Execute selected script ---
    print(f"\n[PHOENIX] Running: {selected['name']}...\n")
    subprocess.run(['bash', selected['script']], check=False)
    print("\n--- Script completed ---")
    input("Press Enter to return to menu...")
