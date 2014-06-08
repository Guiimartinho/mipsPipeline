
A sequencia de comandos pode ser simplificada executando:
	$ make sim

Se for necessario executar os comandos individualmente, siga esses passos:

para compilar: 

	$ ghdl -a --ieee=synopsys -fexplicit [arquivo].vhd

elaboracao do testbench: 

	$ ghdl -e --ieee=synopsys -fexplicit [arquivo]

simulacao:

	$ ghdl -r [arquivo] --vcd=[output].vcd --stop-time="***ns"

visualizar a oscilacao dos sinais:

	$ gtkwave [output].vcd
		

Este diretorio contem:
	Makefile - 	Usado para compilar/elaborar/simular e visualizar os
			resultados
	mips_pipeline.tar.bz2 - arquivo com todo o conteudo deste diretorio
	add32.vhd - somador de 32 bits
	alu_ctl.vhd - controlador da ALU
	alu.vhd - ALU de 32 bits
	basic_types.vhd - Tipos basicos, constantes de opcodes de instrucoes 
	          	  e funcoes da ALU
	control_pipeline.vhd - controlador do pipeline
	gera_rom - contem os scripts para gerar o arquivo rom32.vhd a partir
	           de um codigo assembly.
	mem32.vhd - memoria de acesso a dados, seu tamanho pode ser configurado
                    atraves de um generic map
	mips_pipeline.vhd - caminho de dados
	mips_tb.vhd - sugestao de testbench simples
	mux2.vhd - multiplexador de 2 entradas
	mux3.vhd - mux 3 entradas
	mux4.vhd - mux 4 entradas
	readme.txt - este arquivo
	reg32_ce.vhd - registrador do banco de registradores, contendo um sinal
                       que controla a sua escrita
	reg_bank.vhd - banco de registradores
	reg.vhd - registrador generico cujo tamanho pode ser configurado atraves
                  de um generic map
	rom32.vhd - ROM que contem as instrucoes que serao executadas
	shift_left.vhd - circuito que realiza deslocamento de n bits a esquerda
