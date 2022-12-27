# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FIREFOX_PATCHSET="firefox-102esr-patches-07j.tar.xz"
MY_PV="$(ver_cut 1-2)"
# https://dist.torproject.org/torbrowser
MY_P="102.6.0esr-${MY_PV}-1-build1"
MY_P="firefox-tor-browser-${MY_P}"

LLVM_MAX_SLOT=15

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="ncurses,sqlite,ssl"

WANT_AUTOCONF="2.1"

VIRTUALX_REQUIRED="pgo"

inherit autotools check-reqs desktop flag-o-matic gnome2-utils linux-info \
	llvm multiprocessing pax-utils python-any-r1 toolchain-funcs \
	virtualx xdg

PATCH_URIS=(
	https://dev.gentoo.org/~{juippis,whissi,slashbeast}/mozilla/patchsets/${FIREFOX_PATCHSET}
)

if [[ -z ${PV%%*_alpha*} ]]; then
	MY_PV+="a$(ver_cut 4)"
else
	MY_PV+=".$(ver_cut 3)"
	KEYWORDS="~amd64 ~x86"
fi
MY_PV="${MY_PV%.0}"
MY_NOS="11.4.13"
MY_NOS="noscript-${MY_NOS}.xpi"
SRC_URI="
	mirror://tor/${PN}/${MY_PV}/src-${MY_P}.tar.xz
	https://secure.informaction.com/download/releases/${MY_NOS}
	${PATCH_URIS[@]}
"
RESTRICT="primaryuri"

DESCRIPTION="The Tor Browser"
HOMEPAGE="https://www.torproject.org"

SLOT="0"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
LICENSE+=" BSD CC-BY-3.0"

IUSE="+clang cpu_flags_arm_neon dbus debug eme-free hardened hwaccel"
IUSE+=" jack libproxy lto +openh264 pgo pulseaudio sndio selinux"
IUSE+=" +system-av1 +system-harfbuzz +system-icu +system-jpeg +system-libevent +system-libvpx system-png system-python-libs +system-webp"
IUSE+=" wayland wifi"

REQUIRED_USE="debug? ( !system-av1 )
	pgo? ( lto )
	wayland? ( dbus )
	wifi? ( dbus )"

BDEPEND="${PYTHON_DEPS}
	|| (
		(
			sys-devel/clang:15
			sys-devel/llvm:15
			clang? (
				sys-devel/lld:15
				virtual/rust:0/llvm-15
				pgo? ( =sys-libs/compiler-rt-sanitizers-15*[profile] )
			)
		)
		(
			sys-devel/clang:14
			sys-devel/llvm:14
			clang? (
				sys-devel/lld:14
				virtual/rust:0/llvm-14
				pgo? ( =sys-libs/compiler-rt-sanitizers-14*[profile] )
			)
		)
	)
	!clang? ( virtual/rust )
	app-arch/unzip
	app-arch/zip
	>=dev-util/cbindgen-0.24.3
	net-libs/nodejs
	virtual/pkgconfig
	amd64? ( >=dev-lang/nasm-2.14 )
	x86? ( >=dev-lang/nasm-2.14 )"

COMMON_DEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libffi:=
	>=dev-libs/nss-3.79.2
	>=dev-libs/nspr-4.34
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/mesa
	media-video/ffmpeg
	sys-libs/zlib
	virtual/freedesktop-icon-theme
	virtual/opengl
	x11-libs/cairo[X]
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3[X]
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXtst
	x11-libs/libxcb:=
	x11-libs/libxkbcommon[X]
	x11-libs/pango
	x11-libs/pixman
	dbus? (
		dev-libs/dbus-glib
		sys-apps/dbus
	)
	jack? ( virtual/jack )
	libproxy? ( net-libs/libproxy )
	sndio? ( >=media-sound/sndio-1.8.0-r1 )
	system-av1? (
		>=media-libs/dav1d-1.0.0:=
		>=media-libs/libaom-1.0.0:=
	)
	system-harfbuzz? (
		>=media-gfx/graphite2-1.3.13
		>=media-libs/harfbuzz-2.8.1:0=
	)
	system-icu? ( >=dev-libs/icu-71.1:= )
	system-jpeg? ( >=media-libs/libjpeg-turbo-1.2.1 )
	system-libevent? ( >=dev-libs/libevent-2.1.12:0=[threads] )
	system-libvpx? ( >=media-libs/libvpx-1.8.2:0=[postproc] )
	system-png? ( >=media-libs/libpng-1.6.35:0=[apng] )
	system-webp? ( >=media-libs/libwebp-1.1.0:0= )
	wayland? (
		x11-libs/gtk+:3[wayland]
		x11-libs/libdrm
		x11-libs/libxkbcommon[wayland]
	)
	wifi? (
		kernel_linux? (
			dev-libs/dbus-glib
			net-misc/networkmanager
			sys-apps/dbus
		)
	)"

