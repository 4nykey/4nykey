# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit gnome2
if [[ -z ${PV%%*9999} ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/cedl38/${PN}.git"
	inherit git-r3
else
	SRC_URI="
		mirror://githubcl/cedl38/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A simple, consistent and visually appealing GTK+ theme"
HOMEPAGE="https://github.com/cedl38/zen-gtk-themes"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	x11-libs/gtk+:2
	x11-libs/gtk+:3
"
RDEPEND="
	${DEPEND}
"
