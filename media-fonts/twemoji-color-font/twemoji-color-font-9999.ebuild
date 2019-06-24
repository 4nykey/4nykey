# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/eosrei/${PN}"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	MY_PV="${PV//_/-}"
	MY_P="TwitterColorEmoji-SVGinOT-Linux-${MY_PV}"
	SRC_URI="
		!binary? (
			mirror://githubcl/eosrei/${PN}/tar.gz/v${MY_PV} -> ${P}.tar.gz
		)
		binary? (
			https://github.com/eosrei/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font-r1

DESCRIPTION="A color emoji SVGinOT font using Twitter Unicode 8.0 emoji"
HOMEPAGE="https://github.com/eosrei/${PN}"

LICENSE="CC-BY-4.0 MIT"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? (
		media-gfx/inkscape
		virtual/imagemagick-tools[png]
		media-gfx/potrace
		dev-util/svgo
		dev-python/scfbuild
	)
"

pkg_setup() {
	local _fc="fontconfig/56-${PN%-*}.conf"
	if use binary; then
		S="${WORKDIR}/${MY_P}"
		FONT_CONF="${S}/${_fc}"
	else
		FONT_S=( build )
		FONT_CONF="${S}/linux/${_fc}"
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return

	sed -e '/all:/ s:$(OSX_FONT)::' -i "${S}"/Makefile
	addpredict /dev/dri
}

src_compile() {
	use binary && return

	emake \
		SCFBUILD="${EROOT}usr/bin/scfbuild"
}
