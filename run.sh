#!/bin/bash
# Make sure to give execute permission: chmod +x run.sh

echo "Compiling..."
make

if [ ! -f lexer ]; then
    echo "Lexer not built!"
    exit 1
fi

echo "Running lexer on test files..."

for file in test/*.txt; do
    echo -e "\n--- Output for $file ---"
    ./lexer < "$file"
done
