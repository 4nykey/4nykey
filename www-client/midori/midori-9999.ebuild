# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='threads(+)'
VALA_MIN_API_VERSION="0.30"

inherit eutils pax-utils python-any-r1 vala gnome2 cmake-utils

if [[ -z ${PV%%*9999} ]]; then
	EBZR_REPO_URI="lp:${PN}"
	inherit bzr
	SRC_URI=
else
	SRC_URI="
		http://www.${PN}-browser.org/downloads/${PN}_${PV}_all_.tar.bz2
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A lightweight web browser based on WebKitGTK+"
HOMEPAGE="http://www.midori-browser.org/"

LICENSE="LGPL-2.1 MIT"
SLOT="0"
IUSE="gtk2 apidocs granite introspection +jit +webkit2 zeitgeist"
REQUIRED_USE="
	granite? ( !gtk2 )
	webkit2? ( !gtk2 )
	introspection? ( gtk2 )
"
RDEPEND="
	>=dev-db/sqlite-3.6.19:3
	>=dev-libs/glib-2.32.3
	dev-libs/libxml2
	>=net-libs/libsoup-2.38:2.4
	>=net-libs/libsoup-gnome-2.38:2.4
	>=x11-libs/libnotify-0.7
	x11-libs/libXScrnSaver
	gtk2? (
		>=net-libs/webkit-gtk-1.8.1:2[jit=]
		>=x11-libs/gtk+-2.24:2
	)
	!gtk2? (
		>=app-crypt/gcr-3
		x11-libs/gtk+:3
		webkit2? ( >=net-libs/webkit-gtk-2.3.91:4[jit=] )
		!webkit2? ( >=net-libs/webkit-gtk-1.8.1:3[jit=] )
	)
	granite? ( >=dev-libs/granite-0.2 )
	introspection? ( dev-libs/gobject-introspection )
	zeitgeist? ( >=dev-libs/libzeitgeist-0.3.14 )
"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	$(vala_depend)
	dev-util/intltool
	gnome-base/librsvg
	sys-devel/gettext
	apidocs? ( dev-util/gtk-doc )
"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	default
	vala_src_prepare
	sed -i -e '/install/s:COPYING:HACKING TODO TRANSLATE:' CMakeLists.txt || die
	strip-linguas -i po
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DUSE_APIDOCS=$(usex apidocs)
		-DUSE_GIR=$(usex introspection)
		-DUSE_GRANITE=$(usex granite)
		-DUSE_ZEITGEIST=$(usex zeitgeist)
		-DVALA_EXECUTABLE="${VALAC}"
		-DUSE_GTK3=$(usex !gtk2)
		-DHALF_BRO_INCOM_WEBKIT2=$(usex webkit2)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	einstalldocs
	use jit && pax-mark -m "${ED}"/usr/bin/${PN} #480290
}
