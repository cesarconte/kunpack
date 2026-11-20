#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
# install.sh: Instalador autónomo de kunpack para KDE Plasma 6 / Dolphin (instalación estricta en /usr)

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_PATH="/usr/bin/kunpack"
SERVICEMENUS_PATH="/usr/share/kio/servicemenus/org.cesar.kunpack.desktop"
APPS_PATH="/usr/share/applications/org.cesar.kunpack.desktop"

echo "==> Instalando kunpack (Descompresión Inteligente & Auto-limpieza) estrictamente en /usr..."

# 1. Comprobar dependencias
MISSING_DEPS=()
for dep in python3 ark notify-send; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        MISSING_DEPS+=("$dep")
    fi
done

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo "⚠️  Faltan dependencias del sistema: ${MISSING_DEPS[*]}"
    if command -v pacman >/dev/null 2>&1; then
        echo "--> Puedes instalarlas en CachyOS/Arch con:"
        echo "    sudo pacman -S --needed python ark libnotify glib2"
    fi
fi

# 2. Instalar ejecutable en /usr/bin
sudo -n install -m 755 "${SCRIPT_DIR}/bin/kunpack" "$BIN_PATH"
echo "  ✓ Binario instalado en $BIN_PATH"

# 3. Instalar menú de servicio para Dolphin en /usr/share/kio/servicemenus
sudo -n install -m 644 "${SCRIPT_DIR}/data/kunpack_servicemenu.desktop" "$SERVICEMENUS_PATH"
echo "  ✓ Menú de contexto para Dolphin instalado en $SERVICEMENUS_PATH"

# 4. Instalar lanzador de aplicaciones y asociación MIME en /usr/share/applications
sudo -n install -m 644 "${SCRIPT_DIR}/data/org.cesar.kunpack.desktop" "$APPS_PATH"
echo "  ✓ Lanzador registrado en $APPS_PATH"

# 5. Actualizar bases de datos de escritorio de KDE
if command -v update-desktop-database >/dev/null 2>&1; then
    sudo -n update-desktop-database "/usr/share/applications" >/dev/null 2>&1 || true
fi

if command -v kbuildsycoca6 >/dev/null 2>&1; then
    kbuildsycoca6 --noincremental >/dev/null 2>&1 || true
    echo "  ✓ Base de datos Sycoca de KDE actualizada"
fi

echo ""
echo "🎉 ¡Instalación de kunpack completada con éxito en /usr!"
echo "   Puedes usarlo desde el menú contextual de Dolphin (clic derecho en cualquier comprimido),"
echo "   asociarlo como descompresor predeterminado o ejecutar 'kunpack <archivo>' en la terminal."
