# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A multithreaded MPD client for Audioscrobbler"
HOMEPAGE="http://scmpc.berlios.de"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"

RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	>=net-misc/curl-7.10
	dev-libs/libdaemon
	dev-libs/confuse
	dev-libs/argtable
"
DEPEND="
	${RDEPEND}
"

CFG=/etc/scmpc.conf

pkg_setup() {
	enewgroup lastfm || die "problem adding group lastfm"
	enewuser scmpc '' '' '' lastfm || die "problem adding user scmpc"
}

pkg_config() {
	einfo "This will create system-wide config file for scmpc,"
	einfo "if you rather run it as a user, refer to scmpc(1)."
	
	einfo "Please enter your last.fm username: "
	read -e USERNAME
	einfo "and password (will not be echoed):"
	read -s -e PASSWORD
	
	sed -i "s:username = .*:username = \"$USERNAME\":" $CFG
	sed -i "s:password = .*:password = \"$PASSWORD\":" $CFG

	einfo
	einfo "You can now try running scmpc:"
	einfo "\"/etc/init.d/scmpc start\""
}

src_unpack() {
	unpack ${A}
	# make it --as-needed friendly
	sed -i 's:\($(LDLIBS)\) \(-o .*\):\2 \1:' ${S}/src/Rules.mk
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed!"

	doinitd ${FILESDIR}/scmpc

	insinto /etc
	insopts -m0600 -oscmpc
	doins examples/scmpc.conf

	touch ${T}/foo
	insopts -m0644 -oscmpc -glastfm
	insinto /var/log
	newins ${T}/foo scmpc.log
	insinto /var/cache
	newins ${T}/foo scmpc.cache

	diropts -m0755 -oscmpc -glastfm
	dodir /var/run/scmpc
	keepdir /var/run/scmpc

	dosed 's:.*\(cache_file =\).*:\1 "/var/cache/scmpc.cache":' ${CFG}
	dosed 's:.*\(pid_file =\).*:\1 "/var/run/scmpc/scmpc.pid":' ${CFG}
}

pkg_postinst() {
	elog "To configure scmpc, you should run:"
	elog "    \`emerge --config =${CATEGORY}/${PF}'"
	elog "if this is a new install."
}
