TB = mips_tb

COMP = ghdl -a --ieee=synopsys -fexplicit 

ELAB = ghdl -e --ieee=synopsys -fexplicit

SIMUL = ghdl -r

VCD = --vcd=mips.vcd

STOP = --stop-time=100000ns

SRC = 	basic_types.vhd \
    	reg.vhd \
    	add32.vhd \
    	mux2.vhd \
	mux3.vhd \
	mux4.vhd \
    	rom32.vhd \
    	reg32_ce.vhd \
    	reg_bank.vhd \
    	control_pipeline.vhd \
    	shift_left.vhd \
    	alu.vhd \
    	alu_ctl.vhd \
    	mem32.vhd \
    	mips_pipeline.vhd \
    	mips_tb.vhd

OBJ = 	basic_types.o \
    	reg.o \
    	add32.o \
    	mux3.o \
	mux4.o \
	mux2.o \
    	rom32.o \
    	reg32_ce.o \
    	reg_bank.o \
    	control_pipeline.o \
    	shift_left.o \
    	alu.o \
    	alu_ctl.o \
    	mem32.o \
    	mips_pipeline.o \
    	mips_tb.o

$(OBJ): $(SRC)
	$(COMP) $(SRC)

$(TB): $(OBJ)
	$(ELAB) $(TB)

sim: $(TB)
	$(SIMUL) $(TB) $(VCD) $(STOP) 2> /dev/null

clean:
	rm -f *.o *.cf
	
