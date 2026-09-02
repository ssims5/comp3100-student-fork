# Week 3 wax-seal checkpoints. Run from labs/week-03:  make -C check m1
# (Answers are checked spelled backwards below, so a glance here spoils nothing.)
SEAL := bash ../../lib/seal.sh 03
TMP  := /tmp/wo03-$(shell id -un)

# Every check below is BEHAVIOURAL: the seal reads what the program DOES, never
# what its source text says. Source greps were tried here and removed -- they
# refused a correct wait(&status) form once its TODO comments were deleted, and
# the greps meant to catch a faked program were themselves satisfied by those
# same shipped comments, so they never fired at all. Do not add them back.
# The order of the checks matters: each one is reachable only when the ones
# above it passed, which is what lets every message name a single cause.
m1:
	@gcc -Wall -Wextra -Werror -g -o $(TMP)-pg ../starter/pantograph.c
	@$(TMP)-pg echo test >$(TMP)-pg.out 2>&1 || true
	@grep -q 'desk copied' $(TMP)-pg.out || grep -qx 'test' $(TMP)-pg.out || { echo "  (the desk never copied -- pantograph reported that its fork failed. TODO 1: replace the -1 with your fork() call.)"; exit 1; }
	@grep -q 'desk copied' $(TMP)-pg.out || { echo "  (the parent never announced the copy. Either your execvp is running in the PARENT -- it belongs INSIDE the if (child == 0) block, on the line directly above perror -- or you edited the 'desk copied' printf, which this check reads. Restore that line exactly.)"; exit 1; }
	@grep -q 'execvp: ' $(TMP)-pg.out && { echo "  (the copy never became the command -- the perror line beneath TODO 2 ran, which means no execvp call executed there. TODO 2 goes INSIDE the if (child == 0) block, directly above that perror.)"; exit 1; } || true
	@grep -qx 'test' $(TMP)-pg.out || { echo "  (the command ran, but with the wrong argument list -- the first word it printed should be 'test', not the command's own name. Check TODO 2's second argument.)"; exit 1; }
	@grep -q 'exit status 0' $(TMP)-pg.out || { echo "  (no 'exit status 0' line. Either TODO 3 is missing, or you edited the 'copy ... finished' printf, which this check reads. Restore that line exactly.)"; exit 1; }
	@$(TMP)-pg false >$(TMP)-pg2.out 2>&1 || true
	@grep -q 'exit status 1' $(TMP)-pg2.out || { echo "  (a failing command must report exit status 1 -- is the parent really waiting?)"; exit 1; }
	@rm -f $(TMP)-pg $(TMP)-pg.out $(TMP)-pg2.out
	@$(SEAL) 1

m2:
	@test -f zombie-sighting.txt || { echo "  (No zombie-sighting.txt yet -- Task 2 step 3 captures it into check/.)"; exit 1; }
	@grep -Eq '[[:space:]]Z[^[:space:]]*[[:space:]]+.*defunct' zombie-sighting.txt || { echo "  (No line in Z state with <defunct> -- capture ps while zombie-maker still waits.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-03: cp check/answers-template check/answers.txt)"; exit 1; }
	@grep -Eq '^A1:.*[^[:space:]]' answers.txt || { echo "  (A1 is still blank in check/answers.txt.)"; exit 1; }
	@$(SEAL) 2

m3:
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-03: cp check/answers-template check/answers.txt)"; exit 1; }
	@grep -E '^A2:' answers.txt | grep -qF "$$(printf '.K.E' | rev)" || { echo "  (A2 must copy the patron line exactly as the environment gives it.)"; exit 1; }
	@grep -Eq '^A3:[^0-9]*[0-9]+' answers.txt || { echo "  (A3 must be the PPid number from /proc/<pid>/status.)"; exit 1; }
# If a tender is running on this bench, A3 must match ITS parent -- otherwise a
# stale number from a census taken before a restage seals silently. If no tender
# is running (shut the environment down since censusing), any number passes: the
# census was honest when it was taken and we cannot re-check it.
	@t=$$(pgrep -x -u "$$(id -un)" loom-tender 2>/dev/null | head -1); \
	 if [ -n "$$t" ] && [ -r "/proc/$$t/status" ]; then \
	   want=$$(awk '/^PPid:/{print $$2}' "/proc/$$t/status"); \
	   got=$$(grep -E '^A3:' answers.txt | sed 's/^A3://' | grep -oE '[0-9]+' | head -1); \
	   if [ -n "$$want" ] && [ "$$got" != "$$want" ]; then \
	     echo "  (A3 says $$got, but the tender on this bench reports PPid $$want."; \
	     echo "   You restaged since your census -- the pid changed. Re-read"; \
	     echo "   /proc/$$t/status and use the new number.)"; \
	     exit 1; \
	   fi; \
	 fi
	@$(SEAL) 3

.PHONY: m1 m2 m3
