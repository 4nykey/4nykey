# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit qt4-r2 multilib

DESCRIPTION="Use Fingerprint Devices with Linux"
HOMEPAGE="http://www.n-view.net/Appliance/fingerprint/"
SRC_URI="http://www.n-view.net/Appliance/fingerprint/download/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	!sys-auth/pam_fprint
	!sys-auth/fprintd
	!sys-auth/thinkfinger
	>=sys-auth/libfprint-0.1.0_pre2
	x11-libs/libfakekey
	>=app-crypt/qca-2.0.0
	>=app-crypt/qca-ossl-2.0.0_beta3
	sys-auth/upekbsapi-bin[headers]
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake4 \
		PREFIX="$EROOT/usr" \
		LIB="$(get_libdir)" \
		LIBEXEC=libexec \
		LIBPOLKIT_QT=LIBPOLKIT_QT_1_1 || die "qmake4 failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" DESTDIR="${D}" install || die "emake install failed"
	domenu bin/fingerprint-gui/fingerprint-gui.desktop
	dodoc CHANGELOG README
}

pkg_postinst() {
	elog "1) You may want to add the followingline to the first of /etc/pam.d/system-auth"
	elog "   auth        sufficient  pam_fingerprint-gui.so"
	elog "2) You must be in the plugdev group to use fingerprint"
}
