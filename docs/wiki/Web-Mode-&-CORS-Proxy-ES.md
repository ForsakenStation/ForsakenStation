> **Idioma**: [English](Web-Mode-&-CORS-Proxy) | **Español**

# Modo Web y Proxy CORS

Forsaken puede ejecutarse en el navegador integrando **EmulatorJS** (`web/emulatorjs/`).

## Configuración del Proxy CORS
Los navegadores bloquean descargas de ROMs desde otros dominios si el servidor no envía cabeceras CORS.
1. Abre **Ajustes → Ajustes Web**.
2. Introduce la **URL de tu Proxy CORS** (puedes desplegar el worker incluido en `tools/cors-proxy-worker/`).
3. Guarda los cambios y lanza cualquier plataforma compatible en Web.
