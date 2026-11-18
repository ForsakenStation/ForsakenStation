> **Language**: **English** | [Español](ROM-Storage-&-Archive-org-ES)

# ROM Storage & Archive.org

## Temporary vs Permanent Storage
- **Temporary (`ROM_TEMP_PATH`)**: Downloaded ROMs are stored temporarily and cleaned up after the emulator closes. After playing, Forsaken offers to save the ROM permanently.
- **Permanent (`ROM_FOREVER_PATH`)**: Saved or extracted ROMs stay on disk and appear in the **Downloaded** collection.
- Manage, move, or delete stored ROMs in **Settings → ROM Storage Management**.

## Archive.org Credentials
Some Archive.org items require authentication (`401` / `403` errors). Configure your free Archive.org S3 API keys in **Settings → Archive.org Settings**:
- **Access Key** & **Secret Key** from `https://archive.org/account/s3.php`
- Credentials are preserved automatically across Archive.org CDN redirects (`archive.org` → `ia*.us.archive.org`).
