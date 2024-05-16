# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.code.sf.net/p/mp3gain/code"
else
	MY_MPG="mp3gain-1.6.2"
	SRC_URI="
		mirror://githubcl/mecke/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
		https://downloads.sourceforge.net/${MY_MPG%-*}/${MY_MPG//./_}-src.zip
	"
	KEYWORDS="~amd64 ~x86"
fi

MY_FAA="faad2-2.7"
MY_MP4="mp4v2-1.9.1"
SRC_URI+="
	mirror://gcarchive/mp4v2/${MY_MP4}.tar.bz2
	https://downloads.sourceforge.net/faac/${MY_FAA}.tar.gz
"
RESTRICT="primaryuri"

DESCRIPTION="Normalize perceived loudness of AAC audio files"
HOMEPAGE="http://aacgain.altosdesign.com/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND=""

PATCHES=(
	${PN}/mp4v2.patch
	"${FILESDIR}"/${PN}-1.9-derefptr.patch
	"${FILESDIR}"/${PN}-mp4v2_m4.diff
	"${FILESDIR}"/${PN}-autotools.diff
	"${FILESDIR}"/mp3gain-1.6.2-CVE-2019-18359-plus.patch
)
DOCS="${PN}/README"

src_unpack() {
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_fetch
		git-r3_checkout "${EGIT_REPO_URI}" '' '' ${PN} mp3gain
	fi
	mkdir -p "${S}"/mp3gain
	cd "${S}"/mp3gain
	unpack ${A}
	mv ${MY_MP4} ../${MY_MP4%-*}
	mv ${MY_FAA} ../${MY_FAA%-*}
	[[ -d ${P} ]] && mv ${P} ../${PN}
}

src_prepare() {
	default
	mv -f faad2/configure.{in,ac}
	cp ${PN}/linux/Makefile.am.mp3gain mp3gain/Makefile.am
	cp ${PN}/linux/Makefile.am.topsrcdir Makefile.am
	cp ${PN}/linux/configure.ac .
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-shared
		--enable-static
		--without-xmms
		--without-mpeg4ip
		--disable-util
		--disable-gch
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	dobin ${PN}/${PN}
	einstalldocs
}

pkg_postinst() {
	ewarn
	ewarn "BACK UP YOUR MUSIC FILES BEFORE USING AACGAIN!"
	ewarn "THIS IS EXPERIMENTAL SOFTWARE. THERE HAVE BEEN"
	ewarn "BUGS IN PAST RELEASES THAT CORRUPTED MUSIC FILES."
	ewarn
}