RDEPEND="${COMMON_DEPEND}
	jack? ( virtual/jack )
	openh264? ( media-libs/openh264:*[plugin] )
	pulseaudio? (
		|| (
			media-sound/pulseaudio
			>=media-sound/apulse-0.1.12-r4
		)
	)"

DEPEND="${COMMON_DEPEND}
	x11-libs/libICE
	x11-libs/libSM
	pulseaudio? (
		|| (
			media-sound/pulseaudio
			>=media-sound/apulse-0.1.12-r4[sdk]
		)
	)"
RDEPEND+="
	net-vpn/tor
"

S="${WORKDIR}/${MY_P}"

llvm_check_deps() {
	if ! has_version -b "sys-devel/clang:${LLVM_SLOT}" ; then
		einfo "sys-devel/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
		return 1
	fi

	if use clang ; then
		if ! has_version -b "sys-devel/lld:${LLVM_SLOT}" ; then
			einfo "sys-devel/lld:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi

		if ! has_version -b "virtual/rust:0/llvm-${LLVM_SLOT}" ; then
			einfo "virtual/rust:0/llvm-${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
			return 1
		fi

		if use pgo ; then
			if ! has_version -b "=sys-libs/compiler-rt-sanitizers-${LLVM_SLOT}*[profile]" ; then
				einfo "=sys-libs/compiler-rt-sanitizers-${LLVM_SLOT}*[profile] is missing! Cannot use LLVM slot ${LLVM_SLOT} ..." >&2
				return 1
			fi
		fi
	fi

	einfo "Using LLVM slot ${LLVM_SLOT} to build" >&2
}

moz_clear_vendor_checksums() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -ne 1 ]] ; then
		die "${FUNCNAME} requires exact one argument"
	fi

	einfo "Clearing cargo checksums for ${1} ..."

	sed -i \
		-e 's/\("files":{\)[^}]*/\1/' \
		"${S}"/third_party/rust/${1}/.cargo-checksum.json \
		|| die
}

mozconfig_add_options_ac() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 2 ]] ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local reason=${1}
	shift

	local option
	for option in ${@} ; do
		echo "ac_add_options ${option} # ${reason}" >>${MOZCONFIG}
	done
}

mozconfig_add_options_mk() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 2 ]] ; then
		die "${FUNCNAME} requires at least two arguments"
	fi

	local reason=${1}
	shift

	local option
	for option in ${@} ; do
		echo "mk_add_options ${option} # ${reason}" >>${MOZCONFIG}
	done
}

mozconfig_use_enable() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 1 ]] ; then
		die "${FUNCNAME} requires at least one arguments"
	fi

	local flag=$(use_enable "${@}")
	mozconfig_add_options_ac "$(use ${1} && echo +${1} || echo -${1})" "${flag}"
}

