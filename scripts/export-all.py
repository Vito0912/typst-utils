#!/usr/bin/env python3

import os
import sys
import subprocess
import hashlib
import time
import csv
from pathlib import Path


def get_md5(file_path):
    """Calculate MD5 hash of a file."""
    hash_md5 = hashlib.md5()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()


def find_typ_files(repo_root):
    """Find all .typ files excluding certain directories."""
    typ_files = []
    for root, dirs, files in os.walk(repo_root):
        # Skip excluded directories
        dirs[:] = [
            d for d in dirs if d not in ["typst-utils", "_export"]
        ]

        for file in files:
            if file.endswith(".typ"):
                full_path = os.path.join(root, file)
                typ_files.append(full_path)

    return typ_files


def remove_duplicate_uuids(csv_file):
    """Remove duplicate rows based on UUID (second column)."""
    seen_uuids = set()
    unique_rows = []
    duplicate_count = 0

    with open(csv_file, "r", encoding="utf-8", newline="") as f:
        reader = csv.reader(f, delimiter=";")
        for row in reader:
            if len(row) >= 2:
                uuid = row[1]
                if uuid not in seen_uuids:
                    seen_uuids.add(uuid)
                    unique_rows.append(row)
                else:
                    duplicate_count += 1

    with open(csv_file, "w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f, delimiter=";")
        writer.writerows(unique_rows)

    if duplicate_count > 0:
        print(f"Removed {duplicate_count} duplicate card(s)")


def format_time(elapsed):
    """Format elapsed time."""
    if elapsed >= 60:
        hours = int(elapsed // 3600)
        mins = int((elapsed % 3600) // 60)
        secs = elapsed % 60
        return f"{hours}:{mins:02d}:{secs:06.3f} (H:MM:SS.mmm)"
    else:
        return f"{elapsed:.3f} seconds"


def main():
    ignore_md5 = False
    if len(sys.argv) > 1 and sys.argv[1] == "--ignore-md5":
        ignore_md5 = True
        print("Ignoring md5 checks")

    script_dir = Path(__file__).parent.resolve()
    repo_root = (script_dir / "../..").resolve()
    export_dir = repo_root / "_export"

    print(f"Repository root: {repo_root}")
    print(f"Export directory: {export_dir}")

    export_dir.mkdir(parents=True, exist_ok=True)

    start_time = time.time()

    typ_files = find_typ_files(repo_root)

    for typ_file in typ_files:
        typ_path = Path(typ_file)
        rel_path = typ_path.relative_to(repo_root)

        output_file = export_dir / rel_path.with_suffix(".pdf")
        rel_path_no_ext = str(rel_path.with_suffix(""))
        output_anki_file = export_dir / f"{rel_path_no_ext}_anki.txt"

        output_file.parent.mkdir(parents=True, exist_ok=True)

        md5_file = Path(str(output_file) + ".md5")

        # Check if MD5 hash file exists and matches
        if not ignore_md5 and md5_file.exists():
            existing_hash = md5_file.read_text().strip()
            current_hash = get_md5(typ_path)
            if existing_hash == current_hash:
                print(f"Skipping (no changes): {rel_path}")
                continue

        current_hash = get_md5(typ_path)
        md5_file.write_text(current_hash + "\n")

        print(
            f"Compiling: {rel_path} -> "
            f"{output_file.relative_to(repo_root)}"
        )
        subprocess.run(
            [
                "typst",
                "compile",
                "--root",
                str(repo_root),
                str(typ_path),
                str(output_file),
            ],
            check=True,
        )

        print("Creating Anki cards")
        subprocess.run(
            [
                "python",
                str(script_dir / "../custom/typki/typki/__init__.py"),
                "-o",
                str(output_anki_file),
                "-q",
                str(typ_path),
                "--root",
                str(repo_root),
            ],
            check=True,
        )

    merged_anki_file = export_dir / "anki_cards.txt"
    with open(merged_anki_file, "w", encoding="utf-8") as merged:
        for anki_file in export_dir.rglob("*_anki.txt"):
            with open(anki_file, "r", encoding="utf-8") as f:
                lines = f.readlines()[5:]
                merged.writelines(lines)

    print("Removing duplicate cards...")
    remove_duplicate_uuids(merged_anki_file)

    # Add string to top of merged file
    with open(merged_anki_file, "r+", encoding="utf-8") as f:
        content = f.read()
        f.seek(0, 0)
        f.write("""#notetype column:1
#guid column:2
#deck column: 3
#html:true
#separator:Semicolon""" + "\n" + content)

    end_time = time.time()
    elapsed = end_time - start_time

    print()
    print(f"Total time: {format_time(elapsed)}")


if __name__ == "__main__":
    main()