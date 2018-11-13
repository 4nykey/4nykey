# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6,7} )
PYTHON_REQ_USE="threads(+)"

MY_PN="wxPython"
# ext/wxwidgets submodule commit and corresponding wxGTK version
WXV="cd11d91:3.0.5_pre20180607"
# wafCurrentVersion from build.py
WAF_BINARY="${WORKDIR}/waf-2.0.7"
inherit alternatives distutils-r1 eutils wxwidgets vcs-snapshot

DESCRIPTION="A blending of the wxWindows C++ class library with Python"
HOMEPAGE="https://wiki.wxpython.org/ProjectPhoenix"
SRC_URI="
	mirror://githubcl/wxWidgets/Phoenix/tar.gz/${MY_PN}-${PV/_p}
	-> ${P}.tar.gz
	mirror://githubcl/wxwidgets/wxwidgets/tar.gz/${WXV%:*}
	-> wxGTK-${WXV#*:}.tar.gz
	https://wxpython.org/Phoenix/tools/${WAF_BINARY##*/}.bz2
"
RESTRICT="primaryuri"

LICENSE="wxWinLL-3.1 LGPL-2"
SLOT="${PV:0:3}"
KEYWORDS="~amd64 ~x86"
IUSE="apidocs examples gtk3 libnotify opengl test"

RDEPEND="
	dev-lang/python-exec:2[${PYTHON_USEDEP}]
	gtk3? (
		>=x11-libs/wxGTK-${WXV#*:}:3.0-gtk3[libnotify=,opengl?,tiff,X]
	)
	!gtk3? (
		>=x11-libs/wxGTK-${WXV#*:}:3.0[libnotify=,opengl?,tiff,X]
	)
	dev-python/pypubsub[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/appdirs[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	app-doc/doxygen
	dev-python/sip[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
	apidocs? (
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
"
DOCS=(
	{CHANGES,README,TODO}.rst
	docs/{classic_vs_phoenix,MigrationGuide}.rst
)

waf() {
	local mywafargs=(
		--jobs=$(makeopts_jobs)
		--verbose
		--out="${BUILD_DIR}"
		--prefix=/usr
		--destdir="${D}"
		--python="${PYTHON}"
		--wx_config="${WX_CONFIG}"
		--gtk$(usex gtk3 3 2)
	)
	${EPYTHON} "${WAF_BINARY}" "${mywafargs[@]}" "${@}" || die
}

pkg_setup() {
	WX_GTK_VER="3.0$(usex gtk3 '-gtk3' '')"
	use apidocs && DOCS+=( docs/html )
	python_setup
	setup-wxwidgets
}

python_prepare_all() {
	distutils-r1_python_prepare_all

	sed \
		-e "/conf.env.INCLUDES_WXPY/ s:'sip/siplib', ::" \
		-i wscript

	mv -f "${WORKDIR}"/wxGTK-${WXV#*:}/* ext/wxWidgets/
	cp -s /usr/bin/{doxygen,sip} bin/

	SIP=bin/sip DOXYGEN=bin/doxygen \
		${EPYTHON} "${S}"/build.py dox etg sip \
		$(usex apidocs 'sphinx' '--nodoc')
}

python_configure() {
	waf configure
}

python_compile() {
	waf build
}

python_install() {
	distutils-r1_python_install --skip-build
}

python_install_all() {
	if use examples; then
		docinto demo
		dodoc -r demo/.
		docinto samples
		dodoc -r samples/.

	fi
	distutils-r1_python_install_all
}
