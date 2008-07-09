# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="A library of image understanding-related algorithms"
HOMEPAGE="http://code.google.com/p/iulib/"
ESVN_REPO_URI="http://iulib.googlecode.com/svn/trunk"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	media-libs/libpng
	media-libs/jpeg
	media-libs/tiff
"
RDEPEND="
	${DEPEND}
	dev-util/scons
"

src_unpack() {
	subversion_src_unpack
	sed -i "${S}"/SConstruct -e "s:if have_vidio:if 0:"
}

src_compile() {
	scons \
		${MAKEOPTS} \
		prefix="/usr" \
		opt="${CXXFLAGS}" \
		|| die
}

src_install() {
	scons \
		${MAKEOPTS} \
		prefix="${D}/usr" \
		opt="${CXXFLAGS}" \
		install || die
	dodoc CHANGES README
}
