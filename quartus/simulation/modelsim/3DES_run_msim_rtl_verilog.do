transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/DES3 {C:/HK6/CE213/3DES/DES3/S8.v}
vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/DES3 {C:/HK6/CE213/3DES/DES3/S7.v}
vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/DES3 {C:/HK6/CE213/3DES/DES3/S6.v}
vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/DES3 {C:/HK6/CE213/3DES/DES3/S5.v}
vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/DES3 {C:/HK6/CE213/3DES/DES3/S4.v}
vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/DES3 {C:/HK6/CE213/3DES/DES3/S3.v}
vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/DES3 {C:/HK6/CE213/3DES/DES3/S2.v}
vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/DES3 {C:/HK6/CE213/3DES/DES3/S1.v}
vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/DES3 {C:/HK6/CE213/3DES/DES3/S.v}
vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/DES3 {C:/HK6/CE213/3DES/DES3/key_scheduler.v}
vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/DES3 {C:/HK6/CE213/3DES/DES3/IP_inv.v}
vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/DES3 {C:/HK6/CE213/3DES/DES3/IP.v}
vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/DES3 {C:/HK6/CE213/3DES/DES3/feistel_algo.v}
vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/DES3 {C:/HK6/CE213/3DES/DES3/f.v}
vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/DES3 {C:/HK6/CE213/3DES/DES3/E.v}
vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/DES3 {C:/HK6/CE213/3DES/DES3/des3.v}

vlog -vlog01compat -work work +incdir+C:/HK6/CE213/3DES/quartus/../DES3 {C:/HK6/CE213/3DES/quartus/../DES3/top.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneii_ver -L rtl_work -L work -voptargs="+acc"  top

add wave *
view structure
view signals
run -all
