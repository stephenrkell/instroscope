#include "labels.h"

int g(int *p) { return 42; }

void (__attribute__((used)) f)(int *p)
{
	do_nothing_p(p);
	START_LABEL(p)
	int ignored = g(p);
	END_LABEL(ignored)
}

#ifdef RUNNABLE
int main(void)
{
	int x = 0;
	f(&x);
}
#endif
