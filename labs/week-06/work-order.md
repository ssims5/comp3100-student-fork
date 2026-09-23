# WORK ORDER No. 1851-06 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Dated** | Monday, 21 September 1851 — eleven weeks to the Exhibition |
| **Due** | **Sunday, September 27, 11:59 pm** — `logbook.md` + `case-notes.md` on Canvas |

---

## Situation

Last week you put a guard on one shared line of C and watched a wrong
ledger become a right one. That was the whole of the lesson and it was
worth a week. It is also about a tenth of what this house actually needs,
because the Enginehouse is not one counter being added to. It is a
building full of machinery in which **several things are always going on
at once**, and every one of them is waiting on something.

Three floors are in trouble this week, and they are in trouble in three
different ways:

- The **north gallery signal box** lets two trains onto a single line. Not
  often. Not predictably. Enough.
- The **card sorting floor** tips cards into a chute that holds eight, and
  cannot tell you where the missing ones went.
- The **ledger hall** hands out pages that do not add up, written by a
  clerk who never wrote a wrong figure in his life.

A mutex will not fix all three. One of them needs a way for a waiting man
to be **told** rather than to stare; one needs a way to **count** what is
in a box; one needs readers and a writer to be treated differently,
because they are different. You will build all three tools.

Then there is a fourth floor, and it does not finish. It is the long
table in the refectory, and everybody at it is politely waiting for
everybody else. Read it, describe it, and then break it open. Next week
is an entire week on what you will have seen there; this week you only
have to see it.

And there is one last thing, which is not a program. There is a lever in
the north gallery that is thrown, and a lock beside it that will not come
off, and nobody on the floor will own either. It goes last on purpose.

Report for duty. — *B.M.*

## Your objectives (the real ones, in plain English)

Week 5 gave you one tool — the mutex — and one problem it solves: two
threads writing the same memory at the same time. This week is about the
four questions a mutex does **not** answer:

*How does a thread wait for something without burning the engine? How do
you keep a fixed-size buffer from over-running? What do you do when most
of your threads only read? And what happens when everybody is holding
something everybody else wants?*

The fiction is set dressing and the commands are the course; **no task
here requires story knowledge.** By Friday you will be able to:

1. **Say exactly what a mutex protects and what it does not.** It makes a
   stretch of code mutually exclusive. It does not tell a waiting thread
   when to try again, it does not count anything, and it does not know the
   difference between a reader and a writer. *zyBooks Ch 4.2.*
2. **Use a condition variable, and say why a bare mutex cannot do its
   job.** A thread that must wait for a *state* — not for a lock, for a
   state — should sleep until somebody signals that the state changed. You
   will replace a loop that looks, and looks, and looks with one that
   sleeps and is woken. *zyBooks Ch 4.3.*
3. **Say what a semaphore counts, and use two of them to bound a buffer.**
   A mutex is a yes/no. A semaphore is a number — of free slots, of
   waiting items — and a thread that finds it already at zero waits
   there instead of taking one.
   *zyBooks Ch 4.4.*
4. **Say why readers and writers need different treatment, and use a
   reader/writer lock.** Any number of readers may read at once; a writer
   must be alone. You will also meet **starvation**, which is what happens
   when a correct lock hands out turns unfairly. *zyBooks Ch 4.5.*
5. **Describe, in plain English, how a cycle of held locks forms** — who
   holds what, who waits on whom, all the way round — and apply one rule
   that makes the cycle impossible. *zyBooks Ch 4.5 (classic problems).*

Objective 5 is the one the Guild examines hardest, and the describing is
the graded part. Anybody can copy a fix. Very few people can tell you
what was actually happening.

## Provisions

**P1 — Your working Linux environment.** Any bench that passed Week 1's
smoke test is ready. This week uses `gcc`, `make`, `ls`, `stat`, `cat` and
`getent`, plus the POSIX threads library and POSIX semaphores — all of
which come with every Linux that can compile C at all. You will need
`sudo` **once**, at staging, and the script tells you exactly what for
before it asks. Nothing this week needs a network or a second terminal.
If your environment broke over the weekend,
[`setup/getting-started.md`](../../setup/getting-started.md) rebuilds it.

**P2 — This folder, open in a Linux terminal.** One is enough. Run the
line that matches your setup:

```sh
cd ~/comp3100-student/labs/week-06
```

Windows/WSL2 with the repo on the Windows side (Tab completes the path):

```sh
cd /mnt/c/Users/<YourWindowsName>/comp3100-student/labs/week-06
```

macOS/Multipass with your Mac's clone mounted into the VM:

```sh
cd ~/comp3100/labs/week-06
```

**P3 — Report for duty.** One command stages your bench:

```sh
bash report-for-duty.sh
```

On a bench that has never staged Week 6 before, this needs root once. It
prints a paragraph saying what it is going to do, `sudo` asks for your
password **once**, and both jobs happen inside that one window. (The roll
office adds a short note of its own while it works; it will not ask you
for anything.) Run it a second time and there is no disclosure and no
prompt at all, because there is nothing left outstanding.

Expected output — the slip, once the bench is up:

```
  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-06 :: bench staged and verified
  ------------------------------------------------------------------
   Signal box: ~/enginehouse/interlocking/lever-07.lock
               ~/enginehouse/interlocking/lock-record.txt
   Forge:      labs/week-06/starter   (interlocking, sorting-floor,
               ledger-hall, philosophers -- make builds all four)

   Lever 07 stands thrown and nobody on the floor will own it. The
   record books its holder by number, because numbers are the frame's
   business. Names are the house roll's.

   Take the four floors in the order they are listed. The last one does
   not finish, and is not meant to: it closes itself after five idle
   seconds, and Ctrl-C closes it sooner.
   (bash report-for-duty.sh --reset withdraws all of it. The house roll
   stays -- later weeks are standing on it.)
  ------------------------------------------------------------------
```

Two files land in `~/enginehouse/interlocking/`, plus — on a bench
staging Week 6 for the first time — the one house-roll entry disclosed
above. Nothing else is touched, no process is started, and re-running is
always safe.

**P4 — Your paperwork.** Two copies, each made once:

```sh
cp ../templates/logbook-template.md logbook.md
cp check/answers-template check/answers.txt
```

`logbook.md` is this week's report. `check/answers.txt` holds seven short
answers (A1–A7) that the seal checks read; the template says what goes
where, and each task tells you when. Your running `case-notes.md` is
already at the repo root.

**A note on this week's size.** This is a three-session week and it is the
longest work order of the term so far. Five tasks, five seals, roughly
three hours of bench time if nothing fights you. **Do not try to do it in
one sitting.** Tasks 1 and 2 are one session, Tasks 3 and 4 are the next,
and Task 5 is thirty minutes you should take when you are fresh. The
seals are designed to be claimed as you go; claim each one before you
stand up.

> **If you're lost, start here (Provisions).** None of this is graded.
> Work the list; bring whatever is still stuck to studio.
> - Run `pwd`. It should end in `labs/week-06`. If not, re-run the `cd`
>   line from P2 that matches your setup.
> - `pwd` prints something like `C:\Users\...`? You're in PowerShell, not
>   Linux. Type `wsl`, press Enter, then re-run the `cd` line.
> - `bash: report-for-duty.sh: /usr/bin/env: bad interpreter`? The file
>   picked up Windows line endings on the way down. From the repo root:
>   `git checkout -- .` and try again.
> - `gcc: command not found` or `make: command not found`? Your bench was
>   built without a compiler. `setup/getting-started.md` installs both in
>   one line; do it now, not on Friday.
> - The script says it cannot get root and has staged nothing? That is the
>   script refusing to half-build your bench, which is correct of it.
>   Bring the message to your instructor rather than working around it.
> - You ran `--reset` and want the bench back? Run
>   `bash report-for-duty.sh` again. It is idempotent.

---

## Task 1 — The interlocking, and a gateman who stares *(~35 minutes → Seal M1)*

A signal box in the north gallery works a stretch of **single line** —
one set of rails that trains must use in both directions. The whole
reason an interlocking frame exists is to keep one promise: *one train on
that line at a time, and never two.*

**1. Read the frame.**

```sh
cat starter/interlocking.c
```

Read it once through, then find these four things:

- `static int line_taken` — the frame's idea of the line. `0` clear, `1`
  taken. Four gatemen read it and four gatemen write it.
- `day_book` — one line of text saying whose train has the single line,
  rewritten for every crossing.
- `work_the_frame()` — what one gateman does, thirty thousand times:
  **wait** for the line, **write** the day-book, **throw** the lever, run
  the train through, put the lever back.
- The waiting itself:

```c
        while (line_taken != 0)
            g->idle_looks++;
```

