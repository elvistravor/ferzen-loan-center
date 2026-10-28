# Deploy LoanPro from an Android phone (Render)

This project uses SQLite, so it needs a persistent disk. The included `render.yaml` configures a Render web service with a persistent disk mounted at `/var/data`. Persistent disks require a paid Render service; do not remove the disk if you want to retain records.

## 1. Put the project on GitHub
1. Download and extract `LoanPro-Completed-Project.zip` on a computer if available. If you only have a phone, use a trusted ZIP/file manager and GitHub's website.
2. On GitHub, create a **private** repository named `loanpro`.
3. Upload the contents of the `loanpro-project` folder into the repository root. Make sure `render.yaml`, `server.js`, `package.json`, `public/`, and `.env.example` are at the root. Do not upload `.env`, any database file, passwords, or real borrower data.

## 2. Create the Render service
1. Open https://render.com/ in Chrome and create/sign in to your account.
2. Connect GitHub when asked.
3. In Render, choose **New** → **Blueprint** (or create a Web Service from the repository if Blueprint is not offered).
4. Select the private `loanpro` repository and deploy the Blueprint. Review the paid service and persistent disk charges before confirming.
5. Wait for the first deployment to finish. Render should create `SESSION_SECRET` and `SETUP_KEY` from the blueprint and set `DB_FILE=/var/data/loanpro.sqlite`.

## 3. Create the owner account
1. Open the deployed HTTPS `onrender.com` URL.
2. In Render Dashboard → your LoanPro service → **Environment**, find `SETUP_KEY`. Reveal/copy it privately; never post it in chat or share it with staff.
3. On LoanPro's first-run setup screen, enter that key, your full name, an owner username, and a unique password of at least 12 characters.
4. After the owner account is created, the setup endpoint permanently refuses another owner setup while the database remains intact. Keep the setup key private; rotate/remove it after confirming the owner account works. If you remove it before owner setup, initial setup will fail.
5. Sign in and create separate staff accounts from **Staff accounts**. Never share the owner login.

## 4. Verify persistence and security
- Add a test borrower and loan. Restart/redeploy the service, then confirm the records remain.
- Confirm the URL uses HTTPS.
- Keep the Render disk attached. A disk protects against ordinary redeploys but is not a backup. Set up and test encrypted backups to a separate location before storing real records.
- Do not store real customer data until you have reviewed the applicable Uganda privacy/data-protection and lending requirements, access controls, backup/restore procedures, and interest calculations.

## Notes
- The persistent disk is a paid hosting feature. Review Render's current prices before deployment.
- If Render does not offer Blueprint deployment, create a Node web service with build command `npm install`, start command `npm start`, health check `/api/setup-status`, and attach a persistent disk mounted at `/var/data`. Set `NODE_ENV=production`, `DB_FILE=/var/data/loanpro.sqlite`, and generate long random values for `SESSION_SECRET` and `SETUP_KEY`.
- Do not set `DB_FILE` to the repository folder on ephemeral hosting; records can be lost on redeploy.


## Ferzen Loan Services client registration update
The updated version includes client passport photo, National ID front and back uploads, NIN, phone/SIM registered name, employment/income, address, and next-of-kin details. Keep UPLOAD_DIR on the persistent disk (defaults to a directory beside DB_FILE). Re-deploy after uploading the new ZIP. The provided image is used as the browser/app icon.

### Client consent and owner client filters

When registering a client, explain the consent statement and have the client tick the consent checkbox and sign the signature box with a finger or stylus. Registration is blocked if consent or a signature is missing. The system records the signed-consent timestamp and the signed-in staff member who created the record. In the Clients/Borrowers list, the owner can filter by registering officer and date, search by name/phone/NIN/address, filter by loan and consent status, and sort by registration date, name, or officer.
