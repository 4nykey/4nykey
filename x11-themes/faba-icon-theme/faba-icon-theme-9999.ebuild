# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome2
MY_M="faba-mono-icons-2006c52"
if [[ -z ${PV%%*9999} ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/snwh/${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	MY_PV="6f1cea3"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/snwh/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/snwh/${MY_M%-*}/tar.gz/${MY_M##*-} -> ${MY_M}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A sexy and modern icon theme with Tango influences"
HOMEPAGE="https://snwh.org/moka#${PN}"

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
		EGIT_CHECKOUT_DIR="${S}/${MY_M%-*}" \
		EGIT_REPO_URI="https://github.com/snwh/${MY_M%-*}" \
			git-r3_src_unpack
	else
		vcs-snapshot_src_unpack
		mv "${WORKDIR}"/${MY_M} "${S}"/${MY_M%-*}
	fi

}

src_prepare() {
	sed \
		-e "s:EXTRA_DIST.*:SUBDIRS=${MY_M%-*}\n&:" \
		-i Makefile.am
	sed \
		-e "s:AM_SILENT_RULES.*:&\nAC_CONFIG_SUBDIRS(${MY_M%-*}):" \
		-i configure.ac
	default
	eautoreconf
}
