# Week 4 wax-seal checkpoints. Run from labs/week-04:  make -C check m1
# (Strings are checked spelled backwards below, so a glance here spoils nothing.)
# Every answer is read with `sed -n 's/^AN://p'` so the check sees the VALUE
# only -- matching the whole line let the digit in the label satisfy a [0-9]
# guard, and a blank answer sealed the milestone.
# m3 has no live state to read (its demos end when the student Ctrl-Cs), so it
# binds A4 and A5 to the bench instead: A4 may not carry the work order's own
# example pid, and A5 must come in under the baseline the same student put in A1.
SEAL := bash ../../lib/seal.sh 04

m1:
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-04: cp check/answers-template check/answers.txt)"; exit 1; }
	@sed -n 's/^A1://p' answers.txt | grep -Eq '[0-9]' || { echo "  (A1 is still blank -- record your looms' settled baseline rates.)"; exit 1; }
	@pids="$$(pgrep -u "$$(id -u)" -f 'bash.*loom-job\.sh' || true)"; \
	n="$$(printf '%s\n' $$pids | grep -c . || true)"; \
	if [ "$$n" -lt 2 ]; then echo "  (Fewer than two looms at work -- Task 1 starts two, and this seal wants them still running.)"; exit 1; fi; \
	for p in $$pids; do \
	  ni="$$(ps -o ni= -p $$p | tr -d ' ')"; \
	  if [ "$$ni" != "19" ]; then echo "  (Loom $$p is at courtesy $$ni, not 19 -- Task 1 starts looms with nice -n 19. Stop any extras first.)"; exit 1; fi; \
	done
	@$(SEAL) 1

m2:
	@if command -v crontab >/dev/null 2>&1; then \
	  crontab -l >/dev/null 2>&1 || { echo "  (No appointment book at all on this bench. Striking out one line leaves the book in place and merely empty, so this means either staging never posted the appointment here, or the whole book was removed -- which is what 'crontab -r' does, personal lines and all. Task 2's if-you're-lost box covers both.)"; exit 1; }; \
	fi
	@! crontab -l 2>/dev/null | grep -qF "$$(printf '413 .oN tnemdnemA' | rev)" || { echo "  (The Board's standing orders still carry the offending line -- finish the strike-out before sealing.)"; exit 1; }
	@! crontab -l 2>/dev/null | grep -q "$$(printf 'hs.413-tnemdnema' | rev)" || { echo "  (That machinery is still dispatched on a schedule. The comment may be gone, but the appointment is not -- strike the whole line, not its tail.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-04: cp check/answers-template check/answers.txt)"; exit 1; }
	@sed -n 's/^A2://p' answers.txt | grep -Eq '[0-9]' || { echo "  (A2 is still blank -- the worst starved rate you measured during a drill, written as a numeral.)"; exit 1; }
	@a1="$$(sed -n 's/^A1://p' answers.txt | grep -oE '[0-9]+' | head -1)"; \
	a2="$$(sed -n 's/^A2://p' answers.txt | grep -oE '[0-9]+' | head -1)"; \
	if [ -n "$$a1" ] && [ -n "$$a2" ] && [ "$$a2" -ge "$$a1" ]; then \
	  echo "  (A2 ($$a2) is not below your own baseline in A1 ($$a1). A2 is the WORST rate a loom reported while the floor was stormed, not its healthy one.)"; exit 1; \
	fi
	@sed -n 's/^A3://p' answers.txt | grep -Eiq "$$(printf '41:51|41.51|41:3|eerht tsap' | rev)" || { echo "  (A3 must name the time of day the two numbers make together. Field order is minute, then hour.)"; exit 1; }
	@sed -n 's/^A3://p' answers.txt | grep -Eiq "$$(printf 'etunim' | rev)" || { echo "  (A3 must say IN WORDS which field is the minute -- the seal looks for the word itself.)"; exit 1; }
	@sed -n 's/^A3://p' answers.txt | grep -Eiq "$$(printf 'ruoh' | rev)" || { echo "  (A3 must say IN WORDS which field is the hour -- the seal looks for the word itself.)"; exit 1; }
	@$(SEAL) 2

m3:
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-04: cp check/answers-template check/answers.txt)"; exit 1; }
	@sed -n 's/^A4://p' answers.txt | grep -q "$$(printf 'OFIF_DEHCS' | rev)" || { echo "  (A4 wants the 'current scheduling policy' line the real-time demo printed, copied exactly -- a loom rate line is not it.)"; exit 1; }
	@sed -n 's/^A5://p' answers.txt | grep -q 'lines/sec' || { echo "  (A5 wants a settled rate line from the governed loom, pasted as printed.)"; exit 1; }
	@! sed -n 's/^A4://p' answers.txt | grep -q "$$(printf '56362' | rev)" || { echo "  (That is the work order's EXAMPLE pid, not one from your bench. A4 wants the policy line your own demo printed.)"; exit 1; }
	@sed -n 's/^A5://p' answers.txt | grep -Eq '[0-9]' || { echo "  (A5's rate line carries no number -- paste the line as the loom printed it.)"; exit 1; }
	@a1="$$(sed -n 's/^A1://p' answers.txt | grep -oE '[0-9]+' | head -1)"; \
	a5="$$(sed -n 's/^A5://p' answers.txt | grep -oE '[0-9]+' | head -1)"; \
	if [ -n "$$a1" ] && [ -n "$$a5" ] && [ "$$a5" -ge "$$a1" ]; then \
	  echo "  (A5 ($$a5) is not below your own baseline in A1 ($$a1). A governed loom is capped at a fifth of one engine -- it cannot match an ungoverned one. Check you pasted the GOVERNED line, not the reference.)"; exit 1; \
	fi
	@$(SEAL) 3

.PHONY: m1 m2 m3
