# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="ttc ttf"
FONT_TYPES_EXCLUDE="ttf"
inherit check-reqs font-r1

DESCRIPTION="A CJK monospaced font, a composite of Iosevka, M+ and Source Han Sans"
HOMEPAGE="https://be5invis.github.io/${PN^}"
SRC_URI="
	font_types_ttc? (
		http://7xpdnl.dl1.z0.glb.clouddn.com/${P}.7z
	)
	font_types_ttf? (
		http://7xpdnl.dl1.z0.glb.clouddn.com/${PN}-ttfs-${PV}.7z
	)
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+binary l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW"
REQUIRED_USE="|| ( l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW )"

DEPEND="
	app-arch/p7zip
"
S="${WORKDIR}"

pkg_pretend() {
	local _u=0 _d=0
	if use font_types_ttc; then
		use l10n_ja && _u="$((${_u}+113))"
		use l10n_ko && _u="$((${_u}+114))"
		use l10n_zh-CN && _u="$((${_u}+110))"
		use l10n_zh-TW && _u="$((${_u}+110))"
		_d=$((${_d}+447))
	fi
	if use font_types_ttf; then
		use l10n_ja && _u="$((${_u}+502))"
		use l10n_ko && _u="$((${_u}+502))"
		use l10n_zh-CN && _u="$((${_u}+499))"
		use l10n_zh-TW && _u="$((${_u}+502))"
		_d=$((${_d}+2005))
	fi
	CHECKREQS_DISK_BUILD="${_d}M"
	CHECKREQS_DISK_USR="${_u}M"
	check-reqs_pkg_pretend
}

src_prepare() {
	default
	if use font_types_ttc; then
		use l10n_ja || rm -f inziu-J-*.ttc
		use l10n_ko || rm -f inziu-CL-*.ttc
		use l10n_zh-CN || rm -f inziu-SC-*.ttc
		use l10n_zh-TW || rm -f inziu-TC-*.ttc
	fi
	if use font_types_ttf; then
		use l10n_ja || rm -f inziu-*-J-*.ttf
		use l10n_ko || rm -f inziu-*-CL-*.ttf
		use l10n_zh-CN || rm -f inziu-*-SC-*.ttf
		use l10n_zh-TW || rm -f inziu-*-TC-*.ttf
	fi
}
