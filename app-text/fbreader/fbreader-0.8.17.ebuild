# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt3 qt4 confutils

DESCRIPTION="FBReader is an e-book reader for various platforms"
HOMEPAGE="http://www.fbreader.org/"
SRC_URI="http://www.fbreader.org/${PN}-sources-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gtk qt3 qt4 debug verbose-build"

DEPEND="
	dev-libs/expat
	app-i18n/enca
	sys-libs/zlib
	app-arch/bzip2
	dev-libs/liblinebreak
	gtk? ( >=x11-libs/gtk+-2.4 )
	qt3? ( $(qt_min_version 3) )
	qt4? ( $(qt4_min_version 4) )
"
RDEPEND="
	${DEPEND}
"

pkg_setup() {
	confutils_use_conflict gtk qt3 qt4
	confutils_use_conflict qt3 qt4
}

src_unpack() {
	unpack ${A}
	cd ${S}
	use verbose-build && epatch ${FILESDIR}/${PN}-verbose-build.diff
}

src_compile() {
	local myconf="UI_TYPE=gtk"
	if use qt3; then
		myconf="UI_TYPE=qt QTINCLUDE=-I${QTDIR}/include MOC=${QTDIR}/bin/moc"
		LDFLAGS="${LDFLAGS} -L${QTDIR}/lib"
	fi
	if use qt4; then
		myconf="UI_TYPE=qt4 MOC=/usr/bin/moc"
		LDFLAGS="${LDFLAGS} -L/usr/lib/qt4"
	fi
	use debug && myconf="${myconf} TARGET_STATUS=debug"

	# TARGET_STATUS=release (default) adds "-O3 -s" to flags
	emake \
		INSTALLDIR=/usr \
		CC="g++ ${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		TARGET_ARCH=desktop \
		TARGET_STATUS= \
		${myconf} \
		|| die
}

src_install() {
	emake \
		DESTDIR=${D} \
		INSTALLDIR=/usr \
		CC="g++ ${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		TARGET_ARCH=desktop \
		TARGET_STATUS= \
		${myconf} install \
		|| die
}
