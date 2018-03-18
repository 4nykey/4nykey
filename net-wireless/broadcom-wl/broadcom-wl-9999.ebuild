# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils linux-info linux-mod
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/antoineco/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="21ddc7b"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/antoineco/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Broadcom Linux hybrid wireless driver"
HOMEPAGE="https://www.broadcom.com/support/802.11"

LICENSE="Broadcom"

DEPEND="virtual/linux-sources"
RDEPEND=""

MODULE_NAMES="wl(net/wireless)"
MODULESD_WL_ALIASES=("wlan0 wl")

pkg_setup() {
	CONFIG_CHECK="~!B43 ~!BCMA ~!SSB"
	CONFIG_CHECK2="LIB80211 ~!MAC80211 ~LIB80211_CRYPT_TKIP"
	ERROR_B43="B43: If you insist on building this, you must blacklist it!"
	ERROR_BCMA="BCMA: If you insist on building this, you must blacklist it!"
	ERROR_SSB="SSB: If you insist on building this, you must blacklist it!"
	ERROR_LIB80211="LIB80211: Please enable it. If you can't find it: enabling the driver for \"Intel PRO/Wireless 2100\" or \"Intel PRO/Wireless 2200BG\" (IPW2100 or IPW2200) should suffice."
	ERROR_MAC80211="MAC80211: If you insist on building this, you must blacklist it!"
	ERROR_PREEMPT_RCU="PREEMPT_RCU: Please do not set the Preemption Model to \"Preemptible Kernel\"; choose something else."
	ERROR_LIB80211_CRYPT_TKIP="LIB80211_CRYPT_TKIP: You will need this for WPA."
	if kernel_is ge 3 8 8; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} CFG80211 ~!PREEMPT_RCU ~!PREEMPT"
	elif kernel_is ge 2 6 32; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} CFG80211"
	elif kernel_is ge 2 6 31; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} WIRELESS_EXT ~!MAC80211"
	elif kernel_is ge 2 6 29; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} WIRELESS_EXT COMPAT_NET_DEV_OPS"
	else
		CONFIG_CHECK="${CONFIG_CHECK} IEEE80211 IEEE80211_CRYPT_TKIP"
	fi

	linux-mod_pkg_setup

	BUILD_PARAMS="-C ${KV_DIR} M=${S}"
	BUILD_TARGETS="wl.ko"
}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/${PN}-6.30.223.141-makefile.patch"
		"${FILESDIR}/${PN}-6.30.223.141-eth-to-wlan.patch"
		"${FILESDIR}/${PN}-6.30.223.141-gcc.patch"
		"${FILESDIR}/${PN}-6.30.223.248-r3-Wno-date-time.patch"
		"${FILESDIR}/${PN}-6.30.223.271-r1-linux-3.18.patch"
		"${FILESDIR}/${PN}-6.30.223.271-r2-linux-4.3-v2.patch"
		"${FILESDIR}/${PN}-6.30.223.271-r4-linux-4.7.patch"
	)

	if linux_chkconfig_present PAX_CONSTIFY_PLUGIN; then
		PATCHES+=( "${FILESDIR}"/${PN}-6.30.223.271-pax-no-const.patch )
	fi
	default
}
