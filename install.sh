#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
# install.sh: Instalador autónomo de kunpack para KDE Plasma 6 / Dolphin

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
APPS_DIR="${HOME}/.local/share/applications"
SERVICEMENUS_DIR="${HOME}/.local/share/kio/servicemenus"

echo "==> Instalando kunpack (Descompresión Inteligente & Auto-limpieza)..."

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

# 2. Instalar ejecutable
mkdir -p "$BIN_DIR"
install -m 755 "${SCRIPT_DIR}/bin/kunpack" "${BIN_DIR}/kunpack"
echo "  ✓ Binario instalado en ${BIN_DIR}/kunpack"

# 3. Instalar menú de servicio para Dolphin
mkdir -p "$SERVICEMENUS_DIR"
install -m 644 "${SCRIPT_DIR}/data/kunpack_servicemenu.desktop" "${SERVICEMENUS_DIR}/org.cesar.kunpack.desktop"
echo "  ✓ Menú de contexto para Dolphin instalado en ${SERVICEMENUS_DIR}/org.cesar.kunpack.desktop"

# 4. Instalar lanzador de aplicaciones y asociación MIME
mkdir -p "$APPS_DIR"
install -m 644 "${SCRIPT_DIR}/data/org.cesar.kunpack.desktop" "${APPS_DIR}/org.cesar.kunpack.desktop"
echo "  ✓ Lanzador registrado en ${APPS_DIR}/org.cesar.kunpack.desktop"

# 5. Actualizar bases de datos de escritorio de KDE
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$APPS_DIR" >/dev/null 2>&1 || true
fi

if command -v kbuildsycoca6 >/dev/null 2>&1; then
    kbuildsycoca6 --noincremental >/dev/null 2>&1 || true
    echo "  ✓ Base de datos Sycoca de KDE actualizada"
fi

echo ""
echo "🎉 ¡Instalación de kunpack completada con éxito!"
echo "   Puedes usarlo desde el menú contextual de Dolphin (clic derecho en cualquier comprimido),"
echo "   asociarlo como descompresor predeterminado o ejecutar 'kunpack <archivo>' en la terminal."
