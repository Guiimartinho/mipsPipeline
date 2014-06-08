#!/usr/bin/python

##############################################################
#   Author: Marco Bontorin, 2010
#   Bug Report/Suggestions to: mbontorin@gmail.com
#
#   Version 1.0.0.1
##############################################################

import os;
import sys;
import re;
import commands;
import string;
import array;


labelDic = {};


def errorExit():
    sys.exit(1);

#Removes comma and newline characters
#Also scapes special characters to avoid
#problems when executing bash scripts
def scapeCMD(patStr):    
    #removes the whitespaces from beggining
    retCMD = re.sub("^\s*", "", patStr);

    #scaping special chars
    retCMD = re.sub(","," ", retCMD);
    retCMD = re.sub("\n", "", retCMD);
    retCMD = re.sub("\$", "\\$", retCMD);
    retCMD = re.sub("\(", "\\(", retCMD);
    retCMD = re.sub("\)", "\\)", retCMD);
	
    #adding support to comments (ignoring chars after `#`)
    retCMD = re.sub("#.*", "", retCMD);
    return retCMD;

#Generates a dictionary that maps each assembly code
#label to its instruction count location in the asm file
def createLabelDic(asmFileList):
   
    i = 0;
    for line in asmFileList:
        inst = scapeCMD(line);
        pat = re.findall("([a-zA-Z]|[0-9])+", inst);
        if len(pat) > 0:                           
            label = re.findall("[a-zA-Z]+[0-9]*:", inst);
            if len(label) > 0:
                inst = re.sub(":", "", inst);
		inst = re.sub("\s*", "", inst);
                labelDic[inst] = i;
            else:
                i = i + 1;
        
            
#Change the label representation in branches and jumps
#to the right integer number. That means a instruction
#number related to pc for branches, and absolute instruction
#count for jumps.
def changeLabel(inst, address):
    
    l = string.split(inst);
    ind = -1;
    if l[0] == "beq":
        ind = 3;
        imm = address;
    elif l[0] == "j":
        ind = 1;
        imm = -1;
    elif l[0] == "jal":
        ind = 1;
        imm = -1;
    else:
        ind = -1;
        
    if ind >= 0:
        isLabel = re.findall("[a-zA-Z]+[0-9]*", l[ind]);
        if len(isLabel) > 0:
            if not(l[ind] in labelDic):
                print "Error: there is no label \"" + l[ind] + "\" to jump.";
                errorExit();
            
            labelAddress = labelDic[l[ind]];     
            
            if imm < 0:
                imm = labelAddress;
            else:
                imm = (labelAddress - imm) - 1; #As the current PC == PCbranch+4, we must subtract 1 to get the right location
            
            l[ind] = str(imm);
    
    return string.join(l," ");   


#Reads the asm file and executes the ./generate_line_rom.sh
#to create a rom32.vhd file.
def main(argv):
    
    if len(argv) != 2:
            print "Usage:", argv[0], "[prog].asm";
            errorExit();
            
                 
    

    fileArg = open(argv[1], "r");
    rom = open("rom_middle.txt", "w");

    fileList = fileArg.readlines();

    createLabelDic(fileList);

    i = 0;
    for line in fileList:
	    inst = scapeCMD(line);

            pat = re.findall("^-*[0-9]", inst);
            if len(pat) > 0:
                print "Error: there are lines beginning with numbers";
                errorExit();
                
            pat = re.findall("([a-zA-Z]|[0-9])+", inst);
            if len(pat) > 0:
                    label = re.findall("[a-zA-Z]+[0-9]*:", inst);
                    if len(label) == 0:
                        
                        inst = changeLabel(inst, i);
                       
                        cmd = "./generate_line_rom.sh "+ inst + " " + str(i);
                       
                        outgen = "\t\t\t\t" + commands.getoutput(cmd) + "\n";
                        
                        rom.write(outgen);
                        i = i + 1;
                    
                    
    fileArg.close();
    rom.close();
    commands.getoutput("cat rom_up.txt rom_middle.txt rom_bottom.txt > rom32.vhd");
    sys.exit(0);
 

#The program stars its execution here
main(sys.argv);
