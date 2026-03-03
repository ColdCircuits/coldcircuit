#!/bin/bash
cd /Users/clank/.openclaw/workspace/crypto-blog
git add .
git commit -m "Update $(date +%Y-%m-%d)" 2>/dev/null
git push origin main 2>/dev/null
