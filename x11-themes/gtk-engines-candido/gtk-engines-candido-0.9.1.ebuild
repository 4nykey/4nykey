# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="${PN##*-}-engine"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Candido is the Gtk2 cairo-based engine"
HOMEPAGE="http://candido.berlios.de/"
BASE_URI="http://candido.berlios.de/media/download_gallery/"
SRC_URI="
	mirror://berlios/candido/${MY_P}.tar.bz2
	${BASE_URI}Candido.tar.bz2
	${BASE_URI}Candido-Calm.tar.bz2
	${BASE_URI}Candido-Candy.tar.bz2
	${BASE_URI}Candido-DarkOrange.tar.bz2
	${BASE_URI}Candido-Hybrid.tar.bz2
	${BASE_URI}Candido-Graphite.tar.bz2
	${BASE_URI}Candido-Redux.tar.bz2
	${BASE_URI}Candido-NeoGraphite.tar.bz2
	gdm? ( ${BASE_URI}Candido-Gdm.tar.bz2 )
	metacity? (
		mirror://berlios/candido/Candido-Engine-Metacity.tar.bz2
		${BASE_URI}Candido-Selected.tar.bz2
		${BASE_URI}Candido-Graphite-Metacity-Fat.tar.bz2
	)
	kde? (
		${BASE_URI}Candido-Kde.tar.bz2
		${BASE_URI}Candido-Graphite-Kde.tar.bz2
	)
"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gdm kde metacity"

DEPEND=">=x11-libs/gtk+-2.8
	kde? ( kde-base/kdelibs )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use kde; then
		KDEDIR="$(kde-config --prefix)/share/apps/kdisplay/color-schemes"
	fi
	GTKDIR="/usr/share/themes"
	GDMDIR="/usr/share/gdm/themes"
}

src_compile() {
	econf --enable-animation || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	# kde color schemes
	if use kde; then
		dodir ${KDEDIR}
		mv "${WORKDIR}"/*.kcsrc "${D}"${KDEDIR}
	fi

	# gdm greeter
	if use gdm; then
		dodir ${GDMDIR}/Candido
		mv "${WORKDIR}"/Candido/*.{jpg,png,xml,desktop} "${D}"${GDMDIR}/Candido
	fi

	# remaining: gtk+/metacity themes
	insinto ${GTKDIR}
	doins -r "${WORKDIR}"/Candido* "${D}"${GTKDIR}
}
