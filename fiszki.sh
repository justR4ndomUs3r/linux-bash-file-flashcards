#!/bin/bash

function bad_format {
  echo "Help"
  echo "Argument 1(separator):"
  echo "Dowolny znak przedstawiajacy separator w pliku"
  echo "Argument 2(wyswietlanie):"
  echo "-pl - wyswietla polskie slowo, -en - wyswietla angielskie slowo"
  echo "Argument 3(dzwiek):"
  echo "-n tylko wyswietla slowo, -t tylko wypowiada slowa, -tn wypowiada i wyswietla slowo"
  echo "Pozostale argumenty to nazwa pliku"
  echo "przyklad: fiszki.sh : -pl -t fiszki.txt"
} 1>&2

if (( $# <= 3 )); then
  bad_format
  exit 1
fi

separator=$1
display=$2
sound=$3
shift 3

correct=0
wrong=0

for ((;$# > 0;))
do
  file=$1
  num=`cat $file | grep "$separator" | wc -l`
  
  for ((i=1;i <= $num; i++))
  do
    pl=`cat $file | grep "$separator" |head -n $i | tail -n 1 | cut -d $separator -f 1`
    en=`cat $file | grep "$separator" |head -n $i | tail -n 1 | cut -d $separator -f 2`
    if [[ $display == "-en" ]]; then
      show=$en
      hide=$pl
    elif [[ $display == "-pl" ]]; then
      show=$pl
      hide=$en
    else
      bad_format
      exit 1
    fi
    

    if [[ $sound == "-n" ]]; then
      echo $show
    elif [[ $sound == "-t" ]]; then
      espeak $show
    elif [[ $sound == "-tn" ]]; then
      echo $show
      espeak $show
    else
      bad_format
      exit 1
    fi

    read -p "Twoja odpowiedz: " -t 10 user
    if [[ $user == $hide ]]; then
      echo "+++++DOBRZE+++++"
      correct=`expr $correct + 1`
    else
      echo "-----ŹLE-----"
      wrong=`expr $wrong + 1`
    fi
  done

  shift
done

all=`expr $correct + $wrong`
if (( $all == 0 )); then
  echo "error 404"
  echo "Bledny separator lub nazwa pliku"
  exit 2
fi
echo "Poprawne odpowiedzi: "
echo $correct
echo "Niepoprawne odpowiedzi: "
echo $wrong
percent=`expr 100 \* $correct / $all`
echo "Wynik procentowy"
echo $percent
