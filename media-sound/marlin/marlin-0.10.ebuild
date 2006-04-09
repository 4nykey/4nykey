# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs gnome2 autotools flag-o-matic

DESCRIPTION="GNOME Sample editor"
HOMEPAGE="http://marlin.sf.net/"
SRC_URI=""
S="${WORKDIR}/${PN}"
ECVS_SERVER="anoncvs.gnome.org:/cvs/gnome"
ECVS_MODULE="${PN}"
LICENSE="GPL-2"

KEYWORDS="~x86"
IUSE="vorbis mp3 cdr"
SLOT="0"

RDEPEND=">=x11-libs/gtk+-2.8
	>=gnome-base/gnome-vfs-2.6.0
	>=media-libs/gst-plugins-0.8.5
	>=media-plugins/gst-plugins-gnomevfs-0.8.5
	vorbis? ( >=media-plugins/gst-plugins-vorbis-0.8.5 )
	mp3? ( >=media-plugins/gst-plugins-lame-0.8.5 )
	>=gnome-base/libgnomeui-2.6.0
	>=gnome-extra/gnome-media-2.6.0
	cdr? ( >=gnome-extra/nautilus-cd-burner-2.11.5
		>=media-libs/musicbrainz-2.1.1 )
	sys-fs/e2fsprogs"


DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.29
	app-text/scrollkeeper"

MAKEOPTS="${MAKEOPTS} -j1"

DOCS="AUTHORS ChangeLog NEWS README TODO"

G2CONF="$(use_enable cdr cd)"

pkg_setup() {
	filter-ldflags -Wl,--as-needed
}

src_unpack() {
	cvs_src_unpack
	cd ${S}
	intltoolize --automake --copy --force || die
	eautoreconf || die
}

src_install() {
	gnome2_src_install
	dosed \
		's:Icon=.*:Icon=/usr/share/pixmaps/marlin/marlin-icon.png:' \
		/usr/share/applications/marlin.desktop
}
