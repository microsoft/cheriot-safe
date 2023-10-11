// Copyright (C) Microsoft Corporation. All rights reserved.



module OBUF #(
    parameter DRIVE = 12,
    parameter IOSTANDARD = "DEFAULT",
    parameter SLEW = "SLOW"
    ) (
    output O,
    input I
);


assign O = I;

endmodule
