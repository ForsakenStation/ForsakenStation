#!/bin/bash
# Helper script to run scraper with environment variables from .env file

if [ ! -f .env ]; then
    echo "Error: .env file not found"
    echo "Copy .env.example to .env and add your credentials"
    exit 1
fi

# Load only SCREENSCRAPER_ variables from .env
export $(grep '^SCREENSCRAPER_' .env | xargs)

# Check if credentials are set
if [ -z "$SCREENSCRAPER_USER" ] || [ -z "$SCREENSCRAPER_PASSWORD" ]; then
    echo "Error: SCREENSCRAPER_USER or SCREENSCRAPER_PASSWORD not found in .env"
    echo "Please add these lines to your .env file:"
    echo "SCREENSCRAPER_USER=your_username"
    echo "SCREENSCRAPER_PASSWORD=your_password"
    exit 1
fi

# Run scraper with all arguments
python3 scrape_media.py "$@"
