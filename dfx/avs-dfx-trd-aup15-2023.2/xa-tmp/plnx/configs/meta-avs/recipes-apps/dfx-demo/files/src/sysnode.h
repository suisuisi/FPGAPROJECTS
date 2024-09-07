#ifndef TSYSNODE_H_
#define TSYSNODE_H_


#ifdef __cplusplus
extern "C" {
#endif


typedef enum {
	eHex,
	eDec
} t_sysnode_format;

char *set_sysnode_base(char *base_dir, uint64_t core_baseaddr);
char *get_sysnode_path(char *sysnode_base, char *sysnode_name);
uint64_t read_sysnode(char *sysnode_base, char *sysnode_name, const t_sysnode_format fmt);
void write_sysnode(char *sysnode_base, char *sysnode_name, char *value);




#ifdef __cplusplus
}
#endif

#endif  /* End of protection macro. */
