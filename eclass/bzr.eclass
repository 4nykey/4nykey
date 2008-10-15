# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# @ECLASS: bzr.eclass
# @MAINTAINER:
# Jorge Manuel B. S. Vicetto <jmbsvicetto>@gentoo.org
# @BLURB: This eclass provides support to use the Bazaar DSCM
# @DESCRIPTION:
# The bzr.eclass provides support for apps using the bazaar DSCM (distributed source control management system).
# The eclass was originally derived from the git eclass.
#
# Note: Just set EBZR_REPO_URI to the url of the branch and the src_unpack
# this eclass provides will put an export of the branch in ${WORKDIR}/${PN}.

inherit eutils

EBZR="bzr.eclass"

EXPORT_FUNCTIONS src_unpack

HOMEPAGE="http://bazaar-vcs.org/"
DESCRIPTION="Based on the ${EBZR} eclass"

DEPEND=">=dev-util/bzr-0.92"

# @ECLASS-VARIABLE: EBZR_STORE_DIR
# @DESCRIPTION:
# The dir to store the bzr sources.
EBZR_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/bzr-src"

# @ECLASS-VARIABLE: EBZR_FETCH_CMD
# @DESCRIPTION:
# The bzr command to fetch the sources.
EBZR_FETCH_CMD="bzr branch"

# @ECLASS-VARIABLE: EBZR_UPDATE_CMD
# @DESCRIPTION:
# The bzr command to update the sources.
EBZR_UPDATE_CMD="bzr pull"

# @ECLASS-VARIABLE: EBZR_DIFFSTAT_CMD
# @DESCRIPTION:
# The bzr command to get the diffstat output.
EBZR_DIFFSTAT_CMD="bzr diff"

# @ECLASS-VARIABLE: EBZR_EXPORT_CMD
# @DESCRIPTION:
# The bzr command to export a branch.
EBZR_EXPORT_CMD="bzr export"

# @ECLASS-VARIABLE: EBZR_REVNO_CMD
# @DESCRIPTION:
# The bzr command to list revision number of the branch.
EBZR_REVNO_CMD="bzr revno"

# @ECLASS-VARIABLE: EBZR_OPTIONS
# @DESCRIPTION:
# The options passed to the fetch and update commands.
EBZR_OPTIONS="${EBZR_OPTIONS:-}"

# @ECLASS-VARIABLE: EBZR_REPO_URI
# @DESCRIPTION:
# The repository uri for the source package.
#
# @CODE
# Supported protocols:
# 		- http://
# 		- https://
# 		- sftp://
# 		- rsync://
# 		- lp://
# @CODE
#
# Note: lp = https://launchpad.net
EBZR_REPO_URI="${EBZR_REPO_URI:-}"

# @ECLASS-VARIABLE: EBZR_BOOTSTRAP
# @DESCRIPTION:
# Bootstrap script or command like autogen.sh or etc.
EBZR_BOOTSTRAP="${EBZR_BOOTSTRAP:-}"

# @ECLASS-VARIABLE: EBZR_PATCHES
# @DESCRIPTION:
# bzr eclass can apply patches in bzr_bootstrap().
# you can use regexp in this valiable like *.diff or *.patch or etc.
# NOTE: this patches will applied before EBZR_BOOTSTRAP is processed.
#
# Patches are searched both in ${PWD} and ${FILESDIR}, if not found in either
# location, the installation dies.
EBZR_PATCHES="${EBZR_PATCHES:-}"

# @ECLASS-VARIABLE: EBZR_BRANCH
# @DESCRIPTION:
# The branch to fetch in bzr_fetch().
#
# default: trunk
EBZR_BRANCH="${EBZR_BRANCH:-trunk}"

# @ECLASS-VARIABLE: EBZR_REVISION
# @DESCRIPTION:
# Revision to get, if not latest (see http://bazaar-vcs.org/BzrRevisionSpec)
EBZR_REVISION="${EBZR_REVISION:-}"

# @ECLASS-VARIABLE: EBZR_CACHE_DIR
# @DESCRIPTION:
# The dir to store the source for the package, relative to EBZR_STORE_DIR.
#
# default: ${PN}
EBZR_CACHE_DIR="${EBZR_CACHE_DIR:-${PN}}"

