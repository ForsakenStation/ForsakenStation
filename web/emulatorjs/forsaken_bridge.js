/**
 * Forsaken Emulator - EmulatorJS Bridge
 *
 * This script provides a bridge between Flutter Web and EmulatorJS CDN.
 * It dynamically loads EmulatorJS and manages emulator instances.
 *
 * IMPORTANT: All mutable state is stored in a module-level Map
 * (window._forsakenState) keyed by container ID, NOT on `this`.
 * Dart's JSObject.callMethod can lose `this` binding for class methods,
 * so reading/writing `this.xyz` inside methods called from Dart will
 * silently fail (return undefined).  By using a global state store we
 * sidestep the problem entirely.
 */

// ---------------------------------------------------------------------------
// Debug gating — set window.FORSAKEN_DEBUG = true to enable console output.
// Can be toggled from Dart via js_interop.
// ---------------------------------------------------------------------------
if (window.FORSAKEN_DEBUG === undefined) {
    window.FORSAKEN_DEBUG = false;
}

function _log(...args) {
    if (window.FORSAKEN_DEBUG) console.log(...args);
}

function _warn(...args) {
    if (window.FORSAKEN_DEBUG) console.warn(...args);
}

function _error(...args) {
    if (window.FORSAKEN_DEBUG) console.error(...args);
}

const EMULATORJS_CDN = 'https://cdn.emulatorjs.org/stable/data/';

/**
 * Platform name to EmulatorJS system name mapping.
 *
 * EmulatorJS expects a "system" identifier (not a RetroArch core name).
 * Internally it maps the system to the default RetroArch core.
 * See getCores() in emulator.js for the canonical list.
 *
 * Keys: Forsaken platform identifiers (lowercase).
 * Values: EmulatorJS system names.
 */
const PLATFORM_TO_SYSTEM = {
    // Nintendo
    'nes': 'nes',
    'snes': 'snes',
    'n64': 'n64',
    'gb': 'gb',
    'gbc': 'gb',           // EmulatorJS handles GB/GBC with the same system
    'gba': 'gba',
    'nds': 'nds',
    'vb': 'vb',
    'virtualboy': 'vb',

    // Sega
    'genesis': 'segaMD',
    'megadrive': 'segaMD',
    'sms': 'segaMS',
    'mastersystem': 'segaMS',
    'gamegear': 'segaGG',
    'gg': 'segaGG',
    'segacd': 'segaCD',
    'sega32x': 'sega32x',
    '32x': 'sega32x',
    'saturn': 'segaSaturn',

    // Sony
    'psx': 'psx',
    'ps1': 'psx',
    'psp': 'psp',

    // Arcade
    'arcade': 'arcade',
    'mame': 'mame',
    'neogeo': 'arcade',    // Neo Geo runs on arcade (fbneo)

    // Other
    'atari2600': 'atari2600',
    'atari7800': 'atari7800',
    'lynx': 'lynx',
    'atarilynx': 'lynx',
    'jaguar': 'jaguar',
    'atarijaguar': 'jaguar',
    'pce': 'pce',
    'pcengine': 'pce',
    'pcenginecd': 'pce',
    'ngp': 'ngp',
    'ngpc': 'ngp',
    'ws': 'ws',
    'wsc': 'ws',
    'wonderswan': 'ws',
    'wonderswancolor': 'ws',
    '3do': '3do',
    'coleco': 'coleco',
    'colecovision': 'coleco',

    // Atari 5200
    'atari5200': 'atari5200',
    '5200': 'atari5200',

    // Amstrad CPC (core name used as system — EmulatorJS passes it through)
    'amstradcpc': 'cap32',
    'cpc': 'cap32',

    // ZX Spectrum (core name used as system)
    'zxspectrum': 'fuse',
    'spectrum': 'fuse',

    // ZX81 (core name used as system)
    'zx81': '81',

    // PC-FX
    'pcfx': 'pcfx',

    // DOOM (core name used as system)
    'doom': 'prboom',
    'prboom': 'prboom',

    // Amiga
    'amiga': 'amiga',
    'amiga500': 'amiga',
    'amiga600': 'amiga',
    'amiga1200': 'amiga',
    'cdtv': 'amiga',

    // CD-i (core name used as a system)
    'cdi': 'same_cdi',

    // DOS
    'dos': 'dos',

    // Commodore
    'c64': 'c64',
    'c128': 'c128',
    'pet': 'pet',
    'plus4': 'plus4',
    'cplus4': 'plus4',
    'vic20': 'vic20',
};

/**
 * Get the EmulatorJS system name for a Forsaken platform
 */
function getSystemForPlatform(platform) {
    const normalized = platform.toLowerCase().replace(/[^a-z0-9]/g, '');
    return PLATFORM_TO_SYSTEM[ normalized ] || null;
}

// ---------------------------------------------------------------------------
// Module-level state store — immune to `this` binding issues
// ---------------------------------------------------------------------------
window._forsakenState = window._forsakenState || {};

/** Get (or create) the state object for a given container */
function _getState(containerId) {
    if (!window._forsakenState[ containerId ]) {
        window._forsakenState[ containerId ] = {
            containerId: containerId,
            container: null,
            currentCore: null,
            currentRom: null,
            currentRomBlob: null,
            currentPlatform: null,
            currentCoreUrl: null,
            isLoading: false,
            isRunning: false,
            initPromise: null,
            emulatorInstance: null,
            callbacks: {
                onReady: () => {
                },
                onError: (error) => _error('EmulatorJS Error:', error),
                onLoadingProgress: (progress) => _log('Loading:', progress),
                onCoreLoaded: () => {
                },
                onRomLoaded: () => {
                },
                onPause: () => {
                },
                onResume: () => {
                },
            },
        };
    }
    return window._forsakenState[ containerId ];
}

