# Week 7 wax-seal checkpoints. Run from labs/week-07:  make -C check m1
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
#     Week 5 shipped a half-applied version of this, which is worse than
#     neither. If you add a seal, copy the pipeline exactly. (A5 adds one
#     filter in the middle, grep -oE 'ring-frame\.c:[0-9]+', used only when
#     the line carries a pasted gdb location; the ends of the pipe are the
#     same.)
#
#  3. Any string in here that would give an answer away is written BACKWARDS
#     and un-reversed at check time with 'rev', exactly as weeks 2-6 do, so a
#     glance at this file spoils nothing. That covers the four box names, the
#     four conditions and every figure. The gdb commands are not reversed:
#     the work order teaches them openly, so they are not spoilers.
#
# Every answer is read with sed -n 's/^AN://p' so the check sees the VALUE
# only -- matching the whole line lets the digit in the label satisfy a
# [0-9] guard, and a blank answer seals the milestone.
#
# Text answers are compared after the same folding everywhere: lower case,
# and spaces, tabs, hyphens and underscores removed, so Old Quarter,
# old-quarter and OLDQUARTER are one name. The conditions also have an
# ampersand read as "and", and A6 folds further still (see below).
#
#  4. A seal must never be satisfiable on a bench that never staged the
#     week. This week there is no source of the student's own to build --
#     the model is compiled at staging and its drawing is not kept -- so
#     every seal first requires the staged model to exist and be executable.
#     That does not make a seal a test: it cannot watch the ring stand or
#     clear. It only means there was a bench.
#
# m2 carries ONE constant that goes stale if anybody edits the model's
# source inside report-for-duty.sh: LOCK_LINE_R, the line gdb reports for
# the waiting lock in every take_lever frame, written backwards. If the
# payload is ever changed, stage a bench, run the model under gdb, read the
# number after ring-frame.c: in any take_lever frame of thread apply all bt,
# and set LOCK_LINE_R to that number reversed -- in the same commit.
#
# How two answers are read, for whoever maintains this:
#  - A4 is walked from box name to box name (a lever name counts as its
#    box). The words between two names make the link: waits for, wants,
#    needs, for, or an arrow run it from the first name to the second;
#    failing those, holds, held or has run it the other way. Only the words
#    after the last comma, semicolon, full stop, colon, bracket or = in
#    that stretch count, so the boundary between two clauses is never a
#    link, and a list of names with no waits in it is no ring.
#  - A6a..A6d each name their condition at the very START of the line.
#    One leading list mark is dropped -- 3. 3) c) (c) iii. and the like, or
#    a step and item together, 3(c) 3c) (3c) 3.c), as a student might copy
#    Task 3's own numbering and lettering -- then the rest is folded
#    to its letters alone: lower case, an ampersand read as and, and every
#    digit, space, dash and bracket gone. What is left must BEGIN with one
#    of the forms in COND_R, each a condition's name or a usual variant cut
#    to a stem; mutual exclusion may have mutual or mutually in front of
#    its stem, and no preemption may have no, non, resource or no resource.
#    Nothing else may come first, so a line that opens with starvation,
#    deadlock or a command names no condition, however its evidence goes on
#    to say cycle or preempted, separator or none. What follows the name is
#    never read, beyond m3's length floor.
#  The arrow is written as an octal escape (printf) so that this file stays
#  plain ASCII.
LOCK_LINE_R := 721
RING_R      := wornlik retrauqdlo edisretaw etaghtron
COND_R      := wc:lcyc wc:ralucric pn:tpmeerpecruosernon pn:tpmeerpecruoseron pn:tpmeerpecruoser pn:tpmeerpnon pn:tpmeerpon pn:tpmeerp wh:tiawelihwgnidloh wh:tiawelihwsdloh wh:tiawelihwdloh wh:tiawdloh wh:tiawdnagnidloh wh:tiawdnasdloh wh:tiawdnadloh em:isulcxe em:isulcxeyllautum em:isulcxelautum

SEAL := bash ../../lib/seal.sh 07

