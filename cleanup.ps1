# Exécuter en mode silencieux
$ErrorActionPreference = "SilentlyContinue"

# Définition du fichier de log
$logFile = "C:\nettoyage_resultat.txt"

# Fonction pour obtenir l'espace libre en Go
function Get-FreeSpace {
    return (Get-PSDrive C).Free / 1GB
}

# Espace libre AVANT nettoyage
$beforeCleanup = Get-FreeSpace

# Liste des étapes de nettoyage
$cleanupSteps = @(
    "Suppression des fichiers temporaires utilisateur",
    "Suppression des fichiers temporaires Windows",
    "Vidage de la corbeille",
    "Nettoyage du cache Windows Update",
    "Suppression du cache Microsoft Edge",
    "Suppression des logs système",
    "Suppression du dossier Windows.old",
    "Suppression des fichiers inutiles de mise à jour de Windows",
    "Suppression des fichiers de préchargement (Prefetch)",
    "Suppression des caches Microsoft Store",
    "Suppression du fichier de mise en veille prolongée (hiberfil.sys)",
    "Suppression du cache des polices Windows",
    "Flush DNS cache",
    "Suppression des fichiers d'installation de Windows",
    "Suppression du cache Steam et Epic Games",
    "Suppression des caches Adobe",
    "Suppression des caches des navigateurs Chrome et Firefox",
    "Nettoyage des caches et logs pour Autodesk",
    "Suppression des fichiers temporaires de Rhino",
    "Nettoyage du cache Archicad",
    "Suppression des bibliothèques temporaires de rendu (V-Ray, Enscape, Lumion)",
    "Nettoyage des fichiers temporaires et du cache Office",
    "Optimisation du disque",
    "Compression du disque pour gagner de l'espace",
    "Suppression du dossier de téléchargement Autodesk",
    "Suppression des applications inutiles"
)

