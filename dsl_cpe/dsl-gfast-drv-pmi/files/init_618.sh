./what.sh /lib/modules/3.10.12/dsl_gfast_drv_*
lspci
insmod dsl_gfast_drv_vrx618_ep vrx618_pcie_vendor_id=0x8086 vrx618_pcie_device_id=0x09AA
insmod dsl_gfast_drv_pmi debug_level=0x333311
echo 0x10006001 > /sys/class/pmidev/dsl_pmi_dev0/force_dev_type
./control_pmi -I 1
./control_pmi -D 0 -1 99 -2 0 # init device 0, IntMode active polling

# trigger PLL lock
#./control_pmi -X 0x0C -w "0x03F00500"
#./control_pmi -X 0x0C -w "0x0BF00500"
#./control_pmi -X 0x0100 -w "0x00004000"
#./control_pmi -X 0x0C -w "0x0BF00501"
#./control_pmi -X 0x0C -w "0x08000501"
#./control_pmi -X 0x0C -w "0x0C000501"
#./control_pmi -X 0x0 -w "0x021400BF" 

./control_pmi -F 0 -x /lib/firmware/09AA/xcpe_fw.bin

