# Maintainer: Cesar <yugurta@gmail.com>
# Contributor: CachyOS Linux Architect Team

pkgname=kunpack
pkgver=1.0.0
pkgrel=1
pkgdesc="Smart archive unpacker with auto-clean to trash and nested folder prevention for KDE Plasma 6 / Dolphin"
arch=('any')
url="https://github.com/cesarconte/kunpack"
license=('GPL-3.0-or-later')
depends=(
    'python'
    'ark'
    'libnotify'
    'glib2'
)
optdepends=(
    'p7zip: Support for legacy 7z archives'
    'unrar: Support for RAR archives'
    'dolphin: KDE file manager with context menu integration'
)
source=("${pkgname}-${pkgver}.tar.gz::https://github.com/cesarconte/${pkgname}/archive/v${pkgver}.tar.gz")
sha256sums=('SKIP')

package() {
    cd "${srcdir}/${pkgname}-${pkgver}" 2>/dev/null || cd "${srcdir}/${pkgname}" 2>/dev/null || cd "${startdir}"

    install -Dm755 bin/kunpack "${pkgdir}/usr/bin/kunpack"
    install -Dm644 data/kunpack_servicemenu.desktop "${pkgdir}/usr/share/kio/servicemenus/org.cesar.kunpack.desktop"
    install -Dm644 data/org.cesar.kunpack.desktop "${pkgdir}/usr/share/applications/org.cesar.kunpack.desktop"
    install -Dm644 README.md "${pkgdir}/usr/share/doc/${pkgname}/README.md"
}
