#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>

int main (int argc, char **argv) {
	int c = 0;
	while((c = fgetc(stdin)) != EOF) {
		printf("%c",toupper(c));
	}

}
