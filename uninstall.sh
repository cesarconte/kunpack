#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
# uninstall.sh: Desinstalador de kunpack

set -eo pipefail

echo "==> Desinstalando kunpack de /usr..."

sudo -n rm -f "/usr/bin/kunpack"
sudo -n rm -f "/usr/share/kio/servicemenus/org.cesar.kunpack.desktop"
sudo -n rm -f "/usr/share/applications/org.cesar.kunpack.desktop"

if command -v update-desktop-database >/dev/null 2>&1; then
    sudo -n update-desktop-database "/usr/share/applications" >/dev/null 2>&1 || true
fi

if command -v kbuildsycoca6 >/dev/null 2>&1; then
    kbuildsycoca6 --noincremental >/dev/null 2>&1 || true
fi

echo "✓ Desinstalación de kunpack completada."
