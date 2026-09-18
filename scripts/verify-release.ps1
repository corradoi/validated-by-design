[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$expectedPdfHash = 'C56411ED86E86953DC834612ED601338702A9C30B1C693C333EFB195F0A68342'
$pdfRelativePath = 'releases/v1.0.0/validated-by-design-book-1-v1.0.0.pdf'
$requiredFiles = @(
    '.nojekyll',
    '.zenodo.json',
    'CITATION.cff',
    'LICENSE',
    'PUBLISHING.md',
    'README.md',
    'index.html',
    $pdfRelativePath,
    'releases/v1.0.0/RELEASE-NOTES.md',
    'releases/v1.0.0/SHA256SUMS.txt'
)

$failures = [System.Collections.Generic.List[string]]::new()

foreach ($relativePath in $requiredFiles) {
    $absolutePath = Join-Path $repositoryRoot $relativePath
    if (-not (Test-Path -LiteralPath $absolutePath -PathType Leaf)) {
        $failures.Add("Missing required file: $relativePath")
    }
}

try {
    Get-Content -LiteralPath (Join-Path $repositoryRoot '.zenodo.json') -Raw |
        ConvertFrom-Json |
        Out-Null
}
catch {
    $failures.Add("Invalid .zenodo.json: $($_.Exception.Message)")
}

$pdfPath = Join-Path $repositoryRoot $pdfRelativePath
if (Test-Path -LiteralPath $pdfPath -PathType Leaf) {
    $actualPdfHash = (Get-FileHash -LiteralPath $pdfPath -Algorithm SHA256).Hash
    if ($actualPdfHash -ne $expectedPdfHash) {
        $failures.Add("PDF hash mismatch. Expected $expectedPdfHash; received $actualPdfHash")
    }
}

$landingPage = Get-Content -LiteralPath (Join-Path $repositoryRoot 'index.html') -Raw
if ($landingPage -notmatch [regex]::Escape($pdfRelativePath)) {
    $failures.Add('The landing page does not link to the canonical PDF.')
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "Release verification passed. PDF SHA-256: $expectedPdfHash"
