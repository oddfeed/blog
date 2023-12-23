#!/bin/bash

# Prompt for title
read -p "Enter title: " title

# Get current date in YYYY-MM-DD format
current_date=$(date +%F)

# Replace spaces in title with hyphens
formatted_title="${current_date}-${title// /-}"

# Create the markdown file
file_name="${formatted_title}.md"
echo "---" > "$file_name"
echo "tags: [tags]" >> "$file_name"
echo "---" >> "$file_name"
echo "" >> "$file_name"
echo "* TOC" >> "$file_name"
echo "{:toc}" >> "$file_name"
echo "---" >> "$file_name"
echo "" >> "$file_name"

# Open the file with nano
gedit "$file_name"
