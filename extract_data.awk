BEGIN { 
	inside = 0
	print("DATE, TIME, FPC, PIC, ENCAP_BYTES, ENCAP_PKTS, DECAP_BYTES, DECAP_PKTS")
 }
    
	/^2021/ { datetime = sprintf("\n%s,%s",$1, $2) } 
	/node0/,/node1/ {
		if (!/node0/ && !/node1/) {
			if ($3 ~/of/) { 
				inside = 1; 
				printf("%s,%s,%s", datetime, $4, $5)
			}
			if ($3 ~/summary/) { inside = 0 }
			if (($2 ~/encapsulation/ || $2 ~/decapsulation/) && inside == 1) { printf (",%s", $4)}
		}
	}
END {
	printf("\n")
}