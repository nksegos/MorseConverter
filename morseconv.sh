#!/bin/bash

MUTE=1
MODE=0
TRANSCRIPT=""
declare -A text_to_morse #Build text_to_morse code dictionary
text_to_morse['A']='.-' 	; 	text_to_morse['B']='-...' 	; 	text_to_morse['C']='-.-.' 	;
text_to_morse['D']='-..' 	; 	text_to_morse['E']='.'    	; 	text_to_morse['F']='..-.' 	;
text_to_morse['G']='--.' 	; 	text_to_morse['H']='....'    	; 	text_to_morse['I']='..'   	;
text_to_morse['J']='.---' 	; 	text_to_morse['K']='-.-'     	; 	text_to_morse['L']='.-..' 	;
text_to_morse['M']='--'  	; 	text_to_morse['N']='-.'      	; 	text_to_morse['O']='---'  	;
text_to_morse['P']='.--.' 	; 	text_to_morse['Q']='---.--.-' 	; 	text_to_morse['R']='--.-' 	;
text_to_morse['S']='...' 	; 	text_to_morse['T']='-'       	; 	text_to_morse['U']='..-' 	;
text_to_morse['V']='...-' 	; 	text_to_morse['W']='.--'     	; 	text_to_morse['X']='-..-' 	;
text_to_morse['Y']='-.--' 	; 	text_to_morse['Z']='--..' 	;

text_to_morse['0']='-----' 	; 	text_to_morse['1']='.----'   	;
text_to_morse['2']='..---' 	; 	text_to_morse['3']='...--'   	;
text_to_morse['4']='....-' 	; 	text_to_morse['5']='.....'   	;
text_to_morse['6']='-....' 	; 	text_to_morse['7']='--...'   	;
text_to_morse['8']='---..' 	; 	text_to_morse['9']='----.'   	;

text_to_morse['.']='.-.-.-'  	; 	text_to_morse[',']='--..--'  	; 	text_to_morse['?']='..--..' 	;
text_to_morse["'"]='.----.' 	; 	text_to_morse['!']='-.-.--'  	; 	text_to_morse['/']='-..-.' 	;
text_to_morse['(']='-.--.'   	; 	text_to_morse[')']='-.--.-'  	; 	text_to_morse['&']='.-...' 	;
text_to_morse[':']='---...'  	; 	text_to_morse[';']='-.-.-.'  	; 	text_to_morse['=']='-...-' 	;
text_to_morse['+']='.-.-.'   	; 	text_to_morse['-']='-....-'  	; 	text_to_morse['_']='..--.-' 	;
text_to_morse['"']='.-..-.'  	; 	text_to_morse['$']='...-..-' 	; 	text_to_morse['@']='.--.-.' 	;

# Build reverse dictionary
declare -A morse_to_text
for i in "${!text_to_morse[@]}"; do
  morse_to_text["${text_to_morse[$i]}"]="$i"
done




#exit 0

while true ; do
	read -p "MorseConv> " USER_INPUT
	if [ "$?" -eq 1 ]; then
		printf '\n'
		exit 0
	elif [[ "${USER_INPUT,,}" == *"quit"* ]]; then
		printf '\n'
		exit 0
	fi	
#	for one_thing in $USER_INPUT; do
#    	echo $one_thing
#	done
	USER_INPUT="${USER_INPUT} "
	BUFFER=""
	if [ "$MODE" -eq 0 ]; then
		TRANSCRIPT=$USER_INPUT
		for (( i=0; i<${#USER_INPUT}; i++ )); do
			if [[ "${USER_INPUT:$i:1}" == "." ]] || [[ "${USER_INPUT:$i:1}" == "-" ]]; then
				BUFFER="${BUFFER}${USER_INPUT:$i:1}"	
			elif [[ "${USER_INPUT:$i:1}" =~ [[:space:]] ]] && [[ "$BUFFER" != "" ]] ; then
				printf "%s" "${morse_to_text[$BUFFER]}"
				BUFFER=""
			elif [[ "${USER_INPUT:$i:1}" == "/" ]]; then
				printf " "
				BUFFER=""
			fi
		done
		printf "\n"
	else
		true
	fi


	
	if [ "$MUTE" -eq 0 ]; then	
		for (( i=0; i<${#TRANSCRIPT}; i++ )); do
			if [[ "${TRANSCRIPT:$i:1}" == "." ]]; then
				paplay ./sounds/short.ogg 
			elif [[ "${TRANSCRIPT:$i:1}" == "-" ]]; then
				paplay ./sounds/long.ogg 
			elif [[ "${TRANSCRIPT:$i:1}" =~ [[:blank:]] ]] || [[ "${TRANSCRIPT:$i:1}" == "/" ]]; then
				sleep 0.3 
			fi
		done
	fi
done

