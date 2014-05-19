# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/fprintd/fprintd-0.2.0-r1.ebuild,v 1.1 2011/11/14 00:45:15 xmw Exp $

EAPI=4

inherit autotools-utils toolchain-funcs git-r3

DESCRIPTION="D-Bus to offer libfprint functionality"
HOMEPAGE="http://cgit.freedesktop.org/libfprint/fprintd/"
EGIT_REPO_URI="git://anongit.freedesktop.org/libfprint/fprintd"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc pam static-libs"

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
HTML_DOCS=(doc/)

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	sys-auth/libfprint
	sys-auth/polkit
	pam? ( sys-libs/pam )
"
DEPEND="
	${RDEPEND}
	dev-util/gtk-doc
	dev-util/intltool
	doc? ( dev-libs/libxml2 dev-libs/libxslt )
"

src_configure() {
	local myeconfargs=(
		$(use_enable pam)
		$(use_enable static-libs static)
		$(use_enable doc gtk-doc-html)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install \
		pammoddir=/$(get_libdir)/security
	use doc && dohtml -a xml -r "${HTML_DOCS[@]}"

	keepdir /var/lib/fprint
}

pkg_postinst() {
	elog "Please take a look at the upstream documentation for integration"
	elog "Example: add following line to your /etc/pam.d/system-local-login"
	einfo
	elog "    auth    sufficient      pam_fprintd.so"
	einfo
}
