# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gtk-sharp-beans/gtk-sharp-beans-2.14.0.ebuild,v 1.5 2012/05/04 03:56:55 jdhore Exp $

EAPI=5
inherit autotools-utils mono multilib git-2

DESCRIPTION="GTK+ API C# binding"
HOMEPAGE="http://github.com/mono/gtk-sharp-beans"
EGIT_REPO_URI="git://github.com/mono/gtk-sharp-beans.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-dotnet/gio-sharp
	>=dev-dotnet/glib-sharp-2.12
	>=dev-dotnet/gtk-sharp-2.12
	>=dev-dotnet/gtk-sharp-gapi-2.12
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
DOCS=( AUTHORS NEWS README )
AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

src_install() {
	#autotools-utils_src_install
	egacinstall ${PN}.dll ${PN} || die
	insinto /usr/$(get_libdir)/pkgconfig
	sed -e 's:assemblies_dir=\${libdir}/:&mono/:' -i ${PN}-2.0.pc
	doins ${PN}-2.0.pc

	mono_multilib_comply
}
