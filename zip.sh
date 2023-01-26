#!/bin/bash

read -p "Enter the directory to zip: " DIC
DICS=($DIC)

FILES=($(ls $DIC))

RE="^[0-9]+([.][0-9]+)?$"
declare -i C=0 N P LEN

for i in ${FILES[@]}; do 
    if ! [[ $i =~ $RE ]] ; then
        unset FILES[$C]
    fi
    
    C+=1         
done

LEN=${#FILES[@]}

FILES=( $(printf "%s\n" ${FILES[@]} | sort ) )

read -p "The number of folders to devide it to: " N

P=LEN/N
P=${P#![0-9]*}

echo $P

N=$((N-1))

for (( i=1; i<=$N; i++ )); do
	DIRC="${DIC}_$i"
	DICS=(${DICS[@]} $DIRC)
	mkdir $DIRC 
	for (( j=1; j<=$P; j++ )); do
		mv $DIC/${FILES[$j]} $DIRC/
		echo "moving ${FILES[$j]} to $DIRC"
		unset FILES[$j]
	done
	FILES=( $(printf "%s\n" ${FILES[@]} | sort ) )
done

echo ${DICS[@]}

for k in ${DICS[@]}; do
	echo "Zipping $k ..."
	zip -r $k $k
	rm -r $k
	echo "Removing $k ..."
done	

echo "Zipping is done :)"
