#!/bin/bash

set -e

rm -f ./gtk-common-themes.snap ./gtk-common-themes.assert ./updated-common-themes-snap 2>/dev/null
rm -rf ./updated-common-themes 2>/dev/null

source ./.env
THEME_ARRAYS_VARS=("GTK_THEMES" "ICON_THEMES" "SOUND_THEMES")

#Download base gtk common thems
echo "Downloading common-themes snap..."
snap download gtk-common-themes --basename gtk-common-themes

#Extract gtk snap content into a new dir
echo "Extracting common-themes snap..."
unsquashfs -d ./updated-common-themes gtk-common-themes.snap

#loop themes
for themes_var_name in "${THEME_ARRAYS_VARS[@]}" ; do 

    #Create a refrerence to the vars stored in THEMES_BY_TYPE
    declare -n THEME_VAR_REF="$themes_var_name"

    #Get the theme type given the var name
    case "$themes_var_name" in
            "GTK_THEMES")
                theme_type="gtk" ;;
            "ICON_THEMES")
                theme_type="icon" ;;
            "SOUND_THEMES")
                theme_type="sound" ;;
    esac

    #loop themes
    for theme_name in "${!THEME_VAR_REF[@]}"; do

        theme_path=$(realpath "${THEME_VAR_REF[$theme_name]}")

        if [[ "$theme_type" == "icon" ]]; then
            dst_path="updated-common-themes/share/icons"
            yaml_target='.slots."icon-themes".source.read'
            yaml_new_value="\$SNAP/share/icons/$theme_name"


        elif [[ "$theme_type" == "gtk" ]]; then
            dst_path="updated-common-themes/share/themes"
            yaml_target='.slots."gtk-3-themes".source.read'
            yaml_new_value="\$SNAP/share/themes/$theme_name"


        elif [[ "$theme_type" == "sound" ]]; then
            dst_path="updated-common-themes/share/sounds"
            yaml_target='.slots."sound-themes".source.read'
            yaml_new_value="\$SNAP/share/sounds/$theme_name"
        fi

        echo -n "Adding $theme_name...  "

        cp -r "$theme_path" "$dst_path"
        
        #Add theme to snap yaml files
        yq -yi $yaml_target' += ["'"$yaml_new_value"'"]' ./updated-common-themes/meta/snap.yaml
        yq -yi $yaml_target' += ["'"$yaml_new_value"'"]' ./updated-common-themes/snap/manifest.yaml
        yq -yi $yaml_target' += ["'"$yaml_new_value"'"]' ./updated-common-themes/snap/snapcraft.yaml

        echo "done"

    done
  
done

echo "Packing updated snap... "
mksquashfs updated-common-themes updated-common-themes-snap -noappend -comp xz

echo "Installing updated snap... "
sudo snap install ./updated-common-themes-snap --dangerous

echo -n "Cleaning files...  "
rm -f ./gtk-common-themes.snap ./gtk-common-themes.assert ./updated-common-themes-snap 2>/dev/null
rm -rf ./updated-common-themes 2>/dev/null
echo "done"

