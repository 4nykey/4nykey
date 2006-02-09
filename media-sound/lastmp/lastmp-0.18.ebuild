# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_P="${P/mp/fmsubmitd}"
DESCRIPTION="LastMP is a Last.fm plugin client for MPD, implemented in Python"
HOMEPAGE="http://www.red-bean.com/~decklin/software/lastfmsubmitd/"
SRC_URI="http://www.red-bean.com/~decklin/software/lastfmsubmitd/${MY_P}.tar.bz2"
LICENSE="as-is"
KEYWORDS="~x86"
IUSE=""
S="${WORKDIR}/${MY_P}"

RDEPEND="media-libs/py-libmpdclient"

DOCS="NEWS"

CFG_DIR="/etc/lastmp"
CFG="${CFG_DIR}/lastmp.cfg"

pkg_setup() {
	enewgroup lastfm || die "problem adding group lastfm"
	enewuser lastfm '' '' '' lastfm || die "problem adding user lastfm"
}

src_install() {
	distutils_src_install
	touch ${T}/blah
	diropts -m0755 -o lastfm -g lastfm
	dodir ${CFG_DIR}
	keepdir ${CFG_DIR}
	dodir /var/run/lastfm
	keepdir /var/run/lastfm
	dodir /var/log/lastfm
	keepdir /var/log/lastfm
	dodir /var/cache/lastfm
	keepdir /var/cache/lastfm
	exeinto /etc/init.d
	doexe ${FILESDIR}/l{fmsubmitd,astmp}
	dosed "s:@PF@:${PF}:g" /etc/init.d/lfmsubmitd
}

pkg_config() {
	einfo "This will configure LastMP"
	if [ -e ${CFG} ]; then
		ewarn "You already have a LastMP configuration file."
		ewarn "Press Control-C to abort or press ENTER to create a new one."
	else
		einfo "Press ENTER to continue..."
	fi
	read -s
	
	if [ ! -f $CFG ]; then
		touch $CFG
		chown lastfm:lastfm $CFG
		chmod 0600 $CFG
	fi
	einfo "Please enter your last.fm username: "
	read -e USERNAME
	einfo "and your password:"
	read -s -e PASSWORD
	
	echo "LASTFM_USER=$USERNAME" > $CFG
	echo "LASTFM_PASSWORD=$PASSWORD" >> $CFG

	einfo
	einfo "You can now try running LastMP:"
	einfo "\"/etc/init.d/lastmp start\""
}

pkg_postinst() {
	einfo "To configure LastMP, you should run:"
	einfo "\"ebuild /var/db/pkg/media-sound/${PF}/${PF}.ebuild config\""
	einfo "if this is a new install."
}
