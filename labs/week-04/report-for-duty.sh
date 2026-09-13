#!/usr/bin/env bash
# report-for-duty.sh -- Work Order No. 1851-04: stage the Dispatch Board week.
#
# Usage:
#   bash report-for-duty.sh            stage this week's bench (safe to re-run)
#   bash report-for-duty.sh --drill    call the 15:14 trouble onto the floor
#                                      now, for ninety seconds (repeatable)
#   bash report-for-duty.sh --reset    remove everything this script created
#
# What it touches, and nothing else:
#   ~/enginehouse/machinery/           one working part is fitted here
#   your user crontab                  ONE line is added. --reset (and the
#                                      week's own detective work) removes
#                                      exactly that line, found by a marker
#                                      this script greps for; every other
#                                      line of your crontab is preserved,
#                                      staged and struck alike. Nothing here
#                                      edits system cron, /etc, or any other
#                                      user's book.
#   the floor                          when the appointment falls due, or on
#                                      --drill, short-lived jobs hold the CPU
#                                      for ninety seconds and then stand down
#                                      by themselves. No network, no files
#                                      outside ~/enginehouse. Finding out
#                                      what they are is the week's detective
#                                      work, which is why the pattern ships
#                                      sealed -- reading it would only spoil
#                                      the hunt.
#
# Sudo: none for staging, with one disclosed exception -- if the cron
# service is not running (some WSL benches), the script offers
# `sudo service cron start`, that command and no other, and says so out
# loud when it happens. Task 3's demos carry their own warning boxes.
#
# Works offline.
set -eu

