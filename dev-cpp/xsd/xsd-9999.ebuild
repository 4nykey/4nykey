# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.codesynthesis.com/${PN}/${PN}.git"
else
	MY_PV="7ff03f4"
	[[ -n ${PV%%*_*} ]] && MY_PV="${PV}"
	SRC_URI="
		https://git.codesynthesis.com/cgit/${PN}/${PN}/snapshot/${MY_PV}.tar.gz
		-> ${P}.tar.gz
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
	dev-libs/boost:=[threads]
	>=dev-cpp/libcutl-1.11.0_beta9:=
	>=dev-cpp/libxsd-frontend-2.1.0_beta2:=
	zlib? ( sys-libs/zlib )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/build2
	dev-util/cli
	doc? ( app-doc/doxygen )
"

src_prepare() {
	# collision with xsd of dev-lang/mono
	grep -rl '{xsd}:'|xargs sed 's,{xsd}:,{codesynthesis-xsd}:,' -i
	default
}

src_configure() {
	local myconfigargs=(
		config.cxx="$(tc-getCXX)"
		config.cxx.coptions="${CXXFLAGS}"
		config.cxx.loptions="${LDFLAGS}"
		config.bin.ar="$(tc-getAR)"
		config.bin.ranlib="$(tc-getRANLIB)"
		config.install.root="${ED}/usr/"
		config.install.lib="exec_root/$(get_libdir)"
		config.install.doc="data_root/share/doc/${PF}"
	)

	MAKE=b \
	MAKEOPTS="--jobs $(makeopts_jobs) --verbose 3" \
	emake \
		"${myconfigargs[@]}" \
		configure: libxsd/ xsd/
}

src_compile() {
	tc-is-gcc && export CCACHE_DISABLE=1
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
	einstalldocs
}
