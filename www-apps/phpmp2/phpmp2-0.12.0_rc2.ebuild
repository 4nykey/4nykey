# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/phpmp/phpmp-0.11.0.ebuild,v 1.3 2004/09/15 17:48:22 eradicator Exp $

IUSE=""

inherit webapp

MY_PN="${PN/m/M}"
MY_PV="${PV/_/-}"
MY_P="${MY_PN}-${MY_PV}"
DESCRIPTION="phpMp2 is a client program for Music Player Daemon (mpd)"
HOMEPAGE="http://www.musicpd.org/phpMp2.shtml"
SRC_URI="http://whitelynx.g33xnexus.com/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_PN}"

LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="net-www/apache
	dev-lang/php
	media-libs/gd"

src_install() {
	webapp_src_preinst

	find ${S} -name .svn | xargs rm -rf

	local docs="README TODO"

	dodoc ${S}/${docs}
	for doc in ${docs}
		do rm -rf ${S}/${doc}
	done

	cp -r ${S}/* ${D}${MY_HTDOCSDIR}

	webapp_configfile ${MY_HTDOCSDIR}/config.php

	#webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	webapp_src_install
}