mozconfig_use_with() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${#} -lt 1 ]] ; then
		die "${FUNCNAME} requires at least one arguments"
	fi

	local flag=$(use_with "${@}")
	mozconfig_add_options_ac "$(use ${1} && echo +${1} || echo -${1})" "${flag}"
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		if use pgo ; then
			if ! has usersandbox $FEATURES ; then
				die "You must enable usersandbox as X server can not run as root!"
			fi
		fi

		# Ensure we have enough disk space to compile
		if use pgo || use lto || use debug ; then
			CHECKREQS_DISK_BUILD="13500M"
		else
			CHECKREQS_DISK_BUILD="6600M"
		fi

		check-reqs_pkg_pretend
	fi
}

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] ; then
		if use pgo ; then
			if ! has userpriv ${FEATURES} ; then
				eerror "Building ${PN} with USE=pgo and FEATURES=-userpriv is not supported!"
			fi
		fi

		# Ensure we have enough disk space to compile
		if use pgo || use lto || use debug ; then
			CHECKREQS_DISK_BUILD="13500M"
		else
			CHECKREQS_DISK_BUILD="6400M"
		fi

		check-reqs_pkg_setup

		llvm_pkg_setup

		if use clang && use lto ; then
			local version_lld=$(ld.lld --version 2>/dev/null | awk '{ print $2 }')
			[[ -n ${version_lld} ]] && version_lld=$(ver_cut 1 "${version_lld}")
			[[ -z ${version_lld} ]] && die "Failed to read ld.lld version!"

			local version_llvm_rust=$(rustc -Vv 2>/dev/null | grep -F -- 'LLVM version:' | awk '{ print $3 }')
			[[ -n ${version_llvm_rust} ]] && version_llvm_rust=$(ver_cut 1 "${version_llvm_rust}")
			[[ -z ${version_llvm_rust} ]] && die "Failed to read used LLVM version from rustc!"

			if ver_test "${version_lld}" -ne "${version_llvm_rust}" ; then
				eerror "Rust is using LLVM version ${version_llvm_rust} but ld.lld version belongs to LLVM version ${version_lld}."
				eerror "You will be unable to link ${CATEGORY}/${PN}. To proceed you have the following options:"
				eerror "  - Manually switch rust version using 'eselect rust' to match used LLVM version"
				eerror "  - Switch to dev-lang/rust[system-llvm] which will guarantee matching version"
				eerror "  - Build ${CATEGORY}/${PN} without USE=lto"
				eerror "  - Rebuild lld with llvm that was used to build rust (may need to rebuild the whole "
				eerror "    llvm/clang/lld/rust chain depending on your @world updates)"
				die "LLVM version used by Rust (${version_llvm_rust}) does not match with ld.lld version (${version_lld})!"
			fi
		fi

		python-any-r1_pkg_setup

		# Avoid PGO profiling problems due to enviroment leakage
		# These should *always* be cleaned up anyway
		unset \
			DBUS_SESSION_BUS_ADDRESS \
			DISPLAY \
			ORBIT_SOCKETDIR \
			SESSION_MANAGER \
			XAUTHORITY \
			XDG_CACHE_HOME \
			XDG_SESSION_COOKIE

		# Build system is using /proc/self/oom_score_adj, bug #604394
		addpredict /proc/self/oom_score_adj

		if use pgo ; then
			# Allow access to GPU during PGO run
			local ati_cards mesa_cards nvidia_cards render_cards
			shopt -s nullglob

			ati_cards=$(echo -n /dev/ati/card* | sed 's/ /:/g')
			if [[ -n "${ati_cards}" ]] ; then
				addpredict "${ati_cards}"
			fi

			mesa_cards=$(echo -n /dev/dri/card* | sed 's/ /:/g')
			if [[ -n "${mesa_cards}" ]] ; then
				addpredict "${mesa_cards}"
			fi

			nvidia_cards=$(echo -n /dev/nvidia* | sed 's/ /:/g')
			if [[ -n "${nvidia_cards}" ]] ; then
				addpredict "${nvidia_cards}"
			fi

			render_cards=$(echo -n /dev/dri/renderD128* | sed 's/ /:/g')
			if [[ -n "${render_cards}" ]] ; then
				addpredict "${render_cards}"
			fi

			shopt -u nullglob
		fi

		if ! mountpoint -q /dev/shm ; then
			# If /dev/shm is not available, configure is known to fail with
			# a traceback report referencing /usr/lib/pythonN.N/multiprocessing/synchronize.py
			ewarn "/dev/shm is not mounted -- expect build failures!"
		fi

		# Ensure we use C locale when building, bug #746215
		export LC_ALL=C
	fi

	CONFIG_CHECK="~SECCOMP"
	WARNING_SECCOMP="CONFIG_SECCOMP not set! This system will be unable to play DRM-protected content."
	linux-info_pkg_setup
}

