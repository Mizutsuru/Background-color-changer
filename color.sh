#!/bin/bash

packageChecker() {
    dpkg -s "$1" &> /dev/null
}

packageInstalled() {
    echo "Package $1 is already installed."
}

installPackages() {
    if ! packageChecker "python3-pip"; then
        echo "Installing python3-pip..."
        sleep 1
        sudo apt-get update
        sudo apt-get install -y python3-pip
    else
        packageInstalled "python3-pip"
        sleep 1
    fi

    if ! packageChecker "python3"; then
        echo "Installing Python 3..."
        sleep 1
        sudo apt-get update
        sudo apt-get install -y python3
    else
        packageInstalled "python3"
        sleep 1
    fi

    if ! packageChecker "imagemagick"; then
        echo "Installing ImageMagick..."
        sleep 1
        sudo apt-get update
        sudo apt-get install -y imagemagick
    else
        packageInstalled "Imagemagick"
        sleep 1
    fi

    if ! packageChecker "figlet"; then
        echo "Installing figlet..."
        sleep 1
        sudo apt-get install -y figlet
    else
        packageInstalled "figlet"
        sleep 1
    fi
    
    if ! pip3 show Pywal &> /dev/null; then
        echo "Installing Pywal..."
        pip3 install Pywal
    else
        echo "Pywal is already installed."
    fi

    echo "All required packages are installed."
}

addSources() {
    if [ ! -d "sources" ]; then
        mkdir sources
    fi

    downloads_dir="$HOME/Downloads"
    ls $downloads_dir
    echo "Enter the names of the files you want to add (separated by space):"
    read filenames

    if [ -d "$downloads_dir" ]; then
        for filename in $filenames; do
            file_path=$(find "$downloads_dir" -maxdepth 1 -type f -iname "$filename")
            if [ -n "$file_path" ]; then
                cp "$file_path" sources/
                echo "File $filename added to sources directory."
            else
                echo "File $filename not found in downloads directory."
            fi
        done
    else
        echo "Downloads directory not found."
    fi
}

removeSources() {
    ls sources/
    echo "Enter the names of the files you want to remove (separated by space):"
    read files

    if [ -z "$files" ]; then
        echo "No files specified for removal."
        return
    fi

    for file in $files; do
        if [ -f "sources/$file" ]; then
            rm "sources/$file"
            echo "File $file removed from sources directory."
        else
            echo "File $file does not exist in sources directory."
        fi
    done
}

selectColor() {
    echo "Files in sources directory:"
    ls sources/

    echo "Enter the name of the file you want to use as the wallpaper:"
    read file

    if [ -f "sources/$file" ]; then
        wal -n -i "sources/$file"
        sleep 1
        echo "Done."
    else
        echo "File $file does not exist in sources directory."
    fi
}

while true; do
    clear
    figlet -t "Background color changer"
    echo "1. Install"
    echo "2. Add or remove sources"
    echo "3. Select color"
    echo "4. Exit"
    echo
    echo "Please enter your choice:"

    read choice

    case $choice in
        1)
            installPackages
            ;;
        2)
            echo "Add or remove sources:"
            echo "1. Add sources"
            echo "2. Remove sources"
            read option

            case $option in
                1)
                    addSources
                    ;;
                2)
                    removeSources
                    ;;
                *)
                    echo "Invalid option. Please try again."
                    ;;
            esac
            ;;
        3)
            selectColor
            ;;
        4)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac

    read -p "Press Enter to continue..."
done

