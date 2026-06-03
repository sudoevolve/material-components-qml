#!/usr/bin/env python3
"""
Material Design 3 Project Scaffold Script

Creates a new md3-based Qt Quick project from a template.

Usage:
    python3 scaffold/create_project.py
    python3 scaffold/create_project.py MyApp --template basic
    python3 scaffold/create_project.py "My Awesome App" --template basic --output ~/projects/
"""

import os
import sys
import shutil
import argparse
import re
from pathlib import Path


# ─── Paths ───────────────────────────────────────────────────────────────────

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent
TEMPLATES_DIR = SCRIPT_DIR / "templates"


# ─── Helpers ─────────────────────────────────────────────────────────────────

def to_project_id(name: str) -> str:
    """Convert a human-readable name to a C++/CMake-safe identifier.

    Examples:
        "My App"      -> "MyApp"
        "my-app"      -> "MyApp"
        "my_app"      -> "MyApp"
        "MyApp"       -> "MyApp"
    """
    # Replace common separators with spaces, then title-case each word
    cleaned = re.sub(r"[-_\s]+", " ", name).strip()
    # Title-case and remove spaces
    return "".join(word.capitalize() for word in cleaned.split())


def to_project_uri(name: str) -> str:
    """Convert a project ID to a QML module URI (lowercase dotted).

    Examples:
        "MyApp"       -> "my.app"
        "MySuperApp"  -> "my.super.app"
    """
    # Insert dots before capital letters (except the first)
    s = re.sub(r"(?<!^)(?=[A-Z])", ".", name)
    return s.lower()


def color_print(message: str, color: str = ""):
    """Print a colored message to the terminal."""
    colors = {
        "green": "\033[92m",
        "yellow": "\033[93m",
        "red": "\033[91m",
        "cyan": "\033[96m",
        "bold": "\033[1m",
        "reset": "\033[0m",
    }
    prefix = colors.get(color, "")
    suffix = colors["reset"] if color else ""
    print(f"{prefix}{message}{suffix}")


# ─── Template Discovery ──────────────────────────────────────────────────────

def list_templates() -> list[str]:
    """Return a list of available template names."""
    if not TEMPLATES_DIR.exists():
        return []

    templates = []
    for entry in sorted(TEMPLATES_DIR.iterdir()):
        if entry.is_dir() and not entry.name.startswith(".") and not entry.name.startswith("_"):
            # Check it has a CMakeLists.txt
            if (entry / "CMakeLists.txt").exists():
                templates.append(entry.name)
    return templates


def describe_template(name: str) -> str:
    """Return a short description of a template."""
    descriptions = {
        "basic": "A full-featured starter app with navigation drawer, home/settings/extras pages, "
                 "performance monitor, and all extras (Charts, DataGrid, HotReload) pre-wired.",
    }
    return descriptions.get(name, "No description available.")


def select_template_interactive() -> str:
    """Let the user pick a template interactively."""
    templates = list_templates()

    if not templates:
        color_print("❌ No templates found in scaffold/templates/", "red")
        sys.exit(1)

    if len(templates) == 1:
        name = templates[0]
        color_print(f"📁 Only one template available: {name}", "cyan")
        color_print(f"   {describe_template(name)}", "reset")
        return name

    color_print("\n📁 Available templates:\n", "bold")
    for i, name in enumerate(templates, 1):
        color_print(f"  [{i}] {name}", "cyan")
        print(f"      {describe_template(name)}")
    print()

    while True:
        try:
            choice = input(f"Select template [1-{len(templates)}] (default: 1): ").strip()
            if choice == "":
                return templates[0]
            idx = int(choice) - 1
            if 0 <= idx < len(templates):
                return templates[idx]
            color_print(f"  Please enter a number between 1 and {len(templates)}.", "yellow")
        except ValueError:
            color_print("  Please enter a valid number.", "yellow")
        except (EOFError, KeyboardInterrupt):
            print()
            sys.exit(0)


# ─── Core Logic ──────────────────────────────────────────────────────────────

