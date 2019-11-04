# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( otf +ttf )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="phase3-second-cleanup"
	MY_PV="v${PV//./-}-${MY_PV}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="de09105"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font-r1

DESCRIPTION="A font family that aims to support all the world's languages"
HOMEPAGE="https://www.google.com/get/noto"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="autohint"

src_prepare() {
	default

	use font_types_ttf && \
	find -type f -path "./phaseIII_only/$(usex autohint hinted unhinted)/ttf/*.ttf" \
		-exec mv --target-directory="${FONT_S}" {} +

	use font_types_otf && \
	find -type f -path "./phaseIII_only/unhinted/otf/*.otf" \
		-exec mv --target-directory="${FONT_S}" {} +
}
