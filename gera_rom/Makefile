CC = gcc -g
UPPER = upper_case
COMPL = compl_num

$(UPPER): $(UPPER).c
	@$(CC) $< -o $@

$(COMPL): $(COMPL).c
	@$(CC) $< -o $@

all: $(UPPER) $(COMPL)


clean: $(UPPER) $(COMPL)
	@rm $(UPPER) $(COMPL)
 


