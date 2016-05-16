parsed = 0;

#phy
$2 ~ /(3fc)$/ {
	if ($1 == "write16") {
		parsed = 1;
		phy_reg = $4;
	} else if ($1 == "write32") { #wl does such a weird 32-bit write, mostly for tables
		parsed = 1;
		phy_reg = "0x" substr($4, 7);
		print "phy_write(" phy_reg ") <- " substr($4, 1, 6);
	}
}
$2 ~ /(3fe)$/ {
	if ($1 == "read16") {
		parsed = 1;
		print " phy_read(" phy_reg ") -> " $4;
	} else if ($1 == "write16") {
		parsed = 1;
		print "phy_write(" phy_reg ") <- " $4;
	}
}

#radio
$2 ~ /(3f6)$/ {
	if ($1 == "write16") {
		parsed = 1;
		radio_reg = $4;
	}
}
$2 ~ /(3fa)$/ {
	if ($1 == "read16") {
		parsed = 1;
		print " radio_read(" radio_reg ") -> " $4;
	} else if ($1 == "write16") {
		parsed = 1;
		print "radio_write(" radio_reg ") <- " $4;
	}
}

#radio24
$2 ~ /(3d8)$/ {
	if ($1 == "write16") {
		parsed = 1;
		radio24_reg = $4;
	}
}
$2 ~ /(3da)$/ {
	if ($1 == "read16") {
		parsed = 1;
		print " radio_read(" radio24_reg ") -> " $4;
	} else if ($1 == "write16") {
		parsed = 1;
		print "radio_write(" radio24_reg ") <- " $4;
	}
}

parsed == 0 {
	print;
}
