#include "node_list.h"

int main(){

  /*
  List list;
  list.first = NULL;
  add_element_front(&list, "I ");
  add_element_front(&list, "Love ");
  add_element_front(&list, "Pink ");
  add_element_front(&list, "Floyd ");
  printListOfGnodes(&list);
  */

  // Nodes...
  GNode node1;
  List list1;
  list1.first = NULL;
  node1.data = "A";
  node1.edges = &list1;
  
  GNode node2;
  List list2;
  list2.first = NULL;
  node2.data = "B";
  node2.edges = &list2; 

  GNode node3;
  List list3;
  list3.first = NULL;
  node3.data = "C";
  node3.edges = &list3; 
  
  // 3 edges in the graph
  GEdge node1edge1;
  node1edge1.src = &node1;
  node1edge1.dst = &node2;
  node1edge1.weight = 3;

  GEdge node1edge2;
  node1edge2.src = &node1;
  node1edge2.dst = &node3;
  node1edge2.weight = 7;

  GEdge * node2edge1 = buildEdge(&node2, 4, &node3);

  // Adding edges to their respective nodes;
  add_edge(&node1, &node1edge1);
  add_edge(&node1, &node1edge2);
  add_edge(&node2, node2edge1);

  // Add Nodes of the graph to Graph (list)
  Graph graph;
  graph.node = NULL;
  add_gnode_to_Graph(&node1, &graph);
  add_gnode_to_Graph(&node2, &graph);
  add_gnode_to_Graph(&node3, &graph);

  // Print the graph
  printGraph((List *) &graph);

  
  fprintf(stderr, "Done\n");
}
