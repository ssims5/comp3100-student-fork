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
Week 3
**Work Order No.:**

## Milestone 1
This weeks first milestone I took a look into the pantograph desk to understand what is going on in the moment. 

**Output or seal:**
~~~ WAX SEAL of the Guild: BA055E04 ~~~

**What it means:**
Fork handed each process a pid, execvp replaced the old process with a new one, and waitpid brought back the termination status.

## Milestone 2
In milestone 2 I explored zombies, I looked at how they worked, how they run, and what happened to them.

**Output or seal:**
~~~ WAX SEAL of the Guild: BBDB3293 ~~~

**What it means:**
A zombie is a process that has completed its duty and been terminated but has not yet been picked back up by its parents. Looking through the processes I learned that zombies were common and normal and not usually something to be worried about. Then learned that orphans are processes whose parent has been murdered.

## Milestone 3
**What I did:**
In Milestone 3 I explored everything that was running. I took a look at the processes that had started when I booted up my program and I explored what they were doing despite no direct communication from me. 

**Output or seal:**
~~~ WAX SEAL of the Guild: CC62BF35 ~~~

**What it means:**
I looked at ppids to see what was running and learned that many things run in the background quietly and without instruction. These are the processes that allow me to basic things and to communicate with the hardware when I am in the kernel.

> Fewer or more milestones this week? Copy a block above as needed.

## Reflection

1. fork() copies a process; execvp() replaces the program inside one. Most languages you have used offer a single "run this command" call instead. In a paragraph: what does splitting the job into two steps let a shell do between them that a single call would not? (You built the seam yourself in Task 1 — everything your shell does with redirection and pipes happens in that gap.)
Splitting the job creates an area where the child process exists but has not started running. In this window of time the child can be manipulated by the shell to use systems not called by the parent, allowing for a distinct outcome from a child. 

2. A zombie has finished but has not been collected; an orphan is still running but its parent is gone. You met one of each this week. In two or three sentences: which resources does each one hold, who is responsible for clearing each, and why is the zombie the one that can bring a machine down?
A zombie process does noy hold memory or resources from the CPU but an orphan continues to run and consumes normal amounts or resources. If the parent process dies the orphan may be adopted while the zombie continues to run. If a zombie is not collected or killed however they can begin to accumulate and can exhaust tth amount of pids available so the os would not be able to launch any more processes.

## Sources and help

Anyone or anything that helped you this week — a classmate, a man page,
a Stack Overflow answer, an AI assistant. One line each: who or what,
and what you used it for. This is **not graded and never costs points**;
it is the habit professional engineers keep, and the syllabus asks for
it under *Academic integrity* and *Use of AI tools*.

- *(example)* Worked through the `fork` ordering with Sam in studio.
- *(example)* Used an AI assistant to explain what `EAGAIN` means in the trace.

*Nothing to report? Write "None" — that's a perfectly normal week.*
None

## Time spent

Roughly how long this took, start to finish: __2.5_____ hours
*No wrong answer — this just helps calibrate future work orders.*
