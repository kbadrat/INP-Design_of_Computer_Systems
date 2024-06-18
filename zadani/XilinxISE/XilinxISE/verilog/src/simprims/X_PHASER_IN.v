// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/fuji/X_PHASER_IN.v,v 1.16 2010/12/22 17:21:14 robh Exp $
///////////////////////////////////////////////////////
//  Copyright (c) 2010 Xilinx Inc.
//  All Right Reserved.
///////////////////////////////////////////////////////
//
//   ____   ___
//  /   /\/   / 
// /___/  \  /     Vendor      : Xilinx 
// \  \    \/      Version     :  13.1
//  \  \           Description : Xilinx Timing Simulation Library Component
//  /  /                         Fujisan PHASER IN
// /__/   /\       Filename    : X_PHASER_IN.v
// \  \  /  \ 
//  \__\/\__ \                    
//                                 
//  Revision: Comment:
//  22APR2010 Initial UNI/UNP/SIM Version from yaml
//  03JUN2010 yaml update
//  12JUL2010 enable secureip
//  14SEP2010 yaml, rtl update
//  24SEP2010 yaml, rtl update
//  29SEP2010 add width checks
//  13OCT2010 yaml, rtl update
//  26OCT2010 delay yaml, rtl update
//  02NOV2010 yaml update
//  05NOV2010 secureip parameter name update
//  01DEC2010 yaml update, REFCLK_PERIOD max
//  09DEC2010 586079 yaml update, tie off defaults
//  20DEC2010 587097 yaml update, OUTPUT_CLK_SRC
///////////////////////////////////////////////////////

