#!/bin/bash
# Deploy ColdCircuit blog to GitHub Pages
cd "$(dirname "$0")"

# Commit any changes on main
git add .
git commit -m "Update - $(date +%Y-%m-%d_%H:%M)" 2>/dev/null

# Update gh-pages from main
git checkout gh-pages
git merge main --no-edit
git push origin gh-pages
git checkout main
git push origin main 2>/dev/null

echo "Deployed to https://coldcircuits.github.io/coldcircuit/"
