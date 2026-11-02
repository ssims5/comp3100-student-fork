# Week 12 wax-seal checkpoints. Run from labs/week-12:  make -C check m1
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
#     Copy the pipeline exactly if you add a seal. (A comma is read as part
#     of a figure, so a major and minor written with a comma between them
#     read as one number; A1 has its own nudge for that.)
#
#  3. Any string in here that would give an answer away is written BACKWARDS
#     and un-reversed at check time with 'rev', so a glance at this file
#     spoils nothing: SIGPIPE's status, the loop's send count, the fittings'
#     letters and the hidden tube's name, the owner's uid, the growth per
#     capsule, the capsule count, the cities and the closing line. Paths on
#     the post and the copier's command name are not reversed: the work
#     order teaches every one of them openly.
#
#  4. A seal must never be satisfiable on a bench that never staged the
#     week. Every seal first requires the post's exchange line to exist, as
#     a FIFO, with a message routing to report-for-duty.sh. m3 also requires
#     THIS home's copier at work: a process of the post's owner named
#     tube-tee, alive in /proc, whose command line names a fitting under
#     this home's post/. Some other home's copier on a shared bench never
#     counts. Liveness is read from /proc, never with kill -0: you may not
#     signal another account's process, so the knock fails even when the
#     copier stands.
#
#  5. No seal needs root, and no seal changes anything. Nothing here sends a
#     capsule, writes to the post or signals the copier: m3 reads the
#     copier's command line (public) and the drop box (world-readable).
#
# Every DERIVED value is computed at check time from the student's own
# bench, never stored here: /dev/null's major and minor (stat), how many
# accounts have /usr/sbin/nologin as their shell (/etc/passwd, read the way
# the work order reads it), the copier (pgrep and /proc), the student's own
# TEST CAPSULE in the drop box (polled for about two seconds, because the
# copy lands just after the capsule is passed on), and the Board's count
# (an anchored grep of the drop box). The constants left are canon, written
# backwards below; the instructor-side bench check guards them against
# drift in report-for-duty.sh.
#
# Every answer is read with sed -n 's/^AN://p' so the check sees the VALUE
# only -- matching the whole line lets the digit in the label satisfy a
# [0-9] guard, and a blank answer seals the milestone.

LINE   := $$HOME/enginehouse/post/exchange-line
DROP   := $$HOME/enginehouse/post/.drop-box/outbound-copy.txt
TUBE   := $$HOME/enginehouse/tube-shop/tube
COPIER := tube-tee

SIGPIPE_R := 141
PIPEW_R   := epip
SENT_R    := 02
LETTERS_R := dppl
WRONGP_R  := dppp
NAME_R    := ebut-gninetsil
UID_R     := 9481
GREW_R    := 1
CAPS_R    := 21
CITIES_R  := 5
CITIESW_R := evif
CLOSE_R   := tnavrestnegilidruoy

# The order ls -lA lists the post's four fittings in. It is printed on the
# student's own screen and gives nothing away; A6 wants a different order.
LSORDER := dppl

SEAL := bash ../../lib/seal.sh 12

