# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.codesynthesis.com/${PN}/${PN}.git"
else
	MY_PV="7ff03f4"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV/_beta/-b.}"
	SRC_URI="
		https://git.codesynthesis.com/cgit/${PN}/${PN}/snapshot/${MY_PV}.tar.xz
		-> ${P}.tar.xz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PV}"
fi
inherit toolchain-funcs multiprocessing

DESCRIPTION="An open-source, cross-platform W3C XML Schema to C++ data binding compiler"
HOMEPAGE="https://www.codesynthesis.com/products/xsd/"
LICENSE="GPL-2"
SLOT="0"
IUSE="doc examples test zlib"
RDEPEND="
	>=dev-libs/xerces-c-3.0.0
	dev-libs/boost:=
	>=dev-cpp/libcutl-1.11.0_beta9:=
	>=dev-cpp/libxsd-frontend-2.1.0_beta2:=
	zlib? ( sys-libs/zlib )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/build2-0.15
	dev-util/cli
	doc? ( app-doc/doxygen )
"
PATCHES=( "${FILESDIR}"/packages.diff )

src_configure() {
	local _c='gcc'
	tc-is-clang && _c='clang'
	local myconfigargs=(
		config.cxx="$(tc-getCXX)"
		config.cxx.id="${_c}"
		config.cxx.coptions="${CXXFLAGS}"
		config.cxx.loptions="${LDFLAGS}"
		config.bin.ar="$(tc-getAR)"
		config.bin.ranlib="$(tc-getRANLIB)"
		config.install.root="${ED}/usr/"
		config.install.bin="exec_root/libexec/codesynthesis"
		config.install.lib="exec_root/$(get_libdir)"
		config.install.doc="data_root/share/doc/${PF}"
		config.install.legal="${T}"
	)

	MAKE=b \
	MAKEOPTS="--jobs $(makeopts_jobs) --verbose 3" \
	emake \
		"${myconfigargs[@]}" \
		configure: libxsd/ xsd/
}

src_compile() {
	export CCACHE_DISABLE=1
	MAKE=b \
	MAKEOPTS="--jobs $(makeopts_jobs) --verbose 3" \
	emake libxsd/ xsd/
}

src_test() {
	MAKE=b \
	MAKEOPTS="--jobs $(makeopts_jobs)" \
	emake test
}

src_install() {
	MAKE=b \
	MAKEOPTS="--jobs $(makeopts_jobs) --verbose 3" \
	emake install
	rm -rf "${ED}"/usr/share/man/man1
	newman xsd/doc/pregenerated/xsd.1 codesynthesis-xsd.1
}
