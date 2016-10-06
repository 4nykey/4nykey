# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

EGIT_REPO_URI="https://github.com/bohoomil/fontconfig-ultimate"
inherit readme.gentoo-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
else
	inherit vcs-snapshot
	SRC_URI="mirror://githubcl/bohoomil/${PN}/tar.gz/${PV//./-} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A set of rendering and font replacement rules for fontconfig-infinality"
HOMEPAGE="http://bohoomil.cu.cc/"

LICENSE="MIT"
SLOT="0"
IUSE="+fonts-ms +fonts-free fonts-extra"

RDEPEND="app-eselect/eselect-infinality
	app-eselect/eselect-lcdfilter
	media-libs/fontconfig-infinality
	media-libs/freetype:2
	fonts-ms? (
		media-fonts/corefonts
		media-fonts/dejavu
		media-fonts/noto
		fonts-extra? (
			media-fonts/cantarell
			media-fonts/droid
			media-fonts/font-bh-75dpi
			media-fonts/paratype
			media-fonts/source-pro
		)
	)
	fonts-free? (
		media-fonts/dejavu
		media-fonts/noto
		media-fonts/liberation-fonts
		media-fonts/heuristica
		fonts-extra? (
			media-fonts/cantarell
			media-fonts/droid
			media-fonts/font-bh-ttf
			media-fonts/libertine
			media-fonts/paratype
			media-fonts/urw-fonts
			media-fonts/symbola
			media-fonts/ubuntu-font-family
		)
	)"

#DISABLE_AUTOFORMATTING="1"
DOC_CONTENTS="
1. Disable all rules but 52-infinality.conf using eselect fontconfig
2. Enable one of \"ultimate\" presets using eselect infinality
"

src_install() {
	local default_configs cfg flv \
		flavors='ms free combi' \
		src='../../conf.src.ultimate' \
		dst='/etc/fonts/infinality/styles.conf.avail/ultimate-'

	insinto /etc/fonts/infinality/conf.src.ultimate
	doins conf.d.infinality/*.conf
	for flv in ${flavors}; do
		doins fontconfig_patches/${flv}/*.conf
	done

	# Cut a list of default .conf files out of Makefile.am
	default_configs=$(sed --quiet \
		-e ':again' \
		-e '/\\$/ N' \
		-e 's/\\\n/ /' \
		-e 't again' \
		-e 's/^CONF_LINKS =//p' \
		conf.d.infinality/Makefile.am) || die

	for flv in ${flavors}; do
		for cfg in ${default_configs} fontconfig_patches/${flv}/*.conf; do
			dosym {${src},${dst}${flv}}/${cfg##*/}
		done
	done

	insinto /etc/fonts/conf.avail
	doins fontconfig_patches/fonts-settings/*.conf

	insinto /usr/share/eselect-lcdfilter/env.d
	newins freetype/infinality-settings.sh ultimate

	dodoc README.md conf.d.infinality/README
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
