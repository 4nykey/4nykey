# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="MEGAsync"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/meganz/${MY_PN}.git"
	EGIT_SUBMODULES=( -src/MEGASync/mega )
	SRC_URI=
else
	MY_PV="85e50f2"
	SRC_URI="
		mirror://githubcl/meganz/${MY_PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi
CMAKE_USE_DIR="${S}/src/MEGAShellExtDolphin"
CMAKE_IN_SOURCE_BUILD=y
inherit cmake qmake-utils xdg

DESCRIPTION="Easy automated syncing with MEGA Cloud Drive"
HOMEPAGE="https://github.com/meganz/MEGAsync"

LICENSE="EULA"
LICENSE_URL="https://raw.githubusercontent.com/meganz/MEGAsync/master/LICENCE.md"
SLOT="0"
IUSE="dolphin nautilus thunar"

RDEPEND="
	>=net-misc/meganz-sdk-3.9.6b:=[libuv,qt,sodium(+),sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtx11extras:5
	dev-qt/qtdbus:5
	dev-qt/qtconcurrent:5
	dev-qt/qtimageformats:5
	dolphin? ( kde-apps/dolphin )
	nautilus? ( >=gnome-base/nautilus-3 )
	thunar? ( xfce-base/thunar )
"
DEPEND="
	${RDEPEND}
	dev-libs/breakpad
"
BDEPEND="
	dev-qt/linguist-tools:5
"
src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-qmake.diff
	)
	sed \
		-e "/include(/ s:mega/bindings/qt/:${EPREFIX}/usr/share/&:" \
		-i src/MEGASync/MEGASync.pro
	cmake_src_prepare
	mv -f src/MEGAShellExtDolphin/CMakeLists{_kde5,}.txt
	rm -f src/MEGAShellExtDolphin/megasync-plugin.moc
	printf 'CONFIG += link_pkgconfig
		PKGCONFIG += breakpad-client
		DEFINES += __STDC_FORMAT_MACROS\n' > \
		src/MEGASync/google_breakpad/google_breakpad.pri
	sed \
		-e "/USE_\(FFMPEG\|LIBRAW\|MEDIAINFO\)/s:+:-:" \
		-i src/MEGASync/MEGASync.pro
}

src_configure() {
	cd src
	local eqmakeargs=(
		CONFIG$(usex nautilus + -)=with_ext
		CONFIG$(usex thunar + -)=with_thu
		CONFIG-=with_updater
		CONFIG-=with_tools
		MEGASDK_BASE_PATH="${EPREFIX}/usr"
		CONFIG+=nofreeimage
	)
	eqmake5 "${eqmakeargs[@]}"
	use dolphin && cmake_src_configure
}

src_compile() {
	cd src
	$(qt5_get_bindir)/lrelease \
		MEGASync/MEGASync.pro
	emake
	use dolphin && cmake_src_compile
}

src_install() {
	local DOCS=( CREDITS.md README.md )
	einstalldocs
	emake -C src INSTALL_ROOT="${D}" install
	use dolphin && cmake_src_install
}
