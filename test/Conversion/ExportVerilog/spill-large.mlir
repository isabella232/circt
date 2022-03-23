hw.module @spill_top_level(%a: i1) -> (b: i1) {
  %1 = comb.add %a, %a, %a, %a, %a : i1
  hw.output %1 : i1
}

hw.module @spill_use_in_procedural(%a: i1) {
  sv.always {
    %1 = comb.add %a, %a, %a, %a, %a : i1
    sv.if %1 {
      sv.exit
    }
  }
}
