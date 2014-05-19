# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3,3_4} )

inherit distutils-r1 git-r3

DESCRIPTION="Python bindings for MusicBrainz libdiscid"
HOMEPAGE="https://python-discid.readthedocs.org"
EGIT_REPO_URI="https://github.com/JonnyJD/python-discid.git"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/libdiscid
"
RDEPEND="
	${DEPEND}
"
