#!/bin/bash

# mark a to-do as complete
check_off_todo() {
  local options=""
  local line_num=0

  while IFS= read -r line; do
    ((line_num++))
    if [[ -n "$line" ]]; then
      options+="$line_num $line\n"
    fi
  done < "$todo_filename"

  if [[ -z "$options" ]]; then
    zenity --info --text="No uncompleted to-dos to check off."
    return
  fi

  local selected=$(echo -e "$options" | zenity --list --column="Line" --column="To-Do" --title="Check Off a To-Do")

  if [[ -n "$selected" ]]; then
    local line_num=$(echo "$selected" | awk '{print $1}')
    sed -i "${line_num}d" "$todo_filename"
  fi
}


# directories and files
notes_dir="$HOME/Documents/Notes"
todo_filename="$notes_dir/todo.txt"
mkdir -p "$notes_dir"

# dates
current_date=$(date +"%Y-%m-%d")
note_filename="$notes_dir/$current_date.txt"

# do fancy shit if note or todo file doesn't exist
if [[ ! -r "$note_filename" ]]; then
    echo "----------------------------------------" >> "$note_filename"
    echo "Date: $current_date" >> "$note_filename"
    echo "----------------------------------------" >> "$note_filename"
fi

if [[ ! -r "$todo_filename" ]]; then
    echo "----------------------------------------" >> "$todo_filename"
    echo "To-Do List" >> "$todo_filename"
    echo "----------------------------------------" >> "$todo_filename"
fi

# loop for adding notes or to-dos
while true; do
  choice=$(zenity --list --title="Choose Action" --column="Options" "Add Note or todo" "View To-Do List" "Check Off To-Do" "Quit")

  case "$choice" in
    "Add Note or todo")
        new_content=$(zenity --entry --title="Create a Note or To-Do" --text="Enter your note or to-do:")
        action=$(zenity --list --title="Save As" --column="Options" "Note" "To-Do")

        if [[ $action == "Note" ]]; then
            if [[ ! -z "$new_content" ]]; then
                echo "$(date +"%H:%M") $new_content" >> "$note_filename"
            fi
        elif [[ $action == "To-Do" ]]; then
            if [[ ! -z "$new_content" ]]; then
                echo "$new_content" >> "$todo_filename"
            fi
        fi
        ;;
    "View To-Do List")
        zenity --text-info --filename="$todo_filename"
        ;;
    "Check Off To-Do")
        check_off_todo
        ;;
    "Quit")
        exit 0
        ;;
  esac
done
