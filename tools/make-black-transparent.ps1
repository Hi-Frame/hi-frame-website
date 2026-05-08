param(
  [Parameter(Mandatory=$true)][string]$InPath,
  [Parameter(Mandatory=$true)][string]$OutPath,
  [int]$Threshold = 10
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::new($InPath)
try {
  for ($y = 0; $y -lt $bmp.Height; $y++) {
    for ($x = 0; $x -lt $bmp.Width; $x++) {
      $c = $bmp.GetPixel($x, $y)
      if ($c.R -lt $Threshold -and $c.G -lt $Threshold -and $c.B -lt $Threshold) {
        $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, $c.R, $c.G, $c.B))
      }
    }
  }

  $bmp.Save($OutPath, [System.Drawing.Imaging.ImageFormat]::Png)
}
finally {
  $bmp.Dispose()
}

Write-Output "Wrote $OutPath"

