# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
PYPI_NO_NORMALIZE=1
PYPI_PN="wxPython"
VIRTUALX_REQUIRED="test"

inherit toolchain-funcs distutils-r1 multiprocessing virtualx pypi
MY_PV="${PV}"
MY_P="${PYPI_PN}-${PV}"
if [[ -z ${PV%%*_*} ]]; then
	MY_PV="f0785b3c"
	MY_PV="$(ver_cut 1-3)a$(ver_cut 5)+${MY_PV}"
	MY_P="${MY_PV}"
fi
SRC_URI="
	https://github.com/wxWidgets/Phoenix/releases/download/${MY_P}/${PN}-${MY_PV}.tar.gz
	apidocs? (
		https://github.com/wxWidgets/Phoenix/releases/download/${MY_P}/${PYPI_PN}-docs-${MY_PV}.tar.gz
	)
"
RESTRICT="primaryuri"

DESCRIPTION="A blending of the wxWindows C++ class library with Python"
HOMEPAGE="https://www.wxpython.org"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="wxWinLL-3.1 LGPL-2"
SLOT="4.0"
KEYWORDS="~amd64"
IUSE="apidocs debug examples libnotify opengl test webkit"

RDEPEND="
	>=x11-libs/wxWidgets-3.3.4:3.3=[gstreamer,webkit?,libnotify=,opengl?,tiff,X]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	app-text/doxygen
	dev-python/cython[${PYTHON_USEDEP}]
	>=dev-python/sip-6.11.1-r1[${PYTHON_USEDEP}]
	test? (
		${VIRTUALX_DEPEND}
		dev-python/appdirs[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pytest-forked[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"
DOCS=(
	{CHANGES,README,TODO}.rst
)
PATCHES=(
	"${FILESDIR}"/cflags.diff
	"${FILESDIR}/${PN}-4.2.1-x86-time.patch"
	"${FILESDIR}/${PN}-4.2.2-setuppy.patch"
)
EPYTEST_DESELECT=(
	unittests/test_windowid.py::IdManagerTest::test_newIdRef03
	unittests/test_frame.py::frame_Tests::test_frameRestore
	unittests/test_lib_pubsub_provider.py::lib_pubsub_Except::test1
	unittests/test_glcanvas.py::glcanvas_Tests::test_glcanvas2
	unittests/test_glcanvas.py::glcanvas_Tests::test_glcanvas3
)
distutils_enable_tests pytest

pkg_setup() {
	use apidocs && HTML_DOCS=( ../${MY_P/-/-docs-}/docs/html/. )
	use examples && DOCS+=( demo samples )
	python_setup
}

python_prepare_all() {
	if use !webkit; then
		rm -f unittests/test_webview.py
		eapply "${FILESDIR}"/${PN}-4.2.0-no-webkit.patch
	fi

	doxygen -u ext/wxWidgets/docs/doxygen/Doxyfile || die

	distutils-r1_python_prepare_all
}

python_compile() {
	local -x DOXYGEN="$(type -P doxygen)" \
		WX_CONFIG="${EPREFIX}/usr/$(get_libdir)/wx/config/gtk3-unicode-3.3"
	local _args=(
		--python=${PYTHON}
		--$(usex debug debug release)
		--gtk3
		--use_syswx
		--no_magic
		--jobs=$(makeopts_jobs)
		--verbose
	)
	DISTUTILS_ARGS=(
		--verbose
		build
		--buildpy-options="build_py ${_args[*]}"
	)

	CC="$(tc-getCC) ${CFLAGS}" \
	CXX="$(tc-getCXX) ${CXXFLAGS}" \
	distutils-r1_python_compile

	# This package's built system relies on copying extensions back
	# to source directory for setuptools to pick them up.  This is
	# hopeless.
	find -name "*$(get_modname)" -delete || die
}

python_test() {
	rm -rf wx
	# We use pytest-forked as opensuse does to avoid tests corrupting each
	# other.
	virtx epytest --forked unittests
}

python_install_all() {
	distutils-r1_python_install_all
	use examples && docompress -x /usr/share/doc/${PF}/{demo,samples}
}
