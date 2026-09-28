# WORK ORDER No. 1851-07 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Dated** | Monday, 28 September 1851 — ten weeks to the Exhibition |
| **Due** | **Monday, October 5, 11:59 pm** — `logbook.md` + `case-notes.md` on Canvas (the semester's only Monday deadline) |

---

## Situation

On Saturday the Ring Line stopped.

Four districts sit on it — **Northgate, Waterside, Old Quarter and Kiln
Row** — and each has a signal box. Each box holds one lever on the ring,
its own **ring junction lever**, and to pass a train on round the ring a
box needs its own lever *and* the next box's. On Saturday every one of the
four took its own lever, reached for its neighbour's, and waited. Inside
one minute nothing on the Ring Line was moving.

Nothing collided. Not a buffer was scraped. Every box did exactly what its
rules say a box should do, the whole line stood perfectly still, and it
would be standing still yet if nobody had been sent to deal with it.

Last week you sat five philosophers at a table and watched them do the same
thing with forks, and I asked you to describe it without naming it. You may
name it now. It is called **deadlock**, and this week is about the four
things that have to be true at once for it to happen, how to see it inside
a program that has stopped, and how to get a program out of it.

The Guild has built a model of the four boxes on your bench. It re-enacts
Saturday, box by box, and then it stands, the way the Ring Line stood. It
will tell you what each box is holding. It will not tell you what any of
them is waiting for. For that you will have to look inside it while it
stands, with a debugger, which is a tool for doing exactly that.

The boxes kept a log of Saturday, and the signal-box manual has a page on
what to do about a ring that will not move. Read both before you touch the
model.

Report for duty. — *B.M.*

## Your objectives (the real ones, in plain English)

Week 6 gave you the tools that make threads wait for one another
properly. This week is about what happens when that waiting closes into a
circle: a set of threads, each holding something, each waiting for
something another one holds, all the way round. Nobody is at fault, nothing
is broken, and nothing will ever move again unless something from outside
the circle steps in. From outside, it looks exactly like a program doing
nothing at all — which is why the first skill this week is looking inside.

The fiction is set dressing and the commands are the course; **no task
here requires story knowledge.** By the time you hand this in you will be
able to:

1. **Name the four conditions for deadlock, and show each one holding in a
   live program.** Mutual exclusion, hold and wait, no preemption (of
   resources — not Week 4's processor kind; Task 3 explains), circular
   wait: all four at once, or no deadlock. You will point at each one on
   your own screen. *zyBooks Ch 5.*
2. **Map a cycle of held locks from a debugger's backtrace.** Stop a hung
   program under `gdb`, read every thread's stack, and write down who holds
   what and who waits for whom, all the way round. That drawing is a
   **wait-for graph**, and the cycle in it is the deadlock. *zyBooks Ch 5.*
3. **Explain why breaking any one of the four conditions prevents deadlock,
   and name which one a given remedy breaks.** Last week's
   lower-numbered-fork rule was one such remedy; you will see where it sits
   among the others. *zyBooks Ch 5.*
4. **Recover a deadlocked system by resource preemption, and say why the
   choice of victim matters.** You will release the standstill by the book,
   watch it clear, and say why the book names the box it names.
   *zyBooks Ch 5.*

Objective 2 is the one the Guild examines hardest. A deadlock found is a
deadlock half fixed; a deadlock guessed at is a week lost.

## Provisions

**P1 — Your working Linux environment.** Any bench that passed Week 1's
smoke test is ready. This week uses `cat`, `ls` and **`gdb`**, the GNU
debugger, which every setup path in this course installs. You write no C
this week and compile nothing yourself: the staging script builds the model
for you with the `gcc` you already have. Nothing this week needs `sudo` or
a network, and nothing needs a second terminal (one is handy once, in Task
3, and optional). If your environment broke over the weekend,
[`setup/getting-started.md`](../../setup/getting-started.md) rebuilds it.

**P2 — This folder, open in a Linux terminal.** Run the line that matches
your setup:

```sh
cd ~/comp3100-student/labs/week-07
```

Windows/WSL2 with the repo on the Windows side (Tab completes the path):

```sh
cd /mnt/c/Users/<YourWindowsName>/comp3100-student/labs/week-07
```

macOS/Multipass with your Mac's clone mounted into the VM:

```sh
cd ~/comp3100/labs/week-07
```

**P3 — Report for duty.** One command stages your bench:

```sh
bash report-for-duty.sh
```

It needs no input. It takes a few seconds, because it builds the model
first. Expected output:

```
  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-07 :: bench staged and verified
  ------------------------------------------------------------------
   Log:     ~/enginehouse/interlocking/acquisition.log
   Manual:  ~/enginehouse/manuals/signal-box-release-procedure.txt
   Model:   ~/enginehouse/ring-line/ring-frame   (built just now)
            ~/enginehouse/ring-line/signal-box.gdb

   Four boxes on the Ring Line took their holds one after another,
   and then not one of them would move. Nothing collided. Read the
   log and the manual page before you go near the model.

   The model is built from sealed drawings, on this bench, and the
   drawings were not left behind: the debugger is this week's
   instrument. It stands until you stop it, and Ctrl-C stops it.
   No house keys were wanted this week.
   (bash report-for-duty.sh --reset withdraws all of it.)
  ------------------------------------------------------------------
```

Four files land in three rooms under `~/enginehouse/`:

- `interlocking/acquisition.log` — the Ring Line's own log of Saturday;
- `manuals/signal-box-release-procedure.txt` — one page of the signal-box
  manual;
- `ring-line/ring-frame` — the model, compiled a moment ago on your bench
  with debugging information in it — and `ring-line/signal-box.gdb`, two
  settings for `gdb` that Task 2 explains.

The model's C source is **not** left on your bench, and that is on
purpose. This week you find out what a program is doing by looking at it
while it runs, not by reading its code, and `gdb` will remind you of that
more than once (it will say it cannot find `ring-frame.c`). If your Week 6
bench is still staged, its two files sit beside the log in
`interlocking/`; nothing this week touches them. The script leaves no
program running, and it is always safe to run it again: it rebuilds the
model and rewrites the two text files.

**P4 — Your paperwork.** Two copies, each made once:

```sh
cp ../templates/logbook-template.md logbook.md
cp check/answers-template check/answers.txt
```

`logbook.md` is this week's report. `check/answers.txt` holds eleven short
answers — A1 to A8, with A6 in four parts — that the seal checks read; the
template says what goes where, and each task tells you when. Your running
`case-notes.md` is already at the repo root.

**A note on this week's size.** This is a two-session week: Monday's
episode and **one** studio, on Wednesday. There is no Friday studio (fall
break), and nothing is due over the break: this order is due **Monday,
October 5**. Three tasks, three seals, about an hour and a half at the
terminal if nothing goes wrong — more than one studio. **Do Task 1 first,
and do it no later than Wednesday's studio** — it is twenty minutes of
reading and it is where the week starts. Task 1 and a good start on Task 2
fit in the studio; plan on finishing Tasks 2 and 3 at home before Monday.
Claim each seal as soon as its task is done.

> **If you're lost, start here (Provisions).** None of this is graded.
> Work the list; bring whatever is still stuck to studio.
> - Run `pwd`. It should end in `labs/week-07`. If not, re-run the `cd`
>   line from P2 that matches your setup.
> - `pwd` prints something like `C:\Users\...`? You're in PowerShell, not
>   Linux. Type `wsl`, press Enter, then re-run the `cd` line.
> - `$'\r': command not found`, or `set: -: invalid option`, or a
>   `syntax error near unexpected token`? The file picked up Windows line
>   endings on the way down. From the repo root: `git checkout -- .` and
>   try again.
> - `report-for-duty: gcc not found`? The model is compiled at your bench
>   and your bench has lost its compiler. Run the *"a tool is missing"* fix
>   in `setup/getting-started.md` (Troubleshooting), then run the script
>   again.
> - `report-for-duty: note -- gdb is not on this bench`? The bench staged,
>   but Tasks 2 and 3 need `gdb`. Same fix, same section, before Wednesday.
> - `report-for-duty: run this as YOURSELF, not as root.`? You typed
>   `sudo` in front of it. Nothing this week needs `sudo`; run it again
>   without it.
> - You ran `--reset` and want the bench back? Run
>   `bash report-for-duty.sh` again. It is idempotent.

---

## Task 1 — Saturday, as the frame recorded it *(~20 minutes → Seal M1)*

No debugger yet. This task is `cat` and `ls`, two files, and a pencil. It
goes first because everything after it stands on what these two files say.

**1. Read the log.**

```sh
cat ~/enginehouse/interlocking/acquisition.log
```

Expected — in full, and the same on every bench:

```
ACQUISITION LOG -- RING LINE INTERLOCKING
Brassbridge Enginehouse, Work Order No. 1851-07

  frame ............ the Ring Line: four signal boxes, one ring
  lever ............ each box holds its own ring junction lever
  day .............. Saturday, 26 September 1851

  Northgate ........ hold taken 1851-09-26 18:51:07
  Waterside ........ hold taken 1851-09-26 18:51:21
  Old Quarter ...... hold taken 1851-09-26 18:51:35
  Kiln Row ......... hold taken 1851-09-26 18:51:49

  The frame books a hold when it grants one. What a box is waiting
  for is not a hold, and is not booked here.
```

The frame writes down a **hold** at the moment it grants one: a box asked
for its lever, got it, and the frame logged it. Each hold line gives the
box, the date (year-month-day), and the time on a 24-hour clock as
hours:minutes:seconds. The last two digits are the seconds.

Read the last two lines of the file twice. The log books holds and nothing
else. What each box was **waiting for** after it took its hold is not in
here, and cannot be. That is Task 2's job.

**2. Ask the file for its date.**

```sh
ls -l ~/enginehouse/interlocking/acquisition.log
```

Expected — the owner and group will be your own name, not `you`, and on
some benches the permissions read `-rw-rw-r--`:

```
-rw-r--r-- 1 you you 590 Sep 26 18:51 /home/you/enginehouse/interlocking/acquisition.log
```

The staging script set the file's date to match what is written in it:
26 September of this year, at the minute of the last hold. A file's date
and a file's contents are two different things that can agree or disagree,
and a careful reader checks both.

**3. Write down the holds.** In your logbook, under **Milestone 1**:

- the four boxes, in the order they took their holds;
- the four hold times, exactly as the log gives them;
- the **seconds** of each hold — the last two digits of each time;
- the **gap**, in seconds, between each hold and the next.

Work the gap out yourself, from the log, by subtraction, and do it for every
pair — first to second, second to third, third to fourth — not just the
first one.

**4. Read the manual page.**

```sh
cat ~/enginehouse/manuals/signal-box-release-procedure.txt
```

Expected — in full:

```
THE HONOURABLE GUILD OF ENGINEWRIGHTS
Manual of Signal-Box Working -- Brassbridge Enginehouse

  entered: 1851-09-23

RELEASE OF A RING STANDSTILL

  When every box on a ring stands waiting upon its neighbour, each one
  holding the lever the next box wants, the ring is at a standstill. It
  will not clear itself: it will stand, quite correctly, until someone
  with the authority to do so tells one box to give way.

  1. No box shall be forced. A lever wrenched from a box's hand is how
     trains come to meet. The frame fails stopped, and stopped is safe.

  2. The duty enginewright files a release order naming ONE box, and
     one only: the box whose claim is youngest -- that is, the box that
     took its hold last. It has held its lever the shortest while, and
     so it has the smallest share of the ring's work to lose by standing
     back.

  3. The order bears the box's name as the acquisition log books it,
     and nothing more, and it is hung on the frame's order hook:

         ~/enginehouse/ring-line/release-order

  4. The box so named returns its lever to normal and waits its turn.
     The box that was waiting on that lever takes it and passes its
     train; then the box that was waiting on that one; and so round the
     ring. The named box goes last. Nothing is forced, and nothing
     collides.

  5. An order naming no box on the ring is taken down unheeded. File it
     again, correctly.
```

The wording is old-fashioned, but it is a step-by-step procedure, and you
will carry it out in Task 3. Don't do any of it yet.

**5. The rule, and the box it names.** Rule 2 does not give a box's name.
It gives a *description* — the box whose claim is youngest — and the same
sentence tells you what "youngest" means. Compare that with the four hold
times in the log from step 1 and find the one box it means.

In your logbook, write rule 2 in your own words, then the box it names,
then the reason rule 2 itself gives for choosing that box. Hold on to the
reason; it is Task 3's last question.

**6. Two dates.** The log carries its date at its head:

```
  day .............. Saturday, 26 September 1851
```

The manual page carries its own date at its head, too:

```
  entered: 1851-09-23
```

Write both in your logbook, one under the other, exactly as they are
printed. That is all this step asks.

(If you run `ls -l` on the manual page, its file date is just the moment
you ran the staging script, which rewrites the file every time. The page's
real date is the one printed on it.)

**Checkpoint.** Before you claim the seal you should be able to say,
without looking: which box took its hold first and which last, how many
seconds apart the holds were, which box the manual says to name, and why it
says that one. If the last of those is the one you cannot say, read the
second half of rule 2 again. It gives its reason in plain words.

**7. File what you read.** Open `check/answers.txt`:

- **`A1:`** — the **seconds** of the four holds: four numbers, with spaces
  between them.
- **`A2:`** — the gap between one hold and the next, in seconds. One
  number.
- **`A3:`** — the one box the manual says a release order should name,
  spelled as the log spells it.

**8. Claim the seal** — from `labs/week-07`:

```sh
make -C check m1
```

Expected:

```
make: Entering directory '.../labs/week-07/check'
  ~~~ WAX SEAL of the Guild: 5C0C06ED ~~~
  (Paste this seal into your logbook under Milestone 1.)
make: Leaving directory '.../labs/week-07/check'
```

(The seal code is yours, not this one.)

Paste your seal under **Milestone 1** with what steps 3, 5 and 6 asked you
to write down: the four holds in order, the gap, the rule in your own words
with the box it names and its reason, and the two dates.

> **If you're lost, start here (Task 1).**
> - `cat: /home/.../acquisition.log: No such file or directory`? Your
>   bench is not staged, or you reset it. From `labs/week-07`:
>   `bash report-for-duty.sh`.
> - `ls -l` prints `2026` where the time should be (`Sep 26  2026`)? Your
>   bench's clock thinks it is still earlier than Saturday 26 September.
>   `date` will show you. It does not matter for this week; the log's own
>   contents are what you are reading.
> - `ls ~/enginehouse/interlocking/` shows more than the log? Those are
>   Week 6's two files, still staged. Leave them exactly where they are.
> - Seal says A1 wants FOUR numbers? The seconds of all four holds go on
>   the one `A1:` line, **separated by spaces**. A comma counts as part of
>   a figure (so that `120,000` reads as one number, everywhere in this
>   course), which means `07,21` reads as one number too.
> - Seal says A1 carries only some of the four? Copy the last two digits of
>   every `hold taken` time — all four lines.
> - Seal says A2 wants ONE number? Put the gap alone on the line. Writing
>   `NN s` is fine; a time such as `0:NN` counts as two numbers.
> - Seal refuses your A2 figure? Redo the subtraction for each pair of
>   holds, one pair at a time.
> - Seal says A3 names no box, or more than one? A3 wants one of the four
>   names in the log, and only one. Case, spaces and hyphens do not matter.
> - Seal says A3 is not the box the rule picks? Read rule 2 against the log
>   once more: *youngest* is defined on the page.

---

## Task 2 — The frame under glass *(~40 minutes → Seal M2)*

The log told you who **holds** what. Nothing on your bench will tell you
who is **waiting** for what — not the log, not the model's own output. That
is normal: a hung program almost never explains itself. The facts are still
there, in the program's own memory, and the tool that can read a running
program's memory is a **debugger**. This course's debugger is `gdb`.

**Before you run anything, read this.** The model does not finish. That is
the point of it: it stands the way the Ring Line stood, for as long as you
let it. There are three ways out, and none of them damages anything:

- **Running on its own** (step 1): press **Ctrl-C**. You get your prompt
  back.
- **Running under gdb** (step 3 onward): **Ctrl-C** stops the program where
  it stands and gives you the `(gdb)` prompt. The program is frozen, not
  ended. To leave, type `kill` and answer `y`, then type `quit`. (Type
  `quit` with the program still loaded and gdb asks
  `Quit anyway? (y or n)` first; answer `y`, which comes to the same
  thing.)
- **A terminal that will not answer at all:** open a second terminal and
  type `pkill ring-frame`. A model running on its own ends. Under gdb, it
  hands you back the `(gdb)` prompt; then `kill` and `quit` as above.

**1. Run it plain.**

```sh
cd ~/enginehouse/ring-line
ls
./ring-frame
```

Expected — `ls` shows the model and its gdb file, and **no `.c` file**.
Then the model takes the four holds, in the log's order, a moment apart,
and stands:

```
ring-frame  signal-box.gdb
  Northgate    holds its ring junction lever.
  Waterside    holds its ring junction lever.
  Old Quarter  holds its ring junction lever.
  Kiln Row     holds its ring junction lever.
The frame stands. (Ctrl-C stops the model.)
```

Wait ten seconds. Nothing more will come, and nothing more ever would. Then
press **Ctrl-C**:

```
^C
```

and your prompt is back. Notice what the model told you: four holds, and
that it stands. It never said what any box is waiting for.

**2. Open it under gdb.** You are still in `~/enginehouse/ring-line`:

```sh
gdb -q -x signal-box.gdb ./ring-frame
```

(Coming back to this in a fresh terminal? The whole thing in one line is
`cd ~/enginehouse/ring-line && gdb -q -x signal-box.gdb ./ring-frame`.)

Expected:

```
Reading symbols from ./ring-frame...
(gdb)
```

`(gdb)` is gdb's prompt. Everything you type there is a gdb command, not a
shell command, until you `quit`. The model is loaded but **not running
yet**.

The two flags are worth knowing. `-q` skips gdb's opening banner.
`-x signal-box.gdb` runs the two commands in that file before anything
else:

- `set debuginfod enabled off` — without it, Ubuntu's gdb offers to fetch
  debugging information from the internet the moment you type `run`, and
  waits for your answer;
- `set pagination off` — without it, gdb stops long output after every
  screenful and waits for a key.

If you ever start gdb **without** `-x signal-box.gdb` and it asks
`Enable debuginfod for this session? (y or [n])`, press **Enter**. The
default, *n*, is the right answer.

**3. Run it, let it stand, and stop it.** At the `(gdb)` prompt, type
`run` and press Enter. When `The frame stands.` appears, press **Ctrl-C**.

Expected — every `0x…` below is an address and every `LWP …` a thread
number. Your screen shows real numbers in those places, different on every
run and every bench, and your own home folder on the second line. The
model's own lines will be exactly these:

```
(gdb) run
Starting program: /home/you/enginehouse/ring-line/ring-frame 
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
[New Thread 0x… (LWP …)]
  Northgate    holds its ring junction lever.
[New Thread 0x… (LWP …)]
  Waterside    holds its ring junction lever.
[New Thread 0x… (LWP …)]
  Old Quarter  holds its ring junction lever.
[New Thread 0x… (LWP …)]
  Kiln Row     holds its ring junction lever.
The frame stands. (Ctrl-C stops the model.)
^C
Thread … "ring-frame" received signal SIGINT, Interrupt.
0x… in __futex_abstimed_wait_common64 (private=128, cancel=true, abstime=0x0, op=265, expected=…, 
    futex_word=0x…) at ./nptl/futex-internal.c:57
warning: 57	./nptl/futex-internal.c: No such file or directory
(gdb)
```

Line by line:

- Each `[New Thread 0x… (LWP …)]` is gdb announcing a thread the moment
  the program starts it: one per box. **LWP** is the kernel's own number
  for that thread (a *light-weight process*); it is different on every run
  and every bench, which is why this work order writes it `…`.
- **Ctrl-C** froze the whole program — every thread at once, exactly where
  it stood — and gdb reports where the program's main thread (the one it
  names `ring-frame`, running `main`) was stopped: deep inside the C
  library, waiting for the four boxes to finish.
- The `warning: ... No such file or directory` is about the **C library's**
  own source code, which your bench does not carry. It is normal, harmless,
  and it has nothing to do with the model. (On a bench without the C
  library's debugging information, the stop line reads `?? () from` and a
  library path instead, and there is no warning. Also harmless.)

**4. List the threads.** Type `info threads`. Expected — gdb wraps these
long lines at the edge of your terminal, so yours may break in other
places:

```
(gdb) info threads
  Id   Target Id                                       Frame 
* …    Thread 0x… (LWP …) "ring-frame"  0x… in __futex_abstimed_wait_common64 (
    private=128, cancel=true, abstime=0x0, op=265, expected=…, futex_word=0x…)
    at ./nptl/futex-internal.c:57
  …    Thread 0x… (LWP …) "Northgate"   __futex_abstimed_wait_common (cancel=false, private=0, 
    abstime=0x…, clockid=0, expected=2, futex_word=0x… <lever_waterside>)
    at ./nptl/futex-internal.c:103
  …    Thread 0x… (LWP …) "Waterside"   __futex_abstimed_wait_common (cancel=false, private=0, 
    abstime=0x…, clockid=0, expected=2, futex_word=0x… <lever_oldquarter>)
    at ./nptl/futex-internal.c:103
  …    Thread 0x… (LWP …) "Old Quarter" __futex_abstimed_wait_common (cancel=false, private=0, 
    abstime=0x…, clockid=0, expected=2, futex_word=0x… <lever_kilnrow>)
    at ./nptl/futex-internal.c:103
  …    Thread 0x… (LWP …) "Kiln Row"    __futex_abstimed_wait_common (cancel=false, private=0, 
    abstime=0x…, clockid=0, expected=2, futex_word=0x… <lever_northgate>)
    at ./nptl/futex-internal.c:103
```

Five threads: the program's `main` and one per box. The model names each
thread after its box, and gdb prints the name in quotes. **Id** is gdb's own
number for the thread — only a label, written `…` here because it can come
out differently on your bench. The `*` marks the thread gdb is looking at
right now. The **Frame** column says where each thread is stopped: every box
is inside `__futex_abstimed_wait_common`, which is the C library asking the
kernel to put a thread to sleep until something changes, and the
`futex_word=... <lever_...>` at the end says which lever it is asleep on.

You can already read the waits off that column. The next command shows them
in a form you can reason with.

**5. Read every stack.** Type `thread apply all bt`. **`bt`** is a
**backtrace**: the chain of function calls a thread is in the middle of,
innermost first. `thread apply all` does it for every thread. Expected —
five blocks, one per thread; here are Kiln Row's and the main thread's,
which comes last, with the other three cut:

```
(gdb) thread apply all bt

Thread … (Thread 0x… (LWP …) "Kiln Row"):
#0  __futex_abstimed_wait_common (cancel=false, private=0, abstime=0x…, clockid=0, expected=2, futex_word=0x… <lever_northgate>) at ./nptl/futex-internal.c:103
#1  __GI___futex_abstimed_wait64 (futex_word=futex_word@entry=0x… <lever_northgate>, expected=expected@entry=2, clockid=clockid@entry=0, abstime=abstime@entry=0x…, private=private@entry=0) at ./nptl/futex-internal.c:128
#2  0x… in __futex_clocklock64 (private=<optimized out>, abstime=0x…, clockid=0, futex=0x… <lever_northgate>) at ../sysdeps/nptl/futex-internal.h:325
#3  __pthread_mutex_clocklock_common (mutex=0x… <lever_northgate>, clockid=0, abstime=0x…) at ./nptl/pthread_mutex_timedlock.c:88
#4  0x… in take_lever (district=0x… "Kiln Row", lever=0x… <lever_northgate>) at ring-frame.c:127
#5  0x… in signal_box (arg=0x… <ring+72>) at ring-frame.c:169
#6  0x… in start_thread (arg=<optimized out>) at ./nptl/pthread_create.c:447
#7  0x… in clone3 () at ../sysdeps/unix/sysv/linux/x86_64/clone3.S:78
...
Thread … (Thread 0x… (LWP …) "ring-frame"):
#0  0x… in __futex_abstimed_wait_common64 (private=128, cancel=true, abstime=0x0, op=265, expected=…, futex_word=0x…) at ./nptl/futex-internal.c:57
#1  __futex_abstimed_wait_common (cancel=true, private=128, abstime=0x0, clockid=0, expected=…, futex_word=0x…) at ./nptl/futex-internal.c:87
#2  __GI___futex_abstimed_wait_cancelable64 (futex_word=futex_word@entry=0x…, expected=…, clockid=clockid@entry=0, abstime=abstime@entry=0x0, private=private@entry=128) at ./nptl/futex-internal.c:139
#3  0x… in __pthread_clockjoin_ex (threadid=…, thread_return=0x0, clockid=0, abstime=0x0, block=<optimized out>) at ./nptl/pthread_join_common.c:102
#4  0x… in main () at ring-frame.c:216
```

The three blocks cut are shaped exactly like Kiln Row's, one for each of
the other boxes, and the order the four box blocks come out in follows
gdb's thread numbers, so yours may differ. The lines are long; your
terminal will fold them.

**How to read one.** Take Kiln Row's block **from the bottom up**, because
that is the order the calls were made in:

- `#7 clone3` and `#6 start_thread` — the thread being born. Every thread
  starts like this.
- `#5 signal_box (...) at ring-frame.c:169` — the box's own function: what
  every signal box does, at line 169 of the model's source.
- `#4 take_lever (district=... "Kiln Row", lever=... <lever_northgate>) at ring-frame.c:127`
  — **this is the line that matters.** The box called a function to take a
  lever, and gdb shows you both arguments: the box doing the asking,
  *Kiln Row*, and the lever it asked for, **`lever_northgate`**. It is
  stopped at line 127 of the model, inside that call.
- `#3` down to `#0` — the C library doing the waiting on the model's
  behalf, down to the kernel's sleep.

So one frame in each box's stack says, in plain words, which box is waiting
and which lever it is waiting for. The main thread, at the bottom, is simply
waiting for the four boxes to finish, which they never will.

**6. The four waits.** You could scroll back through all five blocks. Or
you can let gdb pick out the four lines for you:

```
(gdb) pipe thread apply all bt | grep take_lever
#4  0x… in take_lever (district=0x… "Kiln Row", lever=0x… <lever_northgate>) at ring-frame.c:127
#4  0x… in take_lever (district=0x… "Old Quarter", lever=0x… <lever_kilnrow>) at ring-frame.c:127
#4  0x… in take_lever (district=0x… "Waterside", lever=0x… <lever_oldquarter>) at ring-frame.c:127
#4  0x… in take_lever (district=0x… "Northgate", lever=0x… <lever_waterside>) at ring-frame.c:127
```

`pipe` runs a gdb command and sends what it prints through a shell command
— here `grep`, which keeps only the lines that mention `take_lever`. Four
lines, one per box: **who is waiting** (`district=`) and **for which lever**
(`lever=`). Write all four in your logbook.

Look at the end of each line. All four boxes are stopped at the **same line
of the model**: the line where a box asks for its neighbour's lever. Write
that number down too.

**Checkpoint.** You should now be able to put a finger on one line per box
and say, in plain words, which box it is and which lever it is waiting for.
If a `take_lever` line still reads as noise, go back to step 5 and read
Kiln Row's block from the bottom up once more.

**What varies, and what does not.** Wherever this work order's expected
output shows `0x…`, `LWP …`, a thread number written `…` or `N`, or any
other `…` inside a gdb line, your screen shows a real number instead: an
address, the kernel's number for a thread, gdb's own label for a thread, a
process number, a clock reading. Every one of them changes from run to run
and bench to bench, and so does the order the threads are listed in. The
**frame numbers** after the `#` can change too: on a bench without the C
library's debugging information, the C library's frames shrink to `?? ()`
lines, and `take_lever` comes out nearer the top. What does **not** change
is what you are reading: the box names, the lever names, the function
names, and the line numbers after `ring-frame.c:`.

**7. What each box holds.** The model keeps the lever a box holds in a
variable called **`holding`**, inside that box's `signal_box` function. To
read it you switch to the box's thread, select its `signal_box` frame, and
print the variable. Here it is for Kiln Row:

```
(gdb) thread find Kiln Row
Thread N has target name 'Kiln Row'
(gdb) thread N
[Switching to thread N (Thread 0x… (LWP …))]
#0  __futex_abstimed_wait_common (cancel=false, private=0, abstime=0x…, clockid=0, expected=2, 
    futex_word=0x… <lever_northgate>) at ./nptl/futex-internal.c:103
103	in ./nptl/futex-internal.c
(gdb) frame function signal_box
#5  0x… in signal_box (arg=0x… <ring+72>) at ring-frame.c:169
warning: 169	ring-frame.c: No such file or directory
(gdb) print holding
$1 = (pthread_mutex_t *) 0x… <lever_kilnrow>
(gdb) list
164	in ring-frame.c
```

- `thread find Kiln Row` searches the thread names and tells you gdb's
  number for that box, written `N` here. **Type the number your own bench
  prints** in place of `N` in the next command.
- `thread N`, with your number, switches gdb to that thread. It lands on
  the innermost frame, in the C library.
- `frame function signal_box` selects the frame belonging to the function
  `signal_box` — by **name**, not by number, because the numbers vary and
  the names do not.
- The `warning: 169 ring-frame.c: No such file or directory` is
  **expected**. gdb knows the file name and line number from the debugging
  information built into the model, and would show you the source line if
  the file were there. It is not: the staging script deleted the source
  after building the model. `list`, which prints source lines, can only
  print the line number.
- `print holding` answers the question: Kiln Row holds **`lever_kilnrow`**,
  its own lever. (`$1` is just gdb numbering the values it prints.)

Now do the same for the other three boxes: `thread find`, `thread`, `frame
function signal_box`, `print holding`. Or read all four at once:
`thread apply all bt full` prints every frame's local variables as well,
and in each box's `signal_box` frame you will find the `holding` line. For
Kiln Row, the two frames that matter read:

```
#4  0x… in take_lever (district=0x… "Kiln Row", lever=0x… <lever_northgate>) at ring-frame.c:127
        until = {tv_sec = …, tv_nsec = …}
#5  0x… in signal_box (arg=0x… <ring+72>) at ring-frame.c:169
        d = 0x… <ring+72>
        holding = 0x… <lever_kilnrow>
```

(`until` is a clock reading, written `…` here because it differs on every
run; Task 3 says what it is for.)

**8. Draw the wait-for graph.** On paper, now. Four boxes round a circle,
one per district. For each box, draw **one arrow**, from that box to the
box that **holds** the lever it is **waiting for**. You have the first one
already: Kiln Row waits for `lever_northgate`, and `lever_northgate` is
Northgate's, held by Northgate — so the arrow runs **Kiln Row → Northgate**.
Draw the other three from your own four `take_lever` lines and your own four
`holding` values.

What you have drawn is a **wait-for graph**: one node per thread, one arrow
for each "is waiting for". When every resource has exactly one holder at a
time — a lever, a mutex — the rule is simple: **a cycle in the wait-for
graph means deadlock, and no cycle means none.** Follow your arrows from any
box. You will come back to the box you started from.

That closed ring is a **deadlock**: a set of threads, each waiting for
something that only another member of the set can release. It is exactly
the shape of last week's long table, with levers for forks. Nobody in it is
wrong. Nothing in it can move.

**9. Leave cleanly, and go back.** Type `kill`, answer `y`, then type
`quit`:

```
(gdb) kill
Kill the program being debugged? (y or n) y
[Inferior 1 (process …) killed]
(gdb) quit
```

You are back at the shell, still in `~/enginehouse/ring-line`. The seals
are claimed from your work-order folder, so go back there now with the `cd`
line from P2 that matches your setup — for most of you,
`cd ~/comp3100-student/labs/week-07`.

**Checkpoint.** Before you claim the seal you should be able to say,
without looking at your notes: which lever each box holds, which lever each
box is waiting for, which box holds *that* lever, and why the four arrows
make a ring rather than a line. If you cannot say which way an arrow points,
go back to step 8's first arrow and say it out loud: *Kiln Row is waiting
for the lever Northgate holds.*

**10. File what you found.** In `check/answers.txt`:

- **`A4:`** — the ring, as a chain of waits that goes all the way round and
  back to where it started: *X waits for Y, Y waits for Z, Z waits for W,
  W waits for X*. Any box may come first; the direction is what matters.
- **`A5:`** — the line number gdb gives in every `take_lever` frame, after
  `ring-frame.c:`. One number.

**11. Claim the seal** — from `labs/week-07`:

```sh
make -C check m2
```

Expected:

```
make: Entering directory '.../labs/week-07/check'
  ~~~ WAX SEAL of the Guild: DBF7E7DA ~~~
  (Paste this seal into your logbook under Milestone 2.)
make: Leaving directory '.../labs/week-07/check'
```

(The seal code is yours, not this one.)

Paste it under **Milestone 2** with a real paragraph — this is the week's
centrepiece. Write out the wait-for graph in words: for each of the four
boxes, the lever it holds, the lever it waits for and the box holding that
lever, with the gdb line that showed you each. Then one sentence saying why
the ring cannot break itself.

> **If you're lost, start here (Task 2).**
> - gdb starts and says `./ring-frame: No such file or directory.` and
>   `signal-box.gdb: No such file or directory.`? You launched it from the
>   wrong folder. `quit`, then
>   `cd ~/enginehouse/ring-line && gdb -q -x signal-box.gdb ./ring-frame`.
> - gdb asks `Enable debuginfod for this session? (y or [n])`? You left out
>   `-x signal-box.gdb`. Press **Enter** (the default, *n*) and carry on.
> - Output stops with `--Type <RET> for more, q to quit, c to continue
>   without paging--`? Same cause. Type `c` and press **Enter** to see the
>   rest.
> - `run` printed the four holds and the prompt never came back? It is not
>   meant to: the model is standing. Press **Ctrl-C** — that is step 3.
> - `warning: ... ring-frame.c: No such file or directory`, or `list`
>   prints `164 in ring-frame.c` and no code? **Expected.** The model's
>   source is not on your bench, by design. Everything this week reads
>   comes from the running program.
> - A command says `The program is not being run.`, `info threads` says
>   `No threads.`, `frame function` says `No registers.`, or
>   `thread apply all bt` prints nothing at all? The model is not running:
>   you killed it, never typed `run`, or (in Task 3) the ring cleared. Type
>   `run`, wait for `The frame stands.`, and press **Ctrl-C**. (Printing a
>   lever before `run` shows all zeros, `__owner = 0`: the lever as the
>   program starts, before any box has taken it. Run first, then read.)
> - `No threads match 'kiln row'`? `thread find` minds its capitals. Type
>   the name exactly as the log spells it: `thread find Kiln Row`. (The
>   seals and the release order forgive case; gdb does not.)
> - `thread` with a number copied from somebody else's screen landed on the
>   wrong box? gdb's thread numbers are labels and vary between benches. Use
>   the number `thread find` printed on yours.
> - `No symbol "holding" in current context.`? You are still in the
>   thread's innermost frame, down in the C library, where `holding` does
>   not exist. Type `frame function signal_box` first, then
>   `print holding`.
> - One `take_lever` line ends at a different line number from the other
>   three? Rare, and harmless: that box happened to be looking at its order
>   hook (Task 3 explains) at the instant you pressed Ctrl-C. Type
>   `continue`, press Ctrl-C again, and read again; the four agree.
> - The terminal will not answer at all? A second terminal and
>   `pkill ring-frame`; under gdb that returns the `(gdb)` prompt, then
>   `kill` and `quit`.
> - `make: *** check: No such file or directory.  Stop.`? You are not in
>   `labs/week-07` — most likely you are still in `~/enginehouse/ring-line`.
>   Run the `cd` line from P2 that matches your setup, then claim the seal
>   again.
> - Seal says A4, read as *X waits for Y*, goes round the ring the wrong
>   way? Each arrow runs from the box that is **waiting** to the box that
>   **holds** what it waits for. A box waits for the lever in its *own*
>   `take_lever` frame. Write every link with the waiting box first.
> - Seal says A4 names only some of the boxes, or gives only some of the
>   waits? All four boxes are in the ring, each spelled as the log spells
>   it, and every box's wait is a link in the chain, which comes back to
>   the box it started from.
> - Seal says A4 never says who waits for whom? Put `waits for` (or an
>   arrow, `->`) between the two boxes of every link.
> - Seal says A4 does not read as one ring of waits? Write it in exactly
>   the template's shape, *X waits for Y, Y waits for Z, ...*, one link after
>   another, with nothing else on the line.
> - Seal says A5 wants ONE number? Put the number after `ring-frame.c:`
>   on the line, and no other number.
> - Seal says A5 does not carry the line? It wants the number after
>   `ring-frame.c:` in a `take_lever` frame — not the frame number after
>   the `#`, not gdb's thread number, not an LWP.

---

## Task 3 — Four conditions, and a release by the book *(~35 minutes → Seal M3)*

You have found a deadlock and drawn it. Now you will say exactly what makes
it one, and then get the Ring Line out of it the way the manual says to.

**1. The four conditions.** A deadlock needs four things to be true **at
the same time**. They are usually listed in this order, and in the model you
stopped in Task 2 all four were true at once:

1. **Mutual exclusion.** A resource can be held by only one thread at a
   time. A lever is in one box's hand or in nobody's.
2. **Hold and wait.** A thread holds at least one resource while it waits
   for another. Every box holds its own lever while it waits for the next.
3. **No preemption** — in full, **no resource preemption**. A resource
   cannot be taken away from the thread that holds it; only the holder can
   let it go. *Careful:* in Week 4, *preemption* meant the scheduler taking
   the **processor** back from a job in the middle of its run. This is a
   different thing under the same word. Here it is about **resources** — the
   locks, the levers — and whether anything can take one back from its
   holder. Whenever this course says *preemption* in the deadlock sense, it
   means **resource preemption**.
4. **Circular wait.** There is a closed chain of threads, each waiting for
   a resource held by the next one: the cycle in your wait-for graph.

Take away **any one** of the four and a deadlock cannot form. If a
resource could be shared, nobody would wait for it. If nobody held one
thing while asking for another, nobody would be holding what the next
thread needs. If a lever could be taken back, the ring could be broken from
outside. If the waits never closed into a circle, somebody at the end of
the chain would always be able to finish, and then the next. That is the
whole theory of fixing deadlock, and it is why the list is worth knowing in
order.

**2. Back into gdb.** Start the model under gdb again, exactly as in
Task 2 steps 2 and 3:

```sh
cd ~/enginehouse/ring-line && gdb -q -x signal-box.gdb ./ring-frame
```

then `run`, wait for `The frame stands.`, and press **Ctrl-C**.

**3. The evidence, one condition at a time.** For each condition, find
something on **your own screen** that shows the condition is true. Write
one line for each in your logbook: the condition, the command you typed,
and what it showed.

**(a) Mutual exclusion — ask a lever who holds it.** A lever in this model
is a `pthread_mutex_t`, and a mutex keeps its own record of its owner. Print
one, then list the threads:

```
(gdb) print lever_waterside
$1 = {__data = {__lock = 2, __count = 0, __owner = …, __nusers = 1, __kind = 0, __spins = 0, __elision = 0, 
    __list = {__prev = 0x0, __next = 0x0}}, 
  __size = "…", __align = 2}
(gdb) info threads
  Id   Target Id                                       Frame 
...
  …    Thread 0x… (LWP …) "Waterside"   __futex_abstimed_wait_common (cancel=false, private=0, 
...
```

(Above, the `info threads` output is cut to the one line that matters;
yours lists all five threads, as in Task 2. The `__size` field repeats the
same record as raw bytes and is shortened to `"…"` here.) Most of that
structure is the C library's private bookkeeping. Read one field:
**`__owner`**, the LWP of the one thread that holds the lock. Find that LWP
in `info threads`: it is Waterside's. One lever, one owner, and
`__lock = 2` means it is locked and somebody is waiting for it. On your
screen `__owner` and Waterside's `LWP` show the same real number (written
`…` here because it is different on every run). The number changes from
run to run; the match does not.

