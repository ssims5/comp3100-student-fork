# The survey bench -- Work Order No. 1851-10, Tasks 1 and 2.
#
#   make            build storeroom and glutton
#   make clean      sweep both builds away
#
# -g so a debugger can name a line; -O0 so each program runs exactly as it
# is written, nothing optimised away. Neither program needs sudo or a
# network; neither keeps running on its own (storeroom exits; glutton stops
# itself at 512 MiB, or sooner if the governor evicts it).

CC     = gcc
CFLAGS = -Wall -Wextra -g -O0

all: storeroom glutton

storeroom: storeroom.c
	$(CC) $(CFLAGS) -o $@ $<

glutton: glutton.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f storeroom glutton

.PHONY: all clean
