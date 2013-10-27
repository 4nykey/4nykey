# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gio-sharp/gio-sharp-0.3.ebuild,v 1.4 2012/05/04 03:56:57 jdhore Exp $

EAPI=5
inherit autotools-utils mono git-2

DESCRIPTION="GIO API C# binding"
HOMEPAGE="http://github.com/mono/gio-sharp"
EGIT_REPO_URI="git://github.com/mono/gio-sharp.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-dotnet/glib-sharp-2.12
	>=dev-dotnet/gtk-sharp-gapi-2.12
	>=dev-libs/glib-2.22:2
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
DOCS=( AUTHORS NEWS README )
AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

src_prepare() {
	sed -i -e '/autoreconf/d' autogen-generic.sh || die
	NOCONFIGURE=1 ./autogen-2.22.sh || die

	autotools-utils_src_prepare
}

src_install() {
	egacinstall gio/${PN}.dll ${PN} || die
	insinto /usr/$(get_libdir)/pkgconfig
	sed -e 's:assemblies_dir=\${libdir}/:&mono/:' -i gio/${PN}-2.0.pc
	doins gio/${PN}-2.0.pc
	mono_multilib_comply
	dodoc ${DOCS[@]}
}
