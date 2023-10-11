// Copyright (C) Microsoft Corporation. All rights reserved.



module IOBUF #(
    parameter DRIVE = 12,
    parameter IBUF_LOW_PWR = "TRUE", 
    parameter IOSTANDARD = "DEFAULT",
    parameter SLEW = "SLOW"
    ) (
    output O,
    inout IO,
    input I,
    input T
);


assign IO = (T) ? 1'bz : I;
assign O = IO;

endmodule
