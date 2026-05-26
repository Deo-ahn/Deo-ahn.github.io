# sync-design.ps1 — pull the latest Claude Design bundle for this site.
#
# Workflow:
#   1. Open your Claude Design project (claude.ai/design/p/<uuid>).
#   2. Use the "Share" / "Export" action to copy a hash URL of the form
#        https://api.anthropic.com/v1/design/h/<HASH>?open_file=index.html
#   3. Run this script with that URL — it downloads the gzipped tar bundle,
#      unpacks it into ./design-import/, and prints the file inventory so
#      you (or Claude Code) can compare it against the live site and pull
#      changes into _layouts/, _sass/, _includes/, etc.
#
# Usage:
#   ./bin/sync-design.ps1 -Url "https://api.anthropic.com/v1/design/h/XXXX?open_file=index.html"
#   ./bin/sync-design.ps1 -Url "..." -Dest "./design-import" -KeepRaw
#
# The bundle is just project files — applying them to the Jekyll layout
# (al-folio plugin overrides, SCSS partials, liquid templates) still
# requires interpreting the design intent into our existing structure.
# This script automates the download/unpack step only.

param(
  [Parameter(Mandatory = $true)]
  [string]$Url,

  [string]$Dest = "./design-import",

  [switch]$KeepRaw
)

if ($Url -notmatch '^https://api\.anthropic\.com/v1/design/h/') {
  Write-Error @"
URL must be a Claude Design share/hash URL of the form
  https://api.anthropic.com/v1/design/h/<HASH>?open_file=index.html

You provided: $Url

Open your design at claude.ai/design/p/<uuid>, hit Share/Export, and
copy the resulting api.anthropic.com URL.
"@
  exit 1
}

if (Test-Path $Dest) {
  Write-Host "Clearing existing $Dest ..." -ForegroundColor DarkGray
  Remove-Item $Dest -Recurse -Force
}
New-Item -ItemType Directory -Path $Dest | Out-Null

$tmpBin = New-TemporaryFile
$tmpTar = New-TemporaryFile

try {
  Write-Host "Downloading design bundle..." -ForegroundColor Cyan
  Invoke-WebRequest -Uri $Url -OutFile $tmpBin.FullName -UseBasicParsing

  $bytes = [System.IO.File]::ReadAllBytes($tmpBin.FullName)
  if ($bytes.Length -lt 2 -or $bytes[0] -ne 0x1F -or $bytes[1] -ne 0x8B) {
    Write-Error "Response is not a gzip bundle (got $($bytes.Length) bytes, magic = $('{0:X2}{1:X2}' -f $bytes[0], $bytes[1])). The hash URL may be expired or the design unpublished."
    exit 2
  }

  Write-Host "Decompressing ($([math]::Round($bytes.Length / 1KB, 1)) KB)..." -ForegroundColor Cyan
  $in  = [System.IO.File]::OpenRead($tmpBin.FullName)
  $gz  = New-Object System.IO.Compression.GZipStream($in, [System.IO.Compression.CompressionMode]::Decompress)
  $out = [System.IO.File]::Create($tmpTar.FullName)
  try { $gz.CopyTo($out) } finally { $gz.Close(); $out.Close(); $in.Close() }

  Write-Host "Extracting tar -> $Dest ..." -ForegroundColor Cyan
  tar -xf $tmpTar.FullName -C $Dest

  if ($KeepRaw) {
    Copy-Item $tmpBin.FullName (Join-Path $Dest "bundle.tar.gz")
  }

  Write-Host ""
  Write-Host "Done. Files:" -ForegroundColor Green
  Get-ChildItem $Dest -Recurse -File |
    Select-Object @{n='path'; e={$_.FullName.Substring((Resolve-Path $Dest).Path.Length + 1)}}, @{n='kb'; e={[math]::Round($_.Length / 1KB, 1)}} |
    Format-Table -AutoSize

  Write-Host "Next: inspect $Dest/personal-page/project/index.html and the *.jsx files," -ForegroundColor Yellow
  Write-Host "      then ask Claude Code to port any diffs into _layouts/_includes/_sass." -ForegroundColor Yellow
}
finally {
  Remove-Item $tmpBin.FullName, $tmpTar.FullName -Force -ErrorAction SilentlyContinue
}
