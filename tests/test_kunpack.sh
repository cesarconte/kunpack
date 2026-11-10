#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Cesar <yugurta@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later
# test_kunpack.sh: Suite de pruebas automatizadas para kunpack

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KUNPACK="${SCRIPT_DIR}/../bin/kunpack"
TEST_ROOT="$(mktemp -d /tmp/kunpack_test_XXXXXX)"

cleanup() {
    rm -rf "$TEST_ROOT"
}
trap cleanup EXIT

echo "=== INICIANDO SUITE DE PRUEBAS DE KUNPACK ==="

# Test 1: Archivo con múltiples ficheros sueltos en raíz -> debe crear subcarpeta
echo -n "[Test 1] Múltiples ficheros en raíz (prevención de zipbomb)... "
T1_DIR="${TEST_ROOT}/t1"
mkdir -p "$T1_DIR/src" "$T1_DIR/run"
echo "A" > "$T1_DIR/src/f1.txt"
echo "B" > "$T1_DIR/src/f2.txt"
tar -czf "$T1_DIR/run/multi.tar.gz" -C "$T1_DIR/src" f1.txt f2.txt

"$KUNPACK" --keep -q "$T1_DIR/run/multi.tar.gz"

if [ -d "$T1_DIR/run/multi" ] && [ -f "$T1_DIR/run/multi/f1.txt" ] && [ -f "$T1_DIR/run/multi/f2.txt" ]; then
    echo "✅ PASADO"
else
    echo "❌ FALLADO: no se creó la subcarpeta 'multi'"
    exit 1
fi

# Test 2: Archivo con una sola carpeta raíz -> NO debe duplicar anidamiento
echo -n "[Test 2] Carpeta raíz única (sin anidamiento redundante)... "
T2_DIR="${TEST_ROOT}/t2"
mkdir -p "$T2_DIR/src/my_app" "$T2_DIR/run"
echo "code" > "$T2_DIR/src/my_app/main.py"
tar -czf "$T2_DIR/run/package.tar.gz" -C "$T2_DIR/src" my_app

"$KUNPACK" --keep -q "$T2_DIR/run/package.tar.gz"

# Debe existir run/my_app/main.py y NO run/package/my_app/main.py
if [ -d "$T2_DIR/run/my_app" ] && [ -f "$T2_DIR/run/my_app/main.py" ] && [ ! -d "$T2_DIR/run/package" ]; then
    echo "✅ PASADO"
else
    echo "❌ FALLADO: se detectó anidamiento redundante"
    ls -la "$T2_DIR/run"
    exit 1
fi

# Test 3: Archivo con carpeta real + metadatos __MACOSX -> limpia __MACOSX y desanida
echo -n "[Test 3] Limpieza de __MACOSX y desanidamiento inteligente... "
T3_DIR="${TEST_ROOT}/t3"
mkdir -p "$T3_DIR/run"
python3 -c "
import zipfile
with zipfile.ZipFile('$T3_DIR/run/mac_bundle.zip', 'w') as z:
    z.writestr('app_core/app.sh', '#!/bin/sh\necho hi')
    z.writestr('__MACOSX/._app.sh', 'metadata')
"

"$KUNPACK" --keep -q "$T3_DIR/run/mac_bundle.zip"

if [ -d "$T3_DIR/run/app_core" ] && [ -f "$T3_DIR/run/app_core/app.sh" ] && [ ! -d "$T3_DIR/run/__MACOSX" ] && [ ! -d "$T3_DIR/run/mac_bundle" ]; then
    echo "✅ PASADO"
else
    echo "❌ FALLADO: no se desanidó o no se limpió __MACOSX"
    ls -la "$T3_DIR/run"
    exit 1
fi

# Test 4: Parámetro --keep (conservar archivo original)
echo -n "[Test 4] Verificación de preservación con --keep... "
T4_DIR="${TEST_ROOT}/t4"
mkdir -p "$T4_DIR"
echo "sample" > "$T4_DIR/hello.txt"
tar -czf "$T4_DIR/keep_test.tar.gz" -C "$T4_DIR" hello.txt
rm "$T4_DIR/hello.txt"

"$KUNPACK" --keep -q "$T4_DIR/keep_test.tar.gz"

if [ -f "$T4_DIR/keep_test.tar.gz" ]; then
    echo "✅ PASADO"
else
    echo "❌ FALLADO: el archivo original fue eliminado a pesar de --keep"
    exit 1
fi

# Test 5: Parámetro de destino personalizado (-o / --dest)
echo -n "[Test 5] Destino personalizado con -o... "
T5_DIR="${TEST_ROOT}/t5"
mkdir -p "$T5_DIR/source" "$T5_DIR/custom_out"
echo "custom" > "$T5_DIR/source/item.txt"
tar -czf "$T5_DIR/source/custom.tar.gz" -C "$T5_DIR/source" item.txt

"$KUNPACK" --keep -q -o "$T5_DIR/custom_out" "$T5_DIR/source/custom.tar.gz"

if [ -f "$T5_DIR/custom_out/item.txt" ] || [ -f "$T5_DIR/custom_out/custom/item.txt" ]; then
    echo "✅ PASADO"
else
    echo "❌ FALLADO: no se extrajo en custom_out"
    exit 1
fi

echo ""
echo "🎉 ¡TODAS LAS PRUEBAS (5/5) SE COMPLETARON CON ÉXITO!"
