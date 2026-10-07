# Ensaio do transcodificador para 7 segmentos (modulo de topo displayBCD)

# Numero a apresentar (interruptores SW3 a SW0)
set_property PACKAGE_PIN W17 [get_ports {Numero[3]}]
set_property PACKAGE_PIN W16 [get_ports {Numero[2]}]
set_property PACKAGE_PIN V16 [get_ports {Numero[1]}]
set_property PACKAGE_PIN V17 [get_ports {Numero[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {Numero[*]}]

# Displays a ligar (interruptores SW15 a SW12, um por display)
set_property PACKAGE_PIN R2 [get_ports {Liga[3]}]
set_property PACKAGE_PIN T1 [get_ports {Liga[2]}]
set_property PACKAGE_PIN U1 [get_ports {Liga[1]}]
set_property PACKAGE_PIN W2 [get_ports {Liga[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {Liga[*]}]

# Segmentos a..g (Segmentos[6] = a ... Segmentos[0] = g), ativos a Low
set_property PACKAGE_PIN W7 [get_ports {Segmentos[6]}]
set_property PACKAGE_PIN W6 [get_ports {Segmentos[5]}]
set_property PACKAGE_PIN U8 [get_ports {Segmentos[4]}]
set_property PACKAGE_PIN V8 [get_ports {Segmentos[3]}]
set_property PACKAGE_PIN U5 [get_ports {Segmentos[2]}]
set_property PACKAGE_PIN V5 [get_ports {Segmentos[1]}]
set_property PACKAGE_PIN U7 [get_ports {Segmentos[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {Segmentos[*]}]

# Ponto decimal
set_property PACKAGE_PIN V7 [get_ports DotPoint]
    set_property IOSTANDARD LVCMOS33 [get_ports DotPoint]

# Anodos comuns dos 4 displays (ativos a Low); Anodos[0] e o display da direita
set_property PACKAGE_PIN U2 [get_ports {Anodos[0]}]
set_property PACKAGE_PIN U4 [get_ports {Anodos[1]}]
set_property PACKAGE_PIN V4 [get_ports {Anodos[2]}]
set_property PACKAGE_PIN W4 [get_ports {Anodos[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {Anodos[*]}]

# Definir a tensao correta da placa Basys3
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
