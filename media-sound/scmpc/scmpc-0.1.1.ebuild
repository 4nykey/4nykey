# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A multithreaded MPD client for Audioscrobbler"
HOMEPAGE="http://scmpc.berlios.de"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.bz2"

RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=net-misc/curl-7.10.0
	dev-libs/libdaemon
	dev-libs/confuse
	dev-libs/argtable"
RDEPEND="${DEPEND}"

CFG=/etc/scmpc.conf

pkg_setup() {
	enewgroup lastfm || die "problem adding group lastfm"
	enewuser scmpc '' '' '' lastfm || die "problem adding user scmpc"
}

pkg_config() {
	einfo "This will create system-wide configure file for scmpc,"
	einfo "if you rather run it as a user, refer to scmpc(1)."
	if [ ! "$(grep 'password = ""' ${CFG})" ]; then
		ewarn "You already have last.fm password in scmpc configuration file."
		ewarn "Press Control-C to abort or press ENTER to reconfigure."
	else
		einfo "Press ENTER to continue..."
	fi
	read -s
	
	einfo "Please enter your last.fm username: "
	read -e USERNAME
	einfo "and password (will not be echoed):"
	read -s -e PASSWORD
	
	sed -i "s:username = \"\":username = \"$USERNAME\":" $CFG
	sed -i "s:password = \"\":password = \"$PASSWORD\":" $CFG

	einfo
	einfo "You can now try running scmpc:"
	einfo "\"/etc/init.d/scmpc start\""
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed!"

	exeinto /etc/init.d
	doexe ${FILESDIR}/scmpc

	insinto /etc
	insopts -m0600
	doins examples/scmpc.conf

	touch ${T}/foo
	insopts -m0644 -oscmpc -glastfm
	insinto /var/log
	newins ${T}/foo scmpc.log
	insinto /var/cache
	newins ${T}/foo scmpc.cache
#	fowners scmpc:lastfm /var/log/scmpc.log /var/cache/scmpc.cache

	diropts -m0755 -oscmpc -glastfm
	dodir /var/run/scmpc
	keepdir /var/run/scmpc

	dosed 's:.*\(cache_file =\).*:\1 "/var/cache/scmpc.cache":' ${CFG}
	dosed 's:.*\(pid_file =\).*:\1 "/var/run/scmpc/scmpc.pid":' ${CFG}
}

pkg_postinst() {
	einfo "To configure scmpc, you should run:"
	einfo "\"ebuild /var/db/pkg/media-sound/${PF}/${PF}.ebuild config\""
	einfo "if this is a new install."
}
