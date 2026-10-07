# Recria os projetos Vivado do Lab1 (aula 1), corre a simulacao comportamental
# e gera o bitstream de cada um.
# Uso (na raiz do repositorio): vivado -mode batch -source scripts/build.tcl
set root [file normalize [file dirname [info script]]/..]
set part xc7a35ticpg236-1L   ;# FPGA da Basys3 indicada no enunciado

# nome do projeto -> {fontes de desenho} testbench
set projetos {
    multiplexer4x1    {multiplexer4x1/multiplexer4x1.v}
    descodificador2x4 {descodificador2x4/descodificador2x4.v}
    multiplexer16x4   {multiplexer4x1/multiplexer4x1.v multiplexer16x4/multiplexer16x4.v}
}

file mkdir $root/bitstreams $root/simulacao
foreach {nome fontes} $projetos {
    set dir $root/vivado/$nome
    create_project $nome $dir -part $part -force
    foreach f $fontes { add_files -norecurse $root/$f }
    add_files -fileset constrs_1 -norecurse $root/$nome/$nome.xdc
    add_files -fileset sim_1 -norecurse $root/$nome/${nome}_teste1.v
    set_property top $nome [current_fileset]
    set_property top ${nome}_teste1 [get_filesets sim_1]
    update_compile_order -fileset sources_1

    # Simulacao comportamental (Behavioral Simulation) com registo VCD das formas de onda
    set_property -name {xsim.simulate.runtime} -value {all} -objects [get_filesets sim_1]
    launch_simulation -simset sim_1 -mode behavioral
    open_vcd $root/simulacao/${nome}_teste1.vcd
    log_vcd [get_objects -r /${nome}_teste1/*]
    restart
    run all
    close_vcd
    close_sim

    # Sintese, implementacao e bitstream
    launch_runs synth_1 -jobs 8
    wait_on_run synth_1
    launch_runs impl_1 -to_step write_bitstream -jobs 8
    wait_on_run impl_1
    if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} { error "$nome: implementacao falhou" }
    file copy -force $dir/$nome.runs/impl_1/$nome.bit $root/bitstreams/$nome.bit
    open_run impl_1
    report_utilization -file $root/bitstreams/${nome}_utilizacao.txt
    close_project
}
