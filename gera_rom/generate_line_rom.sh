#!/bin/bash

#	Instructions currently available for mounting are: lw, sw, jal, j, jr, add, addi, beq, nop
#	additionaly, the ficticious instruction ldi was added
#	In order to get support to other instructions, you need to modify the "case" below, adding
#	them by yourselves.



##########################################################################################
# Function fill_zero
# Receives as argument:
#	$1: WORD in binary or hexadecimal
#	$2: the field size
#	result: complete the left side of the WORD with zeros until reach the field size
##########################################################################################
function fill_zero() {

	WORD=$1
	NUM=$(expr length $WORD)



	while (( NUM < $2 ))
	do
        	WORD="0$WORD"
        	NUM=$((NUM + 1))
	done

	echo "$WORD"
}


#Vector receives the script arguments
vetor=()

i=0
for j in $*
do
	vetor[$i]=$j
	i=$((i + 1))
done	



INST=${vetor[0]}




case $INST in

lw*)
	
	ADDRESS=${vetor[3]}							#ROM address
	BOP="100101"								#Opcode in binary
  	RT=$(echo "${vetor[1]}"| sed -e "s/\$\([0-9]*\)/\1/g")			#RT register field
  	IMM=$(echo "${vetor[2]}"| sed -e "s/\(^-*[0-9]*\)(.*/\1/g")		#Immediate field
  	RS=$(echo "${vetor[2]}"| sed -e "s/-*[0-9]*(\$\([0-9]*\))/\1/g")	#RS register field
	BRT=$(fill_zero $(echo "ibase=10;obase=2;$RT" | bc) 5)			#RT register field converted to binary
	BRS=$(fill_zero $(echo "ibase=10;obase=2;$RS" | bc) 5)			#RS register field converted to binary
	BIMM=$(./compl_num $IMM)						#Immediate field converted to hexadecimal
	BIMM=$(fill_zero $BIMM 8)						#fill left side of the immediate field with zeros
	#BIMM=$(echo "ibase=16;obase=2;$(echo $BIMM|./upper_case)"|bc)
	BIMM=$(expr substr $BIMM 5 8)

	#Returns the address and the instruction binary format. This is going to represent a ROM line which will be accessed by the instruction fetch of the datapath
	echo "when 	\"$(fill_zero $(echo "ibase=10;obase=2;$ADDRESS" | bc) 6)\" => data_out <= \"$BOP\" & \"$BRS\" & \"$BRT\" & x\"$BIMM\"; -- lw \$$RT, $IMM(\$$RS)"    

	
  	;;

