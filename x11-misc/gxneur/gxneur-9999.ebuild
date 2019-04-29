# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="be de es he ro ru uk"
GNOME2_EAUTORECONF="yes"
inherit l10n gnome2
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AndrewCrewKuznetsov/xneur-devel.git"
	SRC_URI=""
	S="${WORKDIR}/${P}/${PN}"
else
	inherit vcs-snapshot
	MY_PV="ee27c77"
	MY_P="xneur-${PV}"
	SRC_URI="
		mirror://githubcl/AndrewCrewKuznetsov/xneur-devel/tar.gz/${MY_PV}
		-> ${MY_P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}/${PN}"
fi

DESCRIPTION="GTK+ based GUI for xneur"
HOMEPAGE="http://www.xneur.ru/"
EGIT_REPO_URI="https://github.com/AndrewCrewKuznetsov/xneur-devel.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="ayatana nls"

DEPEND="
	gnome-base/libglade:2.0
	>=sys-devel/gettext-0.16.1
	>=x11-libs/gtk+-2.20:2
	~x11-misc/xneur-${PV}:${SLOT}[nls=]
	ayatana? ( dev-libs/libappindicator:2 )
"
RDEPEND="
	${DEPEND}
	nls? ( virtual/libintl )
"
DEPEND="
	${DEPEND}
	virtual/pkgconfig
	dev-util/intltool
	nls? ( sys-devel/gettext )
"

src_prepare() {
	sed -e '/\(README\|TODO\)/d' -i Makefile.am
	gnome2_src_prepare
}

src_configure() {
	local myconf="
		$(use_with ayatana appindicator)
		$(use_enable nls)
	"
	gnome2_src_configure ${myconf}
}
