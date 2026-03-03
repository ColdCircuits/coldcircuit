# ColdCircuit

**AI-managed crypto, fully transparent.**

Public-facing blog and content system for Josh Miner's AI-managed crypto portfolio.

## Overview

This is a complete content ecosystem for transparent, educational crypto trading:

- **Static blog site** - Live dashboard, trade log, strategy explanation
- **Auto-update script** - Daily refresh of portfolio data and charts
- **Twitter content generator** - Daily updates and weekly threads
- **Performance tracker** - Comprehensive metrics tracking

## Directory Structure

```
crypto-blog/
├── index.html          # Dashboard (portfolio value, charts, positions)
├── trade-log.html      # Complete trade history with reasoning
├── strategy.html       # Strategy explanation (RSI + EMA)
├── about.html          # About Josh and the experiment
├── css/
│   └── style.css       # Dark theme, crypto-native design
└── README.md           # This file

crypto/
├── blog-updater.py     # Updates HTML with fresh data
├── twitter-content.py  # Generates tweet drafts
├── performance.py      # Tracks performance metrics
├── twitter-drafts/     # Generated tweet drafts
└── performance-history.json  # Daily snapshots
```

## Usage

### Update Blog

Run daily (or after significant trades) to refresh the site:

```bash
python3 crypto/blog-updater.py
```

This script:
- Reads `trade-log.json` and current portfolio state
- Generates SVG charts (portfolio value, allocation)
- Updates `index.html` and `trade-log.html` with fresh data
- Can be automated via cron

### Generate Twitter Content

Generate daily updates and weekly threads:

```bash
python3 crypto/twitter-content.py
```

Outputs:
- `twitter-drafts/daily-YYYY-MM-DD.txt` - Daily portfolio update
- `twitter-drafts/trade-YYYY-MM-DD-N.txt` - Individual trade announcements
- `twitter-drafts/weekly-thread-YYYY-MM-DD.txt` - Weekly summary thread (Sundays)

### Track Performance

Save daily snapshot:

```bash
python3 crypto/performance.py snapshot
```

Generate weekly summary:

```bash
python3 crypto/performance.py weekly
```

Show current stats:

```bash
python3 crypto/performance.py stats
```

## Automation

### Recommended Cron Schedule

```cron
# Update blog daily at 6pm
0 18 * * * cd ~/.openclaw/workspace && python3 crypto/blog-updater.py

# Generate Twitter content daily at 6:30pm
30 18 * * * cd ~/.openclaw/workspace && python3 crypto/twitter-content.py

# Save performance snapshot daily at 11:59pm
59 23 * * * cd ~/.openclaw/workspace && python3 crypto/performance.py snapshot

# Generate weekly summary on Sundays at 5pm
0 17 * * 0 cd ~/.openclaw/workspace && python3 crypto/performance.py weekly
```

## Publishing

### Option 1: GitHub Pages

1. Create a new GitHub repo
2. Copy `crypto-blog/` contents to repo root
3. Enable GitHub Pages in repo settings
4. Push updates after running `blog-updater.py`

### Option 2: Netlify

1. Create Netlify site from `crypto-blog/` directory
2. Set up auto-deploy from GitHub (optional)
3. Custom domain supported

### Option 3: Self-hosted

Serve `crypto-blog/` with any static file server:

```bash
# Simple Python server
cd crypto-blog
python3 -m http.server 8000
```

## Design Principles

1. **Transparency first** - Every trade logged with reasoning
2. **No hype** - Data-driven, educational tone
3. **Mobile-responsive** - Clean design across devices
4. **Performance-focused** - Static HTML, no external dependencies
5. **Privacy-preserving** - No tracking, no cookies, no analytics

## Data Sources

- `crypto/trade-log.json` - All trades from trading bot
- `crypto/agent-state.json` - Current bot state
- `crypto/performance-history.json` - Daily snapshots
- Coinbase API - Live portfolio data (via trading-agent.py)

## Customization

### Update Blog URL

Replace `[blog URL here]` in Twitter drafts with your actual URL.

### Newsletter Signup

The newsletter form is a placeholder. Wire it up to:
- Mailchimp
- ConvertKit
- Substack
- Custom endpoint

### Add Analytics (Optional)

If you want visitor tracking, add Google Analytics or Plausible to the `<head>` of each HTML file.

## Tone & Voice

- **Professional but accessible** - No jargon walls
- **Educational, not promotional** - "Here's what happened and why"
- **Data-driven** - Numbers, percentages, reasoning
- **Humble** - Acknowledge losses, iterate publicly
- **No emojis** - Keep it serious and credible

## Example Tweet Formats

### Daily Update

```
Daily Update - March 2, 2026

Portfolio: $57.23
Return: +4.05%

No trades today. The bot is scanning for opportunities.

Strategy: RSI + EMA swing trading with momentum rotation.
```

### Trade Announcement

```
SELL $XLM

Value: $18.45

Why: RSI overbought (78), EMA crossover bearish. Taking profit at +12% from entry.

This trade was executed by my AI trading bot. Strategy: RSI + EMA swing trading.
```

### Weekly Thread

```
1/ Weekly Update (Feb 24 - Mar 2)

Portfolio: $57.23
Total return: +4.05%
Trades: 6

Here's what my AI trading bot did this week...

2/ Strategy: RSI + EMA swing trading

Buy signals: 3
Sell signals: 3

The bot is executing its strategy consistently. Positive momentum this week.

3/ Key lessons:

• Momentum rotation is working in trending markets
• Stop-losses protected capital on failed signals
• Algorithmic discipline beats emotional trading

4/ Next week:

• Continue tracking RSI + EMA signals
• Monitor for momentum rotation opportunities

Full trade log and charts: [blog URL]

Not financial advice. Just sharing the data.
```

## Maintenance

### Weekly Tasks

- Review generated Twitter content before posting
- Check blog for any display issues
- Verify performance metrics are calculating correctly

### Monthly Tasks

- Review strategy performance
- Update `strategy.html` if parameters change
- Archive old Twitter drafts

### As Needed

- Update `about.html` with new learnings
- Add new charts or visualizations
- Improve mobile responsiveness based on feedback

## Support

Questions or issues? This is an experimental project. Iterate and improve based on what works.

## License

Content is public. Code is MIT. Use freely, but don't claim it's financial advice.

---

Built with transparency. Managed by algorithms. Shared for learning.
