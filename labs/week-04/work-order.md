# WORK ORDER No. 1851-04 — Honourable Guild of Enginewrights

*Ex Vapore, Ordo — "From steam, order."*

| | |
|---|---|
| **To** | The Apprentice Cohort of 1851, at their benches |
| **From** | By hand of **Chief Enginewright B. Marlowe** |
| **Dated** | Monday, 7 September 1851 — thirteen weeks to the Exhibition |
| **Due** | **Sunday, September 13, 11:59 pm** — `logbook.md` + `case-notes.md` on Canvas |

---

## Situation

Every afternoon at three o'clock the gallery doors open for the Public
Demonstration: schoolchildren, aldermen, one alderman's tea. Every
afternoon at **fourteen minutes past three**, to the minute, the looms
stutter. Rates fall to nothing. The tea goes cold. And before the half
hour it is all mysteriously well again — every day, on the same minute,
like a train that runs on an embarrassment timetable.

Machines wear. Wear does not keep appointments.

The Engine does not observe bank holidays, and neither, this morning,
does the gallery: the doors open at three as they do every day of the
year, and at fourteen minutes past, as on every other day, something
goes wrong on time.

The **Dispatch Board** is the Overseer's office that decides, every
instant, which job gets an engine and which job waits — and something
has gotten into its standing orders. This week you learn to read that
office the way an enginewright must: what **priority** is, what
**courtesy** (`nice`) buys, how to watch the floor live (`top`), how the
Board keeps its **appointment book** (`cron`), and what the two big
levers beyond courtesy do — the **real-time class** and the
**governor**. Then you will catch the 15:14 trouble in the act, trace it
to its paperwork, and strike it out with your own hands.

Report for duty. — *B.M.*

## Your objectives (the real ones, in plain English)

Your laptop is running several hundred processes on a handful of
cores, and it feels as though all of them run at once. They do not.
Something decides, thousands of times a second, who works and who
waits — and "who waits" is a policy, chosen by people, with winners
and losers. This week you watch that policy operate and then you
change it yourself. The fiction is set dressing and the commands are
the course; **no task ever requires story knowledge.** By Friday you
will be able to:

1. **Say what a CPU scheduler does** — ready queues, time slices,
   priorities, and what "starvation" means — *zyBooks 3.1–3.2*.
2. **Read and steer the floor**: watch processes compete in `top`, set
   courtesy with `nice`, change it on a running job with `renice`.
3. **Read a cron schedule** — the five fields, what fires when — and
   remove a user crontab entry without harming the rest.
4. **Demonstrate two stronger levers** — a `SCHED_FIFO` real-time job
   and a cgroup CPU quota — and say when each is the right tool and
   when it is a loaded engine — *zyBooks 3.3*.

## Provisions

**P1 — Your working Linux environment.** Any bench that passed Week 1's
smoke test is ready: this week uses `top`, `nice`, `renice`, `ps`,
`crontab`, `chrt`, and `systemd-run`. Five of those are on every Linux
there is. Two can be absent on a hand-built bench: `crontab`, if the
bench keeps no appointment book at all, and `systemd-run`, which needs
a systemd *user session*. Both have a documented way round in the task
that uses them — the drill for the first, a `nice`-only demo for the
second — so neither can strand you. If your environment broke over the
holiday weekend,
[`setup/getting-started.md`](../../setup/getting-started.md) rebuilds
it.

**P2 — This folder, open in TWO Linux terminals.** Not a luxury this
week — the looms will keep the first terminal talking, and you will
work from the second. Open two, and in **each** run the line that
matches your setup:

```sh
cd ~/comp3100-student/labs/week-04
```

Windows/WSL2 with the repo on the Windows side (Tab completes the path):

```sh
cd /mnt/c/Users/<YourWindowsName>/comp3100-student/labs/week-04
```

macOS/Multipass with your Mac's clone mounted into the VM:

```sh
cd ~/comp3100/labs/week-04
```

**P3 — Report for duty.** One command stages your bench for the week:

```sh
bash report-for-duty.sh
```

Expected output:

```
  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-04 :: bench staged and verified
  ------------------------------------------------------------------
   Forge:     labs/week-04/starter   (one loom pattern: loom-job.sh,
              plain shell, yours to read -- honest work, counted)
   Floor:     the Public Demonstration falters DAILY AT 15:14 --
              fourteen minutes past three -- and is well again
              before the half hour, every day, to the minute.
              Something on this bench keeps that appointment now.
   Drill:     bash report-for-duty.sh --drill   calls the same
              trouble onto the floor at once, for ninety seconds,
              so Friday need not wait for the clock.

   Catch it in the act. Find its appointment. Strike it out
   properly.   (bash report-for-duty.sh --reset withdraws all.)
  ------------------------------------------------------------------
```

