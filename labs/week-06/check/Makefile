# Week 6 wax-seal checkpoints. Run from labs/week-06:  make -C check m1
#
# Three house rules, all learned the hard way, all non-negotiable:
#
#  1. No backticks anywhere in a recipe's echo. A backtick inside an echo is
#     command substitution, and week 5's build caught one printing a VALID
#     wax seal inside a FAILURE message -- handing a student who had just
#     failed a checkpoint the reward for passing it. There is not a single
#     backtick in this file; keep it that way.
#
#  2. Every numeric answer is parsed the same way, in every seal that reads
#     it:   sed -n 's/^AN://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'
#     Week 5 shipped a half-applied version of this (m1 accepted 200,000 and
#     m2 then choked on the same file), which is worse than neither accepting
#     it. If you add a seal, copy the pipeline exactly.
#
#  3. Any string in here that would give an answer away is written BACKWARDS
#     and un-reversed at check time with 'rev', exactly as weeks 2-5 do, so a
#     glance at this file spoils nothing. The pthread_* and sem_* names are
#     NOT reversed: the work order teaches them openly, so they are not
#     spoilers.
#
# Every answer is read with sed -n 's/^AN://p' so the check sees the VALUE
# only -- matching the whole line lets the digit in the label satisfy a
# [0-9] guard, and a blank answer seals the milestone.
#
# Where a seal needs a figure out of the student's own source (the chute's
# capacity, the number of gatemen) it reads it from the source rather than
# carrying a constant, so a student who changes a define is measured against
# what they actually built.
#
# m4 carries ONE constant that will go stale if anybody edits
# starter/philosophers.c: the cksum of the shipped file with all whitespace
# removed. If that file is ever changed, recompute it with
#   tr -d '[:space:]' < starter/philosophers.c | cksum | cut -d' ' -f1
# and update the value in m4, or the "you have not changed it" check quietly
# stops catching anything.
#  4. A seal must never be satisfiable by text that is not code. Two rules
#     follow from that, and both were added after a bench proved the hole:
#     an unmodified starter with the three required calls pasted into a
#     /* comment */, plus the figures this work order prints, sealed M1.
#
#     (a) EVERY source grep runs through $(NOCOMMENT), which is gcc asked to
#         strip comments and nothing else. -fpreprocessed stops it expanding
#         includes, so it needs no headers, touches no macros, and cannot
#         fail on any bench that compiles at all.
#     (b) EVERY seal that reads a program first requires that program to
#         BUILD, with the same flags the work order gives. gcc's own errors
#         are allowed through to the student, because they are the next
#         thing they need to read.
#
#     These do not make a seal a test -- it still cannot watch a condition
#     variable work, and the instructor-side script is still the thing that
#     builds and runs. They only mean the source has to be a program, and
#     the calls have to be in it.
NOCOMMENT = gcc -fpreprocessed -dD -E -P
CCTEST    = gcc -Wall -Wextra -pthread -o /dev/null

SEAL := bash ../../lib/seal.sh 06

