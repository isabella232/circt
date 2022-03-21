// RUN: circt-opt -lowering-options=maximumNumberOfTermsPerExpression=4 --export-verilog %s | FileCheck %s
// RUN: circt-opt -lowering-options=maximumNumberOfTermsPerExpression=4,disallowLocalVariables --export-verilog %s | FileCheck %s --check-prefix=DISALLOW -strict-whitespace

// CHECK-LABEL: module large_use_in_procedural
// DISALLOW-LABEL: module large_use_in_procedural
hw.module @large_use_in_procedural(%a: i1) {
  // DISALLOW: wire _GEN;
  // DISALLOW: assign _GEN = a + a + a + a + a;
  // DISALLOW: always
  sv.always {
    %1 = comb.add %a, %a, %a, %a, %a : i1
    // CHECK: if (a + a + a + a + a)
    // DISALLOW: if (_GEN)
    sv.if %1 {
      sv.exit
    }
    %2 = comb.add %a, %a, %a, %a : i1
    // CHECK: if (a + a + a + a)
    // DISALLOW: if (a + a + a + a)
    sv.if %2 {
      sv.exit
    }
  }
}