/**
 * Main Forsaken Emulator class that wraps EmulatorJS.
 *
 * Methods read/write via _getState(this.containerId) so that even if
 * Dart's callMethod loses `this`, the containerId stored at construction
 * time is still usable — and as a belt-and-suspenders measure we also
 * stash the containerId on the state object itself.
 */
class ForsakenEmulatorJS {
    constructor(containerElementId, options = {}) {
        // This is the ONLY field we store on the instance — it's set once in
        // the constructor (which is NOT called via callMethod, so `this` is
        // fine here) and never mutated.
        this._cid = containerElementId;

        const s = _getState(containerElementId);

        s.callbacks = {
            onReady: options.onReady || (() => {
            }),
            onError: options.onError || ((error) => _error('EmulatorJS Error:', error)),
            onLoadingProgress: options.onLoadingProgress || ((progress) => _log('Loading:', progress)),
            onCoreLoaded: options.onCoreLoaded || (() => {
            }),
            onRomLoaded: options.onRomLoaded || (() => {
            }),
            onPause: options.onPause || (() => {
            }),
            onResume: options.onResume || (() => {
            }),
        };

        // Start async initialization
        s.initPromise = this._initialize(containerElementId);
    }

    // --- internal helpers (always receive containerId explicitly) ---

    /**
     * Wait for container element to appear in DOM
     */
    async _waitForContainer(containerId, maxWaitMs = 10000) {
        const startTime = Date.now();
        let attempts = 0;

        _log(`[ForsakenEmulator] Waiting for container: ${containerId}`);

        while (Date.now() - startTime < maxWaitMs) {
            // Try multiple selectors
            let element = document.getElementById(containerId);

            if (!element) {
                element = document.querySelector(`#${CSS.escape(containerId)}`);
            }

            // Check if inside flt-platform-view
            if (!element) {
                const platformViews = document.querySelectorAll('flt-platform-view');
                for (const pv of platformViews) {
                    const inner = pv.querySelector(`#${CSS.escape(containerId)}`);
                    if (inner) {
                        element = inner;
                        break;
                    }
                    if (pv.shadowRoot) {
                        const shadowInner = pv.shadowRoot.querySelector(`#${CSS.escape(containerId)}`);
                        if (shadowInner) {
                            element = shadowInner;
                            break;
                        }
                    }
                }
            }

            if (element) {
                _log(`[ForsakenEmulator] Container found after ${attempts} attempts: ${containerId}`);
                return element;
            }

            attempts++;
            await new Promise(resolve => setTimeout(resolve, 100));
        }

        _error('[ForsakenEmulator] Container not found. Available elements:');
        _error('  - IDs:', Array.from(document.querySelectorAll('[id]')).map(e => e.id).slice(0, 20));
        _error('  - Platform views:', document.querySelectorAll('flt-platform-view').length);

        throw new Error(`Container element with ID '${containerId}' not found after ${maxWaitMs}ms (${attempts} attempts)`);
    }

    /**
     * Initialize the container
     */
    async _initialize(containerId) {
        const s = _getState(containerId);
        try {
            s.container = await this._waitForContainer(containerId);

            s.container.innerHTML = '';
            s.container.style.cssText = `
        width: 100%;
        height: 100%;
        background: #000;
        display: flex;
        align-items: center;
        justify-content: center;
        position: relative;
      `;

            _showMessage(containerId, 'Ready to load game', 'Select a ROM to start playing');

            _log('ForsakenEmulatorJS initialized for container:', containerId);
            return true;
        } catch (error) {
            _error('ForsakenEmulatorJS initialization failed:', error);
            s.callbacks.onError(error.message);
            return false;
        }
    }

    // --- public API (called from Dart via callMethod) ---
    // Every method resolves containerId from this._cid, then uses _getState().
    // If `this` is broken, _cid will be undefined — so we also accept an
    // explicit first-arg override from the Dart side as a last resort.

    /** Resolve the container ID regardless of whether `this` binding works. */
    _resolveId() {
        // this._cid was set in the constructor
        const cid = this._cid;
        if (cid) return cid;
        // Fallback: scan state store for the single entry (most apps have one)
        const keys = Object.keys(window._forsakenState || {});
        if (keys.length === 1) return keys[ 0 ];
        _error('[ForsakenEmulator] Cannot resolve containerId — this._cid is', cid);
        return null;
    }

    /**
     * Ensure initialization is complete
     */
    async _ensureInit() {
        const cid = this._resolveId();
        if (!cid) throw new Error('Cannot resolve container ID');
        const s = _getState(cid);
        if (s.initPromise) {
            await s.initPromise;
        }
        if (!s.container) {
            throw new Error('Emulator container not initialized');
        }
        return { cid, s };
    }

