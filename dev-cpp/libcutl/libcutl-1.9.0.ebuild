# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils versionator

DESCRIPTION="Library of C++ utilities -- meta-programming tests, smart pointers, containers"
HOMEPAGE="http://codesynthesis.com/projects/libcutl/"
SRC_URI="http://codesynthesis.com/download/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="dev-libs/boost"
DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=(
		--with-external-boost
		--docdir=/tmp/dropme
	)

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	rm -r "${D}"/tmp/dropme || die
}
