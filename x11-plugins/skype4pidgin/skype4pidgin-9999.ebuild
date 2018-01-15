# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_USE_DIR="${S}/skypeweb"
inherit cmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/EionRobb/skype4pidgin.git"
else
	SRC_URI="
		mirror://githubcl/EionRobb/${PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Skype Plugin for Pidgin"
HOMEPAGE="https://eion.robbmob.com"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	net-im/pidgin
	dev-libs/json-glib
"
RDEPEND="
	${DEPEND}
"
DEPEND="
	${DEPEND}
	virtual/pkgconfig
"
