# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
FONT_SUFFIX=otf
EGIT_REPO_URI="https://github.com/alerque/${PN}.git"
if [[ -z ${PV%%*9999} ]]; then
	REQUIRED_USE="!binary"
else
	SRC_URI="
		binary? (
			https://github.com/alerque/${PN}/releases/download/v${PV%_p*}/${PN^}-${PV%_p*}.tar.zst
		)
	"
	RESTRICT="primaryuri"
	if has binary ${USE}; then
		S="${WORKDIR}/${PN^}-${PV%_p*}"
	else
		EGIT_COMMIT="758651b"
		[[ -n ${PV%%*_p*} ]] && EGIT_COMMIT="v${PV}"
	fi
	KEYWORDS="~amd64"
fi
inherit git-r3 unpacker python-single-r1 font-r1

DESCRIPTION="A fork of the Linux Libertine and Linux Biolinum fonts"
HOMEPAGE="https://github.com/alerque/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

BDEPEND="
	!binary? (
		${PYTHON_DEPS}
		dev-util/fontship[${PYTHON_SINGLE_USEDEP}]
	)
"

pkg_setup() {
	if use binary; then
		FONT_S=( static/OTF )
	else
		python-single-r1_pkg_setup
		DOCS="*.linuxlibertine.txt"
	fi
	font-r1_pkg_setup
}

src_unpack() {
	if use binary; then
		unpacker_src_unpack
	else
		git-r3_src_unpack
	fi
}

src_compile() {
	use binary && return
	local _args=(
		STATICWOFF2=
		PROJECT="${PN^}"
	)
	fontship -v make -- "${_args[@]}" || die
}
