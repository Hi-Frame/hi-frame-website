param(
  [Parameter(Mandatory = $true)][string]$InPath,
  [Parameter(Mandatory = $true)][string]$OutDir
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

function Save-Crop(
  [Parameter(Mandatory = $true)][System.Drawing.Bitmap]$Src,
  [Parameter(Mandatory = $true)][int]$X,
  [Parameter(Mandatory = $true)][int]$Y,
  [Parameter(Mandatory = $true)][int]$W,
  [Parameter(Mandatory = $true)][int]$H,
  [Parameter(Mandatory = $true)][string]$OutPath
) {
  $rect = New-Object System.Drawing.Rectangle($X, $Y, $W, $H)
  $clone = $Src.Clone($rect, $Src.PixelFormat)
  try {
    $clone.Save($OutPath, [System.Drawing.Imaging.ImageFormat]::Png)
  }
  finally {
    $clone.Dispose()
  }
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$bmp = [System.Drawing.Bitmap]::new($InPath)
try {
  # Tuned for the provided screenshot (1024x461).
  # Crops: centered on each thumbnail, avoids neighboring columns.
  Save-Crop -Src $bmp -X 70  -Y 92 -W 170 -H 120 -OutPath (Join-Path $OutDir 'leistung-graphic.png')
  Save-Crop -Src $bmp -X 266 -Y 92 -W 170 -H 120 -OutPath (Join-Path $OutDir 'leistung-media.png')
  Save-Crop -Src $bmp -X 462 -Y 92 -W 170 -H 120 -OutPath (Join-Path $OutDir 'leistung-brand.png')
  Save-Crop -Src $bmp -X 658 -Y 92 -W 170 -H 120 -OutPath (Join-Path $OutDir 'leistung-animation.png')
  Save-Crop -Src $bmp -X 854 -Y 92 -W 170 -H 120 -OutPath (Join-Path $OutDir 'leistung-ai-workshop.png')
}
finally {
  $bmp.Dispose()
}

Write-Output "Cropped images written to $OutDir"
