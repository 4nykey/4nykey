# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils
MY_PS="ps3muxer-f435b1a"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/clark15b/${PN}"
else
	inherit vcs-snapshot
	MY_PV="c7ab3db"
	SRC_URI="
		mirror://githubcl/clark15b/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/clark15b/${MY_PS%-*}/tar.gz/${MY_PS##*-} -> ${MY_PS}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="AVCHD/Blu-Ray HDMV Transport Stream demultiplexer"
HOMEPAGE="https://github.com/clark15b/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="qt4"

DEPEND="
	qt4? ( dev-qt/qtgui:4 )
"
RDEPEND="
	${DEPEND}
"

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_PS}" \
		EGIT_REPO_URI="git://github.com/clark15b/${MY_PS%-*}" \
			git-r3_src_unpack
	else
		vcs-snapshot_src_unpack
	fi
}

src_prepare() {
	default
	tc-export CXX
	sed \
		-e "s:g++:${CXX} ${CXXFLAGS} ${LDFLAGS}:" \
		-i Makefile
	mv "${WORKDIR}"/${MY_PS} "${S}"/${MY_PS%-*}
}

src_configure() {
	use qt4 && cd tsDemuxGUI && eqmake4 tsDemuxGUI.pro
}

src_compile() {
	default
	use qt4 && emake -C tsDemuxGUI || die
}

src_install() {
	dobin tsdemux
	dodoc README
	use qt4 && dobin tsDemuxGUI/tsDemuxGUI
}
