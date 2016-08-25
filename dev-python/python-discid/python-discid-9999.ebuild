# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/JonnyJD/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="fd714ad"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/JonnyJD/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Python bindings for MusicBrainz libdiscid"
HOMEPAGE="https://python-discid.readthedocs.org"
EGIT_REPO_URI="https://github.com/JonnyJD/python-discid.git"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/libdiscid
	${PYTHON_DEPS}
"
RDEPEND="
	${DEPEND}
"
