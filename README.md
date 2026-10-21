# snap-theme-injection

A utility to extend the `gtk-common-themes` snap by injecting custom GTK themes for use in sandboxed applications.

## Description

Due to **sandboxing**, Snap applications are restricted from accessing custom themes stored in your local directories. Ubuntu addresses this by providing the `gtk-common-themes` snap a collection of popular pre-packaged themes. However, this collection cannot include every custom theme available.

This repository provides a solution to this limitation. It **modifies** the `gtk-common-themes` snap by injecting your specified themes, making them available to your Snap applications and ensuring a consistent look across your desktop.

## Getting Started

### Dependencies

* `yq` package, a command-line YAML processor - jq wrapper for YAML documents. It can be installed with ```sudo apt install yq```

## Usage

To add your custom themes to the script, follow these steps:

### 1. Configure your themes
Create a `.env` file in the root of the repository. You can use the provided `.env.example` as a template. 

```bash
cp .env.example .env
```
### 2. Define your themes

Open the `.env` file and add your themes using the associative array syntax. You must categorize them by type: `GTK_THEMES`, `ICON_THEMES`, or `SOUND_THEMES`.

Syntax: `ARRAY_NAME["THEME_NAME"]="/PATH/TO/THEME"`

#### example configuration:
```bash
# --- GTK Themes ---
GTK_THEMES["Adwaita-Dark"]="/usr/share/themes/Adwaita-dark"

# --- Icon Themes ---
ICON_THEMES["Papirus-Dark"]="/usr/share/icons/Papirus-Dark"

# --- Sound Themes ---
SOUND_THEMES["MacOSSounds4Gnome"]="/usr/share/sounds/MacOSSounds4Gnome"
```
### 3. Run the script

Once your `.env` file is configured, run the main script to inject the themes into the gtk-common-themes snap.
Ensure the paths provided in your `.env` file are correct and accessible by your user.

```bash
bash main.bash
```

### 3. Snap connection

Running `main.bash` handles snap connections, but after installing a new snap or refreshing an existing one, you need to reconnect it manually by running:

```bash
sudo bash connect_snaps.bash
```