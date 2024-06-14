from register_info import *

#############################################################################################################
# This class is responsible for decoding the CHERI Capabilities.
#############################################################################################################
class CHERI_Decoder:

    def __init__(self):
        self.exponent = 0
        self.addr_hi = 0
        self.addr_mid = 0

        self.top_cor = 0
        self.top = 0

        self.base_cor = 0
        self.base = 0

        self.full_top = 0
        self.full_base = 0

        self.permissions_string = 0

        self.permissions_dict = { "U1" : 0,
                                  "U0" : 0,
                                  "SE" : 0,
                                  "US" : 0,
                                  "EX" : 0,
                                  "SR" : 0,
                                  "MC" : 0,
                                  "LD" : 0,
                                  "SL" : 0,
                                  "LM" : 0,
                                  "SD" : 0,
                                  "LG" : 0,
                                  "GL" : 0}


    ####################################################################################################
    # This function is responsible for decompressing the bounds of a CHERI Capability
    #
    # Inputs:
    #   reg_address: 32 bit value that is stored in the GPR
    #   reg_capabilities: The Capability associated with the above register
    #
    # Outputs:
    #   self.full_top: Uncompressed upper bound for the pointer
    #   self.full_base: Uncompressed lower bound for the pointer
    ####################################################################################################
    def decode_bounds(self, reg_address, reg_capabilities):
        self.extract_exponent(reg_capabilities)
        self.extract_upper_address(self.exponent, reg_address)
        self.extract_mid_address(self.exponent, reg_address)
        self.build_correction(reg_capabilities, self.addr_mid)
        self.calc_bounds(self.addr_hi, self.top_cor, self.base_cor, self.top, self.base, self.exponent)

        self.extract_permissions_from_capability(reg_capabilities)
        self.decode_permissions(self.permissions_string)



        return self.full_top, self.full_base


    ####################################################################################################
    # This function is responsible extracting the exponent from a Capability
    # The exponent is a 4 bit field in the Capability register
    #
    # Inputs:
    #   capability: The Capability associated with a GPR (Hex String)
    #
    # Outputs:
    #   self.exponent: Decoded exponent from the Capability
    ####################################################################################################
    def extract_exponent(self, capability):
        # Convert Hex string into integer -> Convert integer to binary string -> Pad the binary string with 0s
        binary_capability = bin(int(capability, 16))[2:].zfill(CAPABILITY_SIZE)

        # Isolate the exponent field of the register
        self.exponent = binary_capability[CAPABILITY_SIZE - 1 - EXPO_UPPER_BIT: CAPABILITY_SIZE - EXPO_LOWER_BIT]

        # Convert string into integer
        self.exponent = int(self.exponent, 2)

        if self.exponent == 15:
            self.exponent = 24

        return self.exponent

    ####################################################################################################
    # This function is responsible extracting the compressed top field of the capability
    #
    # Inputs:
    #   address: 32 bit value that is stored in the GPR
    #   exponent: Decoded exponent from the Capability
    #
    # Outputs:
    #   self.addr_hi: The nine bits associated with the upper bounds of the pointer
    ####################################################################################################
    def extract_upper_address(self, exponent, address):
        # Convert Hex string into integer -> Convert integer to binary string -> Pad the binary string with 0s
        binary_address = bin(int(address, 16))[2:].zfill(CAPABILITY_SIZE)

        # This is padding because the theoretical max bounds for a pointer are 0x0 -> 0x100000000
        binary_address = "0" + binary_address

        if exponent == 24:
            self.addr_hi = 0
        else:
            addr_hi_bits = binary_address[0: 24 - exponent]
            self.addr_hi = int(addr_hi_bits, 2)

        return self.addr_hi

    ####################################################################################################
    # This function is responsible extracting a certain number of bits from the address depending on
    # the exponent field. The lower the exponent the bounds are be more granular
    #
    # Inputs:
    #   address: 32 bit value that is stored in the GPR
    #   exponent: Decoded exponent from the Capability
    #
    # Outputs:
    #   self.addr_hi: A section of 9 bits associated with the bounds of a pointer
    ####################################################################################################
    def extract_mid_address(self, exponent, address):
        # Convert Hex string into integer -> Convert integer to binary string -> Pad the binary string with 0s
        binary_address = bin(int(address, 16))[2:].zfill(CAPABILITY_SIZE)
        binary_address = "0" + binary_address

        self.addr_mid = binary_address[24 - exponent : 33 - exponent]
        self.addr_mid = int(self.addr_mid, 2)

        return self.addr_mid

    ####################################################################################################
    # This function is responsible for building a correction that will be used when calculating lower
    # and upper bounds.
    #
    # Inputs:
    #   capability: The Capability associated with a GPR (Hex String)
    #   addr_mid: A section of 9 bits associated with the bounds of a pointer
    #
    # Outputs:
    #   self.base_cor: The correction for the lower bound
    #   self.top_cor: The correction for the upper bound
    ####################################################################################################
    def build_correction(self, capability, addr_mid):
        # Convert Hex string into integer -> Convert integer to binary string -> Pad the binary string with 0s
        binary_capability = bin(int(capability, 16))[2:].zfill(CAPABILITY_SIZE)

        # Extract the Top and base fields from the Capabilities register
        self.top = binary_capability[CAPABILITY_SIZE - 1 - TOP_UPPER_BIT: CAPABILITY_SIZE - TOP_LOWER_BIT]
        self.base = binary_capability[CAPABILITY_SIZE - 1 - BASE_UPPER_BIT: CAPABILITY_SIZE - BASE_LOWER_BIT]

        # Convert Binary string to integer
        self.top = int(self.top, 2)
        self.base = int(self.base, 2)

        if (self.top < self.base) and (addr_mid < self.base):
            self.top_cor = 0

        elif (self.top >= self.base) and (addr_mid >= self.base):
            self.top_cor = 0

        elif (self.top < self.base) and (addr_mid >= self.base):
            self.top_cor = 1

        else:
            self.top_cor = -1

        if addr_mid < self.base:
            self.base_cor = -1
        else:
            self.base_cor = 0

        return self.base_cor, self.top_cor

    ####################################################################################################
    # This function is responsible for Calculating the uncompressed upper and lower bounds of the
    # Capability register.
    #
    # Inputs:
    #   addr_hi: A section of 9 bits associated with the bounds of a pointer
    #   top_cor: The correction for the lower bound
    #   base_cor: The correction for the upper bound
    #   top: 9 bit field from the Capability register that help indicate the upper bounds
    #   base: 9 bit field from the Capability register that help indicate the lower bounds
    #   exp: 4 bit exponent field
    #
    # Outputs:
    #   self.full_top: Uncompressed Upper bound for the pointer
    #   self.full_base: Uncompressed lower bound for the pointer
    ####################################################################################################
    def calc_bounds(self, addr_hi, top_cor, base_cor, top, base, exp):
        self.full_top = ((addr_hi + top_cor) << (9 + exp)) + (top << exp)
        self.full_base = ((addr_hi + base_cor) << (9 + exp)) + (base << exp)


    ####################################################################################################
    # This function is responsible extracting the compressed permissions field of the capability
    #
    # Inputs:
    #   capability: The Capability associated with a GPR (Hex String)
    #
    # Outputs:
    #   self.permissions_string: A string that contains the 6 bits used for deciding permissions for
    #                            a pointer
    ####################################################################################################
    def extract_permissions_from_capability(self, capability):


        # Convert Hex string into integer -> Convert integer to binary string -> Pad the binary string with 0s
        binary_capability = bin(int(capability, 16))[2:].zfill(CAPABILITY_SIZE)

        self.permissions_string = binary_capability[CAPABILITY_SIZE - 1 - PERMISSION_UPPER_BIT: CAPABILITY_SIZE - PERMISSION_LOWER_BIT]

        return self.permissions_string

    ####################################################################################################
    # This function is responsible decoding the compressed permissions
    #
    # Inputs:
    #   permissions: A binary string that contains the 6 bits of permissions
    #
    # Outputs:
    #   self.permissions_dict: Dictionary with updated permissions
    #
    ####################################################################################################
    def decode_permissions(self, permissions):

        # Set all bits in the register to 0 this will clear changes from the previous decoding
        for perms in self.permissions_dict:
            self.permissions_dict[perms] = 0

        self.permissions_dict["GL"] = int(permissions[NUM_PERMISSION_BITS - 1 - PERMISSION_GL_BIT_INDEX], 2)

        perm_bits_4_3 = permissions[1:3]
        perm_bits_4_2 = permissions[1:4]
        perm_bits_4_0 = permissions[1:6]

        perm_bits_4_3 = int(perm_bits_4_3, 2)
        perm_bits_4_2 = int(perm_bits_4_2, 2)
        perm_bits_4_0 = int(perm_bits_4_0, 2)

        if perm_bits_4_3 == 3:
            self.permissions_dict["LD"] = 1
            self.permissions_dict["MC"] = 1
            self.permissions_dict["SD"] = 1
            self.permissions_dict["LG"] = int(permissions[NUM_PERMISSION_BITS - 1 - PERMISSION_LG_SD_US_BIT_INDEX], 2)
            self.permissions_dict["LM"] = int(permissions[NUM_PERMISSION_BITS - 1 - PERMISSION_LM_LD_SE_BIT_INDEX], 2)
            self.permissions_dict["SL"] = int(permissions[NUM_PERMISSION_BITS - 1 - PERMISSION_SL_SR_U0_BIT_INDEX], 2)

        elif perm_bits_4_2 == 5:
            self.permissions_dict["LD"] = 1
            self.permissions_dict["MC"] = 1
            self.permissions_dict["LG"] = int(permissions[NUM_PERMISSION_BITS - 1 - PERMISSION_LG_SD_US_BIT_INDEX], 2)
            self.permissions_dict["LM"] = int(permissions[NUM_PERMISSION_BITS - 1 - PERMISSION_LM_LD_SE_BIT_INDEX], 2)

        elif perm_bits_4_0 == 16:
            self.permissions_dict["SD"] = 1
            self.permissions_dict["MC"] = 1

        elif perm_bits_4_2 == 4:
            self.permissions_dict["SD"] = int(permissions[NUM_PERMISSION_BITS - 1 - PERMISSION_LG_SD_US_BIT_INDEX], 2)
            self.permissions_dict["LD"] = int(permissions[NUM_PERMISSION_BITS - 1 - PERMISSION_LM_LD_SE_BIT_INDEX], 2)

        elif perm_bits_4_3 == 1:
            self.permissions_dict["EX"] = 1
            self.permissions_dict["MC"] = 1
            self.permissions_dict["LD"] = 1
            self.permissions_dict["LG"] = int(permissions[NUM_PERMISSION_BITS - 1 - PERMISSION_LG_SD_US_BIT_INDEX], 2)
            self.permissions_dict["LM"] = int(permissions[NUM_PERMISSION_BITS - 1 - PERMISSION_LM_LD_SE_BIT_INDEX], 2)
            self.permissions_dict["SR"] = int(permissions[NUM_PERMISSION_BITS - 1 - PERMISSION_SL_SR_U0_BIT_INDEX], 2)

        elif perm_bits_4_0 == 0:
            self.permissions_dict["US"] = int(permissions[NUM_PERMISSION_BITS - 1 - PERMISSION_LG_SD_US_BIT_INDEX], 2)
            self.permissions_dict["SE"] = int(permissions[NUM_PERMISSION_BITS - 1 - PERMISSION_LM_LD_SE_BIT_INDEX], 2)
            self.permissions_dict["U0"] = int(permissions[NUM_PERMISSION_BITS - 1 - PERMISSION_SL_SR_U0_BIT_INDEX], 2)

        else:
            print("ERROR: Invalid Permissions!")

        return self.permissions_dict

    ####################################################################################################
    # This function is responsible for clearing the permissions list
    ####################################################################################################
    def clear_permissions(self):
        # Set all bits in the register to 0 this will clear changes from the previous decoding
        for perms in self.permissions_dict:
            self.permissions_dict[perms] = 0












