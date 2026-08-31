/*
 * hello-brassbridge.c — Work Order No. 1851-02, Task 1.
 *
 * The pattern shop has sent your bench a casting with FOUR faults in
 * it — a Guild tradition; nobody trusts an apprentice who has only
 * seen metal that pours clean. Each fault is marked with a comment
 * that names its SYMPTOM (what you will see), never its repair.
 * Repair all four. The work order walks them in order.
 */

#include <stdio.h>
#include <string.h>
/* FAULT 1 — symptom: the compiler reports an implicit declaration of
 * 'strlen' and suggests a header. This file never says where strlen
 * lives. */

#define DAYS 5 /* the working week, Monday through Friday */

int main(void)
{
    const char *motto = "Ex Vapore, Ordo";
    int hours[DAYS] = {0}; /* one pigeonhole per working day */
    int total = 0;       /* the week's tally */

    /* FAULT 3 — symptom: compiles and links, then AddressSanitizer
     * halts the run with "stack-buffer-overflow ... WRITE of size 4".
     * Five pigeonholes; count what this loop touches. */
    for (int day = 0; day < DAYS; day++) {
        hours[day] = day + 4; }/* 4, 5, 6, 7, 8 — an honest week */

    /* FAULT 4 — symptom: nothing at all — and even valgrind stays
     * quiet until Fault 2 is mended; repair the watchman first, then
     * valgrind reports a conditional jump depending on an
     * uninitialised value. */
    for (int day = 0; day < DAYS; day++) {
        total = total + hours[day]; }

    /* FAULT 2 — symptom: the compiler suggests parentheses around an
     * assignment used as a truth value — and every week comes out
     * "full", whatever the pigeonholes hold. One character short of a
     * comparison. */
    if (total == 30)
        printf("A full week: %d hours at the bench.\n", total);
    else
        printf("A short week: %d hours at the bench.\n", total);

    printf("The motto has %zu letters; the bench salutes every one.\n",
           (size_t)strlen(motto));
    return 0;
}
