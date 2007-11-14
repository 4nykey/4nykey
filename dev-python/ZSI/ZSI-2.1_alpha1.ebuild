# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_P="${PN}-${PV/_alpha/-a}"
DESCRIPTION="Zolera SOAP Infrastructure"
HOMEPAGE="http://pywebsvcs.sf.net"
SRC_URI="mirror://sourceforge/pywebsvcs/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT ZPL"
SLOT="0"
KEYWORDS="~x86"
IUSE="twisted"

DEPEND=""
RDEPEND="
	twisted? ( dev-python/twisted-web )
"

