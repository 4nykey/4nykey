# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/wxwidgets.eclass,v 1.18 2007/01/02 08:10:31 dirtyepic Exp $
#
# Author Rob Cakebread <pythonhead@gentoo.org>

# This eclass helps you find the correct wx-config script so ebuilds
# can use gtk, gtk2 or gtk2+unicode versions of wxGTK

# FUNCTIONS:
# need-wxwidgets:
#   Arguments:
#     2.4: !!! 2.4 is being removed from the tree !!!
#     2.6+: gtk2 unicode base base-unicode mac mac-unicode
#
#
# set-wxconfig
#   Arguments: gtk-ansi gtk2-ansi unicode base-ansi base-unicode mac-ansi mac-unicode
#   Note: Don't call this function directly from ebuilds

inherit multilib

need-wxwidgets() {
	debug-print-function $FUNCNAME $*
	# We're going to use wxGTK-2.6, if v2.8 isn't installed,
	# or if ebuild explicitly sets WX_GTK_VER to "2.6".
	if ! has_version '>=x11-libs/wxGTK-2.8'; then WX_GTK_VER="2.6"; fi
	WX_GTK_VER="${WX_GTK_VER:-2.8}"
	case $1 in
		gtk2)
			set-wxconfig gtk2-ansi
			;;
		unicode)
			set-wxconfig gtk2-unicode
			;;
		base)
			set-wxconfig base-ansi
			;;
		base-unicode)
			set-wxconfig base-unicode
			;;
		mac)
			set-wxconfig mac-ansi
			;;
		mac-unicode)
			set-wxconfig mac-unicode
			;;
		*)
			echo "!!! $FUNCNAME: Error: wxGTK was not comipled with $1."
			echo "!!! Adjust your USE flags or re-emerge wxGTK with version you want."
			exit 1
			;;
	esac
}

set-wxconfig() {

	debug-print-function $FUNCNAME $*

	wxconfig_prefix="/usr/$(get_libdir)/wx/config"
	wxconfig_name="${1}-release-${WX_GTK_VER}"
	wxconfig="${wxconfig_prefix}/${wxconfig_name}"
	wxconfig_debug_name="${1}-debug-${WX_GTK_VER}"
	wxconfig_debug="${wxconfig_prefix}/${wxconfig_debug_name}"

	WX_CONFIG_PREFIX=${wxconfig_prefix}
	if [ -e ${wxconfig} ] ; then
		WX_CONFIG=${wxconfig}
		WX_CONFIG_NAME=${wxconfig_name}
		WXBASE_CONFIG_NAME=${wxconfig_name}
		echo " * Using ${wxconfig}"
	elif [ -e ${wxconfig_debug} ] ; then
		WX_CONFIG=${wxconfig_debug}
		WX_CONFIG_NAME=${wxconfig_debug_name}
		WXBASE_CONFIG_NAME=${wxconfig_debug_name}
		echo " * Using ${wxconfig_debug}"
	else
		echo "!!! $FUNCNAME: Error:  Can't find normal or debug version:"
		echo "!!! $FUNCNAME:         ${wxconfig} not found"
		echo "!!! $FUNCNAME:         ${wxconfig_debug} not found"
		case $1 in
			gtk2*-unicode)
				echo "!!! You need to emerge wxGTK with unicode in your USE"
				;;
			gtk2*-ansi)
				echo "!!! You need to emerge wxGTK with gtk in your USE"
				;;
		esac
		exit 1
	fi
	export WX_CONFIG WX_CONFIG_NAME WX_CONFIG_PREFIX WXBASE_CONFIG_NAME
}

