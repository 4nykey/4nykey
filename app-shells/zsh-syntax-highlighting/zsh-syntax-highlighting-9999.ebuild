# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit readme.gentoo-r1

if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/zsh-users/${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	SRC_URI="mirror://githubcl/zsh-users/${PN}/tar.gz/${PV/_/-} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

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
	default
}

src_install() {
	emake \
		SHARE_DIR="${ED}/usr/share/zsh/site-contrib/${PN}" \
		DOC_DIR="${ED}/usr/share/doc/${PF}" \
		install
	readme.gentoo_create_doc
}
