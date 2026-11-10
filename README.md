# kunpack 📦

> **Descompresión Inteligente & Auto-limpieza estilo *The Unarchiver* de macOS para KDE Plasma 6 y Dolphin.**

`kunpack` es una utilidad nativa, rápida y ligera diseñada para CachyOS / Arch Linux y KDE Plasma 6 que elimina toda la fricción al descomprimir archivos en el escritorio.

---

## ✨ Características

- 🧠 **Sin carpetas anidadas redundantes:** Si un archivo comprimido ya contiene una única carpeta raíz con su contenido dentro, la extrae directamente sin envolverla en otra carpeta duplicada.
- 🛡️ **Prevención de Tarbombs / Zipbombs:** Si el archivo contiene múltiples archivos sueltos en su raíz, crea automáticamente una subcarpeta con el nombre del archivador para no ensuciar tu escritorio o carpeta de descargas.
- 🍏 **Limpieza de metadatos:** Detecta y suprime automáticamente artefactos residuales de macOS (`__MACOSX`, `.DS_Store`) y Windows (`Thumbs.db`).
- 🗑️ **Auto-limpieza a la Papelera de Plasma:** Tras finalizar la extracción con éxito (`exit 0`), envía automáticamente el archivo comprimido original a la Papelera oficial de FreeDesktop / KIO (`trash:/`), manteniendo tus carpetas limpias sin riesgo de pérdida permanente de datos.
- 🐬 **Integración con Dolphin:** Menú contextual integrado al hacer clic derecho sobre cualquier archivo comprimido (`.zip`, `.tar.*`, `.7z`, `.rar`, `.gz`, `.xz`, `.zst`, `.iso`):
  - *Extraer inteligentemente y limpiar (a Papelera)*
  - *Extraer inteligentemente (conservar original)*
- 🔔 **Notificaciones OSD Interactivas:** Notificación nativa con botón directo para `[📂 Abrir carpeta]`.

---

## 🚀 Instalación Rápida

```bash
git clone https://github.com/cesarconte/kunpack.git
cd kunpack
./install.sh
```

O si prefieres instalarlo mediante paquete del sistema en Arch / CachyOS:

```bash
makepkg -si
```

---

## 💻 Uso en Terminal

```bash
# Descomprimir inteligentemente y enviar el original a la papelera (por defecto)
kunpack archivo.zip

# Descomprimir pero conservar el archivo original
kunpack -k archivo.tar.gz
kunpack --keep archivo.tar.gz

# Descomprimir en un directorio específico
kunpack -o ~/Documentos/Destino proyecto.7z

# Descomprimir y abrir la carpeta inmediatamente en Dolphin
kunpack --open paquete.zip

# Descomprimir múltiples archivos a la vez
kunpack *.zip
```

---

## 🧪 Pruebas Automatizadas

El repositorio incluye una suite completa de verificación:

```bash
./tests/test_kunpack.sh
```

---

## 🗑️ Desinstalación

```bash
./uninstall.sh
```

---

## 📄 Licencia

GPLv3. Desarrollado para el entorno KDE Plasma 6 sobre Wayland.
