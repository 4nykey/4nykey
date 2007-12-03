# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/wxpython/wxpython-2.6.3.3.ebuild,v 1.6 2007/01/16 06:16:12 josejx Exp $

inherit distutils wxwidgets-nu

MY_P="${P/wxpython-/wxPython-src-}"
DESCRIPTION="A blending of the wxWindows C++ class library with Python"
HOMEPAGE="http://www.wxpython.org/"
SRC_URI="mirror://sourceforge/wxpython/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}/wxPython/"

LICENSE="wxWinLL-3"
SLOT="2.8"
KEYWORDS="~x86"
IUSE="unicode opengl"

RDEPEND="
	>=dev-lang/python-2.1
	>=x11-libs/wxGTK-${PV}
	>=x11-libs/gtk+-2.0
	>=x11-libs/pango-1.2
	>=dev-libs/glib-2.0
	media-libs/libpng
	media-libs/jpeg
	media-libs/tiff
	>=sys-libs/zlib-1.1.4
	opengl? ( >=dev-python/pyopengl-2.0.0.44 )
	!<dev-python/wxpython-2.4.2.4-r1
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

WX_GTK_VER="${SLOT}"
PYTHON_MODNAME="."

pkg_setup() {
	if use unicode; then
		need-wxwidgets unicode
	else
		need-wxwidgets gtk2
	fi
	use opengl && check_wxuse opengl
	use unicode && check_wxuse unicode
	mypyconf="WX_CONFIG=${WX_CONFIG} WXPORT=gtk2"
	use !opengl; mypyconf="${mypyconf} BUILD_GLCANVAS=$?"
	use !unicode; mypyconf="${mypyconf} UNICODE=$?"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i "s:cflags.append('-O3'):pass:" config.py
	# the following mimics "scripts-multiver-xxx.diff"
	find scripts -mindepth 1 -type f -executable | xargs sed -i \
		"/^#\!/a import wxversion\nwxversion.select(\"${SLOT}\")"
}

src_compile() {
	distutils_src_compile ${mypyconf}
}

src_install() {
	distutils_src_install ${mypyconf}
	newbin "${FILESDIR}"/wxpy-config.py wxpy-config

	#Add ${PV} suffix to all /usr/bin/* programs to avoid clobbering SLOT'd
	for filename in "${D}"/usr/bin/* ; do
		mv ${filename} ${filename}-${SLOT}
	done
}

pkg_postinst() {
	distutils_pkg_postinst
	elog "Gentoo now uses the Multi-version method for SLOT'ing"
	elog "Developers see this site for instructions on using SLOTs"
	elog "with your apps:"
	elog "http://wiki.wxpython.org/index.cgi/MultiVersionInstalls"
}
