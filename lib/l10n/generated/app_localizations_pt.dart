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
  String get biosRequired => 'OBRIGATÓRIO';

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
  String get biosMissing => 'Em falta';

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
  String get gamepadConnected => 'Controle conectado';

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
  String get rightStick => 'Stick direito';

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

  @override
  String get view => 'Visualizar';

  @override
  String get media => 'Mídia';

  @override
  String get navigate => 'Navegar';

  @override
  String get info => 'Info';

  @override
  String get toggleFilter => 'Alternar filtro';

  @override
  String get changeTheme => 'Mudar tema';

  @override
  String get keyboard => 'Teclado';

  @override
  String get gamepad => 'Gamepad';

  @override
  String get hideKeyboard => 'Ocultar teclado';

  @override
  String get gameManual => 'Manual do Jogo';

  @override
  String get pdfDocument => 'Documento PDF';

  @override
  String get manual => 'Manual';

  @override
  String get video => 'Vídeo';

  @override
  String get zoomOut => 'Diminuir zoom';

  @override
  String get zoomIn => 'Aumentar zoom';

  @override
  String pageCounter(String current, String total) {
    return 'Página $current / $total';
  }

  @override
  String get zoom => 'Zoom';

  @override
  String get firstLast => 'Primeiro/Último';

  @override
  String get scroll => 'Rolar';

  @override
  String get loadingVideo => 'Carregando vídeo...';

  @override
  String get playPause => 'Reproduzir/Pausar';

  @override
  String get useArrowKeysToNavigate =>
      'Use as setas do teclado ou deslize para navegar';

  @override
  String get searchRomsHint => 'Pesquisar ROMs...';

  @override
  String get cancelSearch => 'Cancelar Pesquisa';

  @override
  String get virtualKeyboard => 'Teclado Virtual';

  @override
  String get noRomsAvailable => 'Nenhuma ROM disponível';

  @override
  String get noRomsForPlatformMessage =>
      'Nenhum ficheiro ROM encontrado para esta plataforma. Os ficheiros ROM devem ser colocados como ficheiros .txt contendo URLs de download no diretório da plataforma.';

  @override
  String get noMatchingRoms => 'Nenhuma ROM correspondente';

  @override
  String get tryDifferentSearch => 'Tente um termo de pesquisa diferente';

  @override
  String get saveToPermanentStorage => 'Guardar no armazenamento permanente';

  @override
  String get temporary => 'Temporário';

  @override
  String get permanent => 'Permanente';

  @override
  String get tempPathLabel => 'Temp';

  @override
  String get foreverPathLabel => 'Forever';

  @override
  String get storageOverview => 'Visão Geral do Armazenamento';

  @override
  String get clearTemporaryStorage => 'Limpar armazenamento temporário';

  @override
  String filesCount(String count) {
    return '$count ficheiros';
  }

  @override
  String pathDisplay(String label, String path) {
    return 'Caminho $label: $path';
  }

  @override
  String get unknown => 'Desconhecido';

  @override
  String get tagVerifiedGoodDump =>
      'Dump verificado e correto - funcionamento confirmado';

  @override
  String get tagBadDump => 'Dump incorreto - pode não funcionar corretamente';

  @override
  String get tagAlternateVersion => 'Versão alternativa';

  @override
  String get tagOverdump => 'Overdump - contém dados adicionais';

  @override
  String get tagModifiedHacked => 'ROM modificada/hackeada';

  @override
  String get tagFanTranslation => 'Tradução de fãs';

  @override
  String get tagPirateBootleg => 'Versão pirata/bootleg';

  @override
  String get tagFixedVersion => 'Versão corrigida';

  @override
  String get tagCheatTrainer => 'Inclui trainer de batota';

  @override
  String tagVersion(String text) {
    return 'Versão: $text';
  }

  @override
  String tagSpecialRelease(String text) {
    return 'Lançamento especial: $text';
  }

  @override
  String tagMediaInfo(String text) {
    return 'Info de mídia: $text';
  }

  @override
  String noEmulatorConfigured(
    String displayName,
    String platform,
    String configPath,
  ) {
    return 'Nenhum emulador configurado para $displayName.\n\nAdicione a configuração para \"$platform\" em:\n$configPath';
  }

  @override
  String get noEmulatorCommandAvailable =>
      'Nenhum comando de emulador disponível';

  @override
  String platformNotSupportedWeb(String platform, String supportedPlatforms) {
    return 'A plataforma \"$platform\" ainda não é compatível com o navegador web.\n\nPlataformas compatíveis: $supportedPlatforms';
  }

  @override
  String failedToLaunchWebEmulator(String error) {
    return 'Falha ao iniciar o emulador web: $error';
  }

  @override
  String failedToLaunchRom(String error) {
    return 'Falha ao iniciar a ROM.\n\nVerifique se:\n• O emulador está instalado corretamente\n• O arquivo ROM é válido\n• A configuração está correta\n\nErro: $error';
  }

  @override
  String errorLaunchingRom(String error) {
    return 'Erro ao iniciar a ROM: $error';
  }

  @override
  String noInfoAvailable(String platformName) {
    return 'Nenhuma informação disponível para $platformName';
  }

  @override
  String get platformInfoTooltip => 'Info da plataforma (I)';

  @override
  String get navigationHint => 'Use as teclas de seta ou deslize para navegar';

  @override
  String get noGamesFound => 'Nenhum jogo encontrado';

  @override
  String get noGamesFoundForSearch => 'Nenhum jogo encontrado para a pesquisa';

  @override
  String get tryDifferentSearchOrClear =>
      'Tente um termo de pesquisa diferente ou limpe o filtro';

  @override
  String get checkStorageOrDownload =>
      'Verifique as configurações de armazenamento ou descarregue algumas ROMs';

  @override
  String get searchGamesHint => 'Pesquisar jogos...';

  @override
  String get settingsHeaderTitle => 'Configuração do Emulador Forsaken';

  @override
  String get settingsHeaderSubtitle =>
      'Configurar emuladores, caminhos e baixar conteúdo';

  @override
  String get emulatorManagementDesc =>
      'Adicionar, editar e configurar comandos de emuladores';

  @override
  String get systemPaths => 'Caminhos do sistema';

  @override
  String get systemPathsDesc =>
      'Configurar caminhos de ROMs, mídia e emuladores';

  @override
  String get romDatabaseDesc => 'Baixar e gerenciar listas de ROMs do GitHub';

  @override
  String get romStorageDesc =>
      'Gerenciar ROMs baixadas, armazenamento e limpeza de arquivos temporários';

  @override
  String get downloadManagerDesc =>
      'Baixar emuladores, listas de ROMs e dados de jogos';

  @override
  String get systemRequirementsDesc =>
      'Verificar ferramentas e dependências necessárias';

  @override
  String get gamepadTestDebug => 'Teste e depuração do controle';

  @override
  String get gamepadTestDebugDesc =>
      'Testar botões do controle, eixos e solucionar problemas';

  @override
  String get biosFirmwareHelpDesc =>
      'Verificar arquivos BIOS e requisitos de firmware';

  @override
  String get webSettingsDesc => 'Proxy CORS e configuração da plataforma web';

  @override
  String get setupWizardDesc =>
      'Reexecutar o assistente de configuração inicial';

  @override
  String get languageDesc => 'Selecionar idioma do aplicativo';

  @override
  String get aboutDebug => 'Sobre e depuração';

  @override
  String get aboutDebugDesc =>
      'Informações do aplicativo e configurações de depuração';

  @override
  String get legalDisclaimer => 'Aviso legal';

  @override
  String get romDatabaseCredits =>
      'As listas de ROMs são originalmente do repositório AndroidRoms de Arley4d:';

  @override
  String get romDatabaseThanks =>
      'Agradecimento especial ao projeto AndroidRoms por manter bancos de dados abrangentes de ROMs para fins de preservação.';

  @override
  String get biosFilesSection => 'Arquivos BIOS';

  @override
  String get biosFilesCredits =>
      'Os arquivos BIOS são do repositório retroarch_system de Abdess:';

  @override
  String get biosFilesThanks =>
      'Este repositório contém arquivos de sistema e BIOS necessários para várias plataformas de emulação. Agradecimento especial aos mantenedores por preservar esses arquivos essenciais.';

  @override
  String get amigaCopyProtection =>
      'Suporte à proteção contra cópia do Amiga fornecido pela biblioteca capsimg:';

  @override
  String get amigaCopyProtectionThanks =>
      'Agradecimento especial a rsn8887 por manter a biblioteca capsimg que permite o suporte a imagens de disco IPF (protegidas contra cópia) para emulação do Amiga.';

  @override
  String get additionalBiosFiles =>
      'Arquivos BIOS adicionais fornecidos pelo projeto RetroPieBios:';

  @override
  String get additionalBiosThanks =>
      'Obrigado ao PIBSAS/RetroPieBios por fornecer variantes adicionais de BIOS e arquivos regionais que melhoram a compatibilidade entre diferentes sistemas e regiões.';

  @override
  String get enabled => 'Ativado';

  @override
  String get disabled => 'Desativado';

  @override
  String get disclaimerRequired =>
      'Você deve aceitar o aviso de isenção de responsabilidade para continuar.';

  @override
  String get emulatorsPathRequired =>
      'O caminho do diretório de emuladores é obrigatório.';

  @override
  String get emulatorConfigPathRequired =>
      'O caminho do arquivo de configuração do emulador é obrigatório.';

  @override
  String get mediaPathRequired => 'O caminho de mídia é obrigatório.';

  @override
  String get tempRomPathRequired =>
      'O caminho do armazenamento temporário de ROMs é obrigatório.';

  @override
  String get permanentRomPathRequired =>
      'O caminho do armazenamento permanente de ROMs é obrigatório.';

  @override
  String wizardStepCounter(int current, int total) {
    return 'Passo $current / $total';
  }

  @override
  String get emulatorConfiguration => 'Configuração do emulador';

  @override
  String get emulatorConfigStepDesc =>
      'Defina os caminhos onde seus emuladores estão instalados. Você pode alterá-los depois em Configurações > Caminhos do sistema.';

  @override
  String get emulatorsDirectory => 'Diretório de emuladores';

  @override
  String get pathToEmulatorBinaries =>
      'Caminho para os binários dos emuladores';

  @override
  String get emulatorConfigFile => 'Arquivo de configuração do emulador';

  @override
  String get pathToEmulatorConfig =>
      'Caminho para o JSON de configuração do emulador';

  @override
  String get storagePaths => 'Caminhos de armazenamento';

  @override
  String get storagePathsStepDesc =>
      'Configure onde os recursos de mídia e arquivos ROM são armazenados. Você pode alterá-los depois em Configurações > Caminhos do sistema.';

  @override
  String get wizardMediaPathHint => 'Capas, capturas de tela e vídeos';

  @override
  String get temporaryRomStorage => 'Armazenamento temporário de ROMs';

  @override
  String get temporaryRomStorageHint =>
      'ROMs baixadas para sessões de jogo únicas';

  @override
  String get permanentRomStorage => 'Armazenamento permanente de ROMs';

  @override
  String get permanentRomStorageHint => 'ROMs salvas para jogar offline';

  @override
  String get allSet => 'Tudo pronto!';

  @override
  String get wizardEmulatorReady =>
      'O emulador Forsaken está pronto para usar.';

  @override
  String get changeSettingsLater =>
      'Você pode alterar essas configurações depois na tela de Configurações.';

  @override
  String get configurationSummary => 'Resumo da configuração';

  @override
  String get summaryEmulators => 'Emuladores';

  @override
  String get summaryMedia => 'Mídia';

  @override
  String get summaryTempRoms => 'ROMs temporárias';

  @override
  String get summarySavedRoms => 'ROMs salvas';

  @override
  String get defaultValue => '(padrão)';

  @override
  String pdfPageIndicator(int current, int total) {
    return 'Página $current de $total';
  }

  @override
  String get pdfZoomOut => 'Diminuir zoom (-)';

  @override
  String get pdfZoomIn => 'Aumentar zoom (+)';

  @override
  String get pdfResetZoom => 'Redefinir zoom (0)';

  @override
  String get pdfFirstPage => 'Primeira página (Home)';

  @override
  String get pdfPreviousPage => 'Página anterior (←/PgUp)';

  @override
  String get pdfNextPage => 'Próxima página (→/PgDn)';

  @override
  String get pdfLastPage => 'Última página (End)';

  @override
  String get pdfFileNotFound => 'Arquivo PDF não encontrado';

  @override
  String confirmDeleteEmulator(String system) {
    return 'Tem certeza de que deseja excluir a configuração do emulador para $system?';
  }

  @override
  String commandsConfigured(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comandos configurados',
      one: '1 comando configurado',
    );
    return '$_temp0';
  }

  @override
  String get noCommand => 'Sem comando';

  @override
  String get reloadConfigTooltip => 'Recarregar configuração (R)';

  @override
  String get configurationInfo => 'Informações de configuração';

  @override
  String get configLocation => 'Local da configuração:';

  @override
  String get hasLocalOverridesYes => 'Tem substituições locais: Sim';

  @override
  String get hasLocalOverridesNo => 'Tem substituições locais: Não';

  @override
  String get changesSavedToDevice =>
      'Suas alterações são salvas no armazenamento do dispositivo.';

  @override
  String get usingBundledConfig =>
      'Usando configuração incluída. Edite para criar substituições locais.';

  @override
  String get noEmulatorsConfigured => 'Nenhum emulador configurado';

  @override
  String get addFirstEmulator => 'Adicione seu primeiro emulador para começar';

  @override
  String get edit => 'Editar';

  @override
  String get editEmulator => 'Editar emulador';

  @override
  String get system => 'Sistema';

  @override
  String get systemHint => 'e.g., nes, snes, ps1';

  @override
  String get commands => 'Comandos';

  @override
  String commandNumber(int number) {
    return 'Comando $number';
  }

  @override
  String get commandHint => 'e.g., ../retroarch.AppImage -f -L core.so';

  @override
  String get remove => 'Remover';

  @override
  String get options => 'Opções';

  @override
  String get biosDownloading => 'A descarregar...';

  @override
  String downloadRequiredAndExtras(int requiredCount, int optionalCount) {
    return 'Descarregar $requiredCount obrigatórios + $optionalCount extras';
  }

  @override
  String downloadRequiredFiles(int requiredCount) {
    return 'Descarregar $requiredCount ficheiros obrigatórios';
  }

  @override
  String downloadOptionalExtras(int optionalCount) {
    return 'Descarregar $optionalCount extras opcionais';
  }

  @override
  String get downloadFiles => 'Descarregar ficheiros';

  @override
  String batchDownloadConfirmation(int totalFiles, int platformCount) {
    return 'Serão descarregados $totalFiles ficheiros BIOS para $platformCount plataformas:';
  }

  @override
  String get downloadSourceNote =>
      'Os ficheiros serão descarregados do repositório retroarch_system.';

  @override
  String get biosOptional => 'OPCIONAL';

  @override
  String biosFilesFound(int foundCount, int totalCount) {
    return '$foundCount/$totalCount ficheiros encontrados';
  }

  @override
  String optionalExtrasAvailable(int count) {
    return '+$count extras opcionais disponíveis';
  }

  @override
  String get biosLocations => 'Localizações:';

  @override
  String get availableForDownload =>
      'Disponível para download de múltiplas fontes';

  @override
  String get summary => 'Resumo';

  @override
  String get biosComplete => 'Completo';

  @override
  String get biosPartial => 'Parcial';

  @override
  String get biosFiles => 'Ficheiros';

  @override
  String get biosDownloadable => 'Descarregável';

  @override
  String get refreshF5Tooltip => 'Atualizar (F5)';

  @override
  String get allBiosFilesFound => 'Todos os ficheiros BIOS encontrados!';

  @override
  String get noBiosRequirements => 'Nenhum requisito de BIOS encontrado';

  @override
  String platformCount(int count) {
    return '$count plataformas';
  }

  @override
  String failedToLoadBiosStatus(String error) {
    return 'Falha ao carregar o estado do BIOS: $error';
  }

  @override
  String get refreshStatus => 'Atualizar estado';

  @override
  String platformsCompleteCount(int complete, int total) {
    return '$complete/$total plataformas completas';
  }

  @override
  String get platformStatusHeader => 'Estado das plataformas';

  @override
  String filesVerifiedStatus(
    int presentFiles,
    int totalFiles,
    int verifiedFiles,
  ) {
    return '$presentFiles/$totalFiles ficheiros ($verifiedFiles verificados)';
  }

  @override
  String get biosCollectionOverview => 'Visão geral da coleção BIOS';

  @override
  String get biosVerified => 'Verificado';

  @override
  String downloadComingSoon(String platformName) {
    return 'Funcionalidade de download para $platformName - Em breve!';
  }

  @override
  String get noGamepadConnected => 'Nenhum controle conectado';

  @override
  String get connectGamepadPrompt =>
      'Conecte um controle e pressione qualquer botão';

  @override
  String get pressButtonToTest =>
      'Pressione qualquer botão para testar (ações desativadas)';

  @override
  String get buttonFunctionTests => 'Testes de funções dos botões';

  @override
  String get gamepadASelect => 'A (Selecionar)';

  @override
  String get gamepadBBack => 'B (Voltar)';

  @override
  String get gamepadXSearch => 'X (Buscar)';

  @override
  String get gamepadYHelp => 'Y (Ajuda)';

  @override
  String get gamepadLBPageDown => 'LB (Página abaixo)';

  @override
  String get gamepadRBPageUp => 'RB (Página acima)';

  @override
  String get gamepadStartMenu => 'Start (Menu)';

  @override
  String get gamepadSelectSettings => 'Select (Configurações)';

  @override
  String get gamepadLSClick => 'LS Clique';

  @override
  String get gamepadRSView => 'RS Clique (Visualizar)';

  @override
  String get gamepadLTTrigger => 'LT (Gatilho)';

  @override
  String get gamepadRTTrigger => 'RT (Gatilho)';

  @override
  String get rawButtonStates => 'Estados brutos dos botões';

  @override
  String get noButtonsPressed => 'Nenhum botão pressionado';

  @override
  String get axisValues => 'Valores dos eixos';

  @override
  String get noAxisMovement => 'Sem movimento de eixos';

  @override
  String get dpadLeftStick => 'D-Pad + Stick esquerdo';

  @override
  String get webSettingsDescription =>
      'Configurar definições específicas da plataforma web';

  @override
  String get corsProxyWhyNeeded => 'Por que é necessário um proxy CORS?';

  @override
  String get corsProxyExplanation =>
      'Os navegadores bloqueiam downloads de ROM de servidores externos devido a restrições de segurança CORS. Um proxy CORS retransmite a solicitação de um servidor que você controla, adicionando os cabeçalhos necessários.\n\nForsaken inclui um Cloudflare Worker que você pode implantar gratuitamente (100k solicitações/dia). Consulte o diretório tools/cors-proxy-worker/ para instruções de configuração.';

  @override
  String get corsProxyUrl => 'URL do proxy CORS';

  @override
  String get corsProxyHelperText =>
      'Deixe vazio para desativar o proxy CORS (ROMs de servidores sem CORS falharão)';

  @override
  String get testingProxy => 'Testando proxy...';

  @override
  String get testProxyConnection => 'Testar conexão do proxy';

  @override
  String get noProxyUrlConfigured => 'Nenhuma URL de proxy configurada';

  @override
  String proxyWorking(int statusCode) {
    return 'O proxy está funcionando (HTTP $statusCode)';
  }

  @override
  String proxyReturnedHttp(int statusCode) {
    return 'O proxy retornou HTTP $statusCode';
  }

  @override
  String get connectionTimedOut => 'Conexão expirou';

  @override
  String get corsProxySettingsSaved =>
      'Configurações do proxy CORS salvas. Aplica-se imediatamente para novos lançamentos de ROM.';

  @override
  String get quickDeploy => 'Implantação rápida';

  @override
  String get corsProxyDeploySteps =>
      '1. Cadastre-se em dash.cloudflare.com (gratuito)\n2. Instale o Wrangler: npm install -g wrangler\n3. Login: wrangler login\n4. cd tools/cors-proxy-worker\n5. npx wrangler deploy\n6. Cole a URL do worker acima';

  @override
  String get permanentStorage => 'Armazenamento permanente';

  @override
  String get temporaryStorage => 'Armazenamento temporário';

  @override
  String get noDownloadedRoms => 'Nenhuma ROM baixada';

  @override
  String get biosErrorNetworkMessage => 'Falha na conexão de rede';

  @override
  String get biosErrorNetworkSuggestions =>
      'Verifique sua conexão com a internet\nTente novamente em alguns instantes\nVerifique as configurações de DNS\nTente usar uma VPN se o acesso for restrito';

  @override
  String get biosErrorFileNotFoundMessage =>
      'Arquivo não encontrado no servidor';

  @override
  String get biosErrorFileNotFoundSuggestions =>
      'O arquivo BIOS pode ter sido movido ou renomeado\nTente baixar de uma fonte alternativa\nVerifique se o arquivo existe em outra branch/repositório\nReporte este problema se ele persistir';

  @override
  String get biosErrorAccessDeniedMessage => 'Acesso negado pelo servidor';

  @override
  String get biosErrorAccessDeniedSuggestions =>
      'O servidor pode estar bloqueando downloads\nTente novamente mais tarde - o servidor pode estar temporariamente restrito\nUse VPN se o acesso for restrito por região\nVerifique se é necessária autenticação';

  @override
  String get biosErrorRateLimitedMessage => 'Limite de requisições excedido';

  @override
  String get biosErrorRateLimitedSuggestions =>
      'Aguarde alguns minutos antes de tentar novamente\nReduza o número de downloads simultâneos\nO servidor está se protegendo contra requisições excessivas';

  @override
  String get biosErrorChecksumMessage =>
      'Falha na verificação de integridade do arquivo';

  @override
  String get biosErrorChecksumSuggestions =>
      'O arquivo pode ter sido corrompido durante o download\nTente baixar novamente\nVerifique se o arquivo foi atualizado no servidor\nVerifique a estabilidade da sua conexão';

  @override
  String get biosErrorSizeMismatchMessage => 'Tamanho de arquivo inesperado';

  @override
  String get biosErrorSizeMismatchSuggestions =>
      'O arquivo pode ser uma versão diferente da esperada\nO download pode estar incompleto\nTente baixar novamente\nVerifique o espaço disponível em disco';

  @override
  String get biosErrorStorageMessage => 'Erro de armazenamento';

  @override
  String get biosErrorStorageSuggestions =>
      'Libere espaço em disco\nVerifique as permissões de arquivo\nCertifique-se de que o diretório de destino é gravável\nTente baixar em outro local';

  @override
  String get biosErrorTimeoutMessage => 'Tempo limite de download excedido';

  @override
  String get biosErrorTimeoutSuggestions =>
      'A conexão de internet pode estar lenta\nO servidor pode estar sobrecarregado\nTente novamente com uma conexão estável\nVerifique se o firewall está bloqueando a conexão';

  @override
  String get biosErrorArchiveMessage => 'Falha na extração do arquivo';

  @override
  String get biosErrorArchiveSuggestions =>
      'O arquivo baixado pode estar corrompido\nTente baixar o arquivo novamente\nVerifique se a ferramenta de extração correta está disponível\nVerifique se o arquivo é um formato de arquivo válido';

  @override
  String get biosErrorUnknownMessage => 'Falha no download';

  @override
  String get biosErrorUnknownSuggestions =>
      'Tente baixar novamente\nVerifique sua conexão com a internet\nVerifique se o arquivo ainda está disponível\nEntre em contato com o suporte se o problema persistir';
}
