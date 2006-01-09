# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial eclass by Ycarus. For new version look here :
# http://gentoo.zugaina.org/
# This is a modified version of the subversion eclass

## --------------------------------------------------------------------------- #
# Author: Ycarus <ycarus@zugaina.org>
# 
# The git eclass is written to fetch the software sources from
# git repositories like the cvs eclass.
#
#
# Description:
#   If you use this eclass, the ${S} is ${WORKDIR}/${P}.
#   It is necessary to define the EGIT_REPO_URI variables at least.
#
## --------------------------------------------------------------------------- #

inherit eutils

ECLASS="git"
INHERITED="${INHERITED} ${ECLASS}"
EGIT="git.eclass"

EXPORT_FUNCTIONS src_unpack

HOMEPAGE="http://kernel.org/pub/software/scm/git/"
DESCRIPTION="GIT eclass"


## -- add cogito in DEPEND
#
DEPEND="dev-util/cogito"


## -- EGIT_STORE_DIR:  git sources store directory
#
EGIT_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/git-src"


## -- EGIT_FETCH_CMD:  git fetch command
#
# default: git checkout
#
[ -z "${EGIT_FETCH_CMD}" ]  && EGIT_FETCH_CMD="cg-clone"
[ -z "${EGIT_UPDATE_CMD}" ]  && EGIT_UPDATE_CMD="cg-update"


## -- EGIT_REPO_URI:  repository uri
#
[ -z "${EGIT_REPO_URI}" ]  && EGIT_REPO_URI=""


## -- EGIT_PROJECT:  project name of your ebuild
#
# git eclass will check out the git repository like:
#
#   ${EGIT_STORE_DIR}/${EGIT_PROJECT}/${EGIT_REPO_URI##*/}
#
#
# default: ${PN/-git}.
#
[ -z "${EGIT_PROJECT}" ] && EGIT_PROJECT="${PN/-git/}"


## -- EGIT_PATCHES:
#
# git eclass can apply pathces in git_fetch().
# you can use regexp in this valiable like *.diff or *.patch or etc.
# NOTE: this patches will apply before eval ESVN_BOOTSTRAP.
#
# the process of applying the patch is:
#   1. just epatch it, if the patch exists in the path.
#   2. scan it under FILESDIR and epatch it, if the patch exists in FILESDIR.
#   3. die.
#
[ -z "${EGIT_PATCHES}" ] && EGIT_PATCHES=""


## -- git_fetch() ------------------------------------------------- #

function git_fetch() {
	# EGIT_REPO_URI is empty.
	[ -z "${EGIT_REPO_URI}" ] && die "${EGIT}: EGIT_REPO_URI is empty."
	EGIT_REPO_URI="${EGIT_REPO_URI} ${EGIT_PROJECT}"
	# check for the protocol.
	case ${EGIT_REPO_URI%%:*} in
		rsync)	;;
		ssh)	;;
		*)
			die "${EGITN}: fetch from "${EGIT_REPO_URI%:*}" is not yet
implemented."
			;;
	esac

	if [ ! -d "${EGIT_STORE_DIR}" ]; then
		debug-print "${FUNCNAME}: initial checkout. creating git directory"

		addwrite /
		mkdir -p "${EGIT_STORE_DIR}"      || die "${EGIT}: can't mkdir
${EGIT_STORE_DIR}."
		chmod -f o+rw "${EGIT_STORE_DIR}" || die "${EGIT}: can't chmod
${EGIT_STORE_DIR}."
		export SANDBOX_WRITE="${SANDBOX_WRITE%%:/}"
	fi

	cd -P "${EGIT_STORE_DIR}" || die "${EGIT}: can't chdir to ${EGIT_STORE_DIR}"
	EGIT_STORE_DIR=${PWD}

	# every time
	addwrite "${EGIT_STORE_DIR}"

	[ -z "${EGIT_REPO_URI##*/}" ] && EGIT_REPO_URI="${EGIT_REPO_URI%/}"
	EGIT_CO_DIR="${EGIT_PROJECT}/${EGIT_PROJECT}"
	if [ ! -d "${EGIT_CO_DIR}/.git" ]; then
		# first check out
		einfo "git check out start -->"
		einfo "   checkout from: ${EGIT_REPO_URI}"

		mkdir -p "${EGIT_PROJECT}"      || die "${EGIT}: can't mkdir
${EGIT_PROJECT}."
		chmod -f o+rw "${EGIT_PROJECT}" || die "${EGIT}: can't chmod
${EGIT_PROJECT}."
		cd "${EGIT_PROJECT}"
		${EGIT_FETCH_CMD} ${EGIT_REPO_URI} || die "${EGIT}: can't fetch from
${EGIT_REPO_URI}."

		einfo "   checkouted in: ${EGIT_STORE_DIR}/${EGIT_CO_DIR}"

	else
		# update working copy
		einfo "git update start -->"
		einfo "   update from: ${EGIT_REPO_URI}"
		cd "${EGIT_CO_DIR}"
		${EGIT_UPDATE_CMD} || die "${EGIT}: can't update from ${EGIT_REPO_URI}."
		einfo "    updated in: ${EGIT_STORE_DIR}/${EGIT_CO_DIR}"

	fi

	# copy to the ${WORKDIR}
	cp -Rf "${EGIT_STORE_DIR}/${EGIT_CO_DIR}" "${S}" || die "${EGIT}: can't copy
to ${S}."
	einfo "     copied to: ${S}"
	echo

	local patch lpatch

	cd "${S}"

	if [ "${EGIT_PATCHES}" ]; then
		einfo "apply patches -->"

		for patch in ${EGIT_PATCHES}; do
			if [ -f "${patch}" ]; then
				epatch ${patch}

			else
				for lpatch in ${FILESDIR}/${patch}; do
					if [ -f "${lpatch}" ]; then
						epatch ${lpatch}

					else
						die "${ESVN}; ${patch} is not found"

					fi
				done
			fi
		done
		echo
	fi

}

## -- git_src_unpack() ------------------------------------------------ #

function git_src_unpack() {

	if [ "${A}" != "" ]; then
		unpack ${A}
	fi
	git_fetch || die "${EGIT}: unknown problem in git_fetch()."
}

