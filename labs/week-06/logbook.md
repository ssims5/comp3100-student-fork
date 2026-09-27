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

**Name: Scott **
**Week: 6**
**Work Order No.: 6**

## Milestone 1
**What I did:**
I made sure the gateman did not lock repeatedly but looked once and went to sleep. I also stopped the trains from running simultaneously much like last week, except this time the trains running had a larger negative affect on the program and my computer.

**Output or seal:**
~~~ WAX SEAL of the Guild: 883642FC ~~~

**What it means:**
Programs that are not properly kept in check can cause serious issues to a programs ability to run and use resources properly. My programs was originally busy thousands upon thousands of times wastefully but with my fix it is now safe to run without fear.

## Milestone 2
**What I did:**
I added both semaphores and mutex to the code to protect it. I did so for the chute guard and the room.

**Output or seal:**
~~~ WAX SEAL of the Guild: 2DA46117 ~~~

**What it means:**
This means my protections were successful, I was able to protect the room until it was ready and create a queue for processes to wait in until the program was ready.

## Milestone 3
**What I did:**
I added read/writer lock in order to allow the readers to read without queuing because reading does not conflict with itself. It also allows a writer to write for the readers take over because that will change an outcome.

**Output or seal:**
~~~ WAX SEAL of the Guild: 85DAAF22 ~~~

**What it means:**
This means my program is more efficient and more accurate than ever before, the processes that do not interrupt one another may continue on but the processes that need everyone to wait can force them to wait.

## Milestone 4
**What I did:**
Aurelia is holding fork zero and is waiting on fork one which is being held by Bramwell. Bramwell is holding fork one and is waiting on fork two which is being held by Cordelia. Cordelia is holding fork two and is waiting on fork 3 which is being held by Desmond. Desmond is holding fork 3 and is waiting on fork 4 which is being held by Eustace. Eustace is holding fork 4 and is waiting on fork 0 which is being held by Aurelia. The ring can not fix itself because one will not give up their own until given one but since everyone is waiting on each other they are all stuck.

**Output or seal:**
~~~ WAX SEAL of the Guild: F4BE746C ~~~

**What it means:**
This means that each philosopher was stuck waiting on the other infinitely with no way to solve their own problem. However, with a slight tweak we were able to make it to where only one philosopher waits at a time and not for long.

## Milestone 5
**What I did:**
Lever 07 is held. - ls -ln ~/enginehouse/interlocking/
The lock is owned by uid 1849 and nothing of that uid is running. - stat -c 'owner uid %u   mode %a   %n' ~/enginehouse/interlocking/lever-07.lock
The roll has an entry for 1849, and its description says what that account was for. - cat ~/enginehouse/interlocking/lever-07.lock
Its login shell says whether anybody was meant to sign in as it. - cat ~/enginehouse/interlocking/lock-record.txt

**Output or seal:**
~~~ WAX SEAL of the Guild: 2A5CA4EF ~~~

**What it means:**
This means that when a lever is held but not given up it can not be edited. We can find who owns it, created it, does anyone sign for it, but I can not change it because it is still locked.

> Fewer or more milestones this week? Copy a block above as needed.

## Reflection

1. You used four different tools this week: a mutex, a condition variable, two semaphores, and a reader/writer lock. In a paragraph each for any three of them, say what the tool does that the others cannot, and name a situation where reaching for the wrong one would produce a program that is correct but useless. Use the words critical section, bounded buffer and starvation correctly at least once each. zyBooks Ch 4.2–4.5.

A mutex provides exclusive access what one thread can hold at a time, which makes it useful for protecting important or critical sections that access shared data or states. Using a mutex when you need a semaphore for something like a bounded buffer can make a program that is correct but useless. If both the producer and consumer need coordinates to show available buffer spots a mutex only protects the buffer but not count the available slots.
A condition variable lets a thread sleep until another thread signals that a condition has been met. Using a condition variable where a semaphore is needed can result in a correct but useless program. Trying to track ten available identical resources requires separately maintaining and checking the count.
A reader/writer lock distinguishes between readers and writers, because multiple readers can hold the lock simultaneously, but a writer requires exclusive access. Using a reader/writer for a small piece of data that is almost always being modified could make a program that is correct but wasting time/resources. A mutex would be better used for that situation.


2. The long table stalls because every philosopher follows the same reasonable rule at the same time. Nobody is greedy and nobody is wrong. In two or three sentences: what does that tell you about testing? Specifically — your fixed table ran fifteen meals in under a second, three times out of three. What would you need to see before you were willing to tell the Guild that a piece of concurrent machinery is safe, given that "I ran it and it worked" is the same sentence a student says about a program that stalls once a fortnight? (There is no answer key. I am asking what standard you hold yourself to.)

Three successful runs show that the tested schedule works but does not promise safety. I would want more repeated testing under varied timings to show the standard was upheld. 

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

Roughly how long this took, start to finish: __3_____ hours
*No wrong answer — this just helps calibrate future work orders.*
