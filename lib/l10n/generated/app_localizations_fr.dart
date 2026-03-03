// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Forsaken Emulator';

  @override
  String get retroGamingFrontend => 'Frontend de Jeu Rétro';

  @override
  String get platforms => 'Plateformes';

  @override
  String get roms => 'ROMs';

  @override
  String get settings => 'Paramètres';

  @override
  String get settingsAndConfiguration => 'Paramètres et Configuration';

  @override
  String get aboutForsakenEmulator => 'À propos de Forsaken Emulator';

  @override
  String get version => 'Version';

  @override
  String get appDescription =>
      'Un frontend d\'émulateur multi-plateforme moderne construit avec Flutter.';

  @override
  String get emulators => 'Émulateurs';

  @override
  String get ready => 'Prêt';

  @override
  String get back => 'Retour';

  @override
  String get select => 'Sélectionner';

  @override
  String get search => 'Rechercher';

  @override
  String get refresh => 'Actualiser';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get initializationError => 'Erreur d\'Initialisation';

  @override
  String get retry => 'Réessayer';

  @override
  String get cancel => 'Annuler';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get close => 'Fermer';

  @override
  String get noRomsFound => 'Aucune ROM trouvée';

  @override
  String get noPlatformsFound => 'Aucune plateforme trouvée';

  @override
  String get checkRomsPath => 'Vérifiez la variable d\'environnement ROMS_PATH';

  @override
  String get downloading => 'Téléchargement...';

  @override
  String get downloadComplete => 'Téléchargement terminé';

  @override
  String get downloadFailed => 'Échec du téléchargement';

  @override
  String get emulatorNotFound => 'Émulateur non trouvé';

  @override
  String get romNotFound => 'ROM non trouvée';

  @override
  String get biosRequired => 'BIOS requis';

  @override
  String get systemCheck => 'Vérification Système';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get systemDefault => 'Par défaut du système';

  @override
  String get help => 'Aide';

  @override
  String get keyboardAndGamepadControls => 'Contrôles Clavier et Manette';

  @override
  String get navigation => 'Navigation';

  @override
  String get actions => 'Actions';

  @override
  String get viewControls => 'Contrôles d\'Affichage';

  @override
  String get gotIt => 'Compris!';

  @override
  String get exit => 'Quitter';

  @override
  String get exitApplication => 'Quitter l\'Application';

  @override
  String get exitConfirm => 'Êtes-vous sûr de vouloir quitter?';

  @override
  String get downloadManager => 'Gestionnaire de Téléchargements';

  @override
  String get clearCompleted => 'Effacer Terminés';

  @override
  String get selectCategory => 'Sélectionner une Catégorie';

  @override
  String get confirmDownload => 'Confirmer le Téléchargement';

  @override
  String get downloadGameLists => 'Télécharger les Listes de Jeux';

  @override
  String get downloadGameListsDescription =>
      'Cela téléchargera les listes de ROMs depuis GitHub.';

  @override
  String get gameListsDownloaded => 'Listes de jeux téléchargées!';

  @override
  String get romStorageManagement => 'Gestion du Stockage des ROMs';

  @override
  String get deleteRom => 'Supprimer la ROM?';

  @override
  String deleteRomConfirm(String fileName) {
    return 'Supprimer $fileName?';
  }

  @override
  String get actionCannotBeUndone => 'Cette action ne peut pas être annulée.';

  @override
  String deleted(String fileName) {
    return 'Supprimé: $fileName';
  }

  @override
  String get savePermanently => 'Enregistrer Permanemment?';

  @override
  String moveRomConfirm(String fileName) {
    return 'Déplacer $fileName vers le stockage permanent?';
  }

  @override
  String saved(String fileName) {
    return 'Enregistré: $fileName';
  }

  @override
  String get clearAll => 'Tout Effacer?';

  @override
  String get clearAllConfirm => 'Supprimer toutes les ROMs temporaires?';

  @override
  String get allCleared => 'Toutes les ROMs temporaires effacées';

  @override
  String get systemPathsConfiguration => 'Configuration des Chemins Système';

  @override
  String get migrateRoms => 'Migrer les ROMs?';

  @override
  String get migrateRomsDescription =>
      'Le chemin de stockage permanent des ROMs a changé de \$oldPath vers \$newPath. Voulez-vous migrer les ROMs existantes vers le nouvel emplacement?';

  @override
  String get noKeepThem => 'Non, les garder';

  @override
  String get yesMigrateRoms => 'Oui, migrer les ROMs';

  @override
  String get migratingRoms => 'Migration des ROMs...';

  @override
  String get romMigrationFailed =>
      'Avertissement: La migration des ROMs a échoué';

  @override
  String get pathsSaved => 'Chemins enregistrés avec succès';

  @override
  String get errorSavingPaths =>
      'Erreur lors de l\'enregistrement des chemins:';

  @override
  String get resetConfiguration => 'Réinitialiser la Configuration';

  @override
  String get resetConfigDescription =>
      'Cela réinitialisera tous les chemins à leurs valeurs par défaut. Vos ROMs et fichiers médias ne seront pas affectés.';

  @override
  String get configurationReset =>
      'Configuration réinitialisée aux valeurs par défaut';

  @override
  String get errorResettingConfiguration =>
      'Erreur lors de la réinitialisation de la configuration:';

  @override
  String get savePaths => 'Enregistrer les Chemins';

  @override
  String get saving => 'Enregistrement...';

  @override
  String get emulatorManagement => 'Gestion des Émulateurs';

  @override
  String get configurationReloaded => 'Configuration rechargée';

  @override
  String get errorLoadingEmulators =>
      'Erreur lors du chargement des émulateurs:';

  @override
  String get emulatorAdded => 'Émulateur ajouté avec succès';

  @override
  String get errorAddingEmulator => 'Erreur lors de l\'ajout de l\'émulateur:';

  @override
  String get emulatorUpdated => 'Émulateur mis à jour avec succès';

  @override
  String get errorUpdatingEmulator =>
      'Erreur lors de la mise à jour de l\'émulateur:';

  @override
  String get deleteEmulator => 'Supprimer l\'Émulateur';

  @override
  String get emulatorDeleted => 'Émulateur supprimé';

  @override
  String get errorDeletingEmulator =>
      'Erreur lors de la suppression de l\'émulateur:';

  @override
  String get configurationSource => 'Source de Configuration';

  @override
  String get addEmulator => 'Ajouter un Émulateur';

  @override
  String get systemNameRequired => 'Le nom du système est requis';

  @override
  String get commandRequired => 'Au moins une commande est requise';

  @override
  String get addCommand => 'Ajouter une Commande';

  @override
  String get acceptZipFiles => 'Accepter les fichiers ZIP';

  @override
  String get acceptZipSubtitle =>
      'Permettre le lancement des ROMs depuis des archives ZIP';

  @override
  String get useForeverMode => 'Utiliser le Mode Forever';

  @override
  String get useForeverSubtitle => 'Garder l\'émulateur en cours d\'exécution';

  @override
  String get workInProgress => 'Travail en Cours';

  @override
  String get wipSubtitle => 'Marquer comme pas encore entièrement configuré';

  @override
  String get biosFirmwareHelp => 'Aide BIOS et Firmware';

  @override
  String get downloadMissingFiles => 'Télécharger les Fichiers Manquants';

  @override
  String get showOnlyMissing => 'Afficher seulement les manquants';

  @override
  String get downloadAllMissingBios => 'Télécharger Tous les BIOS Manquants';

  @override
  String get configurationError => 'Erreur de Configuration';

  @override
  String get configurationErrorDescription =>
      'L\'application n\'a pas trouvé la configuration requise.\nVeuillez configurer vos chemins dans Paramètres > Chemins Système.';

  @override
  String get configurationRequired =>
      'Requis:\n- Chemin Médias: répertoire contenant les assets médias\n- Chemin Émulateurs: répertoire contenant les binaires des émulateurs\n\nOptionnel:\n- Chemins de stockage des ROMs pour téléchargements temporaires/permanents';

  @override
  String get goToSettingsToConfigure =>
      'Aller à Paramètres > Chemins Système pour configurer';

  @override
  String get noDownloadableBios => 'Aucun fichier BIOS téléchargeable manquant';

  @override
  String get allDownloadsCompleted =>
      'Tous les téléchargements terminés avec succès!';

  @override
  String get batchDownloadFailed => 'Échec du téléchargement par lot:';

  @override
  String get download => 'Télécharger';

  @override
  String get downloadCancelled => 'Téléchargement annulé';

  @override
  String get launched => 'Lancé:';

  @override
  String get failedToSave => 'Échec de l\'enregistrement permanent de la ROM';

  @override
  String get failedToSaveRom =>
      'Échec de l\'enregistrement permanent de la ROM';

  @override
  String get errorSaving => 'Erreur lors de l\'enregistrement de la ROM:';

  @override
  String errorSavingRom(String error) {
    return 'Erreur lors de l\'enregistrement de la ROM: $error';
  }

  @override
  String get openFolder => 'Ouvrir le Dossier';

  @override
  String get viewManual => 'Voir le Manuel';

  @override
  String get play => 'Jouer';

  @override
  String get goBack => 'Retourner';

  @override
  String get clearSearch => 'Effacer la Recherche';

  @override
  String get iUnderstand => 'Je comprends et j\'accepte ces termes';

  @override
  String get start => 'Démarrer';

  @override
  String get debugMode => 'Mode Débogage: ';

  @override
  String get toggleDebugMode => 'Basculer le Mode Débogage';

  @override
  String get preparingDownload => 'Préparation du téléchargement...';

  @override
  String get noEmulatorsAvailable =>
      'Aucun émulateur disponible pour cette catégorie';

  @override
  String get failedToLaunch => 'Échec du lancement de l\'émulateur web:';

  @override
  String get platformInfo => 'Info Plateforme';

  @override
  String get emulatorPlatformInfo => 'Info Plateforme Émulateur';

  @override
  String get favorites => 'Favoris';

  @override
  String get all => 'Tout';

  @override
  String get collections => 'Collections';

  @override
  String get searchRoms => 'Rechercher des ROMs...';

  @override
  String get searchPlatforms => 'Rechercher des plateformes...';

  @override
  String romsCount(int count) {
    return '$count ROMs';
  }

  @override
  String platformsCount(int count) {
    return '$count plateformes';
  }

  @override
  String get region => 'Région';

  @override
  String get genre => 'Genre';

  @override
  String get year => 'Année';

  @override
  String get publisher => 'Éditeur';

  @override
  String get developer => 'Développeur';

  @override
  String get playWithNetplay => 'Jouer avec Netplay';

  @override
  String get downloadBios => 'Télécharger BIOS';

  @override
  String get viewDetails => 'Voir les Détails';

  @override
  String get addToFavorites => 'Ajouter aux Favoris';

  @override
  String get removeFromFavorites => 'Retirer des Favoris';

  @override
  String get biosMissing => 'BIOS manquant';

  @override
  String get biosPresent => 'BIOS présent';

  @override
  String get checkingBios => 'Vérification du BIOS...';

  @override
  String get emulatorDownloading => 'Téléchargement de l\'émulateur...';

  @override
  String get emulatorDownloadComplete => 'Émulateur téléchargé';

  @override
  String get emulatorDownloadFailed =>
      'Échec du téléchargement de l\'émulateur';

  @override
  String get installingEmulator => 'Installation de l\'émulateur...';

  @override
  String get emulatorReady => 'Émulateur prêt';

  @override
  String get configuration => 'Configuration';

  @override
  String get paths => 'Chemins';

  @override
  String get storage => 'Stockage';

  @override
  String get emulatorsPath => 'Chemin des Émulateurs';

  @override
  String get romsPath => 'Chemin des ROMs';

  @override
  String get mediaPath => 'Chemin des Médias';

  @override
  String get biosPath => 'Chemin du BIOS';

  @override
  String get tempPath => 'Chemin Temporaire';

  @override
  String get browse => 'Parcourir';

  @override
  String get apply => 'Appliquer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get clear => 'Effacer';

  @override
  String get scan => 'Scanner';

  @override
  String get scanForRoms => 'Scanner les ROMs';

  @override
  String get scanningRoms => 'Scan des ROMs...';

  @override
  String get scanComplete => 'Scan terminé';

  @override
  String romsFound(int count) {
    return '$count ROMs trouvées';
  }

  @override
  String get noNewRomsFound => 'Aucune nouvelle ROM trouvée';

  @override
  String get launchEmulator => 'Lancer l\'Émulateur';

  @override
  String get emulatorError => 'Erreur d\'Émulateur';

  @override
  String get gamepadConnected => 'Manette connectée';

  @override
  String get gamepadDisconnected => 'Manette déconnectée';

  @override
  String get gamepadTest => 'Test Manette';

  @override
  String get pressAnyButton => 'Appuyez sur n\'importe quel bouton pour tester';

  @override
  String get buttonA => 'A';

  @override
  String get buttonB => 'B';

  @override
  String get buttonX => 'X';

  @override
  String get buttonY => 'Y';

  @override
  String get buttonStart => 'Start';

  @override
  String get buttonSelect => 'Select';

  @override
  String get dpadUp => 'D-Pad Haut';

  @override
  String get dpadDown => 'D-Pad Bas';

  @override
  String get dpadLeft => 'D-Pad Gauche';

  @override
  String get dpadRight => 'D-Pad Droite';

  @override
  String get leftShoulder => 'L1';

  @override
  String get rightShoulder => 'R1';

  @override
  String get leftTrigger => 'L2';

  @override
  String get rightTrigger => 'R2';

  @override
  String get leftStick => 'Stick Gauche';

  @override
  String get rightStick => 'Stick Droit';

  @override
  String get setupWizard => 'Assistant de Configuration';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get welcomeMessage => 'Bienvenue dans Forsaken Emulator';

  @override
  String get next => 'Suivant';

  @override
  String get previous => 'Précédent';

  @override
  String get finish => 'Terminer';

  @override
  String get skip => 'Passer';

  @override
  String get setupComplete => 'Configuration Terminée';

  @override
  String get selectLanguage => 'Sélectionner la Langue';

  @override
  String get selectEmulatorsPath => 'Sélectionner le Chemin des Émulateurs';

  @override
  String get selectRomsPath => 'Sélectionner le Chemin des ROMs';

  @override
  String get selectMediaPath => 'Sélectionner le Chemin des Médias';

  @override
  String get allSettingsConfigured => 'Tous les paramètres configurés';

  @override
  String get darkTheme => 'Sombre';

  @override
  String get lightTheme => 'Clair';

  @override
  String get systemTheme => 'Système';

  @override
  String get about => 'À propos';

  @override
  String get checkForUpdates => 'Vérifier les Mises à Jour';

  @override
  String get noUpdatesAvailable => 'Aucune mise à jour disponible';

  @override
  String get updateAvailable => 'Mise à jour disponible';

  @override
  String get downloadingUpdate => 'Téléchargement de la mise à jour...';

  @override
  String get installingUpdate => 'Installation de la mise à jour...';

  @override
  String get updateComplete => 'Mise à jour terminée';

  @override
  String get updateFailed => 'Échec de la mise à jour';

  @override
  String get networkError => 'Erreur réseau';

  @override
  String get connectionError => 'Erreur de connexion';

  @override
  String get timeoutError => 'Erreur de délai';

  @override
  String get unknownError => 'Erreur inconnue';

  @override
  String get permissionDenied => 'Permission refusée';

  @override
  String get fileNotFound => 'Fichier non trouvé';

  @override
  String get directoryNotFound => 'Répertoire non trouvé';

  @override
  String get diskFull => 'Disque plein';

  @override
  String get invalidPath => 'Chemin invalide';

  @override
  String get pathNotWritable => 'Chemin non inscriptible';

  @override
  String get romCorrupted => 'Le fichier ROM peut être corrompu';

  @override
  String get zipError => 'Erreur d\'archive ZIP';

  @override
  String get extractionFailed => 'Échec de l\'extraction';

  @override
  String get checksumMismatch => 'Incompatibilité de somme de contrôle';

  @override
  String get biosCheckFailed => 'Échec de la vérification du BIOS';

  @override
  String get continueAnyway => 'Continuer quand même';

  @override
  String get reportIssue => 'Signaler un Problème';

  @override
  String get copyToClipboard => 'Copier dans le presse-papiers';

  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get share => 'Partager';

  @override
  String get hide => 'Masquer';

  @override
  String get show => 'Afficher';

  @override
  String get toggleView => 'Changer la Vue';

  @override
  String get gridView => 'Vue en Grille';

  @override
  String get listView => 'Vue en Liste';

  @override
  String get carouselView => 'Vue en Carrousel';

  @override
  String get sortBy => 'Trier par';

  @override
  String get sortByName => 'Nom';

  @override
  String get sortByDate => 'Date';

  @override
  String get sortBySize => 'Taille';

  @override
  String get sortByRegion => 'Région';

  @override
  String get ascending => 'Croissant';

  @override
  String get descending => 'Décroissant';

  @override
  String get filter => 'Filtrer';

  @override
  String get filterByRegion => 'Filtrer par Région';

  @override
  String get filterByGenre => 'Filtrer par Genre';

  @override
  String get filterByYear => 'Filtrer par Année';

  @override
  String get clearFilters => 'Effacer les Filtres';

  @override
  String get systemInfo => 'Info Système';

  @override
  String get cpu => 'CPU';

  @override
  String get memory => 'Mémoire';

  @override
  String get storageInfo => 'Stockage';

  @override
  String get os => 'Système d\'Exploitation';

  @override
  String get emulatorVersion => 'Version de l\'Émulateur';

  @override
  String get totalRoms => 'Total ROMs';

  @override
  String get totalSize => 'Taille Totale';

  @override
  String get freeSpace => 'Espace Libre';

  @override
  String get usedSpace => 'Espace Utilisé';

  @override
  String get systemUtilities => 'Utilitaires Système';

  @override
  String get romVerificationResults => 'Résultats de Vérification des ROMs';

  @override
  String get totalRomFiles => 'Total fichiers ROM';

  @override
  String get emptyRomFiles => 'Fichiers ROM vides';

  @override
  String get validRomFiles => 'Fichiers ROM valides';

  @override
  String get romsDirectoryDoesNotExist =>
      'Le répertoire des ROMs n\'existe pas';

  @override
  String get gamelistCheckResults => 'Résultats de Vérification des Gamelists';

  @override
  String get totalPlatforms => 'Total plateformes';

  @override
  String get missingGamelists => 'Gamelists manquantes';

  @override
  String get configurationBackup => 'Sauvegarde de Configuration';

  @override
  String get configurationBackedUp => 'Configuration sauvegardée dans:';

  @override
  String get errorBackingUp =>
      'Erreur lors de la sauvegarde de la configuration:';

  @override
  String get romDatabase => 'Base de Données ROMs';

  @override
  String get romDatabaseDownloaded =>
      'Base de données ROMs téléchargée avec succès';

  @override
  String get failedDownloadRomDatabase =>
      'Échec du téléchargement de la base de données ROMs';

  @override
  String get romDatabaseCleared => 'Base de données ROMs effacée';

  @override
  String get failedClearDatabase =>
      'Échec de l\'effacement de la base de données';

  @override
  String get downloadRomDatabase => 'Télécharger la Base de Données ROMs';

  @override
  String get clearRomDatabase => 'Effacer la Base de Données ROMs';

  @override
  String get systemRequirements => 'Exigences Système';

  @override
  String get failedToCheckSystem => 'Échec de la vérification du système';

  @override
  String cleanedUpTempFiles(String deletedCount) {
    return '$deletedCount fichiers ROM temporaires nettoyés';
  }

  @override
  String get errorCleaningTempFiles =>
      'Erreur lors du nettoyage des fichiers temporaires:';

  @override
  String get errorVerifyingRomFiles =>
      'Erreur lors de la vérification des fichiers ROM:';

  @override
  String get errorCheckingGamelists =>
      'Erreur lors de la vérification des gamelists:';

  @override
  String get cancelDownload => 'Annuler le Téléchargement';

  @override
  String get selectEmulator => 'Sélectionner un Émulateur';

  @override
  String get biosStatusDashboard => 'Tableau de Bord État BIOS';

  @override
  String get webSettings => 'Paramètres Web';

  @override
  String get saveSettings => 'Enregistrer les Paramètres';

  @override
  String get errorSavingSettings =>
      'Erreur lors de l\'enregistrement des paramètres:';

  @override
  String romsCountItems(String count) {
    return '$count ROMs';
  }

  @override
  String get savedPermanently => 'enregistré permanentemment';

  @override
  String get keptInTemporary => 'gardé dans le stockage temporaire';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get allDownloads => 'Tous les téléchargements terminés';

  @override
  String romSavedPermanently(String name) {
    return '$name enregistré permanentemment';
  }

  @override
  String get undo => 'Annuler';

  @override
  String romKeptInTemporary(String name) {
    return '$name gardé dans le stockage temporaire';
  }

  @override
  String romsCountWithSize(String count, String size) {
    return '$count ROMs • $size';
  }

  @override
  String get whatYouCanTry => 'Ce que vous pouvez essayer:';

  @override
  String get tips => 'Conseils';

  @override
  String get helpNavigateItems => 'Naviguer entre les éléments';

  @override
  String get helpGamepadNavigation => 'Navigation manette';

  @override
  String get helpQuickNavigation =>
      'Navigation rapide (sauter plusieurs éléments)';

  @override
  String get helpGamepadPageNavigation => 'Navigation par pages manette';

  @override
  String get helpGoToFirst => 'Aller au premier élément';

  @override
  String get helpGoToLast => 'Aller au dernier élément';

  @override
  String get helpJumpToLetter =>
      'Sauter à l\'élément commençant par cette lettre';

  @override
  String get helpSelectItem => 'Sélectionner un élément';

  @override
  String get helpGamepadSelect => 'Sélection manette';

  @override
  String get helpGoBackCloseDialogs => 'Retour / Fermer les dialogues';

  @override
  String get helpExitApplication => 'Quitter l\'application';

  @override
  String get helpGamepadBackClose => 'Manette retour / Fermer les dialogues';

  @override
  String get helpToggleViewMode =>
      'Basculer le mode d\'affichage (Grille/Liste/Carrousel)';

  @override
  String get helpGamepadViewToggle => 'Changer la vue avec la manette';

  @override
  String get helpRefreshView => 'Actualiser la vue actuelle';

  @override
  String get helpShowPlatformInfo =>
      'Afficher les informations de la plateforme';

  @override
  String get helpActivateSearch => 'Activer la recherche';

  @override
  String get helpGamepadSearch => 'Recherche manette';

  @override
  String get helpShowHelpDialog => 'Afficher ce dialogue d\'aide';

  @override
  String get helpGamepadHelp => 'Aide manette';

  @override
  String get tipUseKeyboardOrGamepad =>
      'Utilisez le clavier ou la manette pour naviguer';

  @override
  String get tipAlphabeticalJump =>
      'Le saut alphabétique fonctionne dans tous les modes d\'affichage';

  @override
  String get tipPressQuestionMark =>
      'Appuyez sur ? à tout moment pour voir cette aide';

  @override
  String get tipGamepadAlongside =>
      'La manette fonctionne avec les contrôles clavier';

  @override
  String get configurePathsDescription =>
      'Configurez les chemins utilisés par l\'application pour localiser les ROMs, médias et émulateurs.';

  @override
  String get romListsAutoManaged =>
      'Les listes de ROMs sont maintenant gérées automatiquement. Téléchargez-les depuis Paramètres > Base de Données ROMs.';

  @override
  String get romStorage => 'Stockage ROMs';

  @override
  String get configureRomStorageDescription =>
      'Configurez où les ROMs téléchargées sont stockées temporairement et permanentemment.';

  @override
  String get resetToDefaults => 'Réinitialiser aux valeurs par défaut';

  @override
  String get mediaPathLabel => 'Chemin des Médias';

  @override
  String get mediaPathHint =>
      'Répertoire contenant les médias (images, vidéos)';

  @override
  String get emulatorsPathLabel => 'Chemin des Émulateurs';

  @override
  String get emulatorsPathHint =>
      'Répertoire contenant les binaires des émulateurs';

  @override
  String get gamelistPathAutomatic => 'Chemin Gamelist (Automatique)';

  @override
  String get gamelistAutoDescription =>
      'Les gamelists sont maintenant gérées automatiquement dans le répertoire de données de l\'application. Cela rend l\'application complètement indépendante et prépare la future distribution de gamelists depuis GitHub.';

  @override
  String get tempRomStorageLabel => 'Stockage Temporaire des ROMs (Optionnel)';

  @override
  String get tempRomStorageDescription =>
      'Les ROMs sont téléchargées ici en premier. Elles peuvent être promues vers le stockage permanent après avoir joué.';

  @override
  String get permanentRomStorageLabel =>
      'Stockage Permanent des ROMs (Optionnel)';

  @override
  String get permanentRomStorageDescription =>
      'Les ROMs enregistrées permanentemment sont stockées ici. Celles-ci ne sont pas nettoyées automatiquement.';

  @override
  String get defaultAppSupportDir =>
      'Par défaut: répertoire de support de l\'application';

  @override
  String currentPathDisplay(String path) {
    return 'Actuel: $path';
  }

  @override
  String get configurationFile => 'Fichier de Configuration';

  @override
  String get source => 'Source:';

  @override
  String get customConfigActive => 'Configuration personnalisée active';

  @override
  String get pathStructure => 'Structure des Chemins';

  @override
  String get pathStructureDescription =>
      'Chemin Médias: MEDIA_PATH/plateforme/boxart|screenshots|videos/rom.png\nChemin Gamelist: ~/.local/share/com.example.emulator/gamelists/plateforme/gamelist.xml (automatique)\nChemin Émulateurs: EMULATORS_PATH/emulateur_binaire';

  @override
  String get errorCheckingSystem => 'Erreur lors de la vérification du système';

  @override
  String get recheckR => 'Re-vérifier (R)';

  @override
  String get allRequiredToolsInstalled => 'Tous les Outils Requis Installés';

  @override
  String get missingRequiredTools => 'Outils Requis Manquants';

  @override
  String get systemReadyToUse =>
      'Votre système est prêt à utiliser l\'émulateur';

  @override
  String get someRequiredToolsMissing => 'Certains outils requis manquent';

  @override
  String get requiredTools => 'Outils Requis';

  @override
  String get requiredToolsDescription =>
      'Ces outils sont nécessaires pour télécharger et extraire les émulateurs';

  @override
  String get installationInstructions => 'Instructions d\'Installation';

  @override
  String get installed => 'Installé';

  @override
  String get missing => 'Manquant';

  @override
  String get downloadEmulatorsAndGameLists =>
      'Télécharger les émulateurs et listes de jeux';

  @override
  String get quickActions => 'Actions Rapides';

  @override
  String get downloadAll => 'Tout Télécharger';

  @override
  String get byCategory => 'Par Catégorie';

  @override
  String get downloadQueue => 'File de Téléchargement';

  @override
  String get noDownloadsInProgress => 'Aucun téléchargement en cours';

  @override
  String get selectQuickActionToStart =>
      'Sélectionnez une action rapide ci-dessus pour commencer à télécharger';

  @override
  String get categorySony => 'Sony (PS1-PS4)';

  @override
  String get categoryNintendo => 'Nintendo (GC, Wii, Switch)';

  @override
  String get categoryMicrosoft => 'Microsoft (Xbox, Xbox 360)';

  @override
  String get categoryMultiPlatform => 'Multi-Platesforme (RetroArch)';

  @override
  String get categoryOtherEmulators => 'Autres Émulateurs';

  @override
  String get categoryUtilities => 'Utilitaires';

  @override
  String confirmDownloadDescription(String count, String size) {
    return 'Télécharger $count émulateur(s)?\nTaille estimée: ~$size MB\n\nCela peut prendre un certain temps selon votre connexion internet.';
  }

  @override
  String get alreadyInstalled => 'Déjà installé';

  @override
  String get starting => 'Démarrage...';

  @override
  String get completed => 'Terminé';

  @override
  String get gameListsAlreadyDownloaded => 'Listes de jeux déjà téléchargées';

  @override
  String get redownload => 'Re-Télécharger';

  @override
  String get gameListsFromGitHub => 'Listes de Jeux (depuis GitHub)';

  @override
  String get downloaded => 'Téléchargé';

  @override
  String get cancelled => 'Annulé';

  @override
  String get missingFor => 'Manquant pour:';

  @override
  String get noCustomConfigToBackup =>
      'Aucune configuration personnalisée à sauvegarder. Utilisation des valeurs par défaut.';

  @override
  String get saveConfigurationBackup => 'Sauvegarder la Configuration';

  @override
  String get refreshStatsR => 'Actualiser les statistiques (R)';

  @override
  String get systemStatistics => 'Statistiques Système';

  @override
  String get romFiles => 'Fichiers ROM';

  @override
  String get maintenanceTools => 'Outils de Maintenance';

  @override
  String get cleanupTemporaryRoms => 'Nettoyer les ROMs Temporaires';

  @override
  String get cleanupTemporaryRomsDescription =>
      'Supprimer les fichiers ROM temporaires du répertoire temporaire du système';

  @override
  String get verifyRomFiles => 'Vérifier les Fichiers ROM';

  @override
  String get verifyRomFilesDescription =>
      'Vérifier que tous les fichiers ROM existent et sont valides';

  @override
  String get checkMissingGamelists => 'Vérifier les Gamelists Manquantes';

  @override
  String get checkMissingGamelistsDescription =>
      'Trouver les plateformes sans fichier gamelist.xml';

  @override
  String get backupConfiguration => 'Sauvegarder la Configuration';

  @override
  String get backupConfigurationDescription =>
      'Créer une sauvegarde de config.json';

  @override
  String get downloadingRomDatabase =>
      'Téléchargement de la Base de Données ROMs...';

  @override
  String get downloadMayTakeMinutes =>
      'Cela peut prendre quelques minutes selon votre connexion...';

  @override
  String get databaseStatus => 'État de la Base de Données';

  @override
  String get notDownloaded => 'Non Téléchargé';

  @override
  String get aboutRomDatabase => 'À propos de la Base de Données ROMs';

  @override
  String get aboutRomDatabaseDescription =>
      'La base de données ROMs contient des listes de ROMs disponibles organisées par plateforme. Elle est téléchargée depuis le dépôt romList de Forsaken sur GitHub.';

  @override
  String get romDatabaseSource => 'Source: github.com/ForsakenStation/romList';

  @override
  String get downloadRomDatabaseDescription =>
      'Cela téléchargera les listes ROMs depuis le dépôt romList de Forsaken sur GitHub.';

  @override
  String get downloadRomDatabaseStats =>
      'Taille: ~7 MB\nPlateformes: 138\nTotal ROMs: ~240,000';

  @override
  String get downloadWillOverwrite =>
      'Note: Cela écrasera les données existantes.';

  @override
  String get clearRomDatabaseDescription =>
      'Cela supprimera toutes les listes ROMs téléchargées et réinitialisera la base de données à son état initial.';

  @override
  String get gamelistsStatus => 'État des Gamelists';

  @override
  String get gamelistsDownloaded => 'Téléchargées';

  @override
  String get gamelistsNotDownloaded => 'Non Téléchargées';

  @override
  String get aboutGamelists => 'À propos des Gamelists';

  @override
  String get aboutGamelistsDescription =>
      'Les gamelists contiennent les métadonnées des jeux (noms, descriptions, évaluations) pour chaque plateforme. Elles sont téléchargées depuis le dépôt gamelists de Forsaken sur GitHub.';

  @override
  String get gamelistsSource => 'Source: github.com/ForsakenStation/gamelists';

  @override
  String get downloadGamelists => 'Télécharger les Gamelists';

  @override
  String get downloadGamelistsDescription =>
      'Cela téléchargera les fichiers gamelist.xml depuis le dépôt gamelists de Forsaken sur GitHub.';

  @override
  String get downloadGamelistsWillOverwrite =>
      'Note: Cela écrasera les fichiers gamelists existants.';

  @override
  String get downloadingGamelists => 'Téléchargement des Gamelists...';

  @override
  String get gamelistsDownloadedSuccess => 'Gamelists téléchargées avec succès';

  @override
  String get failedDownloadGamelists => 'Échec du téléchargement des gamelists';

  @override
  String get clearGamelists => 'Effacer les Gamelists';

  @override
  String get clearGamelistsDescription =>
      'Cela supprimera tous les fichiers gamelists téléchargés.';

  @override
  String get gamelistsCleared => 'Gamelists effacées';

  @override
  String get failedClearGamelists => 'Échec de l\'effacement des gamelists';

  @override
  String get rebuildMediaCache => 'Reconstruire le Cache Médias';

  @override
  String get rebuildMediaCacheDescription =>
      'Scanner les répertoires médias et mettre en cache les chemins dans les gamelists pour un chargement plus rapide';

  @override
  String get rebuildMediaCacheConfirmTitle => 'Reconstruire le Cache Médias?';

  @override
  String get rebuildMediaCacheConfirmBody =>
      'Cela scannera tous les répertoires médias et mettra à jour les fichiers gamelist.xml avec les chemins médias. Cela peut prendre un moment pour les grandes collections.';

  @override
  String get rebuildMediaCacheProgress => 'Reconstruction du cache médias...';

  @override
  String rebuildMediaCacheProcessingPlatform(
    String platform,
    String current,
    String total,
  ) {
    return 'Traitement de $platform ($current/$total)';
  }

  @override
  String get rebuildMediaCacheComplete => 'Cache Médias Reconstruit';

  @override
  String rebuildMediaCacheSummary(
    String platforms,
    String games,
    String updated,
    String paths,
  ) {
    return '$platforms plateformes, $games jeux scannés, $updated mis à jour, $paths chemins médias mis en cache';
  }

  @override
  String get rebuildMediaCacheError =>
      'Échec de la reconstruction du cache médias';

  @override
  String rebuildMediaCacheErrors(String count) {
    return '$count erreurs lors de la reconstruction';
  }

  @override
  String get description => 'Description';

  @override
  String get noDescriptionAvailable =>
      'Aucune description disponible pour cette ROM.';

  @override
  String get releaseDate => 'Date de sortie';

  @override
  String get players => 'Joueurs';

  @override
  String get rating => 'Note';

  @override
  String get regions => 'Régions';

  @override
  String folderRomCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ROMs',
      one: '$count ROM',
    );
    return '$_temp0';
  }

  @override
  String manualTitle(String name) {
    return '$name - Manuel';
  }

  @override
  String get playInBrowser => 'Jouer dans le navigateur';

  @override
  String downloadingPlatformBios(String platformName) {
    return 'Téléchargement du BIOS $platformName';
  }

  @override
  String get downloadingAllMissingBios =>
      'Téléchargement de tous les BIOS manquants';

  @override
  String biosFileLabel(String filename) {
    return 'Fichier : $filename';
  }

  @override
  String batchProgressLabel(String completed, String total) {
    return 'Progression : $completed/$total fichiers';
  }

  @override
  String get fileDetails => 'Détails du fichier :';

  @override
  String get waiting => 'En attente...';

  @override
  String get verifying => 'Vérification...';

  @override
  String get failed => 'Échoué';

  @override
  String get preparing => 'Préparation...';

  @override
  String get downloadingFiles => 'Téléchargement des fichiers...';

  @override
  String get someDownloadsFailed => 'Certains téléchargements ont échoué';

  @override
  String get downloadsCancelled => 'Téléchargements annulés';

  @override
  String get calculating => 'Calcul en cours...';

  @override
  String secondsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count secondes',
      one: '1 seconde',
    );
    return '$_temp0';
  }

  @override
  String minutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String hoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count heures',
      one: '1 heure',
    );
    return '$_temp0';
  }

  @override
  String get downloadingAndLaunching => 'Téléchargement et lancement...';

  @override
  String get launching => 'Lancement...';

  @override
  String emulatorLabel(String name) {
    return 'Émulateur : $name';
  }

  @override
  String get generalInformation => 'Informations générales';

  @override
  String get manufacturer => 'Fabricant';

  @override
  String get releaseYear => 'Année de sortie';

  @override
  String get generation => 'Génération';

  @override
  String get technicalSpecifications => 'Spécifications techniques';

  @override
  String get resolution => 'Résolution';

  @override
  String get colors => 'Couleurs';

  @override
  String get notNow => 'Pas maintenant';

  @override
  String get saveRomPermanently => 'Sauvegarder la ROM définitivement ?';

  @override
  String get keepRomOfflineQuestion =>
      'Souhaitez-vous conserver cette ROM téléchargée pour jouer hors ligne ?';

  @override
  String get deletedToSaveSpace =>
      'Sinon, elle sera supprimée ultérieurement pour économiser de l\'espace.';
}
