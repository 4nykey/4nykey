# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
if [[ -z ${PV%%*9999} ]]; then
	inherit subversion
	ESVN_REPO_URI="https://svn.code.sf.net/p/${PN}/code/trunk"
else
	SRC_URI="mirror://gcarchive/${PN}/${PN}-src-${PV}.tar.xz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"
fi

DESCRIPTION="A set of fontforge scripts for producing fonts"
HOMEPAGE="https://code.google.com/p/font-helpers"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	dev-libs/libxslt
"

src_prepare() {
	local PATCHES=( "${FILESDIR}"/${PN}_py3.diff )
	default
	sed -e 's:^\t:        :' -i *.py
}

src_install() {
	insinto /usr/share/${PN}
	doins *.{ff,py}
	dodoc ChangeLog* README*
}