**(b) Hold and wait — one thread, both at once.** You have this from Task 2
step 7: Kiln Row's `holding` is `lever_kilnrow`, and in the same thread its
`take_lever` frame is asking for `lever_northgate`. It holds one lever
while it waits for another. So does every box.

**(c) No resource preemption — nothing takes a lever back.** Let the model
run on for ten seconds, stop it again, and look at the waits:

```
(gdb) continue
Continuing.
^C
Thread … "ring-frame" received signal SIGINT, Interrupt.
0x… in __futex_abstimed_wait_common64 (private=128, cancel=true, abstime=0x0, op=265, expected=…, 
    futex_word=0x…) at ./nptl/futex-internal.c:57
57	in ./nptl/futex-internal.c
(gdb) pipe thread apply all bt | grep take_lever
#4  0x… in take_lever (district=0x… "Kiln Row", lever=0x… <lever_northgate>) at ring-frame.c:127
#4  0x… in take_lever (district=0x… "Old Quarter", lever=0x… <lever_kilnrow>) at ring-frame.c:127
#4  0x… in take_lever (district=0x… "Waterside", lever=0x… <lever_oldquarter>) at ring-frame.c:127
#4  0x… in take_lever (district=0x… "Northgate", lever=0x… <lever_waterside>) at ring-frame.c:127
```

