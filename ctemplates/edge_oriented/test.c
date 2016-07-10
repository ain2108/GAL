#include "list.h"
int main(){

  // Create a list
  List * list = initList();


  // Add string to our list
  add_front(list, "G ");
  add_front(list, "A ");
  add_front(list, "L ");
  add_front(list, "compiler ");
  add_front(list, "! ");

  // Traverse the list and read
  traverse_map(print_string, list); 
  fprintf(stderr, "\n");
  
  // Reverse
  reverseList(list);

  // Traverse and print
  traverse_map(print_string, list); 
  fprintf(stderr, "\n");

  // Again
  reverseList(list);
  traverse_map(print_string, list); 
  fprintf(stderr, "\n");

  fprintf(stderr, "Done\n");
  
  destrList(list);
}