    /**
     * Load a core for a platform.
     * @param {string} coreUrl - CDN URL for the core (pre-cached by Dart)
     * @param {string} platform - Platform identifier
     */
    async loadCore(coreUrl, platform) {
        const { cid, s } = await this._ensureInit();

        if (s.isLoading) {
            throw new Error('Already loading');
        }

        s.isLoading = true;

        try {
            const systemName = getSystemForPlatform(platform);
            if (!systemName) {
                throw new Error(`Unsupported platform: ${platform}`);
            }

            s.currentCore = systemName;
            s.currentPlatform = platform;
            s.currentCoreUrl = coreUrl || null;

            s.callbacks.onLoadingProgress({
                stage: 'core',
                progress: 1.0,
                message: `Core ready: ${systemName}`
            });

            _showMessage(cid, `${platform.toUpperCase()} ready`, 'Waiting for ROM...');

            s.callbacks.onCoreLoaded();
            _log(`Core prepared: ${systemName} (system) for platform: ${platform}`);
            if (coreUrl) {
                _log(`Core pre-cached URL: ${coreUrl}`);
            }

        } catch (error) {
            _showMessage(cid, 'Error', error.message);
            s.callbacks.onError(`Failed to load core: ${error.message}`);
            throw error;
        } finally {
            s.isLoading = false;
        }
    }

    /**
     * Load a ROM from a URL.
     *
     * We download the ROM ourselves via fetch (which handles CORS proxied
     * URLs correctly), then hand EmulatorJS a blob: URL.  This avoids two
     * problems:
     *   1. EmulatorJS's XHR download can fail with CORS or redirect issues.
     *   2. EmulatorJS derives the ROM filename from the URL path, which
     *      breaks when the URL goes through a CORS proxy query parameter.
     *      A blob: URL forces it to fall back to EJS_gameName.
     *
     * @param {string} romUrl - Direct (or CORS-proxied) URL to the ROM file
     * @param {string} fileName - Original ROM filename (e.g. '1942a.zip')
     */
    async loadRomFromUrl(romUrl, fileName) {
        const { cid, s } = await this._ensureInit();

        if (!s.currentCore) {
            throw new Error('Core not loaded. Load a core first.');
        }

        if (s.isLoading) {
            throw new Error('Already loading');
        }

        s.isLoading = true;

        try {
            const platform = s.currentPlatform || '';
            if (!platform) {
                _warn('[ForsakenIDB] currentPlatform is empty — ROM cache key will use empty platform string');
            }
            _log(`[ForsakenIDB] loadRomFromUrl: platform="${platform}" fileName="${fileName}"`);
            let romData = null;

            // --- Check IndexedDB cache (forever first, then temp) ---
            try {
                const foreverData = await window.forsakenRomStorage.getFromForever(platform, fileName);
                if (foreverData) {
                    _log(`ROM found in forever storage: ${fileName} (${foreverData.byteLength} bytes)`);
                    romData = foreverData;
                } else {
                    const tempData = await window.forsakenRomStorage.getFromTemp(platform, fileName);
                    if (tempData) {
                        _log(`ROM found in temp storage: ${fileName} (${tempData.byteLength} bytes)`);
                        romData = tempData;
                    }
                }
            } catch (cacheErr) {
                _warn('IndexedDB cache lookup failed, will download:', cacheErr);
            }

            if (romData) {
                s.callbacks.onLoadingProgress({
                    stage: 'rom',
                    progress: 0.5,
                    message: 'ROM loaded from cache'
                });
                _showMessage(cid, 'Loading cached ROM', fileName, true);
            } else {
                // --- Download from network ---
                s.callbacks.onLoadingProgress({
                    stage: 'rom',
                    progress: 0,
                    message: 'Downloading ROM...'
                });
                _showMessage(cid, 'Downloading ROM', fileName, true);

                _log(`Fetching ROM: ${fileName} from ${romUrl}`);
                const response = await fetch(romUrl);
                if (!response.ok) {
                    throw new Error(`ROM download failed: ${response.status} ${response.statusText}`);
                }

                romData = await response.arrayBuffer();
                _log(`ROM downloaded: ${fileName} (${romData.byteLength} bytes)`);

                // Save to temp storage for future use.
                // Clone the ArrayBuffer so we keep a pristine copy — the original
                // may be consumed / neutered when creating the Blob below.
                try {
                    const romDataCopy = romData.slice(0);
                    _log(`[ForsakenIDB] Saving to temp: platform=${platform} fileName=${fileName} size=${romDataCopy.byteLength} isArrayBuffer=${romDataCopy instanceof ArrayBuffer}`);
                    await window.forsakenRomStorage.saveToTemp(platform, fileName, romDataCopy);
                    _log(`[ForsakenIDB] ROM saved to temp storage: ${fileName}`);
                } catch (saveErr) {
                    _error('[ForsakenIDB] FAILED to cache ROM in IndexedDB:', saveErr);
                    _error('[ForsakenIDB] Error details:', saveErr.name, saveErr.message, saveErr.stack);
                }
            }

            // Create a blob URL — EmulatorJS handles blob: URLs well and
            // falls back to EJS_gameName for the filename.
            const blob = new Blob([romData], { type: 'application/octet-stream' });
            s.currentRomBlob = URL.createObjectURL(blob);
            s.currentRom = fileName;

            s.callbacks.onLoadingProgress({
                stage: 'rom',
                progress: 0.5,
                message: 'ROM ready, initializing emulator...'
            });

            // Launch with all values from the state store
            await _launchEmulatorJS(cid);

            s.callbacks.onLoadingProgress({
                stage: 'rom',
                progress: 1.0,
                message: 'ROM loaded successfully'
            });

            s.callbacks.onRomLoaded();

        } catch (error) {
            _showMessage(cid, 'Error', error.message);
            s.callbacks.onError(`Failed to load ROM from URL: ${error.message}`);
            throw error;
        } finally {
            s.isLoading = false;
        }
    }

