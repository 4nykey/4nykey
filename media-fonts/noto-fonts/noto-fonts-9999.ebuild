# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( otf +ttf )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	MY_PV="phase3"
	MY_PV="v${PV//.}-${MY_PV}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="0723a59"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
inherit font-r1

DESCRIPTION="A font family that aims to support all the world's languages"
HOMEPAGE="https://www.google.com/get/noto"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="autohint variable"
REQUIRED_USE="font_types_otf? ( !variable )"

pkg_setup() {
	use variable && FONT_S=( unhinted/variable-ttf )
	font-r1_pkg_setup
}

src_prepare() {
	default

	if use font_types_otf; then
		find -type f -path "./unhinted/otf/*.otf" \
			-exec mv --target-directory="${FONT_S}" {} +
	elif use !variable; then
		find -type f -path "./$(usex autohint hinted unhinted)/ttf/*.ttf" \
			-exec mv --target-directory="${FONT_S}" {} +
	fi
}