m1:
	@test -x "$$HOME/enginehouse/ring-line/ring-frame" || { echo "  (There is no Ring Line model on this bench, so nothing has been staged to seal. From labs/week-07: bash report-for-duty.sh -- then make -C check m1 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-07: cp check/answers-template check/answers.txt, fill in A1 to A3, then make -C check m1 again.)"; exit 1; }
	@n="$$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -lt 4 ]; then echo "  (A1 wants FOUR numbers on the one A1 line: the seconds of each of the log's four holds -- the last two digits of every hold time -- with spaces between them. A comma is read as part of a figure, so 07,21 is one number here. Task 1 step 3. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$n" -gt 12 ]; then echo "  (A1 carries $$n numbers. It wants the seconds of the four holds and nothing else that looks like a number: four figures, or at most the four hold times written as hh:mm:ss -- not whole log lines with their dates. Task 1 step 3. Then make -C check m1 again.)"; exit 1; fi
	@got=0; \
	for w in 70 12 53 94; do \
	  want="$$(printf '%s' "$$w" | rev)"; hit=0; \
	  for x in $$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+'); do \
	    if [ "$$x" -eq "$$want" ] 2>/dev/null; then hit=1; fi; \
	  done; \
	  got=$$(($$got + $$hit)); \
	done; \
	if [ "$$got" -lt 4 ]; then echo "  (A1 carries $$got of the four seconds figures the log books. Read the four hold taken lines again and copy the seconds -- the last two digits -- of every one of them. Then make -C check m1 again.)"; exit 1; fi
	@n="$$(sed -n 's/^A2://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A2 wants ONE number: the gap between one hold and the next, in whole seconds, and nothing else on the line that looks like a number. Task 1 step 3. Then make -C check m1 again.)"; exit 1; fi
	@want="$$(printf '41' | rev)"; \
	gap="$$(sed -n 's/^A2://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -1)"; \
	if ! [ "$$gap" -eq "$$want" ] 2>/dev/null; then echo "  (A2 says $$gap seconds between one hold and the next. Take each hold's seconds from the next hold's, and check your subtraction on every pair down the log, not just the first. Then make -C check m1 again.)"; exit 1; fi
	@a3="$$(sed -n 's/^A3://p' answers.txt | tr 'A-Z' 'a-z' | tr -d ' \t_-')"; \
	if [ -z "$$a3" ]; then echo "  (A3 is still blank -- the ONE box the manual page says a release order should name. Task 1 step 5. Then make -C check m1 again.)"; exit 1; fi; \
	n=0; \
	for r in etaghtron edisretaw retrauqdlo wornlik; do \
	  if printf '%s' "$$a3" | grep -qF "$$(printf '%s' "$$r" | rev)"; then n=$$(($$n + 1)); fi; \
	done; \
	if [ "$$n" -eq 0 ]; then echo "  (A3 names no box on the Ring Line. The page's rule is a description; the answer is one of the four names in the log, spelled as the log spells it. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$n" -gt 1 ]; then echo "  (A3 names more than one box. The manual is plain about it: a release order names ONE box, and one only. Then make -C check m1 again.)"; exit 1; fi; \
	if ! printf '%s' "$$a3" | grep -qF "$$(printf 'wornlik' | rev)"; then echo "  (A3 does not name the box the manual's rule picks. Rule 2 on the page says which claim to name; put it beside the four hold times in the log. Then make -C check m1 again.)"; exit 1; fi
	@$(SEAL) 1

