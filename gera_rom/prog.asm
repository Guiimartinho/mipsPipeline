#Test prog.asm - Edit your MIPS assembly here
#PS.: Some instructions below are not implemented in the processor datapath yet. 
#     You will have to implement, for example: addi, andi, ldi, jal, j, jr. Uncomment 
#     them only when their datapath structures and controls are available.


addi $1, $1, 5
sw $1, 0($0)
#ldi $7, $8, $3		#comment load indexed
lw $2, 0($0)
addi $4, $2, 5		#comment add immediate
sw $4, 8($0)
#add $5, $0, $2          #comment add
#add $5, $5, $3
#slt $6, $4, $5
#beq $6, $0, -9
#andi $7, $0, 10       #comment bitwise and immediate
#sw $5, 0($0)
#jal function          #comment jump and link
#
#
#function:                       #label for function call
#       addi $5, $0, 1
#       addi $6, $0, 10
#	beginloop:               #label for entering the loop
#	slt $3, $5, $6
#	beq $3, $0, endloop      
#	add $7, $5, $6
#	addi $5, $5, 1
#	j beginloop
#	endloop:                 #label for ending loop
#       jr $31                   #Jump register (returning from function call)
