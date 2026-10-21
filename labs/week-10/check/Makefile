# Week 10 wax-seal checkpoints. Run from labs/week-10:  make -C check m1
#
# The house rules, all learned the hard way, all non-negotiable:
#
#  1. No backticks anywhere in a recipe's echo. A backtick inside an echo is
#     command substitution, and an earlier week's build caught one printing a
#     VALID wax seal inside a FAILURE message. There is not a single backtick
#     in this file; keep it that way.
#
#  2. Every numeric answer is parsed the same way, in every seal that reads
#     it:   sed -n 's/^AN://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'
#     The tr -d ',' lets 1,024 and 1024 read alike, and a space-separated
#     pair (A2) read as two numbers. Copy the pipeline exactly if you add a
#     seal.
#
#  3. Any string in here that would give an answer away is written BACKWARDS
#     and un-reversed at check time with 'rev', exactly as earlier weeks do,
#     so a glance at this file spoils nothing. That covers the owner's uid,
#     the A7 years, the desk letter, the A6 words, and -- above all --
#     both surnames from the record, so the Makefile never holds either name.
#     The perms token ---p is matched literally: the work order teaches it
#     openly and it gives nothing away.
#
#  4. A seal must never be satisfiable on a bench that never did the work.
#     Every seal first requires this week's keeper to be staged
#     (test -x the record-keeper binary under the survey), with a message
#     routing to report-for-duty.sh. It then checks what was copied off the
#     screen. No seal depends on the live daemon's memory: a seal runs
#     unprivileged and cannot read a uid-1849 process, so what it grades is
#     the answer file, as the reading tasks of Week 7 did.
#
#  5. No seal leaves a process behind. Nothing here launches, attaches to,
#     or signals the keeper; the dump in Task 4 is the student's own batch
#     gdb run, which detaches itself.
#
# Every answer is read with sed -n 's/^AN://p' so the check sees the VALUE
# only -- matching the whole line lets the digit in the label satisfy a
# [0-9] guard, and a blank answer seals the milestone.
#
# The record tokens (A6 opening-line words, A7 years and desk, A8 both
# surnames)
# are the keeper's own payload, fixed in report-for-duty.sh. If anyone edits
# that payload these go stale; the week's instructor-side bench check guards
# them.
# A5's size is NOT a stored constant: it is computed at check time as
# 256 * getconf PAGESIZE (N = 256, fixed in the keeper's source), so a bench
# with 16 KiB pages (arm64) checks against 4096 KiB without an edit here.

UID_R        := 9481
OOM_R        := moo
KILL_R       := llik
LIMIT_R      := 46
HEADWORDS_R  := tucnu tsivihcra
YEAR1_R      := 8481
YEAR2_R      := 9481
DESK_R       := kksed ksedk
NAME1_R      := soeruk
NAME2_R      := dooweltsiht

WING_PAGES := 256
KEEPER     := $$HOME/enginehouse/survey/record-keeper
SEAL       := bash ../../lib/seal.sh 10

m1:
	@test -x "$(KEEPER)" || { echo "  (The keeper is not staged on this bench, so nothing has been surveyed yet. From labs/week-10: bash report-for-duty.sh -- then make -C check m1 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-10: cp check/answers-template check/answers.txt, fill in A1 and A2, then make -C check m1 again.)"; exit 1; }
	@a1="$$(sed -n 's/^A1://p' answers.txt | tr 'A-Z' 'a-z')"; \
	if [ -z "$$(printf '%s' "$$a1" | tr -d '[:space:]')" ]; then echo "  (A1 is still blank -- the kinds of region your /proc/\$$\$$/maps shows, and the permissions column. Task 1 step 1. Then make -C check m1 again.)"; exit 1; fi; \
	for w in heap stack anon; do \
	  printf '%s' "$$a1" | grep -q "$$w" || { echo "  (A1 does not name the $$w region. Name at least heap, stack and an anonymous region, as your own map shows them. Task 1 step 1. Then make -C check m1 again.)"; exit 1; }; \
	done; \
	if ! printf '%s' "$$a1" | grep -qE 'perm|rwx|[-r][-w][-x][-p]'; then echo "  (A1 names the regions but not the column that carries read/write/execute. Name the permissions column too -- the rwxp one, such as rw-p. Task 1 step 1. Then make -C check m1 again.)"; exit 1; fi
	@c="$$(sed -n 's/^A2://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$c" -ne 2 ]; then echo "  (A2 wants TWO numbers: the first-round minor faults, then the second-round minor faults, in that order. Task 1 step 3. Then make -C check m1 again.)"; exit 1; fi; \
	f1="$$(sed -n 's/^A2://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 1p)"; \
	f2="$$(sed -n 's/^A2://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 2p)"; \
	if [ "$$f1" -eq 0 ]; then echo "  (A2's first-round count is zero. The first touch of each page should fault -- about one per page. Read the first round of a storeroom run, not the second. Task 1 step 3. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$f2" -ne 0 ]; then echo "  (A2's second-round count is not zero. The second round touches pages that are already there, so it faults ZERO times. Run storeroom and read both rounds of the one run. Task 1 step 3. Then make -C check m1 again.)"; exit 1; fi
	@$(SEAL) 1

