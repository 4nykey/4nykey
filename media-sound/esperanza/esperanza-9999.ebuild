# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git qt4 toolchain-funcs
DESCRIPTION="Esperanza is a XMMS2 client written in C++/Qt4"
HOMEPAGE="http://wiki.xmms2.xmms.se/index.php/Client:Esperanza"
EGIT_REPO_URI="git://git.xmms.se/xmms2/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	media-sound/xmms2
	$(qt4_min_version 4.2)
"
DEPEND="
	${RDEPEND}
"

pkg_setup() {
	if ! built_with_use media-sound/xmms2 boost; then
		eerror "Please remerge xmms2 with 'boost' in USE"
		die "we need xmmsclient++"
	fi
}

src_compile() {
	qmake || die
	sed -i "s:\(FLAGS[ ]*\)=:\1+=:" Makefile
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		LFLAGS="${LDFLAGS}" \
		|| die
}

src_install() {
	dobin esperanza
	dodoc ChangeLog
}