Read the slip twice, then the script's own header once — it says
plainly what it touches. The short of it: one working part under
`~/enginehouse/machinery/`, **one line added to your user crontab**
(marked, and removed by `--reset` — every other line of your crontab,
if you keep any, is preserved untouched, staged and struck alike), and,
when the appointment falls due or you call `--drill`, jobs that hold
the CPU for ninety seconds and then stand down by themselves. No
network, no files outside your bench. What those jobs *are* is the
week's detective work, so the pattern ships sealed.

> **One disclosed sudo, and only if needed.** The appointment can only
> fire if the **cron service** is running. On most benches it already
> is. If yours has it stopped (some WSL setups), the staging script
> says so out loud and offers exactly one command:
> **`sudo service cron start`** — *what it does:* starts the standard
> system cron daemon, the same one every Linux box runs; *why it is
> safe:* it starts a stock service and changes nothing else; *the
> command, and no other:* the script never runs anything else under
> sudo. If it cannot start (containers), the `--drill` flag covers
> every task anyway.

**P4 — Your paperwork.** Two copies, each made once:

```sh
cp ../templates/logbook-template.md logbook.md
cp check/answers-template check/answers.txt
```

`logbook.md` is this week's report. `check/answers.txt` holds five
short answers (A1–A5) that the seal checks read; the template says what
goes where, and the tasks tell you when. Your running `case-notes.md`
is already at the repo root.

> **If you're lost, start here (Provisions).** Two terminals and a
> service that may need starting — none of that is graded. Work the
> list, then bring whatever is still stuck to studio.
> - Run `pwd` in both terminals. Each should end in `labs/week-04`.
>   If not, re-run the `cd` line from P2 that matches your setup.
> - `pwd` prints something like `C:\Users\...`? You're in PowerShell,
>   not Linux. Type `wsl` and press Enter, then re-run the `cd` line.
> - Staging said the standing orders carry 0 such lines? Run
>   `bash report-for-duty.sh` again — it is safe, idempotent, and
>   never posts the same line twice.
> - The sudo note appeared and you don't know the password? Most of
>   you will never be asked for one: Paths A and B (WSL2 and
>   Multipass) both come with passwordless sudo, so the
>   command simply runs. If you *are* prompted — a native Linux bench
>   (Path C), or a distro you built yourself rather than from
>   `setup/` — it wants your own account's login password, the one you
>   chose when you created the user; there is no separate course
>   password anywhere. Either way the drill covers every task,
>   service or no service.

---

## Task 1 — An honest shift *(~20 minutes → Seal M1)*

Before you can measure the 15:14 trouble you need an instrument. Yours
is in the forge, and unlike some things staged this week, it is in the
clear.

**1. Read it:**

```sh
cat starter/loom-job.sh
```

Sixty-odd lines of plain shell: rule a card, checksum it character by
character, next card, forever — and every two seconds it reports its
true working rate and its own **courtesy** (its `nice` value, read
fresh each report). No files, no network. When its number falls, it is
being starved of engine time; when the number rises, the time came
back. That number is the week's instrument.

**2. About courtesy.** Every ordinary job carries a nice value from
**−20 to 19**. The default is 0. Higher is *more courteous* — the job
offers to wait when others want the engine. Any user may raise their
own job's courtesy; only root may lower one. It is called *nice* in
every manual since the seventies, and it is exactly what it sounds
like: you cannot demand a bigger share, but you may politely take a
smaller one.

**3. Start two looms at full courtesy** — in your **first** terminal:

```sh
nice -n 19 bash starter/loom-job.sh north &
nice -n 19 bash starter/loom-job.sh south &
```

Expected (your rates are your own; they settle after the first report
or two, and the two looms will not agree exactly). **Every sample
number in this work order came off one modest bench: a faster machine
with more engines reads lower per loom, and that is not a fault.** No
seal ever compares your figures with the printed ones:

```
[1] 4823
[2] 4824
loom north:     4483 lines/sec   (courtesy 19)
loom south:     4491 lines/sec   (courtesy 19)
loom north:     4587 lines/sec   (courtesy 19)
loom south:     4638 lines/sec   (courtesy 19)
```

Leave them talking. That terminal now belongs to the looms until Task 2
is done. (Press Enter there any time you need to convince yourself the
prompt is still yours; the looms stop with `kill %1 %2` — `%1` and
`%2` are the job numbers bash printed in brackets when you
backgrounded them — but **not yet**.)

