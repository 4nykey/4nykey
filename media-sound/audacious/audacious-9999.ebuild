# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/_/-}"

inherit meson xdg
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/audacious-media-player/${PN}.git"
else
	SRC_URI="
		https://distfiles.audacious-media-player.org/${P}.tar.bz2
	"
	if [[ -z ${PV%%*_p*} ]]; then
		MY_PV="9777eef"
		SRC_URI="
			mirror://githubcl/audacious-media-player/${PN}/tar.gz/${MY_PV}
			-> ${P}.tar.gz
		"
		S="${WORKDIR}/${PN}-${MY_PV}"
	fi
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Lightweight and versatile audio player"
HOMEPAGE="https://audacious-media-player.org/"

LICENSE="BSD-2"
SLOT="0"
IUSE="gtk qt6 test"
IUSE+=" libarchive nls"

BDEPEND="
	>=dev-util/gdbus-codegen-2.80.5-r1
	sys-devel/gettext
	virtual/pkgconfig
	nls? ( dev-util/intltool )
"
DEPEND="
	dev-libs/glib:2
	virtual/freedesktop-icon-theme
	gtk? (
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		>=x11-libs/gtk+-3.18:3
		x11-libs/pango
	)
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
		dev-qt/qtsvg:6
	)
	libarchive? ( app-arch/libarchive )
"
RDEPEND="
	${DEPEND}
"
PDEPEND="
	~media-plugins/audacious-plugins-${PV}[gtk=,qt6=]
"

src_prepare() {
	default
	if ! use nls; then
		sed -e "/subdir('po')/d" -i meson.build || die "failed to sed" # bug #512698
	fi
}

src_configure() {
	# D-Bus is a mandatory dependency. Remote control,
	# session management and some plugins depend on this.
	# Building without D-Bus is *unsupported* and a USE-flag
	# will not be added due to the bug reports that will result.
	# Bugs #197894, #199069, #207330, #208606
	local emesonargs=(
		-Ddbus=true
		$(meson_use qt6 qt)
		-Dqt5=false
		$(meson_use gtk)
		-Dgtk2=false
		$(meson_use libarchive)
		-Dbuildstamp="Gentoo ${P}"
		-Dvalgrind=false
	)
	meson_src_configure

	if use test; then
		emesonargs=()
		EMESON_SOURCE="${S}"/src/libaudcore/tests \
		BUILD_DIR="${WORKDIR}"/${P}-libaudcore_tests-build \
		meson_src_configure
	fi
}

src_compile() {
	meson_src_compile

	if use test; then
		EMESON_SOURCE="${S}"/src/libaudcore/tests \
		BUILD_DIR="${WORKDIR}"/${P}-libaudcore_tests-build \
		meson_src_compile
	fi
}

src_test() {
	BUILD_DIR="${WORKDIR}"/${P}-libaudcore_tests-build meson_src_test
}

pkg_postinst() {
	if use gtk || use qt6; then
		ewarn "Audacious without X11/XWayland is unsupported."
		ewarn "Especially the Winamp interface is not usable yet on Wayland."
	fi
	xdg_pkg_postinst
}
