# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="threads(+)"
VIRTUALX_REQUIRED="test"

MY_PN="wxPython"
# wxGTK version and corresponding ext/wxwidgets submodule commit or tag
WXV=( 3.1.4_pre20200418 e803408 )
# build.py: 'wafCurrentVersion'
WAF_BINARY="waf-2.0.19"
inherit distutils-r1 eutils vcs-snapshot virtualx

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
IUSE="apidocs examples libnotify opengl test"

RDEPEND="
	>=x11-libs/wxGTK-${WXV}:3.1[gstreamer,webkit,libnotify=,opengl?,tiff,X]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	app-doc/doxygen
	>=dev-python/sip-4.19.19[${PYTHON_USEDEP}]
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
	docs/MigrationGuide.rst
)

pkg_setup() {
	WAF_BINARY="${WORKDIR}/${WAF_BINARY}/waf"
	use apidocs && DOCS+=( docs/html )
	use examples && DOCS+=( demo samples )
	python_setup
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
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--out="${BUILD_DIR}"
		--python="${PYTHON}"
		--wx_config="${EPREFIX}/usr/$(get_libdir)/wx/config/gtk3-unicode-3.1"
		--gtk3
	)
	set -- "${WAF_BINARY}" "${wafargs[@]}" configure
	echo "${@}"
	${EPYTHON} "${@}" || die "configure failed"
}

python_compile() {
	${EPYTHON} "${WAF_BINARY}" \
		--jobs=$(makeopts_jobs) --verbose || die "build failed"
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
