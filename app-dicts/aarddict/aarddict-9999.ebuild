# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils mercurial

DESCRIPTION="A multiplatform dictionary and offline Wikipedia reader"
HOMEPAGE="http://aarddict.org/"
EHG_REPO_URI="http://bitbucket.org/itkach/${PN}"
S="${WORKDIR}/${EHG_REPO_URI##*/}"

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