m1:
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-06: cp check/answers-template check/answers.txt)"; exit 1; }
	@test -f ../starter/interlocking.c || { echo "  (starter/interlocking.c is missing. From labs/week-06: git checkout -- starter/interlocking.c)"; exit 1; }
	@$(CCTEST) ../starter/interlocking.c || { echo "  (starter/interlocking.c does not compile. The errors above are gcc's, not mine, and they are the first thing to fix -- nothing else this seal could tell you means anything until the file builds. From labs/week-06: make -C starter interlocking)"; exit 1; }
	@$(NOCOMMENT) ../starter/interlocking.c 2>/dev/null | grep -q pthread_mutex_lock || { echo "  (Nothing in starter/interlocking.c takes a guard before it looks at the frame. This seal reads the source you actually edited, and a declaration on its own is not a guard: the lock has to be TAKEN before the check. Task 1 step 3 prints every line.)"; exit 1; }
	@$(NOCOMMENT) ../starter/interlocking.c 2>/dev/null | grep -q pthread_cond_wait || { echo "  (starter/interlocking.c has a guard but nowhere to WAIT. A mutex stops the second train; it does not stop a gateman staring at a lever, and this task is both. The frame wants a condition variable with a while loop around pthread_cond_wait -- Task 1 step 3, second edit.)"; exit 1; }
	@$(NOCOMMENT) ../starter/interlocking.c 2>/dev/null | grep -q pthread_cond_signal || $(NOCOMMENT) ../starter/interlocking.c 2>/dev/null | grep -q pthread_cond_broadcast || { echo "  (starter/interlocking.c waits on a condition variable and never rings the bell, so a gateman who goes to sleep is never woken. Something has to signal when the lever comes back to normal -- Task 1 step 3, fourth edit.)"; exit 1; }
	@n="$$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -lt 3 ]; then echo "  (A1 wants THREE numbers on the one A1 line: trains booked through, then the second-train count, then the day-book count. Task 1 step 6 gives the order.)"; exit 1; fi
	@g="$$(grep -oE '^[#]define[[:space:]]+GATEMEN[[:space:]]+[0-9]+' ../starter/interlocking.c | grep -oE '[0-9]+' | head -1)"; \
	c="$$(grep -oE '^[#]define[[:space:]]+CROSSINGS[[:space:]]+[0-9]+' ../starter/interlocking.c | grep -oE '[0-9]+' | head -1)"; \
	if [ -z "$$g" ]; then g=4; fi; \
	if [ -z "$$c" ]; then c=30000; fi; \
	want=$$(($$g * $$c)); \
	set -- $$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'); \
	booked="$$1"; clash="$$2"; torn="$$3"; \
	if [ "$$booked" -ne "$$want" ]; then echo "  (A1 books $$booked trains through. Your own source puts $$g gatemen on $$c crossings apiece, which is $$want, and that figure is exact on every bench, broken or fixed. Check you copied the 'trains booked through' line and not one gateman's own.)"; exit 1; fi; \
	if [ "$$clash" -ne 0 ]; then echo "  (A1 still reports $$clash crossings with a second train on the single line. That is the fault, not the fix. The guard has to be taken BEFORE the while loop and released AFTER the line is claimed, so the check and the claim happen inside one held guard.)"; exit 1; fi; \
	if [ "$$torn" -ne 0 ]; then echo "  (A1 still reports $$torn day-book entries in another hand. The day-book is written inside the same held guard as the claim on the line. If the unlock went in above it, two gatemen can still be at the desk together.)"; exit 1; fi
	@$(SEAL) 1

m2:
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-06: cp check/answers-template check/answers.txt)"; exit 1; }
	@test -f ../starter/sorting-floor.c || { echo "  (starter/sorting-floor.c is missing. From labs/week-06: git checkout -- starter/sorting-floor.c)"; exit 1; }
	@$(CCTEST) ../starter/sorting-floor.c || { echo "  (starter/sorting-floor.c does not compile. The errors above are gcc's, and they are the first thing to fix. A missing semaphore.h include is the usual one this week -- Task 2 step 4, Edit 1. From labs/week-06: make -C starter sorting-floor)"; exit 1; }
	@$(NOCOMMENT) ../starter/sorting-floor.c 2>/dev/null | grep -q sem_wait || { echo "  (Nothing in starter/sorting-floor.c waits for anything yet. A press that glances at a full chute and tips anyway has not waited, and a sorter that reaches into an empty slot has not either. Task 2 step 4 prints every line.)"; exit 1; }
	@$(NOCOMMENT) ../starter/sorting-floor.c 2>/dev/null | grep -q sem_post || { echo "  (starter/sorting-floor.c waits on a semaphore and never posts to one, so whatever went to sleep is still asleep. Every sem_wait has a sem_post opposite it: one on the press side, one on the sorter side, and the shift bell in main.)"; exit 1; }
	@n="$$(sed -n 's/^A2://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -lt 1 ]; then echo "  (A2 is still blank -- the 'deepest the chute ever got' figure your fixed build printed, as one number. If your build does not print that line at all, it is the printf at the end of Task 2 step 4 that adds it.)"; exit 1; fi
	@cap="$$(grep -oE '^[#]define[[:space:]]+CHUTE[[:space:]]+[0-9]+' ../starter/sorting-floor.c | grep -oE '[0-9]+' | head -1)"; \
	if [ -z "$$cap" ]; then cap=8; fi; \
	mark="$$(sed -n 's/^A2://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -1)"; \
	if [ "$$mark" -le 0 ]; then echo "  (A2 says the chute never held a single card. Then nothing was ever tipped into it, which is not what the run printed. Copy the 'deepest the chute ever got' figure.)"; exit 1; fi; \
	if [ "$$mark" -gt "$$cap" ]; then echo "  (A2 is $$mark, and your own source declares a chute that holds $$cap. A chute that holds $$cap never holds $$mark. Either that figure came off the broken floor, or sem_wait on the room counter is not being reached before the tip -- and if the floor stops instead, re-read the note about waiting OUTSIDE the guard.)"; exit 1; fi
	@n="$$(sed -n 's/^A3://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -lt 2 ]; then echo "  (A3 wants TWO numbers on the one A3 line: cards tipped in, then cards carried away.)"; exit 1; fi
	@set -- $$(sed -n 's/^A3://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'); \
	tipped="$$1"; carried="$$2"; \
	if [ "$$tipped" -le 0 ] || [ "$$carried" -le 0 ]; then echo "  (A3 carries a zero. Cards went in and the same cards have to come out; neither figure is zero on a floor that ran at all.)"; exit 1; fi; \
	if [ "$$tipped" -ne "$$carried" ]; then echo "  (A3 says $$tipped cards went in and $$carried came out. Those are the same cards counted at two ends of one chute, so they have to agree exactly. If your floor really is short, the fix is not complete -- and the answer file is not the place to settle it.)"; exit 1; fi
	@$(SEAL) 2

