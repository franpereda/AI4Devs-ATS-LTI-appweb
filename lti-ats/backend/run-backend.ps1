# run-backend.ps1
# Downloads Maven 3.9.9 locally (into .tools/) if not present, then starts the backend.
# Requires: Java 21 installed and available on PATH or in JAVA_HOME.

$ErrorActionPreference = "Stop"

$toolsDir  = Join-Path $PSScriptRoot ".tools"
$mavenVer  = "3.9.9"
$mavenDir  = Join-Path $toolsDir "apache-maven-$mavenVer"
$mavenZip  = Join-Path $toolsDir "apache-maven-$mavenVer-bin.zip"
$mavenUrl  = "https://archive.apache.org/dist/maven/maven-3/$mavenVer/binaries/apache-maven-$mavenVer-bin.zip"
$mvnExe    = Join-Path $mavenDir "bin\mvn.cmd"

# ── 1. Check Java ──────────────────────────────────────────────────────────────
Write-Host "Checking Java..." -ForegroundColor Cyan

$javaExe = $null

# 1a. Already on PATH?
$onPath = Get-Command java -ErrorAction SilentlyContinue
if ($onPath) {
    $javaExe = $onPath.Source
}

# 1b. Search common installation directories
if (-not $javaExe) {
    $searchRoots = @(
        "C:\Program Files\Eclipse Adoptium",
        "C:\Program Files\Java",
        "C:\Program Files\Microsoft",
        "C:\Program Files\Amazon Corretto",
        "C:\Program Files\BellSoft",
        "C:\Program Files\Zulu"
    )
    foreach ($root in $searchRoots) {
        if (Test-Path $root) {
            $found = Get-ChildItem -Path $root -Filter "java.exe" -Recurse -ErrorAction SilentlyContinue |
                     Where-Object { $_.FullName -match "bin\\java\.exe" } |
                     Select-Object -First 1
            if ($found) {
                $javaExe = $found.FullName
                break
            }
        }
    }
}

if (-not $javaExe) {
    Write-Host ""
    Write-Host "ERROR: Java not found." -ForegroundColor Red
    Write-Host "Install Java 21 with:" -ForegroundColor Yellow
    Write-Host "  winget install EclipseAdoptium.Temurin.21.JDK --accept-package-agreements --accept-source-agreements" -ForegroundColor Yellow
    exit 1
}

# Set JAVA_HOME so Maven can find it
$env:JAVA_HOME = Split-Path (Split-Path $javaExe -Parent) -Parent
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

$javaVersion = & $javaExe --version 2>&1 | Select-Object -First 1
Write-Host "  Found: $javaVersion" -ForegroundColor Green
Write-Host "  JAVA_HOME: $env:JAVA_HOME" -ForegroundColor Gray

# ── 2. Download Maven if not present ──────────────────────────────────────────
if (-not (Test-Path $mvnExe)) {
    Write-Host "Maven not found. Downloading Maven $mavenVer..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path $toolsDir | Out-Null

    Write-Host "  Downloading from $mavenUrl ..." -ForegroundColor Gray
    Invoke-WebRequest -Uri $mavenUrl -OutFile $mavenZip -UseBasicParsing

    Write-Host "  Extracting..." -ForegroundColor Gray
    Expand-Archive -Path $mavenZip -DestinationPath $toolsDir -Force
    Remove-Item $mavenZip

    Write-Host "  Maven $mavenVer ready at $mavenDir" -ForegroundColor Green
} else {
    Write-Host "Maven found at $mavenDir" -ForegroundColor Green
}

# ── 3. Start backend ──────────────────────────────────────────────────────────
Write-Host ""
Write-Host "Starting Spring Boot backend on http://localhost:8080 ..." -ForegroundColor Cyan
Write-Host "(First run will download dependencies - this may take a few minutes)" -ForegroundColor Gray
Write-Host ""

Set-Location $PSScriptRoot
& $mvnExe spring-boot:run
