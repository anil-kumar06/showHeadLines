#!/bin/bash

NC='\033[0m'
BBlue='\033[1;34m'
BPurple='\033[1;35m'
BRed='\033[1;31m' 
BGreen='\033[1;32m'
FILE_NAME=/tmp/theHindu.html.$$
FINAL_FILE_NAME=/tmp/theHindu.html.final.$$

wget -O $FILE_NAME https://www.thehindu.com/news/  >/dev/null 2>&1
if [ $? -ne 0 ];then
  echo -e "$BRed Error in running wget command !!! $NC"
  exit 1
fi

if [ -f $FILE_NAME ]; then 
  grep -A 1 mins $FILE_NAME | grep -v "</span" | grep -v "-" | cut -d '<' -f 1 > $FINAL_FILE_NAME
  grep -A 1 hrs $FILE_NAME | grep -v "</span" | grep -v "-" | cut -d '<' -f 1 >> $FINAL_FILE_NAME
  grep " | " $FILE_NAME | grep "teaser-text" | cut -d '>' -f 3 | cut -d '<' -f 1 >> $FINAL_FILE_NAME

  echo -e "$BRed Welcome to the News application"
  echo -e "------------------------------------------$NC"
else
  echo -e "$BRed Some error happened !!! $NC"
  default_colour=$(tput sgr0)
  # Check if connected to Internet or not
  ping -c 1 google.com &> /dev/null && echo -e '\E[32m'"Internet: $default_colour Connected" || echo -e '\E[32m'"Internet: $default_colour Disconnected"
  exit 1
fi

counter=0
while read -r line
do
    if [ "XX$line" == "XX" ]; then
      continue
    else
    counter=$((counter+1))
    echo -e "$BPurple $counter. $BBlue$line $NC"
    #sleep 1
fi 
done < "$FINAL_FILE_NAME"
echo "Total Head Lines : $counter"

rm -f $FILE_NAME*