src_prepare() {
	if use lto; then
		rm -v "${WORKDIR}"/firefox-patches/*-LTO-Only-enable-LTO-*.patch || die
	fi

	eapply "${WORKDIR}/firefox-patches"

	# Allow user to apply any additional patches without modifing ebuild
	eapply_user

	# Make cargo respect MAKEOPTS
	export CARGO_BUILD_JOBS="$(makeopts_jobs)"

	append-cppflags "-DTOR_BROWSER_DATA_IN_HOME_DIR"
	eapply "${FILESDIR}"/${PN}11.5-profiledir.patch

	sed -e '/new-identity-button/d' -i browser/components/customizableui/CustomizableUI.jsm

	# Make LTO respect MAKEOPTS
	sed -i \
		-e "s/multiprocessing.cpu_count()/$(makeopts_jobs)/" \
		"${S}"/build/moz.configure/lto-pgo.configure \
		|| die "sed failed to set num_cores"

	# Make ICU respect MAKEOPTS
	sed -i \
		-e "s/multiprocessing.cpu_count()/$(makeopts_jobs)/" \
		"${S}"/intl/icu_sources_data.py \
		|| die "sed failed to set num_cores"

	# sed-in toolchain prefix
	sed -i \
		-e "s/objdump/${CHOST}-objdump/" \
		"${S}"/python/mozbuild/mozbuild/configure/check_debug_ranges.py \
		|| die "sed failed to set toolchain prefix"

	sed -i \
		-e 's/ccache_stats = None/return None/' \
		"${S}"/python/mozbuild/mozbuild/controller/building.py \
		|| die "sed failed to disable ccache stats call"

	einfo "Removing pre-built binaries ..."
	find "${S}"/third_party -type f \( -name '*.so' -o -name '*.o' \) -print -delete || die

	# Clearing crate checksums where we have applied patches
	moz_clear_vendor_checksums bindgen

	# Create build dir
	BUILD_DIR="${WORKDIR}/${PN}_build"
	mkdir -p "${BUILD_DIR}" || die

	xdg_environment_reset
}

src_configure() {
	# Show flags set at the beginning
	einfo "Current BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
	einfo "Current CFLAGS:\t\t${CFLAGS:-no value set}"
	einfo "Current CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
	einfo "Current LDFLAGS:\t\t${LDFLAGS:-no value set}"
	einfo "Current RUSTFLAGS:\t\t${RUSTFLAGS:-no value set}"

	local have_switched_compiler=
	if use clang; then
		# Force clang
		einfo "Enforcing the use of clang due to USE=clang ..."
		if tc-is-gcc; then
			have_switched_compiler=yes
		fi
		AR=llvm-ar
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		NM=llvm-nm
		RANLIB=llvm-ranlib
	elif ! use clang && ! tc-is-gcc ; then
		# Force gcc
		have_switched_compiler=yes
		einfo "Enforcing the use of gcc due to USE=-clang ..."
		AR=gcc-ar
		CC=${CHOST}-gcc
		CXX=${CHOST}-g++
		NM=gcc-nm
		RANLIB=gcc-ranlib
	fi

	if [[ -n "${have_switched_compiler}" ]] ; then
		# Because we switched active compiler we have to ensure
		# that no unsupported flags are set
		strip-unsupported-flags
	fi

	# Ensure we use correct toolchain
	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"
	export AS="$(tc-getCC) -c"
	tc-export CC CXX LD AR AS NM OBJDUMP RANLIB PKG_CONFIG

	# Pass the correct toolchain paths through cbindgen
	if tc-is-cross-compiler ; then
		export BINDGEN_CFLAGS="${SYSROOT:+--sysroot=${ESYSROOT}} --target=${CHOST} ${BINDGEN_CFLAGS-}"
	fi

	# Set MOZILLA_FIVE_HOME
	export MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	# python/mach/mach/mixin/process.py fails to detect SHELL
	export SHELL="${EPREFIX}/bin/bash"

	# Set state path
	export MOZBUILD_STATE_PATH="${BUILD_DIR}"

	# Set MOZCONFIG
	export MOZCONFIG="${S}/.mozconfig"

	# Initialize MOZCONFIG
	mozconfig_add_options_ac '' --enable-application=browser

	# Set Gentoo defaults
	export MOZILLA_OFFICIAL=1

	mozconfig_add_options_ac 'Gentoo default' \
		--allow-addon-sideload \
		--disable-cargo-incremental \
		--disable-crashreporter \
		--disable-gpsd \
		--disable-install-strip \
		--disable-parental-controls \
		--disable-strip \
		--disable-updater \
		--enable-negotiateauth \
		--enable-new-pass-manager \
		--enable-official-branding \
		--enable-release \
		--enable-system-ffi \
		--enable-system-pixman \
		--host="${CBUILD:-${CHOST}}" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--prefix="${EPREFIX}/usr" \
		--target="${CHOST}" \
		--without-ccache \
		--without-wasm-sandboxed-libraries \
		--with-intl-api \
		--with-libclang-path="$(llvm-config --libdir)" \
		--with-system-nspr \
		--with-system-nss \
		--with-system-zlib \
		--with-toolchain-prefix="${CHOST}-" \
		--with-unsigned-addon-scopes=app,system \
		--x-includes="${ESYSROOT}/usr/include" \
		--x-libraries="${ESYSROOT}/usr/$(get_libdir)"

	# Set update channel
	local update_channel=release
	[[ -n ${MOZ_ESR} ]] && update_channel=esr
	mozconfig_add_options_ac '' --update-channel=${update_channel}

	if [[ -s "${S}/api-mozilla.key" ]] ; then
		local key_origin="Gentoo default"
		if [[ $(cat "${S}/api-mozilla.key" | md5sum | awk '{ print $1 }') != 3927726e9442a8e8fa0e46ccc39caa27 ]] ; then
			key_origin="User value"
		fi

		mozconfig_add_options_ac "${key_origin}" \
			--with-mozilla-api-keyfile="${S}/api-mozilla.key"
	else
		einfo "Building without Mozilla API key ..."
	fi

	mozconfig_use_with system-av1
	mozconfig_use_with system-harfbuzz
	mozconfig_use_with system-harfbuzz system-graphite2
	mozconfig_use_with system-icu
	mozconfig_use_with system-jpeg
	mozconfig_use_with system-libevent
	mozconfig_use_with system-libvpx
	mozconfig_use_with system-png
	mozconfig_use_with system-webp

	mozconfig_use_enable dbus
	mozconfig_use_enable libproxy

	use eme-free && mozconfig_add_options_ac '+eme-free' --disable-eme

	if use hardened ; then
		mozconfig_add_options_ac "+hardened" --enable-hardening
		append-ldflags "-Wl,-z,relro -Wl,-z,now"
	fi

	local myaudiobackends=""
	use jack && myaudiobackends+="jack,"
	use sndio && myaudiobackends+="sndio,"
	use pulseaudio && myaudiobackends+="pulseaudio,"
	! use pulseaudio && myaudiobackends+="alsa,"

	mozconfig_add_options_ac '--enable-audio-backends' --enable-audio-backends="${myaudiobackends::-1}"

	mozconfig_use_enable wifi necko-wifi

	if use wayland ; then
		mozconfig_add_options_ac '+x11+wayland' --enable-default-toolkit=cairo-gtk3-x11-wayland
	else
		mozconfig_add_options_ac '+x11' --enable-default-toolkit=cairo-gtk3
	fi

	if use lto ; then
		if use clang ; then
			# Upstream only supports lld when using clang
			mozconfig_add_options_ac "forcing ld=lld due to USE=clang and USE=lto" --enable-linker=lld

			mozconfig_add_options_ac '+lto' --enable-lto=cross

		else
			# ThinLTO is currently broken, see bmo#1644409
			mozconfig_add_options_ac '+lto' --enable-lto=full
			mozconfig_add_options_ac "linker is set to bfd" --enable-linker=bfd
		fi

		if use pgo ; then
			mozconfig_add_options_ac '+pgo' MOZ_PGO=1

			if use clang ; then
				# Used in build/pgo/profileserver.py
				export LLVM_PROFDATA="llvm-profdata"
			fi
		fi
	else
		# Avoid auto-magic on linker
		if use clang ; then
			# This is upstream's default
			mozconfig_add_options_ac "forcing ld=lld due to USE=clang" --enable-linker=lld
		else
			mozconfig_add_options_ac "linker is set to bfd" --enable-linker=bfd
		fi
	fi

	# LTO flag was handled via configure
	filter-flags '-flto*'

	mozconfig_use_enable debug
	if use debug ; then
		mozconfig_add_options_ac '+debug' --disable-optimize
	else
		if is-flag '-g*' ; then
			if use clang ; then
				mozconfig_add_options_ac 'from CFLAGS' --enable-debug-symbols=$(get-flag '-g*')
			else
				mozconfig_add_options_ac 'from CFLAGS' --enable-debug-symbols
			fi
		else
			mozconfig_add_options_ac 'Gentoo default' --disable-debug-symbols
		fi

		if is-flag '-O0' ; then
			mozconfig_add_options_ac "from CFLAGS" --enable-optimize=-O0
		elif is-flag '-O4' ; then
			mozconfig_add_options_ac "from CFLAGS" --enable-optimize=-O4
		elif is-flag '-O3' ; then
			mozconfig_add_options_ac "from CFLAGS" --enable-optimize=-O3
		elif is-flag '-O1' ; then
			mozconfig_add_options_ac "from CFLAGS" --enable-optimize=-O1
		elif is-flag '-Os' ; then
			mozconfig_add_options_ac "from CFLAGS" --enable-optimize=-Os
		else
			mozconfig_add_options_ac "Gentoo default" --enable-optimize=-O2
		fi
	fi

	# Debug flag was handled via configure
	filter-flags '-g*'

	# Optimization flag was handled via configure
	filter-flags '-O*'

	# Modifications to better support ARM, bug #553364
	if use cpu_flags_arm_neon ; then
		mozconfig_add_options_ac '+cpu_flags_arm_neon' --with-fpu=neon

		if ! tc-is-clang ; then
			# thumb options aren't supported when using clang, bug 666966
			mozconfig_add_options_ac '+cpu_flags_arm_neon' \
				--with-thumb=yes \
				--with-thumb-interwork=no
		fi
	fi

	if use clang ; then
		# https://bugzilla.mozilla.org/show_bug.cgi?id=1482204
		# https://bugzilla.mozilla.org/show_bug.cgi?id=1483822
		# toolkit/moz.configure Elfhack section: target.cpu in ('arm', 'x86', 'x86_64')
		local disable_elf_hack=
		if use amd64 ; then
			disable_elf_hack=yes
		elif use x86 ; then
			disable_elf_hack=yes
		elif use arm ; then
			disable_elf_hack=yes
		fi

		if [[ -n ${disable_elf_hack} ]] ; then
			mozconfig_add_options_ac 'elf-hack is broken when using Clang' --disable-elf-hack
		fi
	elif tc-is-gcc ; then
		if ver_test $(gcc-fullversion) -ge 10 ; then
			einfo "Forcing -fno-tree-loop-vectorize to workaround GCC bug, see bug 758446 ..."
			append-cxxflags -fno-tree-loop-vectorize
		fi
	fi

	if ! use elibc_glibc ; then
		mozconfig_add_options_ac '!elibc_glibc' --disable-jemalloc
	fi

	# Allow elfhack to work in combination with unstripped binaries
	# when they would normally be larger than 2GiB.
	append-ldflags "-Wl,--compress-debug-sections=zlib"

	# Make revdep-rebuild.sh happy; Also required for musl
	append-ldflags -Wl,-rpath="${MOZILLA_FIVE_HOME}",--enable-new-dtags

	# Pass $MAKEOPTS to build system
	export MOZ_MAKE_FLAGS="${MAKEOPTS}"

	# Rename the install directory and the executable
	mozconfig_add_options_ac 'torbrowser' --with-app-name=${PN}
	mozconfig_add_options_ac 'torbrowser' --with-app-basename=${PN}
	mozconfig_add_options_ac 'torbrowser' --disable-tor-browser-update
	mozconfig_add_options_ac 'torbrowser' --with-tor-browser-version=${MY_PV}
	mozconfig_add_options_ac 'torbrowser' --enable-tor-browser-data-outside-app-dir
	mozconfig_add_options_ac 'torbrowser' --with-branding=browser/branding/official
	mozconfig_add_options_ac 'torbrowser' --disable-webrtc
	mozconfig_add_options_ac 'torbrowser' --enable-sandbox

	# Use system's Python environment
	export PIP_NETWORK_INSTALL_RESTRICTED_VIRTUALENVS=mach

	if use system-python-libs; then
		export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE="system"
	else
		export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE="none"
	fi

	# Disable notification when build system has finished
	export MOZ_NOSPAM=1

	# Portage sets XARGS environment variable to "xargs -r" by default which
	# breaks build system's check_prog() function which doesn't support arguments
	mozconfig_add_options_ac 'Gentoo default' "XARGS=${EPREFIX}/usr/bin/xargs"

	# Set build dir
	mozconfig_add_options_mk 'Gentoo default' "MOZ_OBJDIR=${BUILD_DIR}"

	# Show flags we will use
	einfo "Build BINDGEN_CFLAGS:\t${BINDGEN_CFLAGS:-no value set}"
	einfo "Build CFLAGS:\t\t${CFLAGS:-no value set}"
	einfo "Build CXXFLAGS:\t\t${CXXFLAGS:-no value set}"
	einfo "Build LDFLAGS:\t\t${LDFLAGS:-no value set}"
	einfo "Build RUSTFLAGS:\t\t${RUSTFLAGS:-no value set}"

	# Handle EXTRA_CONF and show summary
	local ac opt hash reason

	# Apply EXTRA_ECONF entries to $MOZCONFIG
	if [[ -n ${EXTRA_ECONF} ]] ; then
		IFS=\! read -a ac <<<${EXTRA_ECONF// --/\!}
		for opt in "${ac[@]}"; do
			mozconfig_add_options_ac "EXTRA_ECONF" --${opt#--}
		done
	fi

	echo
	echo "=========================================================="
	echo "Building ${PF} with the following configuration"
	grep ^ac_add_options "${MOZCONFIG}" | while read ac opt hash reason; do
		[[ -z ${hash} || ${hash} == \# ]] \
			|| die "error reading mozconfig: ${ac} ${opt} ${hash} ${reason}"
		printf "    %-30s  %s\n" "${opt}" "${reason:-mozilla.org default}"
	done
	echo "=========================================================="
	echo

	./mach configure || die
}

src_compile() {
	local virtx_cmd=

	if use pgo ; then
		virtx_cmd=virtx

		# Reset and cleanup environment variables used by GNOME/XDG
		gnome2_environment_reset

		addpredict /root
	fi

	local -x GDK_BACKEND=x11

	${virtx_cmd} ./mach build --verbose \
		|| die
}

src_install() {
	# mimic official release
	rm -f "${BUILD_DIR}"/browser/locales/bookmarks.html
	insinto ${MOZILLA_FIVE_HOME}/browser/extensions
	newins "${DISTDIR}"/${MY_NOS} {73a6fe31-595d-460b-a920-fcc0f8843232}.xpi

	# xpcshell is getting called during install
	pax-mark m \
		"${BUILD_DIR}"/dist/bin/xpcshell \
		"${BUILD_DIR}"/dist/bin/${PN} \
		"${BUILD_DIR}"/dist/bin/plugin-container

	DESTDIR="${D}" ./mach install || die

	# Upstream cannot ship symlink but we can (bmo#658850)
	rm "${ED}${MOZILLA_FIVE_HOME}/${PN}-bin" || die
	dosym ${PN} ${MOZILLA_FIVE_HOME}/${PN}-bin

	# Don't install llvm-symbolizer from sys-devel/llvm package
	if [[ -f "${ED}${MOZILLA_FIVE_HOME}/llvm-symbolizer" ]] ; then
		rm -v "${ED}${MOZILLA_FIVE_HOME}/llvm-symbolizer" || die
	fi

	# Install policy (currently only used to disable application updates)
	insinto "${MOZILLA_FIVE_HOME}/distribution"
	newins "${FILESDIR}"/distribution.ini distribution.ini
	newins "${FILESDIR}"/disable-auto-update.policy.json policies.json

	# Install system-wide preferences
	local PREFS_DIR="${MOZILLA_FIVE_HOME}/browser/defaults/preferences"
	insinto "${PREFS_DIR}"
	newins "${FILESDIR}"/gentoo-default-prefs.js gentoo-prefs.js

	local GENTOO_PREFS="${ED}${PREFS_DIR}/gentoo-prefs.js"

	# Set dictionary path to use system hunspell
	cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to set spellchecker.dictionary_path pref"
	pref("spellchecker.dictionary_path",       "${EPREFIX}/usr/share/myspell");
	EOF

	# Force hwaccel prefs if USE=hwaccel is enabled
	if use hwaccel ; then
		cat "${FILESDIR}"/gentoo-hwaccel-prefs.js-r2 \
		>>"${GENTOO_PREFS}" \
		|| die "failed to add prefs to force hardware-accelerated rendering to all-gentoo.js"

		if use wayland; then
			cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to set hwaccel wayland prefs"
			pref("gfx.x11-egl.force-enabled",          false);
			EOF
		else
			cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to set hwaccel x11 prefs"
			pref("gfx.x11-egl.force-enabled",          true);
			EOF
		fi
	fi

	# Force the graphite pref if USE=system-harfbuzz is enabled, since the pref cannot disable it
	if use system-harfbuzz ; then
		cat >>"${GENTOO_PREFS}" <<-EOF || die "failed to set gfx.font_rendering.graphite.enabled pref"
		sticky_pref("gfx.font_rendering.graphite.enabled", true);
		EOF
	fi
	cat >>"${GENTOO_PREFS}" <<-EOF
		pref("extensions.torbutton.local_tor_check", false);
		pref("extensions.torbutton.versioncheck_enabled", false);
		pref("extensions.torlauncher.start_tor", false);
		pref("extensions.torlauncher.prompt_at_startup", false);
		pref("extensions.torlauncher.quickstart", true);
	EOF

	# Install icons
	local icon_srcdir="${S}/browser/branding/official"
	local icon size
	for icon in "${icon_srcdir}"/default*.png ; do
		size=${icon%.png}
		size=${size##*/default}

		if [[ ${size} -eq 48 ]] ; then
			newicon "${icon}" ${PN}.png
		fi

		newicon -s ${size} "${icon}" ${PN}.png
	done
	newicon -s scalable "${icon_srcdir}/firefox.svg" ${PN}.svg

	# Install .desktop for menu entry
	make_desktop_entry ${PN} "Tor Browser" ${PN} "Network;WebBrowser" "StartupWMClass=Torbrowser"
}

