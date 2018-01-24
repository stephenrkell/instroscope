#include "labels.h"

int *(__attribute__((used)) f)(int **p, int *q)
{
	START_LABEL(p)
	*p = q;
	END_LABEL(*q)
	return q;
}
