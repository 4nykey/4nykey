# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools pax-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://wimlib.net/${PN}"
else
	MY_PV="05fa75f"
	SRC_URI="
		https://wimlib.net/git/?p=${PN};a=snapshot;h=${MY_PV};sf=tgz -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="The open source Windows Imaging (WIM) library"
HOMEPAGE="https://wimlib.net/"

LICENSE="|| ( GPL-3+ LGPL-3+ ) CC0-1.0"
SLOT="0"
IUSE="fuse ntfs static-libs threads test yasm"

RDEPEND="
	dev-libs/libxml2:2
	ntfs? ( sys-fs/ntfs3g )
	fuse? ( sys-fs/fuse:0 )
"
DEPEND="
	${RDEPEND}
"
PATCHES=( "${FILESDIR}"/${PN}-tests.diff )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with ntfs ntfs-3g)
		$(use_with fuse)
		$(use_enable static-libs static)
	)
	use test && myeconfargs+=( --enable-test-support )
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake
	pax-mark m "${S}"/.libs/wimlib-imagex
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete
}
