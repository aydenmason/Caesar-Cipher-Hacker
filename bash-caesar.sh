#!/bin/bash
wordPercentage=20
letterPercentage=70
num1=1
num0=0
num100=100
godKey=-1
while IFS=' ' read -r line; do
message=$line
SYMBOLS="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890 !?."

if [ ${#message} -lt $num1 ] 
then
	echo
fi
for((key=1;key<=${#SYMBOLS};key++));
do
	if [ $godKey -gt $num0 ] 
	then 
	 key=$godKey
	else 
	 key=$key
	fi
	translated=''
	for((i=0;i<${#message};i++));
	do
		temp=${message:$i:1}
		
		if grep -q -F -d skip "$temp" <<< "$SYMBOLS";
		  then
		    indexSymbol=$(awk -v z="$temp" -v x="$SYMBOLS" 'BEGIN{print index(x, z)}')
		    indexSymbol=$(($indexSymbol-$num1))
		    translatedIndex=$(($indexSymbol-$key))
			
				if [ $translatedIndex -lt $num0 ]
					then
					translatedIndex=$(($translatedIndex+${#SYMBOLS}))	
					
				fi
			tempChar=${SYMBOLS:$translatedIndex:1}
			
			translated+=$tempChar
		else
			
		    translated+=$temp
		fi
	done
	
	
	detectString=${translated^^}
	
	
	detectString=${detectString//[^[:alpha:]" "]/}
	
	numLetters=${#detectString}
	
	IFS=' ', read -r -a array <<< "$detectString"
	sum=0
	
	
	File='dictionary.txt'
	if [ ${#array[@]} -lt $num1 ] 
	then
		engCount=0
		break
	fi
	for val in "${array[@]}"
	do 
		
		if grep -w -q -F -e "$val" "$File";then
			sum=$((++sum))
			
		fi
	done
	engCount=$(($sum *$num100 / ${#array[@]} ))
	
	if [ $engCount -ge $wordPercentage ]
	then
		wordsMatch=true
	else
		wordsMatch=false
	fi
	letterCount=$(($numLetters * $num100 / ${#message} ))
	
	
	
	if [ $letterCount -ge $letterPercentage ] 
	then 
		lettersMatch=true
	else
		lettersMatch=false
	fi
	if [ $wordsMatch = true ] && [ $lettersMatch = true ]
	then 
		echo $translated
		godKey=$key
		break
	fi
done

done 
