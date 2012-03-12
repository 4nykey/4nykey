# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit linux-mod versionator

MY_P="DPO_RT3070_LinuxSTA_V$(replace_version_separator 4 _)"
DESCRIPTION="Driver for the RaLink RT307x USB wireless chipset"
HOMEPAGE="http://www.ralinktech.com/support.php?s=2"
SRC_URI="
http://www.ralinktech.com/download.php?t=U0wyRnpjMlYwY3k4eU1ERXdMekEzTHpJNEwyUnZkMjVzYjJGa01EUXdOVEE1TnpBd01TNWllakk5UFQxRVVFOWZVbFF6TURjd1gweHBiblY0VTFSQlgxWXlMak11TUM0MFh6SXdNVEF3TmpBMExuUmhjZz09Qw
-> ${MY_P}.tar.bz2
"
RESTRICT="primaryuri"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

MODULE_NAMES="rt3070sta(net/wireless:${S}:${S}/os/linux)"
BUILD_PARAMS="LINUX_SRC=${KERNEL_DIR}"
BUILD_TARGETS="all"
CONFIG_CHECK="WIRELESS_EXT"
MODULESD_RT3070STA_ALIASES=('ra? rt3070sta')
MODULESD_RT3070STA_DOCS="README* *usage.txt"

src_unpack() {
	#tarball was tarred twice
	unpack ${A}
	mv "${S}" "${DISTDIR}"/${A%%.bz2}
	unpack ${A%%.bz2}
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}*.diff
}

src_install() {
	linux-mod_src_install
	insinto /etc/Wireless/RT2870STA
	doins RT2870STA*.dat
}