m3:
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-06: cp check/answers-template check/answers.txt)"; exit 1; }
	@test -f ../starter/ledger-hall.c || { echo "  (starter/ledger-hall.c is missing. From labs/week-06: git checkout -- starter/ledger-hall.c)"; exit 1; }
	@$(CCTEST) ../starter/ledger-hall.c || { echo "  (starter/ledger-hall.c does not compile. The errors above are gcc's, and they are the first thing to fix. If it is the writer-preference attribute that will not resolve, the #define _GNU_SOURCE has to be the FIRST line of the file, above every include -- Task 3 step 4, Edit 1. From labs/week-06: make -C starter ledger-hall)"; exit 1; }
	@src="$$($(NOCOMMENT) ../starter/ledger-hall.c 2>/dev/null)"; \
	rd=0; wr=0; cv=0; mx=0; \
	if printf '%s' "$$src" | grep -q pthread_rwlock_rdlock; then rd=1; fi; \
	if printf '%s' "$$src" | grep -q pthread_rwlock_wrlock; then wr=1; fi; \
	if printf '%s' "$$src" | grep -q pthread_cond_wait && { printf '%s' "$$src" | grep -q pthread_cond_broadcast || printf '%s' "$$src" | grep -q pthread_cond_signal; }; then cv=1; fi; \
	if printf '%s' "$$src" | grep -q pthread_mutex_lock; then mx=1; fi; \
	if [ "$$rd" -eq 1 ] && [ "$$wr" -eq 1 ]; then \
	  : ; \
	elif [ "$$cv" -eq 1 ]; then \
	  : ; \
	elif [ "$$rd" -eq 1 ] || [ "$$wr" -eq 1 ]; then \
	  echo "  (starter/ledger-hall.c uses half of a reader/writer lock. There are two doors and this hall needs both: pthread_rwlock_rdlock for the six readers, pthread_rwlock_wrlock for the one clerk, and the same pthread_rwlock_unlock for each. Task 3 step 4, Edit 3.)"; exit 1; \
	elif [ "$$mx" -eq 1 ]; then \
	  echo "  (starter/ledger-hall.c puts one plain mutex around everything. That DOES make every page balance, and no arithmetic on your answers could tell the difference -- which is exactly why this seal reads your source instead. One mutex admits one reader at a time, so five of your six readers queue for a lock that none of them needed and nobody is reading anything faster than the pen writes it. Reading conflicts with writing, not with reading. Give the readers pthread_rwlock_rdlock and the clerk pthread_rwlock_wrlock, and read Task 3 step 3 again before you do.)"; exit 1; \
	else \
	  echo "  (Nothing in starter/ledger-hall.c stands between the pen and the rail yet. This seal reads the source you actually edited. Task 3 step 4 prints every line.)"; exit 1; \
	fi
	@n="$$(sed -n 's/^A4://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -lt 2 ]; then echo "  (A4 wants TWO numbers on the one A4 line: pages read, then pages that did not balance.)"; exit 1; fi
	@set -- $$(sed -n 's/^A4://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'); \
	seen="$$1"; torn="$$2"; \
	if [ "$$seen" -le 0 ]; then echo "  (A4 says no pages were read at all. Copy the 'pages read' line, which is the total across all six readers, and copy it from the run you are claiming.)"; exit 1; fi; \
	if [ "$$torn" -ne 0 ]; then echo "  (A4 still reports $$torn pages that did not balance, and one torn page is one too many. The clerk's four district writes AND the total at the foot have to sit inside ONE held write-lock; wrap only the column and a reader can still walk in before the foot is written.)"; exit 1; fi
	@$(SEAL) 3

