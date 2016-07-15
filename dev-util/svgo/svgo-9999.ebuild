# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/svg/${PN}.git"
else
	SRC_URI="
		mirror://githubcl/svg/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Nodejs-based tool for optimizing SVG vector graphics files"
HOMEPAGE="https://github.com/svg/svgo"

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	net-libs/nodejs[npm]
"
RDEPEND="${DEPEND}"
DOCS=( {CHANGELOG,README,docs/how-it-works/en}.md )

src_compile() { :; }

src_install() {
	npm set prefix "${ED}"/usr
	npm install -g
	einstalldocs
}
