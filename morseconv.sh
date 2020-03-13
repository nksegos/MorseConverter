#!/bin/bash

MUTE=0
MODE=0
TRANSCRIPT=""
declare -A text_to_morse #Build text_to_morse code dictionary
text_to_morse['A']='.-' 	; 	text_to_morse['B']='-...' 	; 	text_to_morse['C']='-.-.' 	;
text_to_morse['D']='-..' 	; 	text_to_morse['E']='.'    	; 	text_to_morse['F']='..-.' 	;
text_to_morse['G']='--.' 	; 	text_to_morse['H']='....'    	; 	text_to_morse['I']='..'   	;
text_to_morse['J']='.---' 	; 	text_to_morse['K']='-.-'     	; 	text_to_morse['L']='.-..' 	;
text_to_morse['M']='--'  	; 	text_to_morse['N']='-.'      	; 	text_to_morse['O']='---'  	;
text_to_morse['P']='.--.' 	; 	text_to_morse['Q']='--.-' 	; 	text_to_morse['R']='.-.' 	;
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


## Usage function 
Usage(){
	echo "Usage:"
	echo " 		-t PAYLOAD_TYPE: Provide the type of the input payload.Valid values are text or morse.(Default:morse)"
	echo " 		-i PAYLOAD: Provide the input payload to be converted."
	echo " 		-f PAYLOAD_FILE: Load input payload from a file."
	echo " 		-m: Mute the sound transcription when converting text to morse."
	echo " 		-h: Display help menu."
	echo ""
}


# Input collection and sanitization START

while getopts ":t:i:f:mh" opt ; do
	case $opt in
		t)
			if [[ "${OPTARG^^}" == "MORSE" ]]; then
				MODE=0
			elif [[ "${OPTARG^^}" == "TEXT" ]]; then
				MODE=1
			else
				echo "Invalid mode!"
				Usage
				exit 1
			fi
			;; 
		i)
			if [ -z "$OPTARG" ]; then
				echo "Empty payload!"
				exit 1
			fi
			PAYLOAD=$OPTARG
			;;
		f)
			if [ -f "$OPTARG" ]; then
				PAYLOAD=$(cat $OPTARG)
			else
				echo "The file $OPTARG doesn't exit."
				exit 1
			fi
			;;
		m)
			MUTE=1
			;;
		h)
			Usage
			exit 0
			;;
		\?)
			echo "Invalid option: -$OPTARG"
			Usage
			exit 1
			;;
		:)
			echo "Option -$OPTARG requires an argument."
			Usage
			exit 1
			;;
	esac
done










while true ; do
	read -p "MorseConv> " USER_INPUT
	if [ "$?" -eq 1 ]; then
		printf '\n'
		exit 0
	elif [[ "${USER_INPUT,,}" == *"quit"* ]]; then
		printf '\n'
		exit 0
	fi	

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
		for (( i=0; i<${#USER_INPUT}; i++ )); do
			if echo "${USER_INPUT:$i:1}" | grep -q  "\*\|\^\|\%\|\[\|\]\|\{\|\}\|\~\|\`\|>\|<\|\#\||\|\\\\" ; then
				true
			elif [[ "${USER_INPUT:$i:1}" =~ [[:space:]] ]]; then
				TRANSCRIPT="${TRANSCRIPT}/ "
				printf "/ "
			else
				TRANSCRIPT="${TRANSCRIPT}${text_to_morse[${USER_INPUT:$i:1}]} "
				printf "%s " "${text_to_morse[${USER_INPUT:$i:1}]}"
			fi
		done
		printf "\n"
	fi

	
	if [ "$MUTE" -eq 0 ] && [ "$MODE" -eq 1 ]; then	
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

