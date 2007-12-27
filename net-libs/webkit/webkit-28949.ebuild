# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#inherit subversion
#ESVN_REPO_URI="http://svn.webkit.org/repository/webkit/trunk"

inherit qt4

MY_P="WebKit-r${PV}"
DESCRIPTION="WebKit is an open source web browser engine"
HOMEPAGE="http://webkit.org/"
SRC_URI="http://nightly.webkit.org/files/trunk/src/${MY_P}.tar.bz2"
RESTRICT="mirror"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

RDEPEND="
	x11-libs/gtk+
	dev-libs/libxslt
	net-misc/curl
	media-libs/jpeg
	media-libs/libpng
	dev-libs/icu
"
DEPEND="
	${RDEPEND}
	sys-devel/bison
	dev-lang/perl
	>=x11-libs/qt-4
	dev-util/gperf
"

src_compile() {
	local myconf="CONFIG+=gtk-port CONFIG-=qt-port"
	if use debug; then
		myconf="${myconf} CONFIG+=debug CONFIG-=release"
	else
		myconf="${myconf} CONFIG+=release CONFIG-=debug"
	fi

	eqmake4 WebKit.pro -recursive \
		OUTPUT_DIR=${S} \
		WEBKIT_INC_DIR=/usr/include/WebKit \
		WEBKIT_LIB_DIR=/usr/lib \
		${myconf} \
		|| die "eqmake4 failed"

	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "install failed"
}
