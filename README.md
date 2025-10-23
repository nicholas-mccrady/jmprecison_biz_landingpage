# JM Precision — Landing Page

This repo contains a minimal static landing page for JM Precision. It's designed to be published on Cloudflare Pages.

Files added:

- `index.html` — the landing page
- `assets/css/styles.css` — simple responsive stylesheet
- `assets/img/flyer-placeholder.svg` — placeholder flyer artwork (replace with your flyer image)

Quick local preview

Open `index.html` in a browser or run a static server. With Python 3 installed:

```powershell
python -m http.server 8000
# then open http://localhost:8000 in your browser
```

Deploying to Cloudflare Pages

1. Commit this repo to GitHub.
2. In the Cloudflare dashboard go to "Pages" and create a new project.
3. Connect your GitHub repo and choose the `main` branch.
4. For a static site use the "None (Static)" framework preset. Set build command to blank and the build output directory to `/`.
5. Deploy and assign a custom domain if desired.

Automating deploys with GitHub Actions

- A workflow was added at `.github/workflows/deploy-pages.yml` that deploys on push to `main` using Cloudflare Pages Action.
- Before the workflow can deploy, add these repository secrets in GitHub Settings → Secrets:
	- `CLOUDFLARE_API_TOKEN` — a token with Pages permissions.
	- `CLOUDFLARE_ACCOUNT_ID` — your Cloudflare account ID (found in the dashboard).

Image optimization (uploading your flyer)

I added a small Node.js script `scripts/optimize-images.js` that converts an input image to WebP optimized for the web (max width 1600px).

Prerequisites:

1. Install Node.js (v16+ recommended).
2. Install the dependency once in the repo root:

```powershell
npm init -y ; npm install sharp --save
```

Example (PowerShell) — convert your flyer (replace paths):

```powershell
# from repo root
node .\scripts\optimize-images.js 'C:\path\to\your\flyer.jpg' .\assets\img\flyer.webp
# then commit and push
git add .\assets\img\flyer.webp ; git commit -m "Add optimized flyer" ; git push
```

Once `assets/img/flyer.webp` exists, `index.html` will use it as the displayed flyer image.

Notes

- Replace contact email/phone/address in `index.html` and replace the placeholder SVG with your actual flyer image (PNG/JPEG/WebP are fine).