m2:
	@test -x "$(KEEPER)" || { echo "  (The keeper is not staged on this bench. From labs/week-10: bash report-for-duty.sh -- then make -C check m2 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-10: cp check/answers-template check/answers.txt, fill it in, then make -C check m2 again.)"; exit 1; }
	@a3="$$(sed -n 's/^A3://p' answers.txt | tr 'A-Z' 'a-z')"; \
	if [ -z "$$(printf '%s' "$$a3" | tr -d '[:space:]')" ]; then echo "  (A3 is still blank -- the Overseer's verdict and the limit that provoked it. Task 2 step 3. Then make -C check m2 again.)"; exit 1; fi; \
	o="$$(printf '%s' '$(OOM_R)' | rev)"; k="$$(printf '%s' '$(KILL_R)' | rev)"; \
	if ! printf '%s' "$$a3" | grep -q "$$o" || ! printf '%s' "$$a3" | grep -q "$$k"; then echo "  (A3 is not the Overseer's verdict. Copy the result line from the governed run or Monday's deck -- the one that says the unit was oom-killed. Task 2 step 3. Then make -C check m2 again.)"; exit 1; fi; \
	want="$$(printf '%s' '$(LIMIT_R)' | rev)"; hit=0; \
	for n in $$(sed -n 's/^A3://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'); do [ "$$n" = "$$want" ] && hit=1; done; \
	if [ "$$hit" -eq 0 ]; then echo "  (A3 carries the verdict but not the limit that provoked it. Put the MemoryMax figure on the line too -- the ceiling the glutton crossed. Task 2 step 2. Then make -C check m2 again.)"; exit 1; fi
	@$(SEAL) 2

m3:
	@test -x "$(KEEPER)" || { echo "  (The keeper is not staged on this bench, so there is nothing to survey. From labs/week-10: bash report-for-duty.sh -- then make -C check m3 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-10: cp check/answers-template check/answers.txt, fill it in, then make -C check m3 again.)"; exit 1; }
	@want="$$(printf '%s' '$(UID_R)' | rev)"; hit=0; \
	for n in $$(sed -n 's/^A4://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'); do [ "$$n" = "$$want" ] && hit=1; done; \
	if [ "$$hit" -eq 0 ]; then echo "  (A4 is not the keeper's owner. Read the Uid line from /proc/\$$PID/status, or getent passwd on your own screen, and copy the number. Task 3 step 1. Then make -C check m3 again.)"; exit 1; fi
	@a5="$$(sed -n 's/^A5://p' answers.txt)"; \
	if [ -z "$$(printf '%s' "$$a5" | tr -d '[:space:]')" ]; then echo "  (A5 is still blank -- the walled-off room's perms and size. Task 3 step 3. Then make -C check m3 again.)"; exit 1; fi; \
	case "$$a5" in \
	  *'---p'*) : ;; \
	  *'rw-p'*|*'r-xp'*|*'r--p'*) echo "  (A5 names an open region's perms, not the walled-off room's. The room is the one with NO read, write or execute: its perms are ---p. Task 3 step 3. Then make -C check m3 again.)"; exit 1 ;; \
	  *) echo "  (A5 is missing the room's perms. Copy them exactly as the map prints them -- four characters, ---p. Task 3 step 3. Then make -C check m3 again.)"; exit 1 ;; \
	esac; \
	ps="$$(getconf PAGESIZE 2>/dev/null || echo 4096)"; \
	bytes=$$(( ps * $(WING_PAGES) )); kib=$$(( bytes / 1024 )); mib=$$(( kib / 1024 )); \
	hit=0; \
	for x in $$(sed -n 's/^A5://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'); do \
	  if [ "$$x" = "$$bytes" ] || [ "$$x" = "$$kib" ]; then hit=1; fi; \
	done; \
	for x in $$(sed -n 's/^A5://p' answers.txt | tr -d ',' | tr 'A-Z' 'a-z' | grep -oE '[0-9]+ ?m(ib|b)?([^a-z]|$$)' | grep -oE '^[0-9]+'); do \
	  if [ "$$mib" -gt 0 ] && [ "$$x" = "$$mib" ]; then hit=1; fi; \
	done; \
	if [ "$$hit" -eq 0 ]; then echo "  (A5's size is not the room's size. On this bench it is $$kib KiB ($$mib MiB, $$bytes bytes) -- read it from sudo pmap -x, the ----- [ anon ] line. Give it in KiB, in bytes, or in MiB with the unit right after the figure. Task 3 step 3. Then make -C check m3 again.)"; exit 1; fi
	@$(SEAL) 3

