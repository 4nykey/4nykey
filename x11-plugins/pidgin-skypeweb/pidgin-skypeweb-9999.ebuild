# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="skype4pidgin"
CMAKE_USE_DIR="${S}/${PN#*-}"
inherit cmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/EionRobb/${MY_PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/EionRobb/${MY_PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="SkypeWeb Plugin for Pidgin"
HOMEPAGE="https://eion.robbmob.com"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	net-im/pidgin
	dev-libs/json-glib
	!x11-plugins/skype4pidgin
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