# The dispatch office's sealed orders. Decoded at stage time, run, swept up.
decode_pattern() { # writes the dispatch-office payload to $1
  base64 -d > "$1" <<'B64'
IyEvYmluL3NoCiMgRGlzcGF0Y2gtb2ZmaWNlIHBheWxvYWQgLS0gV29yayBPcmRlciBOby4gMTg1
MS0wNC4KIyBEZWNvZGVkIGFuZCBydW4gYnkgcmVwb3J0LWZvci1kdXR5LnNoOyBuZXZlciBzaGlw
cGVkIGluIHRoZSBjbGVhci4KIyAoS2VwdCB2ZXJiYXRpbSwgd2l0aCBjb21tZW50YXJ5LCBpbiB0
aGUgaW5zdHJ1Y3RvcidzIGFuc3dlciBrZXkuKQpzZXQgLWV1Cm1vZGU9IiR7MTo/c3RhZ2V8ZHJp
bGx8c2VsZnRlc3R8cmVzZXR9IgoKRUg9IiRIT01FL2VuZ2luZWhvdXNlIgpNQUNIPSIkRUgvbWFj
aGluZXJ5IgpTQ1JJUFQ9IiRNQUNIL2FtZW5kbWVudC0zMTQuc2giCk1BUks9J0FtZW5kbWVudCBO
by4gMzE0JwpDUk9OTElORT0nMTQgMTUgKiAqICogJEhPTUUvZW5naW5laG91c2UvbWFjaGluZXJ5
L2FtZW5kbWVudC0zMTQuc2ggIyBEaXNwYXRjaCBCb2FyZCBBbWVuZG1lbnQgTm8uIDMxNCDigJQg
Ynkgb3JkZXIgb2Yg4paI4paI4paIJwoKIyBUaGUgdXJnZW50IHdvcmtzLCBieSB0aGVpciBqb2It
Y2FyZCBuYW1lOyB0aGUgc2l0dGluZ3MgdGhhdCBkaXNwYXRjaAojIHRoZW0sIGJ5IGludGVycHJl
dGVyIGFuZCBwYXRoIChuZXZlciBhIGJhcmUgLWYgb24gdGhlIHNjcmlwdCBuYW1lIC0tCiMgdGhh
dCB3b3VsZCBjYXRjaCBhbiBlZGl0b3Igd2l0aCB0aGUgcGFwZXIgb3BlbikuCmJ1cm5lcnMoKSAg
eyBwZ3JlcCAtdSAiJChpZCAtdSkiIC1mICdhbWVuZG1lbnQtMzE0LWJ1cm5lciQnIDI+L2Rldi9u
dWxsIHx8IHRydWU7IH0Kc2l0dGluZ3MoKSB7IHBncmVwIC11ICIkKGlkIC11KSIgLWYgJ14vYmlu
L3NoICgtYyApPyhcJEhPTUV8L1teIF0qKS9lbmdpbmVob3VzZS9tYWNoaW5lcnkvYW1lbmRtZW50
LTMxNFwuc2gnIDI+L2Rldi9udWxsIHx8IHRydWU7IH0KCndyaXRlX21hY2hpbmVyeSgpIHsKICBt
a2RpciAtcCAiJE1BQ0giCiAgY2F0ID4gIiRTQ1JJUFQiIDw8J0FNRU5EJwojIS9iaW4vc2gKIyA9
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT0KIwojICAgICAgICAgICAgRElTUEFUQ0ggQk9BUkQgIC0tICBBTUVORE1FTlQg
IE5vLiAzMTQKIwojICAgQmVpbmcgYW4gQU1FTkRNRU5UIHRvIHRoZSBTVEFORElORyBPUkRFUlMg
T0YgVEhFIERJU1BBVENIIEJPQVJELAojICAgZHJhZnRlZCwgbW92ZWQsIGFuZCBjYXJyaWVkIGlu
IHRoZSBmb3JtIHByZXNjcmliZWQgb2Ygb2xkIC0tCiMgICBvbiBwYXBlciwgaW4gY29tbWl0dGVl
IGFzc2VtYmxlZCwgcmVnaXN0ZXJlZCBhdCBubyBsb29tIC0tCiMgICBhbmQgZW50ZXJlZCB1cG9u
IHRoZSBCb2FyZCdzIGJvb2tzIGJ5IGhhbmQuCiMKIyAgIFdIRVJFQVMgdGhlIFN0YW5kaW5nIE9y
ZGVycyBwcm92aWRlIHRoYXQgdGhlIEJvYXJkIHNoYWxsCiMgICAgICBkaXNwYXRjaCBldmVyeSBq
b2IgaW4gZmFpciByb3RhdGlvbiwgZWFjaCBhY2NvcmRpbmcgdG8gaXRzCiMgICAgICBjb3VydGVz
eTsgYW5kCiMKIyAgIFdIRVJFQVMgYSBQVUJMSUMgREVNT05TVFJBVElPTiBpcyBoZWxkIGRhaWx5
IGF0IHRocmVlIG8nY2xvY2sKIyAgICAgIGluIHRoZSBFbmdpbmUgZ2FsbGVyeSwgYmVmb3JlIHNj
aG9vbGNoaWxkcmVuIGFuZCBhbGRlcm1lbjsKIwojICAgQkUgSVQgQU1FTkRFRCwgdGhhdCBhdCBG
T1VSVEVFTiBNSU5VVEVTIFBBU1QgVEhSRUUgbydjbG9jawojICAgICAgdGhlcmUgYmUgZGlzcGF0
Y2hlZCBjZXJ0YWluIFVSR0VOVCBXT1JLUywgaW4gbnVtYmVyIHR3aWNlCiMgICAgICB0aGUgY291
bnQgb2YgZW5naW5lcyB1cG9uIHRoZSBmbG9vciwgb3dpbmcgY291cnRlc3kgdG8gbm8KIyAgICAg
IG90aGVyIGpvYiB3aGF0c29ldmVyLCB0byBob2xkIGV2ZXJ5IGVuZ2luZSB3aG9sbHk7CiMKIyAg
IEFORCBGVVJUSEVSLCB0aGF0IHRoZSBzYWlkIHdvcmtzIHNoYWxsIHN0YW5kIGRvd24gb2YgdGhl
aXIgb3duCiMgICAgICBhY2NvcmQgdXBvbiB0aGUgZWxhcHNlIG9mIE5JTkVUWSBTRUNPTkRTLCBs
ZWF2aW5nIG5vIHBhcGVyCiMgICAgICB1cG9uIHRoZSBCb2FyZDsKIwojICAgQU5EIEZVUlRIRVIs
IHRoYXQgdGhpcyBBbWVuZG1lbnQgcmVuZXcgaXRzZWxmIGRhaWx5LCBhdCB0aGUKIyAgICAgIGhv
dXIgYW5kIG1pbnV0ZSBhcHBvaW50ZWQsIHVudGlsIGl0IGJlIHN0cnVjayBvdXQuCiMKIyAgICAg
ICAgICAgICAgTW92ZWQsIHNlY29uZGVkLCBhbmQgY2FycmllZCB3aXRob3V0IGRpdmlzaW9uLgoj
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEJ5IG9yZGVyIG9mIOKWiOKW
iOKWiAojCiMgPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09CnNldCAtdQoKZW5naW5lcz0kKG5wcm9jIDI+L2Rldi9udWxs
IHx8IGVjaG8gMikKY291bnQ9JCgoZW5naW5lcyAqIDIpKQoKIyBEaXNwYXRjaCB0aGUgdXJnZW50
IHdvcmtzOiBlYWNoIGhvbGRzIG9uZSBlbmdpbmUgd2hvbGx5LgpwaWRzPSIiCmk9MAp3aGlsZSBb
ICIkaSIgLWx0ICIkY291bnQiIF07IGRvCiAgc2ggLWMgJ3doaWxlIDo7IGRvIDo7IGRvbmUnIGFt
ZW5kbWVudC0zMTQtYnVybmVyICYKICBwaWRzPSIkcGlkcyAkISIKICBpPSQoKGkgKyAxKSkKZG9u
ZQoKIyBTdGFuZCBkb3duIG9ubHkgdGhlIHdvcmtzIHRoaXMgc2l0dGluZyBkaXNwYXRjaGVkLCBh
bmQgb25seSBpZiB0aGUKIyBqb2IgY2FyZCBzdGlsbCByZWFkcyBhcyBvbmUgb2Ygb3VycyAoYSBw
aWQgbnVtYmVyIGNhbiBiZSByZWlzc3VlZCkuCnN0YW5kX2Rvd24oKSB7CiAgZm9yIHAgaW4gJHBp
ZHM7IGRvCiAgICBjYXNlICIkKHRyICdcMCcgJyAnIDwgIi9wcm9jLyRwL2NtZGxpbmUiIDI+L2Rl
di9udWxsKSIgaW4KICAgICAgKmFtZW5kbWVudC0zMTQtYnVybmVyKikga2lsbCAiJHAiIDI+L2Rl
di9udWxsIDs7CiAgICBlc2FjCiAgZG9uZQp9CgojIEEgc2Vjb25kIHBhaXIgb2YgaGFuZHMsIHNo
b3VsZCB0aGlzIHNpdHRpbmcgYmUgc3RydWNrIG1pZC1zZXNzaW9uLgooIHNsZWVwIDEwMDsgc3Rh
bmRfZG93biApID4vZGV2L251bGwgMj4mMSAmCgpzbGVlcCA5MApzdGFuZF9kb3duCmV4aXQgMApB
TUVORAogIGNobW9kICt4ICIkU0NSSVBUIgp9Cgpwb3N0X29yZGVycygpIHsKICBpZiAhIGNvbW1h
bmQgLXYgY3JvbnRhYiA+L2Rldi9udWxsIDI+JjE7IHRoZW4KICAgIGVjaG8gIiAgKFRoaXMgYmVu
Y2gga2VlcHMgbm8gYXBwb2ludG1lbnQgYm9vayAtLSB0aGUgY3JvbnRhYiB0b29sIGlzIG5vdCIK
ICAgIGVjaG8gIiAgIGluc3RhbGxlZC4gVGhlIGRyaWxsIHdpbGwgc2VydmU7IHNlZSBUYXNrIDIn
cyBpZi15b3UncmUtbG9zdCBib3guKSIKICAgIHJldHVybiAwCiAgZmkKICB0bXA9IiQobWt0ZW1w
KSIKICB7IGNyb250YWIgLWwgMj4vZGV2L251bGwgfCBncmVwIC12ICIkTUFSSyIgfHwgdHJ1ZTsg
cHJpbnRmICclc1xuJyAiJENST05MSU5FIjsgfSA+ICIkdG1wIgogIGNyb250YWIgIiR0bXAiCiAg
cm0gLWYgIiR0bXAiCn0KCm9wZW5fb2ZmaWNlKCkgewogIGNvbW1hbmQgLXYgY3JvbnRhYiA+L2Rl
di9udWxsIDI+JjEgfHwgcmV0dXJuIDAKICBpZiBwZ3JlcCAteCBjcm9uID4vZGV2L251bGwgMj4m
MSB8fCBwZ3JlcCAteCBjcm9uZCA+L2Rldi9udWxsIDI+JjE7IHRoZW4KICAgIHJldHVybiAwCiAg
ZmkKICBlY2hvICIgIChUaGUgZGlzcGF0Y2ggb2ZmaWNlIGlzIHNodXQgLS0gdGhlIGNyb24gc2Vy
dmljZSBpcyBub3QgcnVubmluZy4iCiAgZWNobyAiICAgQXNraW5nIHRoZSBwb3J0ZXIgdG8gb3Bl
biBpdDogIHN1ZG8gc2VydmljZSBjcm9uIHN0YXJ0IgogIGVjaG8gIiAgIC0tIHRoYXQgY29tbWFu
ZCBhbmQgbm8gb3RoZXI7IHN1ZG8gbWF5IGFzayBmb3IgeW91ciBwYXNzd29yZC4iCiAgZWNobyAi
ICAgSWYgaXQgY2Fubm90IG9wZW4gaGVyZSwgdGhlIGRyaWxsIHN0aWxsIHNlcnZlcy4pIgogIHN1
ZG8gc2VydmljZSBjcm9uIHN0YXJ0IHx8IHRydWUKfQoKY2FzZSAiJG1vZGUiIGluCiAgc3RhZ2Up
CiAgICB3cml0ZV9tYWNoaW5lcnkKICAgIHBvc3Rfb3JkZXJzCiAgICBvcGVuX29mZmljZQogICAg
OzsKICBkcmlsbCkKICAgIGI9IiQoYnVybmVycyB8IGhlYWQgLTEpIgogICAgaWYgWyAtbiAiJGIi
IF07IHRoZW4KICAgICAgIyBSZWZ1c2FsLCBub3QgZmFpbHVyZSBvZiBtYWNoaW5lcnk6IGV4aXQg
MywgYW5kIG5ldmVyIGEgZnJlc2ggc2xpcC4KICAgICAgZWw9IiQocHMgLW8gZXRpbWVzPSAtcCAi
JGIiIDI+L2Rldi9udWxsIHwgdHIgLWQgJyAnIHx8IHRydWUpIgogICAgICByZW09IiIKICAgICAg
Y2FzZSAiJGVsIiBpbgogICAgICAgICcnfCpbITAtOV0qKSA6IDs7CiAgICAgICAgKikKICAgICAg
ICAgIHJlbT0kKCg5MCAtIGVsKSkKICAgICAgICAgIGlmIFsgIiRyZW0iIC1sdCAwIF07IHRoZW4g
cmVtPTA7IGZpCiAgICAgICAgICA7OwogICAgICBlc2FjCiAgICAgIGVjaG8gIiAgVGhlIGZsb29y
IGlzIGFscmVhZHkgb2NjdXBpZWQgLS0gdXJnZW50IHdvcmtzIGFyZSBzdGlsbCBzdGFuZGluZy4i
CiAgICAgIGlmIFsgLW4gIiRyZW0iIF07IHRoZW4KICAgICAgICBlY2hvICIgIFRoZXkgc3RhbmQg
ZG93biBvZiB0aGVpciBvd24gYWNjb3JkIGluIGFib3V0ICRyZW0gc2Vjb25kKHMpOyIKICAgICAg
ZWxzZQogICAgICAgIGVjaG8gIiAgVGhleSBzdGFuZCBkb3duIG9mIHRoZWlyIG93biBhY2NvcmQg
aW5zaWRlIHRoZWlyIG5pbmV0eSBzZWNvbmRzOyIKICAgICAgZmkKICAgICAgZWNobyAiICB3YWl0
IGZvciBxdWlldCwgdGhlbiBjYWxsIHRoZSBkcmlsbCBhZ2Fpbi4iCiAgICAgIGV4aXQgMwogICAg
ZmkKICAgIFsgLXggIiRTQ1JJUFQiIF0gfHwgd3JpdGVfbWFjaGluZXJ5CiAgICAoIGNkIC8gJiYg
c2V0c2lkIG5vaHVwICIkU0NSSVBUIiA8L2Rldi9udWxsID4vZGV2L251bGwgMj4mMSAmICkKICAg
IHdhbnQ9JCgoICQobnByb2MgMj4vZGV2L251bGwgfHwgZWNobyAyKSAqIDIgKSkKICAgIGk9MAog
ICAgd2hpbGUgWyAiJGkiIC1sdCA0MCBdOyBkbwogICAgICBuPSIkKGJ1cm5lcnMgfCB3YyAtbCki
CiAgICAgIGlmIFsgIiRuIiAtZ2UgIiR3YW50IiBdOyB0aGVuIGJyZWFrOyBmaQogICAgICBzbGVl
cCAwLjI1CiAgICAgIGk9JCgoaSArIDEpKQogICAgZG9uZQogICAgWyAiJChidXJuZXJzIHwgd2Mg
LWwpIiAtZ2UgMSBdIHx8IHsgZWNobyAiZHJpbGw6IG5vIHdvcmtzIHRvb2sgdGhlIGZsb29yIiA+
JjI7IGV4aXQgMTsgfQogICAgOzsKICBzZWxmdGVzdCkKICAgIFsgLXggIiRTQ1JJUFQiIF0gfHwg
eyBlY2hvICJzZWxmLXRlc3Q6IHRoZSBtYWNoaW5lcnkgaXMgbm90IGZpdHRlZCIgPiYyOyBleGl0
IDE7IH0KICAgIGlmIGNvbW1hbmQgLXYgY3JvbnRhYiA+L2Rldi9udWxsIDI+JjE7IHRoZW4KICAg
ICAgbj0iJChjcm9udGFiIC1sIDI+L2Rldi9udWxsIHwgZ3JlcCAtYyAiJE1BUksiIHx8IHRydWUp
IgogICAgICBbICIkbiIgPSAiMSIgXSB8fCB7IGVjaG8gInNlbGYtdGVzdDogdGhlIHN0YW5kaW5n
IG9yZGVycyBjYXJyeSAkbiBzdWNoIGxpbmVzICh3YW50IGV4YWN0bHkgMSkiID4mMjsgZXhpdCAx
OyB9CiAgICBmaQogICAgOzsKICByZXNldCkKICAgICMgMS4gVGhlIHN0YW5kaW5nIG9yZGVyczog
c3RyaWtlIG91ciBsaW5lIGFuZCBubyBvdGhlci4gSWYgbm90aGluZwogICAgIyAgICByZW1haW5z
IGF0IGFsbCwgY2xvc2UgdGhlIGJvb2sgZW50aXJlbHkgKGFzIG1vc3QgYmVuY2hlcyBrZWVwIG5v
bmUpLgogICAgaWYgY29tbWFuZCAtdiBjcm9udGFiID4vZGV2L251bGwgMj4mMTsgdGhlbgogICAg
ICB0bXA9IiQobWt0ZW1wKSIKICAgICAgY3JvbnRhYiAtbCAyPi9kZXYvbnVsbCB8IGdyZXAgLXYg
IiRNQVJLIiA+ICIkdG1wIiB8fCB0cnVlCiAgICAgIGlmIFsgLXMgIiR0bXAiIF07IHRoZW4gY3Jv
bnRhYiAiJHRtcCI7IGVsc2UgY3JvbnRhYiAtciAyPi9kZXYvbnVsbCB8fCB0cnVlOyBmaQogICAg
ICBybSAtZiAiJHRtcCIKICAgIGZpCiAgICAjIDIuIFRoZSBmbG9vcjogc2l0dGluZ3MgZmlyc3Qg
KHNvIG5vdGhpbmcgcmUtZGlzcGF0Y2hlcyksIHRoZW4gd29ya3MuCiAgICBzd2VlcD0wCiAgICB3
aGlsZSBbICIkc3dlZXAiIC1sdCA4IF07IGRvCiAgICAgIHN3ZWVwPSQoKHN3ZWVwICsgMSkpCiAg
ICAgIHBpZHM9IiQoc2l0dGluZ3M7IGJ1cm5lcnMpIgogICAgICBbIC1uICIkKHByaW50ZiAnJXMn
ICIkcGlkcyIgfCB0ciAtZCAnWzpzcGFjZTpdJykiIF0gfHwgYnJlYWsKICAgICAga2lsbCAkcGlk
cyAyPi9kZXYvbnVsbCB8fCB0cnVlCiAgICAgIHNsZWVwIDAuMwogICAgICBraWxsIC05ICRwaWRz
IDI+L2Rldi9udWxsIHx8IHRydWUKICAgICAgc2xlZXAgMC4yCiAgICBkb25lCiAgICAjIDMuIFRo
ZSBwYXBlci4KICAgIHJtIC1mICIkU0NSSVBUIgogICAgIyBUaGUgcm9vbXMgYWJvdmUgYXJlIG91
cnMgdG8gc3dlZXAgb25seSBpZiB3ZWVrIDEgbmV2ZXIgc3RhZ2VkIHRoaXMKICAgICMgYmVuY2gs
IGFuZCBvbmx5IGlmIHRoZXkgYXJlIGVtcHR5ICh3ZWVrIDMncyBwYXJ0IG1heSBzdGlsbCBiZSBm
aXR0ZWQpLgogICAgaWYgWyAhIC1lICIkRUgvaW5ib3giIF07IHRoZW4KICAgICAgcm1kaXIgIiRN
QUNIIiAyPi9kZXYvbnVsbCB8fCB0cnVlCiAgICAgIHJtZGlyICIkRUgiIDI+L2Rldi9udWxsIHx8
IHRydWUKICAgIGZpCiAgICA7OwogICopCiAgICBlY2hvICJwYXlsb2FkOiB1bmtub3duIG1vZGUg
JyRtb2RlJyIgPiYyCiAgICBleGl0IDIKICAgIDs7CmVzYWMK
B64
}

