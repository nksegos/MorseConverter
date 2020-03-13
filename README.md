# MorseConverter
A command line tool for converting text to morse code and vise-versa.

## Execution modes
* **Interactive**: Launch up an interactive interpreter for the specified payload type to convert.
* **Load payload from argument**: Run the conversion on the payload provided as a script option.
* **Load payload from file**: Run the conversion on the payload provided from a file.

## Implemented Alphabet
The implementation supports the standard International Morse Code **[A-Za-z0-9]**, plus the following characters: **| . | , | ? | ' | ! | / | ( | ) | & | : | ; | = | + | - | _ | " | $ | @ |** 
## Usage
```
$ ./morseconv.sh -h
Usage:
 		-t PAYLOAD_TYPE: Provide the type of the input payload.Valid values are text or morse.(Default:text)
 		-i PAYLOAD: Provide the input payload to be converted.
 		-f PAYLOAD_FILE: Load input payload from a file.
 		-m: Mute the sound transcription when converting text to morse.
 		-h: Display help menu.

NOTE: If no options are supplied, the script will start up as an interactive interpreter with the default payload type set.
```
## Examples

### Interactive Mode
```
$ ./morseconv.sh -t TEXT

MorseConv> this is an example.
- .... .. ... / .. ... / .- -. / . -..- .- -- .--. .-.. . .-.-.- / 

MorseConv> 
```