m4:
	@test -s "$$HOME/enginehouse/survey/wing.dump" || { echo "  (No wing.dump yet in ~/enginehouse/survey -- Task 4 step 1 dumps the room. Then make -C check m4 again.)"; exit 1; }
	@test -x "$(KEEPER)" || { echo "  (The keeper is not staged on this bench, so the wing was never opened. From labs/week-10: bash report-for-duty.sh -- then make -C check m4 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-10: cp check/answers-template check/answers.txt, fill it in, then make -C check m4 again.)"; exit 1; }
	@a6="$$(sed -n 's/^A6://p' answers.txt | tr 'A-Z' 'a-z' | tr -cd 'a-z')"; \
	if [ -z "$$a6" ]; then echo "  (A6 is still blank -- one neutral word from the record's opening lines, as proof you opened the room. Task 4 step 2. Then make -C check m4 again.)"; exit 1; fi; \
	hit=0; for w in $(HEADWORDS_R); do printf '%s' "$$a6" | grep -qF "$$(printf '%s' "$$w" | rev)" && hit=1; done; \
	if [ "$$hit" -eq 0 ]; then echo "  (A6 is not a word only the record uses. The word must appear nowhere else in the course's files, so the city's or the works' name will not do. Pick a rarer word from the record's opening lines. Task 4 step 2. Then make -C check m4 again.)"; exit 1; fi
	@y1="$$(printf '%s' '$(YEAR1_R)' | rev)"; y2="$$(printf '%s' '$(YEAR2_R)' | rev)"; h1=0; h2=0; \
	for n in $$(sed -n 's/^A7://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'); do [ "$$n" = "$$y1" ] && h1=1; [ "$$n" = "$$y2" ] && h2=1; done; \
	if [ "$$h1" -eq 0 ] || [ "$$h2" -eq 0 ]; then echo "  (A7 is missing a year the record carries. Write every year the record carries on the line, with the desk. Task 4 step 2. Then make -C check m4 again.)"; exit 1; fi; \
	a7="$$(sed -n 's/^A7://p' answers.txt | tr 'A-Z' 'a-z' | tr -cd 'a-z')"; \
	d=0; for w in $(DESK_R); do printf '%s' "$$a7" | grep -qF "$$(printf '%s' "$$w" | rev)" && d=1; done; \
	if [ "$$d" -eq 0 ]; then echo "  (A7 has the years but not the desk the record names. Add the desk, as the record spells it. Task 4 step 2. Then make -C check m4 again.)"; exit 1; fi
	@a8="$$(sed -n 's/^A8://p' answers.txt | tr 'A-Z' 'a-z' | tr -cd 'a-z')"; \
	one="$$(printf '%s' '$(NAME1_R)' | rev)"; two="$$(printf '%s' '$(NAME2_R)' | rev)"; c1=0; c2=0; \
	printf '%s' "$$a8" | grep -qF "$$one" && c1=1; \
	printf '%s' "$$a8" | grep -qF "$$two" && c2=1; \
	if [ "$$c1" -eq 1 ] && [ "$$c2" -eq 1 ]; then :; \
	elif [ "$$c1" -eq 1 ] || [ "$$c2" -eq 1 ]; then echo "  (A8 names only one. The record names two against the one desk; write both, side by side (and check the spelling), and draw no conclusion. Task 4 step 2. Then make -C check m4 again.)"; exit 1; \
	else echo "  (A8 names neither of the two the record attaches to the desk. Read the record again, and write both surnames it attaches to the desk, exactly as it spells them. Task 4 step 2. Then make -C check m4 again.)"; exit 1; fi
	@$(SEAL) 4

.PHONY: m1 m2 m3 m4
