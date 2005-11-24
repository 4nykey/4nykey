# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

#inherit cvs gnome2
inherit gnome2

DESCRIPTION="Cupid is a video/audio capture solution, based on the GStreamer multimedia framework."
HOMEPAGE="http://ronald.bitfreak.net/cupid.php"
SRC_URI="http://gstreamer.freedesktop.org/src/gst-recorder/${P}.tar.gz"
#ECVS_SERVER="pdx.freedesktop.org:/cvs/gstreamer"
#ECVS_MODULE="gst-recorder"
#ECVS_USER="anoncvs"
#S=${WORKDIR}/${ECVS_MODULE}
LICENSE="GPL-2"
SLOT=0

IUSE=""
KEYWORDS="-*"

RDEPEND=">=media-libs/gstreamer-0.8.8
	>=media-libs/gst-plugins-0.8.7
	>=media-plugins/gst-plugins-ffmpeg-0.8.3
	>=gnome-base/gconf-1.2"

DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.11.5
	>=dev-util/pkgconfig-0.9"

#src_unpack() {
#	cvs_src_unpack
#	cd ${S}
#	einfo "Running autogen.sh"
#	NOCONFIGURE=yup ./autogen.sh > /dev/null || die
#}

DOCS="AUTHORS ChangeLog COPYING* NEWS README TODO"

