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
		https://registry.npmjs.org/boolbase/-/boolbase-1.0.0.tgz
		https://registry.npmjs.org/commander/-/commander-11.1.0.tgz
		https://registry.npmjs.org/csso/-/csso-5.0.5.tgz
		https://registry.npmjs.org/css-select/-/css-select-5.1.0.tgz
		https://registry.npmjs.org/css-tree/-/css-tree-2.2.1.tgz
		https://registry.npmjs.org/css-tree/-/css-tree-2.3.1.tgz
		https://registry.npmjs.org/css-what/-/css-what-6.1.0.tgz
		https://registry.npmjs.org/domelementtype/-/domelementtype-2.3.0.tgz
		https://registry.npmjs.org/domhandler/-/domhandler-5.0.3.tgz
		https://registry.npmjs.org/dom-serializer/-/dom-serializer-2.0.0.tgz
		https://registry.npmjs.org/domutils/-/domutils-3.1.0.tgz
		https://registry.npmjs.org/entities/-/entities-4.5.0.tgz
		https://registry.npmjs.org/mdn-data/-/mdn-data-2.0.28.tgz
		https://registry.npmjs.org/mdn-data/-/mdn-data-2.0.30.tgz
		https://registry.npmjs.org/nth-check/-/nth-check-2.1.1.tgz
		https://registry.npmjs.org/picocolors/-/picocolors-1.1.0.tgz
		https://registry.npmjs.org/sax/-/sax-1.4.1.tgz
		https://registry.npmjs.org/source-map-js/-/source-map-js-1.2.1.tgz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Nodejs-based tool for optimizing SVG vector graphics files"
HOMEPAGE="https://github.com/svg/svgo"

LICENSE="MIT"
SLOT="0"

BDEPEND="
	net-libs/nodejs[npm]
"
RDEPEND="
	net-libs/nodejs
"

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
	else
		unpack ${P}.tar.gz
		cp "${FILESDIR}"/package-lock.json "${S}"
	fi
	cd "${S}"
	npm install --omit=dev || die
}

src_install() {
	local _d="/usr/$(get_libdir)/node_modules/${PN}"
	insinto ${_d}
	doins -r bin lib node_modules plugins package.json
	fperms +x ${_d}/bin/${PN}.js
	dosym ..${_d#/usr}/bin/${PN}.js /usr/bin/${PN}
	find "${ED}" -type f -regex '.*/\(\..*\|LICENSE.*\|README.*\|build.js\)' -delete
	einstalldocs
}
