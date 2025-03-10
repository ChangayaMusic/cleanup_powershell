# Exécuter en mode silencieux
$ErrorActionPreference = "SilentlyContinue"

# Définition du fichier de log
$logFile = "C:\nettoyage_resultat.txt"

# Fonction pour obtenir l'espace libre en Go
function Get-FreeSpace {
    return (Get-PSDrive C).Free / 1GB
}

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

# Fonction pour afficher le menu
function Show-Menu {
    Write-Host "\n===== Menu Nettoyage ====="
    Write-Host "1. Exécuter toutes les actions"
    Write-Host "2. Choisir une action spécifique"
    Write-Host "3. Quitter"
    
    $choice = Read-Host "Choisissez une option (1-3)"
    
    switch ($choice) {
        "1" { return $cleanupSteps }
        "2" {
            Write-Host "\nChoisissez une action :"
            for ($i = 0; $i -lt $cleanupSteps.Length; $i++) {
                Write-Host "$($i + 1). $($cleanupSteps[$i])"
            }
            $actionChoice = Read-Host "Entrez le numéro de l'action"
            return @($cleanupSteps[$actionChoice - 1])
        }
        "3" {
            Write-Host "Fermeture du programme."
            exit
        }
        default {
            Write-Host "Sélection invalide. Veuillez réessayer."
            Show-Menu
        }
    }
}

# Demande de sélection d'actions
$selectedSteps = Show-Menu
if ($selectedSteps -eq $null) {
    Write-Host "Aucune action sélectionnée. Arrêt du script." -ForegroundColor Red
    exit
}

# Espace libre avant nettoyage
$beforeCleanup = Get-FreeSpace
$stepCount = $selectedSteps.Length
$currentStep = 1

# Boucle de nettoyage avec progression
foreach ($step in $selectedSteps) {
    Write-Host "[$currentStep/$stepCount] Exécution: $step"
    # Ajoutez ici les commandes de nettoyage correspondant à chaque action...
    $currentStep++
}

# Espace libre après nettoyage
$afterCleanup = Get-FreeSpace
$spaceFreed = $afterCleanup - $beforeCleanup
Write-Host "\n✅ Nettoyage terminé ! Espace libéré: $([math]::Round($spaceFreed, 2)) Go" -ForegroundColor Green
