# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools
MY_GL="gnulib-3bafb58"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3 mercurial
	EHG_REPO_URI="https://bitbucket.org/sortsmill/${PN}.git"
	EGIT_REPO_URI="git://git.savannah.gnu.org/gnulib.git"
else
	inherit vcs-snapshot
	MY_PV="a1882b0"
	SRC_URI="
		https://bitbucket.org/sortsmill/${PN}/get/${MY_PV}.tar.gz
		-> ${P}.tar.gz
		http://git.savannah.gnu.org/cgit/gnulib.git/snapshot/${MY_GL}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A library to retrieve the information from Unicode Consortium namesList"
HOMEPAGE="https://bitbucket.org/sortsmill/${PN}"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		mercurial_src_unpack
		EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_GL}" git-r3_src_unpack
	else
		vcs-snapshot_src_unpack
	fi
}

src_prepare() {
	default
	local _g="gnulib-tool --update"
	ebegin "Running ${_g}"
	"${WORKDIR}"/${MY_GL}/${_g} > /dev/null
	eend $? || die
	eautoreconf
}
