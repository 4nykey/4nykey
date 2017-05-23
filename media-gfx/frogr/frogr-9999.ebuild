# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://git.gnome.org/browse/frogr"
	SRC_URI=""
else
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A small application for managing Flickr account"
HOMEPAGE="https://wiki.gnome.org/Apps/Frogr"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug gstreamer nls"

DEPEND="
	x11-libs/gtk+:3
	media-libs/libexif
	dev-libs/libxml2
	dev-libs/json-glib
	dev-libs/libgcrypt:0
	net-libs/libsoup:2.4
	gstreamer? ( media-libs/gstreamer:1.0 )
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	mkdir -p "${S}"/m4
	gnome2_src_prepare
	[[ -z ${PV%%*9999} ]] && eautoreconf
}

src_configure() {
	local myconf="
		$(use_enable debug)
		$(use_enable gstreamer video)
		$(use_enable nls)
	"
	gnome2_src_configure ${myconf}
}