ldi*)
	
	ADDRESS=${vetor[4]}
	#Opcode in binary. As ldi is a "ficticious" MIPS instruction, its Opcode was "stolen" from the instruction ldxc1 (which will probably not be asked to be implemented). 
	BOP="010011"
  	RD=$(echo "${vetor[1]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	RS=$(echo "${vetor[2]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	RT=$(echo "${vetor[3]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	SHAMT="00000"
	FUNCT="000000"
	
	BRD=$(fill_zero $(echo "ibase=10;obase=2;$RD" | bc) 5)
	BRS=$(fill_zero $(echo "ibase=10;obase=2;$RS" | bc) 5)
	BRT=$(fill_zero $(echo "ibase=10;obase=2;$RT" | bc) 5)

	echo "when 	\"$(fill_zero $(echo "ibase=10;obase=2;$ADDRESS" | bc) 6)\" => data_out <= \"$BOP\" & \"$BRS\" & \"$BRT\" & \"$BRD\" & \"$SHAMT\" & \"$FUNCT\"; -- ldi \$$RD, \$$RS, \$$RT"    

	;;


sw*)
  	
	ADDRESS=${vetor[3]}
	BOP="101011"
  	RT=$(echo "${vetor[1]}"| sed -e "s/\$\([0-9]*\)/\1/g")
  	IMM=$(echo "${vetor[2]}"| sed -e "s/\(^-*[0-9]*\)(.*/\1/g")
  	RS=$(echo "${vetor[2]}"| sed -e "s/-*[0-9]*(\$\([0-9]*\))/\1/g")	
	BRT=$(fill_zero $(echo "ibase=10;obase=2;$RT" | bc) 5)
	BRS=$(fill_zero $(echo "ibase=10;obase=2;$RS" | bc) 5)
	BIMM=$(./compl_num $IMM)						#Immediate field converted to hexadecimal
	BIMM=$(fill_zero $BIMM 8)						#fill left side of the immediate field with zeros
	#BIMM=$(echo "ibase=16;obase=2;$(echo $BIMM|./upper_case)"|bc)
	BIMM=$(expr substr $BIMM 5 8)

	echo "when 	\"$(fill_zero $(echo "ibase=10;obase=2;$ADDRESS" | bc) 6)\" => data_out <= \"$BOP\" & \"$BRS\" & \"$BRT\" & x\"$BIMM\"; -- sw \$$RT, $IMM(\$$RS)"    


  	;;

addi*)
	ADDRESS=${vetor[4]}
	BOP="001000"
	RT=$(echo "${vetor[1]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	RS=$(echo "${vetor[2]}"| sed -e "s/\$\([0-9]*\)/\1/g")
 	IMM=$(echo "${vetor[3]}"| sed -e "s/\(^-*[0-9]*\)(.*/\1/g")
	BRT=$(fill_zero $(echo "ibase=10;obase=2;$RT" | bc) 5)
	BRS=$(fill_zero $(echo "ibase=10;obase=2;$RS" | bc) 5)
	BIMM=$(./compl_num $IMM)						#Immediate field converted to hexadecimal
	BIMM=$(fill_zero $BIMM 8)						#fill left side of the immediate field with zeros
	#BIMM=$(echo "ibase=16;obase=2;$(echo $BIMM|./upper_case)"|bc)
	BIMM=$(expr substr $BIMM 5 8)
	
	echo "when 	\"$(fill_zero $(echo "ibase=10;obase=2;$ADDRESS" | bc) 6)\" => data_out <= \"$BOP\" & \"$BRS\" & \"$BRT\" & x\"$BIMM\"; -- addi \$$RT, \$$RS, $IMM"    

  	;;

andi*)
	ADDRESS=${vetor[4]}
	BOP="001100"
	RT=$(echo "${vetor[1]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	RS=$(echo "${vetor[2]}"| sed -e "s/\$\([0-9]*\)/\1/g")
 	IMM=$(echo "${vetor[3]}"| sed -e "s/\(^-*[0-9]*\)(.*/\1/g")
	BRT=$(fill_zero $(echo "ibase=10;obase=2;$RT" | bc) 5)
	BRS=$(fill_zero $(echo "ibase=10;obase=2;$RS" | bc) 5)
	BIMM=$(./compl_num $IMM)						#Immediate field converted to hexadecimal
	BIMM=$(fill_zero $BIMM 8)						#fill left side of the immediate field with zeros
	#BIMM=$(echo "ibase=16;obase=2;$(echo $BIMM|./upper_case)"|bc)
	BIMM=$(expr substr $BIMM 5 8)
	
	echo "when 	\"$(fill_zero $(echo "ibase=10;obase=2;$ADDRESS" | bc) 6)\" => data_out <= \"$BOP\" & \"$BRS\" & \"$BRT\" & x\"$BIMM\"; -- andi \$$RT, \$$RS, $IMM"    

  	;;
ori*)
	ADDRESS=${vetor[4]}
	BOP="001101"
	RT=$(echo "${vetor[1]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	RS=$(echo "${vetor[2]}"| sed -e "s/\$\([0-9]*\)/\1/g")
 	IMM=$(echo "${vetor[3]}"| sed -e "s/\(^-*[0-9]*\)(.*/\1/g")
	BRT=$(fill_zero $(echo "ibase=10;obase=2;$RT" | bc) 5)
	BRS=$(fill_zero $(echo "ibase=10;obase=2;$RS" | bc) 5)
	BIMM=$(./compl_num $IMM)						#Immediate field converted to hexadecimal
	BIMM=$(fill_zero $BIMM 8)						#fill left side of the immediate field with zeros
	#BIMM=$(echo "ibase=16;obase=2;$(echo $BIMM|./upper_case)"|bc)
	BIMM=$(expr substr $BIMM 5 8)
	
	echo "when 	\"$(fill_zero $(echo "ibase=10;obase=2;$ADDRESS" | bc) 6)\" => data_out <= \"$BOP\" & \"$BRS\" & \"$BRT\" & x\"$BIMM\"; -- ori \$$RT, \$$RS, $IMM"    

  	;;

add*)
  	
	ADDRESS=${vetor[4]}
	BOP="000000"
  	RD=$(echo "${vetor[1]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	RS=$(echo "${vetor[2]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	RT=$(echo "${vetor[3]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	SHAMT="00000"
	FUNCT="100000"
	
	BRD=$(fill_zero $(echo "ibase=10;obase=2;$RD" | bc) 5)
	BRS=$(fill_zero $(echo "ibase=10;obase=2;$RS" | bc) 5)
	BRT=$(fill_zero $(echo "ibase=10;obase=2;$RT" | bc) 5)

	echo "when 	\"$(fill_zero $(echo "ibase=10;obase=2;$ADDRESS" | bc) 6)\" => data_out <= \"$BOP\" & \"$BRS\" & \"$BRT\" & \"$BRD\" & \"$SHAMT\" & \"$FUNCT\"; -- add \$$RD, \$$RS, \$$RT"    

  	;;
jr*)
  	
	ADDRESS=${vetor[2]}
	BOP="000000"
  	RD="00000"
	RS=$(echo "${vetor[1]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	RT="00000"
	SHAMT="00000"
	FUNCT="001000"
	
	BRD=$RD
	BRS=$(fill_zero $(echo "ibase=10;obase=2;$RS" | bc) 5)
	BRT=$RT

	echo "when 	\"$(fill_zero $(echo "ibase=10;obase=2;$ADDRESS" | bc) 6)\" => data_out <= \"$BOP\" & \"$BRS\" & \"$BRT\" & \"$BRD\" & \"$SHAMT\" & \"$FUNCT\"; -- jr \$$RS"    

  	;;

slt*)
	ADDRESS=${vetor[4]}
	BOP="000000"
  	RD=$(echo "${vetor[1]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	RS=$(echo "${vetor[2]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	RT=$(echo "${vetor[3]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	SHAMT="00000"
	FUNCT="101010"
	
	BRD=$(fill_zero $(echo "ibase=10;obase=2;$RD" | bc) 5)
	BRS=$(fill_zero $(echo "ibase=10;obase=2;$RS" | bc) 5)
	BRT=$(fill_zero $(echo "ibase=10;obase=2;$RT" | bc) 5)

	echo "when 	\"$(fill_zero $(echo "ibase=10;obase=2;$ADDRESS" | bc) 6)\" => data_out <= \"$BOP\" & \"$BRS\" & \"$BRT\" & \"$BRD\" & \"$SHAMT\" & \"$FUNCT\"; -- slt \$$RD, \$$RS, \$$RT"    

  	;;

sll*)
	ADDRESS=${vetor[4]}
	BOP="000000"
  	RD=$(echo "${vetor[1]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	RT=$(echo "${vetor[2]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	SHAMT=$(echo "${vetor[3]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	RS="00000"
	FUNCT="000000"
	
	BRD=$(fill_zero $(echo "ibase=10;obase=2;$RD" | bc) 5)
	BSHAMT=$(fill_zero $(echo "ibase=10;obase=2;$SHAMT" | bc) 5)
	BRT=$(fill_zero $(echo "ibase=10;obase=2;$RT" | bc) 5)

	echo "when 	\"$(fill_zero $(echo "ibase=10;obase=2;$ADDRESS" | bc) 6)\" => data_out <= \"$BOP\" & \"$RS\" & \"$BRT\" & \"$BRD\" & \"$BSHAMT\" & \"$FUNCT\"; -- sll \$$RD, \$$RT, $SHAMT"    

  	;;


jal*)
	ADDRESS=${vetor[2]}
	BOP="000011"
 	IMM=$(echo "${vetor[1]}"| sed -e "s/\(^-*[0-9]*\)(.*/\1/g")
	BIMM=$(./compl_num $IMM)						#Immediate field converted to hexadecimal
	BIMM=$(echo "ibase=16;obase=2;$(echo $BIMM|./upper_case)"|bc)
	BIMM=$(fill_zero $BIMM 32)						#fill left side of the immediate field with zeros
	BIMM=$(expr substr $BIMM 7 32)
	
	echo "when 	\"$(fill_zero $(echo "ibase=10;obase=2;$ADDRESS" | bc) 6)\" => data_out <= \"$BOP\" & \"$BIMM\"; -- jal $IMM"    
	;;

j*)
	ADDRESS=${vetor[2]}
	BOP="000010"
 	IMM=$(echo "${vetor[1]}"| sed -e "s/\(^-*[0-9]*\)(.*/\1/g")
	BIMM=$(./compl_num $IMM)						#Immediate field converted to hexadecimal
	BIMM=$(echo "ibase=16;obase=2;$(echo $BIMM|./upper_case)"|bc)
	BIMM=$(fill_zero $BIMM 32)						#fill left side of the immediate field with zeros
	BIMM=$(expr substr $BIMM 7 32)
	
	echo "when 	\"$(fill_zero $(echo "ibase=10;obase=2;$ADDRESS" | bc) 6)\" => data_out <= \"$BOP\" & \"$BIMM\"; -- j $IMM"    
	;;


beq*)
	ADDRESS=${vetor[4]}
	BOP="000100"
	RS=$(echo "${vetor[1]}"| sed -e "s/\$\([0-9]*\)/\1/g")
	RT=$(echo "${vetor[2]}"| sed -e "s/\$\([0-9]*\)/\1/g")
 	IMM=$(echo "${vetor[3]}"| sed -e "s/\(^-*[0-9]*\)(.*/\1/g")
	BRT=$(fill_zero $(echo "ibase=10;obase=2;$RT" | bc) 5)
	BRS=$(fill_zero $(echo "ibase=10;obase=2;$RS" | bc) 5)
	BIMM=$(./compl_num $IMM)						#Immediate field converted to hexadecimal
	BIMM=$(fill_zero $BIMM 8)						#fill left side of the immediate field with zeros
	#BIMM=$(echo "ibase=16;obase=2;$(echo $BIMM|./upper_case)"|bc)
	BIMM=$(expr substr $BIMM 5 8)
	
	echo "when 	\"$(fill_zero $(echo "ibase=10;obase=2;$ADDRESS" | bc) 6)\" => data_out <= \"$BOP\" & \"$BRS\" & \"$BRT\" & x\"$BIMM\"; -- beq \$$RS, \$$RT, $IMM"    

  	;;
nop*)
	
	# NOP is implemented on old MIPS as an "add $0, $0, $0". As you can't write in $0, this instruction do nothing as expected    
	
	ADDRESS=${vetor[1]}

	BOP="000000"
  	SHAMT="00000"
	FUNCT="100000"
	
	BRD="00000"
	BRS="00000"
	BRT="00000"

	echo "when 	\"$(fill_zero $(echo "ibase=10;obase=2;$ADDRESS" | bc) 6)\" => data_out <= \"$BOP\" & \"$BRS\" & \"$BRT\" & \"$BRD\" & \"$SHAMT\" & \"$FUNCT\"; -- nop"


	;;
*)
	echo "Invalid Instruction"
  	;;
esac

