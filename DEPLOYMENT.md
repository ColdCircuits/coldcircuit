# Deployment Guide

Complete guide to deploying your crypto trading blog to the web.

## Prerequisites

- GitHub account
- Blog files in `crypto-blog/` directory
- Working blog-updater.py script

## Option 1: GitHub Pages (Recommended)

### Initial Setup

1. **Create new GitHub repository**

```bash
# On GitHub.com, create new repo: crypto-trading-blog
# Keep it public (for GitHub Pages free tier)
```

2. **Initialize and push**

```bash
cd ~/.openclaw/workspace/crypto-blog

# Initialize git
git init
git add .
git commit -m "Initial commit: AI crypto trading blog"

# Connect to GitHub
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/crypto-trading-blog.git
git push -u origin main
```

3. **Enable GitHub Pages**

- Go to repository Settings
- Click "Pages" in left sidebar
- Under "Source", select "Deploy from a branch"
- Select branch: `main`
- Select folder: `/ (root)`
- Click "Save"

4. **Wait 2-3 minutes**

Your site will be live at:
```
https://YOUR_USERNAME.github.io/crypto-trading-blog/
```

### Update Workflow

After running `blog-updater.py`:

```bash
cd ~/.openclaw/workspace/crypto-blog

git add .
git commit -m "Update $(date +%Y-%m-%d)"
git push
```

GitHub Pages will automatically rebuild and deploy (takes ~1 minute).

### Automate Updates

Add to your crontab:

```bash
crontab -e
```

Add this line:

```cron
# Update blog and push to GitHub daily at 6:05pm
5 18 * * * cd ~/.openclaw/workspace && python3 crypto/blog-updater.py && cd crypto-blog && git add . && git commit -m "Update $(date +\%Y-\%m-\%d)" && git push >> ~/logs/blog-deploy.log 2>&1
```

**Note:** You'll need to set up SSH keys for password-less git push:

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy public key
cat ~/.ssh/id_ed25519.pub

# Add to GitHub:
# Settings → SSH and GPG keys → New SSH key
# Paste the public key
```

Then update your git remote:

```bash
cd crypto-blog
git remote set-url origin git@github.com:YOUR_USERNAME/crypto-trading-blog.git
```

### Custom Domain (Optional)

1. **Buy a domain** (e.g., `joshminer.com` or `aitrading.xyz`)

2. **Configure DNS** (at your domain registrar)

Add these records:

```
Type: A     Name: @     Value: 185.199.108.153
Type: A     Name: @     Value: 185.199.109.153
Type: A     Name: @     Value: 185.199.110.153
Type: A     Name: @     Value: 185.199.111.153
Type: CNAME Name: www   Value: YOUR_USERNAME.github.io
```

3. **Configure GitHub Pages**

- Go to repo Settings → Pages
- Under "Custom domain", enter your domain (e.g., `aitrading.xyz`)
- Check "Enforce HTTPS" (after DNS propagates)
- Click "Save"

4. **Wait for DNS propagation** (can take 24-48 hours)

## Option 2: Netlify

### Initial Setup

1. **Create Netlify account** at netlify.com

2. **Deploy via drag-and-drop**

- Log in to Netlify
- Click "Add new site" → "Deploy manually"
- Drag the `crypto-blog/` folder into the browser
- Wait ~30 seconds

Your site is live at: `https://random-name.netlify.app`

### Update Workflow

**Manual updates:**

```bash
cd ~/.openclaw/workspace
python3 crypto/blog-updater.py
cd crypto-blog
zip -r blog-update.zip *
```

Then drag `blog-update.zip` to Netlify dashboard → Deploys → Drag & Drop

**Automated via CLI:**

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Login
netlify login

# Link site
cd crypto-blog
netlify link

# Deploy
netlify deploy --prod --dir=.
```

Add to crontab:

```cron
5 18 * * * cd ~/.openclaw/workspace && python3 crypto/blog-updater.py && cd crypto-blog && netlify deploy --prod --dir=. >> ~/logs/netlify-deploy.log 2>&1
```

### Custom Domain on Netlify

1. Go to Site settings → Domain management
2. Add custom domain
3. Follow DNS configuration instructions
4. Netlify auto-provisions SSL certificate

## Option 3: Vercel

Similar to Netlify, but with different CLI:

```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
cd crypto-blog
vercel --prod
```

## Option 4: Self-Hosted

### Simple: Python Server

```bash
cd crypto-blog
python3 -m http.server 8000
```

Access at `http://localhost:8000`