    /**
     * Load a ROM into the emulator
     * @param {Uint8Array|ArrayBuffer} romData - ROM file data
     * @param {string} fileName - Original ROM filename
     */
    async loadRom(romData, fileName) {
        const { cid, s } = await this._ensureInit();

        if (!s.currentCore) {
            throw new Error('Core not loaded. Load a core first.');
        }

        if (s.isLoading) {
            throw new Error('Already loading');
        }

        s.isLoading = true;

        try {
            s.callbacks.onLoadingProgress({
                stage: 'rom',
                progress: 0,
                message: 'Preparing ROM...'
            });

            _showMessage(cid, 'Loading ROM', fileName, true);

            const romBytes = romData instanceof ArrayBuffer ? new Uint8Array(romData) : romData;

            const blob = new Blob([romBytes], { type: 'application/octet-stream' });
            s.currentRomBlob = URL.createObjectURL(blob);
            s.currentRom = fileName;

            _log(`ROM prepared: ${fileName} (${romBytes.length} bytes)`);

            s.callbacks.onLoadingProgress({
                stage: 'rom',
                progress: 0.5,
                message: 'ROM ready, initializing emulator...'
            });

            await _launchEmulatorJS(cid);

            s.callbacks.onLoadingProgress({
                stage: 'rom',
                progress: 1.0,
                message: 'ROM loaded successfully'
            });

            s.callbacks.onRomLoaded();

        } catch (error) {
            _showMessage(cid, 'Error', error.message);
            s.callbacks.onError(`Failed to load ROM: ${error.message}`);
            throw error;
        } finally {
            s.isLoading = false;
        }
    }

    /**
     * Start the emulator (called after core and ROM are loaded)
     */
    start() {
        const cid = this._resolveId();
        if (!cid) return;
        const s = _getState(cid);

        if (!s.currentCore || !s.currentRom) {
            throw new Error('Core and ROM must be loaded before starting');
        }

        if (s.emulatorInstance && s.emulatorInstance.started) {
            if (typeof s.emulatorInstance.play === 'function') {
                s.emulatorInstance.play();
            }
        } else {
            _log('Emulator not fully started yet — EJS_startOnLoaded will handle it.');
        }

        s.isRunning = true;
        s.callbacks.onReady();
        _log('Emulator started');
    }

    /**
     * Pause the emulator
     */
    pause() {
        const cid = this._resolveId();
        if (!cid) return;
        const s = _getState(cid);

        if (s.emulatorInstance && s.emulatorInstance.started && typeof s.emulatorInstance.pause === 'function') {
            s.emulatorInstance.pause();
            s.isRunning = false;
            s.callbacks.onPause();
            _log('Emulator paused');
        }
    }

    /**
     * Resume the emulator
     */
    resume() {
        const cid = this._resolveId();
        if (!cid) return;
        const s = _getState(cid);

        if (s.emulatorInstance && s.emulatorInstance.started && typeof s.emulatorInstance.play === 'function') {
            s.emulatorInstance.play();
            s.isRunning = true;
            s.callbacks.onResume();
            _log('Emulator resumed');
        }
    }

    /**
     * Reset the emulator
     */
    reset() {
        const cid = this._resolveId();
        if (!cid) return;
        const s = _getState(cid);

        if (s.emulatorInstance && s.emulatorInstance.started && typeof s.emulatorInstance.restart === 'function') {
            s.emulatorInstance.restart();
            _log('Emulator reset');
        }
    }

    /**
     * Stop and cleanup the emulator
     */
    stop() {
        const cid = this._resolveId();
        if (!cid) return;
        const s = _getState(cid);

        _log('Stopping emulator...');

        if (s.emulatorInstance && typeof s.emulatorInstance.pause === 'function') {
            try {
                s.emulatorInstance.pause();
            } catch (e) {
                _warn('Error pausing emulator:', e);
            }
        }

        if (s.currentRomBlob && s.currentRomBlob.startsWith('blob:')) {
            URL.revokeObjectURL(s.currentRomBlob);
        }
        s.currentRomBlob = null;

        s.currentCore = null;
        s.currentRom = null;
        s.currentPlatform = null;
        s.currentCoreUrl = null;
        s.isRunning = false;
        s.emulatorInstance = null;

        if (s.container) {
            s.container.innerHTML = '';
            _showMessage(cid, 'Emulator stopped', 'Select a ROM to play again');
        }

        _log('Emulator stopped');
    }

    /**
     * Create a save state
     * @returns {Promise<ArrayBuffer>}
     */
    async createSaveState() {
        const cid = this._resolveId();
        if (!cid) throw new Error('Cannot resolve container ID');
        const s = _getState(cid);

        if (!s.emulatorInstance) {
            throw new Error('Emulator not running');
        }

        try {
            if (typeof s.emulatorInstance.saveState === 'function') {
                const state = s.emulatorInstance.saveState();
                _log('Save state created');
                return state;
            } else {
                _warn('Save state not supported by this core');
                return new ArrayBuffer(0);
            }
        } catch (e) {
            _error('Error creating save state:', e);
            throw e;
        }
    }

    /**
     * Load a save state
     * @param {ArrayBuffer} saveData
     */
    async loadSaveState(saveData) {
        const cid = this._resolveId();
        if (!cid) throw new Error('Cannot resolve container ID');
        const s = _getState(cid);

        if (!s.emulatorInstance) {
            throw new Error('Emulator not running');
        }

        try {
            if (typeof s.emulatorInstance.loadState === 'function') {
                s.emulatorInstance.loadState(saveData);
                _log('Save state loaded');
            } else {
                _warn('Load state not supported by this core');
            }
        } catch (e) {
            _error('Error loading save state:', e);
            throw e;
        }
    }

