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

get_PrevClose() {
  echo $(cat $ticker_source|grep -A2 "Prev Close"|grep -v Close|grep span|awk -F\; '{print $NF}'|cut -d'<' -f1)
}

get_Open() {
  echo $(cat $ticker_source|grep -A2 "Open"|grep -v Open|grep span|awk -F\; '{print $NF}'|cut -d'<' -f1)
}

get_DayHigh() {
  echo $(cat $ticker_source|grep -A2 "Day's High"|grep sectionQuoteDetailHigh|awk -F\; '{print $NF}'|cut -d'<' -f1)
}

get_DayLow() {
  echo $(cat $ticker_source|grep -A2 "Day's Low"|grep sectionQuoteDetailLow|awk -F\; '{print $NF}'|cut -d'<' -f1)
}


for each_ticker in $ticker; do
 ## only connect once per $ticker so it runs faster

 ticker_source=$(mktemp ./ticker.XXXX)
 curl -s http://www.reuters.com/finance/stocks/overview?symbol=$each_ticker.PS > $ticker_source


 echo "* [$each_ticker]"
 curr_price=$(cat $ticker_source|grep -A3 "on Philippine Stock Exchange"|grep PHP|cut -d'<' -f1|sed 's/^[ \t]*//')

## only show info if $curr_price is found
 if [[ "$curr_price" != "" ]]; then
   echo " Current Price : $curr_price"
   echo " Prev Close    : $(get_PrevClose "$each_ticker")"
   echo " Open          : $(get_Open "$each_ticker")"
   echo " Day's High    : $(get_DayHigh "$each_ticker")"
   echo " Day's Low     : $(get_DayLow "$each_ticker")"
 fi

 ## remove temp file
 rm $ticker_source
 echo '-------------------------'
done
