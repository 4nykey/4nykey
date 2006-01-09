# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/mc/mc-4.6.0-r14.ebuild,v 1.6 2006/01/03 22:02:11 sekretarz Exp $

inherit cvs flag-o-matic

DESCRIPTION="GNU Midnight Commander cli-based file manager"
HOMEPAGE="http://www.ibiblio.org/mc/"
#PORTAGE_ACTUAL_DISTDIR=/usr/portage/distfiles
ECVS_SERVER="cvs.sv.gnu.org:/sources/mc"
ECVS_MODULE="mc"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="7zip X gpm ncurses nls pam samba slang unicode"

PROVIDE="virtual/editor"

RDEPEND=">=sys-fs/e2fsprogs-1.19
	ncurses? ( >=sys-libs/ncurses-5.2-r5 )
	=dev-libs/glib-2*
	pam? ( >=sys-libs/pam-0.72 )
	gpm? ( >=sys-libs/gpm-1.19.3 )
	slang? ( >=sys-libs/slang-2.0.0 )
	samba? ( >=net-fs/samba-3.0.0 )
	X? ( || ( (
			x11-libs/libX11
			x11-libs/libICE
			x11-libs/libXau
			x11-libs/libXdmcp
			x11-libs/libSM
			)
			virtual/x11
		)
	)
	x86? ( 7zip? ( >=app-arch/p7zip-4.16 ) )
	ppc? ( 7zip? ( >=app-arch/p7zip-4.16 ) )
	amd64? ( 7zip? ( >=app-arch/p7zip-4.16 ) )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	cvs_src_unpack
	cd ${S}

	epatch ${FILESDIR}/${P}-find.patch
	#epatch ${FILESDIR}/${PN}-4.6.1-largefile.patch
	# Fix building with gcc4.
	#epatch ${FILESDIR}/${P}-gcc4.patch

	# included is slang v2, which handles utf-8
	# so external patched slang not required anymore
	use unicode && epatch ${FILESDIR}/${P}-utf8*.patch

	ebegin "Running autotools"
	./autogen.sh >& /dev/null
	eend $?
}

src_compile() {
	append-flags -I/usr/include/gssapi
	filter-flags -malign-double

	local myconf=""

	if use slang; then
		myconf="${myconf} --with-screen=slang"
	elif use ncurses && ! use unicode; then
		myconf="${myconf} --with-screen=ncurses"
	else
		myconf="${myconf} --with-screen=mcslang"
	fi

	myconf="${myconf} `use_with gpm gpm-mouse`"

	use nls \
	    && myconf="${myconf} --with-included-gettext" \
	    || myconf="${myconf} --disable-nls"

	myconf="${myconf} `use_with X x`"

	use samba \
	    && myconf="${myconf} --with-samba --with-configdir=/etc/samba --with-codepagedir=/var/lib/samba/codepages --with-privatedir=/etc/samba/private" \
	    || myconf="${myconf} --without-samba"

	econf \
	    --with-vfs \
	    --with-ext2undel \
	    --with-edit \
		--enable-charset \
	    ${myconf} || die

	emake || die
}

src_install() {
	 cat ${FILESDIR}/chdir-4.6.0.gentoo >>\
		 ${S}/lib/mc-wrapper.sh

	einstall || die

	# install cons.saver setuid, to actually work
	chmod u+s ${D}/usr/lib/mc/cons.saver

	dodoc ChangeLog AUTHORS MAINTAINERS FAQ INSTALL* NEWS README*

	insinto /usr/share/mc
	doins ${FILESDIR}/mc.gentoo
	doins ${FILESDIR}/mc.ini

	insinto /usr/share/mc/syntax
	doins ${FILESDIR}/ebuild.syntax
	cd ${D}/usr/share/mc/syntax
	epatch ${FILESDIR}/${PN}-4.6.0-ebuild-syntax.patch

	# http://bugs.gentoo.org/show_bug.cgi?id=71275
	rm -f ${D}/usr/share/locale/locale.alias
}

pkg_postinst() {
	einfo "Add the following line to your ~/.bashrc to"
	einfo "allow mc to chdir to its latest working dir at exit"
	einfo ""
	einfo "# Midnight Commander chdir enhancement"
	einfo "if [ -f /usr/share/mc/mc.gentoo ]; then"
	einfo "	. /usr/share/mc/mc.gentoo"
	einfo "fi"
}
