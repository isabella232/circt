// RUN: circt-opt -lower-firrtl-to-hw --split-input-file  %s | FileCheck %s

// When there is no module marked as the DUT, the top level module should be
// considered the DUT.
firrtl.circuit "MyDUT" attributes {annotations = [
  {class = "sifive.enterprise.firrtl.ModuleHierarchyAnnotation", filename = "./dir1/filename1.json" },
  {class = "sifive.enterprise.firrtl.TestHarnessHierarchyAnnotation", filename = "./dir2/filename2.json" }]}
{
  // CHECK-LABEL: hw.module @MyDUT
  // CHECK-SAME: attributes {firrtl.moduleHierarchyFile = [#hw.output_file<"./dir1/filename1.json", excludeFromFileList>, #hw.output_file<"./dir2/filename2.json", excludeFromFileList>]}
  firrtl.module @MyDUT() {}
}

// -----

// When the DUT is the top level module, there is no test harness either.
firrtl.circuit "MyDUT" attributes {annotations = [
  {class = "sifive.enterprise.firrtl.ModuleHierarchyAnnotation", filename = "./dir1/filename1.json" },
  {class = "sifive.enterprise.firrtl.TestHarnessHierarchyAnnotation", filename = "./dir2/filename2.json" }]}
{
  // CHECK-LABEL: hw.module @MyDUT
  // CHECK-SAME: attributes {firrtl.moduleHierarchyFile = [#hw.output_file<"./dir1/filename1.json", excludeFromFileList>, #hw.output_file<"./dir2/filename2.json", excludeFromFileList>]}
  firrtl.module @MyDUT() attributes {annotations = [
      {class = "sifive.enterprise.firrtl.MarkDUTAnnotation"}]} {}
}

// -----

// When the DUT is not the top-level module, the top-level module is the test
// harness.
firrtl.circuit "MyTestHarness" attributes {annotations = [
  {class = "sifive.enterprise.firrtl.ModuleHierarchyAnnotation", filename = "./dir1/filename1.json" },
  {class = "sifive.enterprise.firrtl.TestHarnessHierarchyAnnotation", filename = "./dir2/filename2.json" }]}
{
  // CHECK-LABEL: hw.module @MyDUT
  // CHECK-SAME: attributes {firrtl.moduleHierarchyFile = [#hw.output_file<"./dir1/filename1.json", excludeFromFileList>]}
  firrtl.module @MyDUT() attributes {annotations = [
      {class = "sifive.enterprise.firrtl.MarkDUTAnnotation"}]} {}

  // CHECK-LABEL: hw.module @MyTestHarness
  // CHECK-SAME: attributes {firrtl.moduleHierarchyFile = [#hw.output_file<"./dir2/filename2.json", excludeFromFileList>]}
  firrtl.module @MyTestHarness() {
    firrtl.instance myDUT @MyDUT()
  }
}

// -----

// We should only export the module hierachy when the ModuleHiearchyAnnotation
// is present.
firrtl.circuit "MyDUT" {
  // CHECK-LABEL: hw.module @MyDUT
  // CHECK-NOT: firrtl.moduleHierarchyFile
  firrtl.module @MyDUT() attributes {annotations = [
      {class = "sifive.enterprise.firrtl.MarkDUTAnnotation"}]} {}
}
