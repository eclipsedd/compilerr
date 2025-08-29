#!/bin/bash
# Make sure to give execute permission: chmod +x run.sh

make

if [ ! -f lexer ]; then
    echo "Lexer not built!"
    exit 1
fi

echo "Running lexer on test files"

for file in test/*.c; do
    echo -e "\n--- Output for $file ---"
    ./lexer < "$file"
done
