#include "labels.h"

int *(__attribute__((used)) f)(int **p, int *q)
{
	START_LABEL(p)
	*p = q;
	END_LABEL(*q)
	return q;
}

#ifdef RUNNABLE
int main(void)
{
	int xs[3] = { 0, 1, 2 };
	int *p;
	return f(&p, xs);
}
#endif
