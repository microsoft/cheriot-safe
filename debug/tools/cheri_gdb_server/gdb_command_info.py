GDB_CMD_KEYWORDS = ["set"]

COMMAND = 0
COMMAND_REGISTER = 1
COMMAND_VALUE = 2
COMMAND_REGISTER_VALUE = 3
COMMAND_VALUE_BP = 4
COMMAND_LOAD_MEM = 5




GDB_CMD_KEYWORD_TO_RSP = {"set"     : "P",
                          "print"   : "p",
                          "p"       : "p",
                          "g"       : "g",
                          "info registers" : "g",
                          "G" : "G",
                          "load" : "X"}


RSP_COMMAND_COMPONENTS = {"P" : COMMAND_REGISTER_VALUE,
                          "p" : COMMAND_REGISTER,
                          "g" : COMMAND,
                          "G" : COMMAND_VALUE,
                          "c" : COMMAND,
                          "s" : COMMAND,
                          "Z0": COMMAND_VALUE_BP,
                          "z0": COMMAND_VALUE_BP,
                          "Hc0" : COMMAND,
                          "vCont?" : COMMAND,
                          "vCont;c" : COMMAND,
                          "vCont;s:0;c:0" : COMMAND,
                          "qXfer:threads:read::0,1000" : COMMAND,
                          "vCont;s:0;c" : COMMAND,
                          "vCont;s" : COMMAND,
                          "vCont;c:0;s:0" : COMMAND,
                          "vCont;c:0" : COMMAND,
                          "X" : COMMAND_LOAD_MEM}




CMD_KEYWORD_INDEX = 0
REG_KEYWORD_INDEX = 1
VAL_KEYWORD_INDEX = 2


TEMP_WRITE_ALL_DATA = "G=0x11111111FFFFFFFFFFFFFFFF1111111111111111FFFFFFFFFFFFFFFF1111111111111111FFFFFFFF" \
              "11111111FFFFFFFFFFFFFFFF1111111111111111FFFFFFFFFFFFFFFF1111111111111111FFFFFFFF" \
              "11111111FFFFFFFFFFFFFFFF1111111111111111FFFFFFFFFFFFFFFF1111111111111111FFFFFFFF" \
              "11111111FFFFFFFFFFFFFFFF1111111111111111FFFFFFFFFFFFFFFF1111111111111111FFFFFFFF" \
              "11111111FFFFFFFFFFFFFFFF1111111111111111FFFFFFFFFFFFFFFF1111111111111111FFFFFFFF" \
              "11111111FFFFFFFFFFFFFFFF1111111111111111FFFFFFFFFFFFFFFF1111111111111111FFFFFFFF" \
              "11111111FFFFFFFFFFFFFFFF1111111111111111FFFFFFFF"
