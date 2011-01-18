#!/bin/sh

# Based on the accepted answer in
# http://stackoverflow.com/questions/3916092/how-to-write-an-xcode-user-script-to-surround-the-string-the-cursor-is-inside-wit
# 
# Author:
#	-	Yang Meyer
# 
# Xcode integration:
#	-	Input: Selection
#	-	Output: Replace Selection
# 
# Suggested keyboard shortcut:
# 	-	Cmd-Alt-Shift-up
#
# Usage:
#	-	With the blinking cursor inside a method, invoke the user script (using the keyboard
#		shortcut or choosing the item from the Scripts menu).
#	-	You should save the file before you invoke the script.
#
# Ideas for improvement:
# 	-	More succinct pattern-matching using sed, instead of iterating through the characters.
#		(Steps 1 and 3 should be just one regex: Look for the method-def pattern and only
#		retain the name part, discarding the rest.)
#	-	Assign return value of super call to accordingly-typed variable, e.g.
#		id <#something#> = [super initWithFrame:frame]

# see insert-super-call-tests.sh for input/output values
function super_call_from_definition() {
	MethodDef=$1
	# strip stuff in parens (types) and enclosing whitespace:
	MethodDefWithoutTypes=`echo $MethodDef | sed s/\ *\([^\)]*\)\ *//g`
	# strip minus/plus, whitespace, and opening curly bracket from beginning:
	MethodDefTrimmed=`echo $MethodDefWithoutTypes | sed s/^\ *[-+]\ *//g | sed s/\ *{//g`
	# make super call
	SuperCall=`echo $MethodDefTrimmed | sed 's/.*/\[super &\];/g'`
	echo "$SuperCall"
}

if [ %%%{PBXSelectionLength}%%% -gt 0 ]
  then
    echo "This does not work if you select text. Put your cursor inside a String." >&2
    exit
fi
Source=`cat "%%%{PBXFilePath}%%%"`
SelectionStart="%%%{PBXSelectionStart}%%%"
SelectionEnd="%%%{PBXSelectionEnd}%%%"
StringStart=$SelectionStart

# Step 1: Determine position of method definition start:
#         move backwards 1 char at a time until you see something like '- (' or '+('
BOOL=1
while [ $BOOL -eq 1 ]
 do
  tmpText=`echo "${Source:${StringStart}:3}"`
  if [[ "$tmpText" =~ ^\ *[-+]\ *\( ]]
   then BOOL=0
   else StringStart=$(($StringStart - 1))
  fi
done

# Step 2: Determine position of method definition end:
#         move forward until you see '{'
StringStop=$StringStart
BOOL=1
while [ $BOOL -eq 1 ]
 do 
  tmpText=`echo "${Source:${StringStop}:1}"`
  if [ "$tmpText" = "{" ]
   then BOOL=0
   else StringStop=$(($StringStop + 1))
  fi   
done

# Step 3: Use method definition to build super call.
MethodDef=`echo ${Source:${StringStart}:$(($StringStop - $StringStart))}`
SuperCall=`super_call_from_definition "$MethodDef"`
echo -n "$SuperCall"
