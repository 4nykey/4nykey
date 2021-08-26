# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.codesynthesis.com/${PN}/${PN}.git"
else
	MY_PV="a54c695"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV/_beta/-b.}"
	SRC_URI="
		https://git.codesynthesis.com/cgit/${PN}/${PN}/snapshot/${MY_PV}.tar.gz
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PV}"
fi
inherit toolchain-funcs multiprocessing

DESCRIPTION="Command Line Interface compiler for C++"
HOMEPAGE="https://www.codesynthesis.com/projects/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="static-libs"

RDEPEND="
	>=dev-cpp/libcutl-1.11.0_pre20210722:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=dev-util/build2-0.13.0
"

src_prepare() {
	default
	tc-is-gcc && export CCACHE_DISABLE=1
	touch cli/doc/cli.{1,xhtml}
	sed -e '/\(html2ps\|ps2pdf14\)/d' -i cli/doc/doc.sh
}

src_configure() {
	local myconfigargs=(
		config.cxx="$(tc-getCXX)"
		config.cxx.coptions="${CXXFLAGS}"
		config.cxx.loptions="${LDFLAGS}"
		config.bin.ar="$(tc-getAR)"
		config.bin.ranlib="$(tc-getRANLIB)"
		config.bin.lib="$(usex static-libs both shared)"
		config.install.root="${ED}/usr/"
		config.install.lib="exec_root/$(get_libdir)"
		config.install.doc="data_root/share/doc/${PF}"
	)

	MAKE=b \
	MAKEOPTS="--jobs $(makeopts_jobs) --verbose 3" \
	emake \
		"${myconfigargs[@]}" \
		configure: cli/
}

src_compile() {
	MAKE=b \
	MAKEOPTS="--jobs $(makeopts_jobs) --verbose 3" \
	emake cli/
	cd cli/doc
	sh ./doc.sh
}

src_test() {
	MAKE=b \
	MAKEOPTS="--jobs $(makeopts_jobs)" \
	emake test
}

src_install() {
	MAKE=b \
	MAKEOPTS="--jobs $(makeopts_jobs) --verbose 3" \
	emake install: cli/
	einstalldocs
}