    /**
     * Take a screenshot
     * @returns {Promise<string>} Base64 encoded PNG
     */
    async getScreenshot() {
        const cid = this._resolveId();
        if (!cid) throw new Error('Cannot resolve container ID');
        const s = _getState(cid);

        if (!s.emulatorInstance) {
            throw new Error('Emulator not running');
        }

        try {
            if (typeof s.emulatorInstance.screenshot === 'function') {
                const screenshot = s.emulatorInstance.screenshot();
                _log('Screenshot captured');
                return screenshot;
            } else {
                const canvas = s.container.querySelector('canvas');
                if (canvas) {
                    return canvas.toDataURL('image/png');
                }
                _warn('Screenshot not available');
                return null;
            }
        } catch (e) {
            _error('Error taking screenshot:', e);
            return null;
        }
    }

    /**
     * Get emulator status
     */
    getStatus() {
        const cid = this._resolveId();
        if (!cid) {
            return { isLoaded: false, isLoading: false, container: 'unknown' };
        }
        const s = _getState(cid);
        return {
            isLoaded: !!(s.currentCore && s.currentRom),
            currentCore: s.currentCore,
            currentRom: s.currentRom,
            currentPlatform: s.currentPlatform,
            isLoading: s.isLoading,
            isRunning: s.isRunning,
            container: cid,
            hasEmulatorInstance: !!s.emulatorInstance,
        };
    }

    /**
     * Enter fullscreen mode
     */
    async enterFullscreen() {
        const cid = this._resolveId();
        if (!cid) return;
        const s = _getState(cid);

        try {
            if (s.container && s.container.requestFullscreen) {
                await s.container.requestFullscreen();
            } else if (s.emulatorInstance && typeof s.emulatorInstance.fullscreen === 'function') {
                s.emulatorInstance.fullscreen(true);
            }
        } catch (e) {
            _error('Error entering fullscreen:', e);
        }
    }

    /**
     * Exit fullscreen mode
     */
    async exitFullscreen() {
        const cid = this._resolveId();
        if (!cid) return;
        const s = _getState(cid);

        try {
            if (document.fullscreenElement) {
                await document.exitFullscreen();
            } else if (s.emulatorInstance && typeof s.emulatorInstance.fullscreen === 'function') {
                s.emulatorInstance.fullscreen(false);
            }
        } catch (e) {
            _error('Error exiting fullscreen:', e);
        }
    }

    /**
     * Toggle mute
     */
    toggleMute() {
        const cid = this._resolveId();
        if (!cid) return;
        const s = _getState(cid);

        if (s.emulatorInstance && typeof s.emulatorInstance.mute === 'function') {
            s.emulatorInstance.mute();
        }
    }

    /**
     * Set volume (0.0 - 1.0)
     */
    setVolume(volume) {
        const cid = this._resolveId();
        if (!cid) return;
        const s = _getState(cid);

        if (s.emulatorInstance && typeof s.emulatorInstance.setVolume === 'function') {
            s.emulatorInstance.setVolume(volume);
        }
    }
}

// ---------------------------------------------------------------------------
// Module-level helper functions (no `this` dependency at all)
// ---------------------------------------------------------------------------

/**
 * Show a message in the container
 */
function _showMessage(containerId, title, subtitle = '', showSpinner = false) {
    const s = _getState(containerId);
    if (!s.container) return;

    const spinnerHtml = showSpinner ? `
    <div style="
      width: 40px;
      height: 40px;
      border: 3px solid rgba(255,255,255,0.2);
      border-top-color: #fff;
      border-radius: 50%;
      animation: forsaken-spin 1s linear infinite;
      margin-bottom: 16px;
    "></div>
    <style>
      @keyframes forsaken-spin {
        to { transform: rotate(360deg); }
      }
    </style>
  ` : `
    <div style="font-size: 48px; margin-bottom: 16px;">🎮</div>
  `;

    s.container.innerHTML = `
    <div style="
      text-align: center;
      color: #fff;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    ">
      ${spinnerHtml}
      <div style="font-size: 18px; font-weight: 500;">${title}</div>
      ${subtitle ? `<div style="font-size: 14px; margin-top: 8px; opacity: 0.7;">${subtitle}</div>` : ''}
    </div>
  `;
}

/**
 * Launch EmulatorJS — reads all config from the state store.
 * This is a plain function, not a method, so `this` is irrelevant.
 */
