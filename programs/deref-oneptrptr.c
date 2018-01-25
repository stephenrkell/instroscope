#include "labels.h"

int *(__attribute__((used)) f)(int **p)
{
	START_LABEL(p)
	int *q = *p;
	END_LABEL(q)
	return q;
}

#ifdef RUNNABLE
int main(void)
{
	int x = 0;
	int *p = &x;
	return *f(&p);
}
#endif
