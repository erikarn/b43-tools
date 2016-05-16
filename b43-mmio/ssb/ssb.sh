#!/bin/sh

# we assume pcie ops happen only in first 500 lines

if [ -e "$1" ]
then
	vim $1>/dev/null<<EOO
:0,500s/write32 0x.....130 <- \(.*\)\n read32 0x.....134 -> \(.*\)/ pcie_read(\1) -> \2/
:0,500s/write32 0x.....130 <- \(.*\)\n read32 0x.....130 -> .*\n read32 0x.....134 -> \(.*\)/ pcie_read(\1) -> \2/
:0,500s/write32 0x.....130 <- \(.*\)\nwrite32 0x.....134 <- \(.*\)/pcie_write(\1) <- \2/

:0,500s/write32 0x.....12c <- 0x507e\(...\)0/pcie_mdio_set_phy(0x\1)/
:0,500s/\(write32 0x.....12c <-\) 0x50\(..\)\(....\)/\1 0x50\2\3 [reg:(0x\2 \& 0x7C)>>2 ; data:0x\3]/
:0,500s/\(write32 0x.....12c <-\) 0x60\(..\)0000/\1 0x60\20000 [reg:(0x\2 \& 0x7C))>>2]/

:0,500s/\(write32 0x.....128 <- 0x00000082\)/\r\1/

:wq
EOO
else
	echo "Pass filename as argument"
fi
