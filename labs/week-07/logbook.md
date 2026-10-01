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

**Name: Scott**
**Week: 7**
**Work Order No.: 7**

## Milestone 1
**What I did:**
Four holds are Northgate - 1851-09-26 18:51:07, Waterside - 1851-09-26 18:51:21, Old Quarter - 1851-09-26 18:51:35, and Kiln Row - 1851-09-26 18:51:49. The gaps are 14 seconds, 14 seconds, and 14 seconds.
Rule 2 says that the duty engine wright releases one box, the one that has been most recently claimed. Kiln Row was claimed last. It was chosen because it has the smallest share of the rings work.
day .............. Saturday, 26 September 1851
entered: 1851-09-23

**Output or seal:**
~~~ WAX SEAL of the Guild: 8FB23102 ~~~

**What it means:**
This means each hold grabs a box every fourteen seconds and the duty engine wright grabs the last one because it has the smallest share of rings.

## Milestone 2
**What I did:**
I went through the issues and tried to parse out exactly what was wrong. I used info threads, and thread apply all bt to try and find the chain of function calls to see what is wrong.

**Output or seal:**
~~~ WAX SEAL of the Guild: 7ED21DDD ~~~

**What it means:**
This means that I was able to look through and even diagnose the issues preventing each lever from being pulled.

## Milestone 3
**What I did:**
Mutual exclusion — print lever_waterside: __lock = 2 and __owner = 2666
Hold and wait — thread apply all bt: Kiln Row inside take_lever waiting for lever_northgate while it already holds lever_kilnrow
No resource preemption — pipe thread apply all bt | grep take_lever: same four threads still waiting for the same levers after about 10 seconds; no thread had been forced to give up its held lever.
Circular wait — pipe thread apply all bt | grep take_lever: showed Kiln Row waiting for Northgate's lever, Northgate waiting for Waterside's, Waterside waiting for Old Quarter's, and Old Quarter waiting for Kiln Row's, forming a closed cycle.


**Output or seal:**
~~~ WAX SEAL of the Guild: FDE452E7 ~~~

**What it means:**
This means that there are many things to lock a system up but there are ways to prevent it. The condition that broke it is no preemption. This worked because the smallest system was held back and told to wait while the others worked before it was allowed to step back in. 

> Fewer or more milestones this week? Copy a block above as needed.

## Reflection

1. In a paragraph: why does a deadlock need all four conditions at once, and why is breaking any one of them enough? Then take two of the table's prevention rows and, for each, describe a program where that remedy would be the wrong one to reach for — because it is impossible there, or because of what it costs. Use the words mutual exclusion, hold and wait, resource preemption and circular wait correctly at least once each.

A deadlock requires all four conditions at the same time because if any condition is broken the cycle needed would brake. Breaking just one is sufficient to prevent deadlock.

2.The release worked because somebody outside the ring had the authority to tell one box to give way, and a manual that said which. Most real programs have nobody like that: when their threads deadlock they simply stop, and a person notices eventually. In two or three sentences: would you rather build a system that can recover from deadlock, or one that cannot get into it at all — and what does each choice cost you? (There is no answer key. I am asking what you would defend in a design review.)

I would use a system that prevents deadlock because it would remove some complexity building a system that detects and recovers from deadlock. Even if you build a system that detects and fixes deadlock I think it would be more likely to fail than a system that completely prevents it even though there is still a chance that the system could also fail.

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

Roughly how long this took, start to finish: ___3____ hours
*No wrong answer — this just helps calibrate future work orders.*
