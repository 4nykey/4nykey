# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

ECLASS="gmpc-plugin"
INHERITED="$INHERITED $ECLASS"

EXPORT_FUNCTIONS src_install

HOMEPAGE="http://sarine.nl/gmpc-plugins"
ESVN_REPO_URI="https://svn.musicpd.org/gmpc/plugins/${PN}/trunk"
ESVN_BOOTSTRAP="eautoreconf"

RDEPEND="
	~media-sound/gmpc-9999
"
DEPEND="
	${RDEPEND}
"

gmpc-plugin_src_install() {
	einstall libdir="${D}usr/share/gmpc/plugins" || die "einstall failed"
	[ -n ${DOCS} ] && dodoc ${DOCS}
}
