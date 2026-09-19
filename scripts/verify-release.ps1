[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$expectedPdfHash = '18CF4223204F7C4485C6249902463CA407142D5310BF247EC99C0280052287CE'
$pdfRelativePath = 'releases/v1.0.1/validated-by-design-book-1-v1.0.1.pdf'
$requiredFiles = @(
    '.nojekyll',
    '.zenodo.json',
    'CITATION.cff',
    'LICENSE',
    'PUBLISHING.md',
    'README.md',
    'index.html',
    $pdfRelativePath,
    'releases/v1.0.1/RELEASE-NOTES.md',
    'releases/v1.0.1/SHA256SUMS.txt'
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

$publicText = @(
    'README.md',
    'CITATION.cff',
    '.zenodo.json',
    'index.html',
    'releases/v1.0.1/RELEASE-NOTES.md'
) | ForEach-Object { Get-Content -LiteralPath (Join-Path $repositoryRoot $_) -Raw }
$joinedPublicText = $publicText -join "`n"

if ($joinedPublicText -match 'Telluri') {
    $failures.Add('Public repository text contains the misspelled surname Telluri.')
}

if ($joinedPublicText -notmatch 'Tulluri') {
    $failures.Add('Public repository text does not contain the corrected surname Tulluri.')
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "Release verification passed. PDF SHA-256: $expectedPdfHash"
