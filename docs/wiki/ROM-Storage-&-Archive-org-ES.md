> **Idioma**: [English](ROM-Storage-&-Archive-org) | **Español**

# Almacenamiento de ROMs y Archive.org

## Almacenamiento Temporal vs Permanente
- **Temporal (`ROM_TEMP_PATH`)**: Las ROMs descargadas se guardan temporalmente y se limpian al cerrar el emulador. Al terminar, Forsaken te pregunta si quieres conservarlas.
- **Permanente (`ROM_FOREVER_PATH`)**: Las ROMs guardadas o extraídas permanecen en disco y aparecen en la colección **Downloaded**.
- Gestiona o libera espacio desde **Ajustes → Gestión de Almacenamiento de ROMs**.

## Credenciales de Archive.org
Algunos elementos de Archive.org requieren sesión autenticada (`401` / `403`). Configura tus claves S3 gratuitas en **Ajustes → Configuración de Archive.org**:
- **Access Key** y **Secret Key** obtenidas en `https://archive.org/account/s3.php`
- Las cabeceras de autenticación se mantienen automáticamente tras redirecciones de Archive.org (`archive.org` → `ia*.us.archive.org`).
