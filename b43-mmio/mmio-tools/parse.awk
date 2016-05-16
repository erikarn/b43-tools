# parse: converts to nice [read|write]BITS format with proper zero-leads
#        less interesting numbers are dropped
#
# Example:
# R 4 75.996606 1 0xf0400ffc 0x42438209 0x0 0
# read32 0xf0400ffc -> 0x42438209
#
# R 4 75.996633 1 0xf040002c 0x10 0x0 0
# read32 0xf040002c -> 0x00000010

$1 == "R" || $1 == "W" {
	#operation and register
	bits = $2 * 8;
	if ($1 == "R")
		printf(" read%2d 0x%x -> ", bits, $4);
	else
		printf("write%2d 0x%x <- ", bits, $4);

	# value
	if ($2 == 1)
		printf("0x%.2x", $5);
	else if ($2 == 2)
		printf("0x%.4x", $5);
	else if ($2 == 4)
		printf("0x%.8x", $5);
	printf("\n");
}
