label1:
lw $2, 8($4)
beq $0, $0, label1
label2:
jal frente
j label2
add $5, $1, $2
frente:
addi $4, $2, -2

