#Test prog.asm - Edit your MIPS assembly here
#PS.: Some instructions below are not implemented in the processor datapath yet. 
#     You will have to implement, for example: addi, andi, ldi, jal, j, jr. Uncomment 
#     them only when their datapath structures and controls are available.

ori $4, $0, 6
nop
nop
nop
andi $3, $4, 5
nop
nop
nop
#ldi $7, $8, $3		#comment load indexed
lw $7, 8($0)
nop
addi $7, $7, 9		#comment add immediate
nop
nop
nop
sw $7, 8($0)
add $5, $0, $2          #comment add
nop
nop
nop
add $5, $5, $3
nop
nop
nop
slt $6, $4, $5
nop
nop
nop
beq $6, $0, -9
nop
#andi $7, $0, 10       #comment bitwise and immediate
nop
nop
nop
sw $5, 0($0)

jal function          #comment jump and link
#
#
function:                       #label for function call
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