pkg_preinst() {
	xdg_pkg_preinst

	# If the apulse libs are available in MOZILLA_FIVE_HOME then apulse
	# does not need to be forced into the LD_LIBRARY_PATH
	if use pulseaudio && has_version ">=media-sound/apulse-0.1.12-r4" ; then
		einfo "APULSE found; Generating library symlinks for sound support ..."
		local lib
		pushd "${ED}${MOZILLA_FIVE_HOME}" &>/dev/null || die
		for lib in ../apulse/libpulse{.so{,.0},-simple.so{,.0}} ; do
			# A quickpkg rolled by hand will grab symlinks as part of the package,
			# so we need to avoid creating them if they already exist.
			if [[ ! -L ${lib##*/} ]] ; then
				ln -s "${lib}" ${lib##*/} || die
			fi
		done
		popd &>/dev/null || die
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	if use pulseaudio && has_version ">=media-sound/apulse-0.1.12-r4" ; then
		elog "Apulse was detected at merge time on this system and so it will always be"
		elog "used for sound.  If you wish to use pulseaudio instead please unmerge"
		elog "media-sound/apulse."
		elog
	fi

	local show_doh_information
	local show_normandy_information

	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		# New install; Tell user that DoH is disabled by default
		show_doh_information=yes
		show_normandy_information=yes
	fi

	if [[ -n "${show_doh_information}" ]] ; then
		elog
		elog "Note regarding Trusted Recursive Resolver aka DNS-over-HTTPS (DoH):"
		elog "Due to privacy concerns (encrypting DNS might be a good thing, sending all"
		elog "DNS traffic to Cloudflare by default is not a good idea and applications"
		elog "should respect OS configured settings), \"network.trr.mode\" was set to 5"
		elog "(\"Off by choice\") by default."
		elog "You can enable DNS-over-HTTPS in ${PN^}'s preferences."
	fi

	# bug 713782
	if [[ -n "${show_normandy_information}" ]] ; then
		elog
		elog "Upstream operates a service named Normandy which allows Mozilla to"
		elog "push changes for default settings or even install new add-ons remotely."
		elog "While this can be useful to address problems like 'Armagadd-on 2.0' or"
		elog "revert previous decisions to disable TLS 1.0/1.1, privacy and security"
		elog "concerns prevail, which is why we have switched off the use of this"
		elog "service by default."
		elog
		elog "To re-enable this service set"
		elog
		elog "    app.normandy.enabled=true"
		elog
		elog "in about:config."
	fi
}
