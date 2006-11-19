# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git distutils

DESCRIPTION=""
HOMEPAGE="Insanity is a graphical (GTK2) client for XMMS2"
EGIT_REPO_URI="git://git.xmms.se/xmms2/${PN}.git"

LICENSE="BSD Attribution-NoDerivs"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="
	dev-python/chalyx-eleusis
	>=dev-python/pygtk-2.8
"
RDEPEND="
	${DEPEND}
	media-sound/xmms2
"