The same four waits, ten seconds later. Nothing has taken a lever from any
box, and nothing in the program ever will: in this program only the box
that holds a lever can let it go, and every holder is waiting. (Whether a
lock *could* be forced away from outside is a different question; *For the
curious* tries it.)

One detail you may have noticed: each box's wait is a **timed** one. Look
once more at Kiln Row's block in Task 2 step 5, at the C library frame just
above `take_lever`: `__pthread_mutex_clocklock_common`, in the file
`pthread_mutex_timedlock.c`. (On a bench without the C library's debugging
information, the frames above `take_lever` are bare `?? ()` lines; take
this one on trust.) A box waits for at most one second. When the second is
up, it checks the order hook from the manual (the `release-order` file),
finds nothing there, and waits again — **still holding its own lever the
whole time**. (The `until` variable in `bt full` was the time of the next
check.) Checking the hook does not let go of anything, so this is still
no resource preemption.

**(d) Circular wait — the ring.**
`pipe thread apply all bt | grep take_lever` gives the four waits, and
followed box to box they close into the ring you drew in Task 2 step 8 and
wrote as A4. Say that, with the command, as this condition's evidence.

**Checkpoint.** Four lines in your logbook, one per condition, and every
one of them names a command you typed and what it printed. A line that only
defines the condition is not evidence yet.

