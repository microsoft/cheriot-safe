
extern "C" int eth_init(int);
extern "C" unsigned int *get_eth_base(void);
extern "C" int eth_mdio_test(int);
extern "C" int eth_raw_lpbk_test(int);
extern "C" int eth_wait(int);

unsigned int mdio_write(unsigned int, unsigned int);
unsigned int mdio_read(unsigned int);

void dump_phy_regs(void);
void dump_mac_regs(void);

int dump_rx_buf(unsigned int, unsigned int);

int send_tx_frame(unsigned int);
int find_rx_frame(void);
int check_rx_frame(unsigned int,  unsigned int);
void release_rx_buf(unsigned int);