def copy_and_render(
    src_dir: Path,
    dst_dir: Path,
    variables: "dict[str, str]",
    *,
    ignore_patterns=None,  # list[str] | None
):
    """Recursively copy a directory, replacing template variables in file
    contents AND in file/directory names.

    Args:
        src_dir: Source template directory.
        dst_dir: Destination project directory.
        variables: Dict of ``{{KEY}}`` -> ``value`` replacements.
        ignore_patterns: Glob-style patterns (relative to src_dir) to skip.
    """
    if ignore_patterns is None:
        ignore_patterns = []

    src_dir = src_dir.resolve()
    dst_dir = dst_dir.resolve()

    for root, dirs, files in os.walk(src_dir):
        rel_root = Path(root).relative_to(src_dir)

        # ── Skip ignored directories ─────────────────────────────────────
        dirs_to_skip = set()
        for d in dirs:
            rel_d = (rel_root / d).as_posix()
            if any(Path(rel_d).match(p) for p in ignore_patterns):
                dirs_to_skip.add(d)
        dirs[:] = [d for d in dirs if d not in dirs_to_skip]

        # ── Render directory name ────────────────────────────────────────
        rendered_root = apply_replacements(str(rel_root), variables)
        target_dir = dst_dir / rendered_root
        target_dir.mkdir(parents=True, exist_ok=True)

        # ── Copy files ───────────────────────────────────────────────────
        for fname in sorted(files):
            rel_f = (rel_root / fname).as_posix()
            if any(Path(rel_f).match(p) for p in ignore_patterns):
                continue

            src_file = Path(root) / fname
            rendered_fname = apply_replacements(fname, variables)
            dst_file = target_dir / rendered_fname

            # Detect binary files by extension
            binary_exts = {
                ".ico", ".png", ".jpg", ".jpeg", ".gif", ".bmp", ".svg",
                ".ttf", ".otf", ".woff", ".woff2",
                ".exe", ".dll", ".so", ".dylib",
                ".zip", ".tar", ".gz", ".7z",
                ".pdf", ".doc", ".docx",
            }
            is_binary = src_file.suffix.lower() in binary_exts

            if is_binary:
                shutil.copy2(src_file, dst_file)
            else:
                try:
                    content = src_file.read_text(encoding="utf-8")
                    rendered = apply_replacements(content, variables)
                    dst_file.write_text(rendered, encoding="utf-8")
                except UnicodeDecodeError:
                    # Fall back to binary copy
                    shutil.copy2(src_file, dst_file)


def apply_replacements(text: str, variables: dict[str, str]) -> str:
    """Replace all ``{{KEY}}`` placeholders in *text*."""
    for key, value in variables.items():
        text = text.replace(f"{{{{{key}}}}}", value)
    return text


def _make_src_ignore():
    """Return an ignore function for copytree that skips Extras module
    subdirectories while keeping LICENSE, README, and other non-module files.

    The whitelist of Extras children that are always copied:
        LICENSE, README.md
    Everything else under src/Extras/ is treated as a module folder and skipped.
    """
    KEEP = {"LICENSE", "README.md"}

    def _ignore(directory: str, files: list[str]) -> list[str]:
        import os as _os
        dir_basename = _os.path.basename(directory)
        parent_basename = _os.path.basename(_os.path.dirname(directory))
        # Are we inside src/Extras/* ?
        if parent_basename == "Extras":
            # We are directly inside src/Extras/<module>/
            return []  # skip the whole directory by ignoring nothing? No —
            # Actually we need to skip module dirs at the top level of Extras.
        if dir_basename == "Extras":
            # We are at src/Extras/ — skip all children except KEEP
            return [f for f in files if f not in KEEP and _os.path.isdir(_os.path.join(directory, f))]
        return []
    return _ignore


def copy_md3_source(dst_dir: Path, *, exclude_dirs_extra=None):  # set[str] | None
    """Copy the md3 library source (the whole project minus build artifacts)
    into ``dst_dir/third_party/md3/``.

    Args:
        dst_dir: The project output directory.
        exclude_dirs_extra: Additional directory names to exclude from the copy.
            Used to prevent copying the new project into itself when the output
            is inside the md3 project root.
    """
    color_print("\n📦 Copying md3 library source...", "cyan")

    target = dst_dir / "third_party" / "md3"
    target.mkdir(parents=True, exist_ok=True)

    # Directories & files to exclude from the library copy
    exclude_dirs = {
        "build", ".git", ".vscode", ".idea",
        "scaffold", "preview", "deploy", "projects",
        "__pycache__", ".pytest_cache",
    }
    if exclude_dirs_extra:
        exclude_dirs |= exclude_dirs_extra
    exclude_files = {
        "deploy.bat",
        ".gitignore",
        ".gitattributes",
        ".gitmodules",
        "CMakePresets.json",  # user-specific presets
        "CMakeUserPresets.json",
    }

    for item in PROJECT_ROOT.iterdir():
        if item == scaffold_dir_resolved():
            continue

        rel_name = item.name

        if item.is_dir():
            if rel_name in exclude_dirs or rel_name.startswith("."):
                continue

            # ── Extras: only copy LICENSE + README, skip module folders ─
            if rel_name == "src":
                shutil.copytree(
                    item,
                    target / rel_name,
                    ignore=_make_src_ignore(),
                    dirs_exist_ok=True,
                )
                continue

            shutil.copytree(
                item,
                target / rel_name,
                ignore=shutil.ignore_patterns(
                    "*.o", "*.obj", "*.a", "*.lib", "*.dylib", "*.so",
                    "moc_*", "ui_*", "qrc_*",
                    "Makefile", "*.make",
                    "CMakeFiles", "CMakeCache.txt", "cmake_install.cmake",
                    ".DS_Store", "Thumbs.db",
                ),
                dirs_exist_ok=True,
            )
        elif item.is_file():
            if rel_name in exclude_files or rel_name.startswith("."):
                continue
            shutil.copy2(item, target / rel_name)


def scaffold_dir_resolved() -> Path:
    """Return the resolved path to the scaffold directory."""
    return SCRIPT_DIR.resolve()


