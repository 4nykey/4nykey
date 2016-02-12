# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit gnome2
MY_M="faba-mono-icons-dceb7ab"
if [[ -z ${PV%%*9999} ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/moka-project/${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	MY_PV="6f1cea3"
	SRC_URI="
		mirror://githubcl/moka-project/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/moka-project/${MY_M%-*}/tar.gz/${MY_M##*-} -> ${MY_M}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A sexy and modern icon theme with Tango influences"
HOMEPAGE="http://mokaproject.com"

LICENSE="CC-BY-SA-4.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
"

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_M}" \
		EGIT_REPO_URI="https://github.com/moka-project/${MY_M%-*}" \
			git-r3_src_unpack
	else
		vcs-snapshot_src_unpack
	fi

}

src_configure() { :; }
src_compile() { :; }

src_install() {
	insinto /usr/share/icons
	doins -r "${S}"/Faba "${WORKDIR}"/${MY_M}/Faba-Mono*
}