# Fonction pour afficher la barre de progression
function Show-Progress {
    param (
        [string]$Step,
        [int]$CurrentStep,
        [int]$TotalSteps
    )

    $percentComplete = ($CurrentStep / $TotalSteps) * 100

    Write-Progress -PercentComplete $percentComplete `
        -Activity "Nettoyage du système" `
        -Status $Step `
        -CurrentOperation "$CurrentStep / $TotalSteps"
}

# Boucle de nettoyage avec progression
$stepCount = $cleanupSteps.Length
$currentStep = 1

foreach ($step in $cleanupSteps) {
    Show-Progress -Step $step -CurrentStep $currentStep -TotalSteps $stepCount
    switch ($step) {
        "Suppression des fichiers temporaires utilisateur" {
            Remove-Item -Path "$env:TEMP\*" -Recurse -Force
        }
        "Suppression des fichiers temporaires Windows" {
            Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force
        }
        "Vidage de la corbeille" {
            Clear-RecycleBin -Force
        }
        "Nettoyage du cache Windows Update" {
            Stop-Service wuauserv -Force
            Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force
            Start-Service wuauserv
        }
        "Suppression du cache Microsoft Edge" {
            Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*" -Recurse -Force
        }
        "Suppression des logs système" {
            Remove-Item -Path "C:\Windows\Logs\*" -Recurse -Force
        }
        "Suppression du dossier Windows.old" {
            if (Test-Path "C:\Windows.old") {
                Takeown /F C:\Windows.old /R /D Y | Out-Null
                icacls C:\Windows.old /grant Administrateurs:F /T | Out-Null
                Remove-Item -Path "C:\Windows.old" -Recurse -Force
            }
        }
        "Suppression des fichiers inutiles de mise à jour de Windows" {
            Dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase | Out-Null
        }
        "Suppression des fichiers de préchargement (Prefetch)" {
            Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force
        }
        "Suppression des caches Microsoft Store" {
            Remove-Item -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalCache\*" -Recurse -Force
        }
        "Suppression du fichier de mise en veille prolongée (hiberfil.sys)" {
            powercfg -h off
        }
        "Suppression du cache des polices Windows" {
            Remove-Item -Path "C:\Windows\ServiceProfiles\LocalService\AppData\Local\FontCache\*" -Recurse -Force
        }
        "Flush DNS cache" {
            ipconfig /flushdns
        }
        "Suppression des fichiers d'installation de Windows" {
            Remove-Item -Path "C:\$WINDOWS.~BT" -Recurse -Force
            Remove-Item -Path "C:\$WINDOWS.~WS" -Recurse -Force
        }
        "Suppression du cache Steam et Epic Games" {
            Remove-Item -Path "$env:LOCALAPPDATA\Steam\htmlcache\*" -Recurse -Force
            Remove-Item -Path "$env:LOCALAPPDATA\EpicGamesLauncher\Saved\webcache\*" -Recurse -Force
        }
        "Suppression des caches Adobe" {
            Remove-Item -Path "$env:APPDATA\Adobe\Common\Media Cache\*" -Recurse -Force
            Remove-Item -Path "$env:APPDATA\Adobe\Common\Media Cache Files\*" -Recurse -Force
        }
        "Suppression des caches des navigateurs Chrome et Firefox" {
            Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force
            Remove-Item -Path "$env:APPDATA\Mozilla\Firefox\Profiles\*.default-release\cache2\entries\*" -Recurse -Force
        }
        "Nettoyage des caches et logs pour Autodesk" {
            Remove-Item -Path "$env:APPDATA\Autodesk\AutoCAD\*\Cache\*" -Recurse -Force
            Remove-Item -Path "$env:LOCALAPPDATA\Autodesk\Logs\*" -Recurse -Force
        }
        "Suppression des fichiers temporaires de Rhino" {
            Remove-Item -Path "$env:APPDATA\McNeel\Rhinoceros\*\Temp\*" -Recurse -Force
            Remove-Item -Path "$env:LOCALAPPDATA\McNeel\Rhinoceros\*\Cache\*" -Recurse -Force
        }
        "Nettoyage du cache Archicad" {
            Remove-Item -Path "$env:LOCALAPPDATA\GRAPHISOFT\Cache\*" -Recurse -Force
            Remove-Item -Path "$env:APPDATA\GRAPHISOFT\Logs\*" -Recurse -Force
        }
        "Suppression des bibliothèques temporaires de rendu (V-Ray, Enscape, Lumion)" {
            Remove-Item -Path "$env:LOCALAPPDATA\Chaos Group\*" -Recurse -Force
            Remove-Item -Path "$env:LOCALAPPDATA\Enscape\Cache\*" -Recurse -Force
            Remove-Item -Path "$env:LOCALAPPDATA\Lumion*\Cache\*" -Recurse -Force
        }
        "Nettoyage des fichiers temporaires et du cache Office" {
            Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Office\16.0\OfficeFileCache\*" -Recurse -Force
            Remove-Item -Path "$env:TEMP\Microsoft Office\*" -Recurse -Force
            Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Outlook\RoamCache\*" -Recurse -Force
            Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Office\16.0\Wef\*" -Recurse -Force
            Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Office\16.0\Telemetry\*" -Recurse -Force
        }
        "Optimisation du disque" {
            Optimize-Volume -DriveLetter C -ReTrim -Analyze -Defrag | Out-Null
        }
        "Compression du disque pour gagner de l'espace" {
            compact /CompactOS:always
        }
        "Suppression du dossier de téléchargement Autodesk" {
            Remove-Item -Path "C:\Autodesk" -Recurse -Force
        }
        "Suppression des applications inutiles" {
            Get-AppxPackage -AllUsers *bing* | Remove-AppxPackage
            Get-AppxPackage -AllUsers *xbox* | Remove-AppxPackage
            Get-AppxPackage -AllUsers *solitaire* | Remove-AppxPackage
        }
    }

    # Avancer d'un pas dans l'étape
    $currentStep++
}

# Espace libre APRÈS nettoyage
$afterCleanup = Get-FreeSpace

# Calcul de l'espace libéré
$spaceFreed = $afterCleanup - $beforeCleanup
$spaceFreedMB = $spaceFreed * 1024
$resultText = "`n✅ Nettoyage terminé !`n📌 Espace libéré : $([math]::Round($spaceFreedMB, 2)) Mo ($([math]::Round($spaceFreed, 2)) Go)`n"

# Affichage du résultat dans le terminal
Write-Host $resultText -ForegroundColor Green

# Enregistrement du résultat dans un fichier
$resultText | Out-File -FilePath $logFile -Encoding UTF8 -Append
