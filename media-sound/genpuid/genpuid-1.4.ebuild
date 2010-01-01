# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="genpuid is a utility for fingerprinting of audio files"
HOMEPAGE="http://musicbrainz.org/doc/genpuid"
SRC_URI="mirror://freebsd/ports/distfiles/${PN}_linux_${PV}.tgz"
RESTRICT="strip"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	virtual/libstdc++
"

src_install() {
	dobin genpuid mipcore
	dodoc *.txt
}
