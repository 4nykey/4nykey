# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs gnome2 autotools

DESCRIPTION="GNOME Sample editor"
HOMEPAGE="http://marlin.sf.net/"
SRC_URI=""
S="${WORKDIR}/${PN}"
ECVS_SERVER="anoncvs.gnome.org:/cvs/gnome"
ECVS_MODULE="${PN}"
LICENSE="GPL-2"

KEYWORDS="~x86"
IUSE="debug cdr"
SLOT="0"

RDEPEND=">=x11-libs/gtk+-2.8
	>=gnome-base/libgnomeui-2.6.0
	>=gnome-base/gnome-vfs-2.6.0
	>=media-libs/gst-plugins-base-0.10
	gnome-base/gconf
	>=gnome-extra/gnome-media-2.7.0
	cdr? ( >=gnome-extra/nautilus-cd-burner-2.11.5
		>=media-libs/musicbrainz-2.1.1 )
	sys-fs/e2fsprogs
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.21
"

MAKEOPTS="${MAKEOPTS} -j1"

DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README TODO"

G2CONF="\
	$(use_enable cdr cd) \
	$(use_enable debug) \
"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	epatch "${FILESDIR}/${PN}-as_needed.diff"
	intltoolize --automake --copy --force || die
	eautoreconf
}

src_install() {
	gnome2_src_install
	dosed \
		's:Icon=.*:Icon=/usr/share/pixmaps/marlin/marlin-icon.png:' \
		/usr/share/applications/marlin.desktop
}
