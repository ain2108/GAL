#include "list.h"

// Constructor
List * initList(){
  List * list = malloc(sizeof(List));
  list->first = NULL;
  return list;
}

// Add element
Edge * add_front(List * list, void * elmt){

  // Get a container
  Edge * container = malloc(sizeof(Edge));
  container->payload = elmt;
  container->src = NULL;
  container->dst = NULL;

  if(list->first == NULL){
    list->first = container;
    return container;
  }

  
  // Append the contianer in front
  list->first->src = container;
  container->dst = list->first;
  list->first = container;

  return container;
}

// Destructor 
void destrList(List * list){
  Edge * current = list->first;
  Edge * temp = NULL;
  while(current != NULL){
    temp = current->dst;
    free(current);
    current = temp;
  }
}

// Traverse applying a function
void traverse_map(void (*f)(void * param), List * list){
  Edge * temp = list->first;

  // Iterate through the list
  while(temp != NULL){
    f(temp->payload);
    temp = temp->dst;
  }
  
  return;
}

// String printer funciton
void print_string(void * string){
  fprintf(stderr, "%s -> ", (char *) string);
  return;
}

// Reverse list
void reverseList(List * list){

  Edge * current = list->first;
  Edge * temp = NULL;

  // Iterate
  while(current != NULL){
    temp = current->src;
    current->src = current->dst;
    current->dst = temp;

    current = current->src;
  }

  // Fix the first element pointer
  if(temp != NULL){
    list->first = temp->src;
  } 
  return;
}
