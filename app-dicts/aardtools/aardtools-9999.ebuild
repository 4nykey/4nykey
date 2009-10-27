# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils mercurial

DESCRIPTION="Tools to create dictionaries in aarddict format"
HOMEPAGE="http://aarddict.org/aardtools/doc/aardtools.html"
EHG_REPO_URI="http://bitbucket.org/itkach/${PN}"
S="${WORKDIR}/${EHG_REPO_URI##*/}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	app-dicts/aarddict
	>=dev-python/mwlib-0.12
"
