# Variaveis de selecao do multiplexer 4x1 (interruptores SW15 e SW14)
set_property PACKAGE_PIN R2 [get_ports Sel1]
    set_property IOSTANDARD LVCMOS33 [get_ports Sel1]
set_property PACKAGE_PIN T1 [get_ports Sel0]
    set_property IOSTANDARD LVCMOS33 [get_ports Sel0]

# Variaveis de entrada do multiplexer 4x1 (teclas BTND, BTNR, BTNC e BTNL)
set_property PACKAGE_PIN U17 [get_ports DataIn0]
    set_property IOSTANDARD LVCMOS33 [get_ports DataIn0]
set_property PACKAGE_PIN T17 [get_ports DataIn1]
    set_property IOSTANDARD LVCMOS33 [get_ports DataIn1]
set_property PACKAGE_PIN U18 [get_ports DataIn2]
    set_property IOSTANDARD LVCMOS33 [get_ports DataIn2]
set_property PACKAGE_PIN W19 [get_ports DataIn3]
    set_property IOSTANDARD LVCMOS33 [get_ports DataIn3]

# Variavel de saida do multiplexer 4x1 (LED LD7)
set_property PACKAGE_PIN V14 [get_ports DataOut]
    set_property IOSTANDARD LVCMOS33 [get_ports DataOut]

# Definir a tensao correta da placa Basys3
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
