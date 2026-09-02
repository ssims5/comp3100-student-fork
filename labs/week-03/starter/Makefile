# The forge — Work Order No. 1851-03, Tasks 1 and 2.
#
#   make            cast both programs (pantograph and zombie-maker)
#   make pantograph cast just the one you are repairing
#   make clean      break up both castings
#
# Same watchman as Week 2's forge: -Wall -Wextra means the compiler speaks
# up about anything doubtful, and this week the seal check compiles your
# pantograph.c with -Werror, so a warning left standing is a fault left
# standing. No AddressSanitizer this week — the faults you are hunting are
# in the process table, not in memory.

CC     = gcc
CFLAGS = -Wall -Wextra -g

all: pantograph zombie-maker

pantograph: pantograph.c
	$(CC) $(CFLAGS) -o $@ $<

zombie-maker: zombie-maker.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f pantograph zombie-maker

.PHONY: all clean
