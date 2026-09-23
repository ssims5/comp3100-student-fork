/* sorting-floor.c -- Work Order No. 1851-06, the card sorting floor.
 *
 * Punched cards come off the presses, go down a chute, and are taken off
 * the bottom by the sorters. The chute holds eight cards. That is not a
 * house preference; it is how many cards fit in the chute.
 *
 * Four presses tip cards in. Two sorters reach in and take them out. A
 * press does glance at the chute before it tips -- and then tips anyway,
 * because glancing is not the same as waiting. No sorter waits for there
 * to be anything to take, either.
 *
 * Every card carries a serial, and at the end the floor tallies which
 * serials came out the other side and how many times each. Forty
 * thousand cards go in. Both tallies ought to be extremely dull.
 */
#include <stdio.h>
#include <pthread.h>

#define CHUTE      8       /* cards the chute holds. Eight. */
#define PRESSES    4
#define SORTERS    2
#define PER_PRESS  10000
#define TOTAL      (PRESSES * PER_PRESS)

/* The chute. A slot holding 0 has nothing in it. */
static long chute[CHUTE];

/* Where the next card goes in, and where the next card comes out.
 * Both counters are read and written by everyone on the floor. */
static long tipped_in  = 0;
static long taken_out  = 0;

static int  presses_done = 0;   /* the shift bell, such as it is */
static long tipped_onto_full = 0;
static long reached_into_empty = 0;

/* What each sorter carried away, kept apart so the two of them are not
 * also fighting over the tally. */
static long carried[SORTERS][TOTAL];

struct press_hand {
    int  number;
    long tipped;
};

struct sorting_desk {
    int   number;
    long *carried;
    long  count;
};

static void *run_the_press(void *arg)
{
    struct press_hand *p = arg;
    long i;

    for (i = 0; i < PER_PRESS; i++) {
        long serial = (long)p->number * PER_PRESS + i + 1;

        if (tipped_in - taken_out >= CHUTE)
            tipped_onto_full++;

        chute[tipped_in % CHUTE] = serial;
        tipped_in++;
        p->tipped++;
    }
    return NULL;
}

static void *work_the_desk(void *arg)
{
    struct sorting_desk *d = arg;
    long empty_reaches = 0;

    for (;;) {
        if (taken_out < tipped_in) {
            long slot = taken_out;
            long card = chute[slot % CHUTE];

            chute[slot % CHUTE] = 0;   /* the slot is empty now; he has the card */
            taken_out = slot + 1;

            if (card == 0)
                reached_into_empty++;
            else if (d->count < TOTAL)
                d->carried[d->count++] = card;

            empty_reaches = 0;
        } else {
            /* Nothing there. Reach again. */
            if (presses_done && ++empty_reaches > 200000)
                break;
        }
    }
    return NULL;
}

int main(void)
{
    static int came_out[TOTAL];   /* times each serial reached a sorter */
    struct press_hand press[PRESSES];
    struct sorting_desk desk[SORTERS];
    pthread_t press_thread[PRESSES], desk_thread[SORTERS];
    long tipped = 0, carried_off = 0, never = 0, twice = 0;
    long i;
    int p, s;

    printf("Sorting floor: a chute that holds %d, %d presses, %d sorters, %d cards.\n\n",
           CHUTE, PRESSES, SORTERS, TOTAL);

    for (s = 0; s < SORTERS; s++) {
        desk[s].number  = s + 1;
        desk[s].carried = carried[s];
        desk[s].count   = 0;
        if (pthread_create(&desk_thread[s], NULL, work_the_desk, &desk[s]) != 0) {
            fprintf(stderr, "sorting-floor: sorter %d would not come on duty\n", s + 1);
            return 1;
        }
    }

    for (p = 0; p < PRESSES; p++) {
        press[p].number = p;
        press[p].tipped = 0;
        if (pthread_create(&press_thread[p], NULL, run_the_press, &press[p]) != 0) {
            fprintf(stderr, "sorting-floor: press %d would not start\n", p + 1);
            return 1;
        }
    }

    for (p = 0; p < PRESSES; p++)
        pthread_join(press_thread[p], NULL);
    presses_done = 1;
    for (s = 0; s < SORTERS; s++)
        pthread_join(desk_thread[s], NULL);

    for (p = 0; p < PRESSES; p++)
        tipped += press[p].tipped;

    for (s = 0; s < SORTERS; s++) {
        carried_off += desk[s].count;
        for (i = 0; i < desk[s].count; i++) {
            long serial = desk[s].carried[i];
            if (serial >= 1 && serial <= TOTAL)
                came_out[serial - 1]++;
        }
    }

    for (i = 0; i < TOTAL; i++) {
        if (came_out[i] == 0)
            never++;
        else if (came_out[i] > 1)
            twice++;
    }

    for (s = 0; s < SORTERS; s++)
        printf("  sorter %d carried away %ld cards\n", desk[s].number, desk[s].count);

    printf("\n");
    printf("  cards tipped in: %ld\n", tipped);
    printf("  cards carried away: %ld\n", carried_off);
    printf("  serials that never came out: %ld\n", never);
    printf("  serials that came out more than once: %ld\n", twice);
    printf("  cards tipped onto a chute already full: %ld\n", tipped_onto_full);
    printf("  reaches into a slot with nothing in it: %ld\n", reached_into_empty);
    printf("\n");
    if (never > 0 || tipped_onto_full > 0)
        printf("  A chute that holds eight held rather more than eight, and the\n"
               "  floor cannot tell you where the missing cards went.\n");
    else
        printf("  Every card came out, and the chute was never over-filled.\n"
               "  That is not what this floor is for -- run it again.\n");

    return 0;
}
