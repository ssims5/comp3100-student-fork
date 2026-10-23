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
**Week: 10**
**Work Order No.: 10**

## Milestone 1
**What I did:**
I see mostly r---, rw--, and r-x--. Those are my most common. Under pmap I have none hidden. I have bash, libc.so.6, LC_NUMERIC, LC_TIME and more. VmSize:     6080 kB and VmRSS:      5392 kB. The difference it has access to but has not given out, it may have promised it but not actually handed out.

**Output or seal:**
~~~ WAX SEAL of the Guild: ABB554A4 ~~~

**What it means:**

## Milestone 2
**What I did:**
I ran a program that took memory without limits which would cause a big issue with my computer. Then I was able to run a line that limited its power to 64M. 

**Output or seal:**
~~~ WAX SEAL of the Guild: 457EB20E ~~~

**What it means:**
This means if not kept in check some programs can run until they eat up every bit of memory that your machine has, but with the right limiter this issue can be easily avoided.

## Milestone 3
**What I did:**
I attempted to drill down into the room I have been banned from. I found the owner and his account along with the room that he was hiding. 

**Output or seal:**
~~~ WAX SEAL of the Guild: 1DD7F597 ~~~

**What it means:**
This means people are hiding things on my own machine that as a typical user I do not have access to. I can not get in to my own spaces without others permissions.

## Milestone 4
**What I did:**
I started by dumping the room. I found the addresses that the map pointed my to then cleaned it out and looked in. Then I was able to read the record and learn what was hidden from me. 

**Output or seal:**
~~~ WAX SEAL of the Guild: 296321E9 ~~~

**What it means:**
This means that despite initial attempts to hide, if a person knows what they are doing they will be able to open a door with no key. It may take lots of effort and knowledge but one can find the secrets hidden in private rooms.

> Fewer or more milestones this week? Copy a block above as needed.

## Reflection

1. In a paragraph: a process can hold a Store far larger than the real memory behind it. Explain, using virtual address, page, page fault and resident correctly at least once each, how storeroom could request 256 pages almost for free and why the first touch of each cost a fault and the second cost nothing. 

a storeroom can request 256 pages of virtual address space without immediately using much real memory because the operating system can reserve the addresses without making all the pages resident in physical RAM. When storeroom first touches each page, a page fault occurs because the page is not yet resident, so the OS allocates a physical frame and maps the page into memory. The first touch therefore incurs a fault for each page, but the second touch costs nothing extra because the page is already resident in RAM and its virtual address is mapped to the physical frame.

2. In two or three sentences: the governor ended the glutton by the Overseer's hand, not the glutton's. Was that the right thing for the Engine to do? What would you want a real server to do instead of killing a process outright, and what would that cost?

I believe in this instance it was the right thing to do because who knows how long the glutton could have gone and the Overseer needed to step in. In the future I would prefer a real server to pause the service and check to make sure it is doing what it should before killing it. It may cost more time but it could save an important resource from getting killed.

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

Roughly how long this took, start to finish: ____2___ hours
*No wrong answer — this just helps calibrate future work orders.*
