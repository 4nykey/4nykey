# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion toolchain-funcs

DESCRIPTION="A commandline client for monitoring MPD music dir using inotify"
HOMEPAGE="http://syscrash.ca"
ESVN_REPO_URI="http://svn.syscrash.ca/tinystuff/mpd_inotify"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE=""

DEPEND=""
RDEPEND="
	media-sound/mpd
"

src_compile() {
	echo $(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN} *.c
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${PN} *.c || die
}

src_install() {
	dobin ${PN}
	exeinto /etc/init.d
	newexe "${FILESDIR}"/init_d mpd-inotify
}
