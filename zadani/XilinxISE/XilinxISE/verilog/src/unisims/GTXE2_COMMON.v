// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/fuji/GTXE2_COMMON.v,v 1.9 2010/10/01 14:14:21 vandanad Exp $
///////////////////////////////////////////////////////
//  Copyright (c) 2010 Xilinx Inc.
//  All Right Reserved.
///////////////////////////////////////////////////////
//
//   ____   ___
//  /   /\/   / 
// /___/  \  /     Vendor      : Xilinx 
// \  \    \/      Version : 10.1
//  \  \           Description : Xilinx Functional Simulation Library Component
//  /  /                      
// /__/   /\       Filename    : GTXE2_COMMON.v
// \  \  /  \ 
//  \__\/\__ \                    
//                                 
//  Revision:		1.0
//  11/10/09 - CR - Initial version
//  11/20/09 - CR - Attribute updates in YML
//  04/27/10 - CR - YML update
//  06/10/10 - CR564909  - publish complete verilog unisim wrapper
//  06/17/10 - CR564909 - YML & RTL updates
//  08/05/10 - CR569019 - GTXE2 YML and secureip update
//  09/15/10 - CR575512 - GTXE2 YML and secureip update
///////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps 

module GTXE2_COMMON (
  DRPDO,
  DRPRDY,
  QPLLDMONITOR,
  QPLLFBCLKLOST,
  QPLLLOCK,
  QPLLOUTCLK,
  QPLLOUTREFCLK,
  QPLLREFCLKLOST,
  REFCLKOUTMONITOR,

  BGBYPASS,
  BGMONITOREN,
  BGPDB,
  BGRCALOVRD,
  DRPADDR,
  DRPCLK,
  DRPDI,
  DRPEN,
  DRPWE,
  GTGREFCLK,
  GTNORTHREFCLK0,
  GTNORTHREFCLK1,
  GTREFCLK0,
  GTREFCLK1,
  GTSOUTHREFCLK0,
  GTSOUTHREFCLK1,
  PMARSVD,
  QPLLLOCKDETCLK,
  QPLLLOCKEN,
  QPLLOUTRESET,
  QPLLPD,
  QPLLREFCLKSEL,
  QPLLRESET,
  QPLLRSVD1,
  QPLLRSVD2,
  RCALENB
);

  parameter [63:0] BIAS_CFG = 64'h0000000000000000;
  parameter [31:0] COMMON_CFG = 32'h00000000;
  parameter [26:0] QPLL_CFG = 27'h0000040;
  parameter [3:0] QPLL_CLKOUT_CFG = 4'b0000;
  parameter [5:0] QPLL_COARSE_FREQ_OVRD = 6'b010000;
  parameter [0:0] QPLL_COARSE_FREQ_OVRD_EN = 1'b0;
  parameter [9:0] QPLL_CP = 10'b0000000000;
  parameter [0:0] QPLL_CP_MONITOR_EN = 1'b0;
  parameter [0:0] QPLL_DMONITOR_SEL = 1'b0;
  parameter [9:0] QPLL_FBDIV = 10'b0000000000;
  parameter [0:0] QPLL_FBDIV_MONITOR_EN = 1'b0;
  parameter [0:0] QPLL_FBDIV_RATIO = 1'b0;
  parameter [23:0] QPLL_INIT_CFG = 24'h000000;
  parameter [15:0] QPLL_LOCK_CFG = 16'h21E8;
  parameter [3:0] QPLL_LPF = 4'b0000;
  parameter integer QPLL_REFCLK_DIV = 2;
  parameter [2:0] SIM_QPLLREFCLK_SEL = 3'b001;
  parameter SIM_RESET_SPEEDUP = "TRUE";
  parameter SIM_VERSION = "1.0";
  
  localparam in_delay = 0;
  localparam out_delay = 0;
  localparam INCLK_DELAY = 0;
  localparam OUTCLK_DELAY = 0;

  output DRPRDY;
  output QPLLFBCLKLOST;
  output QPLLLOCK;
  output QPLLOUTCLK;
  output QPLLOUTREFCLK;
  output QPLLREFCLKLOST;
  output REFCLKOUTMONITOR;
  output [15:0] DRPDO;
  output [7:0] QPLLDMONITOR;

  input BGBYPASS;
  input BGMONITOREN;
  input BGPDB;
  input DRPCLK;
  input DRPEN;
  input DRPWE;
  input GTGREFCLK;
  input GTNORTHREFCLK0;
  input GTNORTHREFCLK1;
  input GTREFCLK0;
  input GTREFCLK1;
  input GTSOUTHREFCLK0;
  input GTSOUTHREFCLK1;
  input QPLLLOCKDETCLK;
  input QPLLLOCKEN;
  input QPLLOUTRESET;
  input QPLLPD;
  input QPLLRESET;
  input RCALENB;
  input [15:0] DRPDI;
  input [15:0] QPLLRSVD1;
  input [2:0] QPLLREFCLKSEL;
  input [4:0] BGRCALOVRD;
  input [4:0] QPLLRSVD2;
  input [7:0] DRPADDR;
  input [7:0] PMARSVD;

  reg SIM_RESET_SPEEDUP_BINARY;
  reg SIM_VERSION_BINARY;
  reg [0:0] QPLL_COARSE_FREQ_OVRD_EN_BINARY;
  reg [0:0] QPLL_CP_MONITOR_EN_BINARY;
  reg [0:0] QPLL_DMONITOR_SEL_BINARY;
  reg [0:0] QPLL_FBDIV_MONITOR_EN_BINARY;
  reg [0:0] QPLL_FBDIV_RATIO_BINARY;
  reg [2:0] SIM_QPLLREFCLK_SEL_BINARY;
  reg [3:0] QPLL_CLKOUT_CFG_BINARY;
  reg [3:0] QPLL_LPF_BINARY;
  reg [4:0] QPLL_REFCLK_DIV_BINARY;
  reg [5:0] QPLL_COARSE_FREQ_OVRD_BINARY;
  reg [9:0] QPLL_CP_BINARY;
  reg [9:0] QPLL_FBDIV_BINARY;

  tri0 GSR = glbl.GSR;

  initial begin
    case (QPLL_REFCLK_DIV)
      2 : QPLL_REFCLK_DIV_BINARY = 5'b00000;
      1 : QPLL_REFCLK_DIV_BINARY = 5'b10000;
      3 : QPLL_REFCLK_DIV_BINARY = 5'b00001;
      4 : QPLL_REFCLK_DIV_BINARY = 5'b00010;
      5 : QPLL_REFCLK_DIV_BINARY = 5'b00011;
      6 : QPLL_REFCLK_DIV_BINARY = 5'b00101;
      8 : QPLL_REFCLK_DIV_BINARY = 5'b00110;
      10 : QPLL_REFCLK_DIV_BINARY = 5'b00111;
      12 : QPLL_REFCLK_DIV_BINARY = 5'b01101;
      16 : QPLL_REFCLK_DIV_BINARY = 5'b01110;
      20 : QPLL_REFCLK_DIV_BINARY = 5'b01111;
      default : begin
        $display("Attribute Syntax Error : The Attribute QPLL_REFCLK_DIV on GTXE2_COMMON instance %m is set to %d.  Legal values for this attribute are 1 to 20.", QPLL_REFCLK_DIV, 2);
        $finish;
      end
    endcase

    case (SIM_RESET_SPEEDUP)
      "TRUE" : SIM_RESET_SPEEDUP_BINARY = 0;
      "FALSE" : SIM_RESET_SPEEDUP_BINARY = 0;
      default : begin
        $display("Attribute Syntax Error : The Attribute SIM_RESET_SPEEDUP on GTXE2_COMMON instance %m is set to %s.  Legal values for this attribute are TRUE, or FALSE.", SIM_RESET_SPEEDUP);
        $finish;
      end
    endcase

    case (SIM_VERSION)
      "1.0" : SIM_VERSION_BINARY = 0;
      "2.0" : SIM_VERSION_BINARY = 0;
      default : begin
        $display("Attribute Syntax Error : The Attribute SIM_VERSION on GTXE2_COMMON instance %m is set to %s.  Legal values for this attribute are 1.0, or 2.0.", SIM_VERSION);
        $finish;
      end
    endcase

    if ((QPLL_CLKOUT_CFG >= 4'b0000) && (QPLL_CLKOUT_CFG <= 4'b1111))
      QPLL_CLKOUT_CFG_BINARY = QPLL_CLKOUT_CFG;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_CLKOUT_CFG on GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 4'b0000 to 4'b1111.", QPLL_CLKOUT_CFG);
      $finish;
    end

    if ((QPLL_COARSE_FREQ_OVRD >= 6'b000000) && (QPLL_COARSE_FREQ_OVRD <= 6'b111111))
      QPLL_COARSE_FREQ_OVRD_BINARY = QPLL_COARSE_FREQ_OVRD;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_COARSE_FREQ_OVRD on GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 6'b000000 to 6'b111111.", QPLL_COARSE_FREQ_OVRD);
      $finish;
    end

    if ((QPLL_COARSE_FREQ_OVRD_EN >= 1'b0) && (QPLL_COARSE_FREQ_OVRD_EN <= 1'b1))
      QPLL_COARSE_FREQ_OVRD_EN_BINARY = QPLL_COARSE_FREQ_OVRD_EN;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_COARSE_FREQ_OVRD_EN on GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 1'b0 to 1'b1.", QPLL_COARSE_FREQ_OVRD_EN);
      $finish;
    end

    if ((QPLL_CP >= 10'b0000000000) && (QPLL_CP <= 10'b1111111111))
      QPLL_CP_BINARY = QPLL_CP;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_CP on GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 10'b0000000000 to 10'b1111111111.", QPLL_CP);
      $finish;
    end

    if ((QPLL_CP_MONITOR_EN >= 1'b0) && (QPLL_CP_MONITOR_EN <= 1'b1))
      QPLL_CP_MONITOR_EN_BINARY = QPLL_CP_MONITOR_EN;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_CP_MONITOR_EN on GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 1'b0 to 1'b1.", QPLL_CP_MONITOR_EN);
      $finish;
    end

    if ((QPLL_DMONITOR_SEL >= 1'b0) && (QPLL_DMONITOR_SEL <= 1'b1))
      QPLL_DMONITOR_SEL_BINARY = QPLL_DMONITOR_SEL;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_DMONITOR_SEL on GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 1'b0 to 1'b1.", QPLL_DMONITOR_SEL);
      $finish;
    end

    if ((QPLL_FBDIV >= 10'b0000000000) && (QPLL_FBDIV <= 10'b1111111111))
      QPLL_FBDIV_BINARY = QPLL_FBDIV;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_FBDIV on GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 10'b0000000000 to 10'b1111111111.", QPLL_FBDIV);
      $finish;
    end

    if ((QPLL_FBDIV_MONITOR_EN >= 1'b0) && (QPLL_FBDIV_MONITOR_EN <= 1'b1))
      QPLL_FBDIV_MONITOR_EN_BINARY = QPLL_FBDIV_MONITOR_EN;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_FBDIV_MONITOR_EN on GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 1'b0 to 1'b1.", QPLL_FBDIV_MONITOR_EN);
      $finish;
    end

    if ((QPLL_FBDIV_RATIO >= 1'b0) && (QPLL_FBDIV_RATIO <= 1'b1))
      QPLL_FBDIV_RATIO_BINARY = QPLL_FBDIV_RATIO;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_FBDIV_RATIO on GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 1'b0 to 1'b1.", QPLL_FBDIV_RATIO);
      $finish;
    end

    if ((QPLL_LPF >= 4'b0000) && (QPLL_LPF <= 4'b1111))
      QPLL_LPF_BINARY = QPLL_LPF;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_LPF on GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 4'b0000 to 4'b1111.", QPLL_LPF);
      $finish;
    end

    if ((SIM_QPLLREFCLK_SEL >= 3'b0) && (SIM_QPLLREFCLK_SEL <= 3'b111))
      SIM_QPLLREFCLK_SEL_BINARY = SIM_QPLLREFCLK_SEL;
    else begin
      $display("Attribute Syntax Error : The Attribute SIM_QPLLREFCLK_SEL on GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 3'b0 to 3'b111.", SIM_QPLLREFCLK_SEL);
      $finish;
    end

  end

  wire [15:0] delay_DRPDO;
  wire [7:0] delay_QPLLDMONITOR;
  wire delay_DRPRDY;
  wire delay_QPLLFBCLKLOST;
  wire delay_QPLLLOCK;
  wire delay_QPLLOUTCLK;
  wire delay_QPLLOUTREFCLK;
  wire delay_QPLLREFCLKLOST;
  wire delay_REFCLKOUTMONITOR;

  wire [15:0] delay_DRPDI;
  wire [15:0] delay_QPLLRSVD1;
  wire [2:0] delay_QPLLREFCLKSEL;
  wire [4:0] delay_BGRCALOVRD;
  wire [4:0] delay_QPLLRSVD2;
  wire [7:0] delay_DRPADDR;
  wire [7:0] delay_PMARSVD;
  wire delay_BGBYPASS;
  wire delay_BGMONITOREN;
  wire delay_BGPDB;
  wire delay_DRPCLK;
  wire delay_DRPEN;
  wire delay_DRPWE;
  wire delay_GTGREFCLK;
  wire delay_GTNORTHREFCLK0;
  wire delay_GTNORTHREFCLK1;
  wire delay_GTREFCLK0;
  wire delay_GTREFCLK1;
  wire delay_GTSOUTHREFCLK0;
  wire delay_GTSOUTHREFCLK1;
  wire delay_QPLLLOCKDETCLK;
  wire delay_QPLLLOCKEN;
  wire delay_QPLLOUTRESET;
  wire delay_QPLLPD;
  wire delay_QPLLRESET;
  wire delay_RCALENB;

  assign #(OUTCLK_DELAY) QPLLOUTCLK = delay_QPLLOUTCLK;
  assign #(OUTCLK_DELAY) REFCLKOUTMONITOR = delay_REFCLKOUTMONITOR;

  assign #(out_delay) DRPDO = delay_DRPDO;
  assign #(out_delay) DRPRDY = delay_DRPRDY;
  assign #(out_delay) QPLLDMONITOR = delay_QPLLDMONITOR;
  assign #(out_delay) QPLLFBCLKLOST = delay_QPLLFBCLKLOST;
  assign #(out_delay) QPLLLOCK = delay_QPLLLOCK;
  assign #(out_delay) QPLLOUTREFCLK = delay_QPLLOUTREFCLK;
  assign #(out_delay) QPLLREFCLKLOST = delay_QPLLREFCLKLOST;

  assign #(INCLK_DELAY) delay_DRPCLK = DRPCLK;
  assign #(INCLK_DELAY) delay_GTGREFCLK = GTGREFCLK;
  assign #(INCLK_DELAY) delay_GTNORTHREFCLK0 = GTNORTHREFCLK0;
  assign #(INCLK_DELAY) delay_GTNORTHREFCLK1 = GTNORTHREFCLK1;
  assign #(INCLK_DELAY) delay_GTREFCLK0 = GTREFCLK0;
  assign #(INCLK_DELAY) delay_GTREFCLK1 = GTREFCLK1;
  assign #(INCLK_DELAY) delay_GTSOUTHREFCLK0 = GTSOUTHREFCLK0;
  assign #(INCLK_DELAY) delay_GTSOUTHREFCLK1 = GTSOUTHREFCLK1;
  assign #(INCLK_DELAY) delay_QPLLLOCKDETCLK = QPLLLOCKDETCLK;

  assign #(in_delay) delay_BGBYPASS = BGBYPASS;
  assign #(in_delay) delay_BGMONITOREN = BGMONITOREN;
  assign #(in_delay) delay_BGPDB = BGPDB;
  assign #(in_delay) delay_BGRCALOVRD = BGRCALOVRD;
  assign #(in_delay) delay_DRPADDR = DRPADDR;
  assign #(in_delay) delay_DRPDI = DRPDI;
  assign #(in_delay) delay_DRPEN = DRPEN;
  assign #(in_delay) delay_DRPWE = DRPWE;
  assign #(in_delay) delay_PMARSVD = PMARSVD;
  assign #(in_delay) delay_QPLLLOCKEN = QPLLLOCKEN;
  assign #(in_delay) delay_QPLLOUTRESET = QPLLOUTRESET;
  assign #(in_delay) delay_QPLLPD = QPLLPD;
  assign #(in_delay) delay_QPLLREFCLKSEL = QPLLREFCLKSEL;
  assign #(in_delay) delay_QPLLRESET = QPLLRESET;
  assign #(in_delay) delay_QPLLRSVD1 = QPLLRSVD1;
  assign #(in_delay) delay_QPLLRSVD2 = QPLLRSVD2;
  assign #(in_delay) delay_RCALENB = RCALENB;

  B_GTXE2_COMMON #(
    .BIAS_CFG (BIAS_CFG),
    .COMMON_CFG (COMMON_CFG),
    .QPLL_CFG (QPLL_CFG),
    .QPLL_CLKOUT_CFG (QPLL_CLKOUT_CFG),
    .QPLL_COARSE_FREQ_OVRD (QPLL_COARSE_FREQ_OVRD),
    .QPLL_COARSE_FREQ_OVRD_EN (QPLL_COARSE_FREQ_OVRD_EN),
    .QPLL_CP (QPLL_CP),
    .QPLL_CP_MONITOR_EN (QPLL_CP_MONITOR_EN),
    .QPLL_DMONITOR_SEL (QPLL_DMONITOR_SEL),
    .QPLL_FBDIV (QPLL_FBDIV),
    .QPLL_FBDIV_MONITOR_EN (QPLL_FBDIV_MONITOR_EN),
    .QPLL_FBDIV_RATIO (QPLL_FBDIV_RATIO),
    .QPLL_INIT_CFG (QPLL_INIT_CFG),
    .QPLL_LOCK_CFG (QPLL_LOCK_CFG),
    .QPLL_LPF (QPLL_LPF),
    .QPLL_REFCLK_DIV (QPLL_REFCLK_DIV),
    .SIM_QPLLREFCLK_SEL (SIM_QPLLREFCLK_SEL),
    .SIM_RESET_SPEEDUP (SIM_RESET_SPEEDUP),
    .SIM_VERSION (SIM_VERSION))

    B_GTXE2_COMMON_INST (
    .DRPDO (delay_DRPDO),
    .DRPRDY (delay_DRPRDY),
    .QPLLDMONITOR (delay_QPLLDMONITOR),
    .QPLLFBCLKLOST (delay_QPLLFBCLKLOST),
    .QPLLLOCK (delay_QPLLLOCK),
    .QPLLOUTCLK (delay_QPLLOUTCLK),
    .QPLLOUTREFCLK (delay_QPLLOUTREFCLK),
    .QPLLREFCLKLOST (delay_QPLLREFCLKLOST),
    .REFCLKOUTMONITOR (delay_REFCLKOUTMONITOR),
    .BGBYPASS (delay_BGBYPASS),
    .BGMONITOREN (delay_BGMONITOREN),
    .BGPDB (delay_BGPDB),
    .BGRCALOVRD (delay_BGRCALOVRD),
    .DRPADDR (delay_DRPADDR),
    .DRPCLK (delay_DRPCLK),
    .DRPDI (delay_DRPDI),
    .DRPEN (delay_DRPEN),
    .DRPWE (delay_DRPWE),
    .GTGREFCLK (delay_GTGREFCLK),
    .GTNORTHREFCLK0 (delay_GTNORTHREFCLK0),
    .GTNORTHREFCLK1 (delay_GTNORTHREFCLK1),
    .GTREFCLK0 (delay_GTREFCLK0),
    .GTREFCLK1 (delay_GTREFCLK1),
    .GTSOUTHREFCLK0 (delay_GTSOUTHREFCLK0),
    .GTSOUTHREFCLK1 (delay_GTSOUTHREFCLK1),
    .PMARSVD (delay_PMARSVD),
    .QPLLLOCKDETCLK (delay_QPLLLOCKDETCLK),
    .QPLLLOCKEN (delay_QPLLLOCKEN),
    .QPLLOUTRESET (delay_QPLLOUTRESET),
    .QPLLPD (delay_QPLLPD),
    .QPLLREFCLKSEL (delay_QPLLREFCLKSEL),
    .QPLLRESET (delay_QPLLRESET),
    .QPLLRSVD1 (delay_QPLLRSVD1),
    .QPLLRSVD2 (delay_QPLLRSVD2),
    .RCALENB (delay_RCALENB),
    .GSR (GSR)
  );

  specify
    ( DRPCLK *> DRPDO) = (100, 100);
    ( DRPCLK *> DRPRDY) = (100, 100);
    ( GTGREFCLK *> REFCLKOUTMONITOR) = (100, 100);
    ( GTNORTHREFCLK0 *> REFCLKOUTMONITOR) = (100, 100);
    ( GTNORTHREFCLK1 *> REFCLKOUTMONITOR) = (100, 100);
    ( GTREFCLK0 *> REFCLKOUTMONITOR) = (100, 100);
    ( GTREFCLK1 *> REFCLKOUTMONITOR) = (100, 100);
    ( GTSOUTHREFCLK0 *> REFCLKOUTMONITOR) = (100, 100);
    ( GTSOUTHREFCLK1 *> REFCLKOUTMONITOR) = (100, 100);

    specparam PATHPULSE$ = 0;
  endspecify
endmodule