**Not recommended for production** (no HTTPS, single-threaded)

### Production: Nginx

1. **Install Nginx** (on a VPS like DigitalOcean, Linode, etc.)

```bash
sudo apt update
sudo apt install nginx
```

2. **Copy files to server**

```bash
scp -r crypto-blog/* user@your-server:/var/www/crypto-blog/
```

3. **Configure Nginx**

```bash
sudo nano /etc/nginx/sites-available/crypto-blog
```

Add:

```nginx
server {
    listen 80;
    server_name yourdomain.com;
    root /var/www/crypto-blog;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

4. **Enable site**

```bash
sudo ln -s /etc/nginx/sites-available/crypto-blog /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

5. **Add SSL with Let's Encrypt**

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d yourdomain.com
```

### Update workflow (self-hosted):

```bash
# On your Mac
cd ~/.openclaw/workspace
python3 crypto/blog-updater.py
scp -r crypto-blog/* user@your-server:/var/www/crypto-blog/
```

Automate with cron:

```cron
5 18 * * * cd ~/.openclaw/workspace && python3 crypto/blog-updater.py && scp -r crypto-blog/* user@your-server:/var/www/crypto-blog/ >> ~/logs/deploy.log 2>&1
```

## Post-Deployment Checklist

- [ ] Blog is accessible at your URL
- [ ] All pages load correctly (Dashboard, Trade Log, Strategy, About)
- [ ] Charts render properly
- [ ] Mobile view looks good
- [ ] Update Twitter content with live blog URL
- [ ] Test automated update workflow
- [ ] Monitor logs for errors

## Update Blog URL in Content

After deployment, update references:

1. **In Twitter content generator:**

```bash
nano crypto/twitter-content.py
```

Find: `[blog URL here]`

Replace with: `https://yourusername.github.io/crypto-trading-blog/`

2. **Regenerate content:**

```bash
python3 crypto/twitter-content.py
```

## Monitoring

### Check deployment success:

```bash
# GitHub Pages
curl -I https://yourusername.github.io/crypto-trading-blog/

# Should return: HTTP/2 200

# Check logs
tail -f ~/logs/blog-deploy.log
```

### Test automated updates:

```bash
# Make a small change
echo "<!-- Test $(date) -->" >> crypto-blog/index.html

# Commit and push
cd crypto-blog
git add .
git commit -m "Test deployment"
git push

# Check live site in 1-2 minutes
```

## Troubleshooting

### GitHub Pages not updating?

- Check Actions tab in GitHub repo for build errors
- Verify GitHub Pages is enabled in Settings
- Clear browser cache

### 404 errors?

- Check that `index.html` is in root directory
- Verify file names are lowercase
- Check GitHub Pages source is set to `main` branch, `/ (root)`

### Charts not rendering?

- Open browser console (F12)
- Look for JavaScript errors
- Verify `blog-updater.py` ran successfully
- Check that placeholders like `{{PORTFOLIO_DATA}}` are replaced

### Deployment fails?

```bash
# Check git status
cd crypto-blog
git status

# Check logs
tail -50 ~/logs/blog-deploy.log

# Test manual push
git push -v
```

## Performance Tips

1. **Minify CSS** (optional):

```bash
# Install csso
npm install -g csso-cli

# Minify
csso crypto-blog/css/style.css -o crypto-blog/css/style.min.css
```

Update HTML to reference `style.min.css`

2. **Enable gzip** (Nginx):

```nginx
gzip on;
gzip_types text/css application/javascript;
```

3. **Add caching headers** (Nginx):

```nginx
location ~* \.(css|js)$ {
    expires 7d;
    add_header Cache-Control "public, immutable";
}
```

## Security

1. **Enable HTTPS** (always)
   - GitHub Pages: Automatic with custom domain
   - Netlify: Automatic
   - Self-hosted: Use Let's Encrypt

2. **No sensitive data** in public repo
   - Never commit API keys
   - Never commit `.env` files
   - Add `.gitignore`:

```bash
# In crypto-blog/.gitignore
*.log
*.env
.DS_Store
```

3. **Rate limiting** (self-hosted)

```nginx
limit_req_zone $binary_remote_addr zone=one:10m rate=10r/s;

server {
    location / {
        limit_req zone=one burst=20;
    }
}
```

## Next Steps

- [ ] Deploy to production
- [ ] Share URL on Twitter
- [ ] Monitor traffic (optional: add privacy-friendly analytics like Plausible)
- [ ] Set up automated updates
- [ ] Add custom domain (optional)

---

Your blog is now live. Start building in public.