# ─── Main Entry Point ────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="Create a new md3-based Qt Quick project from a template.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python3 scaffold/create_project.py
  python3 scaffold/create_project.py MyApp
  python3 scaffold/create_project.py "My App" --template basic
  python3 scaffold/create_project.py MyApp --template basic --output ~/projects/
        """,
    )
    parser.add_argument(
        "name",
        nargs="?",
        default=None,
        help="Project name (e.g., 'MyApp' or 'My App'). If omitted, you will be prompted.",
    )
    parser.add_argument(
        "-t", "--template",
        default=None,
        help="Template to use. If omitted, you will choose interactively.",
    )
    parser.add_argument(
        "-o", "--output",
        default=None,
        help="Output directory. Defaults to the current working directory.",
    )
    parser.add_argument(
        "--list-templates",
        action="store_true",
        help="List available templates and exit.",
    )

    args = parser.parse_args()

    # ── List templates mode ──────────────────────────────────────────────
    if args.list_templates:
        templates = list_templates()
        if not templates:
            color_print("No templates found.", "yellow")
        else:
            color_print("Available templates:\n", "bold")
            for t in templates:
                color_print(f"  • {t}", "cyan")
                print(f"    {describe_template(t)}")
        return

    # ── Validate we're in the right project ──────────────────────────────
    if not TEMPLATES_DIR.exists():
        color_print(
            "❌ Cannot find scaffold/templates/ directory.\n"
            "   Run this script from the material-components-qml-pro project root.",
            "red",
        )
        sys.exit(1)

    # ── Gather inputs ────────────────────────────────────────────────────
    project_name = args.name
    if not project_name:
        print()
        try:
            project_name = input("Project name (e.g., 'MyApp' or 'My App'): ").strip()
        except (EOFError, KeyboardInterrupt):
            print()
            sys.exit(0)

    if not project_name:
        color_print("❌ Project name cannot be empty.", "red")
        sys.exit(1)

    project_id = to_project_id(project_name)
    project_uri = to_project_uri(project_id)

    # Choose template
    template_name = args.template
    if template_name:
        template_dir = TEMPLATES_DIR / template_name
        if not template_dir.is_dir():
            color_print(f"❌ Template '{template_name}' not found.", "red")
            color_print(f"   Available: {', '.join(list_templates())}", "yellow")
            sys.exit(1)
    else:
        template_name = select_template_interactive()
        template_dir = TEMPLATES_DIR / template_name

    # Output directory (defaults to projects/ under the repo root)
    if args.output:
        output_root = Path(args.output).resolve()
    else:
        output_root = (PROJECT_ROOT / "projects").resolve()
    project_dir = output_root / project_id

    # ── Confirmation ─────────────────────────────────────────────────────
    color_print("\n" + "─" * 55, "reset")
    color_print("  Project Configuration", "bold")
    color_print("─" * 55, "reset")
    print(f"  Project Name  : {project_name}")
    print(f"  Project ID    : {project_id}")
    print(f"  QML Module URI: {project_uri}")
    print(f"  Template      : {template_name}")
    print(f"  Output        : {project_dir}")
    color_print("─" * 55 + "\n", "reset")

    if project_dir.exists():
        color_print(f"⚠️  Directory already exists: {project_dir}", "yellow")
        try:
            confirm = input("Overwrite? [y/N]: ").strip().lower()
        except (EOFError, KeyboardInterrupt):
            print()
            sys.exit(0)
        if confirm != "y":
            color_print("Aborted.", "yellow")
            sys.exit(0)
        shutil.rmtree(project_dir)

    # ── Create project ───────────────────────────────────────────────────
    variables = {
        "PROJECT_ID": project_id,
        "PROJECT_NAME": project_name,
        "PROJECT_URI": project_uri,
    }

    try:
        # 1. Copy & render template
        color_print(f"🎨 Creating project from '{template_name}' template...", "cyan")
        copy_and_render(
            template_dir,
            project_dir,
            variables,
            ignore_patterns=["**/.DS_Store", "**/Thumbs.db"],
        )

        # 2. Copy md3 library source (exclude the project dir itself if it's
        #    inside this repo, to prevent infinite recursion)
        extra_exclude: set[str] = set()
        try:
            if str(project_dir.resolve()).startswith(str(PROJECT_ROOT.resolve()) + os.sep):
                extra_exclude.add(project_dir.resolve().relative_to(PROJECT_ROOT).parts[0])
        except ValueError:
            pass  # project_dir is outside PROJECT_ROOT, no exclusion needed

        copy_md3_source(project_dir, exclude_dirs_extra=extra_exclude)

    except Exception as e:
        color_print(f"\n❌ Error: {e}", "red")
        # Clean up on failure
        if project_dir.exists():
            shutil.rmtree(project_dir)
        sys.exit(1)

    # ── Done ─────────────────────────────────────────────────────────────
    color_print("\n" + "=" * 55, "green")
    color_print("  ✅  Project created successfully!", "green")
    color_print("=" * 55, "green")
    print(f"\n  📂 {project_dir}")
    print(f"\n  Next steps:")
    print(f"    cd {project_dir}")
    print(f"    Configure CMake with Qt6 prefix path")
    print(f"    Build and run!\n")


if __name__ == "__main__":
    main()
