# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit multilib toolchain-funcs versionator

MY_PV=$(get_version_component_range 1-2)
DESCRIPTION="Domain-specific language for defining command line interfaces"
HOMEPAGE="http://www.codesynthesis.com/projects/cli/"
SRC_URI="http://www.codesynthesis.com/download/${PN}/${MY_PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-cpp/libcutl"
DEPEND="${RDEPEND}
	dev-util/build:0.3"

src_prepare() {
	epatch "${FILESDIR}"/${PN}.diff
}

src_configure() {
	mkdir -p build/cxx/gnu || die
	echo "cxx_id := gnu" > build/cxx/configuration-dynamic.make || die

	cat <<-EOF > build/cxx/gnu/configuration-dynamic.make || die
	cxx_gnu := $(tc-getCXX)
	cxx_gnu_libraries := /usr/$(get_libdir)
	cxx_gnu_optimization_options := ${CXXFLAGS}
	cxx_ld_extra_options := ${LDFLAGS}
	cxx_pp_extra_options := ${CPPFLAGS}
EOF

	echo "libcutl_installed := y" > build/import/libcutl/configuration-dynamic.make || die

	find . -name 'makefile' -exec sed -i -e "s|(install_doc_dir)/cli|(install_doc_dir)|" {} \;
}

src_install() {
	emake install_prefix="${D}/usr" install_doc_dir="${D}/usr/share/doc/cli-${PV}" \
		install || die
}