**4. The release, by the book.** The manual told you what to do: file a
release order naming **one** box — the youngest claim, the box that took
its hold last — on the frame's order hook,
`~/enginehouse/ring-line/release-order`. From the log, the youngest claim is
**Kiln Row**.

You can file the order without leaving gdb: **`shell`** runs one shell
command from the `(gdb)` prompt. File it, then let the model carry on:

```
(gdb) shell echo Kiln Row > ~/enginehouse/ring-line/release-order
(gdb) continue
Continuing.
  Kiln Row     release order honoured. Lever back to normal; waiting its turn.
  Old Quarter  both levers in hand. Train passed.
  Waterside    both levers in hand. Train passed.
  Northgate    both levers in hand. Train passed.
[Thread 0x… (LWP …) exited]
[Thread 0x… (LWP …) exited]
[Thread 0x… (LWP …) exited]
  Kiln Row     both levers in hand. Train passed.
Ring clear. All four boxes have moved.
[Thread 0x… (LWP …) exited]
[Inferior 1 (process …) exited normally]
(gdb) shell ls ~/enginehouse/ring-line
ring-frame  signal-box.gdb
(gdb) quit
```

Within about a second of `continue`, Kiln Row looks at the hook, finds its
own name, and **honours** the order: it returns its own lever and stands
back. Now follow the ring, exactly as rule 4 of the manual said it would go:

