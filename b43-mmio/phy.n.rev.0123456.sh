#!/bin/sh
if [ -e "$1" ]
then
	vim $1>/dev/null<<EOO
:%s/\(radio_read(0x.0..).*\)/\1 <-- RADIO READ WITHOUT 0x100 SET!/
:%s/radio_read(0x\(.\)1\(..\))/radio_read(0x\10\2)/

:%s/\(ssb_write32(0xf98).*\nssb_read32(0xf98).*\nssb_read32(0xf9c).*\nssb_read32(0xf90).*\nssb_write32(0xf98).*\nssb_read32(0xf98).*\nssb_write32(0xf98).*\nssb_read32(0xf98).*\n\)/>>> ssb_device_disable end\r\1>>> ssb_device_enable end\r\r/

:%s/\( phy_read(0x00ed).*\nphy_write(0x00ed).*\)/\r>>> b43_nphy_update_mimo_config start\r\1\r>>> b43_nphy_update_mimo_config end\r/

:%s/\( phy_read(0x00b0).*\n phy_read(0x00b0).*\nphy_write(0x00b0).*\)/\r>>> b43_nphy_classifier start\r\1\r>>> b43_nphy_classifier end\r/

:%s/\( phy_read(0x00a2).*\nphy_write(0x00a2).*\n phy_read(0x00a1).*\nphy_write(0x00a1).*\)/\r>>> b43_nphy_update_txrx_chain start\r\1\r>>> b43_nphy_update_txrx_chain end\r/

:%s/\(phy_write(0x0ca7) <- 0x2021\nphy_write(0x0c38) <- 0x0668\)/\1\r>>> b43_nphy_bphy_init end\r/
:%s/\(phy_write(0x0c88) <- 0x1e1f\nphy_write(0x0c89) <- 0x1c1d\)/\r>>> b43_nphy_bphy_init start\r\1/

:%s/\( read32 0x.....120.*\n phy_read(0x0078).*\nphy_write(0x0078).*\n radio_read(0x0009).*\nradio_write(0x0009).*\)/\r>>> b43_nphy_op_software_rfkill (true) start\r\1/
:%s/\(radio_write(0x305e).*\n radio_read(0x3062).*\nradio_write(0x3062).*\nradio_write(0x3064).*\)/\1\r>>> b43_nphy_op_software_rfkill (true) end\r/

:%s/\( phy_read(0x00[a8][5f]).*\nphy_write(0x00[a8][5f]).*\nphy_write(0x00aa).*\nphy_write(0x0072) <- 0x1d10\nphy_write(0x0073).*\nphy_write(0x0072) <- 0x3c57\n phy_read(0x0073).*\nphy_write(0x0072) <- 0x3c57\nphy_write(0x0073).*\n phy_read(0x00a5).*\nphy_write(0x00a5).*\nphy_write(0x00ab).*\nphy_write(0x0072) <- 0x1d11\nphy_write(0x0073).*\nphy_write(0x0072) <- 0x3c57\n phy_read(0x0073).*\nphy_write(0x0072) <- 0x3c57\nphy_write(0x0073).*\n phy_read(0x00bf).*\nphy_write(0x00bf).*\)/\r>>> b43_nphy_tx_power_fix start\r\1\r>>> b43_nphy_tx_power_fix end\r/

:%s/\(phy_write(0x0072) <- 0x2800\nphy_write(0x0074) <- 0x0800\nphy_write(0x0073) <- 0x4a04\)/\r>>> b43_nphy_tables_init start\r\1/

:%s/\(phy_write(0x0072) <- 0x6dc0\nphy_write(0x0073) <- 0x0000\nphy_write(0x0073) <- 0x0000\nphy_write(0x0073) <- 0x0000\nphy_write(0x0073) <- 0x0000\)/\r>>> b43_nphy_tables_init *almost* end\r\1/





:%s/\( read32 0x.....120.*\n\)\( phy_read(0x0078).*\nphy_write(0x0078).*\n phy_read(0x0078).*\nphy_write(0x0078).*\n phy_read(0x0078).*\nphy_write(0x0078).*\n\)\(radio_write\)/\r>>> b43_nphy_op_software_rfkill (false) start\r\1\r>>> b43_radio_init2055_pre start\r\2>>> b43_radio_init2055_pre end\r\r\3/

:%s/\(phy_write(0x0072) <- 0x0008\nphy_write(0x0073).*\nphy_write(0x0073).*\nphy_write(0x0073).*\nphy_write(0x0073).*\nphy_write(0x0072) <- 0x0408\nphy_write(0x0073).*\nphy_write(0x0073).*\nphy_write(0x0073).*\nphy_write(0x0073).*\n phy_read(0x001e).*\nphy_write(0x001e).*\n phy_read(0x0034).*\nphy_write(0x0034).*\)/\r>>> b43_nphy_adjust_lna_gain_table start\r\1\r>>> b43_nphy_adjust_lna_gain_table end\r/

:%s/\( phy_read(0x008f).*\nphy_write(0x008f).*\nphy_write(0x00aa).*\nphy_write(0x0072) <- 0x1d10\n\(.*\n\)\{28,30}phy_write(0x00bf).*\n\)/\r>>> b43_nphy_tx_power_fix [rev3+] start\r\1>>> b43_nphy_tx_power_fix [rev3+] end\r\r/





:%s/\( read32 0x.....120.*\n\)\( phy_read(0x0078).*\nphy_write(0x0078).*\n phy_read(0x0078).*\nphy_write(0x0078).*\n phy_read(0x0078).*\nphy_write(0x0078).*\n phy_read(0x0078).*\nphy_write(0x0078).*\n\)/\r>>> b43_nphy_op_software_rfkill (false) start\r\1\r>>> b43_radio_init2056_pre start\r\2>>> b43_radio_init2056_pre end\r\r/

:%s/\( radio_read(0x0008).*\nradio_write(0x0008).*\n radio_read(0x0009).*\nradio_write(0x0009).*\n radio_read(0x000b).*\nradio_write(0x000b).*\)/\r>>> b43_radio_init2056_post start\r\1/

:%s/\(radio_write(0x0056).*\nradio_write(0x0057).*\nradio_write(0x0046).*\nradio_write(0x0051).*\nradio_write(0x0050).*\)/\r>>> b43_radio_2056_setup start\r\1/
:%s/\(radio_write(0x003e) <- 0x0038\nradio_write(0x003e) <- 0x0018\nradio_write(0x003e) <- 0x0038\nradio_write(0x003e) <- 0x0039\)/\1\r>>> b43_radio_2056_setup end\r/





:%s/\n\n\n/\r\r/

:wq
EOO
else
	echo "Podaj plik jako argument"
fi
