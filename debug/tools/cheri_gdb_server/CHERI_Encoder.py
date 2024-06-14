from register_info import *

#############################################################################################################
# This class is responsible for Encoding CHERI Capabilities.
#############################################################################################################
class CHERI_Encoder:

    def __init__(self):
        self.exponent = 0
        self.top = 0
        self.base = 0

        self.full_base = 0
        self.full_top = 0

        self.base_top_diff = 0

        self.top_bit_string = None
        self.base_bit_string = None

        self.permissions_string = ""

    ####################################################################################################
    # This function is responsible for creating the 2 compressed fields for the base and top of a
    # pointer. It will also create the exponent field as well
    #
    # Inputs:
    #   full_top: Uncompressed Upper bound for the pointer
    #   full_base: Uncompressed lower bound for the pointer
    #
    # Outputs:
    #   self.top_bit_string: The nine bits associated with the lower bounds of the pointer
    #   self.base_bit_string: The nine bits associated with the lower bounds of the pointer
    #   self.exponent: The exponent that will be stored in the capabilities register
    ####################################################################################################
    def extract_compressed_top_base(self, full_top, full_base):
        self.diff_of_full_base_top(full_top, full_base)
        self.find_correct_exponent(self.base_top_diff)
        self.find_top_nine_bits(self.exponent, full_top)
        self.find_base_nine_bits(self.exponent, full_base)

        return self.top_bit_string, self.base_bit_string, self.exponent




    ####################################################################################################
    # This function is responsible for taking the difference between the full base and top address
    # entered by the user
    #
    # Inputs:
    #   full_top: Uncompressed Upper bound for the pointer
    #   full_base: Uncompressed lower bound for the pointer
    #
    # Outputs:
    #   self.base_top_diff: The difference between the full top and full bottom. Used for calculating
    #                       exponent
    ####################################################################################################
    def diff_of_full_base_top(self, full_top, full_base):
        # full_top_integer = int(full_top, 16)
        # full_base_integer = int(full_base, 16)

        if full_base > full_top:
            print("ERROR: Base Cannot be Bigger then top")
            exit()

        self.base_top_diff = full_top - full_base

        return self.base_top_diff

    ####################################################################################################
    # This function is responsible extracting the exponent from a Capability
    # The exponent is a 4 bit field in the Capability register
    #
    # Inputs:
    #   full_base_top_diff: The difference between the full top and full bottom. Used for calculating
    #                       exponent
    # Outputs:
    #   self.exponent: The exponent that will be stored in the capabilities register
    ####################################################################################################
    def find_correct_exponent(self, full_base_top_diff):
        for expon, max_range in EXPONENT_MAX_LENGTH_DICT.items():

            if full_base_top_diff < max_range:
                self.exponent = expon
                break


        return self.exponent

    ####################################################################################################
    # This function is responsible for creating the nine bit top value that will go inside the
    # capability register
    #
    # Inputs:
    #   top_addi_full: The full top address
    #   exponent: Decoded exponent from the Capability
    #
    # Outputs:
    #   self.top_bit_string: The nine bits associated with the upper bounds of the pointer
    ####################################################################################################
    def find_top_nine_bits(self, exponent, top_addi_full):
        self.top_bit_string = (top_addi_full >> exponent) & NINE_BIT_MASK

        self.top_bit_string = bin(self.top_bit_string)[2:].zfill(NUMBER_BITS_FOR_TOP_BASE)

        return self.top_bit_string

    ####################################################################################################
    # This function is responsible for creating the nine bit base value that will go inside the
    # capability register
    #
    # Inputs:
    #   base_addi_full: The full top address
    #   exponent: Decoded exponent from the Capability
    #
    # Outputs:
    #   self.base_bit_string: The nine bits associated with the lower bounds of the pointer
    ####################################################################################################
    def find_base_nine_bits(self, exponent, base_addi_full):
        self.base_bit_string = (base_addi_full >> exponent) & NINE_BIT_MASK

        self.base_bit_string = bin(self.base_bit_string)[2:].zfill(NUMBER_BITS_FOR_TOP_BASE)

        return self.base_bit_string


    ####################################################################################################
    # This function is responsible for encoding the uncompressed permissions
    #
    # Inputs:
    #   permissions_info_dict: A dictionary that describes the state of all 12 permissions
    #
    # Outputs:
    #   self.permissions_string: The 6 bit compressed permissions that will be stored in the capability
    #                            register
    #
    ####################################################################################################
    def encode_permissions(self, permissions_info_dict):

        # Clear the permissions string
        self.permissions_string = "000000"
        self.permissions_string = list(self.permissions_string)

        self.permissions_string[GL_BIT_INDEX] = str(permissions_info_dict["GL"])

        if permissions_info_dict["LD"] == 1 and permissions_info_dict["MC"] == 1 and permissions_info_dict["SD"] == 1:
            self.permissions_string[4] = "1"
            self.permissions_string[3] = "1"
            self.permissions_string[SL_BIT] = str(permissions_info_dict["SL"])
            self.permissions_string[LM_BIT] = str(permissions_info_dict["LM"])
            self.permissions_string[LG_BIT] = str(permissions_info_dict["LG"])

        elif permissions_info_dict["LD"] == 1 and permissions_info_dict["MC"] == 1:
            self.permissions_string[4] = "1"
            self.permissions_string[3] = "0"
            self.permissions_string[2] = "1"
            self.permissions_string[LM_BIT] = str(permissions_info_dict["LM"])
            self.permissions_string[LG_BIT] = str(permissions_info_dict["LG"])

        elif permissions_info_dict["SD"] == 1 and permissions_info_dict["MC"] == 1:
            self.permissions_string[4] = "1"
            self.permissions_string[3] = "0"
            self.permissions_string[2] = "0"
            self.permissions_string[1] = "0"
            self.permissions_string[0] = "0"

        elif permissions_info_dict["EX"] == 1 and permissions_info_dict["LD"] == 1 and permissions_info_dict["MC"] == 1:
            self.permissions_string[4] = "0"
            self.permissions_string[3] = "1"
            self.permissions_string[SR_BIT] = str(permissions_info_dict["SR"])
            self.permissions_string[LM_BIT] = str(permissions_info_dict["LM"])
            self.permissions_string[LG_BIT] = str(permissions_info_dict["LG"])

        elif permissions_info_dict["LD"] == 1 or permissions_info_dict["SD"] == 1:
            self.permissions_string[4] = "1"
            self.permissions_string[3] = "0"
            self.permissions_string[2] = "0"
            self.permissions_string[LD_BIT] = str(permissions_info_dict["LD"])
            self.permissions_string[SD_BIT] = str(permissions_info_dict["SD"])

        else:
            self.permissions_string[4] = "0"
            self.permissions_string[3] = "0"
            self.permissions_string[U0_BIT] = str(permissions_info_dict["U0"])
            self.permissions_string[SE_BIT] = str(permissions_info_dict["SE"])
            self.permissions_string[US_BIT] = str(permissions_info_dict["US"])

        self.permissions_string = "".join(self.permissions_string)

        return self.permissions_string
