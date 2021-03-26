# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/svg/${PN}.git"
else
	SRC_URI="
		mirror://githubcl/svg/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Nodejs-based tool for optimizing SVG vector graphics files"
HOMEPAGE="https://github.com/svg/svgo"

LICENSE="MIT"
SLOT="0"
IUSE=""

BDEPEND="
	net-libs/nodejs[npm]
"
RDEPEND="
	net-libs/nodejs
"

src_prepare() {
	default
	npm install
}

src_compile() { :; }

src_install() {
	rm -rf node_modules
	npm install --production --no-dev || die
	local _d="/usr/$(get_libdir)/node_modules/${PN}"
	insinto ${_d}
	doins -r bin lib node_modules plugins package.json
	fperms +x ${_d}/bin/${PN}
	dosym ..${_d#/usr}/bin/${PN} /usr/bin/${PN}
	find "${ED}" -type f -regex '.*/\(\..*\|LICENSE.*\|README.*\|build.js\)' -delete
	einstalldocs
}
