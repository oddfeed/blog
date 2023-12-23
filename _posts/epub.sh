#!/bin/bash

# Prompt the user for the tag
read -p "Enter the tag to search for: " SEARCH_TAG

# Name of the output markdown and EPUB files based on the tag
OUTPUT_MD="${SEARCH_TAG}.md"
OUTPUT_EPUB="${SEARCH_TAG}.epub"

# make sure the old epub is removed
rm ../"$OUTPUT_EPUB"

# Clear the output markdown file
> "$OUTPUT_MD"

# Loop through all markdown files in the current directory
for file in *.md; do
    # Check if the file contains the specified tag
    if grep -q "tags:.*\b$SEARCH_TAG\b" "$file"; then
        # Append the content of the file to the output markdown file
        cat "$file" >> "$OUTPUT_MD"
        # Optional: Add a separator between files
        echo -e "\n---\n" >> "$OUTPUT_MD"
    fi
done

# Convert the combined markdown file to an EPUB file with a table of contents
pandoc "$OUTPUT_MD" -o "$OUTPUT_EPUB" --toc

echo "Markdown files combined into $OUTPUT_MD and converted to EPUB as $OUTPUT_EPUB based on tag '$SEARCH_TAG'."

echo "Deleting the markdown file"
rm "$OUTPUT_MD"

echo "Moving the pub"
mv "$OUTPUT_EPUB" ..
