# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
FONT_SUFFIX=otf
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alerque/${PN}.git"
	REQUIRED_USE="!binary"
else
	MY_PV="983ab6c"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		!binary? (
			mirror://githubcl/alerque/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		)
		binary? (
			https://github.com/alerque/${PN}/releases/download/v${PV%_p*}/${PN^}-${PV%_p*}.tar.xz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
inherit python-single-r1 font-r1

DESCRIPTION="A fork of the Linux Libertine and Linux Biolinum fonts"
HOMEPAGE="https://github.com/alerque/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

BDEPEND="
	!binary? (
		${PYTHON_DEPS}
		>=dev-util/fontship-0.7[${PYTHON_SINGLE_USEDEP}]
	)
"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}/${PN^}-${PV%_p*}"
		FONT_S=( static/OTF )
	else
		python-single-r1_pkg_setup
		DOCS="*.linuxlibertine.txt"
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return
	[[ -z ${PV%%*9999} ]] && return
	git init . -q -b master
	git config user.email "portage@local"
	git config user.name "portage"
	git add .
	git commit -q -m init
	git tag v${PV%_p*}
}

src_compile() {
	use binary && return
	local _args=(
		STATICWOFF2=
		PROJECT="${PN^}"
	)
	fontship make -- "${_args[@]}" || die
}
