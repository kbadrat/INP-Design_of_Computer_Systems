// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/versclibs/data/simprims/X_INV.v,v 1.5 2005/03/14 21:05:15 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 8.1i (I.13)
//  \   \         Description : Xilinx Timing Simulation Library Component
//  /   /                  Inverter
// /___/   /\     Filename : X_INV.v
// \   \  /  \    Timestamp : Thu Mar 25 16:43:55 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    03/11/05 - Add LOC paramter;
// End Revision

`timescale 1 ps/1 ps

module X_INV (O, I);

  parameter LOC = "UNPLACED";
  output O;
  input I;

  not (O, I);

  specify

	(I => O) = (0:0:0, 0:0:0);
	specparam PATHPULSE$ = 0;

  endspecify

endmodule
