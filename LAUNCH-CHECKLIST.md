# ColdCircuit Launch Checklist

Everything you need to go live in the next hour.

---

## Pre-Launch (5 minutes)

### 1. Test Locally

```bash
cd ~/.openclaw/workspace/crypto-blog
python3 -m http.server 8000
```

Visit: http://localhost:8000

**Check:**
- [ ] All pages load (Dashboard, Trade Log, Strategy, About)
- [ ] ColdCircuit branding on all pages
- [ ] Charts render correctly
- [ ] Mobile view looks good (resize browser)
- [ ] Footer shows @AICryptoTrades

### 2. Generate Fresh Content

```bash
cd ~/.openclaw/workspace
python3 crypto/blog-updater.py
python3 crypto/twitter-content.py
python3 crypto/performance.py snapshot
```

**Verify:**
- [ ] Blog updated successfully
- [ ] Twitter drafts generated
- [ ] Performance snapshot saved

---

## Deploy to GitHub Pages (5 minutes)

### 1. Create Repository

1. Go to https://github.com/new
2. Name: `coldcircuit`
3. Description: "AI-managed crypto trading - fully transparent"
4. Public repository
5. Click "Create repository"

### 2. Push Code

```bash
cd ~/.openclaw/workspace/crypto-blog

git init
git add .
git commit -m "Launch ColdCircuit - AI-managed crypto trading"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/coldcircuit.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username.

### 3. Enable GitHub Pages

1. Go to repo Settings
2. Click "Pages" in sidebar
3. Source: Deploy from branch **main**, folder **/ (root)**
4. Click "Save"
5. Wait 2-3 minutes

### 4. Get Your URL

Your site will be live at:
```
https://YOUR_USERNAME.github.io/coldcircuit/
```

**Test it:**
- [ ] Visit the URL
- [ ] All pages load correctly
- [ ] No broken links or images

---

## Twitter Setup (10 minutes)

### 1. Update Profile

1. Go to twitter.com/YOUR_USERNAME/settings
2. Username: Change to `@AICryptoTrades` (if available)
3. Display name: `ColdCircuit`
4. Bio:
   ```
   AI-managed crypto trading. Fully transparent.
   coldcircuit.io
   ```
5. Header image: (Optional - can design later)
6. Profile picture: (Optional - can use a circuit icon)

### 2. Pin Launch Tweet

Draft this tweet:

```
Launching ColdCircuit 🤖

An AI-managed crypto portfolio experiment. Starting with $55.

Every trade is logged. Every decision is transparent.

Live dashboard: https://YOUR_USERNAME.github.io/coldcircuit/

No hype. No guarantees. Just data.

Let's see if algorithmic discipline can beat human emotion.
```

**Post and pin it:**
- [ ] Tweet posted
- [ ] Pin to profile (3 dots → Pin to profile)

### 3. First Daily Update

Use the generated content:

```bash
cat crypto/twitter-drafts/daily-$(date +%Y-%m-%d).txt
```

Post via Bird CLI or manually.

---

## Set Up Automation (10 minutes)

### 1. SSH Key for Git Push

```bash
# Generate key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add to agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy public key
cat ~/.ssh/id_ed25519.pub | pbcopy
```

**Add to GitHub:**
1. GitHub → Settings → SSH and GPG keys
2. New SSH key
3. Paste public key
4. Save

**Update remote:**
```bash
cd crypto-blog
git remote set-url origin git@github.com:YOUR_USERNAME/coldcircuit.git
```

### 2. Create Update Script

```bash
mkdir -p ~/scripts

cat > ~/scripts/update-coldcircuit.sh << 'EOF'
#!/bin/bash
cd ~/.openclaw/workspace
python3 crypto/blog-updater.py
cd crypto-blog
git add .
git commit -m "Update $(date +%Y-%m-%d)" || exit 0
git push
EOF

chmod +x ~/scripts/update-coldcircuit.sh
```

### 3. Add Cron Jobs

```bash
crontab -e
```

Add these lines:

```cron
# Update ColdCircuit blog daily at 6:05pm
5 18 * * * ~/scripts/update-coldcircuit.sh >> ~/logs/coldcircuit.log 2>&1

# Generate Twitter content daily at 6:30pm
30 18 * * * cd ~/.openclaw/workspace && python3 crypto/twitter-content.py >> ~/logs/twitter.log 2>&1

# Save performance snapshot daily at 11:59pm
59 23 * * * cd ~/.openclaw/workspace && python3 crypto/performance.py snapshot >> ~/logs/performance.log 2>&1

# Weekly summary on Sundays at 5pm
0 17 * * 0 cd ~/.openclaw/workspace && python3 crypto/performance.py weekly >> ~/logs/weekly.log 2>&1
```

Create log directory:
```bash
mkdir -p ~/logs
```

**Test the script:**
```bash
~/scripts/update-coldcircuit.sh
```

Should push an update to GitHub.

---

## Share & Promote (30 minutes)

### Twitter

**Launch thread (4 tweets):**

```
1/ Launching ColdCircuit 🤖

An AI-managed crypto portfolio experiment.

Starting capital: $55
Strategy: RSI + EMA swing trading
Platform: Coinbase
Frequency: Bot runs every 30 min

Live dashboard: https://YOUR_USERNAME.github.io/coldcircuit/

---

2/ Why $55?

This is a learning experiment. Small stakes let me validate the strategy before scaling.

