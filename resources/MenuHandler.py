#!/usr/bin/env python3
import os
import subprocess

def clear_screen():
    os.system('clear' if os.name != 'nt' else 'cls')

def print_banner():
    banner = """
██████╗ ██╗  ██╗ ██████╗ ██╗  ██╗██╗███╗   ██╗
██╔══██╗██║  ██║██╔═══██╗██║ ██╔╝██║████╗  ██║
██████╔╝███████║██║   ██║█████╔╝ ██║██╔██╗ ██║
██╔═══╝ ██╔══██║██║   ██║██╔═██╗ ██║██║╚██╗██║
██║     ██║  ██║╚██████╔╝██║  ██╗██║██║ ╚████║
╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
"""
    print(banner)

def detect_groups(resources_dir):
    groups_dir = os.path.join(resources_dir, 'groups')
    groups = []
    if os.path.isdir(groups_dir):
        for f in sorted(os.listdir(groups_dir)):
            if f.endswith('.sh'):
                groups.append({
                    'name': f.replace('.sh', '').replace('_', ' '),
                    'path': os.path.join(groups_dir, f)
                })
    return groups

def display_menu(groups):
    print("\nSelect option:\n")
    for i, g in enumerate(groups, 1):
        print(f"{i}. {g['name']}")
    print(f"{len(groups)+1}. Exit")

def run_script(script_path):
    subprocess.run(['bash', script_path])

def main():
    import sys
    # Repo root is passed from setup.sh
    if len(sys.argv) > 1:
        root_dir = sys.argv[1]
    else:
        root_dir = os.path.dirname(os.path.abspath(__file__))

    resources_dir = os.path.join(root_dir, 'resources')
    groups = detect_groups(resources_dir)

    if not groups:
        print("[PHOENIX] No group scripts found in resources/groups/")
        return

    while True:
        clear_screen()
        print_banner()
        display_menu(groups)
        choice = input("\nEnter choice: ").strip()
        if not choice.isdigit():
            continue
        choice = int(choice)
        if choice == len(groups) + 1:
            print("\nExiting Phoenix. Goodbye!\n")
            break
        elif 1 <= choice <= len(groups):
            run_script(groups[choice - 1]['path'])
            input("\nPress Enter to return to menu...")
        else:
            continue

if __name__ == "__main__":
    main()
