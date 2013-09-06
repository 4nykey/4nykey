# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit cmake-utils

DESCRIPTION="Estonian ID card utility"
HOMEPAGE="http://installer.id.ee"
SRC_URI="https://installer.id.ee/media/sources/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sys-apps/pcsc-lite
	dev-libs/opensc
	dev-qt/qtcore:4[ssl]
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4
"
DEPEND="
	${RDEPEND}
"
