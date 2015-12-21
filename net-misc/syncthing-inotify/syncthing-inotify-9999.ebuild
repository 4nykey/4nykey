# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_CB="cenkalti/backoff-4dc7767"
MY_ZN="zillode/notify-f06b1e3"
EGO_PN="github.com/${PN%-*}/${PN}"
inherit systemd golang-build
if [[ -z ${PV%%*9999} ]]; then
	inherit golang-vcs
else
	inherit golang-vcs-snapshot
	SRC_URI="
		mirror://githubcl/${PN%-*}/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
		mirror://githubcl/${MY_CB%-*}/tar.gz/${MY_CB#*-} -> ${MY_CB#*/}.tar.gz
		mirror://githubcl/${MY_ZN%-*}/tar.gz/${MY_ZN#*-} -> ${MY_ZN#*/}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
DESCRIPTION="File watcher intended for use with Syncthing"
HOMEPAGE="https://syncthing.net/"

LICENSE="MPL-2.0"
SLOT="0"
IUSE="systemd"

DEPEND=""
RDEPEND="
	net-misc/syncthing
"

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		golang-vcs_src_unpack
		cp -r "${EGO_STORE_DIR}"/src/${EGO_PN%%/*}/{${MY_CB%/*},${MY_ZN%/*}} \
			"${S}"/src/${EGO_PN%%/*}/
	else
		golang-vcs-snapshot_src_unpack
		unpack ${MY_CB#*/}.tar.gz ${MY_ZN#*/}.tar.gz
		mkdir -p "${S}"/src/github.com/{${MY_CB%/*},${MY_ZN%/*}}
		mv ${MY_CB#*/} "${S}"/src/github.com/${MY_CB%-*}
		mv ${MY_ZN#*/} "${S}"/src/github.com/${MY_ZN%-*}
	fi
}

src_prepare() {
	if [[ -z ${PV%%*9999} ]]; then
		local _v="$(env GIT_DIR="${EGO_STORE_DIR}/src/${EGO_PN}/.git" \
			git describe --abbrev=0 --tags)"
	fi
	sed \
		-e "s,\(Version.*=.*\)unknown-dev,\1${_v:-v${PV}}," \
		-i "${S}"/src/${EGO_PN}/syncwatcher.go
}

src_install() {
	dobin ${PN}
	dodoc src/${EGO_PN}/README.md
	if use systemd; then
		systemd_dounit src/${EGO_PN}/etc/linux-systemd/system/${PN}@.service
		systemd_douserunit src/${EGO_PN}/etc/linux-systemd/user/${PN}.service
	fi
}
