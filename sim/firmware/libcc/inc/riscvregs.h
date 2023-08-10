#ifndef __RISCVREGS_H__
#define __RISCVREGS_H__

#define la_abs(symbol) ({                                                      \
	 size_t val;                                                               \
	 __asm __volatile("lui %0, %%hi(" #symbol ")\n"                            \
			 "addi %0, %0, %%lo(" #symbol ")"                                  \
			 : "=r"(val));                                                     \
	 val;                                                                      \
})

#endif // __RISCVREGS_H__
