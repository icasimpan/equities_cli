#!/bin/bash

ticker="
CNPF
COSCO
DMPL
PCOR
RFM
SMPH
CEB
IMI
LC
PNX
SMC
FDC
"

for each_ticker in $ticker; do
 echo -n "[$each_ticker] -> "
 price=$(curl -s www.reuters.com/finance/stocks/overview?symbol=$each_ticker.PS|grep -A3 "on Philippine Stock Exchange"|grep PHP|cut -d'<' -f1|sed 's/^[ \t]*//')

 [[ "$price" != "" ]] && echo "$price" || echo 'N/A'
done
