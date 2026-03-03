# ColdCircuit - GitHub Pages Deployment

Complete guide to deploying ColdCircuit to GitHub Pages.

---

## Quick Start (5 Minutes)

### 1. Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `coldcircuit` (or `crypto-trading-blog`)
3. Description: "AI-managed crypto trading - fully transparent"
4. Public repository (required for free GitHub Pages)
5. Click "Create repository"

### 2. Push Your Code

```bash
cd ~/.openclaw/workspace/crypto-blog

# Initialize git
git init
git add .
git commit -m "Initial commit: ColdCircuit launch"

# Connect to GitHub (replace YOUR_USERNAME)
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/coldcircuit.git
git push -u origin main
```

### 3. Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** (top right)
3. Click **Pages** in left sidebar
4. Under "Source":
   - Select branch: **main**
   - Select folder: **/ (root)**
5. Click **Save**

### 4. Wait 2-3 Minutes

Your site will be live at:
```
https://YOUR_USERNAME.github.io/coldcircuit/
```

GitHub will show the URL in Settings → Pages once deployed.

---

## Custom Domain Setup (Optional)

If you want `coldcircuit.io` instead of `username.github.io/coldcircuit/`:

### 1. Buy a Domain

Recommended registrars:
- Namecheap
- Google Domains
- Cloudflare Registrar

### 2. Configure DNS

Add these records at your domain registrar:

```
Type: A     Name: @     Value: 185.199.108.153
Type: A     Name: @     Value: 185.199.109.153
Type: A     Name: @     Value: 185.199.110.153
Type: A     Name: @     Value: 185.199.111.153
Type: CNAME Name: www   Value: YOUR_USERNAME.github.io
```

### 3. Configure GitHub Pages

1. In your repo: Settings → Pages
2. Under "Custom domain", enter: `coldcircuit.io`
3. Click "Save"
4. Check "Enforce HTTPS" (after DNS propagates, ~24 hours)

### 4. Wait for DNS Propagation

- Can take 24-48 hours
- Check status: `dig coldcircuit.io`
- Once propagated, your site is live at `coldcircuit.io`

---

## Automated Updates

### Option 1: Cron + Git Push (Recommended)

Set up automated blog updates and deployment:

```bash
# Create update script
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

Add to crontab (`crontab -e`):

```cron
# Update ColdCircuit daily at 6:05pm
5 18 * * * ~/scripts/update-coldcircuit.sh >> ~/logs/coldcircuit-deploy.log 2>&1
```

**Note:** You need SSH keys for password-less git push (see below).

### Option 2: GitHub Actions (Advanced)

Create `.github/workflows/update.yml` in your repo:

```yaml
name: Update ColdCircuit

on:
  schedule:
    - cron: '0 2 * * *'  # Daily at 2am UTC
  workflow_dispatch:  # Manual trigger

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - name: Update blog
        run: |
          python3 crypto/blog-updater.py
      - name: Commit and push
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add .
          git commit -m "Auto-update $(date +'%Y-%m-%d')" || exit 0
          git push
```

This runs the updater on GitHub's servers (no local cron needed).

---

## SSH Key Setup (For Automated Push)

### 1. Generate SSH Key

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
# Save to default location: ~/.ssh/id_ed25519
# Use a passphrase (optional but recommended)
```

### 2. Add to SSH Agent

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### 3. Add Public Key to GitHub

```bash
# Copy public key
cat ~/.ssh/id_ed25519.pub | pbcopy  # macOS
# or
cat ~/.ssh/id_ed25519.pub
```

1. Go to GitHub.com → Settings → SSH and GPG keys
2. Click "New SSH key"
3. Paste the public key
4. Click "Add SSH key"

### 4. Update Git Remote

```bash
cd crypto-blog
git remote set-url origin git@github.com:YOUR_USERNAME/coldcircuit.git
```

Now `git push` works without password prompts.

---

## Verify Deployment

### 1. Check Build Status

- Go to repo → Actions tab
- Should show successful deployment

### 2. Test Live Site

```bash
# Check if site is up
curl -I https://YOUR_USERNAME.github.io/coldcircuit/

# Should return: HTTP/2 200
```

### 3. Test All Pages

Visit these URLs:
- `https://YOUR_USERNAME.github.io/coldcircuit/`
- `https://YOUR_USERNAME.github.io/coldcircuit/trade-log.html`
- `https://YOUR_USERNAME.github.io/coldcircuit/strategy.html`
- `https://YOUR_USERNAME.github.io/coldcircuit/about.html`

All should load correctly with ColdCircuit branding.

---

## Update Workflow

### Daily Routine

1. **Blog auto-updates** (cron at 6:05pm)
2. **Git auto-pushes** to GitHub
3. **GitHub Pages auto-deploys** (1-2 minutes)
4. **Site is live** with fresh data

