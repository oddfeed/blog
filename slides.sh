#!/bin/bash

# Directory containing HTML files
DIR="_site/slides"

# Output file
OUTPUT_FILE="slides.md"

# Header to be added at the start of the file
HEADER="---
title: Slides Masterlist
permalink: /slides/
layout: page
---"

# Write the header to the output file
echo "$HEADER" > "$OUTPUT_FILE"

# Loop through HTML files in the directory
for file in "$DIR"/*.html; do
    # Extract filename without path
    filename=$(basename "$file")

    # Write the formatted line to the output file
    echo "[$filename](https://alienatefurther.neocities.org/slides/$filename)" >> "$OUTPUT_FILE"
done

echo "Slides list has been generated in $OUTPUT_FILE."

