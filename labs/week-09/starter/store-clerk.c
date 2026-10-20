/* store-clerk.c -- Work Order No. 1851-09, the Store's clerk.
 *
 * The clerk keeps a ledger of the bureaus that have drawn blocks from
 * the Store: one entry per bureau, each entry a slip of its own, the
 * slips pinned together in a chain. When a bureau returns its blocks,
 * its slip is struck from the ledger.
 *
 * Run it and the ledger reads correctly, every time. Run it under
 * valgrind (make audit) and the clerk is found out three ways. Read
 * each of valgrind's reports, find the line it points at, and mend the
 * clerk until make audit is quiet -- with the ledger reading exactly as
 * it does now.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct entry {
    struct entry *next;     /* the next slip in the chain     */
    char         *name;     /* the bureau, copied onto a slip */
    int           blocks;   /* blocks it holds                */
};

/* Writes a new slip and pins it to the front of the ledger. */
static struct entry *enter(struct entry *ledger, const char *name, int blocks)
{
    struct entry *e = malloc(sizeof *e);

    if (e == NULL) {
        fprintf(stderr, "store-clerk: out of slips\n");
        exit(1);
    }
    e->name = malloc(strlen(name) + 1);
    if (e->name == NULL) {
        fprintf(stderr, "store-clerk: out of slips\n");
        exit(1);
    }
    strcpy(e->name, name);
    e->blocks = blocks;
    e->next = ledger;
    return e;
}

/* Hands a slip back to the Store. */
static void strike(struct entry *e)
{
    free(e->name);
    free(e);
}

int main(void)
{
    struct entry *ledger = NULL;
    struct entry *e;
    struct entry *struck;
    int total = 0;

    ledger = enter(ledger, "Foundry", 12);
    ledger = enter(ledger, "Ropewalk", 7);
    ledger = enter(ledger, "Printing Office", 9);
    ledger = enter(ledger, "Tide Tables", 4);

    /* The newest bureau returns its blocks: strike its slip. */
    struck = ledger;
    ledger = ledger->next;
    printf("Struck from the ledger: %d blocks returned.\n", struck->blocks);
    strike(struck);

    printf("Blocks still out:\n");
    for (e = ledger; e != NULL; e = e->next) {
        printf("  %-16s %3d\n", e->name, e->blocks);
        total += e->blocks;
    }
    printf("Ledger total: %d blocks outstanding.\n", total);

    while (ledger != NULL) {
	struct entry *next = ledger->next;
	strike(ledger);
	ledger = next;
    }

    return 0;
}
