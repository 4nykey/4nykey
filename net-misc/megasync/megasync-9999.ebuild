# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2 qmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/meganz/${PN}.git"
	EGIT_SUBMODULES=( -src/MEGASync/mega )
	SRC_URI=
else
	inherit vcs-snapshot
	MY_PV="2e03def"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}_Linux"
	SRC_URI="
		mirror://githubcl/meganz/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Easy automated syncing with MEGA Cloud Drive"
HOMEPAGE="https://github.com/meganz/MEGAsync"

LICENSE="EULA"
LICENSE_URL="https://raw.githubusercontent.com/meganz/MEGAsync/master/LICENCE.md"
SLOT="0"
IUSE="nautilus qt5"

RDEPEND="
	net-misc/meganz-sdk[libuv,qt,sodium,sqlite]
	!qt5? ( dev-qt/qtgui:4 )
	qt5? ( dev-qt/qtwidgets:5 )
	nautilus? ( >=gnome-base/nautilus-3 )
"
DEPEND="
	${RDEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
"
src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-qmake.diff
	)
	cp -r "${EROOT}"usr/share/meganz-sdk/bindings "${S}"/src/MEGASync/mega/
	default
}

src_configure() {
	cd src
	eqmake$(usex qt5 5 4) \
		$(usex nautilus 'CONFIG+=with_ext' '') \
		'CONFIG-=with_tools'
}

src_compile() {
	cd src
	$(usex qt5 $(qt5_get_bindir) $(qt4_get_bindir))/lrelease \
		MEGASync/MEGASync.pro
	emake
}

src_install() {
	local DOCS=( CREDITS.md README.md )
	einstalldocs
	emake -C src INSTALL_ROOT="${D}" install
}