**4. Watch the floor watch itself.** In your **second** terminal:

```sh
top
```

Three keys while it runs, worth memorizing this week: **`1`** shows
every engine (CPU) on its own line, **`c`** shows each job's full
command instead of its short name, **`q`** quits. Find your looms
(with `c` pressed they read `bash starter/loom-job.sh north` and
`south`), then read their row: **`NI`** is courtesy — 19; **`S`** is
state — `R`, running; **`%CPU`** is the interesting one.

Look at it carefully: two looms at maximum courtesy, and each is taking
**a whole engine** — `%CPU` near 100. Courtesy is not a brake.
**On a quiet floor, courtesy costs nothing**: nice settles who *waits*
when jobs compete, and nobody is competing yet. Write that sentence in
your logbook now; Task 2 is about to make it matter.

**5. File the baseline.** Open `check/answers.txt` and fill **`A1:`**
with your looms' settled rates — copy a rate line for each (or both
numbers on one line). These are the healthy numbers; everything in
Task 2 is measured against them.

**Now claim the seal** — from `labs/week-04` in the second terminal,
**while both looms are still running** (the check looks at the live
floor: two looms, courtesy 19):

```sh
make -C check m1
```

Expected:

```
make: Entering directory '.../labs/week-04/check'
  ~~~ WAX SEAL of the Guild: 6F20C9A4 ~~~
  (Paste this seal into your logbook under Milestone 1.)
make: Leaving directory '.../labs/week-04/check'
```

(The seal code is yours, not this one.)

Paste your seal under **Milestone 1** with two or three sentences: what
the looms report, what `top`'s NI and %CPU columns showed, and why full
courtesy on a quiet floor still means full speed.

> **If you're lost, start here (Task 1).**
> - `loom-job: this loom wants bash 5 or newer`? Run `bash --version`.
>   Any bench built by this course's setup has bash 5; if yours is
>   older, rebuild from `setup/getting-started.md`.
> - Loom rate lines interleave oddly, or a report lands mid-typing?
>   Two background jobs share that terminal — that is why it belongs
>   to the looms now. Work from the second terminal.
> - `top` shows the looms' %CPU nearer 50 than 100? Your bench has
>   fewer engines than looms, or a browser is eating the floor. Note
>   the number honestly and carry on — the *collapse* in Task 2 is
>   what matters, not the healthy figure's exact size.
> - The seal says fewer than two looms? They stopped (a closed
>   terminal takes its background jobs with it). Re-run both
>   `nice -n 19 ...` lines and claim again.
> - The seal says courtesy is not 19? You started a loom without
>   `nice -n 19`, or an extra loom is running from experiments. Stop
>   extras (`kill %3`, or `pkill -f 'bash.*loom-job'` and restart the
>   two), then claim again.

---

## Task 2 — Fourteen minutes past three *(~40 minutes → Seal M2)*

The Demonstration's trouble keeps a schedule, and you have a bell that
rings it on demand. You will run the drill **three times**: once to
feel it, once to hunt it, once to beat it. Each drill lasts ninety
seconds and sweeps up after itself; the script never stacks two, so if
it says the floor is occupied, wait for quiet and call it again.

**1. First sitting — feel it.** Second terminal:

```sh
bash report-for-duty.sh --drill
```

(A drill slip prints — read it once; it repeats the rules: ninety
seconds, self-cleaning, never stacks.) Now watch your **first**
terminal — the looms:

```
loom north:     4762 lines/sec   (courtesy 19)
loom south:     4732 lines/sec   (courtesy 19)
loom north:     1983 lines/sec   (courtesy 19)
loom south:        8 lines/sec   (courtesy 19)
loom north:        9 lines/sec   (courtesy 19)
loom south:        7 lines/sec   (courtesy 19)
```

(The odd `1983` is honest too: that report's two-second window
*straddled* the bell — half measured in peacetime.) From four and a
half thousand to single digits. The looms are not
broken, not blocked, not sleeping — `top` will show them ready and
willing. They are **starved**: everything else on the floor suddenly
outranks them. In the second terminal, run `top`, press `1` and `c`,
and read the floor: every engine pegged, and at the head of the table
a crowd of `sh` jobs — twice as many as you have engines — every one
at courtesy **0**, every one taking roughly half an engine. Your
courtesy-19 looms are at the bottom of the queue for every single
engine, and their share rounds to almost nothing.

