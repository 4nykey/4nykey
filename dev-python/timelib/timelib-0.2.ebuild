# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils

DESCRIPTION="timelib is a wrapper around php's internal timelib module"
HOMEPAGE="http://github.com/schmir/timelib/tree/master"
SRC_URI="http://pypi.python.org/packages/source/t/${PN}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

