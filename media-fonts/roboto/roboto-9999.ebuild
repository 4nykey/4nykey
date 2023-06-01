# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( otf +ttf )
MY_PN="${PN}-classic"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${MY_PN}.git"
	REQUIRED_USE="!binary"
else
	MY_PV="3852c00"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV/_/-}"
	SRC_URI="
		binary? (
			https://github.com/googlefonts/${MY_PN}/releases/download/v${PV}/${PN^}_${MY_PV}.zip
		)
		!binary? (
			mirror://githubcl/googlefonts/${MY_PN}/tar.gz/v${PV} -> ${P}.tar.gz
		)
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
	[[ -z ${USE##*binary*} ]] && S="${WORKDIR}"
	if [[ -z ${USE##*autohint*} ]]; then
		if [[ -z ${USE##*variable*} ]]; then
			FONTDIR_BIN=( hinted )
		else
			FONTDIR_BIN=( hinted/static )
		fi
	else
		if [[ -z ${USE##*variable*} ]]; then
			FONTDIR_BIN=( unhinted )
		else
			FONTDIR_BIN=( unhinted/static )
		fi
	fi
fi
inherit fontmake

DESCRIPTION="Google's signature family of fonts"
HOMEPAGE="https://github.com/googlefonts/${MY_PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+binary test"
REQUIRED_USE="
	binary? ( !font_types_otf )
"
