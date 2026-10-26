# 사용법: powershell -File screenshots\shot.ps1 -Tag iter0 -Label "반복 0 (초안)"
param([string]$Tag = "iter0", [string]$Label = "")
$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$harness = "file:///" + ($dir -replace '\\', '/') + "/harness.html"
$lbl = [uri]::EscapeDataString($Label)
$jobs = @(
  @{ mode = "devices";  size = "2300,1000" },
  @{ mode = "sections"; size = "2400,900" },
  @{ mode = "desktop";  size = "2300,1080" }
)
foreach ($j in $jobs) {
  $out = Join-Path $dir ("{0}_{1}.png" -f $Tag, $j.mode)
  Start-Process -Wait $edge -ArgumentList "--headless=new", "--disable-gpu", "--hide-scrollbars",
    "--allow-file-access-from-files", "--virtual-time-budget=5000",
    "--window-size=$($j.size)", "--screenshot=$out", "$harness`?mode=$($j.mode)&label=$lbl"
  Write-Output $out
}
