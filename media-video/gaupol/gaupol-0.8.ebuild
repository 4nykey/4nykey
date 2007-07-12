# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils versionator

DESCRIPTION="Gaupol is a subtitle editor for text-based subtitles"
HOMEPAGE="http://home.gna.org/gaupol/"
SRC_URI="http://download.gna.org/gaupol/$(get_version_component_range 1-2)/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="spell"
RESTRICT="primaryuri"

RDEPEND="
	>=dev-lang/python-2.5
	>=dev-python/pygtk-2.10
	dev-python/chardet
	spell? (
		>=dev-python/pyenchant-1.1.3
		app-text/iso-codes
	)
"
DEPEND="
	${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
"
addpredict /root/.gconfd:/root/.gconf
