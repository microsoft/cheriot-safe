

typedef struct packed {
  logic [3:0]                     region;
  logic [AXI_USER_WIDTH-1:0]      user;
  logic [AXI_MGR_ID_WIDTH-1:0]    id;
  logic [AXI_ADDR_WIDTH-1:0]      addr;
  logic [AXI_LEN_WIDTH-1:0]       len;
  logic [2:0]                     size;
  logic [1:0]                     burst;
  logic [3:0]                     cache;
  logic [1:0]                     lock;
  logic [2:0]                     prot;
  logic [3:0]                     qos;
  logic [MGR_ID_BITS-1:0]         mgrnum;
} ADDR_PHASE_t;

typedef struct packed {
  logic [AXI_MGR_ID_WIDTH-1:0]    id;
  logic [AXI_DATA_WIDTH-1:0]      data;
  logic [(AXI_DATA_WIDTH/8)-1:0]  strb;
  logic                           last;
  logic [MGR_ID_BITS-1:0]         mgrnum;
} WDATA_PHASE_t;

typedef struct packed {
  logic [AXI_MGR_ID_WIDTH-1:0]    id;
  logic [AXI_DATA_WIDTH-1:0]      data;
  logic                           last;
  logic [1:0]                     resp;
  logic [MGR_ID_BITS-1:0]         mgrnum;
  //logic [$clog2(NUM_SLAVES)-1:0]  slvnum;
} RDATA_PHASE_t;

typedef struct packed {
  logic [AXI_MGR_ID_WIDTH-1:0]    id;
  logic [1:0]                     resp;
  logic [MGR_ID_BITS-1:0]         mgrnum;
} RESP_PHASE_t;


