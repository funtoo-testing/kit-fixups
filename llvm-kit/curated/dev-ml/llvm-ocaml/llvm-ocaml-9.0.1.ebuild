# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit cmake-utils llvm llvm.org multiprocessing python-any-r1

DESCRIPTION="OCaml bindings for LLVM"
HOMEPAGE="https://llvm.org/"
LLVM_COMPONENTS=( llvm )
llvm.org_set_globals

# Keep in sync with sys-devel/llvm
ALL_LLVM_TARGETS=( AArch64 AMDGPU ARM BPF Hexagon Lanai Mips MSP430
	NVPTX PowerPC RISCV Sparc SystemZ WebAssembly X86 XCore )
ALL_LLVM_TARGETS=( "${ALL_LLVM_TARGETS[@]/#/llvm_targets_}" )

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0/${PV}"
KEYWORDS="*"
IUSE="debug test ${ALL_LLVM_TARGETS[*]}"
REQUIRED_USE="|| ( ${ALL_LLVM_TARGETS[*]} )"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/ocaml-4.00.0:0=
	dev-ml/ocaml-ctypes:=
	~sys-devel/llvm-${PV}:=[debug?]
	!sys-devel/llvm[ocaml(-)]"
for x in "${ALL_LLVM_TARGETS[@]}"; do
	RDEPEND+="
		${x}? ( ~sys-devel/llvm-${PV}[${x}] )"
done
unset x

DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	dev-ml/findlib
	test? ( dev-ml/ounit )
	${PYTHON_DEPS}"

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

pkg_setup() {
	LLVM_MAX_SLOT=${PV%%.*} llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	# Python is needed to run tests using lit
	python_setup

	cmake-utils_src_prepare
}

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}

		-DBUILD_SHARED_LIBS=ON
		-DLLVM_OCAML_OUT_OF_TREE=ON
		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
		-DLLVM_BUILD_TESTS=$(usex test)

		# disable various irrelevant deps and settings
		-DLLVM_ENABLE_FFI=OFF
		-DLLVM_ENABLE_TERMINFO=OFF
		-DHAVE_HISTEDIT_H=NO
		-DWITH_POLLY=OFF
		-DLLVM_ENABLE_ASSERTIONS=$(usex debug)
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON

		-DLLVM_HOST_TRIPLE="${CHOST}"

		# disable go bindings
		-DGO_EXECUTABLE=GO_EXECUTABLE-NOTFOUND

		# TODO: ocamldoc
	)

	use test && mycmakeargs+=(
		-DLLVM_LIT_ARGS="-vv;-j;${LIT_JOBS:-$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")}"
	)

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	# also: custom rules for OCaml do not work for CPPFLAGS
	use debug || local -x CFLAGS="${CFLAGS} -DNDEBUG"
	cmake-utils_src_configure

	local llvm_libdir=$(llvm-config --libdir)
	# an ugly hack; TODO: figure out a way to pass -L to ocaml...
	cd "${BUILD_DIR}/${libdir}" || die
	ln -s "${llvm_libdir}"/*.so . || die

	if use test; then
		local llvm_bindir=$(llvm-config --bindir)
		# Force using system-installed tools.
		sed -i -e "/llvm_tools_dir/s@\".*\"@\"${llvm_bindir}\"@" \
			"${BUILD_DIR}"/test/lit.site.cfg.py || die
	fi
}

src_compile() {
	cmake-utils_src_compile ocaml_all
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake-utils_src_make check-llvm-bindings-ocaml
}

src_install() {
	DESTDIR="${D}" \
	cmake -P "${BUILD_DIR}"/bindings/ocaml/cmake_install.cmake || die

	dodoc bindings/ocaml/README.txt
}