Every trade is logged with the exact reasoning. Total transparency.

---

3/ The strategy:

• RSI (14-period) for oversold/overbought signals
• EMA crossover (12/26) for trend confirmation
• Momentum rotation across 15+ liquid altcoins
• Strict risk management: -8% stop-loss, +15% take-profit

---

4/ What makes this different:

❌ No hype
❌ No price predictions
❌ No paid signals
✅ Open data
✅ Real trades
✅ Real results

Follow for daily updates and weekly performance threads.

AI-managed crypto, fully transparent.
```

**Post as thread:**
- [ ] All 4 tweets posted
- [ ] Pin tweet #1 to profile

### Reddit

**Post to r/algotrading:**

```
Title: Built an AI crypto trading bot - sharing results publicly (ColdCircuit)

I'm running an experiment: can algorithmic discipline beat emotional human decisions in crypto markets?

Project: ColdCircuit
Starting portfolio: $55
Strategy: RSI + EMA swing trading with momentum rotation
Platform: Coinbase (via Python API)
Frequency: Scans every 30 min

Every trade is logged with AI reasoning at: [your GitHub Pages URL]

Key features:
- Total transparency (all trades public)
- Risk management (stop-loss, take-profit, daily trade limits)
- No manual overrides (if I disagree, I change the code, not the order)

This isn't a paid service. Not selling anything. Just documenting the journey.

Tech stack: Python, Coinbase API, pandas, ta (technical analysis lib)

Happy to answer questions about the strategy, implementation, or results so far.
```

**Post to r/CryptoCurrency (if allowed):**

Similar but emphasize transparency and education.

### HackerNews

**Show HN post:**

```
Title: Show HN: ColdCircuit – AI crypto trading bot with full transparency

I built an AI-managed crypto trading bot and I'm sharing all trades publicly.

Live dashboard: [your URL]

Strategy: RSI + EMA swing trading with momentum rotation
Starting capital: $55 (small stakes for validation)
Platform: Coinbase API

Every trade is logged with the AI's reasoning. Win or lose, it's all public.

The goal: test if algorithmic discipline can outperform emotional human trading.

Code is Python (pandas, ta library). Happy to share more details if anyone's interested.

No course. No paid signals. Just an experiment and learning in public.
```

---

## Post-Launch Monitoring (First 24 Hours)

### Check Deployment

```bash
# Site is live
curl -I https://YOUR_USERNAME.github.io/coldcircuit/

# Should return: HTTP/2 200
```

### Monitor Logs

```bash
# Cron is working
tail -f ~/logs/coldcircuit.log

# Twitter content generated
ls -la crypto/twitter-drafts/
```

### Engage on Twitter

- [ ] Reply to comments on launch thread
- [ ] Follow back anyone who follows
- [ ] Share first daily update (6:30pm)
- [ ] Respond to DMs

### Track Analytics (Optional)

If you added analytics:
- [ ] Check visitor count
- [ ] See which pages are popular
- [ ] Monitor bounce rate

---

## Daily Workflow (Going Forward)

### Evening (6-7pm)

1. **Blog auto-updates** (6:05pm via cron)
2. **Twitter drafts generated** (6:30pm via cron)
3. **Review and post:**

```bash
cat crypto/twitter-drafts/daily-$(date +%Y-%m-%d).txt
bird tweet "$(cat crypto/twitter-drafts/daily-*.txt)"
```

4. **Engage** - Reply to comments, questions

### Weekly (Sundays)

1. **Performance summary generated** (5pm via cron)
2. **Weekly thread generated** (6:30pm via cron)
3. **Post thread manually** (Bird doesn't auto-thread)
4. **Review week's performance** - Any strategy changes needed?

---

## Troubleshooting

### Site not updating?

```bash
# Test update script manually
~/scripts/update-coldcircuit.sh

# Check logs
tail -50 ~/logs/coldcircuit.log

# Verify cron is running
crontab -l
```

### Git push fails?

```bash
# Check SSH key
ssh -T git@github.com

# Should say: "Hi username! You've successfully authenticated"
```

### Twitter content not generating?

```bash
# Run manually
python3 crypto/twitter-content.py

# Check for errors
```

---

## Success Metrics (First Week)

Track these to measure initial traction:

- [ ] Site deployed and live
- [ ] 100+ Twitter followers
- [ ] 10+ trades executed
- [ ] 5+ daily updates posted
- [ ] 1 weekly thread posted
- [ ] Reddit post engagement
- [ ] No major bugs or downtime

---

## Launch Checklist Summary

**Pre-Launch:**
- [ ] Test locally
- [ ] Generate fresh content
- [ ] Verify all scripts work

**Deploy:**
- [ ] Create GitHub repo
- [ ] Push code
- [ ] Enable GitHub Pages
- [ ] Site is live

**Twitter:**
- [ ] Update profile (@AICryptoTrades)
- [ ] Post launch thread
- [ ] Pin launch tweet

**Automate:**
- [ ] SSH keys configured
- [ ] Update script created
- [ ] Cron jobs added
- [ ] Test automation

**Share:**
- [ ] Twitter thread posted
- [ ] Reddit posts
- [ ] HackerNews (optional)

**Monitor:**
- [ ] Site health check
- [ ] Cron logs working
- [ ] Engage on social

---

**You're ready to launch ColdCircuit. Let's go! 🚀**

Estimated total time: **1 hour**

Next step: Create GitHub repo and push code (5 minutes)