async function _launchEmulatorJS(containerId) {
    const s = _getState(containerId);

    if (!s.currentCore || !s.currentRomBlob) {
        throw new Error('Core and ROM must be set before launching');
    }

    _log('Launching EmulatorJS...');
    _log('System:', s.currentCore);
    _log('Platform:', s.currentPlatform);
    _log('ROM URL:', s.currentRomBlob);
    _log('ROM Name:', s.currentRom);

    // Clear the container
    s.container.innerHTML = '';

    // Create game container div
    const gameDiv = document.createElement('div');
    gameDiv.id = `${containerId}-game`;
    gameDiv.style.cssText = 'width: 100%; height: 100%;';
    s.container.appendChild(gameDiv);

    // Set up EmulatorJS global configuration
    window.EJS_player = `#${gameDiv.id}`;
    window.EJS_core = s.currentCore;
    window.EJS_gameUrl = s.currentRomBlob;
    window.EJS_gameName = s.currentRom;
    window.EJS_pathtodata = EMULATORJS_CDN;
    window.EJS_startOnLoaded = true;
    window.EJS_color = '#1a1a2e';
    window.EJS_backgroundColor = '#000';
    window.EJS_fullscreenOnLoaded = false;

    // Touch controls on mobile
    window.EJS_VirtualGamepadSettings = undefined;

    // Callbacks
    window.EJS_onGameStart = () => {
        _log('EmulatorJS: Game started');
        s.isRunning = true;
        s.callbacks.onReady();
    };

    window.EJS_onLoadState = (state) => {
        _log('EmulatorJS: State loaded');
    };

    window.EJS_onSaveState = (state) => {
        _log('EmulatorJS: State saved');
    };

    // Remove any existing EmulatorJS script to reload fresh
    const existingScript = document.getElementById('emulatorjs-loader');
    if (existingScript) {
        existingScript.remove();
    }

    // Clear any existing EJS instance
    if (window.EJS_emulator) {
        try {
            window.EJS_emulator = null;
        } catch (e) {
            _warn('Could not clear existing emulator:', e);
        }
    }

    // Load EmulatorJS loader script
    return new Promise((resolve, reject) => {
        const script = document.createElement('script');
        script.id = 'emulatorjs-loader';
        script.src = `${EMULATORJS_CDN}loader.js`;

        script.onload = () => {
            _log('EmulatorJS loader script loaded');

            const checkEmulator = setInterval(() => {
                if (window.EJS_emulator) {
                    clearInterval(checkEmulator);
                    s.emulatorInstance = window.EJS_emulator;
                    _log('EmulatorJS instance ready');
                    resolve();
                }
            }, 100);

            // Timeout after 60 seconds
            setTimeout(() => {
                clearInterval(checkEmulator);
                if (!window.EJS_emulator) {
                    reject(new Error('EmulatorJS failed to initialize within timeout'));
                }
            }, 60000);
        };

        script.onerror = (error) => {
            reject(new Error(`Failed to load EmulatorJS: ${error}`));
        };

        document.body.appendChild(script);
    });
}

// ---------------------------------------------------------------------------
// IndexedDB ROM storage — used by Dart via top-level functions
// ---------------------------------------------------------------------------

const FORSAKEN_DB_NAME = 'ForsakenRomStorage';
const FORSAKEN_DB_VERSION = 1;
const ROM_STORE_TEMP = 'temp_roms';
const ROM_STORE_FOREVER = 'forever_roms';

/**
 * Open (or create) the Forsaken ROM IndexedDB database.
 * Returns a Promise<IDBDatabase>.
 */
function _openRomDB() {
    return new Promise((resolve, reject) => {
        _log('[ForsakenIDB] Opening database:', FORSAKEN_DB_NAME, 'v' + FORSAKEN_DB_VERSION);
        const request = indexedDB.open(FORSAKEN_DB_NAME, FORSAKEN_DB_VERSION);

        request.onupgradeneeded = (event) => {
            _log('[ForsakenIDB] onupgradeneeded — creating object stores');
            const db = event.target.result;
            if (!db.objectStoreNames.contains(ROM_STORE_TEMP)) {
                db.createObjectStore(ROM_STORE_TEMP, { keyPath: ['platform', 'fileName'] });
                _log('[ForsakenIDB] Created store:', ROM_STORE_TEMP);
            }
            if (!db.objectStoreNames.contains(ROM_STORE_FOREVER)) {
                db.createObjectStore(ROM_STORE_FOREVER, { keyPath: ['platform', 'fileName'] });
                _log('[ForsakenIDB] Created store:', ROM_STORE_FOREVER);
            }
        };

        request.onsuccess = () => {
            _log('[ForsakenIDB] Database opened successfully, stores:', Array.from(request.result.objectStoreNames));
            resolve(request.result);
        };
        request.onerror = () => {
            _error('[ForsakenIDB] Database open error:', request.error);
            reject(request.error);
        };
        request.onblocked = () => {
            _warn('[ForsakenIDB] Database open BLOCKED — close other tabs using this DB');
        };
    });
}

/**
 * Save a ROM blob into the given store.
 * @param {string} storeName - ROM_STORE_TEMP or ROM_STORE_FOREVER
 * @param {string} platform
 * @param {string} fileName
 * @param {ArrayBuffer} data
 * @returns {Promise<boolean>}
 */