That is a gateman standing at the frame looking at the lever, and looking
at it again, and looking at it again, because nobody is going to tell him
when it moves. Hold on to that loop. It is half of this task.

**2. Cast it and run it:**

```sh
cd starter
make
./interlocking
```

Expected — the build line with no warnings, then a tally. **Your numbers
will not be mine.** Copy the shape, not the figures:

```
gcc -Wall -Wextra -pthread -o interlocking interlocking.c
Interlocking frame, north gallery: 4 gatemen, 30000 crossings apiece.

  gateman 1: 30000 trains through, 5406832 idle looks at the lever
  gateman 2: 30000 trains through, 5136383 idle looks at the lever
  gateman 3: 30000 trains through, 4958938 idle looks at the lever
  gateman 4: 30000 trains through, 5426723 idle looks at the lever

  trains booked through: 120000
  crossings a second train came onto the line during: 98394
  day-book entries found in another hand: 108374
  idle looks at the lever: 20928876
  wheelsets counted through the frame: 36000000

  The single line is supposed to be single, the day-book is
  supposed to be in one hand, and a gateman who stares at a
  lever is a gateman doing no work at all.
```

Three numbers to read, in this order.

**`trains booked through: 120000`** is exact and will be exact on every
bench: four gatemen, thirty thousand crossings each. Every gateman did
all his work.

**The second and third lines are the fault.** On this bench a second train
came onto the single line during roughly eighty per cent of crossings,
and roughly the same share of day-book entries came back written in
somebody else's hand. Your figures will differ — they are different every
run — but both will be large, and neither will be zero. Run it twice more
and watch them move.

Two separate promises are being broken by the same cause. One `int` that
four threads read and write with nothing between them is a **data race**,
exactly as in Week 5 — except that here the damage is not a lost count.
It is a *train on an occupied line*, which is the kind of bug that gets
written up in a different sort of report.

**The fourth number is a different problem.** Idle looks — however many
your own bench counted. Nothing was gained by a single one of them. That
is four engines running flat out doing nothing at all, and it is what a
mutex on its own will not fix.

**3. Guard the frame.** Open the source:

```sh
nano interlocking.c
```

(Any editor is fine. `nano` saves with Ctrl-O, Enter, and exits with
Ctrl-X.)

**First**, declare two things, immediately below `static int line_taken = 0;`:

```c
/* The frame's own guard. Nothing about the frame -- the lever, the
 * day-book, the holder -- is read or written without it. */
static pthread_mutex_t frame_guard = PTHREAD_MUTEX_INITIALIZER;

/* Word that lever 07 has come back to normal. A gateman waits on this
 * instead of staring at the lever. */
static pthread_cond_t lever_free = PTHREAD_COND_INITIALIZER;
```

A **condition variable** is not a lock. It is a place to wait and a bell
to ring. It always comes with a mutex, it is always used with a `while`
loop around it, and it exists because there is no way to write "sleep
until `line_taken` becomes 0" with a mutex alone.

**Second**, replace the staring loop. Find these two lines in
`work_the_frame()`:

```c
        while (line_taken != 0)
            g->idle_looks++;
```

and make them these five:

```c
        pthread_mutex_lock(&frame_guard);
        while (line_taken != 0) {
            g->idle_looks++;
            pthread_cond_wait(&lever_free, &frame_guard);
        }
```

`pthread_cond_wait` does three things, and you must know all three. The
first two are **one indivisible step**: it **releases the mutex and sleeps**,
with no gap between them. Then, when it is woken, it **takes the mutex
back** before returning. That absent gap is the whole invention — if you
unlocked and then slept as two separate statements, a bell rung in between
would be lost for ever, and you cannot close that window yourself. It is
also why the gateman can hold the guard while he checks and still not
block the man who is going to free the lever.

**Why `while` and not `if`.** Because waking up is not a promise. The man
who rings the bell may be beaten to the lever by somebody else, and some
systems wake a waiter for no reason at all. So a woken thread **re-checks
the condition** and goes back to sleep if it is not true yet. Write
`while`. Always write `while`.

**Third**, close the guarded stretch. Find:

```c
        line_taken = 1;
        line_holder = g->number;
```

and add one line after them:

```c
        pthread_mutex_unlock(&frame_guard);
```

The gateman now writes the day-book, claims the line and records himself
as the holder **without anybody else able to look at the frame in the
middle of it**. Then he lets go, because the train takes a while to run
through and there is no sense holding the frame's guard while it does.

**Fourth**, ring the bell when the lever comes back. Find the end of the
crossing loop:

```c
        g->crossings++;
        line_taken = 0;
```

and make it:

```c
        g->crossings++;

        pthread_mutex_lock(&frame_guard);
        line_taken = 0;
        pthread_cond_signal(&lever_free);
        pthread_mutex_unlock(&frame_guard);
```

`pthread_cond_signal` wakes **at least one** waiter — exactly one, in
practice, on every bench in this course. (`pthread_cond_broadcast` wakes
all of them; you want that when several waiters could each make
progress, and here only one can, because there is only one line.) Signal
while you still hold the mutex — it keeps the change and the announcement
of it inside one guarded stretch, which is easier to read and easier to get
right. (POSIX allows either side of the unlock. What makes the `while` above
necessary is not where you signal; it is that a wakeup is a hint and not a
promise — so you need the `while` either way.)

`#include <pthread.h>` is already at the top of the file. Nothing else
needs adding.

**4. Cast it again and run it three times:**

```sh
make
./interlocking
./interlocking
./interlocking
```

Expected — the build line with no warnings, and then this, three times
out of three, **except for the idle-look figures**:

```
  gateman 1: 30000 trains through, 12332 idle looks at the lever
  gateman 2: 30000 trains through, 11843 idle looks at the lever
  gateman 3: 30000 trains through, 11787 idle looks at the lever
  gateman 4: 30000 trains through, 12254 idle looks at the lever

  trains booked through: 120000
  crossings a second train came onto the line during: 0
  day-book entries found in another hand: 0
  idle looks at the lever: 48216
  wheelsets counted through the frame: 36000000
```

**Here I will print the important numbers, because now there are some.**
`120000`, `0`, `0` — every run, every bench, today and next year. That is
the difference between a program that usually works and a program that is
correct.

It will also take longer to finish than the broken one did — on this
bench, about a second and a half against a tenth of a second. That is the
guard, and it is what a guard costs. It is the right trade every time the
alternative is two trains on one line.

**5. Now look at the idle looks, and think.** I am **not** printing an
expected figure there and I am not going to. It varies by orders of
magnitude between benches, between runs, and between the number of
engines your machine has. On this bench the broken build looked at the
lever about twenty million times and the fixed build about forty-eight
thousand — but the last time this order was revised the broken figure was
under three thousand, and on a single-core bench it has come back at
fifty million. **There is no number here to check.** There is a shape, and
a question:

*The line was genuinely busy tens of thousands of times in both builds.
In the broken build a gateman noticed that by looking, over and over,
with the engine in his hands the whole time. In the fixed build he
notices it once and then sleeps. What is the engine doing during those
waits now, and who does it belong to?*

Answer that in your logbook in two sentences. Quote your own two idle
figures — broken and fixed — and say plainly that they are your bench's
and nobody else's.

**Checkpoint.** Before you claim the seal you should be able to say, out
loud, in one sentence: *the mutex stopped the second train, and the
condition variable stopped the staring.* Two faults, two tools, one task.
If you can only say one of those, read step 3 again.

**6. File what you saw.** Open `check/answers.txt`:

- **`A1:`** — three numbers from your **fixed** run, on the one `A1:`
  line, in this order: `trains booked through`, `crossings a second train
  came onto the line during`, and `day-book entries found in another
  hand`.

**7. Claim the seal** — from `labs/week-06` (not from `starter/`):

```sh
cd ..
make -C check m1
```

Expected:

```
make: Entering directory '.../labs/week-06/check'
  ~~~ WAX SEAL of the Guild: A41C60DE ~~~
  (Paste this seal into your logbook under Milestone 1.)
make: Leaving directory '.../labs/week-06/check'
```

(The seal code is yours, not this one.)

Paste your seal under **Milestone 1** with a short paragraph: what the
broken run printed, what the fixed run printed, what the mutex fixed,
what the condition variable fixed, and the two sentences from step 5.

