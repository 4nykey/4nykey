# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/emelfm2/emelfm2-0.0.9-r1.ebuild,v 1.5 2005/06/12 12:10:28 swegener Exp $

inherit eutils toolchain-funcs

DESCRIPTION="A gtk+ file manager that implements popular two-pane design"
HOMEPAGE="http://emelfm2.net/"
SRC_URI="http://emelfm2.net/rel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls fam debug inotify unicode kernel_linux"
RESTRICT="test" # requires splint

RDEPEND="
	>=x11-libs/gtk+-2.4
	fam? ( virtual/fam )
"
DEPEND="
	${RDEPEND}
"

teh_conf() {
	use !$1; myconf="${myconf} $2=$?"
}

src_unpack() {
	unpack ${A}
	cd ${S}
	# prevent stripping binaries, bzipping manpages
	sed -i "/bzip2/d; /\<strip\>/d" Makefile
	# make it more verbose
	sed -i "s:@\$(:\$(:" Makefile
	rm docs/*{GPL,txt,INSTALL}
}

src_compile() {
	myconf="CC=$(tc-getCC) USE_LATEST=1"
	teh_conf nls I18N
	teh_conf debug DEBUG
	teh_conf unicode FILES_UTF8ONLY
	if use kernel_linux; then
		teh_conf inotify USE_INOTIFY
	elif has_version 'app-admin/fam'; then
		teh_conf fam USE_FAM
	elif has_version 'app-admin/gamin'; then
		teh_conf fam USE_GAMIN
	fi
	emake PREFIX=/usr \
		${myconf} || die "emake failed"
}

src_install() {
	dodir /usr/bin
	emake PREFIX=${D}/usr \
		DOC_DIR=${D}/usr/share/doc/${PF} \
		${myconf} install || die "make install failed"
	prepalldocs
}
