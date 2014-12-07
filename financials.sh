#!/bin/bash

stock_ticker=$1

## Example, for EDC
##             ["Sep 2013","Dec 2013","Mar 2014","Jun 2014"],
##            [1983.438,-610.2798,2375.9754,3909.3485],
##            [6349.3609,5873.0413,7137.8642,8089.3867],
##            [31.2384,-10.3912,33.2869,48.3269]);
##
## Each column represents for each quarter.
## per quarter, each line represents:
##  * Net Income (M): 
##  * Revenue (M)
##  * Profit Margin (%): 

curl -s http://www.bloomberg.com/quote/${stock_ticker}:PM |grep -A4 create_income_statement |grep -v create_income_statement|sed 's/["\[;)]//g'|sed 's/\,$//g'|sed 's/]//g'|sed "s/^[ \t]*//g"> $stock_ticker
