#!/bin/sh
if [ -e "$1" ]
then
	vim $1>/dev/null<<EOO
:%s/\(radio_read(0x.0..).*\)/\1 <-- RADIO READ WITHOUT 0x100 SET!/
:%s/radio_read(0x\(.\)1\(..\))/radio_read(0x\10\2)/

:%s/\( phy_read(0x044d).*\nphy_write(0x044d).*\n phy_read(0x04b1).*\nphy_write(0x04b1).*\n phy_read(0x04b1).*\nphy_write(0x04b1).*\n phy_read(0x04b6).*\nphy_write(0x04b6).*\)/\r>>> lpphy_rev0_1_set_rx_gain start\r\1\r>>> lpphy_rev0_1_set_rx_gain end\r/

:%s/\( phy_read(0x0410).*\nphy_write(0x0410).*\n phy_read(0x0482).*\nphy_write(0x0482).*\n phy_read(0x0481).*\nphy_write(0x0481).*\n phy_read(0x0481).*\nphy_write(0x0481).*\n phy_read(0x0481).*\nphy_write(0x0481).*\n phy_read(0x0481).*\)/\r>>> lpphy_rx_iq_est start\r\1/
:%s/\( phy_read(0x0483).*\n phy_read(0x0484).*\n phy_read(0x0485).*\n phy_read(0x0486).*\n phy_read(0x0487).*\n phy_read(0x0488).*\n phy_read(0x0410).*\nphy_write(0x0410).*\)/\1\r>>> lpphy_rx_iq_est end\r/

:%s/\(read32(0x120).*\nphy_write(0x0455) <- 0x3400\nphy_write(0x0456).*\nphy_write(0x0456).*\nphy_write(0x0456).*\nread32(0x120).*\nphy_write(0x0455) <- 0x3000\nphy_write(0x0456).*\nphy_write(0x0456).*\nphy_write(0x0456).*\)/\r>>> lpphy_adjust_gain_table start\r\1\r>>> lpphy_adjust_gain_table end\r/



:%s/\( phy_read(0x044d).*\nphy_write(0x044d).*\n phy_read(0x04b1).*\nphy_write(0x04b1).*\n phy_read(0x04b1).*\nphy_write(0x04b1).*\nphy_write(0x04b6).*\)/\r>>> lpphy_rev0_1_set_rx_gain start\r\1\r>>> lpphy_rev0_1_set_rx_gain end\r/
:%s/\( phy_read(0x0410).*\nphy_write(0x0410).*\nphy_write(0x0482).*\n phy_read(0x0481).*\nphy_write(0x0481).*\n phy_read(0x0481).*\nphy_write(0x0481).*\n phy_read(0x0481).*\nphy_write(0x0481).*\n phy_read(0x0481).*\)/\r>>> lpphy_rx_iq_est start\r\1/

:%s/\n\n\n/\r\r/

:wq
EOO
else
	echo "Pass filename as argument"
fi
