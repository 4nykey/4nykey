# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${P/_/}"
DESCRIPTION="Yet Another Cleaner tool for Gentoo"
HOMEPAGE="http://blog.tacvbo.net/data/files/gentoo/yacleaner"
SRC_URI="http://blog.tacvbo.net/data/files/gentoo/yacleaner/${MY_P}"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash"

src_unpack() { 
	cp "${DISTDIR}"/${A} .
	sed -i "s:\(cvs|svn\):\1|git|darcs:" ${A}
}

src_install() {
	exeinto /usr/bin
	newexe ${A} yacleaner
}
