///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2010 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 13.1
//  \   \         Description : Xilinx Timing Simulation Library Component
//  /   /                  3-State Diffential Signaling I/O Buffer
// /___/   /\     Filename : X_IOBUFDS_DIFF_OUT_DCIEN.v
// \   \  /  \    Timestamp : Thu Apr 29 14:59:30 PDT 2010
//  \___\/\___\
//
// Revision:
//    04/29/10 - Initial version.
// End Revision

`timescale  1 ps / 1 ps


module X_IOBUFDS_DIFF_OUT_DCIEN (O, OB, IO, IOB, DCITERMDISABLE, I, IBUFDISABLE, TM, TS);

    parameter DIFF_TERM = "FALSE";
    parameter IBUF_LOW_PWR = "TRUE";
    parameter IOSTANDARD = "DEFAULT";
    parameter LOC = "UNPLACED";

    output O;
    output OB;
    inout  IO;
    inout  IOB;
    input  DCITERMDISABLE;
    input  I;
    input  IBUFDISABLE;
    input  TM;
    input  TS;

    wire t1, t2;

    tri0 GTS = glbl.GTS;

    or O1 (t1, GTS, TM);
    bufif0 B1 (IO, I, t1);

    or O2 (t2, GTS, TS);
    notif0 N2 (IOB, I, t2);

    and a1 (disable_out, DCITERMDISABLE, IBUFDISABLE);
    reg O_int, OB_int;

    initial begin
	
        case (DIFF_TERM)

            "TRUE", "FALSE" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute DIFF_TERM on X_IOBUFDS_DIFF_OUT_DCIEN instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", DIFF_TERM);
                          $finish;
                      end

        endcase // case(DIFF_TERM)
        case (IBUF_LOW_PWR)

            "FALSE", "TRUE" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute IBUF_LOW_PWR on X_IOBUFDS_DIFF_OUT_DCIEN instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", IBUF_LOW_PWR);
                          $finish;
                      end

        endcase

    end


    always @(IO or IOB) begin
        if (IO == 1'b1 && IOB == 1'b0) begin
            O_int  = IO;
            OB_int = ~IO;
        end
        else if (IO == 1'b0 && IOB == 1'b1) begin
            O_int  = IO;
            OB_int = ~IO;
        end
        else begin
            O_int  = 1'bx;
            OB_int = 1'bx;
        end
    end

    assign O = (disable_out == 1) ? 1 : (disable_out == 0) ? O_int : 1'bx;
    assign OB = (disable_out == 1) ? 1 : (disable_out == 0) ? OB_int : 1'bx;

    specify
        (DCITERMDISABLE => O)   = (0:0:0,  0:0:0);
        (DCITERMDISABLE => OB)  = (0:0:0,  0:0:0);
        (DCITERMDISABLE => IO)  = (0:0:0,  0:0:0);
        (DCITERMDISABLE => IOB) = (0:0:0,  0:0:0);
        (I => O)                = (0:0:0,  0:0:0);
        (I => OB)               = (0:0:0,  0:0:0);
        (I => IO)               = (0:0:0,  0:0:0);
        (I => IOB)              = (0:0:0,  0:0:0);
        (IO => O)               = (0:0:0,  0:0:0);
        (IO => OB)              = (0:0:0,  0:0:0);
        (IO => IOB)             = (0:0:0,  0:0:0);
        (IOB => O)              = (0:0:0,  0:0:0);
        (IOB => OB)             = (0:0:0,  0:0:0);
        (IOB => IO)             = (0:0:0,  0:0:0);
        (IBUFDISABLE => O)      = (0:0:0,  0:0:0);
        (IBUFDISABLE => OB)     = (0:0:0,  0:0:0);
        (IBUFDISABLE => IO)     = (0:0:0,  0:0:0);
        (IBUFDISABLE => IOB)    = (0:0:0,  0:0:0);
        (TM => O)               = (0:0:0,  0:0:0);
        (TM => OB)              = (0:0:0,  0:0:0);
        (TM => IO)              = (0:0:0,  0:0:0);
        (TM => IOB)             = (0:0:0,  0:0:0);
        (TS => O)               = (0:0:0,  0:0:0);
        (TS => OB)              = (0:0:0,  0:0:0);
        (TS => IO)              = (0:0:0,  0:0:0);
        (TS => IOB)             = (0:0:0,  0:0:0);
        specparam PATHPULSE$ = 0;
    endspecify

    
endmodule
