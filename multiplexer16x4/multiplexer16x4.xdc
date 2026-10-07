# Variaveis de selecao do multiplexer 16x4 (teclas BTNL e BTNR)
set_property PACKAGE_PIN W19 [get_ports {Sel[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {Sel[1]}]
set_property PACKAGE_PIN T17 [get_ports {Sel[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {Sel[0]}]

# Entrada DataIn0 do multiplexer 16x4 (interruptores SW3 a SW0)
set_property PACKAGE_PIN W17 [get_ports {DataIn0[3]}]
set_property PACKAGE_PIN W16 [get_ports {DataIn0[2]}]
set_property PACKAGE_PIN V16 [get_ports {DataIn0[1]}]
set_property PACKAGE_PIN V17 [get_ports {DataIn0[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {DataIn0[*]}]

# Entrada DataIn1 do multiplexer 16x4 (interruptores SW7 a SW4)
set_property PACKAGE_PIN W13 [get_ports {DataIn1[3]}]
set_property PACKAGE_PIN W14 [get_ports {DataIn1[2]}]
set_property PACKAGE_PIN V15 [get_ports {DataIn1[1]}]
set_property PACKAGE_PIN W15 [get_ports {DataIn1[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {DataIn1[*]}]

# Entrada DataIn2 do multiplexer 16x4 (interruptores SW11 a SW8)
set_property PACKAGE_PIN R3 [get_ports {DataIn2[3]}]
set_property PACKAGE_PIN T2 [get_ports {DataIn2[2]}]
set_property PACKAGE_PIN T3 [get_ports {DataIn2[1]}]
set_property PACKAGE_PIN V2 [get_ports {DataIn2[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {DataIn2[*]}]

# Entrada DataIn3 do multiplexer 16x4 (interruptores SW15 a SW12)
set_property PACKAGE_PIN R2 [get_ports {DataIn3[3]}]
set_property PACKAGE_PIN T1 [get_ports {DataIn3[2]}]
set_property PACKAGE_PIN U1 [get_ports {DataIn3[1]}]
set_property PACKAGE_PIN W2 [get_ports {DataIn3[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {DataIn3[*]}]

# Saida do multiplexer 16x4 (LEDs LD3 a LD0)
set_property PACKAGE_PIN V19 [get_ports {DataOut[3]}]
set_property PACKAGE_PIN U19 [get_ports {DataOut[2]}]
set_property PACKAGE_PIN E19 [get_ports {DataOut[1]}]
set_property PACKAGE_PIN U16 [get_ports {DataOut[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {DataOut[*]}]

# Definir a tensao correta da placa Basys3
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