`timescale 1 ps / 1 ps 

module X_PHASER_IN (
  COUNTERREADVAL,
  FINEOVERFLOW,
  ICLK,
  ICLKDIV,
  ISERDESRST,
  RCLK,

  COUNTERLOADEN,
  COUNTERLOADVAL,
  COUNTERREADEN,
  DIVIDERST,
  EDGEADV,
  FINEENABLE,
  FINEINC,
  FREQREFCLK,
  MEMREFCLK,
  PHASEREFCLK,
  RANKSEL,
  RST,
  SYNCIN,
  SYSCLK
);

  parameter LOC = "UNPLACED";
  parameter integer CLKOUT_DIV = 4;
  parameter EN_ISERDES_RST = "FALSE";
  parameter integer FINE_DELAY = 0;
  parameter FREQ_REF_DIV = "NONE";
  parameter OUTPUT_CLK_SRC = "PHASE_REF";
  parameter real REFCLK_PERIOD = 0.000;
  parameter SYNC_IN_DIV_RST = "FALSE";
  
  localparam in_delay = 0;
  localparam out_delay = 0;
  localparam INCLK_DELAY = 0;
  localparam OUTCLK_DELAY = 0;
  localparam MODULE_NAME = "X_PHASER_IN";

  output FINEOVERFLOW;
  output ICLK;
  output ICLKDIV;
  output ISERDESRST;
  output RCLK;
  output [5:0] COUNTERREADVAL;

  input COUNTERLOADEN;
  input COUNTERREADEN;
  input DIVIDERST;
  input EDGEADV;
  input FINEENABLE;
  input FINEINC;
  input FREQREFCLK;
  input MEMREFCLK;
  input PHASEREFCLK;
  input RST;
  input SYNCIN;
  input SYSCLK;
  input [1:0] RANKSEL;
  input [5:0] COUNTERLOADVAL;

  reg REFCLK_PERIOD_BINARY;
  reg [0:0] BURST_MODE_BINARY;
  reg [0:0] CTL_MODE_BINARY;
  reg [0:0] EN_ISERDES_RST_BINARY;
  reg [0:0] EN_TEST_RING_BINARY;
  reg [0:0] HALF_CYCLE_ADJ_BINARY;
  reg [0:0] ICLK_TO_RCLK_BYPASS_BINARY;
  reg [0:0] PHASER_IN_EN_BINARY;
  reg [0:0] SYNC_IN_DIV_RST_BINARY;
  reg [0:0] UPDATE_NONACTIVE_BINARY;
  reg [12:0] TEST_OPT_BINARY;
  reg [1:0] FREQ_REF_DIV_BINARY;
  reg [1:0] OUTPUT_CLK_SRC_BINARY;
  reg [2:0] DQS_FIND_PATTERN_BINARY;
  reg [2:0] PD_REVERSE_BINARY;
  reg [2:0] STG1_PD_UPDATE_BINARY;
  reg [3:0] CLKOUT_DIV_BINARY;
  reg [3:0] CLKOUT_DIV_POS_BINARY;
  reg [3:0] CLKOUT_DIV_ST_BINARY;
  reg [5:0] FINE_DELAY_BINARY;

  tri0 GSR = glbl.GSR;
  reg notifier;

  initial begin
    BURST_MODE_BINARY <= 1'b0;

    case (CLKOUT_DIV)
      4 : CLKOUT_DIV_BINARY <= 4'b0010;
      2 : CLKOUT_DIV_BINARY <= 4'b0000;
      3 : CLKOUT_DIV_BINARY <= 4'b0001;
      5 : CLKOUT_DIV_BINARY <= 4'b0011;
      6 : CLKOUT_DIV_BINARY <= 4'b0100;
      7 : CLKOUT_DIV_BINARY <= 4'b0101;
      8 : CLKOUT_DIV_BINARY <= 4'b0110;
      9 : CLKOUT_DIV_BINARY <= 4'b0111;
      10 : CLKOUT_DIV_BINARY <= 4'b1000;
      11 : CLKOUT_DIV_BINARY <= 4'b1001;
      12 : CLKOUT_DIV_BINARY <= 4'b1010;
      13 : CLKOUT_DIV_BINARY <= 4'b1011;
      14 : CLKOUT_DIV_BINARY <= 4'b1100;
      15 : CLKOUT_DIV_BINARY <= 4'b1101;
      16 : CLKOUT_DIV_BINARY <= 4'b1110;
      default : begin
        $display("Attribute Syntax Error : The Attribute CLKOUT_DIV on %s instance %m is set to %d.  Legal values for this attribute are 2 to 16.", MODULE_NAME, CLKOUT_DIV);
        $finish;
      end
    endcase

    CTL_MODE_BINARY <= 1'b0; // model alert

    case (EN_ISERDES_RST)
      "FALSE" : EN_ISERDES_RST_BINARY <= 1'b0;
      "TRUE" : EN_ISERDES_RST_BINARY <= 1'b1;
      default : begin
        $display("Attribute Syntax Error : The Attribute EN_ISERDES_RST on %s instance %m is set to %s.  Legal values for this attribute are FALSE or TRUE.", MODULE_NAME, EN_ISERDES_RST);
        $finish;
      end
    endcase

    EN_TEST_RING_BINARY <= 1'b0;

    case (FREQ_REF_DIV)
      "NONE" : FREQ_REF_DIV_BINARY <= 2'b00;
      "DIV2" : FREQ_REF_DIV_BINARY <= 2'b01;
      "DIV4" : FREQ_REF_DIV_BINARY <= 2'b10;
      default : begin
        $display("Attribute Syntax Error : The Attribute FREQ_REF_DIV on %s instance %m is set to %s.  Legal values for this attribute are NONE, DIV2 or DIV4.", MODULE_NAME, FREQ_REF_DIV);
        $finish;
      end
    endcase

    HALF_CYCLE_ADJ_BINARY <= 1'b0;

    ICLK_TO_RCLK_BYPASS_BINARY <= 1'b1;

    case (OUTPUT_CLK_SRC)
      "PHASE_REF" : OUTPUT_CLK_SRC_BINARY <= 2'b00;
      "DELAYED_PHASE_REF" : OUTPUT_CLK_SRC_BINARY <= 2'b11;
      "DELAYED_REF" : OUTPUT_CLK_SRC_BINARY <= 2'b01;
      "FREQ_REF" : OUTPUT_CLK_SRC_BINARY <= 2'b10;
      default : begin
        $display("Attribute Syntax Error : The Attribute OUTPUT_CLK_SRC on %s instance %m is set to %s.  Legal values for this attribute are PHASE_REF, DELAYED_REF FREQ_REF or DELAYED_PHASE_REF.", MODULE_NAME, OUTPUT_CLK_SRC);
        $finish;
      end
    endcase

    PD_REVERSE_BINARY <= 3'b011;

    PHASER_IN_EN_BINARY <= 1'b1;

    STG1_PD_UPDATE_BINARY <= 3'b000;

    case (SYNC_IN_DIV_RST)
      "FALSE" : SYNC_IN_DIV_RST_BINARY <= 1'b0;
      "TRUE" : SYNC_IN_DIV_RST_BINARY <= 1'b1;
      default : begin
        $display("Attribute Syntax Error : The Attribute SYNC_IN_DIV_RST on %s instance %m is set to %s.  Legal values for this attribute are FALSE or TRUE.", MODULE_NAME, SYNC_IN_DIV_RST);
        $finish;
      end
    endcase

    UPDATE_NONACTIVE_BINARY <= 1'b0;

    case (CLKOUT_DIV)
        2   : CLKOUT_DIV_POS_BINARY <= 4'b0001;
        3   : CLKOUT_DIV_POS_BINARY <= 4'b0001;
        4   : CLKOUT_DIV_POS_BINARY <= 4'b0010;
        5   : CLKOUT_DIV_POS_BINARY <= 4'b0010;
        6   : CLKOUT_DIV_POS_BINARY <= 4'b0011;
        7   : CLKOUT_DIV_POS_BINARY <= 4'b0011;
        8   : CLKOUT_DIV_POS_BINARY <= 4'b0100;
        9   : CLKOUT_DIV_POS_BINARY <= 4'b0100;
       10   : CLKOUT_DIV_POS_BINARY <= 4'b0101;
       11   : CLKOUT_DIV_POS_BINARY <= 4'b0101;
       12   : CLKOUT_DIV_POS_BINARY <= 4'b0110;
       13   : CLKOUT_DIV_POS_BINARY <= 4'b0110;
       14   : CLKOUT_DIV_POS_BINARY <= 4'b0111;
       15   : CLKOUT_DIV_POS_BINARY <= 4'b0111;
       16   : CLKOUT_DIV_POS_BINARY <= 4'b1000;
     default: CLKOUT_DIV_POS_BINARY <= 4'b0010;
    endcase

    CLKOUT_DIV_ST_BINARY <= 4'b0000;

    DQS_FIND_PATTERN_BINARY <= 3'b000;

    if ((FINE_DELAY >= 0) && (FINE_DELAY <= 63))
      FINE_DELAY_BINARY <= FINE_DELAY;
    else begin
      $display("Attribute Syntax Error : The Attribute FINE_DELAY on %s instance %m is set to %d.  Legal values for this attribute are 0 to 63.", MODULE_NAME, FINE_DELAY);
      $finish;
    end

    if ((REFCLK_PERIOD >= 0.000) && (REFCLK_PERIOD <= 10.000))
      REFCLK_PERIOD_BINARY <= 1'b1;
    else begin
      $display("Attribute Syntax Error : The Attribute REFCLK_PERIOD on %s instance %m is set to %2.3f.  Legal values for this attribute are 0.000 to 10.000.", MODULE_NAME, REFCLK_PERIOD);
      $finish;
    end

    TEST_OPT_BINARY <= 13'b0000000000000;

  end

  wire [3:0] delay_TESTOUT;
  wire [5:0] delay_COUNTERREADVAL;
  wire [8:0] delay_STG1REGR;
  wire delay_DQSFOUND;
  wire delay_DQSOUTOFRANGE;
  wire delay_FINEOVERFLOW;
  wire delay_ICLK;
  wire delay_ICLKDIV;
  wire delay_ISERDESRST;
  wire delay_PHASELOCKED;
  wire delay_RCLK;
  wire delay_SCANOUT;
  wire delay_STG1OVERFLOW;
  wire delay_WRENABLE;

  wire [13:0] delay_TESTIN = 14'h3fff;
  wire [1:0] delay_ENCALIB = 2'b11;
  wire [1:0] delay_ENCALIBPHY = 2'b0;
  wire [1:0] delay_RANKSEL;
  wire [1:0] delay_RANKSELPHY = 2'b0;
  wire [5:0] delay_COUNTERLOADVAL;
  wire [8:0] delay_STG1REGL = 9'h1ff;
  wire delay_BURSTPENDING = 1'b1;
  wire delay_BURSTPENDINGPHY = 1'b0;
  wire delay_COUNTERLOADEN;
  wire delay_COUNTERREADEN;
  wire delay_DIVIDERST;
  wire delay_EDGEADV;
  wire delay_ENSTG1 = 1'b1;
  wire delay_ENSTG1ADJUSTB = 1'b1;
  wire delay_FINEENABLE;
  wire delay_FINEINC;
  wire delay_FREQREFCLK;
  wire delay_MEMREFCLK;
  wire delay_PHASEREFCLK;
  wire delay_RST;
  wire delay_RSTDQSFIND = 1'b1;
  wire delay_SCANCLK = 1'b1;
  wire delay_SCANENB = 1'b1;
  wire delay_SCANIN = 1'b1;
  wire delay_SCANMODEB = 1'b1;
  wire delay_SELCALORSTG1 = 1'b1;
  wire delay_STG1INCDEC = 1'b1;
  wire delay_STG1LOAD = 1'b1;
  wire delay_STG1READ = 1'b1;
  wire delay_SYNCIN;
  wire delay_SYSCLK;
  wire delay_GSR;

  assign #(OUTCLK_DELAY) ICLK = delay_ICLK;
  assign #(OUTCLK_DELAY) ICLKDIV = delay_ICLKDIV;
  assign #(OUTCLK_DELAY) RCLK = delay_RCLK;

  assign #(out_delay) COUNTERREADVAL = delay_COUNTERREADVAL;
  assign #(out_delay) FINEOVERFLOW = delay_FINEOVERFLOW;
  assign #(out_delay) ISERDESRST = delay_ISERDESRST;

  assign #(INCLK_DELAY) delay_FREQREFCLK = FREQREFCLK;
  assign #(INCLK_DELAY) delay_MEMREFCLK = MEMREFCLK;
  assign #(INCLK_DELAY) delay_PHASEREFCLK = PHASEREFCLK;
  assign #(INCLK_DELAY) delay_SYNCIN = SYNCIN;

  assign #(in_delay) delay_RST = RST;
  assign delay_GSR = GSR;

  SIP_PHASER_IN PHASER_IN_INST (
    .BURST_MODE (BURST_MODE_BINARY),
    .CLKOUT_DIV (CLKOUT_DIV_BINARY),
    .CLKOUT_DIV_POS (CLKOUT_DIV_POS_BINARY),
    .CLKOUT_DIV_ST (CLKOUT_DIV_ST_BINARY),
    .CTL_MODE (CTL_MODE_BINARY),
    .DQS_FIND_PATTERN (DQS_FIND_PATTERN_BINARY),
    .EN_ISERDES_RST (EN_ISERDES_RST_BINARY),
    .EN_TEST_RING (EN_TEST_RING_BINARY),
    .FINE_DELAY (FINE_DELAY_BINARY),
    .FREQ_REF_DIV (FREQ_REF_DIV_BINARY),
    .HALF_CYCLE_ADJ (HALF_CYCLE_ADJ_BINARY),
    .ICLK_TO_RCLK_BYPASS (ICLK_TO_RCLK_BYPASS_BINARY),
    .OUTPUT_CLK_SRC (OUTPUT_CLK_SRC_BINARY),
    .PD_REVERSE (PD_REVERSE_BINARY),
    .PHASER_IN_EN (PHASER_IN_EN_BINARY),
    .REFCLK_PERIOD (REFCLK_PERIOD_BINARY),
    .STG1_PD_UPDATE (STG1_PD_UPDATE_BINARY),
    .SYNC_IN_DIV_RST (SYNC_IN_DIV_RST_BINARY),
    .TEST_OPT (TEST_OPT_BINARY),
    .UPDATE_NONACTIVE (UPDATE_NONACTIVE_BINARY),

    .COUNTERREADVAL (delay_COUNTERREADVAL),
    .DQSFOUND (delay_DQSFOUND),
    .DQSOUTOFRANGE (delay_DQSOUTOFRANGE),
    .FINEOVERFLOW (delay_FINEOVERFLOW),
    .ICLK (delay_ICLK),
    .ICLKDIV (delay_ICLKDIV),
    .ISERDESRST (delay_ISERDESRST),
    .PHASELOCKED (delay_PHASELOCKED),
    .RCLK (delay_RCLK),
    .SCANOUT (delay_SCANOUT),
    .STG1OVERFLOW (delay_STG1OVERFLOW),
    .STG1REGR (delay_STG1REGR),
    .TESTOUT (delay_TESTOUT),
    .WRENABLE (delay_WRENABLE),
    .BURSTPENDING (delay_BURSTPENDING),
    .BURSTPENDINGPHY (delay_BURSTPENDINGPHY),
    .COUNTERLOADEN (delay_COUNTERLOADEN),
    .COUNTERLOADVAL (delay_COUNTERLOADVAL),
    .COUNTERREADEN (delay_COUNTERREADEN),
    .DIVIDERST (delay_DIVIDERST),
    .EDGEADV (delay_EDGEADV),
    .ENCALIB (delay_ENCALIB),
    .ENCALIBPHY (delay_ENCALIBPHY),
    .ENSTG1 (delay_ENSTG1),
    .ENSTG1ADJUSTB (delay_ENSTG1ADJUSTB),
    .FINEENABLE (delay_FINEENABLE),
    .FINEINC (delay_FINEINC),
    .FREQREFCLK (delay_FREQREFCLK),
    .MEMREFCLK (delay_MEMREFCLK),
    .PHASEREFCLK (delay_PHASEREFCLK),
    .RANKSEL (delay_RANKSEL),
    .RANKSELPHY (delay_RANKSELPHY),
    .RST (delay_RST),
    .RSTDQSFIND (delay_RSTDQSFIND),
    .SCANCLK (delay_SCANCLK),
    .SCANENB (delay_SCANENB),
    .SCANIN (delay_SCANIN),
    .SCANMODEB (delay_SCANMODEB),
    .SELCALORSTG1 (delay_SELCALORSTG1),
    .STG1INCDEC (delay_STG1INCDEC),
    .STG1LOAD (delay_STG1LOAD),
    .STG1READ (delay_STG1READ),
    .STG1REGL (delay_STG1REGL),
    .SYNCIN (delay_SYNCIN),
    .SYSCLK (delay_SYSCLK),
    .TESTIN (delay_TESTIN),
    .GSR (delay_GSR)
  );

  specify
    $period (posedge FREQREFCLK, 0:0:0, notifier);
    $period (posedge MEMREFCLK, 0:0:0, notifier);
    $period (posedge PHASEREFCLK, 0:0:0, notifier);
    $period (posedge SYNCIN, 0:0:0, notifier);
    $period (posedge SYSCLK, 0:0:0, notifier);
    $setuphold (posedge SYSCLK, negedge COUNTERLOADEN, 0:0:0, 0:0:0, notifier,,, delay_SYSCLK, delay_COUNTERLOADEN);
    $setuphold (posedge SYSCLK, negedge COUNTERLOADVAL, 0:0:0, 0:0:0, notifier,,, delay_SYSCLK, delay_COUNTERLOADVAL);
    $setuphold (posedge SYSCLK, negedge COUNTERREADEN, 0:0:0, 0:0:0, notifier,,, delay_SYSCLK, delay_COUNTERREADEN);
    $setuphold (posedge SYSCLK, negedge DIVIDERST, 0:0:0, 0:0:0, notifier,,, delay_SYSCLK, delay_DIVIDERST);
    $setuphold (posedge SYSCLK, negedge EDGEADV, 0:0:0, 0:0:0, notifier,,, delay_SYSCLK, delay_EDGEADV);
    $setuphold (posedge SYSCLK, negedge FINEENABLE, 0:0:0, 0:0:0, notifier,,, delay_SYSCLK, delay_FINEENABLE);
    $setuphold (posedge SYSCLK, negedge FINEINC, 0:0:0, 0:0:0, notifier,,, delay_SYSCLK, delay_FINEINC);
    $setuphold (posedge SYSCLK, negedge RANKSEL, 0:0:0, 0:0:0, notifier,,, delay_SYSCLK, delay_RANKSEL);
    $setuphold (posedge SYSCLK, posedge COUNTERLOADEN, 0:0:0, 0:0:0, notifier,,, delay_SYSCLK, delay_COUNTERLOADEN);
    $setuphold (posedge SYSCLK, posedge COUNTERLOADVAL, 0:0:0, 0:0:0, notifier,,, delay_SYSCLK, delay_COUNTERLOADVAL);
    $setuphold (posedge SYSCLK, posedge COUNTERREADEN, 0:0:0, 0:0:0, notifier,,, delay_SYSCLK, delay_COUNTERREADEN);
    $setuphold (posedge SYSCLK, posedge DIVIDERST, 0:0:0, 0:0:0, notifier,,, delay_SYSCLK, delay_DIVIDERST);
    $setuphold (posedge SYSCLK, posedge EDGEADV, 0:0:0, 0:0:0, notifier,,, delay_SYSCLK, delay_EDGEADV);
    $setuphold (posedge SYSCLK, posedge FINEENABLE, 0:0:0, 0:0:0, notifier,,, delay_SYSCLK, delay_FINEENABLE);
    $setuphold (posedge SYSCLK, posedge FINEINC, 0:0:0, 0:0:0, notifier,,, delay_SYSCLK, delay_FINEINC);
    $setuphold (posedge SYSCLK, posedge RANKSEL, 0:0:0, 0:0:0, notifier,,, delay_SYSCLK, delay_RANKSEL);
    $width (posedge FREQREFCLK, 0:0:0, 0, notifier);
    $width (posedge MEMREFCLK, 0:0:0, 0, notifier);
    $width (posedge PHASEREFCLK, 0:0:0, 0, notifier);
    $width (posedge RST, 0:0:0, 0, notifier);
    $width (posedge SYNCIN, 0:0:0, 0, notifier);
    $width (posedge SYSCLK, 0:0:0, 0, notifier);
    ( FREQREFCLK *> ICLK) = (10:10:10, 10:10:10);
    ( FREQREFCLK *> ICLKDIV) = (10:10:10, 10:10:10);
    ( FREQREFCLK *> RCLK) = (10:10:10, 10:10:10);
    ( PHASEREFCLK *> ICLK) = (10:10:10, 10:10:10);
    ( PHASEREFCLK *> ICLKDIV) = (10:10:10, 10:10:10);
    ( PHASEREFCLK *> ISERDESRST) = (10:10:10, 10:10:10);
    ( PHASEREFCLK *> RCLK) = (10:10:10, 10:10:10);
    ( SYSCLK *> COUNTERREADVAL) = (10:10:10, 10:10:10);
    ( SYSCLK *> FINEOVERFLOW) = (10:10:10, 10:10:10);

    specparam PATHPULSE$ = 0;
  endspecify
endmodule // X_PHASER_IN
