/**************************************
 * malloc_allign.c
 *
 * Illustration de l'alignement des allocations mémoires en C sous Linux
 *
 **************************************/

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

int main(int argc, char *argv[])
{
  ///AAA
  char *a, *b, *c;
  
  a = (char *) malloc(sizeof(char)*1);
  b = (char *) malloc(sizeof(char)*9);
  c = (char *) malloc(sizeof(char)*1);
  
  printf("Adresse de a : %p.\n",a);
  printf("Adresse de b : %p.\n",b);
  printf("Adresse de c : %p.\n",c);
  ///BBB
  
  free(a);
  free(b);
  free(c);
  
  return EXIT_SUCCESS;
}
