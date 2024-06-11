import re
import textwrap
from register_info import *
from CHERI_Encoder import CHERI_Encoder
from CHERI_Decoder import CHERI_Decoder



class RSP_GDB_Translator:

    def __init__(self):
        self.cheri_dec = CHERI_Decoder()

    ####################################################################################################
    # This function is responsible printing the header labels for the register data.
    ####################################################################################################
    def print_register_info_header(self):
        info_reg_top_string = "Name".ljust(7)
        info_reg_top_string += "  Valid".ljust(11)
        info_reg_top_string += "   Value".ljust(13)
        info_reg_top_string += "Reserved".ljust(11)
        info_reg_top_string += "Permission".ljust(13)
        info_reg_top_string += "otype".ljust(8)
        info_reg_top_string += "Exponent".ljust(11)
        info_reg_top_string += "  Base".ljust(12)
        info_reg_top_string += "  Top".ljust(12)
        info_reg_top_string += "   Full Base".ljust(14)
        info_reg_top_string += "   Full Top".ljust(16)

        info_reg_top_string += self.print_permisions_header()

        print(info_reg_top_string)

    ####################################################################################################
    # This function is responsible printing the registers data to the screen 
    ####################################################################################################
    def print_info_registers_string(self, reg_name, reg_value, capability, top_decoded, base_decoded, valid, permissions):
        register_info_string = reg_name.ljust(11)
        register_info_string += str(valid).ljust(7)

        binary_capability = bin(int(capability, 16))[2:].zfill(CAPABILITY_SIZE)

        register_info_string += ("0x" + reg_value).ljust(13)

        register_info_string += ("   " + binary_capability[CAPABILITY_SIZE - 1 - RESERVED_UPPER_BIT]).ljust(11)
        register_info_string += ("  " + binary_capability[
                                        CAPABILITY_SIZE - 1 - PERMISSION_UPPER_BIT: CAPABILITY_SIZE - PERMISSION_LOWER_BIT]).ljust(13)
        register_info_string += (" " + binary_capability[
                                       CAPABILITY_SIZE - 1 - OTYPE_UPPER_BIT: CAPABILITY_SIZE - OTYPE_LOWER_BIT]).ljust(8)
        register_info_string += ("  " + binary_capability[
                                        CAPABILITY_SIZE - 1 - EXPO_UPPER_BIT: CAPABILITY_SIZE - EXPO_LOWER_BIT]).ljust(11)
        register_info_string += binary_capability[
                                CAPABILITY_SIZE - 1 - BASE_UPPER_BIT: CAPABILITY_SIZE - BASE_LOWER_BIT].ljust(12)
        register_info_string += binary_capability[
                                CAPABILITY_SIZE - 1 - TOP_UPPER_BIT: CAPABILITY_SIZE - TOP_LOWER_BIT].ljust(15)

        register_info_string += str(hex(base_decoded)).ljust(14)
        register_info_string += str(hex(top_decoded)).ljust(13)

        register_info_string += self.print_permisions(permissions)

        print(register_info_string)

    ####################################################################################################
    # This function is responsible stripping away the RSP protocol data and just retaining the
    # individual register data
    #
    # Inputs:
    #   rsp_packet: RSP packet that contains registers data
    #
    # Outputs:
    #   self.endian_register_value: Just the register data in HEX
    #
    ####################################################################################################
    def delete_rsp_keep_data(self, rsp_packet):
        rsp_packet_string = str(rsp_packet)
        rsp_packet_string = rsp_packet_string.replace("0x", "")

        if "#" in rsp_packet_string:
            rsp_packet_string = rsp_packet_string[:len(rsp_packet_string)-4]

        if "$" in rsp_packet_string:
            rsp_packet_string = rsp_packet_string[3:]

        return rsp_packet_string


    ####################################################################################################
    # This function is responsible changing the endian of a number sent from OpenOCD.
    #
    # Inputs:
    #   reg_val: The register value from a packet from OpenOCD
    #
    # Outputs:
    #   self.endian_register_value: The register value from a packet from OpenOCD with flipped endian
    #
    ####################################################################################################
    def change_endian(self, reg_val):
        endian_change = str(reg_val)
        endian_change = endian_change.replace("0x", "")
        endian_change = self.delete_rsp_keep_data(endian_change)

        self.endian_register_value = [endian_change[i:i + 2] for i in range(0, len(endian_change), 2)]
        self.endian_register_value = list(reversed(self.endian_register_value))
        self.endian_register_value = "".join(self.endian_register_value)

        return self.endian_register_value


    ####################################################################################################
    # This function is responsible extracting the register data from a packet open OCD
    #
    # Inputs:
    #   packet: The packet of data received from OpenOCD
    #
    # Outputs:
    #   capability: The registers capability stored in HEX
    #   register_value: The registers value stored in HEX
    #   valid: The valid bit for a register
    #
    ####################################################################################################
    def extract_rsp_reg_and_cap(self, packet):

        # Extract the data in between $ and #
        search = re.search("(?<=\$)(.*)(?=#)", packet)
        valid = 0
        cap_and_reg = self.change_endian(search.group()[:16])

        # The first 8 hax characters are the packets capability and the next 8 are the packets value
        capability = cap_and_reg[:8]
        register_value = cap_and_reg[8:16]

        # Check the end of the packet to see if the data is valid
        if search.group()[16:] == "01":
            valid = 1
        elif search.group()[16:] == "00":
            valid = 0
        else:
            print("Something Broke")

        return capability, register_value, valid


    ####################################################################################################
    # This function is responsible figuring out the bounds of a pointer as well as the permissions.
    # This data will also be displayed
    #
    # Inputs:
    #   register_packet: The packet of data received from OpenOCD
    #   reg_name: The name of the register being displayed
    #
    ####################################################################################################
    def uncompress_and_print_register_data(self, register_packet, reg_name):

        reg_capability, reg_value, valid = self.extract_rsp_reg_and_cap(str(register_packet))

        full_top, full_base = self.cheri_dec.decode_bounds(reg_value, reg_capability)
        prem_decoded = self.cheri_dec.decode_permissions(
        self.cheri_dec.extract_permissions_from_capability(reg_capability))

        self.print_info_registers_string(reg_name, reg_value, reg_capability, full_top, full_base, valid, prem_decoded)


    ####################################################################################################
    # This function is responsible printing the permissions in a presentable manner
    #
    # Inputs:
    #   perm_dict: A Dictionary where the permission name is the key
    #
    # Outputs:
    #   permissions_string: Dictionary with updated permissions
    #
    ####################################################################################################
    def print_all_registers(self, all_register_data):


        register_data = self.delete_rsp_keep_data(all_register_data)

        # 8 hex for Register + 8 hex for Capability + 2 hex for Valid tag bit = 18
        register_data = textwrap.wrap(register_data, 18)
        self.print_register_info_header()

        for reg_name, reg_num in REG_NAME_TO_VALUE.items():
            reg_capability, reg_value, valid = self.extract_rsp_reg_and_cap("b'$" + register_data[reg_num] + "#")

            full_top, full_base = self.cheri_dec.decode_bounds(reg_value, reg_capability)

            prem_decoded = self.cheri_dec.decode_permissions(self.cheri_dec.extract_permissions_from_capability(reg_capability))


            self.print_info_registers_string(reg_name, reg_value, reg_capability, full_top, full_base, valid, prem_decoded)

    ####################################################################################################
    # This function is responsible printing the permissions in a presentable manner
    #
    # Inputs:
    #   perm_dict: A Dictionary where the permission name is the key
    #
    # Outputs:
    #   permissions_string: Dictionary with updated permissions
    #
    ####################################################################################################
    def print_permisions(self, perm_dict):

        permissions_string = ""
        # Set all bits in the register to 0 this will clear changes from the previous decoding
        for perms in PERMISSION_NAME_LIST:
            permissions_string += str(perm_dict[perms]).ljust(4)

        return permissions_string

    ####################################################################################################
    # This function is responsible printing the permissions header in a presentable manner
    #
    # Outputs:
    #   permissions_header_string: A string that contains the header info
    ####################################################################################################
    def print_permisions_header(self):

        permissions_header_string = ""
        # Set all bits in the register to 0 this will clear changes from the previous decoding
        for perms in PERMISSION_NAME_LIST:
            permissions_header_string += perms.ljust(4)

        return permissions_header_string







