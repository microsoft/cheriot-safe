import time
import socket

#########################################################################################################
# This class is responsible for transmitting and receiving data from GDB to OpenOCD. It sits in the
# middle of the spoof GDB server and the OpenOCD. Transmitting RSP packets :)
#########################################################################################################
class GDB_OpenOCD_Transmitter:

    def __init__(self, ip_address, port, socket):
        self.host_ip = ip_address
        self.host_port = port
        self.debug_socket = socket


    ####################################################################################################
    # This function is responsible for requesting info on all the registers inside the CHERI core
    #
    # Inputs:
    #   get_all_register_command: RSP command that tells OpenOCD to send all GPR data
    #
    # Outputs:
    #   all_register_data: This is a packet from OpenOCD that contains all the register info
    ####################################################################################################
    def execute_get_all_registers_command(self, get_all_register_command):
        self.send_packet_and_receive_ack(get_all_register_command)


        all_register_data = self.send_ack_and_receive_packet()
        if "E0E" in str(all_register_data):
            self.send_packet_and_receive_ack(get_all_register_command)

            all_register_data = self.send_ack_and_receive_packet()
            self.send_ack()

        return all_register_data

    ####################################################################################################
    # This function is responsible for requesting info on a specific registers inside the CHERI core
    #
    # Inputs:
    #   get_register_command: RSP command that tells OpenOCD to send data on a specified register
    #
    # Outputs:
    #   all_register_data: This is a packet from OpenOCD that contains a specified register info
    ####################################################################################################
    def execute_get_register_command(self, get_register_command):

        self.send_packet_and_receive_ack(get_register_command)

        register_data = self.send_ack_and_receive_packet()
        self.send_ack()


        return register_data

    ####################################################################################################
    # This function is responsible for sending data to change the value of all GPRs in the CHERI core
    #
    # Inputs:
    #   set_all_registers_command: RSP command that tells OpenOCD to update the value and
    #                         capability of all GPRs
    #
    ####################################################################################################
    def execute_set_all_registers_command(self, set_all_registers_command):
        self.send_packet_and_receive_ack(set_all_registers_command)
        self.send_ack()
        self.receive_OK()


    ####################################################################################################
    # This function is responsible for sending data to change the value of a specific registers
    #
    # Inputs:
    #   set_register_command: RSP command that tells OpenOCD to update the value and
    #                         capability of specific register
    #
    ####################################################################################################
    def execute_set_register_command(self, set_register_command):
        self.send_packet_and_receive_ack(set_register_command)
        self.send_ack()
        self.receive_OK()


    ####################################################################################################
    # This function is responsible for sending data that writes to the memory
    #
    # Inputs:
    #   load_mem_cmd: This command writes values to memory. Starts with an X
    #
    #
    ####################################################################################################
    def execute_load_memory_command(self, load_mem_cmd):

        int_list = []

        for i in load_mem_cmd:
            temp_int = ord(i) & 0xFF
            int_list.append(temp_int)

        self.debug_socket.sendall(bytes(int_list))

        ack = self.debug_socket.recv(1024)

        self.send_ack()
        ack = str(ack)

        if "+" in ack and "OK" in ack:
            return

        self.receive_OK()



    ####################################################################################################
    # This is a lower level function that is responsible for sending a packet of data and receiving an
    # acknowledgment packet
    #
    # Inputs:
    #   pkt_data: The RSP command you want to send to OpenOCD
    #
    ####################################################################################################
    def send_packet_and_receive_ack(self, pkt_data):
        self.debug_socket.sendall(bytes(pkt_data, 'utf-8'))
        self.receive_ack()



    ####################################################################################################
    # Sometimes there are extra packets sent from OpenOCD. This function will flesh out those packets
    #
    # Inputs:
    #   length: The amount of time in seconds until the function exits
    #
    ####################################################################################################
    def flush_out_packet(self, length):
        while True:
            try:
                # Set a 2-second timeout for the socket
                self.debug_socket.settimeout(length)


                # Wait for a response (optional)
                pkt = self.debug_socket.recv(1024)

                self.send_ack()

            except socket.timeout:
                self.send_ack()
                return False

    ####################################################################################################
    # This function sends breakpoint data to OpenOCD
    #
    # Inputs:
    #   pkt_data: The breakpoint command that is sent to OpenOCD
    #
    ####################################################################################################
    def send_packet_and_receive_ack_bp(self, pkt_data):
        self.debug_socket.sendall(bytes(pkt_data, 'utf-8'))
        self.receive_ack()
        while True:
            try:
                # Set a 2-second timeout for the socket
                self.debug_socket.settimeout(2)

                # Get the current time
                current_time = time.time()

                # Wait for a response (optional)
                pkt = self.debug_socket.recv(1024)

                self.send_ack()



            except socket.timeout:
                return False

    ####################################################################################################
    # This function sends the continue command to OpenOCD
    #
    # Inputs:
    #   pkt_data: The continue command that is sent to OpenOCD
    #
    ####################################################################################################
    def send_packet_and_receive_ack_con(self, pkt_data):
        timeout = 1
        self.debug_socket.sendall(bytes(pkt_data, 'utf-8'))
        self.receive_ack()

        while True:
            try:
                # Set a 2-second timeout for the socket
                self.debug_socket.settimeout(2)

                # Get the current time
                current_time = time.time()

                # Wait for a response (optional)
                pkt = self.debug_socket.recv(1024)

                self.send_ack()



            except socket.timeout:

                return False


    ####################################################################################################
    # This function sends the stepi command to OpenOCD
    #
    # Inputs:
    #   pkt_data: The RSP stepi command that is sent to OpenOCD
    #
    ####################################################################################################
    def send_packet_and_receive_ack_stepi(self, pkt_data):
        timeout = 1
        self.debug_socket.sendall(bytes(pkt_data, 'utf-8'))
        self.receive_ack()

        while True:
            try:
                # Set a 2-second timeout for the socket
                self.debug_socket.settimeout(2)

                # Get the current time
                current_time = time.time()

                # Wait for a response (optional)
                pkt = self.debug_socket.recv(1024)

                self.send_ack()


            except socket.timeout:
                return False


    ####################################################################################################
    # This is a lower level function that is responsible for sending an acknowledgment packet and
    # receiving a packet of data
    ####################################################################################################
    def send_ack_and_receive_packet(self):
        self.send_ack()
        return self.receive_packet()

    ####################################################################################################
    # This is a lower level function that is responsible for sending a packet of data
    ####################################################################################################
    def send_packet(self, pkt_data):
        self.debug_socket.sendall(bytes(pkt_data, 'utf-8'))

    ####################################################################################################
    # This is a lower level function that is responsible for confirming the acknowledgment packet has
    # been sent from OpenOCD
    ####################################################################################################
    def receive_ack(self):
        ack = self.debug_socket.recv(1024)
        ack = str(ack)
        if "+" not in ack:
            print("ERROR: No ACK received")

    ####################################################################################################
    # This is a lower level function that is responsible for confirming the OK packet has been sent
    # from OpenOCD. The ""OK"" packet is sent from OpenOCD when a register is written
    ####################################################################################################
    def receive_OK(self):
        try:
            ack = self.debug_socket.recv(1024)
            ack = str(ack)

            if "OK" not in ack:
                print("ERROR: No OK received")

        except socket.timeout:
            return False

    ####################################################################################################
    # This is a lower level function that is responsible for sending an acknowledgment packet to
    # OpenOCD
    ####################################################################################################
    def send_ack(self):
        self.debug_socket.sendall(bytes("+", 'utf-8'))

    ####################################################################################################
    # This is a lower level function that is responsible for receiving any packet from OpenOCD
    ####################################################################################################
    def receive_packet(self):
        incoming_packet = self.debug_socket.recv(1024)
        return incoming_packet

    ####################################################################################################
    # This is a lower level function that is responsible for establishing the initial connection to
    # OpenOCD
    ####################################################################################################
    def establish_connection(self):

        self.debug_socket.connect((self.host_ip, self.host_port))
        self.receive_ack()
        self.send_ack()