#include "node_list.h"

// Adds the element to the list
LNode * add_element_front(List * list, void * element){
  LNode * lnode = malloc(sizeof(LNode));
  lnode->data = element;
  LNode * temp = list->first;
  list->first = lnode;
  lnode->edges = temp;
  
  return lnode;
}

// Prints the list
void printListOfGnodes(List * list){
  LNode * current = list->first;
  while(current != NULL){
    fprintf(stderr, "%s -> ", (char *) ((GNode *)current->data)->data);
    current = current->edges;
  }
  // fprintf(stderr, "%s -> END\n", (char *) ((GNode *)current->data)->data);
  return;
}

// Prints an edge
void printEdge(GEdge * edge){
  fprintf(stderr, "(%s, %d, %s)",
	  (char *) edge->src->data,
	  edge->weight, (char *) edge->dst->data);
  return;
}

// Prints out th elist of edges
void printListOfEdges(List * list){
  LNode * current = list->first;
  while(current != NULL){
    // fprintf(stderr, "inside");   
    printEdge((GEdge *) current->data);
    fprintf(stderr, "  ");
    current = current->edges;    
  }
  fprintf(stderr, "\n");
  // printEdge((GEdge *) current->data);
  return;
}

GEdge * buildEdge(GNode * src, int weight, GNode * dst){

  GEdge * edge = malloc(sizeof(GEdge));
  edge->src = src;
  edge->dst =dst;
  edge->weight = weight;
  
  return edge;
}

// Adds an edge 
void add_edge(GNode * node, GEdge * edge){
  add_element_front( (List *) node->edges, edge);
  return;
}

void add_gnode_to_Graph(GNode * node, Graph * graph){
  add_element_front((List *) graph, node);
  return;
}


// Prints the set of nodes and their edges
void printGraph(List * list){

  LNode * current = list->first;
  while(current != NULL){
    fprintf(stderr, "%s :: ", (char *) ((GNode *)current->data)->data);
    printListOfEdges( (List* ) ((GNode *)current->data)->edges);
    current = current->edges;
  }
  // fprintf(stderr, "%s -> END\n", (char *) ((GNode *)current->data)->data);
  return;
}
