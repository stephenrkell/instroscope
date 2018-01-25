#include "labels.h"

int (__attribute__((used)) f)(int *p)
{
	START_LABEL(p)
	int q = p[2];
	END_LABEL(q)
	return q;
}

#ifdef RUNNABLE
int main(void)
{
	int xs[3] = { 0, 1, 2 };
	return f(xs);
}
#endif
