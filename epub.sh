#!/bin/bash

# Current directory
DIR="."

# Output file
OUTPUT_FILE="epub.md"

# Header to be added at the start of the file
HEADER="---
title: epub Masterlist
permalink: /epub/
layout: page
---"

# Write the header to the output file
echo "$HEADER" > "$OUTPUT_FILE"

# Loop through EPUB files in the current directory
for file in "$DIR"/*.epub; do
    # Extract filename without path
    filename=$(basename "$file")

    # Write the formatted line to the output file
    echo "[$filename](https://alienatefurther.neocities.org/blog/$filename)  " >> "$OUTPUT_FILE"
done

echo "epub list has been generated in $OUTPUT_FILE."

