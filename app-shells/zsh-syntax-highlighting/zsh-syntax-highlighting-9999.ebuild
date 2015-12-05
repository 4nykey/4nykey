# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils readme.gentoo

case ${PV} in
9999*)
	EGIT_REPO_URI="git://github.com/zsh-users/${PN}.git"
	inherit git-r3
	;;
*)
	SRC_URI="mirror://githubcl/zsh-users/${PN}/tar.gz/${PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	;;
esac

DESCRIPTION="Fish shell like syntax highlighting for zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-syntax-highlighting"

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="app-shells/zsh"
DEPEND=""

DISABLE_AUTOFORMATTING="true"
DOC_CONTENTS="In order to use ${CATEGORY}/${PN} add
. /usr/share/zsh/site-contrib/${PN}/zsh-syntax-highlighting.zsh
at the end of your ~/.zshrc
For testing, you can also execute the above command in your zsh."

src_prepare() {
	sed -e 's:COPYING.md::' -i Makefile
	epatch_user
}

src_install() {
	einstall \
		SHARE_DIR="${ED}/usr/share/zsh/site-contrib/${PN}" \
		DOC_DIR="${ED}/usr/share/doc/${PF}"
	readme.gentoo_create_doc
}
