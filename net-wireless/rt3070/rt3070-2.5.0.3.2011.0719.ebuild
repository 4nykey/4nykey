# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit linux-mod versionator

MY_P="$(version_format_string '$5_$6_RT3070_RT3370_RT5370_RT5372_Linux_STA_V$1.$2.$3.$4_DPO')"
DESCRIPTION="Driver for the RaLink RT307x/RT3370/RT537x USB wireless chipsets"
HOMEPAGE="http://www.ralinktech.com/en/04_support/support.php?sn=501"
SRC_URI="${MY_P}.bz2"
RESTRICT="fetch"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

MODULE_NAMES="rt5370sta(net/wireless:${S}:${S}/os/linux)"
BUILD_PARAMS="LINUX_SRC=${KERNEL_DIR} HAS_WPA_SUPPLICANT=y HAS_NATIVE_WPA_SUPPLICANT_SUPPORT=y"
BUILD_TARGETS="all"
CONFIG_CHECK="WIRELESS_EXT"
MODULESD_RT3070STA_ALIASES=('ra? rt5370sta')
MODULESD_RT3070STA_DOCS="README* *.txt"

pkg_nofetch() {
	elog "Please download ${A}"
	elog "from http://www.ralinktech.com/en/04_support/license.php?sn=5016"
	elog "and place it in ${DISTDIR}."
}

src_unpack() {
	tar xjf "${DISTDIR}"/${A}
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-makefile.diff
}

src_install() {
	linux-mod_src_install
	insinto /etc/Wireless/RT2870STA
	doins RT2870STA*.dat
}
