CAPABILITY_SIZE = 32
REGISTER_SIZE = 32
EXPONENT_BIT_SIZE = 4

TOP_LOWER_BIT = 0
TOP_UPPER_BIT = 8

BASE_LOWER_BIT = 9
BASE_UPPER_BIT = 17

EXPO_LOWER_BIT = 18
EXPO_UPPER_BIT = 21

OTYPE_LOWER_BIT = 22
OTYPE_UPPER_BIT = 24

PERMISSION_LOWER_BIT = 25
PERMISSION_UPPER_BIT = 30

RESERVED_LOWER_BIT = 31
RESERVED_UPPER_BIT = 31

NUM_PERMISSION_BITS = 6

PERMISSION_GL_BIT_INDEX = 5
GL_BIT_INDEX = 5

PERMISSION_SL_SR_U0_BIT_INDEX = 2
SL_BIT = 2
SR_BIT = 2
U0_BIT = 2

PERMISSION_LM_LD_SE_BIT_INDEX = 1
LM_BIT = 1
LD_BIT = 1
SE_BIT = 1

PERMISSION_LG_SD_US_BIT_INDEX = 0
LG_BIT = 0
SD_BIT = 0
US_BIT = 0

PERMISSION_NAME_LIST = ["U1", "U0", "SE", "US", "EX", "SR", "MC", "LD", "SL", "LM", "SD", "LG", "GL"]

NINE_BIT_MASK = 0x1FF

NUMBER_BITS_FOR_TOP_BASE = 9

EXPONENT_MAX_LENGTH_DICT = {0 : 511,
                            1 : 1022,
                            2 : 2044,
                            3 : 4088,
                            4 : 8176,
                            5 : 16352,
                            6 : 32704,
                            7 : 65408,
                            8 : 130816,
                            9 : 261632,
                            10 : 523264,
                            11 : 1046528,
                            12 : 2093056,
                            13 : 4186112,
                            14 : 8372224,
                            24 : 8573157376}


REG_NAME_TO_VALUE = { "$ra" : 1,
                      "$sp" : 2,
                      "$gp" : 3,
                      "$tp" : 4,
                      "$t0" : 5,
                      "$t1" : 6,
                      "$t2" : 7,
                      "$fp" : 8,
                      "$s1" : 9,
                      "$a0" : 10,
                      "$a1" : 11,
                      "$a2" : 12,
                      "$a3" : 13,
                      "$a4": 14,
                      "$a5": 15,
                      "$a6": 16,
                      "$a7": 17,
                      "$s2": 18,
                      "$s3": 19,
                      "$s4": 20,
                      "$s5": 21,
                      "$s6": 22,
                      "$s7": 23,
                      "$s8": 24,
                      "$s9": 25,
                      "$s10": 26,
                      "$s11": 27,
                      "$t3": 28,
                      "$t4": 29,
                      "$t5": 30,
                      "$t6": 31,
                      "$pc": 32}