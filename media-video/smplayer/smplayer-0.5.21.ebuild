# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt3 qt4

THV="0.1.3"
DESCRIPTION="A Qt based frontend for mplayer"
HOMEPAGE="http://smplayer.sf.net"
BASEURI="http://smplayer.sf.net/linux/download"
SRC_URI="
	${BASEURI}/${P}.tar.gz
	themes? ( ${BASEURI}/${PN}-themes-${THV}.tar.gz )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="qt4 kde themes"

DEPEND="
	!qt4? ( $(qt_min_version 3) )
	qt4? ( $(qt4_min_version 4) )
	kde? ( kde-base/kdelibs )
"
RDEPEND="
	${DEPEND}
"

pkg_setup() {
	if use qt4 && ! built_with_use 'x11-libs/qt:4' qt3support; then
		eerror 'Please emerge x11-libs/qt:4 with USE=qt3support'
		die 'need qt3support when building with qt4'
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	use qt4 && make prep
}

src_compile() {
	local myconf
	if use qt4; then
		myconf="QMAKE=/usr/bin/qmake"
	else
		myconf="QMAKE=${QTDIR}/bin/qmake"
		use kde && myconf="${myconf} KDE_SUPPORT=y"
	fi
	emake PREFIX=/usr ${myconf} || die
}

src_install() {
	emake PREFIX=/usr DOC_PATH=/usr/share/doc/${PF} DESTDIR="${D}" install || die
	prepalldocs
	if use themes; then
		insinto /usr/share/${PN}
		doins -r "${WORKDIR}"/${PN}-themes-${THV}/themes
	fi
}
