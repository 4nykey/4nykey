inherit cvs gnome2

DESCRIPTION="GNOME Sample editor"
HOMEPAGE="http://marlin.sf.net/"
#SRC_URI="mirror://sourceforge/marlin/${P}.tar.gz"
SRC_URI=""
S="${WORKDIR}/${PN}"
ECVS_SERVER="anoncvs.gnome.org:/cvs/gnome"
ECVS_MODULE="${PN}"
LICENSE="GPL-2"

KEYWORDS="~x86"
#IUSE="oggvorbis xine flac faad mad pda"
IUSE="oggvorbis mp3"
SLOT="0"

RDEPEND=">=x11-libs/gtk+-2.4
	>=gnome-base/gnome-vfs-2.6.0
	>=media-libs/gst-plugins-0.8.5
	>=media-plugins/gst-plugins-gnomevfs-0.8.5
	oggvorbis? ( >=media-plugins/gst-plugins-vorbis-0.8.5
	             >=media-plugins/gst-plugins-ogg-0.8.5 )
	mp3? ( >=media-plugins/gst-plugins-lame-0.8.5 )
	>=gnome-base/libgnomeui-2.6.0
	>=gnome-extra/gnome-media-2.6.0"

#	>=gnome-extra/nautilus-cd-burner-2.11.5

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.29
	app-text/scrollkeeper"

MAKEOPTS="${MAKEOPTS} -j1"

DOCS="AUTHORS COPYING ChangeLog INSTALL \
	  NEWS README TODO"

G2CONF="--disable-cd"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	einfo "Running autogen.sh"
	NOCONFIGURE=yup WANT_AUTOMAKE=1.7 \
		./autogen.sh > /dev/null || die
}

