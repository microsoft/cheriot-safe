import re
from register_info import *
from gdb_command_info import *
from Mutable_String import Mutable_String
from CHERI_Encoder import CHERI_Encoder
from CHERI_Decoder import CHERI_Decoder

class GDB_RSP_Translator:

    def __init__(self, gdb_open_ocd_transmitter, rsp_gdb_translate):
        self.gdb_command = ""

        self.register_ABI_name = ""
        self.register_number = ""
        self.register_value = ""
        self.endian_register_value = ""
        self.openocd_command = ""
        self.rsp_packet = ""

        self.load_address = ""
        self.file_path = ""

        self.top_hex = ""
        self.top_binary = ""

        self.base_hex = ""
        self.base_binary = ""

        self.exponent = ""
        self.exponent_binary = ""

        self.bounds_binary_capability = ""

        self.capability_decoder = CHERI_Decoder()
        self.capability_encoder = CHERI_Encoder()
        self.transmitter = gdb_open_ocd_transmitter
        self.rsp_gdb_trans = rsp_gdb_translate



    ####################################################################################################
    # This function builds the RSP that will then be sent to OpenOCD
    #
    # Inputs:
    #   rsp_command: This is the command attached to the RSP packet
    #   register_name: The name of the register that is being modified (Sometimes this field is left blank)
    #   reg_value: The value that will be placed in the above register (Sometimes this field is left blank)
    #
    # Outputs:
    #   self.rsp_packet: The RSP packet that will be sent to OpenOCD
    #
    ####################################################################################################
    def build_rsp_packet(self, rsp_command, register_name, reg_value):


        if RSP_COMMAND_COMPONENTS[rsp_command] == COMMAND:
            self.rsp_packet = "$"
            self.rsp_packet += rsp_command
            self.rsp_packet += "#"
            self.rsp_packet += str(self.check_sum(self.rsp_packet))

        elif RSP_COMMAND_COMPONENTS[rsp_command] == COMMAND_REGISTER:
            self.rsp_packet = "$"
            self.rsp_packet += rsp_command
            self.rsp_packet += self.find_register_number(register_name)
            self.rsp_packet += "#"
            self.rsp_packet += str(self.check_sum(self.rsp_packet))

        elif RSP_COMMAND_COMPONENTS[rsp_command] == COMMAND_REGISTER_VALUE:
            self.rsp_packet = "$"
            self.rsp_packet += rsp_command
            self.rsp_packet += self.find_register_number(register_name)
            self.rsp_packet += "="
            self.rsp_packet += self.change_endian(reg_value, True)
            self.rsp_packet += "#"
            self.rsp_packet += str(self.check_sum(self.rsp_packet))

        elif RSP_COMMAND_COMPONENTS[rsp_command] == COMMAND_VALUE:
            self.rsp_packet = "$"
            self.rsp_packet += rsp_command
            self.rsp_packet += "="
            self.rsp_packet += self.change_endian(reg_value)
            self.rsp_packet += "#"
            self.rsp_packet += str(self.check_sum(self.rsp_packet))

        elif RSP_COMMAND_COMPONENTS[rsp_command] == COMMAND_VALUE_BP:
            self.rsp_packet = "$"
            self.rsp_packet += rsp_command
            self.rsp_packet += ","
            self.rsp_packet += reg_value
            self.rsp_packet += ","
            self.rsp_packet += "2"
            self.rsp_packet += "#"
            self.rsp_packet += str(self.check_sum(self.rsp_packet))

        elif RSP_COMMAND_COMPONENTS[rsp_command] == COMMAND_LOAD_MEM:
            address = register_name
            memory_values = reg_value
            self.rsp_packet = "$"
            self.rsp_packet += rsp_command
            self.rsp_packet += address.replace("0x", "")
            self.rsp_packet += ","
            self.rsp_packet += "4"         # 128 Bytes will be written
            self.rsp_packet += ":"
            self.rsp_packet += self.hex_to_ascii(memory_values)
            self.rsp_packet += "#"
            self.rsp_packet += str(self.check_sum(self.rsp_packet))

        else:
            print("!!!COMMAND NOT FOUND!!!")
            exit()

        return self.rsp_packet

    ####################################################################################################
    # This function is responsible for converting Hex pairs into ascii characters
    #
    # Inputs:
    #   hex_number: This is used to translate the value of a word in the .vhx file to an ascii string
    #
    # Outputs:
    #   "".join(ascii_list): This is an ascii string that represents a word in a .vhx file
    #
    ####################################################################################################
    def hex_to_ascii(self, hex_number):

        ascii_list = []

        hex_string = hex_number.replace("0x", "")  # Remove '0x' if present at the beginning of the hex number

        hex_string = self.change_endian(hex_string)

        for i in range(0, len(hex_string), 2):
            hex_byte = hex_string[i:i + 2]
            integer_value = int(hex_byte, 16)

            ascii_list.append(chr(integer_value))


        return "".join(ascii_list)


    ####################################################################################################
    # This function is responsible for checking if the permissions that the user entered is valid
    # permission instead of a random pair letters
    #
    # Inputs:
    #   permissions_list: A list of valid permissions. The user should only enter values from this list
    #   user_entered_command: The permissions entered by the user
    #
    #   Output:
    #        True/False: Are the permissions entered by the user valid?
    #
    ####################################################################################################
    def check_substring(self, permissions_list, user_entered_command):

        for permission in permissions_list:
            if permission in user_entered_command:
                return True

        return False

    ####################################################################################################
    # This function is responsible taking the initial gdb command entered by the user and figuring
    # type of RSP packet will be sent to OpenOCD
    #
    # Inputs:
    #   gdb_command: This is the "gdb" command that is entered by the user
    #
    #
    # Outputs:
    #   self.openocd_command: This is the command attached to the RSP packet. One letter at the start of a packet
    #   self.register_ABI_name: The name of the register that is being modified (Sometimes this field is left blank)
    #   self.register_value: The value that will be placed in the above register (Sometimes this field is left blank)
    #
    ####################################################################################################
    def exact_components_of_gdb_cmd(self, gdb_command):
        self.gdb_command = gdb_command.strip()

        if "info registers" in self.gdb_command:
            self.openocd_command = "g"
            self.register_ABI_name = ""
            self.register_value = ""

        elif "set" in self.gdb_command:

            if "T" in self.gdb_command and "B" in self.gdb_command:
                capability, register_value, valid = self.get_current_register_value(re.split(" |=", self.gdb_command)[1])  # Second Element in the list is the registers name

                register_binary_capability, register_binary_value = self.create_binary_register_string(capability, register_value)

                top_val_hex, base_val_hex = self.parse_write_bounds_command(self.gdb_command)
                self.top_binary, self.base_binary, self.exponent = self.capability_encoder.extract_compressed_top_base(int(top_val_hex, 16), int(base_val_hex, 16))
                self.exponent_binary = bin(self.exponent)[2:].zfill(EXPONENT_BIT_SIZE)
                new_bounds = self.concat_bounds_data(self.exponent_binary, self.base_binary, self.top_binary)

                new_bounds = Mutable_String(new_bounds)

                register_binary_capability[-22:] = new_bounds

                self.gdb_command = re.split(" |=", self.gdb_command)

                self.openocd_command = "P"
                self.register_ABI_name = self.gdb_command[1]  # Second Element in the list is the registers name
                self.register_value = self.concat_register_value_and_capability(register_binary_capability, register_binary_value)  # Third Element is the list is the register value

            elif self.check_substring(PERMISSION_NAME_LIST, self.gdb_command):

                register_name = re.split(" |=", self.gdb_command)[1]

                capability, register_value, valid = self.get_current_register_value(register_name) # Second Element in the list is the registers name

                register_binary_capability, register_binary_value = self.create_binary_register_string(capability, register_value)

                self.gdb_command = re.split(" |=", self.gdb_command)
                self.gdb_command = self.gdb_command[2:]

                self.capability_decoder.clear_permissions()
                for permissions in self.gdb_command:
                    if permissions not in self.capability_decoder.permissions_dict:
                        print("This is not valid permission: ", permissions)
                        print("Still looping through the list")
                    else:
                        self.capability_decoder.permissions_dict[permissions] = 1

                new_permissions = Mutable_String(self.capability_encoder.encode_permissions(self.capability_decoder.permissions_dict))

                register_binary_capability[1:7] = new_permissions.reverse_string()

                self.openocd_command = "P"
                self.register_ABI_name = register_name  # Second Element in the list is the registers name
                self.register_value = self.concat_register_value_and_capability(register_binary_capability, register_binary_value)

            elif "otype" in self.gdb_command:

                register_name = re.split(" |=", self.gdb_command)[1]

                capability, register_value, valid = self.get_current_register_value(register_name)  # Second Element in the list is the registers name
                register_binary_capability, register_binary_value = self.create_binary_register_string(capability, register_value)

                new_otype_value = re.split(" |=", self.gdb_command)[-1]
                new_otype_value = Mutable_String(new_otype_value)


                register_binary_capability[7:10] = new_otype_value

                self.openocd_command = "P"
                self.register_ABI_name = register_name  # Second Element in the list is the registers name
                self.register_value = self.concat_register_value_and_capability(register_binary_capability, register_binary_value)

            else:
                register_name = re.split(" |=", self.gdb_command)[1]

                capability, register_value, valid = self.get_current_register_value(register_name)  # Second Element in the list is the registers name
                register_binary_capability, register_binary_value = self.create_binary_register_string(capability, register_value)

                new_register_value = re.split(" |=", self.gdb_command)[-1]
                new_register_value = str(bin(int(new_register_value, 16))[2:].zfill(REGISTER_SIZE))


                self.openocd_command = "P"
                self.register_ABI_name = register_name  # Second Element in the list is the registers name
                self.register_value = self.concat_register_value_and_capability(register_binary_capability, new_register_value)

        elif "breakpoint" in self.gdb_command:
            self.gdb_command = re.split(" ", self.gdb_command)

            self.openocd_command = "Z0"
            self.register_ABI_name = ""
            self.register_value = self.gdb_command[1]

        elif "stepi" in self.gdb_command:
            self.gdb_command = re.split("=", self.gdb_command)

            self.openocd_command = "s"
            self.register_ABI_name = ""
            self.register_value = ""    # Second Element in the list are the register Values

        elif "print" in self.gdb_command:
            self.gdb_command = re.split(" ", self.gdb_command)

            self.openocd_command = "p"
            self.register_ABI_name = self.gdb_command[1]    # Second Element in the list is the registers name
            self.register_value = ""

        elif "setall" in self.gdb_command:
            self.gdb_command = re.split("=", self.gdb_command)

            self.openocd_command = "G"
            self.register_ABI_name = ""
            self.register_value = self.gdb_command[1]    # Second Element in the list are the register Values

        elif "continue" in self.gdb_command:
            self.gdb_command = re.split("=", self.gdb_command)

            self.openocd_command = "c"
            self.register_ABI_name = ""
            self.register_value = ""    # Second Element in the list are the register Values

        elif "remove" in self.gdb_command:
            self.gdb_command = re.split(" ", self.gdb_command)

            self.openocd_command = "z0"
            self.register_ABI_name = ""
            self.register_value = self.gdb_command[1]

        elif "load" in self.gdb_command:
            self.gdb_command = re.split(" ", self.gdb_command)

            self.load_address = ""
            self.file_path = ""

            self.openocd_command = "X"
            self.load_address = self.gdb_command[1]
            self.file_path = self.gdb_command[2]

            return self.openocd_command, self.load_address, self.file_path


        else:
            print("!!!COMMAND NOT FOUND!!!")
            exit()

        return self.openocd_command, self.register_ABI_name, self.register_value

    ####################################################################################################
    # This function is responsible finding the number of a register, associated with the name of a
    # register that was entered by the user
    #
    # Inputs:
    #   reg_name: The name of the register that was entered by the user (Example: $ra, $s2)
    #
    #
    # Outputs:
    #   self.register_number: The register number in hexadecimal format
    #
    ####################################################################################################
    def find_register_number(self, reg_name):
        self.register_number = REG_NAME_TO_VALUE[reg_name]
        self.register_number = str(hex(self.register_number)).replace("0x", "")

        return self.register_number

    ####################################################################################################
    # This function is responsible changing the endian of a number sent from OpenOCD. Since there are
    # 32 bits added to the CHERI core per GPR, the endianness need to be changed for both the
    # capability and the register value
    #
    # Inputs:
    #   reg_val: The register value from a packet from OpenOCD
    #   with_capability: If the data has a capability attached to it
    #
    # Outputs:
    #   self.endian_register_value: The register value from a packet from OpenOCD with flipped endian
    #
    ####################################################################################################
    def change_endian(self, reg_val, with_capability=False):


        if with_capability:
            endian_change_reg_one = reg_val[:32]
            endian_change_reg_two = reg_val[32:]

            endian_change_reg_one = endian_change_reg_one.replace("0x", "")
            endian_change_reg_two = endian_change_reg_two.replace("0x", "")

            endian_change_reg_one = [endian_change_reg_one[i:i + 2] for i in range(0, len(endian_change_reg_one), 2)]
            endian_change_reg_one = list(reversed(endian_change_reg_one))
            endian_change_reg_one = "".join(endian_change_reg_one)

            endian_change_reg_two = [endian_change_reg_two[i:i + 2] for i in range(0, len(endian_change_reg_two), 2)]
            endian_change_reg_two = list(reversed(endian_change_reg_two))
            endian_change_reg_two = "".join(endian_change_reg_two)

            self.endian_register_value = endian_change_reg_one + endian_change_reg_two

            return self.endian_register_value

        else:

            endian_change = reg_val
            endian_change = endian_change.replace("0x", "")

            self.endian_register_value = [endian_change[i:i + 2] for i in range(0, len(endian_change), 2)]
            self.endian_register_value = list(reversed(self.endian_register_value))
            self.endian_register_value = "".join(self.endian_register_value)

            return self.endian_register_value


    ####################################################################################################
    # This function is responsible for summing up the elements of an RSP and sending over TCP/IP. This
    # checksum is used to confirm the integrity of the RSP package that is both sent and recieved
    #
    # Inputs:
    #   rsp_packet_no_checksum: The RSP Packet that is sent to OpenOCD but it doesn't have the checksum
    #                           appended to it yet.
    #
    # Outputs:
    #   checksum: The sum of the RSP packet modulo 256
    #
    ####################################################################################################
    def check_sum(self, rsp_packet_no_checksum):
        checksum = 0
        for p_char in rsp_packet_no_checksum:
            if p_char == "$" or p_char == "#":
                continue
            else:
                checksum += ord(p_char)

        checksum = checksum % 256
        checksum = hex(checksum)
        checksum = str(checksum)
        checksum = checksum[2:]

        if len(checksum) == 1:
            checksum = "0" + checksum

        return checksum


    ####################################################################################################
    # This function is responsible for parsing the command that writes the Base, Top and Exponent of
    # the capability register.
    #
    # Inputs:
    #   set_bounds_command: This command SHOULD have both the upper and lower bounds for the capability.
    #
    # Outputs:
    #   self.top_hex: The top register value in hex
    #   self.base_hex: The base register value in hex
    #
    ####################################################################################################
    def parse_write_bounds_command(self, set_bounds_command):
         self.top_hex = re.search("(?<=T=)(.*?)(?=\s|$)", set_bounds_command)
         self.top_hex = self.top_hex.group()

         self.base_hex = re.search("(?<=B=)(.*?)(?=\s|$)", set_bounds_command)
         self.base_hex = self.base_hex.group()

         return self.top_hex, self.base_hex



    ####################################################################################################
    # This function is responsible for concatenating the 9 bits for the base, 9 bits for the top and 4
    # bits for the exponent into a single bit string
    #
    # Inputs:
    #   exponent: The binary representation of exponent field of the capability
    #   base: The binary representation of base field of the capability
    #   top: The binary representation of top field of the capability
    #
    # Outputs:
    #   self.bounds_binary_capability: The binary representation of the capability fields that deal
    #                                  with bounding the pointer
    #
    ####################################################################################################
    def concat_bounds_data(self, exponent, base, top):
        self.bounds_binary_capability = exponent + base + top
        # print(self.bounds_binary_capability)

        return self.bounds_binary_capability


    ####################################################################################################
    # This function is responsible for changing the register value and capability into binary strings
    # that are mutable.
    #
    # Inputs:
    #   capability: The register capability in a hex format
    #   register_value: The register value in a hex format
    #
    # Outputs:
    #   register_binary_capability: The register capability but in a mutable binary format
    #   register_binary_value: The register value but in a mutable binary format
    #
    ####################################################################################################
    def create_binary_register_string(self, capability, register_value):
        register_binary_capability = Mutable_String(str(bin(int(capability, 16))[2:].zfill(CAPABILITY_SIZE)))
        register_binary_value = Mutable_String(str(bin(int(register_value, 16))[2:].zfill(REGISTER_SIZE)))

        return register_binary_capability, register_binary_value

    ####################################################################################################
    # When changing the value of a capability a (read modify write) is performed. This function is
    # responsible for doing the read portion of the read modify write
    #
    # Inputs:
    #   register_name: Name of the register that is being modified
    #
    # Outputs:
    #   capability: The register capability in a hex format
    #   register_value: The register value in a hex format
    #   valid: Valid bit
    #
    ####################################################################################################
    def get_current_register_value(self, register_name):
        get_register_command = self.build_rsp_packet("p", register_name, "")

        register_packet = self.transmitter.execute_get_register_command(get_register_command)

        capability, register_value, valid = self.rsp_gdb_trans.extract_rsp_reg_and_cap(str(register_packet))

        return capability, register_value, valid



    ####################################################################################################
    # This function is responsible for concatenating the register values and capability values together
    #
    # Inputs:
    #   register_capability: The register capability in a hex format
    #   register_value: The register value in a hex format
    #
    # Outputs:
    #   new_register_value: The concatenation of register_capability and register_value
    ####################################################################################################
    def concat_register_value_and_capability(self, register_value, register_capability):
        new_register_value = str(register_value) + str(register_capability)

        new_register_value = str(hex(int(new_register_value, 2))).replace("0x", "").zfill(16)

        return new_register_value









