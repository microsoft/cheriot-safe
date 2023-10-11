// Copyright (C) Microsoft Corporation. All rights reserved.



module IBUF #(
    parameter IBUF_LOW_PWR = "TRUE", 
    parameter IOSTANDARD = "DEFAULT"
    ) (
    output O,
    input I
);


assign O = I;

endmodule
