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

**Name: Scott Sims**
**Week: 12**
**Work Order No.: 11**

## Milestone 1
**What I did:**
First I asked for files, then I had them point me to where I could change them. I found the drivers the kernel used and what the drivers meant. I followed the pipe all the way down to where the kernel was interacting with each order.

**Output or seal:**
~~~ WAX SEAL of the Guild: 5B79A45C ~~~

**What it means:**
This means I am able to look at do more than I every thought possible. I am able to go find exactly where everything interacts with the kernel and possibly in the future change it myself.

## Milestone 2
**What I did:**
I created a tube and communicated between myself, but still not me another form of me. I found who owned the tube and who was using it all while being able to use and shutdown the tube. I also stood inside the tube to see what passed through and found an echo.
**Output or seal:**
~~~ WAX SEAL of the Guild: F8D8DAE5 ~~~

**What it means:**
This means that I continue to find ways to edit and learn how to manage what goes on underneath the hood of my device. I also learned that to find who holds the tube, a helper may be needed, this time in the form of a second terminal.

## Milestone 3
**What I did:**
I traced the fittings to find the order the capsule meets them, I found the owner, I sent a capsule, and I saw how much it grew.

**Output or seal:**
~~~ WAX SEAL of the Guild: 7AFD0197 ~~~

**What it means:**
This means that I am able to find who owns it, what it does, and how it changes throughout the lifecycle of the capsule.

## Milestone 4
**What I did:**
I searched through the drop box which was not empty even though I sent nothing. I checked the capsules and read what they were then I read one, but it went unsigned.

**Output or seal:**
~~~ WAX SEAL of the Guild: 304DF696 ~~~

**What it means:**
This means capsules can stay even without me sending them, I can also go back through and see what was sent.

> Fewer or more milestones this week? Copy a block above as needed.

## Reflection

1. In a paragraph: explain to someone who has never used a terminal why ls /no-such-fitting 2>&1 > order.txt left the complaint on the screen and ls /no-such-fitting > both.txt 2>&1 did not, and what happens to yes in yes | head -1. Use file descriptor, redirection, pipe and buffer correctly at least once each. 

Every program has numbered file descriptors for its input and output: 1 is standard output and 2 is standard error. Redirections happen from left to right, so ls /no-such-fitting 2>&1 > order.txt first sends errors to the original screen output, then redirects standard output to the file, leaving the complaint on screen. In ls /no-such-fitting > both.txt 2>&1, standard output is redirected to the file first, then standard error is redirected to follow it, so both go into the file. With yes | head -1, the pipe connects yes to head, which reads one line and exits; when yes tries to write more, it finds the pipe has no reader, gets a broken-pipe error, and stops. Any remaining data in the pipe's buffer is discarded when it closes.

2. In two or three sentences: you could read the copier's command line but not its table of open files. Is that the right place for the Engine to draw the wall between one account and another? What would you want a shared machine to show everyone about a process, and what should it keep to the process's owner? (There is no answer key.)

Yes, that is a reasonable boundary for me. If it is a shared machine it can expose enough process information for users to understand system activity without revealing private resources belonging to another account. Everyone should be able to see basic details such as a process's command, owner, and resource usage, while contents or other potentially sensitive details should remain visible only to the process owner or an administrator.


## Sources and help

Anyone or anything that helped you this week — a classmate, a man page,
a Stack Overflow answer, an AI assistant. One line each: who or what,
and what you used it for. This is **not graded and never costs points**;
it is the habit professional engineers keep, and the syllabus asks for
it under *Academic integrity* and *Use of AI tools*.

- *(example)* Worked through the `fork` ordering with Sam in studio.
- *(example)* Used an AI assistant to explain what `EAGAIN` means in the trace.

*Nothing to report? Write "None" — that's a perfectly normal week.*
none

## Time spent

Roughly how long this took, start to finish: ___2.5____ hours
*No wrong answer — this just helps calibrate future work orders.*