- **Old Quarter** was waiting for `lever_kilnrow`. It takes it, has both
  levers, passes its train, and lets both go.
- That frees `lever_oldquarter`, which **Waterside** was waiting for. Then
  `lever_waterside` for **Northgate**. Then `lever_northgate` for **Kiln
  Row**, last, as the manual promised.
- `Ring clear.` and `exited normally` — the program finished on its own,
  with exit status 0. `shell ls` shows the order has been taken down off the
  hook: an order is used once.

The `[Thread ... exited]` lines are gdb's, not the model's, and where they
fall among the model's lines varies from run to run. The model's own lines
come in the same order every time. `quit` asks no question now, because
nothing is running.

**Rather use a second terminal?** Start the model on its own in the first
(`cd ~/enginehouse/ring-line && ./ring-frame`), wait for it to stand, and
file the order from the second:

```sh
echo Kiln Row > ~/enginehouse/ring-line/release-order
```

The first terminal then shows the same model lines as above, without gdb's
notices, and the prompt comes back by itself.

An order that names no box on the ring is taken down with one line, exactly
as rule 5 says — here, an order that read *the youngest*:

```
  Release order ignored and taken down: no box is called "the youngest".
```

The model is still standing after that, so file it again, correctly.

**5. Which condition did the release break?** Here is every common remedy
for deadlock, and the one condition each one breaks. This is the course's
table; the deck, this work order and the examination all use it:

