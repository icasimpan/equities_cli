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

get_PrevClose() {
  echo $(curl -s http://www.reuters.com/finance/stocks/overview?symbol=$1.PS|grep -A2 "Prev Close"|grep -v Close|grep span|awk -F\; '{print $NF}'|cut -d'<' -f1)
}

get_Open() {
  echo $(curl -s http://www.reuters.com/finance/stocks/overview?symbol=$1.PS|grep -A2 "Open"|grep -v Open|grep span|awk -F\; '{print $NF}'|cut -d'<' -f1)
}

get_DayHigh() {
  echo $(curl -s http://www.reuters.com/finance/stocks/overview?symbol=$1.PS|grep -A2 "Day's High"|grep sectionQuoteDetailHigh|awk -F\; '{print $NF}'|cut -d'<' -f1)
}

get_DayLow() {
  echo $(curl -s http://www.reuters.com/finance/stocks/overview?symbol=$1.PS|grep -A2 "Day's Low"|grep sectionQuoteDetailLow|awk -F\; '{print $NF}'|cut -d'<' -f1)
}

for each_ticker in $ticker; do
 echo "[$each_ticker] -> "
 curr_price=$(curl -s www.reuters.com/finance/stocks/overview?symbol=$each_ticker.PS|grep -A3 "on Philippine Stock Exchange"|grep PHP|cut -d'<' -f1|sed 's/^[ \t]*//')

## only show info if $curr_price is found
 if [[ "$curr_price" != "" ]]; then
   echo "Current Price: $curr_price"
   echo "Prev Close:  $(get_PrevClose "$each_ticker")"
   echo "Open: $(get_Open "$each_ticker")"
   echo "Day's High:  $(get_DayHigh "$each_ticker")"
   echo "Day's Low:  $(get_DayLow "$each_ticker")"
 fi

 echo '-------------------------'
done