Note the **worst rate** a loom reports — that number is **`A2:`** in
`check/answers.txt`. Write it as a numeral: on a floor with many
engines the worst report really can be a flat `0`, and `0` is the
right answer — not the word "zero", which the seal cannot read.

Then just watch. Ninety seconds after its bell, the whole crowd
vanishes on its own, and your looms' next report is back near
baseline. **What stands down by itself was built to stand down.**
Wear does not do that either.

**2. Second sitting — hunt it.** Call the drill again, get into `top`
(`c` pressed), and this time take a name and a number: pick any one of
the `sh` crowd and note its **PID**. Quit `top` and ask `ps` for that
job's card — pid, parent, courtesy, and full command (use *your* pid,
not mine):

```sh
ps -o pid,ppid,ni,args -p 26745
```

Expected:

```
    PID    PPID  NI COMMAND
  26745   26735   0 sh -c while :; do :; done amendment-314-burner
```

Read the card. The work is `while :; do :; done` — a do-nothing loop
that eats an engine whole, honest work's exact opposite. And the last
word on the card is a **name**. Jobs on this floor are dispatched under
job-card names — so who dispatched two dozen of these? Ask the parent
(the `PPID` — again, yours, not mine):

```sh
ps -o pid,ppid,ni,args -p 26735
```

Expected:

```
    PID    PPID  NI COMMAND
  26735       1   0 /bin/sh /home/you/enginehouse/machinery/amendment-314.sh
```

(Your `PPID` column may read `1` or a bigger number that isn't any
shell of yours — Week 3 taught you exactly what that means, and where
the climb ends.) There is the dispatcher: a script, sitting in your own
enginehouse's machinery room, keeping the works standing until it is
time to sweep them away. Let this sitting stand down while you go read
it.

**3. Read the paper:**

```sh
cat ~/enginehouse/machinery/amendment-314.sh
```

The top of that file is not a normal comment block, and I will not
reprint it here — it deserves to be read at your own bench, in full,
once with your voice. It is drafted like the minutes of a committee:
*WHEREAS ... BE IT AMENDED ... moved, seconded, and carried.* Note,
against your own measurements, what it provides for: works **twice the
count of engines**, owing **no courtesy**, standing down after
**ninety seconds** — and one more provision, about renewing itself
**daily**. Copy the paper's signature line — the one beginning `By
order of` — into your case notes exactly as it appears, leading `#`
and all.

Then look below the paper at the few lines of live shell, which you
can now read fluently: a loop that dispatches the works, and a
`stand_down` that ends them. But *nothing in this file runs itself
daily.* A script is not a schedule. Something else turns the handle —
and it does it at 15:14.

**4. The appointment book.** The Dispatch Board keeps one per user, and
it is called the **crontab**: a little table of standing appointments
that the system's dispatch office (`cron`) reads every minute of every
day. Look at yours:

```sh
crontab -l
```

Expected — one line you did not write (shown here as much as I am
willing to copy into a work order; read the whole of it at your bench):

```
14 15 * * * $HOME/enginehouse/machinery/amendment-314.sh # [ the rest is yours to read ]
```

A crontab line is **five schedule fields, then a command**:

| Field | Meaning | On this line |
|---|---|---|
| 1st | minute (0–59) | `14` |
| 2nd | hour (0–23) | `15` |
| 3rd | day of month | `*` — every one |
| 4th | month | `*` — every one |
| 5th | day of week | `*` — every one |

Minute **14**, hour **15**: the appointment fires at **15:14 — 
fourteen minutes past three, every single day.** There is your
timetable of embarrassment, in one line of standing orders. (The tail
of the line after `#` is a comment — cron hands the whole command to a
shell, and the shell ignores everything past the `#`. It is there for
the reader. Read it.) Fill **`A3:`** in `check/answers.txt`: the two
numbers, which is the minute, which is the hour, and the time of day
they name.

**5. Strike it out.** First, the wrong lever, so you never pull it:

> **NEVER `crontab -r`.** The `-r` flag removes your **entire**
> crontab — every appointment you keep, not just the bad one. There is
> no undo and no wastebasket. An enginewright strikes out one line; a
> vandal burns the book. (If you burn yours anyway, the lost-box below
> has the recovery.)

The right surgery filters the book and reposts it: list the book,
`grep -v` away exactly the offending line, hand the result back to
`crontab`. One pipeline:

```sh
crontab -l | grep -v 'Amendment No. 314' | crontab -
```

Verify the surgery:

```sh
crontab -l
```