m1:
	@test -p "$(LINE)" || { echo "  (There is no post on this bench, so nothing has been staged to seal. From labs/week-12: bash report-for-duty.sh -- then make -C check m1 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-12: cp check/answers-template check/answers.txt, fill in A1 to A3, then make -C check m1 again.)"; exit 1; }
	@a1="$$(sed -n 's/^A1://p' answers.txt | tr 'A-Z' 'a-z')"; \
	if [ -z "$$(printf '%s' "$$a1" | tr -d '[:space:]')" ]; then echo "  (A1 is still blank -- the type letter of /dev/null, then its major and minor numbers. Task 1 step 4. Then make -C check m1 again.)"; exit 1; fi; \
	w=" $$(printf '%s' "$$a1" | grep -oE '[a-z]+' | tr '\n' ' ')"; \
	case "$$w" in *" b "*|*" block "*|*" brw "*) echo "  (A1 calls /dev/null a block device. Read the first character of its ls -l line again: b marks a block device, and /dev/null is not one. Task 1 step 4. Then make -C check m1 again.)"; exit 1 ;; esac; \
	case "$$w" in *" c "*|*" char "*|*" character "*|*" crw "*) : ;; *) echo "  (A1 does not carry the type letter of /dev/null -- the very first character of its ls -l line. Task 1 step 4. Then make -C check m1 again.)"; exit 1 ;; esac; \
	maj="$$(printf '%d' "0x$$(stat -c %t /dev/null)")"; min="$$(printf '%d' "0x$$(stat -c %T /dev/null)")"; \
	got="$$(sed -n 's/^A1://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | tr '\n' ' ')"; \
	if [ "$$got" = "$$maj $$min " ]; then exit 0; fi; \
	if [ "$$got" = "$$maj$$min " ]; then echo "  (A1 reads its major and minor as ONE number. A comma is read as part of a figure, so two numbers with a comma between them run together. Put a SPACE between the two, as the template says. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$got" = "$$min $$maj " ]; then echo "  (A1 has the two numbers the wrong way round. ls -l prints the major first, then the minor. Then make -C check m1 again.)"; exit 1; fi; \
	echo "  (A1's numbers are not the major and minor of /dev/null on this bench. Read them from its ls -l line, where a file's size would be, or from stat: two numbers, the major first. Task 1 step 4. Then make -C check m1 again.)"; exit 1
	@n="$$(sed -n 's/^A2://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 2 ]; then echo "  (A2 wants TWO numbers: the byte count of order.txt, then the byte count of both.txt, as wc -c printed them. Task 1 step 3. Then make -C check m1 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A2://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 1p)"; \
	y="$$(sed -n 's/^A2://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 2p)"; \
	if [ "$$x" -eq 0 ] && [ "$$y" -gt 0 ]; then exit 0; fi; \
	if [ "$$x" -gt 0 ] && [ "$$y" -eq 0 ]; then echo "  (A2 has the two counts the wrong way round. order.txt comes first -- the file from 2>&1 > order.txt -- then both.txt. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$x" -gt 0 ]; then echo "  (A2 says order.txt is not empty. With 2>&1 written BEFORE > order.txt, the error went to your screen and not to the file. Run that line again exactly as Task 1 step 3 shows, then wc -c. Then make -C check m1 again.)"; exit 1; fi; \
	echo "  (A2 says both.txt is empty. With > both.txt written BEFORE 2>&1, the error follows the output into the file. Run that line again exactly as Task 1 step 3 shows, then wc -c. Then make -C check m1 again.)"; exit 1
	@n="$$(sed -n 's/^A3://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 3 ]; then echo "  (A3 wants THREE numbers: the two PIPESTATUS figures for yes | head -1, in the order bash printed them, then how many accounts on this bench have /usr/sbin/nologin as their shell. Task 1 steps 5 and 6. Then make -C check m1 again.)"; exit 1; fi; \
	p1="$$(sed -n 's/^A3://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 1p)"; \
	p2="$$(sed -n 's/^A3://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 2p)"; \
	c="$$(sed -n 's/^A3://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 3p)"; \
	sig="$$(printf '%s' '$(SIGPIPE_R)' | rev)"; \
	want="$$(cut -d: -f7 /etc/passwd | grep -cx /usr/sbin/nologin)"; \
	if [ "$$p1" -eq 0 ] && [ "$$p2" -eq "$$sig" ]; then echo "  (A3 has the two PIPESTATUS figures the wrong way round. bash lists them in pipeline order: yes first, then head. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$p1" -ne "$$sig" ] || [ "$$p2" -ne 0 ]; then echo "  (A3's first two numbers are not the PIPESTATUS bash printed for yes | head -1. Run the line exactly as Task 1 step 6 shows and copy both figures, in order. Then make -C check m1 again.)"; exit 1; fi; \
	if [ "$$c" -ne "$$want" ]; then echo "  (A3's third number is not how many accounts on THIS bench have /usr/sbin/nologin as their shell. Read the count beside /usr/sbin/nologin in your own cut, sort, uniq -c pipeline, Task 1 step 5. It differs from bench to bench, so never copy a neighbour's. Then make -C check m1 again.)"; exit 1; fi
	@$(SEAL) 1

