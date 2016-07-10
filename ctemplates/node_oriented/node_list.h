#include <stdlib.h>
#include <stdio.h>

typedef struct Node{

  void * data;  // If GNode, pointer to identifier. If LNode, pointer to data
  void * edges; // If GNode, pointer to list of edges. If LNode, pointer next node (?)
  
  
} GNode, LNode, Node;

typedef struct Edge{

  Node * src;
  Node * dst;
  int weight;
  
} GEdge, Edge;

typedef struct List{
  LNode * first;
} List;

typedef struct Graph{
  GNode * node;
} Graph;

LNode * add_element_front(List * list, void * element);
void printListOfGnodes(List * list);
void printListOfEdges(List * list);
void printEdge(GEdge * edge); 
Edge * buildEdge(GNode * src, int weight, GNode * dst);
void add_edge(GNode * node, GEdge * edge);
void add_gnode_to_Graph(GNode * node, Graph * graph);

void printGraph(List * graph);
