#include "labels.h"

void *(__attribute__((used)) f)(char *q)
{
	char *q1 = q;
	do_nothing_c(q1);
	START_LABEL(q1)
	q1 = (char*) q1 + 2;
	END_LABEL(q1)
	return q1;
}

#ifdef RUNNABLE
int main(void)
{
	char c[] = "abc";
	return (int) f(&c);
}
#endif
