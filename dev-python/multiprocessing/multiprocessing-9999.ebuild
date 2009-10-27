# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

NEED_PYTHON=2.4

inherit distutils subversion

DESCRIPTION="Backport of the multiprocessing package"
HOMEPAGE="http://code.google.com/p/python-multiprocessing"
ESVN_REPO_URI="http://python-multiprocessing.googlecode.com/svn/trunk"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

