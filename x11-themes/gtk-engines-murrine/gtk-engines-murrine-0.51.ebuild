# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="${PN##*-}"
MY_P="${MY_PN}-${PV}"
CFGRATOR="${MY_PN}-configurator-0.5"
DESCRIPTION="Murrine GTK+2 Cairo Engine"
HOMEPAGE="http://cimi.netsons.org/pages/murrine.php"
BASE_URI="http://cimi.netsons.org/media/download_gallery/"
SRC_URI="
	${BASE_URI}${MY_PN}/${MY_P}.tar.bz2
	${BASE_URI}MurrineThemePack.tar.bz2
	${BASE_URI}MurrinaAquaIsh.tar.bz2
	${BASE_URI}MurrinaFancyCandy.tar.bz2
	${BASE_URI}MurrinaGilouche.tar.bz2
	${BASE_URI}MurrinaGilouche.tar.bz2
	${BASE_URI}MurrinaVerdeOlivo.tar.bz2
	gnome? ( ${BASE_URI}${MY_PN}/${CFGRATOR}.tar.bz2 )
	metacity? (
		http://www.kernow-webhosting.com/~bvc/theme/mcity/Murrine.tar.gz
	)
"
RESTRICT="primaryuri"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gnome metacity"

RDEPEND="
	>=x11-libs/gtk+-2.8
	gnome? ( gnome-extra/zenity )
"
DEPEND="
	${RDEPEND}
"

src_compile() {
	econf \
		--disable-dependency-tracking \
		--enable-animation \
		|| die
	emake || die
}

src_install() {
	einstall || die
	insinto /usr/share/themes
	doins -r ${WORKDIR}/Murrin*
	if use gnome; then
		cd ${WORKDIR}/${CFGRATOR}/files
		exeinto /usr/bin
		doexe murrine-configurator
		insinto /usr/share/applications
		doins murrine-configurator.desktop
		insinto /usr/share/pixmaps
		doins murrine-configurator.png
	fi
}
