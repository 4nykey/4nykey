# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/rbrito/pkg-${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/rbrito/pkg-${PN}/tar.gz/upstream/${PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="An MP3 reorganizer"
HOMEPAGE="http://omion.dyndns.org/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	dev-lang/ocaml[ocamlopt]
"
RDEPEND=""

src_prepare() {
	default
	sed \
		-e 's:\<ocamlopt\>:& -ccopt "$(CFLAGS) $(LDFLAGS)" -thread:' \
		-e 's:-o mp3reader\$(EXE_EXT):& str.cmxa:' \
		-i makefile
}

src_compile() {
	emake OBJ_EXT=".o" EXE_EXT=
}

src_install() {
	dobin ${PN} mp3reader
}
