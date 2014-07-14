# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit gnome2

DESCRIPTION="A simple, consistent and visually appealing GTK+ theme"
HOMEPAGE="https://github.com/cedl38/zen-gtk-themes"
SRC_URI="https://codeload.github.com/cedl38/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	x11-libs/gtk+:2
	x11-libs/gtk+:3
"
RDEPEND="
	${DEPEND}
"
