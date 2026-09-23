/* interlocking.c -- Work Order No. 1851-06, the north gallery signal box.
 *
 * Lever 07 admits trains to the single line. The whole reason the
 * interlocking frame exists is to keep one promise: one train on that
 * line at a time, and never two.
 *
 * Four gatemen work the frame. Each of them waits for the line to come
 * clear, books his train into the frame's day-book, throws the lever,
 * runs the train through, and puts the lever back to normal.
 *
 * The waiting is done the way an impatient gateman does it -- by
 * standing at the frame and looking at the lever again, and again, and
 * again, until it moves. Nobody tells him when it has moved. He simply
 * keeps looking, and books nothing for his trouble.
 *
 * Read the tally at the end before you touch a line of this. The single
 * line is supposed to be single, and a day-book entry is supposed to be
 * in one hand.
 *
 * On sched_yield(): it is neither part of the trouble nor a cure for it.
 * It is how a program says "I am not at the frame just now -- let
 * somebody else have the floor." The three calls below mark the three
 * moments a gateman is genuinely away from lever 07: between trains, at
 * the day-book, and while a long train runs past him. Take them out and
 * the same faults are still there; they just hide on a busy machine, and
 * hide completely on a bench with one core.
 */
#include <stdio.h>
#include <sched.h>
#include <pthread.h>

#define GATEMEN    4
#define CROSSINGS  30000
#define DAYBOOK    64    /* characters in one day-book entry */
#define PASSAGE    300   /* wheelsets in one train; a crossing is not instant */

/* The frame's idea of the line: 0 clear, 1 taken. Four gatemen read it,
 * four gatemen write it, and nothing at all stands between them. */
static int line_taken = 0;

/* The day-book: one line, rewritten for every train, saying whose train
 * has the single line. */
static char day_book[DAYBOOK];

/* Whose train the frame believes is on the single line just now. The
 * frame keeps this for one reason only: so that it can tell us afterwards
 * when the promise above was broken. */
static int line_holder = 0;

/* Broken promises. Counted without any guard of their own, so read them
 * as floors and not as totals -- some of these go astray in the counting
 * as well. */
static long two_on_the_line = 0;
static long entries_in_two_hands = 0;

struct gateman {
    int  number;
    long crossings;   /* trains he actually put through */
    long idle_looks;  /* looks at the lever that told him nothing */
    long wheelsets;   /* what he counted while his trains ran past */
};

static void *work_the_frame(void *arg)
{
    struct gateman *g = arg;
    char mark = (char)('0' + g->number);
    long i;
    int  j, clash, borrowed;

    for (i = 0; i < CROSSINGS; i++) {
        /* A gateman is wanted all over the floor between trains; he comes
         * back to lever 07 when he is next free. */
        sched_yield();

        /* Wait for the line. Look at the lever. Look at it again. Nobody
         * will tell him when it has moved, so he keeps looking, and books
         * nothing for his trouble. */
        while (line_taken != 0)
            g->idle_looks++;

        /* It looked clear. He steps across to the day-book and enters the
         * train -- the frame carries no train it has no entry for -- and
         * then steps back and throws the lever. Looking and throwing are
         * two separate actions, and the desk is not the frame. This is
         * the gap between them. */
        for (j = 0; j < DAYBOOK; j++)
            day_book[j] = mark;
        sched_yield();

        line_taken = 1;
        line_holder = g->number;

        /* The train runs through. It is long, and he is not needed while
         * it does, so partway along he stands aside and lets the floor
         * get on. A crossing is not one instant either. */
        clash = 0;
        for (j = 0; j < PASSAGE; j++) {
            g->wheelsets++;
            if (j == PASSAGE / 2)
                sched_yield();
            if (line_holder != g->number)
                clash = 1;   /* somebody else has come onto my line */
        }
        if (clash)
            two_on_the_line++;

        /* Read the day-book back. It should still say what he wrote. */
        borrowed = 0;
        for (j = 0; j < DAYBOOK; j++)
            if (day_book[j] != mark)
                borrowed = 1;
        if (borrowed)
            entries_in_two_hands++;

        g->crossings++;
        line_taken = 0;
    }
    return NULL;
}

int main(void)
{
    struct gateman gang[GATEMEN];
    pthread_t hand[GATEMEN];
    long booked = 0, idle = 0, wheels = 0;
    int i;

    for (i = 0; i < DAYBOOK; i++)
        day_book[i] = '-';

    printf("Interlocking frame, north gallery: %d gatemen, %d crossings apiece.\n\n",
           GATEMEN, CROSSINGS);

    for (i = 0; i < GATEMEN; i++) {
        gang[i].number     = i + 1;
        gang[i].crossings  = 0;
        gang[i].idle_looks = 0;
        gang[i].wheelsets  = 0;
        if (pthread_create(&hand[i], NULL, work_the_frame, &gang[i]) != 0) {
            fprintf(stderr, "interlocking: gateman %d would not come on duty\n", i + 1);
            return 1;
        }
    }

    for (i = 0; i < GATEMEN; i++)
        pthread_join(hand[i], NULL);

    for (i = 0; i < GATEMEN; i++) {
        printf("  gateman %d: %ld trains through, %ld idle looks at the lever\n",
               gang[i].number, gang[i].crossings, gang[i].idle_looks);
        booked += gang[i].crossings;
        idle   += gang[i].idle_looks;
        wheels += gang[i].wheelsets;
    }

    printf("\n");
    printf("  trains booked through: %ld\n", booked);
    printf("  crossings a second train came onto the line during: %ld\n", two_on_the_line);
    printf("  day-book entries found in another hand: %ld\n", entries_in_two_hands);
    printf("  idle looks at the lever: %ld\n", idle);
    printf("  wheelsets counted through the frame: %ld\n", wheels);
    printf("\n");
    printf("  The single line is supposed to be single, the day-book is\n");
    printf("  supposed to be in one hand, and a gateman who stares at a\n");
    printf("  lever is a gateman doing no work at all.\n");

    return 0;
}
