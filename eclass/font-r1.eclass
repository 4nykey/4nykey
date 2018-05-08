# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: font-r1.eclass
# @MAINTAINER:
# fonts@gentoo.org
# @BLURB: Eclass to make font installation uniform

[[ ${EAPI} -lt 6 ]] && inherit eutils

EXPORT_FUNCTIONS pkg_setup src_install pkg_postinst pkg_postrm

# @ECLASS-VARIABLE: MY_FONT_TYPES
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of font formats available for install.
MY_FONT_TYPES=( ${MY_FONT_TYPES[@]:-} )
MY_FONT_TYPES=( ${MY_FONT_TYPES[@]/#/font_types_} )
MY_FONT_TYPES=( ${MY_FONT_TYPES[@]/font_types_+/+font_types_} )

# @ECLASS-VARIABLE: MY_FONT_VARIANTS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of available font variants.
MY_FONT_VARIANTS=( ${MY_FONT_VARIANTS[@]:-} )
MY_FONT_VARIANTS=( ${MY_FONT_VARIANTS[@]/#/font_variants_} )
MY_FONT_VARIANTS=( ${MY_FONT_VARIANTS[@]/font_variants_+/+font_variants_} )

# @ECLASS-VARIABLE: MY_FONT_CHARS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of available character variations.
MY_FONT_CHARS=( ${MY_FONT_CHARS[@]:-} )
MY_FONT_CHARS=( ${MY_FONT_CHARS[@]/#/font_chars_} )
MY_FONT_CHARS=( ${MY_FONT_CHARS[@]/font_chars_+/+font_chars_} )

# @ECLASS-VARIABLE: FONT_SUFFIX
# @DEFAULT_UNSET
# @DESCRIPTION:
# Space delimited list of font suffixes to install.
FONT_SUFFIX=${FONT_SUFFIX:-}

# @ECLASS-VARIABLE: FONT_S
# @REQUIRED
# @DESCRIPTION:
# An array of directories containing the fonts, ${S} if unset.
FONT_S=( ${FONT_S[@]:-.} )

# @ECLASS-VARIABLE: FONT_PN
# @DESCRIPTION:
# Font name (ie. last part of FONTDIR).
FONT_PN=${FONT_PN:-${PN}}

# @ECLASS-VARIABLE: FONTDIR
# @DESCRIPTION:
# Full path to installation directory.
FONTDIR=${FONTDIR:-/usr/share/fonts/${FONT_PN}}

# @ECLASS-VARIABLE: FONT_CONF
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array containing fontconfig conf files to install.
FONT_CONF=( "" )

# @ECLASS-VARIABLE: DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Space delimited list of docs to install.
# We always install these:
# COPYRIGHT README{,.txt} NEWS AUTHORS BUGS ChangeLog FONTLOG.txt
DOCS=${DOCS:-}

IUSE="
X
${MY_FONT_TYPES[@]}
${MY_FONT_VARIANTS[@]}
${MY_FONT_CHARS[@]}
"
[[ ${#MY_FONT_TYPES[@]} -ge 1 ]] && REQUIRED_USE="|| ( ${MY_FONT_TYPES[@]/+} )"

DEPEND="
	X? (
		x11-apps/mkfontdir
		media-fonts/encodings
	)
	sys-apps/findutils
"
RDEPEND=""
RESTRICT+=" strip binchecks"

# @FUNCTION: font-r1_xfont_config
# @DESCRIPTION:
# Generate Xorg font files (mkfontscale/mkfontdir).
font-r1_xfont_config() {
	local dir_name
	if has X ${IUSE//+} && use X ; then
		dir_name="${1:-${FONT_PN}}"
		ebegin "Creating fonts.scale & fonts.dir in ${dir_name##*/}"
		rm -f "${ED}${FONTDIR}/${1//${S}/}"/{fonts.{dir,scale},encodings.dir}
		mkfontscale "${ED}${FONTDIR}/${1//${S}/}"
		mkfontdir \
			-e ${EPREFIX}/usr/share/fonts/encodings \
			-e ${EPREFIX}/usr/share/fonts/encodings/large \
			"${ED}${FONTDIR}/${1//${S}/}"
		eend $?
		if [[ -e fonts.alias ]] ; then
			doins fonts.alias
		fi
	fi
}

# @FUNCTION: font-r1_fontconfig
# @DESCRIPTION:
# Install fontconfig conf files given in FONT_CONF.
font-r1_fontconfig() {
	local conffile
	if [[ -n ${FONT_CONF[@]} ]]; then
		insinto /etc/fonts/conf.avail/
		for conffile in "${FONT_CONF[@]}"; do
			[[ -e ${conffile} ]] && doins ${conffile}
		done
	fi
}

# @FUNCTION: font-r1_pkg_setup
# @DESCRIPTION:
# The font pkg_setup function.
# Collision protection and Prefix compat for eapi < 3.
font-r1_pkg_setup() {
	# Prefix compat
	case ${EAPI:-0} in
		0|1|2)
			if ! use prefix; then
				EPREFIX=
				ED=${D}
				EROOT=${ROOT}
				[[ ${EROOT} = */ ]] || EROOT+="/"
			fi
			;;
	esac

	# make sure we get no collisions
	# setup is not the nicest place, but preinst doesn't cut it
	[[ -e "${EROOT}/${FONTDIR}/fonts.cache-1" ]] && rm -f "${EROOT}/${FONTDIR}/fonts.cache-1"

	local _t
	for _t in ${MY_FONT_TYPES[@]/*_}; do
		use font_types_${_t} && FONT_SUFFIX+=" ${_t}"
	done
	FONT_SUFFIX=${FONT_SUFFIX:-ttf}
}

# @FUNCTION: font-r1_font_install
# @DESCRIPTION:
# The main font install function.
font-r1_font_install() {
	local _s

	insinto "${FONTDIR}"

	for _s in ${FONT_SUFFIX}; do
		find "${FONT_S[@]}" -mindepth 1 -maxdepth 1 -! -size 0 -type f \
			-ipath "*.${_s}" -exec doins {} + 2>/dev/null

		find "${ED}${FONTDIR}" -mindepth 1 -maxdepth 1 -! -size 0 -type f \
			-ipath "*.${_s}" -exec false {} + && die \
			"No ${_s} fonts were installed in ${FONTDIR}"
	done
}

# @FUNCTION: font-r1_src_install
# @DESCRIPTION:
# The font src_install function.
font-r1_src_install() {
	font-r1_font_install
	font-r1_xfont_config
	font-r1_fontconfig

	[[ "$(declare -p DOCS)" =~ "declare -a" ]] || DOCS=( ${DOCS} )
	[[ -n ${DOCS} ]] && { dodoc "${DOCS[@]}" || die "docs installation failed" ; }

	# install common docs
	local commondoc
	for commondoc in \
		COPYRIGHT README{,.txt,.md} HISTORY NEWS AUTHORS{,.txt} BUGS TODO \
		ChangeLog F{ont,ONT}L{og,OG}.txt CONTRIBUTORS{,.txt} relnotes.txt
		do [[ -s ${commondoc} ]] && dodoc ${commondoc}
	done
}

# @FUNCTION: font-r1_pkg_postinst
# @DESCRIPTION:
# The font pkg_postinst function.
font-r1_pkg_postinst() {
	if [[ -n ${FONT_CONF[@]} ]]; then
		local conffile
		echo
		elog "The following fontconfig configuration files have been installed:"
		elog
		for conffile in "${FONT_CONF[@]}"; do
			if [[ -e ${EROOT}etc/fonts/conf.avail/$(basename ${conffile}) ]]; then
				elog "  $(basename ${conffile})"
			fi
		done
		elog
		elog "Use \`eselect fontconfig\` to enable/disable them."
		echo
	fi

	if has_version media-libs/fontconfig && [[ ${ROOT} == / ]]; then
		ebegin "Updating fontconfig cache for ${FONT_PN}"
		fc-cache -s "${EROOT}"usr/share/fonts/${FONT_PN}
		eend $?
	else
		einfo "Skipping cache update (media-libs/fontconfig is not installed or ROOT != /)"
	fi
}

# @FUNCTION: font-r1_pkg_postrm
# @DESCRIPTION:
# The font pkg_postrm function.
font-r1_pkg_postrm() {
	if has_version media-libs/fontconfig && [[ ${ROOT} == / ]]; then
		ebegin "Updating fontconfig cache for ${FONT_PN}"
		fc-cache -s "${EROOT}"usr/share/fonts/${FONT_PN}
		eend $?
	else
		einfo "Skipping cache update (media-libs/fontconfig is not installed or ROOT != /)"
	fi
}
