# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

K_PREPATCHED="yes"
UNIPATCH_STRICTORDER="yes"
K_NOUSENAME="yes"
ETYPE="sources"
inherit kernel-2
detect_version

# A few hacks to set ck version via _p instead of -r
MY_PV="$(replace_all_version_separators . ${PVR/r/})"
EXTRAVERSION="-$(get_version_component_range 4- ${MY_PV/p/beyond})"
KV_FULL=${OKV}${EXTRAVERSION}
detect_version

IUSE=""

TEH_PATCH="patch-${KV_FULL}.bz2"
UNIPATCH_LIST="${DISTDIR}/${TEH_PATCH}"

DESCRIPTION="Beyond is a derivation of the CK patchset"
HOMEPAGE="http://iphitus.loudas.com/beyond.php"
SRC_URI="${KERNEL_URI} http://iphitus.loudas.com/beyond/${OKV}/${TEH_PATCH}"

KEYWORDS="~x86"

pkg_postinst() {
	postinst_sources

	ewarn "IMPORTANT:"
	ewarn "This is a experimental kernel version, I'm not responsible for breaking your system"
	ewarn "ALWAYS keep a second stable and bootable kernel apart in your boot manager"
}

