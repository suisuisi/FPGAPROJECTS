
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "sysnode.h"

static char sysnode_base[256];
static char sysnode_file[256];


char *get_sysnode_path(char *sysnode_base, char *sysnode_name)
{
	snprintf(sysnode_file, sizeof(sysnode_file), "%s/%s", sysnode_base, sysnode_name);
	return sysnode_file;
}


uint64_t read_sysnode(char *sysnode_base, char *sysnode_name, const t_sysnode_format fmt)
{
	char *sysnode_path = get_sysnode_path(sysnode_base, sysnode_name);
	char * line = NULL;
	size_t len = 0;

	FILE *fptr = fopen(sysnode_path, "r");
	if(fptr == NULL) {
		exit_on_error("error reading from %s...", sysnode_path);
	}
	getline(&line, &len, fptr);

	if(len <= 0) {
		exit_on_error("error reading from %s...", sysnode_path);
	}

	fclose(fptr);

	if(fmt == eHex)
		return strtol(line, (char **)NULL, 16);
	if(fmt == eDec)
		return strtol(line, (char **)NULL, 10);

	return 0;
}


void write_sysnode(char *sysnode_base, char *sysnode_name, char *value)
{
	char *sysnode_path = get_sysnode_path(sysnode_base, sysnode_name);

	FILE *fptr = fopen(sysnode_path, "w");
	if(fptr == NULL) {
		exit_on_error("error writing %s to %s...", value, sysnode_file);
	}
	size_t len = fwrite(value , 1 , strlen(value), fptr);
	if(len == 0) {
		exit_on_error("error writing %s to %s...", value, sysnode_file);
	}

	fclose(fptr);
}


char *set_sysnode_base(char *base_dir, uint64_t core_baseaddr)
{
	snprintf(sysnode_base, sizeof(sysnode_base),
			base_dir,
			(unsigned int) core_baseaddr);

	return sysnode_base;
};

