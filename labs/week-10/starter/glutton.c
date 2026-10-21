/* glutton.c -- Work Order No. 1851-10, Task 2: when the Store runs short.
 *
 * Asks the Store for memory, 16 MiB at a time, and fills each piece so the
 * pages are really resident (an untouched mapping costs almost nothing -- see
 * Task 1). It pauses a fifth of a second between helpings, so you can watch
 * it climb, and it stops of its own accord at 512 MiB, so a run with no
 * governor cannot take your whole bench. Run under a memory governor
 *   systemd-run --user --scope -p MemoryMax=64M -p MemorySwapMax=0 ./glutton
 * the Overseer evicts it (the OOM killer) long before it reaches its cap.
 */
#define _DEFAULT_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define CAP_MIB 512

int main(void)
{
    size_t chunk = 16 * 1024 * 1024;     /* 16 MiB a helping */
    long total = 0;
    while (total / (1024 * 1024) < CAP_MIB) {
        char *b = malloc(chunk);
        if (!b) {
            printf("malloc refused at %ld MiB -- the Store said no.\n",
                   total / (1024 * 1024));
            return 1;
        }
        memset(b, 1, chunk);             /* touch it, so the pages are real */
        total += (long)chunk;
        printf("taken: %ld MiB\n", total / (1024 * 1024));
        fflush(stdout);
        usleep(200000);                  /* a fifth of a second a helping */
    }
    printf("glutton: stopped at its own cap, %d MiB. Nobody stopped it.\n",
           CAP_MIB);
    return 0;
}