| Remedy | Condition it breaks |
|---|---|
| Everybody takes locks in one fixed global order (Week 6) | **circular wait** |
| Ask for everything at once, or hold nothing while asking | **hold and wait** |
| If you cannot get the next lock, give back what you hold (trylock and back off) | **no preemption** (voluntary) |
| An outside authority takes a lock back from its holder: kill a thread, or force a release | **no preemption** (by authority). This is deadlock *recovery*. |
| Make the resource shareable | **mutual exclusion**. It is rarely possible for a lock, and that is why it is the condition nobody breaks. |

The third row can look like a contradiction. Condition 3 says only the
holder can let a resource go, and in the third row it is the holder that
lets go. Read condition 3 as a promise about **keeping**: a holder keeps
what it holds until it has finished with it, and nothing makes it let go
early. Trylock and back off breaks that promise from the inside: by its own
rule, a thread that cannot get its next lock gives up one it still needs,
before its work is done. Nothing outside took it, which is why the table
calls it *voluntary*.

The fourth row's *by authority* is worth a second look. The release came
from outside the ring, once, after the ring had formed. The named box let
go of its lever itself, so nothing was forced out of anybody's hand, just
as rule 1 of the manual demands. That is also what separates it from the
third row, where every box gives way by its own rule whenever it cannot get
its next lock: here one box gave way because it was told to. (*For the
curious* shows the forced kind, and why rule 1 forbids it.)

