# Quick Start Guide

Get your crypto trading blog up and running in 5 minutes.

## Step 1: Test the System

Generate the blog with current data:

```bash
cd ~/.openclaw/workspace
python3 crypto/blog-updater.py
```

This will update `crypto-blog/index.html` and `crypto-blog/trade-log.html` with live data.

## Step 2: View Locally

Open the blog in your browser:

```bash
cd crypto-blog
open index.html
# or
python3 -m http.server 8000
# then visit http://localhost:8000
```

## Step 3: Generate Twitter Content

Create today's tweet drafts:

```bash
python3 crypto/twitter-content.py
```

Drafts will be saved in `crypto/twitter-drafts/`. Review and post via Bird CLI:

```bash
ls crypto/twitter-drafts/
cat crypto/twitter-drafts/daily-2026-03-02.txt
```

## Step 4: Track Performance

Save today's performance snapshot:

```bash
python3 crypto/performance.py snapshot
```

View current stats:

```bash
python3 crypto/performance.py stats
```

## Step 5: Automate (Optional)

Set up cron jobs to run daily:

```bash
crontab -e
```

Add these lines:

```cron
# Update blog daily at 6pm
0 18 * * * cd ~/.openclaw/workspace && python3 crypto/blog-updater.py >> ~/logs/crypto-blog.log 2>&1

# Generate Twitter content daily at 6:30pm
30 18 * * * cd ~/.openclaw/workspace && python3 crypto/twitter-content.py >> ~/logs/twitter-content.log 2>&1

# Save performance snapshot daily at 11:59pm
59 23 * * * cd ~/.openclaw/workspace && python3 crypto/performance.py snapshot >> ~/logs/performance.log 2>&1
```

Create the log directory:

```bash
mkdir -p ~/logs
```

## Step 6: Publish

### GitHub Pages (Recommended)

1. Create a new GitHub repo: `crypto-trading-blog`
2. Copy `crypto-blog/` contents to repo:

```bash
cd crypto-blog
git init
git add .
git commit -m "Initial blog setup"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/crypto-trading-blog.git
git push -u origin main
```

3. Enable GitHub Pages:
   - Go to repo Settings → Pages
   - Source: Deploy from branch
   - Branch: main, folder: / (root)
   - Save

4. Your blog will be live at: `https://YOUR_USERNAME.github.io/crypto-trading-blog/`

### Update Workflow

After each trade day:

```bash
# 1. Update blog
python3 crypto/blog-updater.py

# 2. Commit and push
cd crypto-blog
git add .
git commit -m "Update $(date +%Y-%m-%d)"
git push
```

### Netlify (Alternative)

1. Create account at netlify.com
2. Drag and drop `crypto-blog/` folder
3. Custom domain supported

## Daily Workflow

### Morning Routine (optional)

Check overnight trades:

```bash
python3 crypto/trading-agent.py status
tail -20 crypto/trade-log.json
```

### Evening Routine

1. Generate content:

```bash
python3 crypto/twitter-content.py
```

2. Review drafts:

```bash
ls crypto/twitter-drafts/
cat crypto/twitter-drafts/daily-$(date +%Y-%m-%d).txt
```

3. Post to Twitter (via Bird CLI):

```bash
bird tweet "$(cat crypto/twitter-drafts/daily-$(date +%Y-%m-%d).txt)"
```

4. Update blog:

```bash
python3 crypto/blog-updater.py
cd crypto-blog && git add . && git commit -m "Update $(date +%Y-%m-%d)" && git push
```

## Weekly Workflow (Sundays)

1. Generate weekly summary:

```bash
python3 crypto/performance.py weekly
```

2. Generate weekly thread:

```bash
python3 crypto/twitter-content.py
cat crypto/twitter-drafts/weekly-thread-$(date +%Y-%m-%d).txt
```

3. Post thread to Twitter (manually, since Bird doesn't thread natively):

- Split the thread file by `---NEXT TWEET---` markers
- Post each tweet as a reply to the previous one

## Customization

### Update Blog URL in Tweets

1. Publish your blog to GitHub Pages / Netlify
2. Get the live URL (e.g., `https://yourusername.github.io/crypto-trading-blog/`)
3. Find and replace `[blog URL here]` in:
   - `crypto/twitter-content.py` (lines with `[blog URL here]`)
   - Update and regenerate content

### Change Starting Value

If you add more capital:

1. Edit `crypto/performance.py`
2. Change `STARTING_VALUE = 55.0` to new amount
3. Save and run `python3 crypto/performance.py snapshot`

### Modify Tweet Tone

Edit `crypto/twitter-content.py`:
- `generate_daily_update()` - Daily format
- `generate_trade_announcement()` - Trade format
- `generate_weekly_thread()` - Weekly format

## Troubleshooting

### Blog not updating?

Check if trade-log.json exists:

```bash
ls -la crypto/trade-log.json
cat crypto/trade-log.json
```

### No Twitter drafts?

Ensure directory exists:

```bash
ls crypto/twitter-drafts/
```

If empty, run:

```bash
python3 crypto/twitter-content.py
```

### Portfolio value showing $0?

Check Coinbase API credentials:

```bash
python3 crypto/trading-agent.py status
```

If that works, blog-updater should too.

### Charts not rendering?

- SVG generation is inline in `blog-updater.py`
- Check browser console for errors
- Try opening `index.html` directly (not via server)

## Next Steps

1. **Build credibility** - Post consistently, share real data
2. **Iterate on strategy** - Document changes transparently
3. **Engage on Twitter** - Reply to questions, share lessons
4. **Add newsletter** - Wire up email capture form
5. **Scale cautiously** - Increase capital as strategy proves out

## Support

This is an experimental system. If something breaks, check:
1. `~/logs/` for cron errors
2. Run scripts manually to see full error output
3. Check that `trade-log.json` is valid JSON

## Philosophy

- **Ship fast, iterate publicly**
- **Transparency builds trust**
- **Data > narratives**
- **Consistency > perfection**

Your blog is now live. Start sharing.
