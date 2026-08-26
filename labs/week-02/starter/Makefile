# The forge — Work Order No. 1851-02, Task 1.
#
#   make            cast the bench build (AddressSanitizer watches every run)
#   make valgrind   cast a separate plain build and walk it under valgrind
#   make clean      break up both castings
#
# Two builds on purpose: AddressSanitizer and valgrind are rival watchmen
# and cannot share one binary. The bench build carries ASan; the -vg build
# carries nothing, so valgrind can do its own watching.

CC     = gcc
CFLAGS = -Wall -Wextra -g -fsanitize=address

hello-brassbridge: hello-brassbridge.c
	$(CC) $(CFLAGS) -o $@ $<

hello-brassbridge-vg: hello-brassbridge.c
	$(CC) -Wall -Wextra -g -o $@ $<

valgrind: hello-brassbridge-vg
	valgrind --error-exitcode=1 ./hello-brassbridge-vg

clean:
	rm -f hello-brassbridge hello-brassbridge-vg

.PHONY: valgrind clean
