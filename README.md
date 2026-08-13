# Godot Project Scaffolder

An editor plugin for Godot 4 that automatically sets up a standard folder structure for new projects, so you don't have to manually create the same folders every time.

## Features

- **Create 2D Setup** — generates `scenes/`, `scripts/`, `assets/sprites/`, `assets/audio/`
- **Create 3D Setup** — generates `scenes/`, `scripts/`, `assets/models/`, `assets/textures/`, `assets/audio/`
- **Delete Generated Setup** — removes the generated folders, with a confirmation popup to prevent accidental data loss
- Warns you before creating folders that already exist, so you don't lose track of existing work

## Installation

1. Download this repository (click the green **Code** button above → **Download ZIP**), or clone it if you're familiar with Git.
2. Copy the `addons/project_scaffolder` folder into your Godot project's root directory, so it looks like:
your_project/
addons/
project_scaffolder/
plugin.cfg
plugin.gd

3. Open your project in Godot.
4. Go to **Project → Project Settings → Plugins**.
5. Find **Project Scaffolder** in the list and enable it.

## Usage

Once enabled, go to **Project → Tools** in the top menu bar. You'll see:

- **Create 2D Setup**
- **Create 3D Setup**
- **Delete Generated Setup**

Click the one you need. Folders will be created (or removed) automatically, and the FileSystem dock will refresh to show the changes.

## Requirements

- Godot 4.x
