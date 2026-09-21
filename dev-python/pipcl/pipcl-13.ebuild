# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=standalone
inherit distutils-r1

DESCRIPTION="Python packaging operations"
HOMEPAGE="https://mupdf.com"
SRC_URI="
	mirror://githubcl/ArtifexSoftware/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
