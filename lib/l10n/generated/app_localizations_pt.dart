// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Forsaken Emulator';

  @override
  String get retroGamingFrontend => 'Frontend de Jogos Retro';

  @override
  String get platforms => 'Plataformas';

  @override
  String get roms => 'ROMs';

  @override
  String get settings => 'Configurações';

  @override
  String get settingsAndConfiguration => 'Configurações e Configuração';

  @override
  String get aboutForsakenEmulator => 'Sobre o Forsaken Emulator';

  @override
  String get version => 'Versão';

  @override
  String get appDescription =>
      'Um frontend de emulador multiplataforma moderno construído com Flutter.';

  @override
  String get emulators => 'Emuladores';

  @override
  String get ready => 'Pronto';

  @override
  String get back => 'Voltar';

  @override
  String get select => 'Selecionar';

  @override
  String get search => 'Pesquisar';

  @override
  String get refresh => 'Atualizar';

  @override
  String get loading => 'Carregando...';

  @override
  String get error => 'Erro';

  @override
  String get initializationError => 'Erro de Inicialização';

  @override
  String get retry => 'Tentar Novamente';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Salvar';

  @override
  String get delete => 'Excluir';

  @override
  String get confirm => 'Confirmar';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get close => 'Fechar';

  @override
  String get noRomsFound => 'Nenhuma ROM encontrada';

  @override
  String get noPlatformsFound => 'Nenhuma plataforma encontrada';

  @override
  String get checkRomsPath => 'Verifique a variável de ambiente ROMS_PATH';

  @override
  String get downloading => 'Baixando...';

  @override
  String get downloadComplete => 'Download concluído';

  @override
  String get downloadFailed => 'Download falhou';

  @override
  String get emulatorNotFound => 'Emulador não encontrado';

  @override
  String get romNotFound => 'ROM não encontrada';

  @override
  String get biosRequired => 'BIOS necessário';

  @override
  String get systemCheck => 'Verificação do Sistema';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get systemDefault => 'Padrão do sistema';

  @override
  String get help => 'Ajuda';

  @override
  String get keyboardAndGamepadControls => 'Controles de Teclado e Gamepad';

  @override
  String get navigation => 'Navegação';

  @override
  String get actions => 'Ações';

  @override
  String get viewControls => 'Controles de Visualização';

  @override
  String get gotIt => 'Entendi!';

  @override
  String get exit => 'Sair';

  @override
  String get exitApplication => 'Sair do Aplicativo';

  @override
  String get exitConfirm => 'Tem certeza de que deseja sair?';

  @override
  String get downloadManager => 'Gerenciador de Downloads';

  @override
  String get clearCompleted => 'Limpar Concluídos';

  @override
  String get selectCategory => 'Selecionar Categoria';

  @override
  String get confirmDownload => 'Confirmar Download';

  @override
  String get downloadGameLists => 'Baixar Listas de Jogos';

  @override
  String get downloadGameListsDescription =>
      'Isso baixará as listas de ROMs do GitHub.';

  @override
  String get gameListsDownloaded => 'Listas de jogos baixadas!';

  @override
  String get romStorageManagement => 'Gerenciamento de Armazenamento de ROMs';

  @override
  String get deleteRom => 'Excluir ROM?';

  @override
  String deleteRomConfirm(String fileName) {
    return 'Excluir $fileName?';
  }

  @override
  String get actionCannotBeUndone => 'Esta ação não pode ser desfeita.';

  @override
  String deleted(String fileName) {
    return 'Excluído: $fileName';
  }

  @override
  String get savePermanently => 'Salvar Permanentemente?';

  @override
  String moveRomConfirm(String fileName) {
    return 'Mover $fileName para armazenamento permanente?';
  }

  @override
  String saved(String fileName) {
    return 'Salvo: $fileName';
  }

  @override
  String get clearAll => 'Limpar Tudo?';

  @override
  String get clearAllConfirm => 'Excluir todas as ROMs temporárias?';

  @override
  String get allCleared => 'Todas as ROMs temporárias limpas';

  @override
  String get systemPathsConfiguration => 'Configuração de Caminhos do Sistema';

  @override
  String get migrateRoms => 'Migrar ROMs?';

  @override
  String get migrateRomsDescription =>
      'O caminho de armazenamento permanente das ROMs mudou de \$oldPath para \$newPath. Deseja migrar as ROMs existentes para o novo local?';

  @override
  String get noKeepThem => 'Não, mantê-las';

  @override
  String get yesMigrateRoms => 'Sim, migrar ROMs';

  @override
  String get migratingRoms => 'Migrando ROMs...';

  @override
  String get romMigrationFailed => 'Aviso: Migração de ROMs falhou';

  @override
  String get pathsSaved => 'Caminhos salvos com sucesso';

  @override
  String get errorSavingPaths => 'Erro ao salvar caminhos:';

  @override
  String get resetConfiguration => 'Redefinir Configuração';

  @override
  String get resetConfigDescription =>
      'Isso redefinirá todos os caminhos para seus valores padrão. Suas ROMs e arquivos de mídia não serão afetados.';

  @override
  String get configurationReset => 'Configuração redefinida para padrões';

  @override
  String get errorResettingConfiguration => 'Erro ao redefinir a configuração:';

  @override
  String get savePaths => 'Salvar Caminhos';

  @override
  String get saving => 'Salvando...';

  @override
  String get emulatorManagement => 'Gerenciamento de Emuladores';

  @override
  String get configurationReloaded => 'Configuração recarregada';

  @override
  String get errorLoadingEmulators => 'Erro ao carregar emuladores:';

  @override
  String get emulatorAdded => 'Emulador adicionado com sucesso';

  @override
  String get errorAddingEmulator => 'Erro ao adicionar emulador:';

  @override
  String get emulatorUpdated => 'Emulador atualizado com sucesso';

  @override
  String get errorUpdatingEmulator => 'Erro ao atualizar emulador:';

  @override
  String get deleteEmulator => 'Excluir Emulador';

  @override
  String get emulatorDeleted => 'Emulador excluído';

  @override
  String get errorDeletingEmulator => 'Erro ao excluir emulador:';

  @override
  String get configurationSource => 'Fonte de Configuração';

  @override
  String get addEmulator => 'Adicionar Emulador';

  @override
  String get systemNameRequired => 'O nome do sistema é obrigatório';

  @override
  String get commandRequired => 'Pelo menos um comando é obrigatório';

  @override
  String get addCommand => 'Adicionar Comando';

  @override
  String get acceptZipFiles => 'Aceitar arquivos ZIP';

  @override
  String get acceptZipSubtitle => 'Permitir lançar ROMs de arquivos ZIP';

  @override
  String get useForeverMode => 'Usar Modo Forever';

  @override
  String get useForeverSubtitle => 'Manter emulador em execução';

  @override
  String get workInProgress => 'Trabalho em Andamento';

  @override
  String get wipSubtitle => 'Marcar como ainda não totalmente configurado';

  @override
  String get biosFirmwareHelp => 'Ajuda de BIOS e Firmware';

  @override
  String get downloadMissingFiles => 'Baixar Arquivos Faltantes';

  @override
  String get showOnlyMissing => 'Mostrar apenas faltantes';

  @override
  String get downloadAllMissingBios => 'Baixar Todos os BIOSs Faltantes';

  @override
  String get configurationError => 'Erro de Configuração';

  @override
  String get configurationErrorDescription =>
      'O aplicativo não encontrou a configuração necessária.\nPor favor, configure seus caminhos em Configurações > Caminhos do Sistema.';

  @override
  String get configurationRequired =>
      'Obrigatório:\n- Caminho de Mídia: diretório com arquivos de mídia\n- Caminho de Emuladores: diretório com binários de emuladores\n\nOpcional:\n- Caminhos de armazenamento de ROMs para downloads temporários/permanentes';

  @override
  String get goToSettingsToConfigure =>
      'Vá para Configurações > Caminhos do Sistema para configurar';

  @override
  String get noDownloadableBios => 'Nenhum arquivo BIOS baixável faltando';

  @override
  String get allDownloadsCompleted =>
      'Todos os downloads concluídos com sucesso!';

  @override
  String get batchDownloadFailed => 'Download em lote falhou:';

  @override
  String get download => 'Baixar';

  @override
  String get downloadCancelled => 'Download cancelado';

  @override
  String get launched => 'Iniciado:';

  @override
  String get failedToSave => 'Falha ao salvar ROM permanentemente';

  @override
  String get failedToSaveRom => 'Falha ao salvar ROM permanentemente';

  @override
  String get errorSaving => 'Erro ao salvar ROM:';

  @override
  String errorSavingRom(String error) {
    return 'Erro ao salvar ROM: $error';
  }

  @override
  String get openFolder => 'Abrir Pasta';

  @override
  String get viewManual => 'Ver Manual';

  @override
  String get play => 'Jogar';

  @override
  String get goBack => 'Voltar';

  @override
  String get clearSearch => 'Limpar Pesquisa';

  @override
  String get iUnderstand => 'Eu entendo e aceito estes termos';

  @override
  String get start => 'Iniciar';

  @override
  String get debugMode => 'Modo Depuração: ';

  @override
  String get toggleDebugMode => 'Alternar Modo Depuração';

  @override
  String get preparingDownload => 'Preparando download...';

  @override
  String get noEmulatorsAvailable =>
      'Nenhum emulador disponível para esta categoria';

  @override
  String get failedToLaunch => 'Falha ao iniciar emulador web:';

  @override
  String get platformInfo => 'Info da Plataforma';

  @override
  String get emulatorPlatformInfo => 'Info da Plataforma do Emulador';

  @override
  String get favorites => 'Favoritos';

  @override
  String get all => 'Todos';

  @override
  String get collections => 'Coleções';

  @override
  String get searchRoms => 'Pesquisar ROMs...';

  @override
  String get searchPlatforms => 'Pesquisar plataformas...';

  @override
  String romsCount(int count) {
    return '$count ROMs';
  }

  @override
  String platformsCount(int count) {
    return '$count plataformas';
  }

  @override
  String get region => 'Região';

  @override
  String get genre => 'Gênero';

  @override
  String get year => 'Ano';

  @override
  String get publisher => 'Editora';

  @override
  String get developer => 'Desenvolvedor';

  @override
  String get playWithNetplay => 'Jogar com Netplay';

  @override
  String get downloadBios => 'Baixar BIOS';

  @override
  String get viewDetails => 'Ver Detalhes';

  @override
  String get addToFavorites => 'Adicionar aos Favoritos';

  @override
  String get removeFromFavorites => 'Remover dos Favoritos';

  @override
  String get biosMissing => 'BIOS faltante';

  @override
  String get biosPresent => 'BIOS present';

  @override
  String get checkingBios => 'Verificando BIOS...';

  @override
  String get emulatorDownloading => 'Baixando emulador...';

  @override
  String get emulatorDownloadComplete => 'Emulador baixado';

  @override
  String get emulatorDownloadFailed => 'Falha ao baixar emulador';

  @override
  String get installingEmulator => 'Instalando emulador...';

  @override
  String get emulatorReady => 'Emulador pronto';

  @override
  String get configuration => 'Configuração';

  @override
  String get paths => 'Caminhos';

  @override
  String get storage => 'Armazenamento';

  @override
  String get emulatorsPath => 'Caminho de Emuladores';

  @override
  String get romsPath => 'Caminho de ROMs';

  @override
  String get mediaPath => 'Caminho de Mídia';

  @override
  String get biosPath => 'Caminho de BIOS';

  @override
  String get tempPath => 'Caminho Temporário';

  @override
  String get browse => 'Procurar';

  @override
  String get apply => 'Aplicar';

  @override
  String get reset => 'Redefinir';

  @override
  String get clear => 'Limpar';

  @override
  String get scan => 'Escanear';

  @override
  String get scanForRoms => 'Escanear ROMs';

  @override
  String get scanningRoms => 'Escaneando ROMs...';

  @override
  String get scanComplete => 'Escaneamento concluído';

  @override
  String romsFound(int count) {
    return '$count ROMs encontradas';
  }

  @override
  String get noNewRomsFound => 'Nenhuma nova ROM encontrada';

  @override
  String get launchEmulator => 'Iniciar Emulador';

  @override
  String get emulatorError => 'Erro do Emulador';

  @override
  String get gamepadConnected => 'Gamepad conectado';

  @override
  String get gamepadDisconnected => 'Gamepad desconectado';

  @override
  String get gamepadTest => 'Testar Gamepad';

  @override
  String get pressAnyButton => 'Pressione qualquer botão para testar';

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
  String get dpadUp => 'D-Pad Cima';

  @override
  String get dpadDown => 'D-Pad Baixo';

  @override
  String get dpadLeft => 'D-Pad Esquerda';

  @override
  String get dpadRight => 'D-Pad Direita';

  @override
  String get leftShoulder => 'L1';

  @override
  String get rightShoulder => 'R1';

  @override
  String get leftTrigger => 'L2';

  @override
  String get rightTrigger => 'R2';

  @override
  String get leftStick => 'Stick Esquerdo';

  @override
  String get rightStick => 'Stick Direito';

  @override
  String get setupWizard => 'Assistente de Configuração';

  @override
  String get welcome => 'Bem-vindo';

  @override
  String get welcomeMessage => 'Bem-vindo ao Forsaken Emulator';

  @override
  String get next => 'Próximo';

  @override
  String get previous => 'Anterior';

  @override
  String get finish => 'Finalizar';

  @override
  String get skip => 'Pular';

  @override
  String get setupComplete => 'Configuração Concluída';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get selectEmulatorsPath => 'Selecionar Caminho de Emuladores';

  @override
  String get selectRomsPath => 'Selecionar Caminho de ROMs';

  @override
  String get selectMediaPath => 'Selecionar Caminho de Mídia';

  @override
  String get allSettingsConfigured => 'Todas as configurações configuradas';

  @override
  String get darkTheme => 'Escuro';

  @override
  String get lightTheme => 'Claro';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get about => 'Sobre';

  @override
  String get checkForUpdates => 'Verificar Atualizações';

  @override
  String get noUpdatesAvailable => 'Nenhuma atualização disponível';

  @override
  String get updateAvailable => 'Atualização disponível';

  @override
  String get downloadingUpdate => 'Baixando atualização...';

  @override
  String get installingUpdate => 'Instalando atualização...';

  @override
  String get updateComplete => 'Atualização concluída';

  @override
  String get updateFailed => 'Atualização falhou';

  @override
  String get networkError => 'Erro de rede';

  @override
  String get connectionError => 'Erro de conexão';

  @override
  String get timeoutError => 'Erro de tempo limite';

  @override
  String get unknownError => 'Erro desconhecido';

  @override
  String get permissionDenied => 'Permissão negada';

  @override
  String get fileNotFound => 'Arquivo não encontrado';

  @override
  String get directoryNotFound => 'Diretório não encontrado';

  @override
  String get diskFull => 'Disco cheio';

  @override
  String get invalidPath => 'Caminho inválido';

  @override
  String get pathNotWritable => 'Caminho não gravável';

  @override
  String get romCorrupted => 'O arquivo ROM pode estar corrompido';

  @override
  String get zipError => 'Erro de arquivo ZIP';

  @override
  String get extractionFailed => 'Extração falhou';

  @override
  String get checksumMismatch => 'Incompatibilidade de soma de verificação';

  @override
  String get biosCheckFailed => 'Verificação de BIOS falhou';

  @override
  String get continueAnyway => 'Continuar mesmo assim';

  @override
  String get reportIssue => 'Reportar Problema';

  @override
  String get copyToClipboard => 'Copiar para área de transferência';

  @override
  String get copiedToClipboard => 'Copiado para área de transferência';

  @override
  String get share => 'Compartilhar';

  @override
  String get hide => 'Ocultar';

  @override
  String get show => 'Mostrar';

  @override
  String get toggleView => 'Alternar Visualização';

  @override
  String get gridView => 'Visualização em Grade';

  @override
  String get listView => 'Visualização em Lista';

  @override
  String get carouselView => 'Visualização em Carrossel';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get sortByName => 'Nome';

  @override
  String get sortByDate => 'Data';

  @override
  String get sortBySize => 'Tamanho';

  @override
  String get sortByRegion => 'Região';

  @override
  String get ascending => 'Crescente';

  @override
  String get descending => 'Decrescente';

  @override
  String get filter => 'Filtrar';

  @override
  String get filterByRegion => 'Filtrar por Região';

  @override
  String get filterByGenre => 'Filtrar por Gênero';

  @override
  String get filterByYear => 'Filtrar por Ano';

  @override
  String get clearFilters => 'Limpar Filtros';

  @override
  String get systemInfo => 'Info do Sistema';

  @override
  String get cpu => 'CPU';

  @override
  String get memory => 'Memória';

  @override
  String get storageInfo => 'Armazenamento';

  @override
  String get os => 'Sistema Operacional';

  @override
  String get emulatorVersion => 'Versão do Emulador';

  @override
  String get totalRoms => 'Total de ROMs';

  @override
  String get totalSize => 'Tamanho Total';

  @override
  String get freeSpace => 'Espaço Livre';

  @override
  String get usedSpace => 'Espaço Usado';

  @override
  String get systemUtilities => 'Utilitários do Sistema';

  @override
  String get romVerificationResults => 'Resultados de Verificação de ROMs';

  @override
  String get totalRomFiles => 'Total de arquivos ROM';

  @override
  String get emptyRomFiles => 'Arquivos ROM vazios';

  @override
  String get validRomFiles => 'Arquivos ROM válidos';

  @override
  String get romsDirectoryDoesNotExist => 'O diretório de ROMs não existe';

  @override
  String get gamelistCheckResults => 'Resultados de Verificação de Gamelists';

  @override
  String get totalPlatforms => 'Total de plataformas';

  @override
  String get missingGamelists => 'Gamelists faltantes';

  @override
  String get configurationBackup => 'Backup de Configuração';

  @override
  String get configurationBackedUp => 'Configuração backupada em:';

  @override
  String get errorBackingUp => 'Erro ao fazer backup da configuração:';

  @override
  String get romDatabase => 'Banco de Dados de ROMs';

  @override
  String get romDatabaseDownloaded =>
      'Banco de dados de ROMs baixado com sucesso';

  @override
  String get failedDownloadRomDatabase =>
      'Falha ao baixar banco de dados de ROMs';

  @override
  String get romDatabaseCleared => 'Banco de dados de ROMs limpo';

  @override
  String get failedClearDatabase => 'Falha ao limpar banco de dados';

  @override
  String get downloadRomDatabase => 'Baixar Banco de Dados de ROMs';

  @override
  String get clearRomDatabase => 'Limpar Banco de Dados de ROMs';

  @override
  String get systemRequirements => 'Requisitos do Sistema';

  @override
  String get failedToCheckSystem => 'Falha ao verificar sistema';

  @override
  String cleanedUpTempFiles(String deletedCount) {
    return 'Limpados $deletedCount arquivos ROM temporários';
  }

  @override
  String get errorCleaningTempFiles => 'Erro ao limpar arquivos temporários:';

  @override
  String get errorVerifyingRomFiles => 'Erro ao verificar arquivos ROM:';

  @override
  String get errorCheckingGamelists => 'Erro ao verificar gamelists:';

  @override
  String get cancelDownload => 'Cancelar Download';

  @override
  String get selectEmulator => 'Selecionar Emulador';

  @override
  String get biosStatusDashboard => 'Painel de Status de BIOS';

  @override
  String get webSettings => 'Configurações Web';

  @override
  String get saveSettings => 'Salvar Configurações';

  @override
  String get errorSavingSettings => 'Erro ao salvar configurações:';

  @override
  String romsCountItems(String count) {
    return '$count ROMs';
  }

  @override
  String get savedPermanently => 'salvo permanentemente';

  @override
  String get keptInTemporary => 'mantido em armazenamento temporário';

  @override
  String get tryAgain => 'Tentar Novamente';

  @override
  String get allDownloads => 'Todos os downloads concluídos';

  @override
  String romSavedPermanently(String name) {
    return '$name salvo permanentemente';
  }

  @override
  String get undo => 'Desfazer';

  @override
  String romKeptInTemporary(String name) {
    return '$name mantido em armazenamento temporário';
  }

  @override
  String romsCountWithSize(String count, String size) {
    return '$count ROMs • $size';
  }

  @override
  String get whatYouCanTry => 'O que você pode tentar:';

  @override
  String get tips => 'Dicas';

  @override
  String get helpNavigateItems => 'Navegar entre itens';

  @override
  String get helpGamepadNavigation => 'Navegação com gamepad';

  @override
  String get helpQuickNavigation => 'Navegação rápida (pular vários itens)';

  @override
  String get helpGamepadPageNavigation => 'Navegação de páginas com gamepad';

  @override
  String get helpGoToFirst => 'Ir para o primeiro item';

  @override
  String get helpGoToLast => 'Ir para o último item';

  @override
  String get helpJumpToLetter => 'Pular para o item que começa com essa letra';

  @override
  String get helpSelectItem => 'Selecionar item';

  @override
  String get helpGamepadSelect => 'Seleção com gamepad';

  @override
  String get helpGoBackCloseDialogs => 'Voltar / Fechar diálogos';

  @override
  String get helpExitApplication => 'Sair do aplicativo';

  @override
  String get helpGamepadBackClose => 'Gamepad voltar / Fechar diálogos';

  @override
  String get helpToggleViewMode =>
      'Alternar modo de visualização (Grade/Lista/Carrossel)';

  @override
  String get helpGamepadViewToggle => 'Alternar visualização com gamepad';

  @override
  String get helpRefreshView => 'Atualizar visualização atual';

  @override
  String get helpShowPlatformInfo => 'Mostrar informações da plataforma';

  @override
  String get helpActivateSearch => 'Ativar pesquisa';

  @override
  String get helpGamepadSearch => 'Pesquisa com gamepad';

  @override
  String get helpShowHelpDialog => 'Mostrar este diálogo de ajuda';

  @override
  String get helpGamepadHelp => 'Ajuda com gamepad';

  @override
  String get tipUseKeyboardOrGamepad => 'Use teclado ou gamepad para navegar';

  @override
  String get tipAlphabeticalJump =>
      'O salto alfabético funciona em todos os modos de visualização';

  @override
  String get tipPressQuestionMark =>
      'Pressione ? a qualquer momento para ver esta ajuda';

  @override
  String get tipGamepadAlongside =>
      'O gamepad funciona junto com os controles de teclado';

  @override
  String get configurePathsDescription =>
      'Configure os caminhos usados pelo aplicativo para localizar ROMs, mídia e emuladores.';

  @override
  String get romListsAutoManaged =>
      'As listas de ROMs agora são gerenciadas automaticamente. Baixe-as em Configurações > Banco de Dados de ROMs.';

  @override
  String get romStorage => 'Armazenamento de ROMs';

  @override
  String get configureRomStorageDescription =>
      'Configure onde as ROMs baixadas são armazenadas temporária e permanentemente.';

  @override
  String get resetToDefaults => 'Redefinir para padrões';

  @override
  String get mediaPathLabel => 'Caminho de Mídia';

  @override
  String get mediaPathHint => 'Diretório contendo mídia (imagens, vídeos)';

  @override
  String get emulatorsPathLabel => 'Caminho de Emuladores';

  @override
  String get emulatorsPathHint => 'Diretório contendo binários de emuladores';

  @override
  String get gamelistPathAutomatic => 'Caminho de Gamelist (Automático)';

  @override
  String get gamelistAutoDescription =>
      'As gamelists agora são gerenciadas automaticamente no diretório de dados do aplicativo. Isso torna o aplicativo completamente independente e prepara a futura distribuição de gamelists do GitHub.';

  @override
  String get tempRomStorageLabel =>
      'Armazenamento Temporário de ROMs (Opcional)';

  @override
  String get tempRomStorageDescription =>
      'As ROMs são baixadas aqui primeiro. Elas podem ser promovidas para armazenamento permanente após jogar.';

  @override
  String get permanentRomStorageLabel =>
      'Armazenamento Permanente de ROMs (Opcional)';

  @override
  String get permanentRomStorageDescription =>
      'As ROMs salvas permanentemente são armazenadas aqui. Estas não são limpas automaticamente.';

  @override
  String get defaultAppSupportDir =>
      'Padrão: diretório de suporte do aplicativo';

  @override
  String currentPathDisplay(String path) {
    return 'Atual: $path';
  }

  @override
  String get configurationFile => 'Arquivo de Configuração';

  @override
  String get source => 'Fonte:';

  @override
  String get customConfigActive => 'Configuração personalizada ativa';

  @override
  String get pathStructure => 'Estrutura de Caminhos';

  @override
  String get pathStructureDescription =>
      'Caminho de Mídia: MEDIA_PATH/plataforma/boxart|screenshots|videos/rom.png\nCaminho de Gamelist: ~/.local/share/com.example.emulator/gamelists/plataforma/gamelist.xml (automático)\nCaminho de Emuladores: EMULATORS_PATH/emulador_binário';

  @override
  String get errorCheckingSystem => 'Erro ao verificar sistema';

  @override
  String get recheckR => 'Re-verificar (R)';

  @override
  String get allRequiredToolsInstalled =>
      'Todas as Ferramentas Necessárias Instaladas';

  @override
  String get missingRequiredTools => 'Ferramentas Necessárias Faltantes';

  @override
  String get systemReadyToUse => 'Seu sistema está pronto para usar o emulador';

  @override
  String get someRequiredToolsMissing =>
      'Algumas ferramentas necessárias estão faltando';

  @override
  String get requiredTools => 'Ferramentas Necessárias';

  @override
  String get requiredToolsDescription =>
      'Estas ferramentas são necessárias para baixar e extrair emuladores';

  @override
  String get installationInstructions => 'Instruções de Instalação';

  @override
  String get installed => 'Instalado';

  @override
  String get missing => 'Faltante';

  @override
  String get downloadEmulatorsAndGameLists =>
      'Baixar emuladores e listas de jogos';

  @override
  String get quickActions => 'Ações Rápidas';

  @override
  String get downloadAll => 'Baixar Tudo';

  @override
  String get byCategory => 'Por Categoria';

  @override
  String get downloadQueue => 'Fila de Download';

  @override
  String get noDownloadsInProgress => 'Nenhum download em andamento';

  @override
  String get selectQuickActionToStart =>
      'Selecione uma ação rápida acima para começar a baixar';

  @override
  String get categorySony => 'Sony (PS1-PS4)';

  @override
  String get categoryNintendo => 'Nintendo (GC, Wii, Switch)';

  @override
  String get categoryMicrosoft => 'Microsoft (Xbox, Xbox 360)';

  @override
  String get categoryMultiPlatform => 'Multi-Plataforma (RetroArch)';

  @override
  String get categoryOtherEmulators => 'Outros Emuladores';

  @override
  String get categoryUtilities => 'Utilitários';

  @override
  String confirmDownloadDescription(String count, String size) {
    return 'Baixar $count emulador(es)?\nTamanho estimado: ~$size MB\n\nIsso pode demorar um pouco dependendo da sua conexão com a internet.';
  }

  @override
  String get alreadyInstalled => 'Já instalado';

  @override
  String get starting => 'Iniciando...';

  @override
  String get completed => 'Concluído';

  @override
  String get gameListsAlreadyDownloaded => 'Listas de jogos já baixadas';

  @override
  String get redownload => 'Re-Baixar';

  @override
  String get gameListsFromGitHub => 'Listas de Jogos (do GitHub)';

  @override
  String get downloaded => 'Baixado';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get missingFor => 'Faltante para:';

  @override
  String get noCustomConfigToBackup =>
      'Nenhuma configuração personalizada para fazer backup. Usando padrões.';

  @override
  String get saveConfigurationBackup => 'Salvar Backup de Configuração';

  @override
  String get refreshStatsR => 'Atualizar estatísticas (R)';

  @override
  String get systemStatistics => 'Estatísticas do Sistema';

  @override
  String get romFiles => 'Arquivos ROM';

  @override
  String get maintenanceTools => 'Ferramentas de Manutenção';

  @override
  String get cleanupTemporaryRoms => 'Limpar ROMs Temporárias';

  @override
  String get cleanupTemporaryRomsDescription =>
      'Remover arquivos ROM temporários do diretório temporário do sistema';

  @override
  String get verifyRomFiles => 'Verificar Arquivos ROM';

  @override
  String get verifyRomFilesDescription =>
      'Verificar que todos os arquivos ROM existem e são válidos';

  @override
  String get checkMissingGamelists => 'Verificar Gamelists Faltantes';

  @override
  String get checkMissingGamelistsDescription =>
      'Encontrar plataformas sem arquivo gamelist.xml';

  @override
  String get backupConfiguration => 'Backup de Configuração';

  @override
  String get backupConfigurationDescription => 'Criar um backup de config.json';

  @override
  String get downloadingRomDatabase => 'Baixando Banco de Dados de ROMs...';

  @override
  String get downloadMayTakeMinutes =>
      'Isso pode demorar alguns minutos dependendo da sua conexão...';

  @override
  String get databaseStatus => 'Status do Banco de Dados';

  @override
  String get notDownloaded => 'Não Baixado';

  @override
  String get aboutRomDatabase => 'Sobre o Banco de Dados de ROMs';

  @override
  String get aboutRomDatabaseDescription =>
      'O banco de dados de ROMs contém listas de ROMs disponíveis organizadas por plataforma. É baixado do repositório romList do Forsaken no GitHub.';

  @override
  String get romDatabaseSource => 'Fonte: github.com/ForsakenStation/romList';

  @override
  String get downloadRomDatabaseDescription =>
      'Isso baixará as listas de ROMs do repositório romList do Forsaken no GitHub.';

  @override
  String get downloadRomDatabaseStats =>
      'Tamanho: ~7 MB\nPlataformas: 138\nTotal de ROMs: ~240.000';

  @override
  String get downloadWillOverwrite =>
      'Nota: Isso sobrescreverá os dados existentes.';

  @override
  String get clearRomDatabaseDescription =>
      'Isso excluirá todas as listas de ROMs baixadas e redefinirá o banco de dados para seu estado inicial.';

  @override
  String get gamelistsStatus => 'Status das Gamelists';

  @override
  String get gamelistsDownloaded => 'Baixadas';

  @override
  String get gamelistsNotDownloaded => 'Não Baixadas';

  @override
  String get aboutGamelists => 'Sobre as Gamelists';

  @override
  String get aboutGamelistsDescription =>
      'As gamelists contêm metadados de jogos (nomes, descrições, classificações) para cada plataforma. São baixadas do repositório gamelists do Forsaken no GitHub.';

  @override
  String get gamelistsSource => 'Fonte: github.com/ForsakenStation/gamelists';

  @override
  String get downloadGamelists => 'Baixar Gamelists';

  @override
  String get downloadGamelistsDescription =>
      'Isso baixará arquivos gamelist.xml do repositório gamelists do Forsaken no GitHub.';

  @override
  String get downloadGamelistsWillOverwrite =>
      'Nota: Isso sobrescreverá os arquivos gamelist existentes.';

  @override
  String get downloadingGamelists => 'Baixando Gamelists...';

  @override
  String get gamelistsDownloadedSuccess => 'Gamelists baixadas com sucesso';

  @override
  String get failedDownloadGamelists => 'Falha ao baixar gamelists';

  @override
  String get clearGamelists => 'Limpar Gamelists';

  @override
  String get clearGamelistsDescription =>
      'Isso excluirá todos os arquivos gamelist baixados.';

  @override
  String get gamelistsCleared => 'Gamelists limpas';

  @override
  String get failedClearGamelists => 'Falha ao limpar gamelists';

  @override
  String get rebuildMediaCache => 'Reconstruir Cache de Mídia';

  @override
  String get rebuildMediaCacheDescription =>
      'Escanear diretórios de mídia e armazenar caminhos em cache nas gamelists para carregamento mais rápido';

  @override
  String get rebuildMediaCacheConfirmTitle => 'Reconstruir Cache de Mídia?';

  @override
  String get rebuildMediaCacheConfirmBody =>
      'Isso escaneará todos os diretórios de mídia e atualizará arquivos gamelist.xml com caminhos de mídia. Isso pode demorar um momento para coleções grandes.';

  @override
  String get rebuildMediaCacheProgress => 'Reconstruindo cache de mídia...';

  @override
  String rebuildMediaCacheProcessingPlatform(
    String platform,
    String current,
    String total,
  ) {
    return 'Processando $platform ($current/$total)';
  }

  @override
  String get rebuildMediaCacheComplete => 'Cache de Mídia Reconstruído';

  @override
  String rebuildMediaCacheSummary(
    String platforms,
    String games,
    String updated,
    String paths,
  ) {
    return '$platforms plataformas, $games jogos escaneados, $updated atualizados, $paths caminhos de mídia em cache';
  }

  @override
  String get rebuildMediaCacheError => 'Falha ao reconstruir cache de mídia';

  @override
  String rebuildMediaCacheErrors(String count) {
    return '$count erros ocorreram durante a reconstrução';
  }

  @override
  String get description => 'Descrição';

  @override
  String get noDescriptionAvailable =>
      'Nenhuma descrição disponível para esta ROM.';

  @override
  String get releaseDate => 'Data de lançamento';

  @override
  String get players => 'Jogadores';

  @override
  String get rating => 'Avaliação';

  @override
  String get regions => 'Regiões';

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
    return '$name - Manual';
  }

  @override
  String get playInBrowser => 'Jogar no navegador';

  @override
  String downloadingPlatformBios(String platformName) {
    return 'Baixando BIOS de $platformName';
  }

  @override
  String get downloadingAllMissingBios => 'Baixando todas as BIOS em falta';

  @override
  String biosFileLabel(String filename) {
    return 'Ficheiro: $filename';
  }

  @override
  String batchProgressLabel(String completed, String total) {
    return 'Progresso: $completed/$total ficheiros';
  }

  @override
  String get fileDetails => 'Detalhes do ficheiro:';

  @override
  String get waiting => 'A aguardar...';

  @override
  String get verifying => 'A verificar...';

  @override
  String get failed => 'Falhou';

  @override
  String get preparing => 'A preparar...';

  @override
  String get downloadingFiles => 'A descarregar ficheiros...';

  @override
  String get someDownloadsFailed => 'Alguns downloads falharam';

  @override
  String get downloadsCancelled => 'Downloads cancelados';

  @override
  String get calculating => 'A calcular...';

  @override
  String secondsRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segundos',
      one: '1 segundo',
    );
    return '$_temp0';
  }

  @override
  String minutesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutos',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String hoursRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count horas',
      one: '1 hora',
    );
    return '$_temp0';
  }

  @override
  String get downloadingAndLaunching => 'A descarregar e a iniciar...';

  @override
  String get launching => 'A iniciar...';

  @override
  String emulatorLabel(String name) {
    return 'Emulador: $name';
  }

  @override
  String get generalInformation => 'Informações gerais';

  @override
  String get manufacturer => 'Fabricante';

  @override
  String get releaseYear => 'Ano de lançamento';

  @override
  String get generation => 'Geração';

  @override
  String get technicalSpecifications => 'Especificações técnicas';

  @override
  String get resolution => 'Resolução';

  @override
  String get colors => 'Cores';

  @override
  String get notNow => 'Agora não';

  @override
  String get saveRomPermanently => 'Guardar ROM permanentemente?';

  @override
  String get keepRomOfflineQuestion =>
      'Gostaria de manter esta ROM descarregada para jogar offline?';

  @override
  String get deletedToSaveSpace =>
      'Caso contrário, será eliminada mais tarde para poupar espaço.';
}
