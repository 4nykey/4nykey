# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/eosrei/${PN}"
	REQUIRED_USE="!binary"
else
	MY_P="EmojiOneColor-SVGinOT-Linux-${PV}"
	SRC_URI="
		!binary? (
			mirror://githubcl/eosrei/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
		)
		binary? (
			https://github.com/eosrei/${PN}/releases/download/v${PV}/${MY_P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font

DESCRIPTION="A color emoji SVGinOT font using EmojiOne Unicode 9.0 emoji"
HOMEPAGE="https://github.com/eosrei/emojione-color-font"

LICENSE="CC-BY-4.0 MIT"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? (
		media-gfx/inkscape
		media-gfx/imagemagick
		media-gfx/potrace
		dev-util/svgo
		dev-python/scfbuild
	)
"
FONT_SUFFIX="ttf"
DOCS=( README.md )

pkg_setup() {
	local _fc="fontconfig/56-emojione-color.conf"
	if use binary; then
		S="${WORKDIR}/${MY_P}"
		FONT_S="${S}"
		FONT_CONF="${S}/${_fc}"
	else
		FONT_S="${S}/build"
		FONT_CONF="${S}/linux/${_fc}"
		DOCS+=( {full,mini}-demo.html )
	fi
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

src_install() {
	font_src_install
	einstalldocs
}
