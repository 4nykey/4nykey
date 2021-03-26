# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/eosrei/${PN}"
	REQUIRED_USE="!binary"
else
	MY_PVB="v${PV%_p*}"
	MY_P="TwitterColorEmoji-SVGinOT-Linux-${MY_PVB#v}"
	MY_PV="v${PV}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="cd3bc6a"
	SRC_URI="
		!binary? (
			mirror://githubcl/eosrei/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		)
		binary? (
			https://github.com/eosrei/${PN}/releases/download/${MY_PVB}/${MY_P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font-r1

DESCRIPTION="A color emoji SVGinOT font using Twitter emoji"
HOMEPAGE="https://github.com/eosrei/${PN}"

LICENSE="CC-BY-4.0 MIT"
SLOT="0"
IUSE="+binary"

BDEPEND="
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
		S="${WORKDIR}/${PN}-${MY_PV#v}"
		FONT_S=( build )
		FONT_CONF="${S}/linux/${_fc}"
	fi
	font-r1_pkg_setup
}

src_compile() {
	use binary && return

	local myemakeargs=(
		build/TwitterColorEmoji-SVGinOT.ttf
		SCFBUILD=/usr/bin/scfbuild
		INKSCAPE_EXPORT_FLAGS='--export-filename'
	)
	emake "${myemakeargs[@]}"
}
