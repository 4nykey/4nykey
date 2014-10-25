# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_2,3_3,3_4} )

inherit distutils-r1 git-r3

DESCRIPTION="An asymptotically faster list-like type for Python"
HOMEPAGE="http://stutzbachenterprises.com/blist"
EGIT_REPO_URI="https://github.com/DanielStutzbach/blist.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
