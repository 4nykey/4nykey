# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs gnome2 meson
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.gnome.org/browse/frogr"
	SRC_URI=""
else
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A small application for managing Flickr account"
HOMEPAGE="https://wiki.gnome.org/Apps/Frogr"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug gstreamer"

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
	sed \
		-e '/compiler\.find_library/ s:libgcrypt:gcrypt:' \
		-i meson.build
	default
}

src_configure() {
	tc-export CC PKG_CONFIG
	local emesonargs=(
		-Denable-video=$(usex gstreamer true false)
	)
	meson_src_configure
}
