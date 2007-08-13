# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="${PN##*-}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Murrine GTK+2 Cairo Engine"
HOMEPAGE="http://murrine.netsons.org/"
BASE_URI="${HOMEPAGE}files/"
SRC_URI="
	${BASE_URI}${MY_P}.tar.bz2 ${BASE_URI}MurrineThemePack.tar.bz2
	${BASE_URI}MurrinaAquaIsh.tar.bz2 ${BASE_URI}MurrinaFancyCandy.tar.bz2
	${BASE_URI}MurrinaLoveGray.tar.bz2 ${BASE_URI}MurrinaGilouche.tar.bz2
	${BASE_URI}MurrinaVerdeOlivo.tar.bz2
	gnome? ( ${BASE_URI}nmc.tar_3.bz2 )
	metacity? (
		http://www.gnome-look.org/CONTENT/content-files/57999-Murrine.tar.gz
		${BASE_URI}MurrineRounded.tar.bz2
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
	gnome? ( dev-python/pygtk )
"
DEPEND="
	${RDEPEND}
"

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}
	tar -xf nmc.tar_3
}

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
		cd ${WORKDIR}/newmurrineconfigurator/src
		insinto /usr/share/applications
		doins murrine-configurator.desktop
		insinto /usr/share/pixmaps
		doins murrine-configurator.png
		insinto /usr/share/nmc
		doins *.{glade,py}
		fperms 0755 /usr/share/nmc/newmurrineconfigurator.py
	fi
}
