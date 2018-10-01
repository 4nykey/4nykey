# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'

inherit distutils-r1 waf-utils multilib eutils

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
#scripts/get_waf.sh
MY_WAF="waf-2.0.11"
SRC_URI="${SRC_URI} https://waf.io/${MY_WAF}"
RESTRICT="primaryuri"

DESCRIPTION="Library for audio labelling"
HOMEPAGE="https://aubio.org/"

LICENSE="GPL-3"
SLOT="0/5"
IUSE="apidocs doc double-precision examples ffmpeg fftw jack libav libsamplerate sndfile python"

RDEPEND="
	ffmpeg? (
		!libav? ( >=media-video/ffmpeg-2.6:0= )
		libav? ( >=media-video/libav-9:0= )
	)
	fftw? ( sci-libs/fftw:3.0 )
	jack? ( virtual/jack )
	libsamplerate? ( media-libs/libsamplerate )
	python? ( dev-python/numpy[${PYTHON_USEDEP}] ${PYTHON_DEPS} )
	sndfile? ( media-libs/libsndfile )
"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	app-text/txt2man
	virtual/pkgconfig
	apidocs? ( app-doc/doxygen )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
REQUIRED_USE+=" double-precision? ( !libsamplerate )"

DOCS=( AUTHORS ChangeLog README.md )

pkg_setup() {
	python_setup
}

src_prepare() {
	default
	sed \
		-e "s:libaubio-doc/sphinx':${PF}/html':" \
		-e "s:libaubio-doc':${PF}/doxygen':" \
		-e '/bld\.path\.find_dir/ s:doc/web:&/html:' \
		-i wscript
	install "${DISTDIR}"/${MY_WAF} "${S}"/waf
}

src_configure() {
	local _d='en'
	use !doc && use !apidocs && _d='dis'
	waf-utils_src_configure \
		--enable-complex \
		$(use_enable double-precision double) \
		$(usex double-precision --disable-fftw3f $(use_enable fftw fftw3f)) \
		$(use_enable fftw fftw3) \
		$(use_enable ffmpeg avcodec) \
		$(use_enable jack) \
		$(use_enable libsamplerate samplerate) \
		$(use_enable sndfile) \
		--${_d}able-docs \
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
	use python && distutils-r1_src_configure
}

src_compile() {
	waf-utils_src_compile --notests
	use python && distutils-r1_src_compile
}

src_test() {
	waf-utils_src_compile --alltests
	use python && distutils-r1_src_test
}

src_install() {
	waf-utils_src_install

	if use examples; then
		# install dist_noinst_SCRIPTS from Makefile.am
		dodoc -r examples
	fi

	if use python ; then
		distutils-r1_src_install
		newdoc python/README.md README.python
	fi

	einstalldocs
}
