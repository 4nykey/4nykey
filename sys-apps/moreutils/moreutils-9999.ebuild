# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://git.joeyh.name/git/${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	SRC_URI="
		https://git.joeyh.name/index.cgi/${PN}.git/snapshot/${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit toolchain-funcs

DESCRIPTION="A collection of unix tools that nobody thought to write 30 years ago"
HOMEPAGE="https://joeyh.name/code/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	dev-lang/perl
	dev-perl/IPC-Run
	dev-perl/Time-Duration
	dev-perl/TimeDate
"
DEPEND="
	${RDEPEND}
	app-text/docbook-xml-dtd:4.4
	app-text/docbook2X
	app-admin/eselect
"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		DOCBOOK2XMAN="docbook2man.pl"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		INSTALL_BIN="install" \
		install

	mv "${ED}"usr/share/man/man1/{,${PN}_}parallel.1
	mv "${ED}"usr/bin/{,${PN}_}parallel
}

pkg_postinst() {
	eselect editor update
}
