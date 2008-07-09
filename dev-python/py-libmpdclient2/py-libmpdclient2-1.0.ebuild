# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="A python MPD interface from Nick Welch"
HOMEPAGE="http://incise.org/py-libmpdclient2.html"
SRC_URI="http://incise.org/files/dev/${P}.tgz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""
RDEPEND="media-sound/mpd"

PYTHON_MODNAME="."
