# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_FONT_TYPES=( otf +ttf )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="phase3-second-cleanup"
	MY_PV="v${PV//./-}-${MY_PV}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="9176dad"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV}
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
IUSE=""

src_prepare() {
	default
	local _s
	for _s in ${FONT_SUFFIX}; do
		find -type f -path "./phaseIII_only/unhinted/${_s}/*.${_s}" \
			-exec mv --target-directory="${FONT_S}" {} +
	done
}
