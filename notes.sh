#!/bin/bash

# bash script using zenity to keep notes throughout the day

# check if notes dir exists, if not make it
notes_dir="$HOME/Documents/Notes"
mkdir -p "$notes_dir"

# set the current date
current_date=$(date +"%Y-%m-%d")

# check if todays note file already exists, if it doesn't then it formats the date stamp at the start
note_filename="$notes_dir/$current_date.txt"
if [[ ! -r "$note_filename" ]]; then
    echo "----------------------------------------" >> "$note_filename"
    echo "Date: $current_date" >> "$note_filename"
    echo "----------------------------------------" >> "$note_filename"
fi

# adds each note by appending to the end of the note file
echo "$(date +"%H:%M") $(zenity --entry --title="Enter Note" --text="Note:")" >> "$note_filename"

# checks if you want to continue or not
zenity --question --text="Keep taking notes?" --width=200
response=$?

# if you don't want to continue it exits
if [[ $response -ne 0 ]]; then
    exit 0
fi

# start looping if you do want to keep adding notes
while true; do
    echo "$(date +"%H:%M") $(zenity --entry --title="Create a Note" --text="Enter your note:")" >> "$note_filename"
    
    zenity --question --text="Do you want to add another note?" --width=200
    response=$?

    if [[ $response -ne 0 ]]; then
        break
    fi
done