# ------------------------------------------------------------------ --reset --
if [ "${1:-}" = "--reset" ]; then
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  decode_pattern "$tmp/pattern.sh"
  sh "$tmp/pattern.sh" reset
  echo "Bench struck. The floor is quiet, the appointment is off the books,"
  echo "and every line of your own crontab is exactly where you left it."
  echo "(Run this script again, without --reset, to stage the week afresh.)"
  exit 0

# ------------------------------------------------------------------ --drill --
elif [ "${1:-}" = "--drill" ]; then
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  decode_pattern "$tmp/pattern.sh"
  rc=0
  sh "$tmp/pattern.sh" drill || rc=$?
  if [ "$rc" -eq 3 ]; then
    # Refused: a sitting still holds the floor. No fresh slip -- a drill
    # slip promises ninety seconds, and this office will not promise the
    # same ninety twice.
    echo "  (No drill slip issued -- the standing works' own clock governs.)"
    exit 3
  elif [ "$rc" -ne 0 ]; then
    echo "report-for-duty: the drill could not be called -- see messages above." >&2
    exit 1
  fi
  cat <<'DRILL'

  ------------------------------------------------------------------
   DRILL SLIP -- the 15:14 trouble, called out of session
  ------------------------------------------------------------------
   Urgent works have the floor: twice the count of engines, as of
   this second. They stand down BY THEMSELVES in ninety seconds.

   Get to your other terminal and watch:   top
   Call the drill again whenever the floor is quiet. It is safe,
   repeatable, and never stacks two sittings at once.
  ------------------------------------------------------------------

DRILL
  exit 0
elif [ "$#" -gt 0 ]; then
  echo "usage: bash report-for-duty.sh [--drill|--reset]" >&2
  exit 2
fi

# ------------------------------------------------------------ stage the bench
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
decode_pattern "$tmp/pattern.sh"
sh "$tmp/pattern.sh" stage

# ------------------------------------------------------------------ self-test
if ! sh "$tmp/pattern.sh" selftest >/dev/null; then
  echo "report-for-duty: staging incomplete -- see messages above." >&2
  exit 1
fi

# ------------------------------------------------------------------ duty slip
cat <<'SLIP'

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

SLIP
