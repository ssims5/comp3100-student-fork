/* philosophers.c -- Work Order No. 1851-06, the long table.
 *
 * Five philosophers sit down to supper. Between each pair of them lies
 * one fork, so there are five forks for five diners. A philosopher needs
 * the fork on the left and the fork on the right before eating, and
 * takes them in that order, because that is the order they are laid.
 *
 * This is the last floor of the week and it is the only one that does
 * not finish. That is deliberate. Run it, read what each philosopher
 * says before the table goes quiet, and write down -- in plain English,
 * in your logbook -- what every one of them is holding and what every
 * one of them is waiting for.
 *
 * Describe it first, in full, and only then fix it: the description is
 * the work, and the fix is four lines once you have it.
 *
 * Getting out: the table has a porter. If nothing has been eaten for
 * five seconds he clears his throat, closes the sitting, and the program
 * ends by itself -- your terminal is never left holding a fork. Ctrl-C
 * ends it sooner, at any moment, and just as cleanly.
 */
#include <stdio.h>
#include <time.h>
#include <pthread.h>

#define PHILOSOPHERS   5
#define MEALS_WANTED   3
#define STALL_SECONDS  5
#define PORTER_TICK_MS 200

static pthread_mutex_t fork_on_table[PHILOSOPHERS];

/* The porter watches this figure and nothing else. He never touches a
 * fork; he only counts what leaves the kitchen. */
static long meals_served = 0;

static const char *NAME[PHILOSOPHERS] = {
    "Aurelia", "Bramwell", "Cordelia", "Desmond", "Eustace"
};

struct philosopher {
    int  seat;
    long meals;
};

static void pause_briefly(long milliseconds)
{
    struct timespec t;

    t.tv_sec  = milliseconds / 1000;
    t.tv_nsec = (milliseconds % 1000) * 1000000L;
    nanosleep(&t, NULL);
}

static void *dine(void *arg)
{
    struct philosopher *p = arg;
    int left  = p->seat;
    int right = (p->seat + 1) % PHILOSOPHERS;

    while (p->meals < MEALS_WANTED) {
        printf("  %-9s takes the fork on the left  (fork %d)\n", NAME[p->seat], left);
        fflush(stdout);
        pthread_mutex_lock(&fork_on_table[left]);

        /* A moment to settle, and a look up the table, before reaching
         * across for the other one. */
        pause_briefly(120);

        printf("  %-9s reaches for the fork on the right (fork %d)\n", NAME[p->seat], right);
        fflush(stdout);
        pthread_mutex_lock(&fork_on_table[right]);

        p->meals++;
        meals_served++;
        printf("  %-9s eats. (%ld)\n", NAME[p->seat], p->meals);
        fflush(stdout);

        pthread_mutex_unlock(&fork_on_table[right]);
        pthread_mutex_unlock(&fork_on_table[left]);
        pause_briefly(10);
    }
    return NULL;
}

int main(void)
{
    struct philosopher seat[PHILOSOPHERS];
    pthread_t diner[PHILOSOPHERS];
    long wanted = (long)PHILOSOPHERS * MEALS_WANTED;
    long last_count = -1;
    int quiet_ticks = 0;
    int stalled = 0;
    int i;

    for (i = 0; i < PHILOSOPHERS; i++)
        pthread_mutex_init(&fork_on_table[i], NULL);

    printf("The long table: %d philosophers, %d forks, %d meals apiece.\n\n",
           PHILOSOPHERS, PHILOSOPHERS, MEALS_WANTED);

    for (i = 0; i < PHILOSOPHERS; i++) {
        seat[i].seat  = i;
        seat[i].meals = 0;
        if (pthread_create(&diner[i], NULL, dine, &seat[i]) != 0) {
            fprintf(stderr, "philosophers: seat %d could not be filled\n", i);
            return 1;
        }
    }

    /* The porter's round. */
    for (;;) {
        long served;

        pause_briefly(PORTER_TICK_MS);
        served = meals_served;

        if (served >= wanted)
            break;
        if (served != last_count) {
            last_count = served;
            quiet_ticks = 0;
        } else if (++quiet_ticks >= STALL_SECONDS * (1000 / PORTER_TICK_MS)) {
            stalled = 1;
            break;
        }
    }

    if (stalled) {
        printf("\n  The porter: nothing has been eaten for %d seconds.\n", STALL_SECONDS);
        printf("  Meals served: %ld of %ld. The sitting is closed.\n", meals_served, wanted);
        printf("  (Ctrl-C would have done the same, at any moment.)\n\n");
        printf("  Every philosopher at that table is holding one fork and\n");
        printf("  waiting for one fork. Name them. Say which fork each holds\n");
        printf("  and which fork each is waiting for, and say who is waiting\n");
        printf("  on whom, all the way round. Do that before you change a\n");
        printf("  single line of this file.\n");
        return 3;
    }

    for (i = 0; i < PHILOSOPHERS; i++)
        pthread_join(diner[i], NULL);

    printf("\n  Everyone ate. That is not what this table is for -- run it again.\n");
    return 0;
}