**The first row is last week's.** You broke the philosophers' ring with one
rule — everybody takes the lower-numbered fork first — before you had the
words for what it did. You have them now: that rule breaks **circular
wait**. If every thread takes its locks in one fixed global order, no chain
of waits can close back on itself, so the other three conditions can all
hold and the program still cannot deadlock. It costs almost nothing, and
it is the first thing a working engineer reaches for.

Every row but one is **prevention**: a rule, followed all the time, that
stops the standstill from ever forming. Row 4 is different in kind: your
release order forced a release. Your ring had already formed, and it
would have stood for ever; something from outside the ring stepped in and
made one box give back what it held. That is **recovery**, and it is one
of four broad things an operating system can do about deadlock:

- **prevent** it — break one of the four conditions by design, as the
  table's prevention rows do;
- **avoid** it — look at each request before granting it, and refuse any
  grant that could lead to a cycle (the *banker's algorithm* is the famous
  version: know its name; this course does not teach its arithmetic);
- **detect and recover** — find the cycle, as you did with gdb, pick a
  victim, and take something back;
- **ignore** it — which is what most general-purpose operating systems do
  about locks inside your program: lock order is left to the programmer,
  and things that stop are caught by timeouts and watchdogs.

Now find what **you** just did in the table, and write in your logbook
which condition it broke and why it is not the first row.

**6. Why the youngest claim?** Any box would have done: return any one
lever and the ring breaks. So why does the manual name the youngest?

Because recovery always costs somebody something, and the cost falls on the
**victim** — the one chosen to give way. Here the victim only loses its
place and waits its turn. In a real system the victim of deadlock recovery
is a thread, a process or a database transaction that is rolled back, or
killed and restarted, and everything it did since it took its lock is work
thrown away. The youngest claim has held its lever the shortest while, so
it has the least to throw away: exactly the reason rule 2 gives. **Choose
the victim that loses least** is the usual rule. The other thing a real
system has to watch is that it does not choose the same victim every time.
A thread that is always the one sent to the back never finishes — and you
met that last week, under its own name: **starvation**.

**Checkpoint.** You should be able to say, without looking: the four
conditions, in order; where on your own screen each one showed; what the
release order changed; which condition that broke, and why it was not
circular wait; and why the manual names the box it names.

**7. File it.** In `check/answers.txt`:

- **`A6a:`** to **`A6d:`** — the four conditions, **one to a line**. Each
  line starts with the condition's name and carries its evidence from step
  3 on the same line: the command, and what it showed.
- **`A7:`** — the line the frame printed when it honoured your order.
  Copy it whole.
- **`A8:`** — the **one** condition the release broke, by its name from
  step 1, alone on the line. The *why* goes in your logbook, not here.

**8. Claim the seal** — from `labs/week-07`. If you are still in
`~/enginehouse/ring-line`, go back first with the `cd` line from P2, as in
Task 2 step 9. Then:

```sh
make -C check m3
```

Expected:

```
make: Entering directory '.../labs/week-07/check'
  ~~~ WAX SEAL of the Guild: BA7A02B5 ~~~
  (Paste this seal into your logbook under Milestone 3.)
make: Leaving directory '.../labs/week-07/check'
```

(The seal code is yours, not this one.)

Paste it under **Milestone 3** with the four conditions and your evidence
for each, what the release printed, which condition it broke and why it
was not circular wait, and — in two sentences of your own — why the manual
names the box it names.

> **If you're lost, start here (Task 3).**
> - You filed the order and `continue` shows nothing new? Check what is on
>   the hook: `shell cat ~/enginehouse/ring-line/release-order`. If that
>   says `No such file or directory`, the order never reached the hook (see
>   the next item), or it has already been taken down — read the model's
>   last line.
> - gdb printed your order straight back at you —
>   `Kiln Row > ~/enginehouse/ring-line/release-order` with `(gdb)` stuck
>   on the end of the line — and nothing else happened? You left off
>   `shell`. At the `(gdb)` prompt the line must start with `shell`;
>   without it, gdb's own `echo` command prints the text and files nothing.
>   Type it again with `shell` in front. (The second-terminal version has
>   no `shell` because it is typed at an ordinary shell prompt.)
> - `Release order ignored and taken down: no box is called "..."`? The
>   name did not match a box. File it again, spelled as the log spells it.
>   Case, spaces and hyphens are forgiven; other letters are not.
> - At start-up the model says `A release order was on the hook before the
>   model started. Taken down,` / `unheeded: hang it again once the frame
>   stands.`? You filed the order before starting the model. An order counts
>   only while the frame stands: run it, wait for `The frame stands.`, then
>   file.
> - `No symbol "lever_watersid" in current context.`? A spelling slip. The
>   four levers are `lever_northgate`, `lever_waterside`,
>   `lever_oldquarter` and `lever_kilnrow`.
> - `continue` says `The program is not being run.`? The model has already
>   finished — the ring cleared, or you killed it. `run` to start again.
> - The ring cleared in a different order, and the honour line names a
>   different box? You named a different box. That clears the ring too (see
>   *For the curious*), but the manual names one box, and A7 wants the line
>   that box prints. Run it again and name that one.
> - `make: *** check: No such file or directory.  Stop.`? You are not in
>   `labs/week-07`. Run the `cd` line from P2 that matches your setup, then
>   claim the seal again.
> - Seal says one of `A6a` to `A6d` is blank, or too short? Each line wants
>   a condition **and** its evidence, both on that one line: the name, then
>   the command, then what it printed.
> - Seal says an A6 line does not start with one of the four conditions?
>   Put the condition's name first, exactly as step 1 gives it, with
>   nothing in front of it but a list mark if you like (`3.`, `(c)` or
>   `3(c)`; not *The*, not *Step*, not a command), then `--`, then the
>   evidence.
> - Seal says an A6 line starts with the same condition as an earlier one?
>   Four lines, four different conditions: all four are needed at once.
> - Seal says A7 carries no honour line, or the wrong box's? Copy the line
>   with `release order honoured` in it, whole, from a release naming the
>   box your A3 names.
> - Seal says A8 names more than one condition? One name, alone on the
>   line. Your reasons belong in the logbook.
> - Seal says A8 is about the processor? Read the *Careful* note in step 1
>   again, then put the condition's name alone on the line.
> - Seal refuses your A8 and asks what the release changed? Look at what
>   the order made one box do with a lever it already held, and then at the
>   table in step 5.

---

## Case notes — the week's entry

Open `case-notes.md` (repo root) and fill the Week 7 row: what you found,
the command that showed it to you, and what you make of it.

Copy these **exactly**, character for character — do not paraphrase:

