# The forge -- Work Order No. 1851-06, the four floors.
#
#   make            cast all four
#   make clean      break up the castings
#
# -pthread gives every floor its hands; -Wall -Wextra keep the compiler
# talking. No -O flag, on purpose: this week the misbehaviour depends on
# the code running exactly as it is written, at exactly the speed it is
# written, and an optimiser is very good at hiding both.

CC     = gcc
CFLAGS = -Wall -Wextra -pthread

FLOORS = interlocking sorting-floor ledger-hall philosophers

all: $(FLOORS)

interlocking: interlocking.c
	$(CC) $(CFLAGS) -o $@ $<

sorting-floor: sorting-floor.c
	$(CC) $(CFLAGS) -o $@ $<

ledger-hall: ledger-hall.c
	$(CC) $(CFLAGS) -o $@ $<

philosophers: philosophers.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(FLOORS)

.PHONY: all clean
