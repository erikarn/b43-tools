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

:%s/\(phy_write(0x0911).*\nphy_write(0x0910).*\nphy_write(0x0915).*\nphy_write(0x0914).*\nphy_write(0x0919).*\nphy_write(0x0918).*\)/\r>>> analog(ON) start\r\1\r>>> analog(ON) end\r/
:%s/\(phy_write(0x0910).*\nphy_write(0x0911).*\nphy_write(0x0914).*\nphy_write(0x0915).*\nphy_write(0x0918).*\nphy_write(0x0919).*\)/\r>>> analog(OFF) start\r\1\r>>> analog(OFF) end\r/

:%s/\( phy_read(0x0810).*\)\n\(phy_write(0x0810).*\)\n\( phy_read(0x0810).*\)\n\(phy_write(0x0810).*\)\n\( phy_read(0x0810).*\)\n\(phy_write(0x0810).*\)\n\( phy_read(0x0810).*\)\n\(phy_write(0x0810).*\)/__\1\r__\2\r__\3\r__\4\r__\5\r__\6\r__\7\r__\8/
:%s/\( phy_read(0x0810).*\nphy_write(0x0810).*\)/\r>>> Switch Radio(OFF) start\r\1\r>>> Switch Radio(OFF) end\r/
:%s/__\( phy_read(0x0810).*\)\n__\(phy_write(0x0810).*\)\n__\( phy_read(0x0810).*\)\n__\(phy_write(0x0810).*\)\n__\( phy_read(0x0810).*\)\n__\(phy_write(0x0810).*\)\n__\( phy_read(0x0810).*\)\n__\(phy_write(0x0810).*\)/\r>>> Switch Radio(ON) start\r\1\r\2\r\3\r\4\r\5\r\6\r\7\r\8/

:%s/\(write32 0x.....160 <- 0x00010028\n read32 0x.....160 -> 0x00010028\nwrite16 0x.....164 <- \)\(0x....\)/\r>>> Switch Channel(\2) start\r\1\2/
:%s/\(phy_write(0x0073).*\nphy_write(0x017e) <- 0x3830\)/\1\r>>> Switch Channel(????) end\r/

:%s/\(radio_write(0x0016) <- 0x00..\nradio_write(0x0017) <- 0x00..\nradio_write(0x0022) <- 0x00..\nradio_write(0x0025) <- 0x00..\nradio_write(0x0027) <- 0x00..\)/\r>>> Radio Channel Setup start\r\1/
:%s/\( radio_read(0x002b) -> 0x....\nradio_write(0x002b) <- 0x....\n radio_read(0x002e) -> 0x....\nradio_write(0x002e) <- 0x....\n radio_read(0x002e) -> 0x....\nradio_write(0x002e) <- 0x....\n radio_read(0x002b) -> 0x....\nradio_write(0x002b) <- 0x....\)/\1\r>>> Radio Channel Setup end\r/

:%s/\(phy_write(0x0072) <- 0x4800\nphy_write(0x0073) <- 0x0000\nphy_write(0x0073) <- 0x0008\)/\r>>> PHY init start\r\1/

:%s/\( phy_read(0x040e) -> 0x....\n phy_read(0x044e) -> 0x....\n phy_read(0x048e) -> 0x....\)/\r>>> Read clip state start\r\1\r>>> Read clip state end\r\r/

:%s/\( phy_read(0x0800) -> 0x....\n phy_read(0x0800) -> 0x....\nphy_write(0x0800) <- 0x....\n phy_read(0x0803) -> 0x....\nphy_write(0x0803) <- 0x....\n\( phy_read(0x0804) -> 0x....\n\)\{1,3\}phy_write(0x0800) <- 0x....\)/\r>>> Force RF seq start\r\1\r>>> Force RF seq end\r\r/

:%s/\( phy_read(0x0911) -> 0x....\nphy_write(0x0911) <- 0x....\n phy_read(0x0910) -> 0x....\nphy_write(0x0910) <- 0x....\n phy_read(0x0911) -> 0x....\nphy_write(0x0911) <- 0x....\n phy_read(0x0910) -> 0x....\nphy_write(0x0910) <- 0x....\)/\r>>> LOOP #1 start\r\1/
:%s/\( phy_read(0x0918) -> 0x....\nphy_write(0x0918) <- 0x....\nphy_write(0x0072) <- 0x....\nphy_write(0x0073) <- 0x....\n phy_read(0x0918) -> 0x....\nphy_write(0x0918) <- 0x....\)/\1\r>>> LOOP #1 end\r/

:%s/\n\n\n/\r\r/

:wq
EOO
else
	echo "Podaj plik jako argument"
fi