Expected: the amendment line is gone, and **every other line — if you
keep personal appointments there — is untouched**. If your book held
only that one line, `crontab -l` now prints **nothing at all**: the
book is still there, and empty. (If instead it says `no crontab for
you`, the book itself is gone rather than emptied — see the
if-you're-lost box.) Tomorrow at 15:14, nothing fires. The
Demonstration is safe, and it cost you one line.

**6. Third sitting — the counter-move.** Striking the appointment
stops *tomorrow's* trouble. Now practice fixing an outbreak that is
*already running* — without killing anything. Call the drill once
more, confirm in your first terminal that the looms have collapsed,
and then, in the second terminal, find the whole crowd by the job-card
name you learned in step 2. `pgrep -f` matches the **whole command
line**, not just the program name — which is the only thing that works
here, because every burner's program name is plain `sh`:

```sh
pgrep -f amendment-314-burner
```

Expected: a column of pids, twice your engine count. Now **renice**
them — courtesy can be
*changed on a running job*, and raising another job's courtesy is the
one direction that needs no root:

```sh
renice -n 19 -p $(pgrep -f amendment-314-burner)
```

Expected (one line per pid):

```
26745 (process ID) old priority 0, new priority 19
26746 (process ID) old priority 0, new priority 19
...
```

Now watch the first terminal. The burners are all still running — you
killed nothing — but the looms climb from single digits to a real
share within a report or two:

```
loom north:        9 lines/sec   (courtesy 19)
loom north:      213 lines/sec   (courtesy 19)
loom south:     1101 lines/sec   (courtesy 19)
loom north:     1075 lines/sec   (courtesy 19)
```

Not baseline — the floor is still carrying twenty-odd jobs, and at
equal courtesy everyone gets a *fair* slice rather than a big one —
but two orders of magnitude better, bought with one command and no
casualties. When the sitting stands down, baseline returns by itself.
This is the whole lesson of the ready queue in one afternoon:
**priority decides who starves; fairness decides who survives.**

**7. Claim the seal** — from `labs/week-04` (the check reads your
crontab and your answers):

```sh
make -C check m2
```

Expected:

```
  ~~~ WAX SEAL of the Guild: B81E37D5 ~~~
  (Paste this seal into your logbook under Milestone 2.)
```

(The seal code is yours, not this one.)

Paste it under **Milestone 2** with a short narrative — the collapse
(numbers), the hunt (PID to parent to paper to appointment book), the
strike-out, and the renice. This is the week's centerpiece; give it
five or six honest sentences.

> **If you're lost, start here (Task 2).**
> - `--drill` says the floor is already occupied, and no drill slip
>   prints? A sitting is still standing — the refusal tells you about
>   how many seconds remain. Wait for quiet, then call again.
> - The looms' rates did NOT collapse? Either the looms aren't at
>   courtesy 19 (check `top`'s NI column) or your bench has many more
>   engines than the works can cover. Record what you see; the
>   contrast with step 6 still teaches.
> - The `sh` crowd is gone before you could read a PID? Ninety
>   seconds is ninety seconds. Call the drill again — it is
>   repeatable by design, and no sitting leaves anything behind.
> - `ps -o ... -p <pid>` prints only the header? That pid stood down
>   already. Fresh drill, fresh pid.
> - `crontab -l` says `no crontab for you` **before you reach step
>   5**? Staging never posted the appointment on this bench. If the
>   `crontab` command is missing entirely, m2 forgives that outright
>   and the drill still teaches the week; if the command exists but
>   the book does not, re-run `bash report-for-duty.sh`, watch it for
>   an error, and tell me if it repeats.
> - `crontab -l` prints **nothing at all** after step 5? That is
>   exactly right — the book is still there and merely empty, because
>   you struck the last line out of it. **Do not re-stage.**
>   `bash report-for-duty.sh` posts the appointment straight back, and
>   m2 will refuse the seal. If m2 fails, re-read `crontab -l` and
>   check your grep, not your staging.
> - `crontab -l` says `no crontab for you` **after step 5**? Different
>   thing, and worth knowing the difference: the book itself is gone,
>   not emptied. That is what `crontab -r` does — see the next entry.
> - **You ran `crontab -r`.** The whole book is gone, including the
>   line the seal wants you to have *removed with grep* — and
>   including any personal lines, which nothing can restore (that is
>   the lesson, learned the honest way). Recover the lab's part:
>   `bash report-for-duty.sh` reposts the amendment line (only that
>   line — it cannot resurrect your own), then do step 5 properly
>   with the pipeline.
> - `renice: Operation not permitted`? You tried to renice a job
>   *down* (toward more priority), or a job that isn't yours. Raising
>   courtesy on your own jobs is always allowed; everything else is
>   root's business.
> - Rebooted / WSL restarted mid-task? The crontab line survives a
>   reboot (that is rather the point of a crontab); drills and looms
>   do not. Restart the looms, call a fresh drill, carry on.

---

## Task 3 — The two governors *(~25 minutes → Seal M3)*

Courtesy settles disputes among equals. This task shows you the two
levers that do not negotiate: the **real-time class**, which outranks
the entire courtesy system, and the **governor** (a cgroup CPU quota),
which caps a job's steam no matter its rank. One demo each. First,
two housekeeping matters: **claim seal M1 now if you have not** — it
reads the live floor, so it will not pass once these looms are down
— and then **stop them** (`kill %1 %2` in the first terminal).
Task 3 brings its own subjects, and it needs a quiet floor to
measure against.

**1. The real-time class.** Ordinary jobs — every loom, every burner,
your shell — live in the **timesharing class** (`ps` calls it `TS`),
where nice values matter. Ask about your own shell:

```sh
chrt -p $$
```

Expected:

```
pid 26285's current scheduling policy: SCHED_OTHER
pid 26285's current scheduling priority: 0
```

`SCHED_OTHER` is the timesharing world you have lived in all course.
Above it sits `SCHED_FIFO`: real-time, priorities 1–99, and a brutally
simple rule — **a FIFO job runs until it blocks or yields, and every
FIFO priority outranks every timesharing job on the engine.** Courtesy
is not consulted. That is what it is *for* — motor control, audio,
things that must never wait — and it is why it needs root.

> **THE LEVER GUARD — this step uses sudo.**
> *What it does:* runs one do-nothing loop in the real-time FIFO class
> at priority 50, **in the foreground of your second terminal**, until
> you press Ctrl-C.
> *Why it is safe here:* your bench is a personal WSL instance or VM
> with several engines — one FIFO job can seize only one of them, and
> the kernel additionally reserves a small slice of every engine (its
> real-time throttle) precisely so a runaway real-time job cannot wall
> out the world. **Never run this on a shared or single-engine
> machine you care about** — that is not caution theater; a FIFO spin
> on the only engine makes a machine effectively unusable.
> *The exact command, and no other:*
> `sudo chrt --fifo 50 sh -c 'chrt -p $$; while :; do :; done'`
> *How it ends:* **Ctrl-C**, in that terminal. Nothing survives it.
> *If that box gave you pause:* that is the box doing its job, not a
> sign you are out of your depth. Read it once more, check your bench
> against it, then run it — one command in, one key out.

Run it:

```sh
sudo chrt --fifo 50 sh -c 'chrt -p $$; while :; do :; done'
```

Expected — it reports its own policy, then holds the engine until you
Ctrl-C:

```
pid 26365's current scheduling policy: SCHED_FIFO
pid 26365's current scheduling priority: 50
```

Copy that policy line into **`A4:`** (yours, with your pid). While it
spins, open your **first** terminal and look at its card (your pid):

```sh
ps -o pid,cls,rtprio,ni,comm -p 26365
```

Expected:

```
    PID CLS RTPRIO  NI COMMAND
  26365  FF     50   - sh
```

Read the columns: class `FF` (FIFO), real-time priority 50, and **NI
is a dash**. Courtesy does not apply. Try `renice -n 19 -p <pid>` and
you are refused — the job is root's, not yours. Even under `sudo` the
renice *succeeds* and changes nothing: the nice value is recorded but
never consulted while the task is in the real-time class, which is why
NI still reads `-`. Then go back to the second terminal and **Ctrl-C**
the demo. Confirm the prompt returns.

**2. The governor.** The opposite lever: instead of outranking the
queue, cap the steam. A **cgroup CPU quota** tells the scheduler "this
group of jobs gets at most such-and-such fraction of an engine,"
enforced no matter the courtesy. It governs the ordinary class; the
real-time class from step 1 answers to a throttle of its own, which is
why the demo below governs an ordinary loom. Your desktop uses it to
keep background indexers from eating laptops; the Guild would call it
a **centrifugal governor** — the spinning brass balls that close a
steam valve when the engine runs too fast.

First a reference number: an ungoverned loom at courtesy 0, in the
second terminal — let it report two or three times, note the rate,
then Ctrl-C:

```sh
bash starter/loom-job.sh reference
```

Now the same loom under a 20% governor (`systemd-run --user` asks your
own user manager — no sudo — to run the command in a fresh **scope**,
a cgroup of its own, with the quota bolted on):

```sh
systemd-run --user --scope -p CPUQuota=20% bash starter/loom-job.sh governed
```

Expected:

```
Running as unit: run-r4f631a2f83a44c1a8b8e52a72e00b1a5.scope; invocation ID: 5ba1f837183d46af8d70038b0b02c2e4
loom governed:    788 lines/sec   (courtesy 0)
loom governed:    719 lines/sec   (courtesy 0)
loom governed:    753 lines/sec   (courtesy 0)
```

Read it against your reference: **courtesy 0 — the ordinary default,
as demanding as an unprivileged job gets — and a fraction of the work
gets done.** The cap is exact (at most a fifth of one engine); the
achieved rate runs under it, since the loom pays its own overheads out
of the ration, and the toll varies run to run — somewhere between a
twentieth and a fifth of reference is a healthy reading. The cap is
the point, not the fraction.
The governor does not care who you are; it meters the steam. Ctrl-C ends
the loom and its scope together. Copy one settled governed rate line
into **`A5:`** exactly as printed.

(Think back to 15:14. Courtesy was one fix. Which of *these* two
levers could have protected the Demonstration, and what would each
have cost? That is Reflection 1.)

**3. Claim the seal** — from `labs/week-04`:

```sh
make -C check m3
```

Expected:

```
  ~~~ WAX SEAL of the Guild: 0A4D62FB ~~~
  (Paste this seal into your logbook under Milestone 3.)
```

(The seal code is yours, not this one.)

Paste it under **Milestone 3** with two or three sentences: what `FF`
outranks, what the quota caps, and one sentence on which lever you
would trust near a Public Demonstration.

> **If you're lost, start here (Task 3).**
> - `chrt: failed to set policy: Operation not permitted`? You ran it
>   without `sudo`. Real-time class changes are root's to grant.
> - The FIFO demo froze your whole session? You are on a one-engine
>   bench — the warning box's exact case. Wait: the kernel's
>   real-time throttle leaves a sliver, and Ctrl-C (or closing that
>   terminal) ends it. Note what happened in your logbook — you just
>   ran the most convincing demonstration in this work order.
> - `systemd-run: command not found`, `Failed to connect to bus`, or
>   similar? Your bench runs without a systemd user session (some
>   minimal VMs and hand-built Path C installs). Run the **contrast
>   demo** instead, which needs nothing but `nice`: restart two looms
>   at courtesy 19 exactly as in Task 1 (Task 3's opening had you stop
>   them), call a drill, and while the floor is stormed start one loom
>   at courtesy 0 in your second terminal —
>   `bash starter/loom-job.sh forward` — beside those two starved
>   courtesy-19 looms. Paste the two contrasting rate
>   lines into **A5**, in place of the governed line — and keep the
>   `SCHED_FIFO` policy line from step 1 as your **A4**. (`chrt` needs
>   no systemd, so step 1 works on your bench.) Read the governor demo
>   above anyway, even though your bench cannot run it.
> - The governed loom reads at only a few percent of reference, or
>   nothing at all? The floor was busy (a drill still standing, looms
>   still running). Quiet the floor and read again.
> - Ctrl-C ended the loom but `systemd-run` complains the unit
>   already exists on a re-run? It picks fresh names each time; if
>   you named one yourself, add `--unit` with a new name or wait a
>   moment for the old scope to clear.

---

## Case notes — the week's entry

Open `case-notes.md` (repo root) and fill the Week 4 row: what you
found, the command that showed it to you, and what you make of it.
Copy the exact strings — **the full crontab line you struck out** (all
of it, including the tail you read at your bench) and **the paper's
signature line** — the one beginning `By order of` — at the head of
`amendment-314.sh`.

Two questions to write toward, neither of which has an answer in this
work order:

1. **The paper reads like committee minutes** — *WHEREAS, BE IT
   AMENDED, moved, seconded, and carried* — drafted with real fluency,
   on a system that keeps its standing orders in one-line table rows.
   What kind of hand writes an amendment in that form, and writes it
   *well*? What would it take to fake that fluency?
2. **Look at what the amendment was careful about.** Ninety seconds
   and self-sweeping. A one-line strike-out restores everything. The
   Demonstration was humiliated; no ledger, no loom, no scrap of work
   was harmed. If you wanted to hurt this house, is this how you would
   do it? If not — what *is* this?

Both questions are asking you to guess, and a plain guess is worth
more here than a careful hedge — the notebook is marked on being kept
honestly, never on being right early. Copy the strings exactly and you
will thank yourself in November.

## Reflection (both prompts go in your logbook)

Both prompts are really about people. A scheduler is somebody's answer
to the question "who waits," and this week you got to be the somebody.
Answer in your own words; I am after your judgment, not the manual's.

1. You now hold three levers: **courtesy** (`nice`/`renice`), the
   **real-time class** (`SCHED_FIFO`), and the **governor**
   (`CPUQuota`). The Guild wants the 3 o'clock Demonstration protected
   from *any* future queue-jumper. In a paragraph: which lever do you
   pull, on which jobs, and what does each alternative cost or risk?
   (There is more than one defensible answer; costs are the point.)
   *zyBooks 3.1–3.3.*
2. During the drill your courtesy-19 loom fell to a handful of lines
   per second — on a floor with many engines it may even have
   reported a flat `0`, its share having rounded below a single card
   — and the moment the burners matched its courtesy it climbed two
   orders of magnitude. In two or three sentences: what was the
   scheduler still promising the loom at the bottom of the queue (a
   reported zero is not the same as never being run), and when is
   courtesy 19 the *right* setting for a job you love?

## Turn it in

Due **Sunday, September 13, 11:59 pm**, on **Canvas** (per
[`syllabus/schedule.md`](../../syllabus/schedule.md)):

1. **`logbook.md`** — all three milestones: what you did, the seal
   pasted in, what it means; the baseline (M1); the full 15:14
   narrative — collapse, hunt, strike-out, renice (M2); the two
   governor demos (M3); plus both reflection prompts and the
   time-spent line.
2. **`case-notes.md`** — your running notebook with its Week 4 entry.

Upload both files to the Week 4 assignment. (`check/answers.txt` stays
in your repo — the seals already vouch for it.) When your paperwork is
in, you may `bash report-for-duty.sh --reset` — or leave the bench
staged and keep the drill; some of you will want it for Reflection 1.

That closes all four objectives: Task 1 is objectives 1 and 2, Task 2
is objectives 2 and 3, Task 3 is objective 4, and the reflections are
all four in your own words.

**Also on this week's docket:** zyBooks **Ch 3** is due **Wednesday**
before class. And **Commission I — *The Census of the Enginehouse***
(zyBooks 12.1, "Mr. Kureos") is due **Friday, September 18** — five days
after this order closes. Note what that leaves you: the weekend belongs
to this work order now, and the commission gets the evenings of the week
that follows. If you have not started it, those evenings are the last
comfortable ones.

> `SUBMISSION: EXPECTED BY SUNDAY 11:59 PM.`
> `WAX SEALS: THREE. ADMIRED.`
> `APPOINTMENTS: THIS PORTER KEEPS HIS OWN. PUNCTUALLY.`
> — punched chit, affixed by Porter Brassfeather

## For the curious *(worth no points, ever)*

Not required, not graded, not a trap. These are the threads I pulled
the first time a scheduler surprised me, left here in case one of them
catches you the same way.

- `man 5 crontab` — the whole grammar of the appointment book: ranges
  (`0-30`), steps (`*/5`), lists (`1,15`), and the special strings
  (`@daily`, `@reboot`). `man 1 crontab` covers the tool itself —
  including `-e`, which edits the book in place with your `$EDITOR`,
  the everyday alternative to the pipeline surgery you performed.
- `man 7 sched` — every scheduling class on the system: `SCHED_OTHER`,
  `SCHED_FIFO`, `SCHED_RR` (FIFO with a time slice), `SCHED_BATCH`,
  `SCHED_IDLE` (courtesy beyond 19 — jobs that run only when *nothing*
  else wants the engine). The section on `SCHED_FIFO` states the
  run-until-yield rule you demonstrated, in the kernel's own words.
- `chrt -m` prints each class's valid priority range on your bench.
- While the governed loom runs, its valve is a readable file. In
  another terminal:
  `cat /sys/fs/cgroup/user.slice/user-$(id -u).slice/user@$(id -u).service/app.slice/run-*.scope/cpu.max`
  — expect `20000 100000`: twenty thousand microseconds of engine per
  hundred-thousand-microsecond window. The whole governor is those two
  numbers, and `systemd-run` merely wrote them there.
- `ps -eo pid,ni,cls,rtprio,pcpu,comm --sort=-pcpu | head -15` — the
  muster roll ranked by appetite, with class and courtesy beside each.
  Run it during a drill and after; keep the two snapshots.
- The looms report *lines per second* because rate-of-real-work is the
  only honest measure of scheduling. `%CPU` says who *holds* an
  engine; the rate says who *gets anything done* — and you watched
  those two numbers disagree all week.

---

*By order,*

**B. Marlowe**, Chief Enginewright
*"Write down what you did. Never trust a figure you have not checked."*
