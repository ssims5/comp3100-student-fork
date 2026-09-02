/* zombie-maker.c -- Work Order No. 1851-03, Task 2.
 *
 * Complete as cast; nothing to repair. It makes one zombie on purpose.
 *
 * The child finishes its card at once. The parent does not collect it for
 * two minutes -- and until a parent collects a finished child with
 * wait(), the Overseer must keep the child's entry in the process table:
 * the exit status has an heir who has not yet claimed it. An entry with
 * nothing running behind it is what ps calls state Z.
 */
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(void)
{
    pid_t child = fork();
    if (child == 0)
        return 0;                    /* the copy finishes immediately */

    printf("zombie-maker: I am %d; my child was %d and has already finished.\n",
           (int)getpid(), (int)child);
    printf("zombie-maker: I shall not collect it for two minutes. Go and look.\n");
    fflush(stdout);

    sleep(120);                       /* the desk sits idle, papers uncleared */

    int status = 0;
    waitpid(child, &status, 0);      /* collected at last -- the entry clears */
    printf("zombie-maker: collected %d at last (exit status %d). It is gone now.\n",
           (int)child, WEXITSTATUS(status));
    return 0;
}
