# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/xombrero/xombrero-9999.ebuild,v 1.4 2014/03/01 22:22:26 mgorny Exp $

EAPI="5"

inherit eutils fdo-mime toolchain-funcs base
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="
		git://opensource.conformal.com/${PN}.git
		https://opensource.conformal.com/git/${PN}.git
	"
	KEYWORDS=""
else
	SRC_URI="http://opensource.conformal.com/snapshots/${PN}/${P}.tgz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A minimalist web browser with sophisticated security features designed-in"
HOMEPAGE="http://opensource.conformal.com/wiki/xombrero"

LICENSE="ISC"
SLOT="0"
IUSE="gtk3 examples"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libbsd
	dev-libs/libgcrypt:0
	net-libs/libsoup:2.4
	net-libs/gnutls
	gtk3? (
		net-libs/webkit-gtk:3
		x11-libs/gtk+:3
	)
	!gtk3? (
		net-libs/webkit-gtk:2
		x11-libs/gtk+:2
	)
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
"
DEPEND="
	${RDEPEND}
	dev-lang/perl
	sys-apps/groff
"
DOCS=( README.md )

src_prepare() {
	sed -i \
		-e 's/-O2//' \
		-e 's/-ggdb3//' \
		linux/GNUmakefile || die 'sed Makefile failed.'
	sed -i \
		-e 's#https://www\.cyphertite\.com#http://www.gentoo.org#' \
		xombrero.h || die 'sed xombrero.h failed.'
	sed \
		-e "s:Application;::" \
		-e "s:icon64\.png::" \
		-i xombrero.desktop || die
	base_src_prepare
}

src_compile() {
	CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDADD="${LDFLAGS}" \
	base_src_compile -C linux \
		GTK_VERSION=$(usex gtk3 gtk3 gtk2) \
		PREFIX=/usr
}

src_install() {
	base_src_install -C linux \
		PREFIX=/usr
	
	newicon ${PN}{icon256,}.png

	if use examples;then
		insinto "/usr/share/doc/${PF}/examples"
		doins \
			${PN}.conf \
			playflash.sh \
			favorites
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
