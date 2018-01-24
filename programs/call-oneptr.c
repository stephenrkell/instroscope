#include "labels.h"

int g(int *p) { return 42; }

void (__attribute__((used)) f)(void *p)
{
	void *p1 = p;
	do_nothing_p(p1);
	START_LABEL(p1)
	int ignored = g(p1);
	END_LABEL(ignored)
}
