/* store-plan.c -- Work Order No. 1851-09, the floor plan.
 *
 * A running program keeps its belongings in more than one room. This
 * one owns five things of five different kinds, and prints where each
 * of them lives -- its address -- without saying which room that is.
 *
 * Run it twice. The numbers change from run to run; something else
 * does not. Sort the five lines from the lowest address to the highest,
 * and name the room each one lives in.
 *
 * Nothing here is broken. Leave the source as it is.
 */
#include <stdio.h>
#include <stdlib.h>

int  tally_kept = 9;        /* given a value before the program starts */
char spare_slips[4096];     /* given no value at all                   */

int main(void)
{
    int   on_hand = 0;                /* lives only while main runs    */
    char *slip = malloc(64);          /* asked for while running       */

    if (slip == NULL) {
        fprintf(stderr, "store-plan: no slip to be had\n");
        return 1;
    }
    printf("slip         (asked for while running)    %p\n", (void *)slip);
    printf("main         (the program's own routine)  %p\n", (void *)main);
    printf("on_hand      (a variable inside main)     %p\n", (void *)&on_hand);
    printf("tally_kept   (set before the start)       %p\n", (void *)&tally_kept);
    printf("spare_slips  (never set at all)           %p\n", (void *)spare_slips);

    free(slip);
    return 0;
}
