# Copyright 2004-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{5,6,7}} )

inherit python-single-r1 xdg
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
else
	inherit vcs-snapshot
	MY_UH="uthash-f19dde2"
	MY_PV="f913204"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/troydhanson/${MY_UH%-*}/tar.gz/${MY_UH##*-}
		-> ${MY_UH}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit autotools

DESCRIPTION="postscript font editor and converter"
HOMEPAGE="https://fontforge.github.io/"

LICENSE="BSD GPL-3+"
SLOT="0"
IUSE="cairo truetype-debugger gif gtk jpeg png +python readline test tiff svg unicode X"
IUSE+=" libspiro"

RESTRICT="!test? ( test )"
RESTRICT+=" primaryuri"

REQUIRED_USE="
	cairo? ( png )
	gtk? ( cairo )
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( png python )
"

RDEPEND="
	dev-libs/glib
	dev-libs/libltdl:0
	dev-libs/libxml2:2=
	>=media-libs/freetype-2.3.7:2=
	cairo? (
		>=x11-libs/cairo-1.6:0=
		x11-libs/pango:0=
	)
	gif? ( media-libs/giflib:0= )
	jpeg? ( virtual/jpeg:0 )
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0= )
	truetype-debugger? ( >=media-libs/freetype-2.3.8:2[fontforge,-bindist(-)] )
	gtk? ( >=x11-libs/gtk+-3.10:3 )
	python? ( ${PYTHON_DEPS} )
	readline? ( sys-libs/readline:0= )
	unicode? ( media-libs/libuninameslist:0= )
	X? (
		x11-libs/libX11:0=
		x11-libs/libXi:0=
		>=x11-libs/pango-1.10:0=[X]
	)
	!media-gfx/pfaedit
	libspiro? ( media-libs/libspiro )
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/20170731-gethex-unaligned.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		EGIT_REPO_URI="https://github.com/troydhanson/uthash" \
		EGIT_CHECKOUT_DIR="${S}/uthash" \
			git-r3_src_unpack
	else
		vcs-snapshot_src_unpack
		mv "${WORKDIR}"/${MY_UH} "${S}"/uthash
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_enable truetype-debugger freetype-debugger "${EPREFIX}/usr/include/freetype2/internal4fontforge")
		$(use_enable python python-extension)
		$(use_enable python python-scripting)
		--enable-tile-path
		$(use_with cairo)
		$(use_with gif giflib)
		$(use_with jpeg libjpeg)
		$(use_with png libpng)
		$(use_with readline libreadline)
		$(use_with libspiro)
		$(use_with tiff libtiff)
		$(use_with unicode libuninameslist)
		$(use_with X x)
	)
	if use gtk; then
		# broken AC_ARG_ENABLE usage
		# https://bugs.gentoo.org/681550
		myeconfargs+=( --enable-gdk=gdk3 )
	fi
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" HTDOCS_SUBDIR=/html install
	docompress -x /usr/share/doc/${PF}/html
	einstalldocs
	find "${ED}" -name '*.la' -type f -delete || die
}
