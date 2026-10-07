# Variaveis de entrada do descodificador 2x4 (interruptores SW15 e SW14)
set_property PACKAGE_PIN R2 [get_ports Bit1]
    set_property IOSTANDARD LVCMOS33 [get_ports Bit1]
set_property PACKAGE_PIN T1 [get_ports Bit0]
    set_property IOSTANDARD LVCMOS33 [get_ports Bit0]

# Enables individuais das saidas (interruptores SW0 a SW3)
set_property PACKAGE_PIN V17 [get_ports En0]
    set_property IOSTANDARD LVCMOS33 [get_ports En0]
set_property PACKAGE_PIN V16 [get_ports En1]
    set_property IOSTANDARD LVCMOS33 [get_ports En1]
set_property PACKAGE_PIN W16 [get_ports En2]
    set_property IOSTANDARD LVCMOS33 [get_ports En2]
set_property PACKAGE_PIN W17 [get_ports En3]
    set_property IOSTANDARD LVCMOS33 [get_ports En3]

# Variaveis de saida do descodificador 2x4 (LEDs LD0 a LD3)
set_property PACKAGE_PIN U16 [get_ports Out0]
    set_property IOSTANDARD LVCMOS33 [get_ports Out0]
set_property PACKAGE_PIN E19 [get_ports Out1]
    set_property IOSTANDARD LVCMOS33 [get_ports Out1]
set_property PACKAGE_PIN U19 [get_ports Out2]
    set_property IOSTANDARD LVCMOS33 [get_ports Out2]
set_property PACKAGE_PIN V19 [get_ports Out3]
    set_property IOSTANDARD LVCMOS33 [get_ports Out3]

# Definir a tensao correta da placa Basys3
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
