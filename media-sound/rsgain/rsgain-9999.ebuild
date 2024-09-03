# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/complexlogic/${PN}.git"
else
	MY_PV="5697031"
	if [[ -n ${PV%%*_p*} ]]; then
		MY_PV="v${PV}"
		SRC_URI="
			https://github.com/complexlogic/${PN}/releases/download/${MY_PV}/${P}-source.tar.xz
		"
	else
		SRC_URI="
			mirror://githubcl/complexlogic/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		"
	fi
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="ReplayGain 2.0 loudness normalizer"
HOMEPAGE="https://github.com/complexlogic/${PN}"

LICENSE="BSD-2"
SLOT="0"
IUSE="std_format"

RDEPEND="
	media-video/ffmpeg:=
	media-libs/taglib
	media-libs/libebur128
	dev-libs/inih
	!std_format? ( dev-libs/libfmt:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

pkg_pretend() {
	use std_format || return
	if [[ $(tc-get-cxx-stdlib) == libc++ ]]; then
		if ver_test $(clang-version) -lt 18; then
			die "clang-18 and up is required for std_format"
		fi
	else
		if ver_test $(gcc-version) -lt 14; then
			die "gcc-14 and up is required for std_format"
		fi
	fi
}

src_configure() {
	local mycmakeargs=(
	-DUSE_STD_FORMAT=$(usex std_format)
	)
	cmake_src_configure
}
