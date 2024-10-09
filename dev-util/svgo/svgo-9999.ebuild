# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/svg/${PN}.git"
else
	MY_PV="$(ver_rs 3 '-' 4 '.')"
	SRC_URI="
		mirror://githubcl/svg/${PN}/tar.gz/v${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
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

src_install() {
	npm install --omit=dev || die
	local _d="/usr/$(get_libdir)/node_modules/${PN}"
	insinto ${_d}
	doins -r bin lib node_modules plugins package.json
	fperms +x ${_d}/bin/${PN}.js
	dosym ..${_d#/usr}/bin/${PN}.js /usr/bin/${PN}
	find "${ED}" -type f -regex '.*/\(\..*\|LICENSE.*\|README.*\|build.js\)' -delete
	einstalldocs
}
