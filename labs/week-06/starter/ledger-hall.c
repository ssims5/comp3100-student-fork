/* ledger-hall.c -- Work Order No. 1851-06, the ledger hall.
 *
 * One page. The four district balances down the side -- Northgate,
 * Waterside, Old Quarter, Kiln Row, the same four as the waterworks
 * table -- and a total written at the foot. A page is correct only when
 * the four balances and the total agree. That is the entire purpose of
 * writing a total.
 *
 * One clerk posts to the page as the quarter's figures come in. Six
 * readers stand at the rail and read it, over and over, adding the four
 * balances up for themselves to see whether the foot of the page is
 * honest.
 *
 * The clerk posts the way a pen posts: one entry at a time, down the
 * column, and the total last. Nothing asks a reader to stand back while
 * the pen is moving, and nothing asks the pen to wait for the readers.
 *
 * Count how many pages balanced, then look at the page that did not.
 */
#include <stdio.h>
#include <pthread.h>

#define DISTRICTS 4
#define READERS   6
#define POSTINGS  2000000L

static const char *DISTRICT[DISTRICTS] = {
    "Northgate", "Waterside", "Old Quarter", "Kiln Row"
};

/* What the four districts stood at when the quarter opened, in pence. */
static const long OPENING[DISTRICTS] = { 53515, 61245, 44635, 54665 };
#define OPENING_SUM (53515L + 61245L + 44635L + 54665L)

/* The page itself. One clerk writes it; six readers read it. */
static long balance[DISTRICTS];
static long stated_total;

static int hall_closed = 0;   /* set when the clerk puts the pen down */

struct reader {
    int  number;
    long pages_read;
    long balanced;
    long did_not_balance;
    int  kept_one;                  /* has this reader kept a bad page? */
    long bad_balance[DISTRICTS];
    long bad_total;
};

static void *read_the_page(void *arg)
{
    struct reader *r = arg;

    while (!hall_closed) {
        long seen[DISTRICTS];
        long foot;
        long sum = 0;
        int  d;

        for (d = 0; d < DISTRICTS; d++) {
            seen[d] = balance[d];
            sum += seen[d];
        }
        foot = stated_total;

        r->pages_read++;
        if (sum == foot) {
            r->balanced++;
        } else {
            r->did_not_balance++;
            if (!r->kept_one) {
                for (d = 0; d < DISTRICTS; d++)
                    r->bad_balance[d] = seen[d];
                r->bad_total = foot;
                r->kept_one = 1;
            }
        }
    }
    return NULL;
}

static void *post_the_figures(void *arg)
{
    long n;

    (void)arg;
    for (n = 1; n <= POSTINGS; n++) {
        int d;

        /* One entry at a time, down the column, as a pen does. */
        for (d = 0; d < DISTRICTS; d++)
            balance[d] = OPENING[d] + n;

        /* And the total at the foot, when the column is done. */
        stated_total = OPENING_SUM + n * DISTRICTS;
    }

    hall_closed = 1;
    return NULL;
}

int main(void)
{
    struct reader bench[READERS];
    pthread_t reader_thread[READERS];
    pthread_t clerk;
    long read_total = 0, balanced_total = 0, torn_total = 0;
    int i, d, shown = 0;

    for (d = 0; d < DISTRICTS; d++)
        balance[d] = OPENING[d];
    stated_total = OPENING_SUM;

    printf("Ledger hall: one clerk posting %ld times, %d readers at the rail.\n\n",
           POSTINGS, READERS);

    for (i = 0; i < READERS; i++) {
        bench[i].number = i + 1;
        bench[i].pages_read = 0;
        bench[i].balanced = 0;
        bench[i].did_not_balance = 0;
        bench[i].kept_one = 0;
        bench[i].bad_total = 0;
        for (d = 0; d < DISTRICTS; d++)
            bench[i].bad_balance[d] = 0;
        if (pthread_create(&reader_thread[i], NULL, read_the_page, &bench[i]) != 0) {
            fprintf(stderr, "ledger-hall: reader %d would not come to the rail\n", i + 1);
            return 1;
        }
    }

    if (pthread_create(&clerk, NULL, post_the_figures, NULL) != 0) {
        fprintf(stderr, "ledger-hall: the clerk would not take the pen\n");
        return 1;
    }

    pthread_join(clerk, NULL);
    for (i = 0; i < READERS; i++)
        pthread_join(reader_thread[i], NULL);

    for (i = 0; i < READERS; i++) {
        printf("  reader %d: %ld pages read, %ld did not balance\n",
               bench[i].number, bench[i].pages_read, bench[i].did_not_balance);
        read_total     += bench[i].pages_read;
        balanced_total += bench[i].balanced;
        torn_total     += bench[i].did_not_balance;
    }

    printf("\n");
    printf("  pages read: %ld\n", read_total);
    printf("  pages that balanced: %ld\n", balanced_total);
    printf("  pages that did not balance: %ld\n", torn_total);
    printf("\n");

    for (i = 0; i < READERS && !shown; i++) {
        long sum = 0;

        if (!bench[i].kept_one)
            continue;
        printf("  the first page reader %d could not make balance:\n", bench[i].number);
        for (d = 0; d < DISTRICTS; d++) {
            printf("    %-12s %ld\n", DISTRICT[d], bench[i].bad_balance[d]);
            sum += bench[i].bad_balance[d];
        }
        printf("    %-12s %ld   <- and the column adds to %ld\n",
               "total", bench[i].bad_total, sum);
        shown = 1;
    }

    if (!shown)
        printf("  every page balanced this time. Run it again.\n");
    else
        printf("\n  Nobody wrote a wrong figure. Every figure on that page was\n"
               "  true when the pen wrote it. The page is still wrong.\n");

    return 0;
}
