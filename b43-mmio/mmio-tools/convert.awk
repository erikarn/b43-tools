# convert: converts ugly timestamp from mmiotrace pipe output into dmesg-like
#          other lines will be left untouched
#
# Usage:
# awk --posix -f convert.awk dump.txt
# awk --posix -f convert.awk dump.txt > nicedump.txt
# cat ugly.txt | awk --posix -f convert.awk > nicedump.txt

{
	#        example of mmiotrace pipe output:
	#           R     2    1.004510   2    0xff  0xff  0xff   0
	if ($0 ~ /^[RW] [0-9]+ [0-9\.]+ [0-9]+ (0x[0-9a-f]+ ){3}[0-9]+/) {
		# print timestamp first, inside [] and with enough spaces
		printf("[%12s]", $3);
		# print rest of the line (simply skipping $3)
		print OFS $1, $2, $4, $5, $6, $7, $8;
	} else {
		print; # print other lines untouched
	}
}
