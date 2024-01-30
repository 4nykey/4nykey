# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler-1.0.2
	arrayref-0.3.7
	arrayvec-0.7.2
	base64-0.21.0
	bitflags-1.3.2
	bytemuck-1.13.1
	cfg-if-1.0.0
	color_quant-1.1.0
	crc32fast-1.3.2
	data-url-0.2.0
	flate2-1.0.25
	float-cmp-0.9.0
	fontconfig-parser-0.5.2
	fontdb-0.13.0
	gif-0.12.0
	imagesize-0.11.0
	jpeg-decoder-0.3.0
	kurbo-0.9.1
	libc-0.2.140
	log-0.4.17
	memmap2-0.5.10
	miniz_oxide-0.6.2
	once_cell-1.17.1
	pico-args-0.5.0
	png-0.17.7
	rctree-0.5.0
	rgb-0.8.36
	roxmltree-0.18.0
	rustybuzz-0.7.0
	simplecss-0.2.1
	siphasher-0.3.10
	slotmap-1.0.6
	smallvec-1.10.0
	strict-num-0.1.0
	svgtypes-0.11.0
	tiny-skia-0.8.3
	tiny-skia-path-0.8.3
	ttf-parser-0.18.1
	unicode-bidi-0.3.13
	unicode-bidi-mirroring-0.1.0
	unicode-ccc-0.1.2
	unicode-general-category-0.6.0
	unicode-script-0.5.5
	unicode-vo-0.1.0
	version_check-0.9.4
	weezl-0.1.7
	xmlparser-0.13.5
	xmlwriter-0.1.0
"
inherit qmake-utils cargo
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/RazrFalcon/${PN}.git"
else
	MY_PV="55888a5"
	if [[ -n ${PV%%*_p*} ]]; then
		MY_PV="v${PV}"
		SRC_URI="
			https://github.com/RazrFalcon/${PN}/releases/download/${MY_PV}/${P}.tar.xz
		"
	else
		SRC_URI="
			mirror://githubcl/RazrFalcon/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
			$(cargo_crate_uris ${CRATES})
		"
	fi
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="An SVG rendering library"
HOMEPAGE="https://github.com/RazrFalcon/resvg"

LICENSE="MPL-2.0"
SLOT="0"
IUSE="qt5"

DEPEND="
	qt5? ( dev-qt/qtgui:5 )
"
RDEPEND="
	${DEPEND}
	media-libs/fontconfig
"

src_configure() {
	cargo_src_configure
	use qt5 || return
	local eqmakeargs=(
		tools/viewsvg/viewsvg.pro
		CONFIG+=$(usex debug debug release)
	)
	eqmake5 "${eqmakeargs[@]}"
}

src_compile() {
	cargo_src_compile --workspace
	use qt5 && emake
}

src_install() {
	cargo_src_install --path crates/resvg
	dolib.so target/$(usex debug debug release)/libresvg.so
	doheader crates/c-api/*.h
	use qt5 && dobin viewsvg
}
