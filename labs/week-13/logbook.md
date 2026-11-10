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
**Week: 13**
**Work Order No.: 12**

## Milestone 1
**What I did:**
IN this milestone I found out who the computer thought I was. Then I tried to figure out why that was who it thought I was and finally I attempted to find out a password but was denied because of my credentials. 
**Output or seal:**
~~~ WAX SEAL of the Guild: F3647AD8 ~~~

**What it means:**
This means the computer knows who you are or at least who you claim to be and is smart enough to deny you access to certain things if you do not fit the criteria. 

## Milestone 2
**What I did:**
I checked what I could run compared to my uid. I learned about effective vs real uid then I found if I owned the file. My find home command only printed one. I found there were papers that I did not own, 1849 did, even on my own computer. Despite it not being mine I was able to learn some.

**Output or seal:**
~~~ WAX SEAL of the Guild: B3F1D4C2 ~~~

**What it means:**
While you are not supposed to be able to read what others store without a key you are able to learn things about it that may help you get into the file to see what is being hidden on your own bench. There is always a spare key somewhere.

## Milestone 3
**What I did:**
I searched through a log to find the keys, the doors, and the times it was opened. I fount who and when opened but not what they did in there.

**Output or seal:**
~~~ WAX SEAL of the Guild: 4411D53D ~~~

**What it means:**
This means you are able to find all the evidence you need if you know where to look. I found all the secret rooms, who went in them, who has the key, when they went in. All the pieces to the puzzle except maybe the most important one, what is in the room.

## Milestone 4
**What I did:**
I looked at the shape of the porters book. I crossed referenced it to the one of the wardens. I found every book has a window then I sorted and looked in. I looked around and asked what the book had.

**Output or seal:**
~~~ WAX SEAL of the Guild: 318D62BA ~~~

**What it means:**
This means that I found a second version of a similar book that was able to corroborate what I found earlier and let me in easier.

> Fewer or more milestones this week? Copy a block above as needed.

## Reflection

1. In a paragraph: explain to someone who has never used a terminal why passwd can change a file its user may not even read, and why a script with the very same mark on it can't. Use uid, effective uid, setuid bit and mode correctly at least once each.

The key difference is that passwd is a program the system trusts to run with special privileges; its setuid bit tells Linux to run it with the file owner's effective uid, even though the person launching it has a different uid. This allows passwd to update the protected password file without letting the user read it. A script with the same setuid bit cannot do this because Linux ignores the setuid bit on interpreted scripts for security reasons. In other words, the file's mode may show the same special permission, but the operating system does not honor it for scripts.

2. In two or three sentences: a log can say which key was shown at a door, and not whose hand held it. What would you add to the door, or to the log, so that it could say more? What would you give up for it?

I would add a personal ID check, like a digital badge or fingerprint reader, and record who presented the key along with the time. This would make the log more useful for identifying people, but that would give up some privacy and convenience.

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

Roughly how long this took, start to finish: ___2____ hours
*No wrong answer — this just helps calibrate future work orders.*
