# Engineer's Logbook

*Honourable Guild of Enginewrights — Ex Vapore, Ordo*

Copy this into your week's folder as `logbook.md` and fill it in as you
work. Paste your wax seals where marked — that's how a milestone gets
marked done.

Write it the way you'd explain the week to a classmate who missed it:
plain sentences, no polish. An honest half-answer under "what it
means" — *I got the seal but I'm still fuzzy on why the second run
differed* — beats a confident sentence you don't believe, and it tells
me where to start when you bring it to studio.

Scott Sims
**Week: 4**
**Work Order No.: 4**

## Milestone 1
I started back and forth programs with maximum niceness, which began to run by trading off who went. I then checked the CPU to see what was running and how much of the CPU it was using. 

**Output or seal:**
~~~ WAX SEAL of the Guild: E9891F11 ~~~

**What it means:**
Nice settles who waits when jobs compete, and nobody is competing yet.

## Milestone 2
**What I did:**
I called the drill to hunt the schedule. Then I read the book to learn the stutter issue in the machine is done by command, not through issue. I then killed the issue fixing it for the Guild.

**Output or seal:**
I was unable to get the seal to output even though I double checked that I did everything right, so I am unsure of what I am missing.

**What it means:**
It means issues of stutter in regular intervals are often man-made not machine generated. Follow the clues and I can find what I need to fix the issue by hand (because the issue was created by hand).

## Milestone 3
**What I did:**
First I checked the scheduling, in order to inspect FIFO. Next I inspected the governor an opposite lever. The governor limited my CPU use but still allowed things to run.

**Output or seal:**
~~~ WAX SEAL of the Guild: E0EF418A ~~~

**What it means:**
I am able to limit what I need with the governor saving me CPU power. However, this also limits what gets done.

> Fewer or more milestones this week? Copy a block above as needed.

## Reflection

1. You now hold three levers: courtesy (nice/renice), the real-time class (SCHED_FIFO), and the governor (CPUQuota). The Guild wants the 3 o'clock Demonstration protected from any future queue-jumper. In a paragraph: which lever do you pull, on which jobs, and what does each alternative cost or risk? (There is more than one defensible answer; costs are the point.) zyBooks 3.1–3.3.

Personally I would pull the governor lever, leaving the 3 o’clock demonstration in the normal scheduler class: a quota gives a hard ceiling on how much CPU the background workload can consume, so future queue-jumpers cannot starve the demonstration, though the cost is lower throughput and possible under-utilization if the demo itself doesn’t need all the CPU.

2. During the drill your courtesy-19 loom fell to a handful of lines per second — on a floor with many engines it may even have reported a flat 0, its share having rounded below a single card — and the moment the burners matched its courtesy it climbed two orders of magnitude. In two or three sentences: what was the scheduler still promising the loom at the bottom of the queue (a reported zero is not the same as never being run), and when is courtesy 19 the right setting for a job you love?

At nice 19, the scheduler was still promising the loom CPU time whenever there was runnable capacity—it had the lowest normal scheduling priority, not a guarantee of zero CPU; a displayed 0% can simply mean its small share rounded down over the measurement interval. Just because it is nice enough to let others go first does not mean it does not get to go at all. 


## Sources and help

Anyone or anything that helped you this week — a classmate, a man page,
a Stack Overflow answer, an AI assistant. One line each: who or what,
and what you used it for. This is **not graded and never costs points**;
it is the habit professional engineers keep, and the syllabus asks for
it under *Academic integrity* and *Use of AI tools*.

- *(example)* Worked through the `fork` ordering with Sam in studio.
- *(example)* Used an AI assistant to explain what `EAGAIN` means in the trace.

*Nothing to report? Write "None" — that's a perfectly normal week.*

## Time spent

Roughly how long this took, start to finish: _______ hours
*No wrong answer — this just helps calibrate future work orders.*