async function _saveRomToStore(storeName, platform, fileName, data) {
    _log(`[ForsakenIDB] saveToStore: store=${storeName} platform=${platform} fileName=${fileName} dataType=${typeof data} isArrayBuffer=${data instanceof ArrayBuffer} isUint8Array=${data instanceof Uint8Array} size=${data?.byteLength ?? '?'}`);

    // Validate inputs
    if (!platform || typeof platform !== 'string') {
        throw new Error(`[ForsakenIDB] Invalid platform: ${platform}`);
    }
    if (!fileName || typeof fileName !== 'string') {
        throw new Error(`[ForsakenIDB] Invalid fileName: ${fileName}`);
    }
    if (!data) {
        throw new Error(`[ForsakenIDB] No data provided`);
    }

    // Ensure we have an ArrayBuffer (IndexedDB stores structured-cloneable data)
    let arrayBufferData = data;
    if (data instanceof Uint8Array) {
        arrayBufferData = data.buffer.slice(data.byteOffset, data.byteOffset + data.byteLength);
        _log('[ForsakenIDB] Converted Uint8Array to ArrayBuffer, size:', arrayBufferData.byteLength);
    } else if (!(data instanceof ArrayBuffer)) {
        throw new Error(`[ForsakenIDB] Data must be ArrayBuffer or Uint8Array, got ${typeof data} (constructor: ${data?.constructor?.name})`);
    }

    // Check for detached/neutered ArrayBuffer
    if (arrayBufferData.byteLength === 0 && data.byteLength !== 0) {
        throw new Error('[ForsakenIDB] ArrayBuffer appears to be detached/neutered (byteLength is 0 after conversion)');
    }

    const db = await _openRomDB();
    return new Promise((resolve, reject) => {
        try {
            const tx = db.transaction(storeName, 'readwrite');
            const store = tx.objectStore(storeName);
            const record = {
                platform: platform,
                fileName: fileName,
                data: arrayBufferData,
                size: arrayBufferData.byteLength,
                savedAt: Date.now(),
            };
            _log('[ForsakenIDB] Putting record with key:', [platform, fileName], 'size:', arrayBufferData.byteLength);
            const putRequest = store.put(record);
            putRequest.onsuccess = () => {
                _log(`[ForsakenIDB] put() succeeded for: ${storeName}/${platform}/${fileName}`);
            };
            putRequest.onerror = (event) => {
                _error(`[ForsakenIDB] put() error:`, putRequest.error, event);
            };
            tx.oncomplete = () => {
                _log(`[ForsakenIDB] Save complete: ${storeName}/${platform}/${fileName} (${arrayBufferData.byteLength} bytes)`);
                db.close();
                resolve(true);
            };
            tx.onerror = (event) => {
                _error(`[ForsakenIDB] Save tx error:`, tx.error, event);
                db.close();
                reject(tx.error);
            };
            tx.onabort = (event) => {
                _error(`[ForsakenIDB] Save tx ABORTED:`, tx.error, event);
                db.close();
                reject(tx.error || new Error('Transaction aborted'));
            };
        } catch (e) {
            _error('[ForsakenIDB] Synchronous error in save:', e);
            db.close();
            reject(e);
        }
    });
}

/**
 * Find a ROM in the given store.
 * @param {string} storeName
 * @param {string} platform
 * @param {string} fileName
 * @returns {Promise<{data: ArrayBuffer, size: number, savedAt: number}|null>}
 */
async function _findRomInStore(storeName, platform, fileName) {
    const db = await _openRomDB();
    return new Promise((resolve, reject) => {
        const tx = db.transaction(storeName, 'readonly');
        const store = tx.objectStore(storeName);
        const request = store.get([platform, fileName]);
        request.onsuccess = () => {
            db.close();
            resolve(request.result || null);
        };
        request.onerror = () => {
            db.close();
            reject(request.error);
        };
    });
}

/**
 * Delete a ROM from the given store.
 * @returns {Promise<boolean>}
 */
async function _deleteRomFromStore(storeName, platform, fileName) {
    const db = await _openRomDB();
    return new Promise((resolve, reject) => {
        const tx = db.transaction(storeName, 'readwrite');
        const store = tx.objectStore(storeName);
        store.delete([platform, fileName]);
        tx.oncomplete = () => {
            db.close();
            resolve(true);
        };
        tx.onerror = () => {
            db.close();
            reject(tx.error);
        };
    });
}

/**
 * Get all ROMs in a store, optionally filtered by platform.
 * @returns {Promise<Array>}
 */
async function _getAllRomsInStore(storeName, platform) {
    const db = await _openRomDB();
    return new Promise((resolve, reject) => {
        const tx = db.transaction(storeName, 'readonly');
        const store = tx.objectStore(storeName);
        const request = store.getAll();
        request.onsuccess = () => {
            db.close();
            let results = request.result || [];
            if (platform) {
                results = results.filter(r => r.platform === platform);
            }
            resolve(results);
        };
        request.onerror = () => {
            db.close();
            reject(request.error);
        };
    });
}

/**
 * Delete all ROMs in a store, optionally filtered by platform.
 * @returns {Promise<number>} number of deleted items
 */
async function _clearRomsInStore(storeName, platform) {
    const db = await _openRomDB();
    return new Promise((resolve, reject) => {
        const tx = db.transaction(storeName, 'readwrite');
        const store = tx.objectStore(storeName);

        if (!platform) {
            store.clear();
            tx.oncomplete = () => {
                db.close();
                resolve(-1);
            };
            tx.onerror = () => {
                db.close();
                reject(tx.error);
            };
            return;
        }

        // Filtered delete — iterate all keys
        const cursorReq = store.openCursor();
        let count = 0;
        cursorReq.onsuccess = (event) => {
            const cursor = event.target.result;
            if (cursor) {
                if (cursor.value.platform === platform) {
                    cursor.delete();
                    count++;
                }
                cursor.continue();
            }
        };
        tx.oncomplete = () => {
            db.close();
            resolve(count);
        };
        tx.onerror = () => {
            db.close();
            reject(tx.error);
        };
    });
}

// ---------------------------------------------------------------------------
// Public API for Dart — exposed as window.forsakenRomStorage.*
// ---------------------------------------------------------------------------

