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
		_u=$((${_u}
			+$(usex l10n_ja		113 0)
			+$(usex l10n_ko		114 0)
			+$(usex l10n_zh-CN	110 0)
			+$(usex l10n_zh-TW	110 0)
		))
		_d=$((${_d}+447))
	fi
	if use font_types_ttf; then
		_u=$((${_u}
			+$(usex l10n_ja		502 0)
			+$(usex l10n_ko		502 0)
			+$(usex l10n_zh-CN	499 0)
			+$(usex l10n_zh-TW	502 0)
		))
		_d=$((${_d}+2005))
	fi
	CHECKREQS_DISK_BUILD="${_d}M"
	CHECKREQS_DISK_USR="${_u}M"
	check-reqs_pkg_pretend
}

src_prepare() {
	default
	rm -f \
		$(usex !l10n_ja 'inziu*-J-*.tt[cf]') \
		$(usex !l10n_ko 'inziu*-CL-*.tt[cf]') \
		$(usex !l10n_zh-CN 'inziu*-SC-*.tt[cf]') \
		$(usex !l10n_zh-TW 'inziu*-TC-*.tt[cf]')
}
