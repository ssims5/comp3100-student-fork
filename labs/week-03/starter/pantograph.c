/* pantograph.c -- Work Order No. 1851-03, Task 1.
 *
 * A pantograph desk copies a card so the copy can be run while the
 * original stays on the desk. That is fork(): one process becomes two,
 * identical but for one thing -- what fork() hands back to each of them.
 *
 * Your job: fit the three missing parts (TODO 1, 2, 3). Everything else,
 * including every line that prints, is already cast. Do not change the
 * printf lines -- the seal check reads them.
 *
 * When it is finished:
 *
 *     $ ./pantograph echo test
 *     pantograph: desk copied -- the copy is 12345, and it runs 'echo'
 *     test
 *     pantograph: copy 12345 finished -- exit status 0
 *
 *     $ ./pantograph false
 *     pantograph: desk copied -- the copy is 12346, and it runs 'false'
 *     pantograph: copy 12346 finished -- exit status 1
 *
 * (Your pid numbers will be your own. Build with: make)
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>     /* fork, execvp                */
#include <sys/types.h>  /* pid_t                       */
#include <sys/wait.h>   /* waitpid, WIFEXITED, ...     */

int main(int argc, char *argv[])
{
    if (argc < 2) {
        fprintf(stderr, "usage: %s COMMAND [ARGS...]\n", argv[0]);
        fprintf(stderr, "   eg: %s echo test\n", argv[0]);
        return 2;
    }

    /* ------------------------------------------------------------------
     * TODO 1 -- Copy the desk.
     *
     * Call fork() and keep what it returns in `child`.
     *
     * fork() returns TWICE, once in each process:
     *   in the copy (the child) it returns 0;
     *   in the original (the parent) it returns the child's pid;
     *   and if the copy could not be made, it returns -1 in the parent.
     * ------------------------------------------------------------------ */
    pid_t child = -1;   /* <-- replace -1 with your fork() call */

    if (child < 0) {
        perror("pantograph: fork");
        return 1;
    }

    if (child == 0) {
        /* --------------------------------------------------------------
         * We are the copy. Replace ourselves with the requested command.
         *
         * TODO 2 -- Run the card.
         *
         * Call execvp(argv[1], &argv[1]).
         *   argv[1]   is the command name ("echo"), looked up on PATH;
         *   &argv[1]  is the argument list, starting at the command name
         *             itself and ending at the NULL argv already has.
         *
         * execvp does not return when it succeeds -- this process stops
         * being pantograph and becomes the command. So every line below
         * this call runs ONLY if the exec failed.
         * -------------------------------------------------------------- */

        perror("pantograph: execvp");
        _exit(127);     /* the shell's own code for "command not found" */
    }

    /* We are the original. Report the copy, then wait for it. */
    printf("pantograph: desk copied -- the copy is %d, and it runs '%s'\n",
           (int)child, argv[1]);
    fflush(stdout);     /* say it before the copy speaks */

    int status = 0;

    /* ------------------------------------------------------------------
     * TODO 3 -- Collect the finished work.
     *
     * Call waitpid(child, &status, 0).
     *   It blocks until that child finishes, then fills `status` with a
     *   packed account of HOW it finished. Check its return value: -1
     *   means the wait itself failed.
     *
     * A parent that never waits leaves a zombie -- Task 2 is about
     * exactly that, so get this line right and you will have made none.
     * ------------------------------------------------------------------ */

    if (WIFEXITED(status)) {
        printf("pantograph: copy %d finished -- exit status %d\n",
               (int)child, WEXITSTATUS(status));
    } else if (WIFSIGNALED(status)) {
        printf("pantograph: copy %d was stopped by signal %d\n",
               (int)child, WTERMSIG(status));
    } else {
        printf("pantograph: copy %d ended in some other way\n", (int)child);
    }

    return 0;
}
