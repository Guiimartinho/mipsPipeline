- primeiro, execute o comando:
		make all

  isso vai compilar localmente os fontes compl_num.c e upper_case.c que serao usados 
  pelo generate_line_rom.sh. 
  

- programe no assembly do mips o arquivo prog.asm
- execute o script generate_rom.py atraves do comando (no diretorio corrente): 
		
		./generate_rom.py prog.asm 

O script gera o arquivo rom32.vhd que deve ser movido para o diretorio contendo
o arquivo vhdl do caminho de dados do mips, mips_pipeline.vhd, e compilado com
o ghdl.


Este diretorio contem:
	upper_case - executavel que converte um numero inteiro para hexadecimal.
                    Usado principalmente pelas funcoes com um imediato, pois eles
                    ocupam muito espaco no rom32.vhd.
	upper_case.c - arquivo fonte do executavel anterior
	compl_num - executavel que converte um numero inteiro para binario.
                    Usado principalmente para gerar numeros negativos em
                    complemento de 2.
	compl_num.c - arquivo fonte do executavel anterior
	generate_line_rom.sh - converte uma instrucao para binario
	generate_rom.py - executa o script anterior para todas as linhas do
                          arquivo assembly fonte e monta o restante do arquivo
                          rom32.vhd
	prog.asm - sugestao de arquivo fonte em assembly. Esse arquivo deve
                   passado como argumento para o script anterior para gerar
                   o rom32.vhd.
	readme.txt - este arquivo
	rom_bottom.txt - parte constante abaixo do arquivo rom32.vhd
	rom_middle.txt - parte onde sao colocadas as instrucoes convertidas
                         para binario.
	rom_up.txt - parte constante acima do arquivo rom32.vhd
