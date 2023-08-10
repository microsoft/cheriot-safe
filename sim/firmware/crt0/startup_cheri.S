.macro ZERO reg
	cmove			\reg, cnull
.endm

.macro LA_ABS reg, symbol
	lui				\reg, %hi(\symbol)
	addi			\reg, \reg, %lo(\symbol)
.endm

#include <cheri.h>

	.section .boot.init1, "ax", @progbits
	.p2align 2
	.global __start
	.type __start,@function
__start:
	# First, zero all general purpose registers.
	ZERO c1
	ZERO c2
	ZERO c3
	ZERO c4
	ZERO c5
	ZERO c6
	ZERO c7
	ZERO c8
	ZERO c9
	ZERO c10
	ZERO c11
	ZERO c12
	ZERO c13
	ZERO c14
	ZERO c15

	# Prepare the stack capability.
	cspecialr		cs0, mtdc
	# Stack needs no global permission.
	li				a1, ~CHERI_PERM_GLOBAL
	candperm		ca0, cs0, a1
	LA_ABS			a1, _stack_end
	LA_ABS			a2, _stack_start
	sub				a2, a2, a1
	csetaddr		ca0, ca0, a1
	csetbounds		ca0, ca0, a2
	cincoffset		csp, ca0, a2

	# Then, prepare the CGP.
	#li				a1, ~CHERI_PERM_STORE_LOCAL
	li				a1, ~0
	candperm		ca0, cs0, a1
	LA_ABS			a1, _cgp_start
	LA_ABS			a2, _cgp_end
	sub				a2, a2, a1
	csetaddr		ca0, ca0, a1
	csetbounds		ca0, ca0, a2
	# Address of CGP must point at the middle.
	srli			a2, a2, 1
	cincoffset		cgp, ca0, a2

	# Prepare the PCC.
	auipcc			cs1, 0
	LA_ABS			a1, _pcc_start
	LA_ABS			a2, _pcc_end
	sub				a2, a2, a1
	csetaddr		ca0, cs1, a1
	csetbounds		ca0, ca0, a2
	LA_ABS			a1, cstart
	csetaddr		cra, ca0, a1

	# Pass the three roots as arguments.
	# First arg is the almighty PCC.
	cmove			ca0, cs1

	# Second is the almighty memory cap.
	cmove			ca1, cs0

	# Third is the heap cap.
	LA_ABS			a3, _heap_start
	csetaddr		ca2, ca1, a3

	# Fourth is the length of the heap.
	LA_ABS			a4, _heap_end
	sub				a3, a4, a3

	# Fifth is the cap_relocs
	LA_ABS			a5, __cap_relocs
	csetaddr		ca4, ca1, a5

	# Sixth is the number of cap_reloc entries.
	LA_ABS			t0, __cap_relocs_end
	sub				a5, t0, a5
	li				t0, 20
	divu			a5, a5, t0

	# Jump to the entry point.
	cjalr			cra
	# Should not return. Trap.
	unimp
.size __start, . - __start