m4:
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-06: cp check/answers-template check/answers.txt)"; exit 1; }
	@test -f ../starter/philosophers.c || { echo "  (starter/philosophers.c is missing. From labs/week-06: git checkout -- starter/philosophers.c)"; exit 1; }
	@sum="$$(tr -d '[:space:]' < ../starter/philosophers.c | cksum | cut -d' ' -f1)"; \
	if [ "$$sum" = "1041770864" ]; then echo "  (starter/philosophers.c is exactly as it was shipped -- not one character changed. Describe the table first, in your logbook, and then break the ring: Task 4 step 6 prints every line. If you did edit it, your editor saved somewhere else; check with git diff starter/philosophers.c)"; exit 1; fi
	@$(CCTEST) ../starter/philosophers.c || { echo "  (starter/philosophers.c does not compile. The errors above are gcc's, and they are the first thing to fix. From labs/week-06: make -C starter philosophers)"; exit 1; }
	@n="$$($(NOCOMMENT) ../starter/philosophers.c 2>/dev/null | grep -c 'pthread_mutex_lock(&fork_on_table\[')"; \
	if [ "$$n" -lt 2 ]; then echo "  (starter/philosophers.c no longer picks up two forks. A philosopher who can eat with one fork is not a table that was fixed; it is a table that was emptied. Put both locks back and change the ORDER they are taken in.)"; exit 1; fi
	@p="$$(grep -oE '^[#]define[[:space:]]+PHILOSOPHERS[[:space:]]+[0-9]+' ../starter/philosophers.c | grep -oE '[0-9]+' | head -1)"; \
	m="$$(grep -oE '^[#]define[[:space:]]+MEALS_WANTED[[:space:]]+[0-9]+' ../starter/philosophers.c | grep -oE '[0-9]+' | head -1)"; \
	if [ "$$p" != "5" ] || [ "$$m" != "3" ]; then echo "  (starter/philosophers.c no longer seats five philosophers for three meals apiece. Emptying the table is not breaking the ring. Put the two defines back as they were and order the forks instead.)"; exit 1; fi
	@test -n "$$(sed -n 's/^A5://p' answers.txt | tr -d '[:space:]')" || { echo "  (A5 is still blank. From the STALLED run: all five philosophers, and for each one the fork in their hand and the fork they are waiting for.)"; exit 1; }
	@a5="$$(sed -n 's/^A5://p' answers.txt)"; n=0; \
	for r in ailerua llewmarb ailedroc dnomsed ecatsue; do \
	  if printf '%s' "$$a5" | grep -iqF "$$(printf '%s' "$$r" | rev)"; then n=$$(($$n + 1)); fi; \
	done; \
	if [ "$$n" -lt 5 ]; then echo "  (A5 names only $$n of the five at that table. There are five, and every one of them is in exactly the same position -- that is the whole of what makes it a ring. The program prints all five names itself, twice over, before it goes quiet.)"; exit 1; fi
	@a5="$$(sed -n 's/^A5://p' answers.txt)"; \
	if ! printf '%s' "$$a5" | grep -iqF "$$(printf 'krof' | rev)"; then echo "  (A5 does not mention a fork. For each philosopher the slot wants both: which fork is in the hand, and which fork the hand is out for -- by number.)"; exit 1; fi; \
	if ! printf '%s' "$$a5" | grep -iqF "$$(printf 'dloh' | rev)" && ! printf '%s' "$$a5" | grep -iqF "$$(printf 'dleh' | rev)"; then echo "  (A5 does not say what anybody is HOLDING. Both halves are wanted for each of the five: what is in the hand, and what the hand is out for.)"; exit 1; fi; \
	if ! printf '%s' "$$a5" | grep -iqF "$$(printf 'tiaw' | rev)"; then echo "  (A5 does not say what anybody is WAITING for. Both halves are wanted for each of the five: what is in the hand, and what the hand is out for.)"; exit 1; fi
	@a6="$$(sed -n 's/^A6://p' answers.txt)"; \
	if [ "$$(printf '%s' "$$a6" | tr -d '[:space:]' | wc -c | tr -d ' ')" -lt 20 ]; then echo "  (A6 is blank or barely there. One sentence: the RULE you applied, written so that somebody could follow it without seeing your code.)"; exit 1; fi; \
	k=0; \
	for r in krof kcol xetum ecruoser; do \
	  if printf '%s' "$$a6" | grep -iqF "$$(printf '%s' "$$r" | rev)"; then k=1; fi; \
	done; \
	if [ "$$k" -eq 0 ]; then echo "  (A6 does not name the thing that gets taken in order. Say it of the forks at this table, or of locks in general -- either one is a rule. The ORDER is the part that has to be in the sentence.)"; exit 1; fi; \
	n=0; \
	for r in redro rewol tsewol rebmun etisoppo esrever rellams gnidnecsa; do \
	  if printf '%s' "$$a6" | grep -iqF "$$(printf '%s' "$$r" | rev)"; then n=1; fi; \
	done; \
	if [ "$$n" -eq 0 ]; then echo "  (A6 does not yet state a rule. What went wrong at that table was that all five agreed on a direction, so a rule that breaks the ring has to say something about the ORDER forks are taken in -- and it should read as something you could hand to a different program tomorrow, not as a description of your diff.)"; exit 1; fi
	@$(SEAL) 4

