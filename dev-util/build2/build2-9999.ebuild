# Copyright 2018-2019 Gentoo Authors
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
		config.bin.lib=shared
		config.install.root="${ED}/usr/"
		config.install.lib="exec_root/$(get_libdir)"
		config.install.doc="data_root/share/doc/${PF}"
	)

	tc-is-gcc && export CCACHE_DISABLE=1
	export LD_LIBRARY_PATH="${S}/libbutl/libbutl:${S}/libpkgconf/libpkgconf:${LD_LIBRARY_PATH}"
	set -- "${@}" "${myconfigargs[@]}"
	echo "${@}"
	"${@}" || die "${@} failed"
}

src_prepare() {
	local _pc="$(tc-getPKG_CONFIG)"

	printf 'cxx.libs += %s\ncxx.poptions += %s\n' \
		"$(${_pc} sqlite3 --libs)" "$(${_pc} sqlite3 --cflags)" >> \
		libodb-sqlite/buildfile

	sed \
		-e 's:libsqlite3[/]\?::' \
		-i buildfile build/bootstrap.build

	default
	emake -C build2 -f bootstrap.gmake CXX=$(tc-getCXX)
}

src_configure() {
	myb ./build2/build2/b-boot configure
}

src_compile() {
	myb ./build2/build2/b-boot update-for-install

	use test || return
	cp -a build2 testdir
	cd testdir
	myb ./build2/b update-for-test
}

src_test() {
	cd testdir
	myb ./build2/b test
}

src_install() {
	myb ./build2/build2/b-boot install
	mkdir -p "${ED}"/usr/share/doc/${PF}/html
	mv -f "${ED}"/usr/share/doc/${PF}/*.xhtml "${ED}"/usr/share/doc/${PF}/html
}
