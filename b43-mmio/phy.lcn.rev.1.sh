#!/bin/sh
if [ -e "$1" ]
then
	vim $1>/dev/null<<EOO
:%s/\(radio_read(0x.0..).*\)/\1 <-- RADIO READ WITHOUT 0x200 SET!/
:%s/radio_read(0x\(.\)2\(..\))/radio_read(0x\10\2)/
:%s/radio_read(0x\(.\)3\(..\))/radio_read(0x\11\2)/
:%s/radio_read(0x\(.\)6\(..\))/radio_read(0x\14\2)/
:%s/radio_read(0x\(.\)7\(..\))/radio_read(0x\15\2)/
:%s/radio_read(0x\(.\)a\(..\))/radio_read(0x\18\2)/
:%s/radio_read(0x\(.\)b\(..\))/radio_read(0x\19\2)/

:%s/\( phy_read(0x043c).*\nphy_write(0x043c).*\n phy_read(0x043b).*\nphy_write(0x043b).*\)/\r>>> analog(OFF) start\r\1\r>>> analog(OFF) end\r/

:%s/\( phy_read(0x044d).*\nphy_write(0x044d).*\n phy_read(0x044c).*\nphy_write(0x044c).*\n phy_read(0x04b7).*\nphy_write(0x04b7).*\n phy_read(0x04b1).*\nphy_write(0x04b1).*\n phy_read(0x04b0).*\nphy_write(0x04b0).*\n phy_read(0x04fa).*\nphy_write(0x04fa).*\n phy_read(0x04f9).*\nphy_write(0x04f9).*\)/\r>>> Switch Radio(OFF) start\r\1\r>>> Switch Radio(OFF) end\r/
:%s/\( phy_read(0x044c).*\nphy_write(0x044c).*\n phy_read(0x04b0).*\nphy_write(0x04b0).*\n phy_read(0x04f9).*\nphy_write(0x04f9).*\)/\r>>> Switch Radio(ON) start\r\1\r>>> Switch Radio(ON) end\r/

:%s/\(write32 0x.....160 <- 0x00010028\n read32 0x.....160 -> 0x00010028\nwrite16 0x.....164 <- \)\(0x....\)/\r>>> Switch Channel(\2) start\r\1\2/

:%s/\( radio_read(0x009d) -> 0x00..\nradio_write(0x009d) <- 0x00..\nradio_write(0x009e) <- 0x00..\nradio_write(0x002a) <- 0x00..\n radio_read(0x0030) -> 0x00..\nradio_write(0x0030) <- 0x00..\)/\r>>> Radio Channel Setup start\r\1/
:%s/\( radio_read(0x0057) -> 0x....\nradio_write(0x0057) <- 0x....\nradio_write(0x0044) <- 0x....\nradio_write(0x012b) <- 0x....\nradio_write(0x0038) <- 0x....\nradio_write(0x0091) <- 0x....\)/\1\r>>> Radio Channel Setup end\r/


:%s/\( phy_read(0x044a).*\nphy_write(0x044a).*\n phy_read(0x044a).*\nphy_write(0x044a).*\n phy_read(0x06d1).*\)/\r>>> PHY init start\r\1/

:%s/\(phy_write(0x0455) <- 0x6000\(\nphy_write(0x0457) <- 0x0008\nphy_write(0x0456) <- 0x0000\)\{160}\)/\1\r>>> Init static tables end\r/

:%s/\(phy_write(0x0455) <- 0x3c00\nphy_write(0x0456) <- 0x0002\nphy_write(0x0456) <- 0x0008\nphy_write(0x0456) <- 0x0004\nphy_write(0x0456) <- 0x0001\)/\r>>> SW ctl tbl start\r\1/
:%s/\(phy_write(0x0456) <- 0x0002\nphy_write(0x0456) <- 0x0008\nphy_write(0x0456) <- 0x0004\nphy_write(0x0456) <- 0x0001\)\n\(phy_write(0x0455)\)/\1\r>>> SW ctl tbl end\r\r\2/

:%s/\(phy_write(0x0455) <- 0x1d40\n phy_read(0x0456) -> 0x....\n phy_read(0x0457) -> 0x....\nphy_write(0x0455) <- 0x1cc0\n phy_read(0x0456) -> 0x....\n phy_read(0x0457) -> 0x....\nphy_write(0x0455) <- 0x1e40\)/\r>>> Load RF power start\r\1/
:%s/\(phy_write(0x0455) <- 0x1dbf\n phy_read(0x0456) -> 0x....\n phy_read(0x0457) -> 0x....\nphy_write(0x0455) <- 0x1d3f\n phy_read(0x0456) -> 0x....\n phy_read(0x0457) -> 0x....\nphy_write(0x0455) <- 0x1ebf\nphy_write(0x0457) <- 0x....\nphy_write(0x0456) <- 0x....\)/\1\r>>> Load RF power end\r/

:%s/\( phy_read(0x043c).*\n phy_read(0x043b).*\nphy_write(0x043c).*\nphy_write(0x043b).*\nphy_write(0x043c).*\nphy_write(0x043b).*\nphy_write(0x043c).*\nphy_write(0x043b).*\)/\r>>> AFE set unset start\r\1\r>>> AFE set unset end\r/

:%s/\(phy_write(0x0455) <- 0x6000\nphy_write(0x0457) <- 0x0008\nphy_write(0x0456) <- 0x0000\nphy_write(0x0455) <- 0x6001\)/\r>>> Clean 0x18 table start\r\1/
:%s/\(phy_write(0x0455) <- 0x607f\nphy_write(0x0457) <- 0x0008\nphy_write(0x0456) <- 0x0000\)/\1\r>>> Clean 0x18 table end\r/

:%s/\(phy_write(0x0455) <- 0x1f40\nphy_write(0x0457) <- 0x0000\nphy_write(0x0456) <- 0x0000\nphy_write(0x0457) <- 0x0000\nphy_write(0x0456) <- 0x0000\)/\r>>> Clear 0x7 table start\r\1/

:%s/\( radio_read(0x0007) -> 0x....\n radio_read(0x00ff) -> 0x....\n radio_read(0x011f) -> 0x....\n radio_read(0x0005) -> 0x....\n radio_read(0x0025) -> 0x....\n radio_read(0x0112) -> 0x....\)/\r>>> Save config restore start\r\1/
:%s/\( phy_read(0x04b0) -> 0x....\nphy_write(0x04b0) <- 0x....\n phy_read(0x04b0) -> 0x....\nphy_write(0x04b0) <- 0x....\n phy_read(0x043b) -> 0x....\nphy_write(0x043b) <- 0x....\nradio_write(0x04a4) <- 0x....\)/\1\r>>> Save config restore end\r/

:%s/\(radio_write(0x009c) <- 0x....\nradio_write(0x0105) <- 0x....\nradio_write(0x0032) <- 0x....\nradio_write(0x0033) <- 0x....\)/\r>>> Radio 2064 init start\r\1/

:%s/\(phy_write(0x0933) <- 0x....\nphy_write(0x0934) <- 0x....\nphy_write(0x0935) <- 0x....\nphy_write(0x0936) <- 0x....\nphy_write(0x0937) <- 0x....\)/\r>>> wlc_lcnphy_rc_cal start\r\1\r>>> wlc_lcnphy_rc_cal end\r>>> Radio 2064 init end\r/

:%s/\n\n\n/\r\r/

:wq
EOO
else
	echo "Podaj plik jako argument"
fi
