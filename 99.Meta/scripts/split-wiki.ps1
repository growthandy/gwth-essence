# split-wiki.ps1 — 50.Wiki/ 를 독립 볼트로 떼어낸다 (Windows 용, split-wiki.sh 와 같은 동작).
# Usage: powershell -ExecutionPolicy Bypass -File 99.Meta\scripts\split-wiki.ps1 C:\path\to\new-vault [-DryRun]
param(
	[Parameter(Mandatory = $true)][string]$Target,
	[switch]$DryRun
)
$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..\..")

if (-not (Test-Path "50.Wiki")) { Write-Error "50.Wiki/ not found — nothing to split"; exit 2 }
if (Test-Path $Target) { Write-Error "refusing: $Target already exists"; exit 1 }

$KitCmds = @("ingest","query","lint","verify","status","reindex","refresh-context","inbox","capture-tabs","audit")
$VaultName = Split-Path -Leaf (Get-Location)
$NewName = Split-Path -Leaf $Target
$BackLink = "obsidian://advanced-uri?vault=" + [uri]::EscapeDataString($VaultName) + "&filepath=" + [uri]::EscapeDataString("0.Map_of_Contents/🏛 나.md")
$FwdLink = "obsidian://advanced-uri?vault=" + [uri]::EscapeDataString($NewName) + "&filepath=index.md"

if ($DryRun) {
	Write-Output "would copy 50.Wiki/ -> $Target"
	Write-Output "would copy .claude/{commands,hooks,settings.json} -> $Target/.claude (50.Wiki/ prefix removed)"
	Write-Output "would append back-link to $Target/Core Context.md: $BackLink"
	Write-Output "paste into 0.Map_of_Contents/📖 위키.md: [$NewName 위키]($FwdLink)"
	exit 0
}

New-Item -ItemType Directory -Path (Join-Path $Target ".claude\commands") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $Target ".claude\hooks") -Force | Out-Null
Copy-Item -Path "50.Wiki\*" -Destination $Target -Recurse -Force
foreach ($c in $KitCmds) {
	$src = ".claude\commands\$c.md"
	if (Test-Path $src) { (Get-Content $src -Raw) -replace "50\.Wiki/", "" | Set-Content (Join-Path $Target ".claude\commands\$c.md") -NoNewline }
}
Get-ChildItem ".claude\hooks\*.sh" | ForEach-Object {
	(Get-Content $_.FullName -Raw) -replace "50\.Wiki/", "" | Set-Content (Join-Path $Target ".claude\hooks\$($_.Name)") -NoNewline
}
Copy-Item ".claude\settings.json" (Join-Path $Target ".claude\settings.json")
Add-Content (Join-Path $Target "Core Context.md") "`n## Mothership`n- 이 위키는 $VaultName 볼트에서 분리됐다. 자화상(Core Context 원본): [$VaultName · 🏛 나]($BackLink)"

Write-Output "split done -> $Target"
Write-Output "next: open $Target as a new vault, install plugins (Claudian, Advanced URI), then paste this into 0.Map_of_Contents/📖 위키.md:"
Write-Output "[$NewName 위키]($FwdLink)"
Write-Output "then delete 50.Wiki/ from this vault once the new vault opens."
