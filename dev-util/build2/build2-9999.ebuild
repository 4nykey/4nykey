# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs multiprocessing
MY_PN="${PN}-toolchain"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.${PN}.org/${MY_PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="
		https://download.${PN}.org/${PV}/${MY_PN}-${PV}.tar.xz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="An open source cross-platform toolchain for building and packaging C++ code"
HOMEPAGE="https://build2.org"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-db/sqlite:3
"
DEPEND="${RDEPEND}"
PATCHES=(
	"${FILESDIR}"/${PN}-nousrlocal.diff
)

src_prepare() {
	local _pc="$(tc-getPKG_CONFIG)"

	printf 'cxx.libs += %s\ncxx.poptions += %s\n' \
		"$(${_pc} sqlite3 --libs)" "$(${_pc} sqlite3 --cflags)" >> \
		libodb-sqlite/buildfile

	sed \
		-e 's:libsqlite3[/]\?::' \
		-i buildfile build/bootstrap.build

	default
}

myb() {
	local myconfigargs=(
		--jobs $(makeopts_jobs)
		--verbose 2
		config.c="$(tc-getCC)"
		config.cxx="$(tc-getCXX)"
		config.cc.coptions="${CFLAGS}"
		config.cc.loptions="${LDFLAGS}"
		config.cxx.coptions="${CXXFLAGS}"
		config.cxx.loptions="${LDFLAGS}"
		config.bin.ar="$(tc-getAR)"
		config.bin.ranlib="$(tc-getRANLIB)"
		config.install.root="${ED}/usr/"
		config.install.lib="exec_root/$(get_libdir)"
		config.install.doc="data_root/share/doc/${PF}"
	)

	set -- "${@}" "${myconfigargs[@]}"
	echo "${@}"
	"${@}" || die "${@} failed"
}

src_compile() {
	cd build2
	emake -f bootstrap.gmake CXX=$(tc-getCXX)
	tc-is-gcc && export CCACHE_DISABLE=1
	myb ./build2/b-boot config.bin.lib=static update-for-install

	cd "${S}"
	myb ./build2/build2/b config.bin.lib=shared configure
	myb ./build2/build2/b $(usex test '' 'update-for-install')
}

src_test() {
	tc-is-gcc && export CCACHE_DISABLE=1
	cd build2
	myb ./build2/b --verbose 1 test
}

src_install() {
	myb ./build2/build2/b install
	mkdir -p "${ED}"/usr/share/doc/${PF}/html
	mv -f "${ED}"/usr/share/doc/${PF}/*.xhtml "${ED}"/usr/share/doc/${PF}/html
}