- The log's `day` line and all four `hold taken` lines.
- The manual page's `entered:` line, and rule 2 in full.
- The honour line your model printed when you released it.

Three questions to write toward, none of which has an answer in this work
order:

1. A frame that jams by accident jams whenever trains happen to meet. Look
   at the four hold times again, and at the gaps between them. Is that what
   an accident looks like? If not, what does it look like?
2. The manual page carries one date and the log another. Put them in
   order. What does that order let you say about the page — and what does it
   not?
3. Nothing collided and nothing was damaged: the frame failed *stopped*, as
   rule 1 says it is built to. Who would know that about a signal frame —
   and what would that knowledge let them do with one?

Write a plain guess rather than a careful hedge. The notebook is marked on
being kept honestly, never on being right early.

## Reflection (both prompts go in your logbook)

Answer in your own words. I am after your judgment, not the manual's.

1. In a paragraph: why does a deadlock need all four conditions at once,
   and why is breaking any one of them enough? Then take **two** of the
   table's prevention rows and, for each, describe a program where that
   remedy would be the wrong one to reach for — because it is impossible
   there, or because of what it costs. Use the words *mutual exclusion*,
   *hold and wait*, *resource preemption* and *circular wait* correctly at
   least once each. *zyBooks Ch 5.*
2. The release worked because somebody outside the ring had the authority
   to tell one box to give way, and a manual that said which. Most real
   programs have nobody like that: when their threads deadlock they simply
   stop, and a person notices eventually. In two or three sentences: would
   you rather build a system that can **recover** from deadlock, or one that
   cannot get into it at all — and what does each choice cost you? (There
   is no answer key. I am asking what you would defend in a design review.)

## Turn it in

Due **Monday, October 5, 11:59 pm**, on **Canvas** (per
[`syllabus/schedule.md`](../../syllabus/schedule.md)). This is **the
semester's only Monday deadline**: fall break takes this week's Friday, and
nothing is due over the break.

1. **`logbook.md`** — all three milestones: what you did, the seal pasted
   in, what it means. M1 wants the four holds in order, the gap, the rule in
   your own words with the box it names and its reason, and the two dates;
   **M2 wants the wait-for graph written out in full** — for each box, what
   it holds, what it waits for, who holds that, and the gdb line that showed
   you — which is the graded centre of the week; M3 wants the four
   conditions with your evidence, the release, which condition it broke and
   why not circular wait, and why the manual names the box it names. Plus
   both reflection prompts and the time-spent line.
2. **`case-notes.md`** — your running notebook with its Week 7 entry.

Upload both files to the Week 7 assignment. (`check/answers.txt` stays in
your repo — the seals already vouch for it.) When your paperwork is in,
you may `bash report-for-duty.sh --reset`. It takes the log, the page and
the model away, and leaves every other week's papers exactly where they
are.

**The usual late window applies, and this week it ends on exam day.**
Late work is accepted for two calendar days at a flat 20%, so this order's
window closes on **Wednesday, October 7** — the day of Guild Examination I.
Hand it in on Monday.

How the tasks cover the four objectives: Task 1 gathers the evidence Tasks
2 and 3 build on, and finds the rule that objective 4's recovery follows;
Task 2 is objective 2; Task 3 is objectives 1, 3 and 4; and the
reflections cover all four in your own words.

**Also on this week's docket.** Four dates:

- zyBooks **Ch 5** — deadlock — due **Wednesday** before class. It is the
  reading behind all three tasks. Do it first if you can.
- **No class Friday, October 2** — fall break. Nothing is due over the
  break.
- **Guild Examination I** is **Wednesday, October 7**, in class: zyBooks
  Ch 1–5 and the work orders through this one. It is an ordinary
  operating-systems paper, and nothing on it requires the story. The
  **review cards** are posted on Canvas with Episode 7's deck, and fall
  break is the long stretch to use them in.
- **Commission II — *The Speaking-Tube Console*** (zyBooks 12.2, "HUSH") is
  due **Friday, October 16, 11:59 pm, in zyBooks** — not Canvas. An **open
  HUSH workshop** runs **Friday, October 9**, the Friday of examination
  week: bring whatever you have, finished or not. The cover is at
  [`commissions/02-speaking-tube-console.md`](../../commissions/02-speaking-tube-console.md).

> `SUBMISSION: EXPECTED BY MONDAY 11:59 PM.`
> `WAX SEALS: THREE. ONE STUDIO. ADMIRED.`
> `AUTUMN FURLOUGH: NOTHING DUE. THIS PORTER CHECKED TWICE.`
> — punched chit, affixed by Porter Brassfeather

## For the curious *(worth no points, ever)*

Not required, not graded, not a trap.

- **gdb's own manual is inside gdb.** Its commands have no manual pages of
  their own: type `help thread apply`, `help frame` or `help print` at the
  `(gdb)` prompt, and `apropos thread` to list everything that mentions
  threads. `man 1 gdb` covers starting it.
- **Name a different box.** Run the model again and file the order naming
  Northgate instead. The ring clears — in a different order, with Northgate
  last. Returning any one lever breaks the cycle; the manual names the
  youngest claim for the reason in Task 3 step 6, not because it is the
  only box that works.
- **Force it, and see why the manual forbids it.** In a stopped model, type
  `print (int)pthread_mutex_unlock(&lever_kilnrow)`. That asks gdb to call
  the C library's unlock on Kiln Row's lever itself, from outside Kiln Row.
  On this bench the ring cleared while the call was still running — gdb
  lets every thread run while it makes a call — and `continue` then printed
  `Ring clear.` The `(int)` is a **cast**: on a bench without the C
  library's debugging information, gdb does not know what
  `pthread_mutex_unlock` returns and refuses the call with
  `'pthread_mutex_unlock' has unknown return type; cast the call to its
  declared return type` until you tell it — an `int`. And what you have
  done is **undefined behaviour**: POSIX does not say what happens when a
  mutex like this one is unlocked by a thread that does not hold it. It is
  exactly what rule 1 of the manual forbids. Kiln Row was never told — no honour line is
  printed — and its `holding` still says `lever_kilnrow` while the lever
  itself goes on to Old Quarter: two boxes with the same lever in their
  books. That is how trains come to meet. Forced resource preemption works,
  and it is almost never safe.
- **Take a photograph.** `gcore` at the `(gdb)` prompt saves the whole
  stopped program to a file named `core.` and a number, in the current
  folder. `kill`, `quit`, then
  `gdb -q -ix signal-box.gdb ./ring-frame core.NNNNN` (your own number;
  `-ix` reads the two settings *before* the core file is loaded, which `-x`
  is too late for) and `thread apply all bt` shows the same four waits —
  read from a file, with nothing running. That is how a hang on somebody
  else's machine gets diagnosed on yours. Delete it afterwards
  (`rm ~/enginehouse/ring-line/core.*`); the week's `--reset` leaves alone
  any file it did not make.
- **Attach instead of launch.** gdb can also look at a program that is
  already running: start the model in one terminal, and in another type
  `gdb -p $(pgrep ring-frame)`. On many benches — stock Ubuntu among them —
  this is refused, because the kernel setting `kernel.yama.ptrace_scope`
  (check it with `sysctl kernel.yama.ptrace_scope`) lets a debugger
  examine only programs it started itself, and on those benches attaching
  needs `sudo`. That is why this work order has you start the model **under**
  gdb: gdb is then its parent, and a debugger may look at a program it
  started itself.
- The four boxes on the Ring Line are Northgate, Waterside, Old Quarter and
  Kiln Row: the four districts of Week 5's waterworks table and Week 6's
  ledger hall. Three weeks, three different machines, the same four names.
  Nobody made you notice.

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"Every box on that ring was doing its duty. That is how a ring stops."*
