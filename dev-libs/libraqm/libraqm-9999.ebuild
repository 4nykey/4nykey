# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/HOST-Oman/${PN}.git"
else
	MY_PV="201db95"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/HOST-Oman/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
inherit autotools

DESCRIPTION="A library for complex text layout"
HOMEPAGE="https://github.com/HOST-Oman/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="gtk-doc static-libs"

RDEPEND="
	media-libs/freetype:2
	media-libs/harfbuzz:=
	dev-libs/fribidi
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/gtk-doc
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable gtk-doc)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete
}
