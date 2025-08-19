Currently the following tests are supported.
- hello_world_cheri.
  -- cd tests
  -- ../scripts/build_test.sh hello_word_cheri
- hello_world_rv32.
  -- cd tests
  -- ../scripts/build_test_rv32.sh hello_word_rv32
- coremark.
  -- cd tests
  -- for cheriot, ../scripts/build_coremark.sh
  -- for rv32, ../scripts/build_coremark_rv32.sh
- cheri_sanity.
  -- cd tests
  -- ../scripts/build_test.sh cheri_sanity
- cheri_eth 
  -- needs more clean-up (this test only works on the actual FPGA board, not in simuation)

The output hex images are placed under tests/bin. You may need to change the tool paths in the compilation scripts to match your setup.
