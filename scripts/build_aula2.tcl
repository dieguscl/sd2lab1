# Aula 2: completa o projeto displayBCD com os modulos da aula 2, corre a
# simulacao comportamental de cada um e gera o bitstream do ensaio do transcodificador.
# Uso (na raiz do repositorio): vivado -mode batch -source scripts/build_aula2.tcl
set root [file normalize [file dirname [info script]]/..]
set dir  $root/vivado/displayBCD
open_project $dir/displayBCD.xpr

# FPGA da Basys3 indicada no enunciado
set_property part xc7a35ticpg236-1L [current_project]

# Retira referencias a ficheiros que nao existem neste computador
foreach f [get_files -quiet -all] {
    if {![file exists $f]} { remove_files $f }
}

set src $dir/displayBCD.srcs
set fontes {registo4.v transcod7seg.v divisorCLK.v contador4.v displayBCD.v}
set testes {registo4_teste1 transcod7seg_teste1 divisorclk_teste1 contador4_teste1}
foreach f $fontes {
    if {[llength [get_files -quiet $src/sources_1/new/$f]] == 0} { add_files -norecurse $src/sources_1/new/$f }
}
foreach t $testes {
    if {[llength [get_files -quiet $src/sim_1/new/$t.v]] == 0} { add_files -fileset sim_1 -norecurse $src/sim_1/new/$t.v }
}
if {[llength [get_files -quiet $src/constrs_1/new/displayBCD.xdc]] == 0} {
    add_files -fileset constrs_1 -norecurse $src/constrs_1/new/displayBCD.xdc
}
set_property top displayBCD [current_fileset]
update_compile_order -fileset sources_1

# Simulacao comportamental de cada modulo, com registo VCD das formas de onda
file mkdir $root/simulacao
set_property -name {xsim.simulate.runtime} -value {all} -objects [get_filesets sim_1]
foreach t $testes {
    set_property top $t [get_filesets sim_1]
    update_compile_order -fileset sim_1
    launch_simulation -simset sim_1 -mode behavioral
    open_vcd $root/simulacao/$t.vcd
    log_vcd [get_objects -r /$t/*]
    restart
    run all
    close_vcd
    close_sim
}
set_property top transcod7seg_teste1 [get_filesets sim_1]

# Sintese, implementacao e bitstream do ensaio do transcodificador
reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} { error "displayBCD: implementacao falhou" }
file mkdir $root/bitstreams
file copy -force $dir/displayBCD.runs/impl_1/displayBCD.bit $root/bitstreams/displayBCD.bit
close_project