m2:
	@test -x "$$HOME/enginehouse/ring-line/ring-frame" || { echo "  (There is no Ring Line model on this bench, so there is nothing for gdb to read. From labs/week-07: bash report-for-duty.sh -- then make -C check m2 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-07: cp check/answers-template check/answers.txt, fill it in, then make -C check m2 again.)"; exit 1; }
	@test -n "$$(sed -n 's/^A4://p' answers.txt | tr -d '[:space:]')" || { echo "  (A4 is still blank -- the ring, written as X waits for Y, Y waits for Z, all the way round and back to the first box. Task 2 step 8. Then make -C check m2 again.)"; exit 1; }
	@ring="$$(printf '%s' '$(RING_R)' | rev)"; \
	v="$$(sed -n 's/^A4://p' answers.txt | tr 'A-Z' 'a-z' | tr -d ' \t_-' | tr '\n' ';' | awk -v ring="$$ring" -v arr="$$(printf '\342\206\222')" ' \
	  function step(a, b) { return (at[b] - at[a] + n) % n } \
	  { n = split(ring, r, " "); for (i = 1; i <= n; i++) at[r[i]] = i; \
	    s = $$0; p = ""; d = 0; L = 0; f = b = o = 0; \
	    while (1) { \
	      k = 0; w = ""; \
	      for (i = 1; i <= n; i++) { j = index(s, r[i]); if (j && (k == 0 || j < k)) { k = j; w = r[i] } } \
	      if (k == 0) break; \
	      c = substr(s, 1, k - 1); s = substr(s, k + length(w)); \
	      if (!(w in seen)) { seen[w] = 1; d++ } \
	      if (p != "" && p != w) { \
	        while (match(c, /[,;.:()=]/)) c = substr(c, RSTART + 1); \
	        dir = 0; \
	        if (c ~ /wait|want|need|for|>/ || index(c, arr)) dir = 1; else if (c ~ /hold|held|has/) dir = -1; \
	        if (dir) { L++; x = p; y = w; if (dir < 0) { x = w; y = p } t = step(x, y); \
	          if (t == 1) { if (!(x in F)) { F[x] = 1; f++ } } else if (t == n - 1) { if (!(x in B)) { B[x] = 1; b++ } } else o++ } \
	      } \
	      p = w \
	    } \
	    if (d < n) print "few", d; \
	    else if (L == 0) print "none"; \
	    else if (f == n && b == 0 && o == 0) print "ok"; \
	    else if (b > 0 && f == 0 && o == 0) print "back"; \
	    else if (f > 0 && b == 0 && o == 0) print "short", f; \
	    else print "tangle" }')"; \
	case "$$v" in \
	  ok) : ;; \
	  "few 0") echo "  (A4 names none of the four boxes. The ring is made of boxes: write it as X waits for Y, Y waits for Z, and so on back to the first, using the names as the log spells them. Then make -C check m2 again.)"; exit 1 ;; \
	  few*) echo "  (A4 names only $${v#few } of the four boxes -- or spells one in a way the check cannot read. Every box on the Ring Line is in the ring, each spelled as the log spells it: write the whole way round, as X waits for Y, Y waits for Z, and so on back to the first. Then make -C check m2 again.)"; exit 1 ;; \
	  none) echo "  (A4 names the boxes but never says who waits for whom. Put waits for, or an arrow, between the two boxes of every link: X waits for Y, Y waits for Z, and so on back to the first. Task 2 step 8. Then make -C check m2 again.)"; exit 1 ;; \
	  back) echo "  (A4, read as X waits for Y, goes round the ring the wrong way. Who is waiting for whom? A box waits for the lever named in its OWN take_lever frame -- the lever= part -- and the box it waits for is the one whose holding is that lever. Write every link with the waiting box first: X waits for Y. Then make -C check m2 again.)"; exit 1 ;; \
	  short*) echo "  (A4 gives only $${v#short } of the ring's four waits. Every box in a deadlock is waiting for somebody: give each box's wait, and the chain closes back on the box it started from. Then make -C check m2 again.)"; exit 1 ;; \
	  *) echo "  (A4 does not read as one ring of waits. Write it in exactly this shape, one link after another: X waits for Y, Y waits for Z, Z waits for W, W waits for X -- with the box names as the log spells them, and nothing else on the line. Task 2 step 8. Then make -C check m2 again.)"; exit 1 ;; \
	esac
	@test -n "$$(sed -n 's/^A5://p' answers.txt | tr -d '[:space:]')" || { echo "  (A5 is still blank -- the line number gdb gives for the waiting lock, read off any take_lever frame. Task 2 step 6. Then make -C check m2 again.)"; exit 1; }
	@want="$$(printf '%s' '$(LOCK_LINE_R)' | rev)"; \
	if sed -n 's/^A5://p' answers.txt | grep -q 'ring-frame\.c:[0-9]'; then \
	  nums="$$(sed -n 's/^A5://p' answers.txt | tr -d ',' | grep -oE 'ring-frame\.c:[0-9]+' | grep -oE '[0-9]+' | sort -u)"; \
	else \
	  nums="$$(sed -n 's/^A5://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sort -u)"; \
	fi; \
	if [ "$$(printf '%s\n' "$$nums" | grep -c .)" -ne 1 ]; then echo "  (A5 wants ONE number: the line gdb gives for the waiting lock, after ring-frame.c: in a take_lever frame -- and nothing else on the line that looks like a number. Task 2 step 6. Then make -C check m2 again.)"; exit 1; fi; \
	if ! [ "$$nums" -eq "$$want" ] 2>/dev/null; then echo "  (A5 does not carry the line gdb names for the waiting lock. In thread apply all bt, every waiting box has a take_lever frame that ends at ring-frame.c: and a number -- that number, not the frame number after the #, not a thread number and not an LWP. Then make -C check m2 again.)"; exit 1; fi
	@$(SEAL) 2

