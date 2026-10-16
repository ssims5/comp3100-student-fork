# The Store's bench -- Work Order No. 1851-09, Tasks 1 and 2.
#
#   make            build store-plan and store-clerk
#   make audit      walk store-clerk under valgrind; it fails until the
#                   clerk is mended
#   make clean      sweep both builds away
#
# -g so valgrind can name a line; -O0 so the program runs exactly as it
# is written. The .valgrindrc beside this file keeps valgrind from going
# looking on the network for debugging symbols, which can take ten
# seconds a run; the audit says the same thing on its own command line.

CC     = gcc
CFLAGS = -Wall -Wextra -g -O0

all: store-plan store-clerk

store-plan: store-plan.c
	$(CC) $(CFLAGS) -o $@ $<

store-clerk: store-clerk.c
	$(CC) $(CFLAGS) -o $@ $<

audit: store-clerk
	valgrind --enable-debuginfod=no --leak-check=full --error-exitcode=1 ./store-clerk

clean:
	rm -f store-plan store-clerk

.PHONY: all audit clean
