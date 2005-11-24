# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="mpdscribble is a music player daemon client which submits information about tracks being played to audioscrobbler."
HOMEPAGE="http://scribble.frob.nl/"
SRC_URI="http://warp.frob.nl/projects/scribble/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND=">=dev-libs/glib-2.0
		>=net-libs/libsoup-2.0
		>=dev-libs/libxml2-2.0"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/rcscript.diff
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die
	
	exeinto /usr/share/mpdscribble
	doexe setup.sh
	
	doman mpdscribble.1
	exeinto /etc/init.d
	newexe contrib/init.d.gentoo mdc

	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README TODO
}

pkg_config() {
	einfo "This is the setup to configure mpdscribble"
	if [ -e "/etc/mpdscribble/mpdscribble.conf" ]; then
		ewarn "You already have a mpdscribble configuration"
		ewarn "Press Control-C to abort"
		ewarn "or press ENTER to create a new one."
	else
		einfo "Press ENTER to continue..."
	fi
	read -s
	
	LOGIN_DIR=/etc/mpdscribble
	CACHE_DIR=/var/cache/mpdscribble
	LOG_DIR=/var/log
	
	mkdir -p $LOGIN_DIR
	mkdir -p $CACHE_DIR
	mkdir -p $LOG_DIR

	LOGIN=$LOGIN_DIR/mpdscribble.conf
	CACHE=$CACHE_DIR/mpdscribble.cache
	LOG=$LOG_DIR/mpdscribble.log

	touch $LOGIN
	einfo "Please enter your audioscrobbler username: "
	read -e USERNAME
	einfo "...and now your password"
	read -s -e PASSWORD
	
	echo "username = $USERNAME" > $LOGIN
	chmod 600 $LOGIN
	MD5=`echo -n $PASSWORD | md5sum | awk '{print $1}'`
	echo "password = $MD5" >> $LOGIN
	echo "cache = $CACHE" >> $LOGIN
	echo "log = $LOG" >> $LOGIN
	echo "verbose = 2" >> $LOGIN

	einfo
	einfo
	einfo "Thank you."
	einfo "You can try running mpdscribble now."
	einfo "/etc/init.d/mdc start"
}

pkg_postinst() {
	einfo "To setup a system-wide mpdscribble configuration, you should run:"
	einfo "\"ebuild /var/db/pkg/net-misc/${PF}/${PF}.ebuild config\""
	einfo "if this is a new install."
	einfo
	einfo
	einfo "For a per-user mpdscribble configuration, use the setup-tool:"
	einfo "   /usr/share/mpdscribble/setup.sh"
}

# contact the clumsy author of this ebuild: fearthebear@gmx.de
