# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/wxpython/wxpython-2.6.3.3.ebuild,v 1.6 2007/01/16 06:16:12 josejx Exp $

inherit distutils wxwidgets-nu eutils multilib toolchain-funcs

MY_P="${P/wxpython-/wxPython-src-}"
DESCRIPTION="A blending of the wxWindows C++ class library with Python"
HOMEPAGE="http://www.wxpython.org/"
SRC_URI="mirror://sourceforge/wxpython/${MY_P}.tar.bz2"

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

S="${WORKDIR}/${MY_P}/wxPython/"

pkg_setup() {
	WX_GTK_VER="${SLOT}"
	if use unicode; then
		need-wxwidgets unicode
	else
		need-wxwidgets gtk2
	fi

	mypyconf="WX_CONFIG=${WX_CONFIG} WXPORT=gtk2"
	use !opengl; mypyconf="${mypyconf} BUILD_GLCANVAS=$?"
	use !unicode; mypyconf="${mypyconf} UNICODE=$?"

	PYTHON_MODNAME="."
}

src_unpack() {
	unpack ${A}
	cd "${S}" || die "failed to cd to ${S}"
	# gcc (at least 4.1.x) b0rks badly with -O2 and up
	sed -i "s:-O3:-O:" config.py || die "sed failed"
	# the following mimics "scripts-multiver-xxx.diff"
	find scripts -mindepth 1 -type f -executable | xargs sed -i \
		"s:\(^#!.*\):\1\n\nimport wxversion\nwxversion.select(\"${SLOT}\"):"
}

src_compile() {
	CC="$(tc-getCXX)" distutils_src_compile ${mypyconf}
}

src_install() {
	distutils_src_install ${mypyconf}

	site_pkgs="$(${python} -c 'from distutils.sysconfig import get_python_lib;print get_python_lib()')"
	use unicode && wxau="unicode" || wxau="ansi"
	wx_name="wx-${SLOT}-gtk2-${wxau}"
	wx_pth="${site_pkgs}/wx.pth"
	if [[ -e "${wx_pth}" && $(grep -o 2.4 ${wx_pth}) == "2.4" ]]; then
		rm "${D}"/${site_pkgs}/wx.pth
		elog "Keeping 2.4 as system default wxPython"
	else
		elog "Setting ${wx_name} as system default wxPython"
		echo ${wx_name} > ${D}/${site_pkgs}/wx.pth ||
		die "Couldn't create wx.pth"
	fi

	#Add ${PV} suffix to all /usr/bin/* programs to avoid clobbering SLOT'd
	for filename in "${D}"/usr/bin/* ; do
		mv ${filename} ${filename}-${SLOT}
	done

	newbin "${FILESDIR}"/wxpy-config.py wxpy-config
}

pkg_postinst() {
	distutils_pkg_postinst
	elog "Gentoo now uses the Multi-version method for SLOT'ing"
	elog "Developers see this site for instructions on using SLOTs"
	elog "with your apps:"
	elog "http://wiki.wxpython.org/index.cgi/MultiVersionInstalls"
}
