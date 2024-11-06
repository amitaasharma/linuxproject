#!/bin/bash

API_KEY="ffff1ffcfebe4660894cc8154f2d5b22"
ENDPOINT="https://newsapi.org/v2/top-headlines?country=us&apiKey=$API_KEY"

echo "Fetching top headlines..."

# Fetch the JSON response using curl
response=$(curl -s "$ENDPOINT")

# Check if the response contains "status": "ok"
if [[ "$response" != *'"status":"ok"'* ]]; then
    echo "Error fetching headlines. Please check your API key or network connection."
    exit 1
fi

# Extract and display the headlines using grep, sed, and awk
echo "Top Headlines:"
echo "$response" | grep -o '"title":"[^"]*"' | sed 's/"title":"//;s/"$//' | nl

echo ""
echo "Enter the number of the headline to see more details, or type 'q' to quit:"

while read -r choice; do
    if [ "$choice" == "q" ]; then
        echo "Exiting. Have a great day!"
        break
    elif [[ "$choice" =~ ^[0-9]+$ ]]; then
        article=$(echo "$response" | grep -oP '"title":"[^"]*"' | sed -n "${choice}p" | sed 's/"title":"//;s/"$//')
        if [ -n "$article" ]; then
            echo "--------------------------"
            echo "Title: $article"
            echo "Details:"
            echo "$response" | grep -oP '"description":"[^"]*"' | sed 's/"description":"//;s/"$//' | sed -n "${choice}p"
            echo "URL: $(echo "$response" | grep -oP '"url":"[^"]*"' | sed 's/"url":"//;s/"$//' | sed -n "${choice}p")"
            echo "--------------------------"
        else
            echo "Invalid choice. Please enter a valid number."
        fi
    else
        echo "Invalid input. Please enter a number or 'q' to quit."
    fi
    echo ""
    echo "Enter another number to see more details, or type 'q' to quit:"