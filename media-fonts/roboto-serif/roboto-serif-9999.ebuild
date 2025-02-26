# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_FONT_TYPES=( otf +ttf )
FONTMAKE_EXTRA_ARGS=( --no-check-compatibility )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
	REQUIRED_USE="!binary"
else
	MY_PV="3852c00"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		binary? (
			https://github.com/googlefonts/${PN}/releases/download/${MY_PV}/RobotoSerifFonts-${MY_PV}.zip
		)
		!binary? (
			mirror://githubcl/googlefonts/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
		)
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
	[[ -z ${USE##*binary*} ]] && S="${WORKDIR}"
	if [[ -z ${USE##*variable*} ]]; then
		FONTDIR_BIN=( variable )
	else
		FONTDIR_BIN=( ttf )
	fi
fi
inherit fontmake

DESCRIPTION="A serif typeface designed to work alongside Roboto"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary +variable"
REQUIRED_USE="
	binary? ( !font_types_otf )
	!binary? ( variable )
"
