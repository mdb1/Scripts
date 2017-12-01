#!/bin/bash

echo "Escribí el path a tu archivo de regresión. Incluyendo el '.csv' final"
read file
echo -e "\n"

INPUT=$file
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
finalText=""
NEWLINE=$'\n'
failedCount=0
blockedCount=0

finalText+="Listado de faileds:${NEWLINE}"

while read id title category status reason column6
do
	if [ "$status" == "failed" ]; then
		if [ "$reason" == "" ]; then
			finalText+=$"${NEWLINE}$id - $category - $title: No se escribió razón del failed"
		else
			finalText+=$"${NEWLINE}$id - $category - $title: $reason"
		fi
		((failedCount++))
	fi

done < $INPUT

finalText+="${NEWLINE}${NEWLINE}Listado de blockeds:${NEWLINE}"

while read id title category status reason column6
do
	if [ "$status" == "blocked" ]; then
		if [ "$reason" == "" ]; then
			finalText+=$"${NEWLINE}$id - $category - $title: No se escribió razón del blocked"
		else
			finalText+=$"${NEWLINE}$id - $category - $title: $reason"
		fi
		((blockedCount++))
	fi

done < $INPUT

echo -e "Listo!\n"
echo -e "Cantidad de faileds: $failedCount\n"
echo -e "Cantidad de blockeds: $blockedCount\n"
echo -e "El resumen de tu regresión está copiado en tu portapapeles, ya podés mandárselo al actual Regre Manager.\n"

finalText+="${NEWLINE}${NEWLINE}Cantidad de faileds: $failedCount"
finalText+="${NEWLINE}Cantidad de blockeds: $blockedCount"

echo $finalText | pbcopy

IFS=$OLDIFS