> **If you're lost, start here (Task 1).**
> - `make: *** No rule to make target`? You are in the wrong directory.
>   `make` for the floors runs in `starter/`; `make -C check m1` runs in
>   `labs/week-06`. Check `pwd` before each.
> - `undefined reference to 'pthread_create'`? You compiled by hand
>   without `-pthread`. Use `make` — the Makefile has the flag.
> - `error: unknown type name 'pthread_cond_t'`? A spelling slip, or the
>   declaration went inside a function. Both declarations belong at file
>   scope, right under `static int line_taken = 0;`.
> - **The program starts and never prints anything.** Almost always one of
>   two things. Either you locked `frame_guard` and never unlocked it on
>   some path — check that step 3's `pthread_mutex_unlock` really is
>   there, after `line_holder = g->number;` — or you signalled without
>   ever setting `line_taken = 0`, so every waiter re-checks, finds the
>   line still taken, and goes back to sleep. Ctrl-C, then read the two
>   blocks you added side by side. (There is a name for the general case
>   of a program where everybody is waiting and nobody can move. It is
>   Week 7's, and Week 7 is a whole week on it.)
> - **The clash count is still non-zero.** The guard is in the wrong
>   place. It must be taken *before* the `while` loop and released *after*
>   `line_holder = g->number;` — the check and the claim have to be inside
>   the same held guard, or two gatemen can both see "clear".
> - **`make` says `'interlocking' is up to date`.** Your editor saved
>   somewhere else. `make clean && make`, and check `pwd`.
> - **The idle-look count came out very small, or zero.** Not a fault, and
>   not something to chase. It means your bench's gatemen rarely had to
>   wait at all. Record what you got and say so.
> - Seal says the source has a mutex but no wait? It greps
>   `starter/interlocking.c` for `pthread_cond_wait` and for
>   `pthread_cond_signal` (or `pthread_cond_broadcast` — the seal accepts
>   either). Check with `grep pthread_cond starter/interlocking.c` —
>   you should see the wait and one of the two wakes.
> - Seal says A1 wants three numbers? Put exactly three on the `A1:` line,
>   in the order step 6 gives, and nothing else that looks like a number.

---

## Task 2 — The sorting floor, and a chute that holds eight *(~40 minutes → Seal M2)*

Punched cards come off four presses, go down a chute, and are taken off
the bottom by two sorters. The chute holds eight cards. That is not a
house preference — it is how many cards fit in the chute.

This is the **producer–consumer** problem, and it is the single most
common shape in working software: a queue with a fixed size, somebody
putting things in, somebody taking things out, and neither of them
allowed to run ahead of the other.

**1. Read the floor.**

```sh
cat starter/sorting-floor.c
```

Find the four things that matter:

- `#define CHUTE 8` and `static long chute[CHUTE]` — the buffer, and its
  size.
- `tipped_in` and `taken_out` — where the next card goes in and where the
  next card comes out. Both are read and written by everyone on the floor.
- `run_the_press()` — a press **glances** at the chute (`if (tipped_in -
  taken_out >= CHUTE)`), counts the fact that it was full, and **tips
  anyway**. Glancing is not waiting.
- `work_the_desk()` — a sorter checks whether there is anything there,
  and if not, checks again. Nobody waits for anything.

**2. Cast it and run it:**

```sh
cd starter
make
./sorting-floor
```

Expected — again, the shape, not the figures:

```
Sorting floor: a chute that holds 8, 4 presses, 2 sorters, 40000 cards.

  sorter 1 carried away 1920 cards
  sorter 2 carried away 7996 cards

  cards tipped in: 40000
  cards carried away: 9916
  serials that never came out: 30590
  serials that came out more than once: 506
  cards tipped onto a chute already full: 16098
  reaches into a slot with nothing in it: 7046

  A chute that holds eight held rather more than eight, and the
  floor cannot tell you where the missing cards went.
```

`cards tipped in: 40000` is exact on every bench. Everything under it is
wreckage, and your figures will differ from mine and from your own next
run. Three separate things have gone wrong:

- **Cards are lost.** Tens of thousands of serials never reached a
  sorter, because a press wrote into a slot that still held a card nobody
  had taken.
- **Cards come out twice.** Two sorters read the same `taken_out`, both
  decided it was theirs, and both carried it off.
- **The bound is not a bound.** Sixteen thousand cards were tipped onto a
  chute that was already full. A `chute[8]` that holds more than eight
  does not exist; what is actually happening is that cards are being
  written over.

Run it twice more. On a bench with one engine you may see something
stranger still — the presses finish before the sorters get the engine at
all, and `cards carried away` comes back in single figures. Truthful, and
worse.

**3. What a semaphore is.** A mutex is a yes/no: held or not held. A
**semaphore** is a **number**, with two operations:

- `sem_wait(&s)` — if the number is greater than zero, take one and carry
  on. If it is zero, **sleep here** until somebody adds one.
- `sem_post(&s)` — add one, and wake a sleeper if there is one.

That is all a semaphore is. What makes it the right tool here is what the
number *means*. You need two of them:

- **`room`** starts at 8 — *"slots free in the chute"*. A press does
  `sem_wait(&room)` before it tips. If the chute is full the number is
  zero and the press sleeps until a sorter makes room.
- **`cards_waiting`** starts at 0 — *"cards in the chute"*. A sorter does
  `sem_wait(&cards_waiting)` before it reaches. If there is nothing there
  the number is zero and the sorter sleeps until a press tips one in.

Every tip is `sem_wait(&room)` … `sem_post(&cards_waiting)`. Every take is
`sem_wait(&cards_waiting)` … `sem_post(&room)`. The two counters chase
each other round, and `room + cards_waiting` is **at most eight** — and
briefly less. Between a press's `sem_wait(&room)` and its
`sem_post(&cards_waiting)` that press holds a slot it has not yet filled,
and a sorter between its own two calls holds a card it has not yet
accounted for; with four presses and two sorters, several can be in
flight at once. Momentarily low is correct, not a bug. **That invariant
is the answer**, and if you can draw it you can write the rest from
memory for the rest of your life.

**One thing the semaphores do not do.** They bound the chute. They do not
protect `tipped_in` and `taken_out`, which are still two shared `long`s
that four presses and two sorters are incrementing — and you know from
Week 5 exactly what that is. **You still need a mutex**, inside the
semaphores, around the indices. A semaphore counts; a mutex excludes;
this floor needs both, and knowing which does which is most of Objective 3.

**4. Make the edits.** Five of them. Open the source:

```sh
nano sorting-floor.c
```

**Edit 1 — the header.** Under `#include <pthread.h>`:

```c
#include <semaphore.h>
```

**Edit 2 — the declarations.** Under `static long chute[CHUTE];`:

```c
/* Room left in the chute, and cards waiting in it. */
static sem_t room;
static sem_t cards_waiting;

/* The chute's counters are shared; a semaphore does not guard them. */
static pthread_mutex_t chute_guard = PTHREAD_MUTEX_INITIALIZER;

/* The deepest the chute ever got. */
static long high_water = 0;
```

**Edit 3 — the press.** In `run_the_press()`, find:

```c
        if (tipped_in - taken_out >= CHUTE)
            tipped_onto_full++;

        chute[tipped_in % CHUTE] = serial;
        tipped_in++;
        p->tipped++;
```

and make it:

```c
        sem_wait(&room);
        pthread_mutex_lock(&chute_guard);

        if (tipped_in - taken_out >= CHUTE)
            tipped_onto_full++;

        chute[tipped_in % CHUTE] = serial;
        tipped_in++;
        if (tipped_in - taken_out > high_water)
            high_water = tipped_in - taken_out;

        pthread_mutex_unlock(&chute_guard);
        sem_post(&cards_waiting);
        p->tipped++;
```

Note the order and keep it: **wait for room, then take the guard**. Take
the guard first and a full chute means one press sleeps holding the guard
that a sorter needs in order to empty it, and the floor stops. Wait
outside, lock inside. Always.

`high_water` is your own instrument. You are about to claim that a chute
that holds eight never holds more than eight; this is the line that makes
the claim checkable instead of hopeful. Measure what you assert.

**Edit 4 — the sorter.** Replace the whole body of `work_the_desk()` —
from `struct sorting_desk *d = arg;` down to and including the
`return NULL;` at the end of it — with this:

```c
    struct sorting_desk *d = arg;

    for (;;) {
        long slot, card;

        sem_wait(&cards_waiting);
        pthread_mutex_lock(&chute_guard);

        if (taken_out >= tipped_in) {
            /* The shift bell, not a card. */
            pthread_mutex_unlock(&chute_guard);
            break;
        }

        slot = taken_out;
        card = chute[slot % CHUTE];
        chute[slot % CHUTE] = 0;
        taken_out = slot + 1;

        pthread_mutex_unlock(&chute_guard);
        sem_post(&room);

        if (card == 0)
            reached_into_empty++;
        else if (d->count < TOTAL)
            d->carried[d->count++] = card;
    }
    return NULL;
```

The old body counted two hundred thousand empty reaches before it would
believe the shift was over. It does not need to guess any more: if a
sorter is woken and the chute is genuinely empty, the only thing that can
have woken it is the bell, which you are about to ring.

**Edit 5 — main.** Three changes. Before the first `printf`, set the two
counters up:

```c
    sem_init(&room, 0, CHUTE);
    sem_init(&cards_waiting, 0, 0);
```

(The middle argument, `0`, means "this semaphore is shared between threads
of one process, not between processes". That is what you want.)

Then find where the presses are joined:

```c
    presses_done = 1;
    for (s = 0; s < SORTERS; s++)
        pthread_join(desk_thread[s], NULL);
```

and ring the bell before you wait for the desks:

```c
    presses_done = 1;
    for (s = 0; s < SORTERS; s++)
        sem_post(&cards_waiting);   /* the shift bell, one per desk */
    for (s = 0; s < SORTERS; s++)
        pthread_join(desk_thread[s], NULL);
```

One post per sorter. Each sorter wakes, finds the chute empty, and goes
home. Without this the sorters would sleep on `cards_waiting` for ever
and the program would never return — a sleeping thread has to be woken by
somebody, and after the last card there is nobody left to do it.

Finally, print your instrument. Just above the `cards tipped onto a chute
already full` line, add:

```c
    printf("  deepest the chute ever got: %ld\n", high_water);
```

**5. Cast it and run it three times:**

```sh
make
./sorting-floor
./sorting-floor
./sorting-floor
```

Expected — no warnings, and then this, three times out of three, except
that the split between the two sorters is theirs to decide:

```
Sorting floor: a chute that holds 8, 4 presses, 2 sorters, 40000 cards.

  sorter 1 carried away 19506 cards
  sorter 2 carried away 20494 cards

  cards tipped in: 40000
  cards carried away: 40000
  serials that never came out: 0
  serials that came out more than once: 0
  deepest the chute ever got: 8
  cards tipped onto a chute already full: 0
  reaches into a slot with nothing in it: 0

  Every card came out, and the chute was never over-filled.
  That is not what this floor is for -- run it again.
```

**Read that last line and then ignore it.** It was written for the broken
floor, back when a clean run meant your bench had simply failed to
misbehave. Now it means you fixed it. A message that made sense in one
state and reads oddly in another is worth noticing; you will write one of
those yourself before you are done, and somebody will file a bug about it.

**`deepest the chute ever got: 8`** is the line to look at hardest. Not
nine. Not eight thousand. **Never more than eight** — which is the number
in the `#define` — and that is the invariant which must hold. On any bench
with real concurrency it will actually reach eight, because four presses
outrun two sorters; if yours reads lower, trust your own measurement and
record it. That is a **bounded buffer**, and it is bounded because a press
that finds no room sleeps instead of tipping.

**Checkpoint.** You should be able to say which of the three faults each
tool fixed: the semaphores stopped the over-run and the empty reaches; the
mutex stopped the duplicates and the losses. Two tools, doing two
different jobs, in the same eight lines.

**6. File it.** In `check/answers.txt`:

- **`A2:`** — the `deepest the chute ever got` figure. One number.
- **`A3:`** — two numbers on the one `A3:` line: `cards tipped in` and
  `cards carried away`.

**7. Claim the seal** — from `labs/week-06`:

```sh
cd ..
make -C check m2
```

Expected:

```
  ~~~ WAX SEAL of the Guild: 12F7AE05 ~~~
  (Paste this seal into your logbook under Milestone 2.)
```

(The seal code is yours, not this one.)

Paste it under **Milestone 2** with a real paragraph — this is the
week's centrepiece. Say what each of the two semaphores counts, why
`sem_wait(&room)` is outside the mutex and not inside it, why the mutex is
still needed once the semaphores are there, and what the bell at the end
is for.

> **If you're lost, start here (Task 2).**
> - `error: unknown type name 'sem_t'`? Edit 1 is missing.
>   `#include <semaphore.h>` goes with the other includes at the top.
> - `undefined reference to 'sem_init'`? On modern Linux `-pthread` covers
>   it, so this almost always means you compiled by hand. Use `make`.
> - **The program starts and never finishes.** Two usual causes, and they
>   look identical from outside. (a) You took `chute_guard` *before*
>   `sem_wait(&room)` — re-read the note in Edit 3. (b) You left the bell
>   out of Edit 5, so the sorters are still asleep waiting for a card that
>   is never coming. Ctrl-C, then check the order of those two lines and
>   the `sem_post` loop in `main`.
> - **`cards carried away` is short by one or two.** Check that your bell
>   loop posts `SORTERS` times, not once, and that the `break` in Edit 4 is
>   inside the `if`, not after it.
> - **`deepest the chute ever got` prints 0.** The `high_water` lines went
>   somewhere that never runs, or they went outside the mutex. They belong
>   immediately after `tipped_in++`, with the guard still held.
> - **`deepest the chute ever got` is larger than 8.** Then `sem_wait(&room)`
>   is not being reached, or `room` was initialised to something other than
>   `CHUTE`. Check Edit 5's first line.
> - **`serials that came out more than once` is still non-zero.** The mutex
>   is missing or is around the wrong lines. It must cover the read of
>   `taken_out`, the read of the slot, and the write back — all three, in
>   one held stretch.
> - Seal says the source has no `sem_wait` or no `sem_post`? It greps
>   `starter/sorting-floor.c`. Check with `grep sem_ starter/sorting-floor.c`.
> - Seal says A2 is larger than the chute holds? Then either you copied the
>   wrong line or the fix is not in. Re-read the two lines above.
> - Seal says A3's two numbers are not equal? They must be. `cards tipped
>   in` and `cards carried away` are the same forty thousand cards counted
>   at two ends of one chute. If yours disagree, the fix is not complete —
>   do not paper over it in the answer file.

---

## Task 3 — The ledger hall, and a page that does not add up *(~35 minutes → Seal M3)*

One page. Four district balances down the side — **Northgate, Waterside,
Old Quarter, Kiln Row**, the same four as the waterworks table you
checked by hand last week — and a total written at the foot. A page is
correct only when the four balances and the total agree. That is the
entire purpose of writing a total.

One clerk posts to the page. Six readers stand at the rail and read it,
adding the column up for themselves to see whether the foot of the page
is honest.

**1. Read the hall.**

```sh
cat starter/ledger-hall.c
```

Find:

- `balance[DISTRICTS]` and `stated_total` — the page. One writer, six
  readers.
- `post_the_figures()` — the clerk. He writes the four districts one at a
  time, down the column, and the total last, **because that is how a pen
  works**. Nothing in that function is wrong.
- `read_the_page()` — a reader copies the four balances, adds them, reads
  the foot, and compares.

**2. Cast it and run it:**

```sh
cd starter
make
./ledger-hall
```

It takes about a second. Expected — the shape:

```
Ledger hall: one clerk posting 2000000 times, 6 readers at the rail.

  reader 1: 8154355 pages read, 3932920 did not balance
  ...
  pages read: 43542757
  pages that balanced: 23035676
  pages that did not balance: 20507081

  the first page reader 1 could not make balance:
    Northgate    53517
    Waterside    61248
    Old Quarter  44638
    Kiln Row     54668
    total        214072   <- and the column adds to 214071

  Nobody wrote a wrong figure. Every figure on that page was
  true when the pen wrote it. The page is still wrong.
```

Roughly half of every read is torn. Your figures will differ and the
specimen page will be a different one every run.

**Look at the specimen page and work out what happened**, because this is
the part that is on the examination. Northgate is **one posting behind**
the other three. The reader copied Northgate, the clerk's pen moved on,
and by the time the reader got to Waterside the page had changed under
him.

Now check the direction, because the direction is the evidence. A stale
balance is a *smaller* balance — the clerk only ever adds — so a column
with one stale district in it comes out **short**, and it comes out short
by exactly as many postings as the reader fell behind. Here the column is
`214071` against a foot of `214072`: one district, one posting, one penny.
Your specimen will be a different page with a different gap, and the gap
will almost always run that way.

(Almost always, not always. The clerk writes the four districts *and then*
the foot, so a reader quick enough can catch a column that has already
moved on while the total at the bottom has not — and then the column comes
out **high** instead. Either way the page does not balance, and either way
nobody wrote a wrong figure.)

Every figure on that page was true at the moment the pen wrote it. **The
page is still wrong**, because a page is a statement about four figures
*taken together*, and the reader saw them taken apart.

That is a **torn read**, and it is a different animal from Week 5's lost
update. Nothing was lost. The writer is not even racing another writer —
there is only one clerk. The fault is that a **reader** is allowed to see
the middle of a write.

**3. Why a plain mutex is the wrong answer here.** You could put one
mutex around the clerk's posting and the same mutex around the reader's
reading. Every page would balance and the seal's arithmetic would pass.

Do not do it, and know why: **it would let one reader at a time.** Six
readers who only look would queue behind each other for no reason, and
six-sevenths of your hall would stand idle waiting for a lock nobody
needed. Reading does not conflict with reading. It conflicts only with
writing.

That asymmetry has its own tool. A **reader/writer lock** has two doors:

- `pthread_rwlock_rdlock()` — **any number** of readers may hold it at
  once.
- `pthread_rwlock_wrlock()` — a writer holds it **alone**, with no readers
  and no other writer.

Both are released with the same `pthread_rwlock_unlock()`.

**And one thing more, which is the real lesson of this task.** A lock has
to decide who goes next, and that decision can be unfair. POSIX does not
mandate one policy, and implementations differ — but **the default on
this bench prefers readers**: while any reader holds the lock, a new
reader may walk straight in, even if a writer has been waiting since
before it arrived. With six readers in a tight loop that moment never
comes, the clerk never gets the pen to the page, and the program runs for
minutes instead of seconds without a single thing being wrong with it.
That is **starvation** — a thread that is never wrong and never
finishes — and it is on the examination too. So you will ask for a lock
that lets the pen in.

**4. Make the edits.** Four of them.

```sh
nano ledger-hall.c
```

**Edit 1 — the very first line of the file**, above the comment block
and above every `#include`:

```c
#define _GNU_SOURCE
```

That switch turns on the GNU extensions in the system headers, and the
knob you need for writer preference is one of them. Every Linux bench in
this course has it. (A line that must come *before* the includes is a real
thing you will meet again; the headers read it as they are compiled.)

**Edit 2 — the lock itself.** Under `static long stated_total;`:

```c
/* The rail. Any number of readers may stand at it together; the pen may
 * not be at the page while anybody is standing there. */
static pthread_rwlock_t page_lock;
```

**Edit 3 — the two paths.** In `read_the_page()`, find:

```c
        for (d = 0; d < DISTRICTS; d++) {
            seen[d] = balance[d];
            sum += seen[d];
        }
        foot = stated_total;
```

and wrap it:

```c
        pthread_rwlock_rdlock(&page_lock);
        for (d = 0; d < DISTRICTS; d++) {
            seen[d] = balance[d];
            sum += seen[d];
        }
        foot = stated_total;
        pthread_rwlock_unlock(&page_lock);
```

Then in `post_the_figures()`, find the two commented blocks:

```c
        /* One entry at a time, down the column, as a pen does. */
        for (d = 0; d < DISTRICTS; d++)
            balance[d] = OPENING[d] + n;

        /* And the total at the foot, when the column is done. */
        stated_total = OPENING_SUM + n * DISTRICTS;
```

and wrap **both of them together**, in one stretch:

```c
        pthread_rwlock_wrlock(&page_lock);

        /* One entry at a time, down the column, as a pen does. */
        for (d = 0; d < DISTRICTS; d++)
            balance[d] = OPENING[d] + n;

        /* And the total at the foot, when the column is done. */
        stated_total = OPENING_SUM + n * DISTRICTS;

        pthread_rwlock_unlock(&page_lock);
```

**Both, together, in one stretch** is the whole fix. The clerk still
writes one figure at a time — you have not changed how a pen works. What
you have changed is that nobody can be at the rail while he does it. The
critical section is not "the write"; it is "**all five writes that make
the page true again**".

**Edit 4 — ask for the fair lock.** In `main()`, immediately above:

```c
    for (d = 0; d < DISTRICTS; d++)
        balance[d] = OPENING[d];
```

put:

```c
    {
        /* The pen gets priority. Six readers at a tight rail never all
         * step back at once, and a default lock would leave the clerk
         * standing there for good. */
        pthread_rwlockattr_t how;

        pthread_rwlockattr_init(&how);
        pthread_rwlockattr_setkind_np(&how, PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP);
        pthread_rwlock_init(&page_lock, &how);
    }
```

That is the pattern for every POSIX object that has options: make an
**attributes** object, set what you want on it, hand it to the `init`
call. You will see it again for threads themselves.

**5. Cast it and run it three times:**

```sh
make
./ledger-hall
./ledger-hall
./ledger-hall
```

Expected — no warnings, a run of a few seconds, and this every time
except for the page counts, which are yours:

```
Ledger hall: one clerk posting 2000000 times, 6 readers at the rail.

  reader 1: 1985785 pages read, 0 did not balance
  reader 2: 2091619 pages read, 0 did not balance
  reader 3: 2013352 pages read, 0 did not balance
  reader 4: 2090562 pages read, 0 did not balance
  reader 5: 2071595 pages read, 0 did not balance
  reader 6: 2007347 pages read, 0 did not balance

  pages read: 12260260
  pages that balanced: 12260260
  pages that did not balance: 0

  every page balanced this time. Run it again.
```

The closing line is another one written for the broken hall — read it as
the hall being surprised. `0` in the right-hand column of all six readers
and `0` on the `did not balance` line is the result.

Notice what the guard **cost**: the run takes a few seconds where the
broken hall took a fraction of one. The readers are waiting on the pen
now, as they should be — correct is slower here, and correct is still
correct. How *many* seconds is your own bench's business, and it does not
go the way you would guess: it is quickest on a single engine, quick
again on a large one, and slowest in between, where a handful of engines
have to take turns. Anything up to ten seconds or so is an ordinary
result. The figure that matters is the one in the right-hand column, and
it is `0`.

**The page counts are a different matter, and I am not printing a
comparison.** On this bench the fixed hall read twelve million pages
against the broken hall's forty-three million, so it looks as though
guarding it cost the readers work. Run the same two builds on a bench with
one engine and the fixed hall reads **more** pages than the broken one,
not fewer. Which way that number moves depends on how many engines your
machine has, and it is not what the fix was for. The figure that is the
same on every bench is the one in the right-hand column: zero.

**Checkpoint.** You should be able to say why the clerk's whole column
went inside one write-lock rather than one lock per district, and why six
readers in the hall is an argument for a reader/writer lock rather than a
mutex. Both answers are one sentence each.

**6. File it.** In `check/answers.txt`:

- **`A4:`** — two numbers on the one `A4:` line: `pages read` and `pages
  that did not balance`.

**7. Claim the seal** — from `labs/week-06`:

```sh
cd ..
make -C check m3
```

Expected:

```
  ~~~ WAX SEAL of the Guild: 7B1E44A9 ~~~
  (Paste this seal into your logbook under Milestone 3.)
```

(The seal code is yours, not this one.)

Paste it under **Milestone 3** with two or three sentences: what a torn
read is in your own words, walking the specimen page you actually got;
why a single mutex would have passed the test and still been the wrong
answer; and what starvation is.

> **If you're lost, start here (Task 3).**
> - `error: 'PTHREAD_RWLOCK_PREFER_WRITER_NONRECURSIVE_NP' undeclared`, or
>   `implicit declaration of function 'pthread_rwlockattr_setkind_np'`?
>   Edit 1 is missing, or it is not the **first** line of the file. It must
>   be above every `#include`.
> - `error: unknown type name 'pthread_rwlock_t'`? A spelling slip.
>   `pthread.h` is already included and has it.
> - **It has been running for more than two minutes.** That is not a slow
>   bench — a correct build finishes well inside a minute on any bench,
>   and this one will not finish at all. Edit 4 is missing or did not take
>   effect, so you have the default reader-preferring lock and six readers
>   who never step back at once. Ctrl-C. Check that the block is
>   in `main()` and *above* the loop that seeds `balance[]`, and that you
>   are calling `pthread_rwlock_init` rather than still using
>   `PTHREAD_RWLOCK_INITIALIZER`.
> - **Pages still do not balance.** The clerk's write-lock is around only
>   one of the two blocks. The four district writes and the total write
>   must be inside **one** held write-lock.
> - **The program starts and never prints.** You took the lock twice
>   without releasing it, or an `unlock` is outside a loop it should be
>   inside. Read the reader's block: exactly one `rdlock`, exactly one
>   `unlock`, both inside the `while`.
> - Seal says one mutex around everything is not the answer? It is telling
>   you what step 3 says: the observable test cannot tell the two apart,
>   and this task is about the difference. Use `pthread_rwlock_rdlock` for
>   the readers and `pthread_rwlock_wrlock` for the clerk.
> - Seal says A4's second number must be zero? Then your run still tore a
>   page. Do not edit the answer file; fix the hall.

---

## Task 4 — The long table *(~40 minutes → Seal M4)*

Five philosophers sit down to supper. Between each pair of them lies one
fork, so there are five forks for five diners. A philosopher needs the
fork on the left and the fork on the right before eating, and takes them
in that order, because that is the order they are laid.

Nothing in that arrangement is unfair, nobody is greedy, and every
philosopher follows the same perfectly reasonable rule.

**Before you run it, read this paragraph.** This floor does not finish,
and that is the point of it. The table has a porter: if nothing has been
eaten for five seconds he closes the sitting and the program ends by
itself, so your terminal is never left holding a fork. **Ctrl-C ends it
sooner, at any moment, and just as cleanly.** Neither one fixes anything.
Run it, watch it stop, and let it close itself — or press Ctrl-C when you
have seen enough. Either way you get your prompt back.

**1. Read the table.**

```sh
cat starter/philosophers.c
```

The header says it plainly: **describe it before you fix it.** The
description is what is graded. The fix is four lines and it is the easy
part.

Find `dine()`. It is short, and there is nothing clever in it.

**2. Run it:**

```sh
cd starter
make
./philosophers
```

Expected — ten lines, then five seconds of silence, then the porter. **The
order of the ten lines will not be mine.** That is the only thing that
varies:

```
The long table: 5 philosophers, 5 forks, 3 meals apiece.

  Aurelia   takes the fork on the left  (fork 0)
  Cordelia  takes the fork on the left  (fork 2)
  Bramwell  takes the fork on the left  (fork 1)
  Eustace   takes the fork on the left  (fork 4)
  Desmond   takes the fork on the left  (fork 3)
  Bramwell  reaches for the fork on the right (fork 2)
  Aurelia   reaches for the fork on the right (fork 1)
  Cordelia  reaches for the fork on the right (fork 3)
  Eustace   reaches for the fork on the right (fork 0)
  Desmond   reaches for the fork on the right (fork 4)

  The porter: nothing has been eaten for 5 seconds.
  Meals served: 0 of 15. The sitting is closed.
  (Ctrl-C would have done the same, at any moment.)

  Every philosopher at that table is holding one fork and
  waiting for one fork. Name them. Say which fork each holds
  and which fork each is waiting for, and say who is waiting
  on whom, all the way round. Do that before you change a
  single line of this file.
```

`Meals served: 0 of 15` is what to expect, and 0 on any ordinary bench —
not one of them ate.

**3. Draw it. On paper. Now, before you read on.**

Five seats round a circle. Five forks, one between each pair, numbered 0
to 4. Philosopher in seat *n* takes fork *n* first and fork *(n+1) mod 5*
second. Write each philosopher's name in their seat, put the fork they are
**holding** in their hand, and draw an arrow from each philosopher to the
fork they are **waiting for**.

Then follow the arrows. Aurelia is waiting for the fork Bramwell is
holding. Bramwell is waiting for the fork Cordelia is holding. Keep going.
You will come back to Aurelia, and when you do you will have drawn the
whole of this task.

What you have drawn is a **cycle**: a closed ring in which every member is
holding something the next member wants, and every member is waiting for
something the previous member will not let go of until it gets what *it*
is waiting for. Nobody is at fault. Nobody can move. Nothing will change
on its own, ever — the porter is not part of the mechanism, he is a
janitor who was hired because this exists.

**There is a name for this, and it is not this week's.** Next week is an
entire week on it: the four conditions that have to be true at once for it
to happen, how to spot it in a live system with a debugger, and what a
real operating system does about it. Week 6 is synchronization; Week 7 is
what synchronization done carelessly produces. What is wanted from you
today is the **description**, in your own words, not the vocabulary.

**4. Write the description, in your logbook, before you change anything.**
All five philosophers. For each one: which fork they hold, which fork they
are waiting for, and which philosopher is holding that fork. Then one
sentence saying why the ring cannot break itself.

**5. Now break it.** Look at what every philosopher has in common: *left
first, then right.* Five people, one rule, and the rule is the trouble —
because "left" means a different fork to each of them, so following it
takes all five forks at once and leaves nobody able to finish.

**The rule that fixes it: everybody takes the lower-numbered fork
first.** Not "their left". The lower number.

Work out on your drawing what that changes. Four of the five are
unaffected — for seats 0, 1, 2 and 3 the lower-numbered fork *is* the
left one. The fifth, in seat 4, now reaches across for fork 0 before
picking up fork 4. So fork 4 stays on the table, and somebody in the ring
can always finish. **One philosopher out of step is enough**, and it is
enough because the ring only closes if everybody agrees on the direction.

That is the general rule and it is worth memorising: **if every thread
takes its locks in the same fixed order, a cycle cannot form.** It costs
nothing, it works everywhere, and it is the first thing a working engineer
reaches for.

**6. Make the edit.** Four changes, all in `dine()`:

```sh
nano philosophers.c
```

Find:

```c
    int left  = p->seat;
    int right = (p->seat + 1) % PHILOSOPHERS;
```

and make it:

```c
    int left   = p->seat;
    int right  = (p->seat + 1) % PHILOSOPHERS;
    int first  = (left < right) ? left : right;
    int second = (left < right) ? right : left;
```

Then change the two `printf` lines and the two `lock` lines to use them.
The first pair becomes:

```c
        printf("  %-9s takes the lower-numbered fork  (fork %d)\n", NAME[p->seat], first);
        fflush(stdout);
        pthread_mutex_lock(&fork_on_table[first]);
```

and the second pair becomes:

```c
        printf("  %-9s reaches for the other fork (fork %d)\n", NAME[p->seat], second);
        fflush(stdout);
        pthread_mutex_lock(&fork_on_table[second]);
```

Change the two unlocks to match, keeping them in the opposite order to
the locks — last taken, first put down:

```c
        pthread_mutex_unlock(&fork_on_table[second]);
        pthread_mutex_unlock(&fork_on_table[first]);
```

Fix the messages as well as the locks. A program that takes fork 0 and
says it took fork 4 is a program that will waste somebody's afternoon.

**7. Cast it and run it three times:**

```sh
make
./philosophers
./philosophers
./philosophers
```

Expected — it finishes in under a second, and every philosopher eats three
times. The interleaving is different every run; the ending is not:

```
The long table: 5 philosophers, 5 forks, 3 meals apiece.

  Aurelia   takes the lower-numbered fork  (fork 0)
  Bramwell  takes the lower-numbered fork  (fork 1)
  Cordelia  takes the lower-numbered fork  (fork 2)
  Desmond   takes the lower-numbered fork  (fork 3)
  Eustace   takes the lower-numbered fork  (fork 0)
  Bramwell  reaches for the other fork (fork 2)
  Cordelia  reaches for the other fork (fork 3)
  Aurelia   reaches for the other fork (fork 1)
  Desmond   reaches for the other fork (fork 4)
  Desmond   eats. (1)
  ...

  Everyone ate. That is not what this table is for -- run it again.
```

Look at the fifth line. **Eustace takes fork 0**, and Aurelia already has
it, so he waits — with fork 4 still lying on the table where Desmond can
reach it. That is the ring broken, in one line of output.

(The closing line is the third message this week written for the broken
version of its floor. Read it as the table being astonished.)

**Checkpoint.** You should be able to say, without looking: which fork
each philosopher held in the stalled run, who was waiting on whom, and
why one philosopher reaching in the other direction is enough to make the
ring impossible rather than merely unlikely.

**8. File it.** In `check/answers.txt`:

- **`A5:`** — all five philosophers by name, with what each was holding
  and what each was waiting for when the table stalled. One line, in your
  own words; it will be a long one and that is fine.
- **`A6:`** — **one sentence** stating the rule you applied. Not what you
  typed — the rule. A sentence somebody could follow without seeing your
  code. Name the thing that gets taken in order — the forks at this table,
  or locks in general — and say what your rule does to that order. The
  general form is the better answer and the slot will take it.

**9. Claim the seal** — from `labs/week-06`:

```sh
cd ..
make -C check m4
```

Expected:

```
  ~~~ WAX SEAL of the Guild: C09D3B72 ~~~
  (Paste this seal into your logbook under Milestone 4.)
```

(The seal code is yours, not this one.)

Paste it under **Milestone 4** with the description from step 4 written
out in full. This is the part of the week the examination asks about; do
not summarise it into two lines.

> **If you're lost, start here (Task 4).**
> - **The terminal seems wedged.** It is not. Wait five seconds and the
>   porter closes the sitting, or press Ctrl-C now. Both give you the
>   prompt back, and neither one damages anything.
> - **Every philosopher ate on the very first run, before you changed
>   anything.** Extraordinary but not impossible on a very slow or
>   very odd bench. Run it five more times; you want a stalled run to
>   describe. If it never stalls, say so in your logbook and describe the
>   stall from the ten lines the program prints anyway.
> - **You got `Meals served: 3 of 15` (or any number other than 0 or
>   15), not `0 of 15`.** `meals_served` is incremented with no guard of
>   its own across five threads, so on a loaded or unusual bench a
>   philosopher or two can slip a meal in before the ring fully closes.
>   Your bench is not broken and neither is the program. Describe the
>   ring exactly as you found it in the ten lines above the count — who
>   holds what, who waits on whom — and note the number you actually
>   got. A partial count is fine to hand in.
> - `error: 'first' undeclared`? The two new lines went inside the `while`
>   loop instead of above it. They belong with `left` and `right`, at the
>   top of `dine()`.
> - **It still stalls after your edit.** One of the two `lock` lines is
>   still using `left` or `right`. `grep fork_on_table starter/philosophers.c`
>   — you should see `first`, `second`, `second`, `first`, in that order,
>   and no `left` or `right` among them.
> - **It finishes but the output says "takes the fork on the left" still.**
>   You changed the locks and not the messages. Step 6 says to do both, and
>   the reason is in the sentence under it.
> - Seal says `philosophers.c` is unchanged from the shipped version? You
>   edited a copy, or your editor saved elsewhere. `git diff
>   starter/philosophers.c` should show your four changes.
> - Seal says A5 does not name all five? There are five at that table and
>   every one of them is in the same position. Names are printed by the
>   program itself.
> - Seal says A6 is not a rule? A6 wants the **rule**, not the diff: a
>   sentence about the order forks are taken in, which somebody could apply
>   to a different program tomorrow.

---

## Task 5 — Lever 07 *(~30 minutes → Seal M5)*

Put the compiler down. This one is `ls`, `stat`, `cat` and one lookup, and
it is the only part of this week that is not a program.

It goes last for a reason. You have now spent two sessions on what it
means for something to be **held** — a lock is taken by somebody, it is
held while they work, and it is released when they are done, and if it is
never released then whatever is behind it is behind it for good. Hold that
thought in your hand while you read the next three files.

**1. The signal box.** The north gallery's interlocking frame — the real
one, not the one you compiled — keeps its state in a directory:

```sh
ls -ln ~/enginehouse/interlocking/
```

`-l` is the long listing you know; **`-n` prints the owner and group as
numbers** instead of looking their names up first. Expected — your dates
will be your own, and the second number (the group) will be whatever your
own account's group is:

```
total 8
-rw-r--r-- 1 1849 1000 283 Sep 21 04:12 lever-07.lock
-rw-r--r-- 1 1000 1000 917 Sep 21 04:12 lock-record.txt
```

Two files. One of them is yours. **One of them is not.**

**2. Ask the file directly.** `stat` gives you a file's bookkeeping
without the listing around it, and `-c` lets you say which fields you
want:

```sh
stat -c 'owner uid %u   mode %a   %n' ~/enginehouse/interlocking/lever-07.lock
```

Expected:

```
owner uid 1849   mode 644   /home/<you>/enginehouse/interlocking/lever-07.lock
```

Mode `644`: the owner may write it, everybody else may only read it. You
are not the owner, so you cannot **edit** it — try, and the shell says
`Permission denied`. You *can* still delete it: removing a name is a
write to the *directory*, and the directory is yours. `rm` warns that the
file is write-protected, then takes it if you say yes; that warning is
the whole of the protection. This task never asks you to remove it, and
the reason is this week's lesson in another costume: the lock holds
because everything that touches the frame agrees to check it first,
exactly as your mutex holds because every thread agrees to take it
first. Neither one stops a party who declines to play along.

**3. Read the lock, and then read the record.**

```sh
cat ~/enginehouse/interlocking/lever-07.lock
```

Expected — 283 bytes, in full:

```
INTERLOCKING FRAME -- NORTH GALLERY -- LEVER 07 -- HELD
held-by-uid: 1849
session opened: 1851-09-18 18:40
taken: 1851-09-21 04:12
note: whatever took this lever is no longer on the floor. The lock
      outlived it. The frame will not release lever 07 while this
      file stands.
```

Then the signalman's record of the same event:

```sh
cat ~/enginehouse/interlocking/lock-record.txt
```

Expected:

```
SIGNAL BOX RECORD -- NORTH GALLERY INTERLOCKING FRAME
Brassbridge Enginehouse, Work Order No. 1851-06

  frame ............ north gallery, levers 01-24
  lever ............ 07  (admits the single line)
  state ............ THROWN, and will not be worked back
  held by, uid ..... 1849
  held by, name .... -- the frame books numbers. It does not book names.
  taken ............ 21 September 1851, 04:12, before the early turn
  released ......... --
  holder present ... no. Nothing of that hand is on the floor, and
                     nothing of that hand is running.

  The frame will not release lever 07 while the lock stands beside this
  record, and the frame cannot tell you whose lock it is. It was never
  the frame's business to know. Numbers are kept here. Names are kept on
  the house roll, and the house roll will answer anyone who asks it
  properly.

  -- signed, the duty signalman, north gallery
```

**Stop and notice what you are looking at**, because you spent two
sessions earning the right to find it strange. A lock is held. The thing
that took it is not running. **That cannot happen** in any of the four
programs you wrote today: every one of them releases a lock on the same
thread that took it, before that thread ends.

Be precise about why, because the loose version of this is false. Nothing
releases a lock on your behalf when a thread ends — a thread that exits
while holding an ordinary mutex leaves it locked. Correctly written
threads release their locks *before* they terminate, and yours do. So a
lock that has outlived the thing that took it means one of three things:
an abnormal exit, a missing cleanup path, or a lock of a different kind
altogether. Whatever took lever 07 is off the floor, and the lock
outlived it.

This is a **stale lock** — a lock whose holder is gone — and it is one of
the genuinely hard problems in this trade, because from the outside a
stale lock and a busy one look exactly the same. The frame cannot tell
which it is. Neither can you, from the frame.

**4. Ask the house roll.** The record tells you where names live, and it
is deliberately not telling you the command. Here it is, and you have used
its cousin before: in Week 2 you read `/etc/passwd` by hand for the Kureos
commission. `getent` is the polite way to ask the same question — it goes
through whatever the system actually uses, file or otherwise:

```sh
getent passwd 1849
```

**I am not printing what comes back, and that is not coyness.** It comes
off your own bench, and the reading of it is the task. What you get is
one line with **seven fields separated by colons**, in this order:

```
name : password-placeholder : uid : gid : description : home directory : login shell
```

Count the colons and read the **fifth field** — the description, which
Unix has called the *GECOS* field since the 1960s for reasons that stopped
mattering about fifty years ago. It is free text, and on a well-kept
system it says what an account is **for**.

If you want just that field on its own:

```sh
getent passwd 1849 | cut -d: -f5
```

And read the last field too, while you are there. An account's login shell
is a plain statement about whether anybody is meant to log in as it.

**5. Write down what the roll says, and stop there.** You have four
facts now and they are all yours, from your own bench:

1. Lever 07 is held.
2. The lock is owned by uid 1849 and nothing of that uid is running.
3. The roll has an entry for 1849, and its description says what that
   account was for.
4. Its login shell says whether anybody was meant to sign in as it.

That is a **finding**, not a verdict. It says an account existed, that it
was set up for a stated purpose, and that something belonging to it took a
lever on the morning of the 21st and never gave it back. It does not say
who used it, when, or why, and nothing on your bench tells you that. Write
the four facts in your case notes, in the roll's own words, and let them
sit.

**Checkpoint.** Before you claim the seal you should be able to say all
four of those facts out loud, and say which command gave you each one. If
fact 2 is the one you cannot say plainly, that is the one worth sitting
with: a lock is released by whatever took it, so a lock still standing
when its holder is gone is a thing none of this week's four floors can
produce.

**6. File it.** In `check/answers.txt`:

- **`A7:`** — the **uid** from the lock record, and **what the roll says
  that uid was for** — the description field, in the roll's own words. Both
  on the one `A7:` line.

The account's **name** is not asked for and should not go in `answers.txt`.
The seal does not want it, the grader does not want it, and what you make
of it belongs in your own case notes.

**7. Claim the seal** — from `labs/week-06`:

```sh
make -C check m5
```

Expected:

```
  ~~~ WAX SEAL of the Guild: 6F82D115 ~~~
  (Paste this seal into your logbook under Milestone 5.)
```

(The seal code is yours, not this one.)

Paste it under **Milestone 5** with the four facts from step 5, each with
the command that produced it.

> **If you're lost, start here (Task 5).**
> - `ls: cannot access '/home/you/enginehouse/interlocking/'`? The bench is
>   not staged, or you reset it. `bash report-for-duty.sh` from
>   `labs/week-06` puts it back.
> - `ls -ln` shows your own name in the owner column instead of a number?
>   You typed `ls -l`. The `-n` is what turns names into numbers.
> - Both files show the **same** owner number? Then the staging did not
>   complete the one job it needed root for. Re-run
>   `bash report-for-duty.sh`; if it still comes back the same, take it to
>   your instructor rather than editing anything.
> - `getent: command not found`? Rare, but `grep '^[^:]*:[^:]*:1849:'
>   /etc/passwd` reads the same line straight out of the file, exactly as
>   you did in Week 2.
> - `getent passwd 1849` prints nothing at all? The roll entry is missing.
>   `bash report-for-duty.sh` restores it. (It is the one thing `--reset`
>   deliberately leaves alone, because later weeks stand on it.)
> - **You deleted the lock.** Not a fault, and not a refusal — the
>   directory is yours, so the name was yours to remove. That is step 2's
>   point. `bash report-for-duty.sh` puts it back.
> - Seal says A7 has no uid in it? It wants the number as a numeral, on the
>   `A7:` line.
> - Seal says A7 does not carry what the roll says the account was for?
>   Read the **fifth** colon-separated field, and copy it as the roll spells
>   it. Do not paraphrase it into one word.

---

## Case notes — the week's entry

Open `case-notes.md` (repo root) and fill the Week 6 row: what you found,
the command that showed it to you, and what you make of it.

Copy these **exactly**, and copy them as strings rather than paraphrasing:

- The `held-by-uid:` line, the `session opened:` line and the `taken:`
  line from `lever-07.lock` — all three.
- The `holder present ...` lines from `lock-record.txt`, in full.
- The roll's **description** field for uid 1849, word for word, and the
  login shell it carries.

Three questions to write toward, none of which has an answer in this work
order:

1. Every lock you built this week is released by the thread that took it,
   and a thread that has ended has nothing left to release. Lever 07's
   lock is held by something that is not running. In the strictest
   possible terms: **what must have happened** for a lock to outlive its
   holder?
2. The frame books the holder by number and refuses to book the name. The
   record says that is not the frame's business. Who *does* it serve, to
   keep those two records in two different places?
3. The lock carries two dates: a session opened on the evening of Friday
   the 18th, and the lever taken at 04:12 on the 21st — the day this
   work order was written, before the early turn came on. What kinds of
   work happen at that hour, and who is normally on the floor to see
   them? And what would have to be true for both dates to belong to the
   same hand?

Write a plain guess rather than a careful hedge. The notebook is marked on
being kept honestly, never on being right early.

## Reflection (both prompts go in your logbook)

Answer in your own words. I am after your judgment, not the manual's.

1. You used four different tools this week: a mutex, a condition variable,
   two semaphores, and a reader/writer lock. In a paragraph each for any
   **three** of them, say what the tool does that the others cannot, and
   name a situation where reaching for the wrong one would produce a
   program that is correct but useless. Use the words *critical section*,
   *bounded buffer* and *starvation* correctly at least once each.
   *zyBooks Ch 4.2–4.5.*
2. The long table stalls because every philosopher follows the same
   reasonable rule at the same time. Nobody is greedy and nobody is wrong.
   In two or three sentences: **what does that tell you about testing?**
   Specifically — your fixed table ran fifteen meals in under a second,
   three times out of three. What would you need to see before you were
   willing to tell the Guild that a piece of concurrent machinery is safe,
   given that "I ran it and it worked" is the same sentence a student says
   about a program that stalls once a fortnight? (There is no answer key. I
   am asking what standard you hold yourself to.)

## Turn it in

Due **Sunday, September 27, 11:59 pm**, on **Canvas** (per
[`syllabus/schedule.md`](../../syllabus/schedule.md)):

1. **`logbook.md`** — all five milestones: what you did, the seal pasted
   in, what it means. M1 wants the broken and fixed tallies and the
   two sentences about the idle looks; M2 wants what each semaphore
   counts and why the mutex is still needed; M3 wants the torn page walked
   through in your own words and one sentence on starvation; **M4 wants the
   full five-philosopher description written out** — that is the graded
   centre of the week; M5 wants the four facts with the command that
   produced each. Plus both reflection prompts and the time-spent line.
2. **`case-notes.md`** — your running notebook with its Week 6 entry.

Upload both files to the Week 6 assignment. (`check/answers.txt` stays in
your repo — the seals already vouch for it.) When your paperwork is in,
you may `bash report-for-duty.sh --reset`. It takes the lever and its
record away and leaves the house roll alone; later weeks are standing on
that roll.

That closes all five objectives: Task 1 is objectives 1 and 2, Task 2 is
objective 3, Task 3 is objective 4, Task 4 is objective 5, Task 5 is what
objectives 1–5 are *for*, and the reflections are all of them in your own
words.

**Also on this week's docket.** Three dates:

- zyBooks **Ch 4.2–4.5** — semaphores, monitors and the classic
  synchronization problems — due **Wednesday** before class. Sections 4.2
  and 4.3 make Task 1 obvious instead of magic; 4.4 is Task 2; 4.5 is
  Tasks 3 and 4. Do it first if you can.
- **Commission II — *The Speaking-Tube Console*** (zyBooks 12.2, "HUSH") is
  under way and due **Friday, October 16, 11:59 pm, in zyBooks** — not
  Canvas. That is four weeks out and it is the last quiet stretch you will
  get before it: Week 7 is a full week, Week 8 is the examination. If you
  have not opened it yet, open it this week. The cover is at
  [`commissions/02-speaking-tube-console.md`](../../commissions/02-speaking-tube-console.md).
- An **open HUSH workshop** runs **Friday, October 9** — bring whatever you
  have, finished or not. It is the Friday of examination week and it is
  there so that HUSH does not land on you the week after.

> `SUBMISSION: EXPECTED BY SUNDAY 11:59 PM.`
> `WAX SEALS: FIVE. A LONG WEEK. ADMIRED TWICE.`
> `LEVER 07: STILL THROWN. THIS PORTER DID NOT TOUCH IT.`
> — punched chit, affixed by Porter Brassfeather

## For the curious *(worth no points, ever)*

Not required, not graded, not a trap.

- `man 3 pthread_cond_wait` is the one to read first, and read the
  paragraph on **spurious wakeups** twice. It is the reason for the
  `while` loop, and it is the single most common thing people get wrong
  about condition variables. `man 7 sem_overview`, `man 3 sem_wait` and
  `man 3 pthread_rwlock_rdlock` cover the rest of this week's tools.
- **Watch the starvation you avoided.** In `ledger-hall.c`, comment out
  Edit 4's block and declare the lock the simple way instead —
  `static pthread_rwlock_t page_lock = PTHREAD_RWLOCK_INITIALIZER;`.
  Rebuild and run it. Every page still balances; the program takes
  **minutes** instead of a second or two, because six readers at a tight
  rail never all step back at once and the clerk almost never gets the
  pen to the page. Ctrl-C whenever you are satisfied. A lock that is
  perfectly correct and hands out turns unfairly is a real category of
  fault, and you have now seen one.
- **Break the ring the other way.** Instead of ordering the forks, leave
  the rule as left-then-right and have exactly **one** philosopher — say
  seat 4 — do it backwards. That is enough on its own, and it is worth
  proving to yourself with the drawing rather than with the compiler. Then
  ask which of the two fixes you would rather defend in a code review of a
  program with nine hundred locks in it.
- **Make the chute bigger and smaller.** Change `#define CHUTE 8` to `1`
  and then to `256`, rebuild, and watch the split between the two sorters
  and the run time. A chute of 1 is a hand-off; a chute of 256 is a
  buffer. Neither loses a card. Buffer size is a performance decision, not
  a correctness one — **once the bound is enforced.**
- **A tool that finds races without you.** Rebuild any of this week's
  floors with debug symbols (`gcc -Wall -Wextra -g -pthread -o lh-g
  starter/ledger-hall.c`) and run `valgrind --tool=helgrind ./lh-g`
  (install `valgrind` if your bench lacks it). On the unguarded build it
  names the exact lines and says `Locks held: none`; on your fixed build
  it goes quiet. It runs perhaps fifty times slower and it is worth it.
- **`sem_getvalue`** will tell you what a semaphore's number currently is.
  Read `man 3 sem_getvalue` and then read the paragraph explaining why you
  almost never want to: by the time you have the number it may be wrong.
  There is a general lesson in that about every "just check the state
  first" instinct you will ever have.
- The four district names in `ledger-hall.c` are the same four you added
  up by hand last week, and the opening figures are last week's working
  papers in pence. Nobody made you notice that. It is the sort of thing
  worth noticing.

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"A lock that is never released is not a lock. It is a wall."*
