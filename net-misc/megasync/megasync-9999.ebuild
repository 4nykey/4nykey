# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_USE_DIR="${S}/src/MEGAShellExtDolphin"
CMAKE_IN_SOURCE_BUILD=y
inherit gnome2 cmake-utils qmake-utils
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
IUSE="dolphin nautilus qt5 thunar"
REQUIRED_USE="dolphin? ( qt5 )"

RDEPEND="
	net-misc/meganz-sdk[libuv,qt,sodium,sqlite]
	qt5? (
		dev-qt/qtsvg:5
		dev-qt/qtdbus:5
	)
	!qt5? (
		dev-qt/qtsvg:4
		dev-qt/qtdbus:4
	)
	dolphin? ( kde-apps/dolphin )
	nautilus? ( >=gnome-base/nautilus-3 )
	thunar? ( xfce-base/thunar )
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
	cmake-utils_src_prepare
	mv -f src/MEGAShellExtDolphin/CMakeLists{_kde5,}.txt
	rm -f src/MEGAShellExtDolphin/megasync-plugin.moc
}

src_configure() {
	cd src
	eqmake$(usex qt5 5 4) \
		$(usex dolphin 'CONFIG+=with_dol' '') \
		$(usex nautilus 'CONFIG+=with_ext' '') \
		$(usex thunar 'CONFIG+=with_thu' '') \
		'CONFIG-=with_tools'
	use dolphin && cmake-utils_src_configure
}

src_compile() {
	cd src
	$(usex qt5 $(qt5_get_bindir) $(qt4_get_bindir))/lrelease \
		MEGASync/MEGASync.pro
	emake
	use dolphin && cmake-utils_src_compile
}

src_install() {
	local DOCS=( CREDITS.md README.md )
	einstalldocs
	emake -C src INSTALL_ROOT="${D}" install
	use dolphin && cmake-utils_src_install
}
