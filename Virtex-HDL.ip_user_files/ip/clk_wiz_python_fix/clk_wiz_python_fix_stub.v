// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Fri Apr 29 01:17:06 2022
// Host        : RISC-IV running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top clk_wiz_python_fix -prefix
//               clk_wiz_python_fix_ clk_wiz_python_fix_stub.v
// Design      : clk_wiz_python_fix
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tftg256-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_python_fix(clk_out1, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,clk_in1" */;
  output clk_out1;
  input clk_in1;
endmodule