m2:
	@test -p "$(LINE)" || { echo "  (There is no post on this bench, so nothing has been staged to seal. From labs/week-12: bash report-for-duty.sh -- then make -C check m2 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-12: cp check/answers-template check/answers.txt, fill it in, then make -C check m2 again.)"; exit 1; }
	@test -p "$(TUBE)" || { echo "  (Your own tube, ~/enginehouse/tube-shop/tube, is not on this bench as a FIFO. Make it with mkfifo, Task 2 step 2 -- then make -C check m2 again.)"; exit 1; }
	@a4="$$(sed -n 's/^A4://p' answers.txt | tr 'A-Z' 'a-z')"; \
	if [ -z "$$(printf '%s' "$$a4" | tr -d '[:space:]')" ]; then echo "  (A4 is still blank -- your tube's type letter, then the word ls -l printed after the arrow for fd 0 inside a pipeline. Tasks 2 steps 1 and 2. Then make -C check m2 again.)"; exit 1; fi; \
	w=" $$(printf '%s' "$$a4" | grep -oE '[a-z]+' | tr '\n' ' ')"; \
	case "$$w" in *" p "*|*" prw "*) : ;; \
	  *" fifo "*) echo "  (A4 gives the word stat uses for your tube. It wants the type LETTER: the first character of the ls -l line for ~/enginehouse/tube-shop/tube. Then make -C check m2 again.)"; exit 1 ;; \
	  *) echo "  (A4 does not carry your tube's type letter -- the first character of its ls -l line. Task 2 step 2. Then make -C check m2 again.)"; exit 1 ;; \
	esac; \
	pw="$$(printf '%s' '$(PIPEW_R)' | rev)"; \
	case "$$w" in *" $$pw "*) exit 0 ;; esac; \
	case "$$w" in *" pts "*|*" dev "*|*" tty "*) echo "  (A4's second word names your terminal. That is where fd 0 points when nothing is piped in. Put echo x and a bar in front, exactly as Task 2 step 1 shows, and read the word after the arrow. Then make -C check m2 again.)"; exit 1 ;; esac; \
	echo "  (A4 does not carry the word ls -l printed after the arrow for fd 0 inside a pipeline -- the word before the colon and the brackets. Task 2 step 1. Then make -C check m2 again.)"; exit 1
	@n="$$(sed -n 's/^A5://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 2 ]; then echo "  (A5 wants TWO numbers: the two readers' counts from one run of the loop, a first, then b. Task 2 step 5. Then make -C check m2 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A5://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 1p)"; \
	y="$$(sed -n 's/^A5://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 2p)"; \
	sent="$$(printf '%s' '$(SENT_R)' | rev)"; \
	if [ "$$x" -eq 0 ] || [ "$$y" -eq 0 ]; then echo "  (A5 has one reader that heard nothing. Two readers, two shares: run the loop again -- the whole block, exactly as Task 2 step 5 shows -- and copy the two counts from a run where both readers heard something. Then make -C check m2 again.)"; exit 1; fi; \
	if [ "$$(($$x + $$y))" -ne "$$sent" ]; then echo "  (A5's two counts add up to $$(($$x + $$y)). Every capsule the loop sends reaches exactly one reader, so the two must add up to the number the loop sent. Copy both counts from the same run. Task 2 step 5. Then make -C check m2 again.)"; exit 1; fi
	@$(SEAL) 2

m3:
	@test -p "$(LINE)" || { echo "  (There is no post on this bench, so there is no line to walk. From labs/week-12: bash report-for-duty.sh -- then make -C check m3 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-12: cp check/answers-template check/answers.txt, fill it in, then make -C check m3 again.)"; exit 1; }
	@uid="$$(printf '%s' '$(UID_R)' | rev)"; mine=""; \
	for p in $$(pgrep -u "$$uid" -x $(COPIER) 2>/dev/null); do \
	  [ -d "/proc/$$p" ] || continue; \
	  if tr '\0' '\n' < "/proc/$$p/cmdline" 2>/dev/null | awk -v p="$$HOME/enginehouse/post/" 'index($$0, p) == 1 { f = 1 } END { exit !f }'; then mine="$$p"; fi; \
	done; \
	if [ -z "$$mine" ]; then echo "  (The post's copier is not at work on this bench. It is a living process, and it does not survive wsl --shutdown or a reboot. From labs/week-12: bash report-for-duty.sh stages the post afresh -- that also sweeps away any capsule you sent, so send yours again, Task 3 step 2 -- then make -C check m3 again.)"; exit 1; fi
	@c="TEST CAPSULE from $$USER"; i=0; hit=0; \
	while [ "$$i" -lt 20 ]; do \
	  if grep -qF -- "$$c" "$(DROP)" 2>/dev/null; then hit=1; break; fi; \
	  sleep 0.1; i=$$(($$i + 1)); \
	done; \
	if [ "$$hit" -eq 0 ]; then echo "  (The drop box holds no line reading $$c. Send one down outbound exactly as Task 3 step 2 shows -- the words, and \$$USER, as written -- and receive it at exchange-line. If you staged the post again since your last send, staging swept it away: send it again. Then make -C check m3 again.)"; exit 1; fi
	@a6="$$(sed -n 's/^A6://p' answers.txt | tr 'A-Z' 'a-z')"; \
	if [ -z "$$(printf '%s' "$$a6" | tr -d '[:space:]')" ]; then echo "  (A6 is still blank -- the four fittings' type letters in the order a capsule meets them, then the name of the hidden tube. Task 3 step 1. Then make -C check m3 again.)"; exit 1; fi; \
	nm="$$(printf '%s' '$(NAME_R)' | rev)"; \
	if ! printf '%s' "$$a6" | grep -qF -- "$$nm"; then echo "  (A6 does not carry the name of the hidden tube that outbound leads into, as readlink or ls -lan prints it. Task 3 step 1. Then make -C check m3 again.)"; exit 1; fi; \
	l="$$(printf '%s' "$$a6" | sed "s/[.]*$$nm//g" | tr -cd 'a-z')"; \
	if [ "$$l" = "$$(printf '%s' '$(LETTERS_R)' | rev)" ]; then exit 0; fi; \
	if [ "$$l" = "$$(printf '%s' '$(WRONGP_R)' | rev)" ]; then echo "  (A6 makes outbound a FIFO. Look again at the first letter of the outbound line in ls -lan -- and at the arrow after its name. Then make -C check m3 again.)"; exit 1; fi; \
	if [ "$$l" = "$(LSORDER)" ]; then echo "  (A6 lists the fittings in the order ls prints them. A6 wants the order a capsule meets them: outbound first, then the tube it leads into, then exchange-line, then the drop box. Then make -C check m3 again.)"; exit 1; fi; \
	echo "  (A6's letters are not the four fittings' type letters in the order a capsule meets them: outbound, the tube it leads into, exchange-line, the drop box. Four letters, the first character of each one's line in ls -lan. Task 3 step 1. Then make -C check m3 again.)"; exit 1
	@n="$$(sed -n 's/^A7://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A7 wants ONE number -- the uid that owns the post's other fittings, as ls -lan prints it -- and the copier's command name. Task 3 steps 1 and 3. Then make -C check m3 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A7://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	if [ "$$x" -ne "$$(printf '%s' '$(UID_R)' | rev)" ]; then \
	  if [ "$$x" -eq "$$(id -u)" ]; then echo "  (A7 carries your own uid. ls -lan shows two owners on the post: you, and one other. A7 wants the other. Then make -C check m3 again.)"; exit 1; fi; \
	  if [ "$$x" -eq "$$(stat -c %g "$(DROP)" 2>/dev/null || echo -1)" ]; then echo "  (A7 carries the GROUP of the drop box -- the second of the two numbers ls -lan prints. A7 wants the owner, the first. Then make -C check m3 again.)"; exit 1; fi; \
	  echo "  (A7's number is not the uid that owns the hidden tube, outbound and the drop box. Read the first number after the link count in ls -lan, Task 3 step 1. Then make -C check m3 again.)"; exit 1; \
	fi; \
	a7="$$(sed -n 's/^A7://p' answers.txt | tr 'A-Z' 'a-z')"; \
	if printf '%s' "$$a7" | grep -qF -- '$(COPIER)'; then exit 0; fi; \
	if printf '%s' "$$a7" | grep -q 'record'; then echo "  (A7 names Week 10's keeper, which also runs under that uid. A7 wants the process whose command line names the fittings of YOUR post. Task 3 step 3. Then make -C check m3 again.)"; exit 1; fi; \
	echo "  (A7 does not carry the copier's command name, as pgrep -l prints it. Task 3 step 3. Then make -C check m3 again.)"; exit 1
	@n="$$(sed -n 's/^A8://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 1 ]; then echo "  (A8 wants ONE number: how many lines the drop box grew by for the one capsule you sent. Task 3 step 2. Then make -C check m3 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A8://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | head -n 1)"; \
	if [ "$$x" -eq "$$(printf '%s' '$(GREW_R)' | rev)" ]; then exit 0; fi; \
	if [ "$$x" -eq 2 ]; then echo "  (A8 says 2. The capsule hissed twice -- once out at exchange-line, once into the drop box -- but the drop box itself took one copy. Compare wc -l before your send and after it. Then make -C check m3 again.)"; exit 1; fi; \
	if [ "$$x" -eq 0 ]; then echo "  (A8 says 0. The copy lands a moment after the capsule comes out at exchange-line. Run wc -l on the drop box again. Then make -C check m3 again.)"; exit 1; fi; \
	echo "  (A8 is not how many lines the drop box grew by for one one-line capsule. Run wc -l, send ONE capsule, run wc -l again, and subtract. Task 3 step 2. Then make -C check m3 again.)"; exit 1
	@$(SEAL) 3

m4:
	@test -p "$(LINE)" || { echo "  (There is no post on this bench, so there is no drop box to read. From labs/week-12: bash report-for-duty.sh -- then make -C check m4 again.)"; exit 1; }
	@test -f answers.txt || { echo "  (No answers.txt yet -- from labs/week-12: cp check/answers-template check/answers.txt, fill it in, then make -C check m4 again.)"; exit 1; }
	@test -r "$(DROP)" || { echo "  (The drop box on your post cannot be read. From labs/week-12: bash report-for-duty.sh stages the post afresh -- then make -C check m4 again.)"; exit 1; }
	@n="$$(sed -n 's/^A9://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | wc -l | tr -d ' ')"; \
	if [ "$$n" -ne 2 ]; then echo "  (A9 wants TWO numbers: how many capsules the drop box held when it was staged, then how many of those came FROM the Board. Task 4 steps 1 and 4. Then make -C check m4 again.)"; exit 1; fi; \
	x="$$(sed -n 's/^A9://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 1p)"; \
	y="$$(sed -n 's/^A9://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | sed -n 2p)"; \
	caps="$$(printf '%s' '$(CAPS_R)' | rev)"; \
	board="$$(grep -c '^CAPSULE .*FROM THE BOARD' "$(DROP)")"; \
	if [ "$$x" -eq "$$caps" ] && [ "$$y" -eq "$$board" ]; then exit 0; fi; \
	if [ "$$x" -eq "$$board" ] && [ "$$y" -eq "$$caps" ]; then echo "  (A9 has the two numbers the wrong way round: the capsule count first, then the Board's. Then make -C check m4 again.)"; exit 1; fi; \
	if [ "$$x" -ne "$$caps" ]; then \
	  if [ "$$x" -eq "$$(grep -c 'CAPSULE' "$(DROP)")" ]; then echo "  (A9's first number counts every line with CAPSULE anywhere in it -- your own test capsules among them. Anchor the count, so it reads only the lines that BEGIN with CAPSULE and a space, exactly as Task 4 step 1 shows. Then make -C check m4 again.)"; exit 1; fi; \
	  echo "  (A9's first number is not how many capsules the drop box held when it was staged. Count the header lines, anchored, Task 4 step 1. Then make -C check m4 again.)"; exit 1; \
	fi; \
	if [ "$$y" -eq "$$(grep -c '^CAPSULE .* TO THE BOARD' "$(DROP)")" ]; then echo "  (A9's second number counts the capsules sent TO the Board. A9 wants the ones FROM it: the sender is the office straight after FROM in each header. Then make -C check m4 again.)"; exit 1; fi; \
	echo "  (A9's second number is not how many capsules came FROM the Board. Count the headers whose sender is the Board, anchored, Task 4 step 4. Then make -C check m4 again.)"; exit 1
	@a10="$$(sed -n 's/^A10://p' answers.txt | tr 'A-Z' 'a-z')"; \
	if [ -z "$$(printf '%s' "$$a10" | tr -d '[:space:]')" ]; then echo "  (A10 is still blank -- how many cities the unsigned capsule addresses, and its closing line, exactly as written. Task 4 step 5. Then make -C check m4 again.)"; exit 1; fi; \
	if ! printf '%s' "$$a10" | tr -cd 'a-z' | grep -qF "$$(printf '%s' '$(CLOSE_R)' | rev)"; then echo "  (A10 does not carry the closing line of the unsigned capsule, exactly as written: its last line, word for word. Task 4 step 5. Then make -C check m4 again.)"; exit 1; fi; \
	nums="$$(sed -n 's/^A10://p' answers.txt | tr -d ',' | grep -oE '[0-9]+' | tr '\n' ' ')"; \
	if [ "$$nums" = "$$(printf '%s' '$(CITIES_R)' | rev) " ]; then exit 0; fi; \
	if [ -z "$$nums" ]; then \
	  case " $$(printf '%s' "$$a10" | grep -oE '[a-z]+' | tr '\n' ' ')" in *" $$(printf '%s' '$(CITIESW_R)' | rev) "*) exit 0 ;; esac; \
	  echo "  (A10 is missing how many cities the unsigned capsule addresses. Read its first line again, and put the number on the A10 line with the closing line. Then make -C check m4 again.)"; exit 1; \
	fi; \
	echo "  (A10's number is not how many cities the unsigned capsule addresses, or there is more than one number on the line. Read the capsule's first line again. Then make -C check m4 again.)"; exit 1
	@$(SEAL) 4

.PHONY: m1 m2 m3 m4