m3:
	@test -x "$$HOME/enginehouse/ring-line/ring-frame" || { echo "  (There is no Ring Line model on this bench, so there is nothing to release. From labs/week-07: bash report-for-duty.sh -- then make -C check m3 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-07: cp check/answers-template check/answers.txt, fill it in, then make -C check m3 again.)"; exit 1; }
	@for L in A6a A6b A6c A6d; do \
	  v="$$(sed -n "s/^$$L://p" answers.txt | tr -d '[:space:]')"; \
	  if [ -z "$$v" ]; then echo "  ($$L is still blank. A6a to A6d want the four conditions, one to a line, each line starting with the condition and carrying its evidence from your own gdb screen on the same line. Task 3 step 3. Then make -C check m3 again.)"; exit 1; fi; \
	  if [ "$$(printf '%s' "$$v" | wc -c | tr -d ' ')" -lt 20 ]; then echo "  ($$L is too short to carry a condition AND its evidence. After the name, say what on your own screen shows it holding: the command, and what it printed. Then make -C check m3 again.)"; exit 1; fi; \
	done
	@seen=" "; \
	for L in A6a A6b A6c A6d; do \
	  h="$$(sed -n "s/^$$L://p" answers.txt | head -n 1 | sed -E 's/^[[:space:]]*[([]?([0-9]+[]).:]?[[:space:]]*[([]?)?([0-9]+|[A-Da-d]|[ivxIVX]+)[]).:]//' | tr 'A-Z' 'a-z' | sed 's/&/and/g' | LC_ALL=C tr -cd 'a-z')"; \
	  c="$$(printf '%s\n' "$$h" | awk -v st="$$(printf '%s' '$(COND_R)' | rev)" '{ n = split(st, a, " "); code = "none"; for (i = 1; i <= n; i++) { split(a[i], q, ":"); if (index($$0, q[1]) == 1) code = q[2] } print code }')"; \
	  if [ "$$c" = none ]; then echo "  ($$L does not start with one of the four conditions. Open the line with the condition's name, as Task 3 step 1 gives it, and put nothing in front of it but a list mark if you like, such as 3. or (c) or 3(c). After the name put --, then the command and what it showed. Then make -C check m3 again.)"; exit 1; fi; \
	  case "$$seen" in *" $$c "*) echo "  ($$L starts with the same condition as an earlier A6 line. A deadlock needs all four at once, so the four lines want four different conditions, one to a line. Then make -C check m3 again.)"; exit 1 ;; esac; \
	  seen="$$seen$$c "; \
	done
	@a7="$$(sed -n 's/^A7://p' answers.txt | tr 'A-Z' 'a-z' | tr -d ' \t_-')"; \
	if [ -z "$$a7" ]; then echo "  (A7 is still blank -- the line the frame printed when it honoured your release order, copied whole. Task 3 step 4. Then make -C check m3 again.)"; exit 1; fi; \
	h=0; \
	for r in deruonoh deronoh; do \
	  if printf '%s' "$$a7" | grep -qF "$$(printf '%s' "$$r" | rev)"; then h=1; fi; \
	done; \
	if [ "$$h" -eq 0 ]; then echo "  (A7 does not carry the line the frame printed when it honoured the order. File the order and continue, as Task 3 step 4 shows, and copy the line that says the order was honoured -- the whole line, as printed. Then make -C check m3 again.)"; exit 1; fi; \
	if ! printf '%s' "$$a7" | grep -qF "$$(printf 'wornlik' | rev)"; then echo "  (A7 is an honour line, but not from the box the manual says to name -- the box in your A3. Run the model again and file the order naming that box. Then make -C check m3 again.)"; exit 1; fi
	@a8="$$(sed -n 's/^A8://p' answers.txt | tr 'A-Z' 'a-z' | sed 's/&/and/g' | tr -d ' \t_-')"; \
	if [ -z "$$a8" ]; then echo "  (A8 is still blank -- the ONE condition the release broke, by name. Task 3 step 5. Then make -C check m3 again.)"; exit 1; fi; \
	me=0; hw=0; np=0; cw=0; \
	if printf '%s' "$$a8" | grep -qF "$$(printf 'isulcxe' | rev)"; then me=1; fi; \
	for r in tiawdnadloh tiawdnasdloh tiawdnagnidloh tiawdloh tiawelihwdloh tiawelihwsdloh tiawelihwgnidloh; do \
	  if printf '%s' "$$a8" | grep -qF "$$(printf '%s' "$$r" | rev)"; then hw=1; fi; \
	done; \
	if printf '%s' "$$a8" | grep -qF "$$(printf 'tpmeerp' | rev)"; then np=1; fi; \
	for r in ralucric lcyc; do \
	  if printf '%s' "$$a8" | grep -qF "$$(printf '%s' "$$r" | rev)"; then cw=1; fi; \
	done; \
	if [ $$(($$me + $$hw + $$np + $$cw)) -gt 1 ]; then echo "  (A8 names more than one condition. The release broke ONE: put its name alone on the A8 line, and your reasons in the logbook. Then make -C check m3 again.)"; exit 1; fi; \
	if printf '%s' "$$a8" | grep -qE 'schedul|cpu|processor'; then echo "  (A8 is about the processor. Week 4's word for taking the CPU back is not this week's condition: the four conditions are about resources -- read the Careful note in Task 3 step 1. Put the condition's name alone on the A8 line, as step 1 gives it; any aside goes in your logbook. Then make -C check m3 again.)"; exit 1; fi; \
	if [ "$$cw" -eq 1 ]; then echo "  (A8 says circular wait. The cycle did break -- every way out of a deadlock ends with it broken -- but that is what the release led to, not what it did. Breaking circular wait means no ring can form at all, as last week's fork rule does; yours had formed, and stood. What the release changed was who held one lever. Which condition is about THAT? Then make -C check m3 again.)"; exit 1; fi; \
	if [ "$$hw" -eq 1 ]; then echo "  (A8 says hold and wait. That condition is broken by a rule every box follows all the time -- take everything at once, or hold nothing while asking -- and no rule changed here. One box was ordered, from outside the ring, to give up a lever it already held. Find that in Task 3's table. Then make -C check m3 again.)"; exit 1; fi; \
	if [ "$$me" -eq 1 ]; then echo "  (A8 says mutual exclusion. Nothing made a lever shareable: before and after the release, each lever had one holder at a time. Find what did change in Task 3's table. Then make -C check m3 again.)"; exit 1; fi; \
	if [ "$$np" -eq 0 ]; then echo "  (A8 names none of the four conditions. Put one of the four names from Task 3 step 1 on the line, as written there. Then make -C check m3 again.)"; exit 1; fi
	@$(SEAL) 3

.PHONY: m1 m2 m3
