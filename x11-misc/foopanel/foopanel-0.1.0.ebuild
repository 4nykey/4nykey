# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Foopanel is a powerful desktop panel"
HOMEPAGE="http://foopanel.berlios.de"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-python/pygtk-2.6.0
	dev-python/pyxdg"
RDEPEND="${DEPEND}"

