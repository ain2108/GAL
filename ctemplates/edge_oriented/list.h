#include <stdlib.h>
#include <stdio.h>

typedef struct Edge{
  void * src;
  void * dst;
  void * payload;
  
} Edge;

typedef struct List{
  Edge * first;
} List;


List * initList();
void destrList(List * list);
Edge * add_front(List * list, void * elmt);
void traverse_map(void (*f)(void * param), List * list);
void print_string(void * string);
void reverseList(List * list);
