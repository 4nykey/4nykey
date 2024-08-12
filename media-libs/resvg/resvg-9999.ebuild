# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler@1.0.2
	arrayref@0.3.7
	arrayvec@0.7.4
	base64@0.22.0
	bitflags@1.3.2
	bitflags@2.5.0
	bytemuck@1.15.0
	cfg-if@1.0.0
	color_quant@1.1.0
	crc32fast@1.4.0
	data-url@0.3.1
	fdeflate@0.3.4
	flate2@1.0.28
	float-cmp@0.9.0
	fontconfig-parser@0.5.6
	fontdb@0.16.2
	gif@0.13.1
	imagesize@0.12.0
	jpeg-decoder@0.3.1
	kurbo@0.11.0
	libc@0.2.153
	log@0.4.21
	memmap2@0.9.4
	miniz_oxide@0.7.2
	once_cell@1.19.0
	pico-args@0.5.0
	png@0.17.13
	rgb@0.8.37
	roxmltree@0.19.0
	rustybuzz@0.13.0
	simd-adler32@0.3.7
	simplecss@0.2.1
	siphasher@1.0.1
	slotmap@1.0.7
	smallvec@1.13.2
	strict-num@0.1.1
	svgtypes@0.15.0
	tiny-skia@0.11.4
	tiny-skia-path@0.11.4
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	ttf-parser@0.20.0
	unicode-bidi@0.3.15
	unicode-bidi-mirroring@0.2.0
	unicode-ccc@0.2.0
	unicode-properties@0.1.1
	unicode-script@0.5.6
	unicode-vo@0.1.0
	version_check@0.9.4
	weezl@0.1.8
	xmlwriter@0.1.0
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
			${CARGO_CRATE_URIS}
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
	cargo_src_install --path crates/usvg
	dolib.so target/$(rust_abi)/$(usex debug debug release)/libresvg.so
	doheader crates/c-api/*.h
	use qt5 && dobin viewsvg
}
