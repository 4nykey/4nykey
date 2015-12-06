# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit l10n base qmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mltframework/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/mltframework/${PN}/tar.gz/v${PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A free, open source, cross-platform video editor"
HOMEPAGE="http://www.shotcut.org"

LICENSE="GPL-3"
SLOT="0"
IUSE="nls"

RDEPEND="
	media-libs/mlt
	dev-qt/qtwebkit:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtwebsockets:5
	dev-qt/qtdeclarative:5
"
DEPEND="
	${RDEPEND}
	nls? ( dev-qt/linguist-tools:5 )
"

src_configure() {
	eqmake5 ${PN}.pro PREFIX=${EPREFIX}/usr
}

src_compile() {
	base_src_compile
	use nls && "$(qt5_get_bindir)"/lrelease src/src.pro
}

src_install() {
	base_src_install INSTALL_ROOT="${D}"
	if use nls; then
		insinto /usr/share/${PN}/translations
		doins translations/*.qm
	fi
}
