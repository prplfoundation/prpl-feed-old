insmod drv_vrx618_fw_sim
insmod drv_pmi_sim boot_cfg=1 # boot mode flash
insmod dsl_gfast_drv_pmi
./control_pmi -I 1
./control_pmi -D 0 -1 99 -2 1 # init device 0, IntMode active polling, warmstart
