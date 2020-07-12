# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="threads(+)"
VIRTUALX_REQUIRED="test"

MY_PN="wxPython"
# wxGTK version and corresponding ext/wxwidgets submodule commit or tag
WXV=( 3.0.5 v3.0.5 )
# build.py: 'wafCurrentVersion'
WAF_BINARY="waf-2.0.8"
inherit waf-utils distutils-r1 eutils wxwidgets vcs-snapshot virtualx

DESCRIPTION="A blending of the wxWindows C++ class library with Python"
HOMEPAGE="https://wiki.wxpython.org/ProjectPhoenix"
SRC_URI="
	mirror://githubcl/wxWidgets/Phoenix/tar.gz/${MY_PN}-${PV/_p/.post}
	-> ${P}.tar.gz
	mirror://githubcl/wxwidgets/wxwidgets/tar.gz/${WXV[1]}
	-> wxGTK-${WXV}.tar.gz
	https://waf.io/${WAF_BINARY}.tar.bz2
"
RESTRICT="primaryuri"

LICENSE="wxWinLL-3.1 LGPL-2"
SLOT="4.0"
#KEYWORDS="~amd64 ~x86"
IUSE="apidocs examples gtk3 libnotify opengl test"

RDEPEND="
	dev-lang/python-exec:2[${PYTHON_USEDEP}]
	gtk3? (
		>=x11-libs/wxGTK-${WXV}:3.0-gtk3[gstreamer,webkit,libnotify=,opengl?,tiff,X]
	)
	!gtk3? (
		>=x11-libs/wxGTK-${WXV}:3.0[gstreamer,webkit,libnotify=,opengl?,tiff,X]
	)
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	app-doc/doxygen
	>=dev-python/sip-4.19.16[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
	apidocs? (
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
"
DOCS=(
	{CHANGES,README,TODO}.rst
	docs/{classic_vs_phoenix,MigrationGuide}.rst
)

pkg_setup() {
	WX_GTK_VER="3.0$(usex gtk3 '-gtk3' '')"
	WAF_BINARY="${WORKDIR}/${WAF_BINARY}/waf"
	use apidocs && DOCS+=( docs/html )
	use examples && DOCS+=( demo samples )
	python_setup
	setup-wxwidgets
}

python_prepare_all() {
	distutils-r1_python_prepare_all

	mv -f "${WORKDIR}"/wxGTK-${WXV}/* ext/wxWidgets/

	SIP=/usr/bin/sip DOXYGEN=/usr/bin/doxygen \
		${EPYTHON} "${S}"/build.py dox etg sip \
		$(usex apidocs 'sphinx' '--nodoc') || die
}

python_configure() {
	local wafargs=(
		--out="${BUILD_DIR}"
		--python="${PYTHON}"
		--wx_config="${WX_CONFIG}"
		--gtk$(usex gtk3 3 2)
	)
	waf-utils_src_configure "${wafargs[@]}"
}

python_compile() {
	waf-utils_src_compile
}

python_test() {
	virtx ${EPYTHON} ./build.py \
		--verbose --pytest_jobs=$(makeopts_jobs) test || \
		die "Tests failed with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install --skip-build
}

python_install_all() {
	distutils-r1_python_install_all
	use examples && docompress -x /usr/share/doc/${PF}/{demo,samples}
}
