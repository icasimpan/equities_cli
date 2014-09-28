#!/bin/bash

my_portfolio="
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

ticker=$(echo $*|tr a-z A-Z)
[[ "$ticker" = "" ]] && ticker=$my_portfolio

for each_ticker in $ticker; do
  echo -n "[$each_ticker] - "
  grade=$(curl -s http://www.reuters.com/finance/stocks/overview?symbol=$each_ticker.PS|grep "Analyst Recommendation"|sed 's!.* title="\([0-9]*.[0-9]*\)" />!\1!g')
  [[ "$grade" != "" ]] && echo $grade || echo 'N/A'
done
