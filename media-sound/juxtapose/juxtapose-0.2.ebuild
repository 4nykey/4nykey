# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git distutils

DESCRIPTION="PyGTK XMMS2 Client"
HOMEPAGE="http://git.xmms.se"
SRC_URI=""
EGIT_REPO_URI="git://git.xmms.se/xmms2/juxtapose.git/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="${RDEPEND}"
RDEPEND="dev-python/pygtk
	media-sound/xmms2"

