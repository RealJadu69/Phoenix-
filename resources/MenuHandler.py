#!/usr/bin/env python3
import os
import sys

# --- Get root directory from setup.sh argument or use current ---
if len(sys.argv) > 1:
    ROOT_DIR = sys.argv[1]
else:
    ROOT_DIR = os.path.dirname(os.path.abspath(__file__))

RES_DIR = os.path.join(ROOT_DIR, 'resources')
GROUPS_DIR = os.path.join(RES_DIR, 'groups')

# --- Verify groups folder exists ---
if not os.path.isdir(GROUPS_DIR):
    print(f"[ERROR] Groups directory not found at {GROUPS_DIR}")
    sys.exit(1)

# --- Scan all .sh scripts in groups folder ---
scripts = [f for f in os.listdir(GROUPS_DIR) if f.endswith('.sh')]
scripts.sort()  # optional: sort alphabetically

# --- Convert filenames to clean menu names ---
def pretty_name(filename):
    name = filename.replace('.sh', '')
    # Add spaces before capital letters
    new_name = ''
    for i, c in enumerate(name):
        if c.isupper() and i != 0 and name[i-1].islower():
            new_name += ' '
        new_name += c
    return new_name

menu_items = [{"name": pretty_name(f), "script": os.path.join(GROUPS_DIR, f)} for f in scripts]

# Add Exit option
