# FIRRTL
add_circt_dialect(FIRRTL firrtl FIRRTL)
add_circt_doc(FIRRTL -gen-dialect-doc FIRRTL Dialects/)

set(LLVM_TARGET_DEFINITIONS FIRRTL.td)
mlir_tablegen(FIRRTLEnums.h.inc -gen-enum-decls)
mlir_tablegen(FIRRTLEnums.cpp.inc -gen-enum-defs)
mlir_tablegen(FIRRTLAttributes.h.inc -gen-attrdef-decls)
mlir_tablegen(FIRRTLAttributes.cpp.inc -gen-attrdef-defs)
add_public_tablegen_target(CIRCTFIRRTLEnumsIncGen)
add_circt_doc(FIRRTL -gen-attrdef-doc FIRRTLAttributes Dialects/)

set(LLVM_TARGET_DEFINITIONS Passes.td)
mlir_tablegen(Passes.h.inc -gen-pass-decls)
add_public_tablegen_target(CIRCTFIRRTLTransformsIncGen)
add_circt_doc(Passes -gen-pass-doc FIRRTLPasses ./)

set(LLVM_TARGET_DEFINITIONS FIRRTLCanonicalization.td)
mlir_tablegen(FIRRTLCanonicalization.h.inc -gen-rewriters)
add_public_tablegen_target(CIRCTFIRRTLCanonicalizationIncGen)

set(LLVM_TARGET_DEFINITIONS FIRRTLOpInterfaces.td)
mlir_tablegen(FIRRTLOpInterfaces.h.inc -gen-op-interface-decls)
mlir_tablegen(FIRRTLOpInterfaces.cpp.inc -gen-op-interface-defs)
add_public_tablegen_target(CIRCTFIRRTLOpInterfacesIncGen)
add_dependencies(circt-headers CIRCTFIRRTLOpInterfacesIncGen)

# CHIRRTL
add_circt_dialect(CHIRRTL chirrtl CHIRRTL)
add_circt_doc(CHIRRTL -gen-dialect-doc CHIRRTL Dialects/)