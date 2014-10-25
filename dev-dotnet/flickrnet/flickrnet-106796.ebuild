# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/flickrnet-bin/flickrnet-bin-2.2-r1.ebuild,v 1.5 2011/06/13 22:19:27 flameeyes Exp $

EAPI=5

MY_PN="FlickrNet"

inherit mono multilib unpacker

DESCRIPTION="A .Net Library for accessing the Flickr API"
HOMEPAGE="http://www.codeplex.com/FlickrNet"

# Upstream download require click-through LGPL-2.1.
# Since the license allows us to do that, just redistribute
# it in a decent format.
SRC_URI="http://download-codeplex.sec.s-msft.com/Download/SourceControlFileDownload.ashx?ProjectName=${PN}&changeSetId=${PV} -> ${P}.zip"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	!dev-dotnet/flickrnet-bin
"
DEPEND="
	>=dev-lang/mono-2.4
	$(unpacker_src_uri_depends)
"

S="${WORKDIR}/${MY_PN}"

src_compile() { 
	xbuild /property:Configuration=Release FlickrNet.csproj || die
}

src_install() {
	egacinstall bin/Release/${MY_PN}.dll ${MY_PN} || die

	# Install .pc file as required by f-spot
	dodir /usr/$(get_libdir)/pkgconfig
	local MY_PV="$(sed '/AssemblyVersion/!d; s:[^0-9.]::g' AssemblyInfo.cs)"
	sed "${FILESDIR}"/${PN}.pc.in \
		-e "s:@VERSION@:${MY_PV}:" \
		-e "s:@LIBDIR@:/usr/$(get_libdir):" \
		> "${D}"/usr/$(get_libdir)/pkgconfig/${PN}.pc \
		|| die "sed failed"
}
