# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_P="${P/mp/fmsubmitd}"
DESCRIPTION="LastMP is a Last.fm plugin client for MPD, implemented in Python"
HOMEPAGE="http://www.red-bean.com/~decklin/software/lastfmsubmitd/"
SRC_URI="http://www.red-bean.com/~decklin/software/lastfmsubmitd/${MY_P}.tar.bz2"
RESTRICT="primaryuri"
LICENSE="as-is"
KEYWORDS="~x86"
IUSE=""
S="${WORKDIR}/${MY_P}"

RDEPEND="media-libs/py-libmpdclient"

DOCS="INSTALL NEWS"

CFG="/etc/lastfmsubmitd.conf"
GROUP="lastfm"
USER="lastmp"

pkg_setup() {
	enewgroup ${GROUP} || die "problem adding group lastfm"
	enewuser ${USER} '' '' '' ${GROUP} || die "problem adding user lastmp"
}

src_unpack() {
	unpack ${A}
	# make it use spool dir from conf file
	sed -i 's:\(lastfm.submit(\[sub\]\)):\1, conf.spool_path):g' ${S}/lastmp
}

src_install() {
	distutils_src_install
		
	diropts -m0755 -o ${USER} -g ${GROUP}
	dodir /var/run/lastmp
	keepdir /var/run/lastmp
	dodir /var/log/lastmp
	keepdir /var/log/lastmp
	dodir /var/spool/lastmp
	keepdir /var/spool/lastmp

	exeinto /etc/init.d
	doexe ${FILESDIR}/l{fmsubmitd,astmp}

	insinto /etc
	insopts -m0600 -o ${USER} -g ${GROUP}
	doins ${FILESDIR}/*.conf
}

pkg_config() {
	einfo "This will configure LastMP"
	
	einfo "Please enter your last.fm username: "
	read -e USERNAME
	einfo "and your password:"
	read -s -e PASSWORD
	
	sed -i "s,\(\<user\>:\).*,\1 $USERNAME," $CFG
	sed -i "s,\(\<password\>:\).*,\1 $PASSWORD," $CFG

	einfo
	einfo "You can now try running LastMP:"
	einfo "\"/etc/init.d/lastmp start\""
}

pkg_postinst() {
	elog "If this is a new install, you should run:"
	elog "    \"emerge --config =${CATEGORY}/${PF}\""
	elog "and/or edit /etc/last{mp,fmsubmitd}.conf"
}
