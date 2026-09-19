# Publishing Checklist

This folder is intentionally separate from the internal authoring pipeline. Publish only this folder to the public GitHub repository.

## 1. Complete The External-Publication Gate

Before making the repository public, record written confirmation that:

- all three authors approve open-internet distribution and CC BY 4.0 licensing;
- required Microsoft and Lonza external-publication, intellectual-property, privacy, brand, and communications reviews are complete;
- every figure, quotation, trademark, and third-party reference can be distributed under the stated terms or is clearly excluded from the license;
- the paper contains no confidential, customer, personal, or internal-only information;
- time-sensitive FDA, EU Annex 11, and EU Annex 22 statements have been reverified as of the public release date;
- the public PDF carries the final author attribution, disclaimer, license notice, publication date, and version.

Do not treat a personal-opinion disclaimer as a substitute for these permissions.

## 2. Create The GitHub Repository

Create an empty public repository named `validated-by-design`. Do not initialize it with a README, license, or `.gitignore`, because those files are already present here.

From this folder, run:

```powershell
git init -b main
git add .
git commit -m "Publish Validated-by-Design Book 1"
git remote add origin https://github.com/corradoi/validated-by-design.git
git push -u origin main
```

Alternatively, with GitHub CLI authenticated:

```powershell
git init -b main
git add .
git commit -m "Publish Validated-by-Design Book 1"
gh repo create validated-by-design --public --source . --remote origin --push
```

## 3. Enable GitHub Pages

In **Settings > Pages**, select **Deploy from a branch**, choose `main`, and publish from `/(root)`. The landing page is `index.html`, and the expected public URL is `https://corradoi.github.io/validated-by-design/`.

## 4. Create An Immutable Release

1. Draft a GitHub release using tag `v1.0.1`.
2. Use the contents of `releases/v1.0.1/RELEASE-NOTES.md` as the release notes.
3. Attach `validated-by-design-book-1-v1.0.1.pdf` as a release asset.
4. Verify the attached file against `SHA256SUMS.txt`.
5. Publish the release only after all assets are present.

## 5. Archive With Zenodo

Connect the repository in Zenodo before publishing the GitHub release. After Zenodo archives `v1.0.1`:

- add the version DOI and concept DOI to `README.md`;
- add the DOI and repository URL to `CITATION.cff`;
- add a Zenodo DOI badge to `README.md`;
- use the DOI as the durable target in LinkedIn and other external posts.

## 6. Social Release

Publish a concise LinkedIn post with the central message, three practical takeaways, and the DOI. A longer LinkedIn article should be an adaptation rather than a second authoritative copy and should backlink to the DOI.
