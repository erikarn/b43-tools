# filter: leaves only R/W ops lines

/^\[[0-9 ]+\.[0-9]{6}\]/ {
	print substr($0, index($0, "] ") + 2)
}