window.forsakenRomStorage = {
    /**
     * Save ROM data to temp storage.
     * @returns {Promise<boolean>}
     */
    saveToTemp: (platform, fileName, data) =>
        _saveRomToStore(ROM_STORE_TEMP, platform, fileName, data),

    /**
     * Save ROM data to forever (permanent) storage.
     * @returns {Promise<boolean>}
     */
    saveToForever: (platform, fileName, data) =>
        _saveRomToStore(ROM_STORE_FOREVER, platform, fileName, data),

    /**
     * Find ROM in forever storage.
     * @returns {Promise<boolean>} true if exists
     */
    findInForever: async (platform, fileName) => {
        const result = await _findRomInStore(ROM_STORE_FOREVER, platform, fileName);
        return result !== null;
    },

    /**
     * Find ROM in temp storage.
     * @returns {Promise<boolean>} true if exists
     */
    findInTemp: async (platform, fileName) => {
        const result = await _findRomInStore(ROM_STORE_TEMP, platform, fileName);
        return result !== null;
    },

    /**
     * Get ROM data from forever storage.
     * @returns {Promise<ArrayBuffer|null>}
     */
    getFromForever: async (platform, fileName) => {
        const result = await _findRomInStore(ROM_STORE_FOREVER, platform, fileName);
        return result ? result.data : null;
    },

    /**
     * Get ROM data from temp storage.
     * @returns {Promise<ArrayBuffer|null>}
     */
    getFromTemp: async (platform, fileName) => {
        const result = await _findRomInStore(ROM_STORE_TEMP, platform, fileName);
        return result ? result.data : null;
    },

    /**
     * Move a ROM from temp to forever storage.
     * @returns {Promise<boolean>}
     */
    moveToForever: async (platform, fileName) => {
        const record = await _findRomInStore(ROM_STORE_TEMP, platform, fileName);
        if (!record) return false;
        await _saveRomToStore(ROM_STORE_FOREVER, platform, fileName, record.data);
        await _deleteRomFromStore(ROM_STORE_TEMP, platform, fileName);
        return true;
    },

    /**
     * Delete ROM from temp storage.
     * @returns {Promise<boolean>}
     */
    deleteFromTemp: (platform, fileName) =>
        _deleteRomFromStore(ROM_STORE_TEMP, platform, fileName),

    /**
     * Delete ROM from forever storage.
     * @returns {Promise<boolean>}
     */
    deleteFromForever: (platform, fileName) =>
        _deleteRomFromStore(ROM_STORE_FOREVER, platform, fileName),

    /**
     * Clean up all temp ROMs (optionally for a specific platform).
     * @returns {Promise<number>}
     */
    cleanupTemp: (platform) => _clearRomsInStore(ROM_STORE_TEMP, platform || null),

    /**
     * Get storage stats.
     * @returns {Promise<Object>}
     */
    getStats: async () => {
        const tempRoms = await _getAllRomsInStore(ROM_STORE_TEMP);
        const foreverRoms = await _getAllRomsInStore(ROM_STORE_FOREVER);
        const tempSize = tempRoms.reduce((sum, r) => sum + (r.size || 0), 0);
        const foreverSize = foreverRoms.reduce((sum, r) => sum + (r.size || 0), 0);
        return {
            tempPath: 'IndexedDB (temp)',
            foreverPath: 'IndexedDB (permanent)',
            tempSize: tempSize,
            foreverSize: foreverSize,
            tempCount: tempRoms.length,
            foreverCount: foreverRoms.length,
        };
    },
};

// ---------------------------------------------------------------------------
// Global instance management
// ---------------------------------------------------------------------------
window.ForsakenEmulators = window.ForsakenEmulators || {};

/**
 * Create a new emulator instance
 */
function createForsakenEmulator(containerId, options = {}) {
    // Clean up existing instance if any
    if (window.ForsakenEmulators[ containerId ]) {
        try {
            window.ForsakenEmulators[ containerId ].stop();
        } catch (e) {
            _warn('Error cleaning up existing emulator:', e);
        }
    }

    const emulator = new ForsakenEmulatorJS(containerId, options);
    window.ForsakenEmulators[ containerId ] = emulator;
    return emulator;
}

/**
 * Get an existing emulator instance
 */
function getForsakenEmulator(containerId) {
    return window.ForsakenEmulators[ containerId ] || null;
}

/**
 * Get list of supported platforms
 */
function getSupportedPlatforms() {
    return Object.keys(PLATFORM_TO_SYSTEM);
}

/**
 * Check if a platform is supported
 */
function isPlatformSupported(platform) {
    return getSystemForPlatform(platform) !== null;
}

// Export for module systems
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        ForsakenEmulatorJS,
        createForsakenEmulator,
        getForsakenEmulator,
        getSupportedPlatforms,
        isPlatformSupported,
        getSystemForPlatform,
        PLATFORM_TO_SYSTEM,
    };
}

_log('Forsaken EmulatorJS Bridge loaded (EmulatorJS CDN integration)');
_log('Supported platforms:', Object.keys(PLATFORM_TO_SYSTEM).join(', '));

// ---------------------------------------------------------------------------
// Proactively open the IndexedDB database on page load so that:
//   1. The DB and object stores appear immediately in DevTools.
//   2. Any permission / quota errors surface early.
// ---------------------------------------------------------------------------
(async () => {
    try {
        const db = await _openRomDB();
        _log('[ForsakenIDB] Database pre-initialized successfully. Stores:', Array.from(db.objectStoreNames));
        db.close();
    } catch (e) {
        _error('[ForsakenIDB] Failed to pre-initialize database:', e);
    }
})();