m5:
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-06: cp check/answers-template check/answers.txt)"; exit 1; }
	@test -n "$$(sed -n 's/^A7://p' answers.txt | tr -d '[:space:]')" || { echo "  (A7 is still blank -- the uid the lock record books, and what the house roll says that uid was for.)"; exit 1; }
	@want="$$(printf '9481' | rev)"; got=0; \
	for x in $$(sed -n 's/^A7://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'); do \
	  if [ "$$x" = "$$want" ]; then got=1; fi; \
	done; \
	if [ "$$got" -eq 0 ]; then echo "  (A7 does not carry the uid the lock record books. It is on the 'held by, uid' line of lock-record.txt, and the file itself will tell you the same number: stat -c '%u' ~/enginehouse/interlocking/lever-07.lock)"; exit 1; fi
	@a7="$$(sed -n 's/^A7://p' answers.txt)"; corps=0; fate=0; \
	if printf '%s' "$$a7" | grep -iqF "$$(printf 'gnitupmoc' | rev)"; then corps=1; fi; \
	if printf '%s' "$$a7" | grep -iqF "$$(printf 'sproc' | rev)"; then corps=1; fi; \
	if printf '%s' "$$a7" | grep -iqF "$$(printf 'vihcra' | rev)"; then fate=1; fi; \
	if [ "$$corps" -eq 0 ] && [ "$$fate" -eq 0 ]; then echo "  (A7 has the number and nothing the roll said. The roll answers anyone who asks it properly: getent passwd 1849 gives one line of seven colon-separated fields, and the FIFTH is the description. Read it, and copy it as the roll spells it.)"; exit 1; fi; \
	if [ "$$corps" -eq 0 ] || [ "$$fate" -eq 0 ]; then echo "  (A7 carries half of what the roll says. That description field has two halves to it: which part of the house the account belonged to, and what was to become of it. Copy the whole field rather than a word out of it.)"; exit 1; fi
	@$(SEAL) 5

.PHONY: m1 m2 m3 m4 m5
