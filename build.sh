#!/usr/bin/env bash

input_file="main.typ"
output_dir="build"
group="39"
name="Assignment-Group$group"
output_file="$output_dir/$name.pdf"

mkdir -p "$output_dir"

typst compile "$input_file" "$output_file"
