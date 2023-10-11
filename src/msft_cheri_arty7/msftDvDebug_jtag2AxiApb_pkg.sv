

package msftDvDebug_jtag2AxiApb_pkg;


parameter DR_MAX_WIDTH       = 192;

parameter AXI_CMD_WIDTH = 192;
parameter AXI_SCMD_WIDTH = 73;
typedef struct packed {
  logic [21:0]                    rsvd;
  logic                           auto_increment;
  logic                           write;
  logic                           read;
  logic [2:0]                     prot;
  logic [3:0]                     qos;
  logic [63:0]                    addr;
  logic [3:0]                     cache;
  logic [1:0]                     lock;
  logic [1:0]                     burst;
  logic [7:0]                     length;
  logic [3:0]                     id;
  logic [2:0]                     size;
  logic                           last;
  logic [7:0]                     strobe;
  logic [63:0]                    data;
} JTAG_AXI_DATA_t;


parameter AXI_RESP_WIDTH = 67;
typedef struct packed {
  logic           done;
  logic [1:0]     resp;
  logic [63:0]    data;
} JTAG_AXI_RESP_t;


parameter APB_CMD_SHIFT_WIDTH = 88;
parameter APB_SCMD_SHIFT_WIDTH = 49;
parameter APB_CMD_WIDTH = 88;
parameter APB_SCMD_WIDTH = 49;
typedef struct packed {
  logic [31:0]  addr;
  logic [4:0]   rsvd;
  logic         d32bit;
  logic         write;
  logic         read;
  logic [47:0]  data;
} JTAG_APB_DATA_t;

parameter APB_RESP_WIDTH = 49;
typedef struct packed {
  logic         suberr;
  logic [47:0]  data;
} JTAG_APB_RESP_t;

endpackage