### Manual Update

```bash
# 1. Update blog
cd ~/.openclaw/workspace
python3 crypto/blog-updater.py

# 2. Push to GitHub
cd crypto-blog
git add .
git commit -m "Manual update $(date +%Y-%m-%d)"
git push

# 3. Wait 1-2 minutes for GitHub Pages to rebuild
```

---

## Troubleshooting

### Site not updating?

**Check build status:**
1. Go to repo → Actions tab
2. Look for failed builds (red X)
3. Click to see error logs

**Common issues:**
- Git push failed (check SSH keys)
- Build timeout (shouldn't happen with static site)
- DNS not propagated (for custom domains)

### 404 errors?

**Check paths:**
- All links should be relative: `./index.html`, `./css/style.css`
- No absolute paths like `/index.html` (breaks on GitHub Pages subpaths)
- Verify files are in repo root (not subdirectory)

**Verify structure:**
```
repo/
├── index.html
├── trade-log.html
├── strategy.html
├── about.html
└── css/
    └── style.css
```

### CSS not loading?

**Check link tags:**
```html
<!-- Correct (relative) -->
<link rel="stylesheet" href="./css/style.css">

<!-- Wrong (absolute) -->
<link rel="stylesheet" href="/css/style.css">
```

### Custom domain not working?

1. Wait 24-48 hours for DNS propagation
2. Check DNS records: `dig coldcircuit.io`
3. Verify GitHub Pages custom domain setting
4. Check "Enforce HTTPS" after DNS propagates

---

## Update Twitter Bio

Once your site is live:

1. Go to Twitter/X → Edit Profile
2. Update bio:
   ```
   AI-managed crypto trading. Fully transparent.
   coldcircuit.io
   ```
3. Pin a tweet:
   ```
   Launching ColdCircuit - an AI-managed crypto portfolio experiment.

   Every trade logged. Every decision explained. No hype, just data.

   Live dashboard: coldcircuit.io
   Strategy: RSI + EMA swing trading
   Portfolio: $55 (starting)

   Follow for daily updates and weekly performance threads.
   ```

---

## Sharing Your Site

### Twitter Announcement

```
Launching ColdCircuit 🤖

An AI-managed crypto portfolio experiment. Starting with $55.

Every trade is logged. Every decision is transparent.

Live dashboard: coldcircuit.io

No hype. No guarantees. Just data.

Let's see if algorithmic discipline can beat human emotion.
```

### Reddit (r/algotrading, r/CryptoCurrency)

```
Title: Built an AI crypto trading bot - sharing performance publicly

I'm running an experiment: can algorithmic trading beat emotional human decisions in crypto?

Starting portfolio: $55
Strategy: RSI + EMA swing trading with momentum rotation
Platform: Coinbase (via Python API)

Every trade is logged with reasoning at coldcircuit.io

This isn't a paid service. Not selling anything. Just documenting the journey publicly.

Happy to answer questions about the strategy or tech stack.
```

---

## Monitoring

### Check Site Health

```bash
# Daily site check
curl -I https://coldcircuit.io

# Expected: HTTP/2 200
```

### Monitor Traffic (Optional)

Add privacy-friendly analytics:

1. **Plausible** (privacy-focused, paid)
2. **GoatCounter** (privacy-focused, free)
3. **Simple Analytics** (privacy-focused, paid)

Add to `<head>` of all HTML files:

```html
<script defer data-domain="coldcircuit.io" src="https://plausible.io/js/script.js"></script>
```

---

## Backup Strategy

### Regular Backups

```bash
# Backup to external drive (weekly)
rsync -av ~/.openclaw/workspace/crypto-blog/ /Volumes/Backup/coldcircuit/

# Backup trade log
cp crypto/trade-log.json ~/Backups/trade-log-$(date +%Y-%m-%d).json
```

### GitHub as Backup

GitHub repo IS your backup. All files are version-controlled.

To recover:
```bash
git clone https://github.com/YOUR_USERNAME/coldcircuit.git
```

---

## Next Steps

- [ ] Deploy to GitHub Pages
- [ ] Set up automated updates (cron + git push)
- [ ] Share live URL on Twitter
- [ ] Pin announcement tweet
- [ ] Update Twitter bio with coldcircuit.io
- [ ] Consider custom domain (coldcircuit.io)
- [ ] Add privacy-friendly analytics (optional)

---

## Support

**Common issues:**
- Check DEPLOYMENT.md for alternative hosting options
- Check BRANDING.md for content guidelines
- Check QUICK-START.md for usage examples

**Still stuck?**
- GitHub Pages docs: https://docs.github.com/en/pages
- Test locally first: `python3 -m http.server 8000`

---

**Your site is ready to go live. Deploy and start building in public.**

Estimated deployment time: **5 minutes**
