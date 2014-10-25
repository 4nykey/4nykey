# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit distutils git-r3

DESCRIPTION="A multiplatform dictionary and offline Wikipedia reader"
HOMEPAGE="http://aarddict.org/"
EGIT_REPO_URI="https://github.com/aarddict/desktop.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-python/PyQt4[X,webkit]
	dev-python/pyicu
	dev-python/simplejson
"