# @FUNCTION: bzr_fetch
# @DESCRIPTION:
# Wrapper function to fetch sources from bazaar via bzr fetch or bzr update,
# depending on whether there is an existing working copy in ${EBZR_BRANCH_DIR}.
bzr_fetch() {
	local EBZR_BRANCH_DIR

	# EBZR_REPO_URI is empty.
	[[ -z ${EBZR_REPO_URI} ]] && die "${EBZR}: EBZR_REPO_URI is empty."

	# check for the protocol or pull from a local repo.
	if [[ -z ${EBZR_REPO_URI%%:*} ]] ; then
		case ${EBZR_REPO_URI%%:*} in
			# lp:// is https://launchpad.net
			http|https|rsync|sftp|lp)
				;;
			*)
				die "${EBZR}: fetch from ${EBZR_REPO_URI%:*} is not yet implemented."
				;;
		esac
	fi

	if [[ ! -d ${EBZR_STORE_DIR} ]] ; then
		debug-print "${FUNCNAME}: initial branch. creating bzr directory"
		addwrite /
		mkdir -p "${EBZR_STORE_DIR}" \
			|| die "${EBZR}: can't mkdir ${EBZR_STORE_DIR}."
		chmod -f o+rw "${EBZR_STORE_DIR}" \
			|| die "${EBZR}: can't chmod ${EBZR_STORE_DIR}."
		export SANDBOX_WRITE="${SANDBOX_WRITE%%:/}"
	fi

	cd -P "${EBZR_STORE_DIR}" || die "${EBZR}: can't chdir to ${EBZR_STORE_DIR}"

	EBZR_BRANCH_DIR="${EBZR_STORE_DIR}/${EBZR_CACHE_DIR}"

	addwrite "${EBZR_STORE_DIR}"
	addwrite "${EBZR_BRANCH_DIR}"

	debug-print "${FUNCNAME}: EBZR_OPTIONS = ${EBZR_OPTIONS}"

	local repository

	if [[ ${EBZR_REPO_URI} == */* ]]; then
		repository="${EBZR_REPO_URI}${EBZR_BRANCH}"
	else
		repository="${EBZR_REPO_URI}"
	fi

	if [[ ! -d ${EBZR_BRANCH_DIR} ]] ; then
		# fetch branch
		einfo "bzr branch start -->"
		einfo "   repository: ${repository} => ${EBZR_BRANCH_DIR}"

		${EBZR_FETCH_CMD} ${EBZR_OPTIONS} "${repository}" "${EBZR_BRANCH_DIR}" \
			|| die "${EBZR}: can't branch from ${repository}."

	else
		# update branch
		einfo "bzr pull start -->"
		einfo "   repository: ${repository}"

		cd "${EBZR_BRANCH_DIR}"
		${EBZR_UPDATE_CMD} ${EBZR_OPTIONS} "${repository}" \
			|| die "${EBZR}: can't merge from ${repository}."
		${EBZR_DIFFSTAT_CMD}
	fi

	cd "${EBZR_BRANCH_DIR}"

	einfo "exporting ..."
	${EBZR_EXPORT_CMD} ${EBZR_REVISION:+-r ${EBZR_REVISION}} "${WORKDIR}/${P}" \
			|| die "${EBZR}: export failed"

	local revision
	if [[ -n "${EBZR_REVISION}" ]]; then
		revision="${EBZR_REVISION}"
	else
		revision=$(${EBZR_REVNO_CMD} "${EBZR_BRANCH_DIR}")
	fi

	einfo "Revision ${revision} is now in ${WORKDIR}/${P}"

	cd "${WORKDIR}"
}

# @FUNCTION: bzr_bootstrap
# @DESCRIPTION:
# Apply patches in ${EBZR_PATCHES} and run ${EBZR_BOOTSTRAP} if specified
bzr_bootstrap() {
	local patch lpatch

	cd "${S}"

	if [[ -n ${EBZR_PATCHES} ]] ; then
		einfo "apply patches -->"

		for patch in ${EBZR_PATCHES} ; do
			if [[ -f ${patch} ]] ; then
				epatch ${patch}
			else
				for lpatch in "${FILESDIR}"/${patch} ; do
					if [[ -f ${lpatch} ]] ; then
						epatch ${lpatch}
					else
						die "${EBZR}: ${patch} is not found"
					fi
				done
			fi
		done
		echo
	fi

	if [[ -n ${EBZR_BOOTSTRAP} ]] ; then
		einfo "begin bootstrap -->"

		if [[ -f ${EBZR_BOOTSTRAP} ]] && [[ -x ${EBZR_BOOTSTRAP} ]] ; then
			einfo "   bootstrap with a file: ${EBZR_BOOTSTRAP}"
			"./${EBZR_BOOTSTRAP}" \
				|| die "${EBZR}: can't execute EBZR_BOOTSTRAP."
		else
			einfo "   bootstrap with commands: ${EBZR_BOOTSTRAP}"
			"${EBZR_BOOTSTRAP}" \
				|| die "${EBZR}: can't eval EBZR_BOOTSTRAP."
		fi
	fi
}

# @FUNCTION: bzr_src_unpack
# @DESCRIPTION:
# default src_unpack. fetch and bootstrap.
bzr_src_unpack() {
	bzr_fetch || die "${EBZR}: unknown problem in bzr_fetch()."
	bzr_bootstrap || die "${EBZR}: unknown problem in bzr_bootstrap()."
}

