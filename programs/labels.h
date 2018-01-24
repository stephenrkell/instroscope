#define START_LABEL(used_after) \
	__asm__ volatile ("ud2 # %0" : "=r"(used_after));
#define END_LABEL(defined_before) \
	__asm__ volatile ("ud2 # %0" : : "r"(defined_before));
	
int main(void) { return 0; }
void do_nothing_c(char *c) {}
void do_nothing_p(void *p) {}
void do_nothing_i(int i) {}
// toyed with
// __asm__ volatile (".L__begin_tear_here_%=:");
// but it doesn't work
