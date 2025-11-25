#!/usr/bin/env python3

import os
import sys
import subprocess
import hashlib
import time
import csv
from pathlib import Path
import sys, ctypes as ct

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

    out_files = []

    for typ_file in typ_files:
        typ_path = Path(typ_file)
        rel_path = typ_path.relative_to(repo_root)

        output_file = export_dir / rel_path.with_suffix(".pdf")

        path_to_file = output_file.parent
        filename = output_file.with_suffix("").name

        output_file.parent.mkdir(parents=True, exist_ok=True)

        md5_file = Path(path_to_file / ("." + filename + ".md5"))

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

        out_files.append(typ_path)


    print("Creating Anki cards")

    print("Running command: "
           + " ".join(        [
            "python",
            str(script_dir / "../custom/typki/typki/__init__.py"),
            "-i",
            
            *map(str, out_files),
            "-t",
            "--root",
            str(repo_root),
        ],) 

    )

    subprocess.run(
        [
            "python",
            str(script_dir / "../custom/typki/typki/__init__.py"),
            "-i",
            "-q",
            *map(str, out_files),
            "-t",
            "--root",
            str(repo_root),
        ],
        check=True,
    )

    end_time = time.time()
    elapsed = end_time - start_time

    print()
    print(f"Total time: {format_time(elapsed)}")


if __name__ == "__main__":
    main()