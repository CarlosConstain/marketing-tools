<#
.SYNOPSIS
    Descarga un video de YouTube y lo particiona en archivos de tamaño fijo.
.DESCRIPTION
    Usa yt-dlp.exe para descargar el mejor formato disponible y ffmpeg.exe
    para dividirlo en segmentos de ~N MB cada uno.
.PARAMETER Url
    URL del video de YouTube (obligatorio).
.PARAMETER PartSizeMB
    Tamaño objetivo por parte en MB (por defecto: 14).
.PARAMETER OutputDir
    Carpeta donde guardar la descarga y las particiones (por defecto: C:\YT).
.PARAMETER KeepVideo
    Conservar el video completo después de partir (por defecto: $false).
.EXAMPLE
    .\download-video.ps1 -Url "https://youtu.be/abcd1234"
    .\download-video.ps1 -Url "https://youtu.be/abcd1234" -PartSizeMB 20
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Url,

    [Parameter(Mandatory = $false)]
    [int]$PartSizeMB = 14,

    [Parameter(Mandatory = $false)]
    [string]$OutputDir = "C:\YT",

    [Parameter(Mandatory = $false)]
    [switch]$KeepVideo
)

$ErrorActionPreference = "Stop"

# ── Validar herramientas ──────────────────────────────────────────────
$ytdlp = Join-Path $OutputDir "yt-dlp.exe"
$ffmpeg = Join-Path $OutputDir "ffmpeg.exe"

if (-not (Test-Path $ytdlp)) { throw "No se encuentra yt-dlp.exe en $OutputDir" }
if (-not (Test-Path $ffmpeg)) { throw "No se encuentra ffmpeg.exe en $OutputDir" }

# ── Crear carpeta de particiones ─────────────────────────────────────
$partDir = Join-Path $OutputDir "particion"
New-Item -ItemType Directory -Path $partDir -Force | Out-Null

# ── Descargar video (nombre limpio) ──────────────────────────────────
Write-Host "Descargando video..." -ForegroundColor Cyan
$outputTemplate = Join-Path $OutputDir "video_%(id)s.%(ext)s"

$ytArgs = @(
    "-f", "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"
    "--output", $outputTemplate
    "--merge-output-format", "mp4"
    "--no-playlist"
    "--no-warnings"
    $Url
)

& $ytdlp $ytArgs 2>&1
if ($LASTEXITCODE -ne 0) { throw "yt-dlp falló con código $LASTEXITCODE" }

# ── Encontrar el archivo descargado ──────────────────────────────────
$videoFile = Get-ChildItem (Join-Path $OutputDir "*.mp4") | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $videoFile) { throw "No se encontró el video descargado" }

Write-Host "Video descargado: $($videoFile.Name) ($([math]::Round($videoFile.Length / 1MB, 2)) MB)" -ForegroundColor Green

# ── Obtener duración del video (redirigir stderr a archivo) ───────────
$ffprobeFile = Join-Path $OutputDir "_ffprobe_tmp.txt"
& $ffmpeg -i $videoFile.FullName -f null - 2> $ffprobeFile
$ffprobeOut = Get-Content $ffprobeFile -Raw
Remove-Item $ffprobeFile -Force -ErrorAction SilentlyContinue
$durationMatch = [regex]::Match($ffprobeOut, "Duration: (\d+):(\d+):(\d+)\.(\d+)")
if (-not $durationMatch.Success) { throw "No se pudo leer la duración del video" }

$h, $m, $s, $ms = $durationMatch.Groups[1..4].Value
$totalSeconds = [int]$h * 3600 + [int]$m * 60 + [int]$s + [int]$ms / 100

# ── Calcular segment_time para ~PartSizeMB por parte ─────────────────
$targetBytes = $PartSizeMB * 1MB
$segmentTime = [math]::Max(1, [int](($targetBytes * $totalSeconds) / $videoFile.Length))

$totalPartsExpected = [math]::Ceiling($totalSeconds / $segmentTime)
Write-Host "Dividiendo en ~$PartSizeMB MB c/u ($totalPartsExpected partes esperadas)..." -ForegroundColor Cyan

# ── Particionar con ffmpeg ───────────────────────────────────────────
$ffArgs = @(
    "-i", $videoFile.FullName
    "-c", "copy"
    "-map", "0"
    "-f", "segment"
    "-segment_time", $segmentTime
    "-reset_timestamps", "1"
    (Join-Path $partDir "part_%03d.mp4")
)

& $ffmpeg $ffArgs 2>&1
if ($LASTEXITCODE -ne 0) { throw "ffmpeg falló con código $LASTEXITCODE" }

# ── Mostrar resumen ──────────────────────────────────────────────────
$parts = Get-ChildItem $partDir -Filter "*.mp4" | Sort-Object Name
$totalParts = $parts.Count
$totalSize = ($parts | Measure-Object -Property Length -Sum).Sum

Write-Host "`nCompletado!" -ForegroundColor Green
Write-Host "  Partes creadas: $totalParts" -ForegroundColor Yellow
Write-Host "  Tamaño total: $([math]::Round($totalSize / 1MB, 2)) MB" -ForegroundColor Yellow
Write-Host "  Carpeta: $partDir" -ForegroundColor Yellow
Write-Host "`nArchivos generados:" -ForegroundColor Cyan
$parts | Select-Object Name, @{N="SizeMB";E={[math]::Round($_.Length/1MB, 2)}} | Format-Table -AutoSize

# ── Limpiar video completo a menos que se pida conservarlo ──────────
if (-not $KeepVideo) {
    Remove-Item $videoFile.FullName -Force
    Write-Host "Video completo eliminado (usa -KeepVideo para conservarlo)" -ForegroundColor DarkGray
}
