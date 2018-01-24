#include "labels.h"

int (__attribute__((used)) f)(int *p)
{
	START_LABEL(p)
	int q = *p;
	END_LABEL(q)
	return q;
}
