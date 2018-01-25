#include <stdlib.h>
#include <stdio.h>
#include "labels.h"

/* Build a linked list of length argv[1].
 * Walk it a large number of times, given by argv[2]. */

struct list_node
{
	int x;
	struct list_node *next;
};

struct list_node *build_list(int n)
{
	struct list_node *head = NULL;
	for (int i = 0; i < n; ++i)
	{
		struct list_node *p = malloc(sizeof (struct list_node));
		p->next = head;
		head = p;
	}
	return head;
}

const int n = 10000;
const int m = 100000;
int f(int ret)
{
	struct list_node *head = build_list(n);
	START_LABEL(ret);
	ret = 0;
	for (int i = 0; i < m; ++i)
	{
		int out = 0;
		for (struct list_node *p = head; p; p = p->next)
		{
			out ^= p->x;
		}
		ret ^= out;
	}
	END_LABEL(ret);
	return ret;
}

#ifdef RUNNABLE
int main(void)
{
	return f(42);
}
#endif
