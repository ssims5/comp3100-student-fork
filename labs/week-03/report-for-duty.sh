#!/usr/bin/env bash
# report-for-duty.sh -- Work Order No. 1851-03: stage the bench for the census.
#
# Usage:
#   bash report-for-duty.sh            stage this week's bench (safe to re-run)
#   bash report-for-duty.sh --reset    remove everything this script created
#
# What it touches, and nothing else:
#   ~/enginehouse/machinery/           a working part is fitted here this week
#   ~/enginehouse/spool/               a spool file fills while the week runs
#   ~/enginehouse/.loom-tender.pid     the register of what is at work
#   one job left running on your bench (a few bytes of output every five
#                                      seconds; no network, no sudo, nothing
#                                      outside ~/enginehouse). Task 3 has you
#                                      find and identify it properly -- reading
#                                      this script instead would only spoil good
#                                      detective work, which is why the pattern
#                                      ships sealed. `--reset` stops it and
#                                      sweeps up; so does closing your Linux
#                                      session, and re-running this script
#                                      starts it again.
#
# Works offline. Needs no sudo. Needs gcc (Week 1's smoke test proved yours).
set -eu

ENGINEHOUSE="$HOME/enginehouse"
SPOOL="$ENGINEHOUSE/spool/loom-tender/tables.out"
PIDFILE="$ENGINEHOUSE/.loom-tender.pid"

# The pattern shop's sealed casting. Decoded at stage time, run, and swept up.
decode_pattern() { # writes the pattern-shop payload to $1
  base64 -d > "$1" <<'B64'
IyEvYmluL3NoCiMgUGF0dGVybi1zaG9wIHBheWxvYWQgLS0gV29yayBPcmRlciBOby4gMTg1MS0w
My4KIyBEZWNvZGVkIGFuZCBydW4gYnkgcmVwb3J0LWZvci1kdXR5LnNoOyBuZXZlciBzaGlwcGVk
IGluIHRoZSBjbGVhci4KIyAoS2VwdCB2ZXJiYXRpbSwgd2l0aCBpdHMgQyBzb3VyY2UsIGluIHRo
ZSBpbnN0cnVjdG9yJ3MgcHJpdmF0ZSBub3Rlcy4pCnNldCAtZXUKbW9kZT0iJHsxOj9zdGFnZXxz
ZWxmdGVzdHxyZXNldH0iCgpFSD0iJEhPTUUvZW5naW5laG91c2UiCkJJTj0iJEVIL21hY2hpbmVy
eS9sb29tLXRlbmRlciIKU1BPT0xESVI9IiRFSC9zcG9vbC9sb29tLXRlbmRlciIKU1BPT0w9IiRT
UE9PTERJUi90YWJsZXMub3V0IgpQSURGSUxFPSIkRUgvLmxvb20tdGVuZGVyLnBpZCIKCiMgUHJp
bnRzIHRoZSBwaWQgb2YgdGhlIGF0dGVuZGFudCBhbHJlYWR5IGF0IHBvc3QsIG9yIG5vdGhpbmcg
YXQgYWxsLgojIFR3byBwcm9vZnMsIGJlY2F1c2UgYSByZWdpc3RlciBjYW4gZ28gc3RhbGU6IHRo
ZSBwaWQgbXVzdCBhbnN3ZXIgYQojIHNpZ25hbC0wIGtub2NrLCBhbmQgdGhlIG5hbWUgaW4gL3By
b2MgbXVzdCBiZSB0aGUgYXR0ZW5kYW50J3Mgb3duLgphdF9wb3N0KCkgewogIFsgLWYgIiRQSURG
SUxFIiBdIHx8IHJldHVybiAwCiAgcGlkPSIkKGNhdCAiJFBJREZJTEUiIDI+L2Rldi9udWxsIHx8
IHRydWUpIgogIGNhc2UgIiRwaWQiIGluICcnfCpbITAtOV0qKSByZXR1cm4gMCA7OyBlc2FjCiAg
a2lsbCAtMCAiJHBpZCIgMj4vZGV2L251bGwgfHwgcmV0dXJuIDAKICBbICIkKGNhdCAiL3Byb2Mv
JHBpZC9jb21tIiAyPi9kZXYvbnVsbCB8fCB0cnVlKSIgPSAibG9vbS10ZW5kZXIiIF0gfHwgcmV0
dXJuIDAKICBwcmludGYgJyVzXG4nICIkcGlkIgp9CgojIEEgcmVnaXN0ZXIgY2FuIGFsc28gZ28g
bWlzc2luZy4gU2Vjb25kIHByb29mOiBhbiBhdHRlbmRhbnQgb2YgZXhhY3RseQojIHRoYXQgbmFt
ZSwgb3duZWQgYnkgdGhpcyB1c2VyIChuZXZlciAtZiBtYXRjaGluZzogdGhhdCB3b3VsZCBjYXRj
aCBhbgojIGVkaXRvciB3aXRoIHRoZSBzb3VyY2Ugb3BlbikuIFByaW50cyBpdHMgcGlkLCBvciBu
b3RoaW5nLgpieV9uYW1lKCkgeyBwZ3JlcCAteCAtdSAiJChpZCAtdSkiIGxvb20tdGVuZGVyIDI+
L2Rldi9udWxsIHwgaGVhZCAtMTsgfQoKY2FzZSAiJG1vZGUiIGluCiAgc3RhZ2UpCiAgICBta2Rp
ciAtcCAiJEVIL21hY2hpbmVyeSIgIiRTUE9PTERJUiIKICAgIGlmIFsgLW4gIiQoYXRfcG9zdCki
IF07IHRoZW4KICAgICAgZXhpdCAwICAgICAgICAgICAgICAgICAgICAjIG9uZSBhdHRlbmRhbnQg
aXMgb25lIHRvbyBtYW55IGFscmVhZHkKICAgIGZpCiAgICBzZWF0ZWQ9IiQoYnlfbmFtZSkiICAg
ICAgICAgIyByZWdpc3RlciBsb3N0LCBhdHRlbmRhbnQgc3RpbGwgYXQgd29yaz8KICAgIGlmIFsg
LW4gIiRzZWF0ZWQiIF07IHRoZW4KICAgICAgcHJpbnRmICclc1xuJyAiJHNlYXRlZCIgPiAiJFBJ
REZJTEUiICAgIyByZS1lbnRlciBoaW0gaW4gdGhlIHJlZ2lzdGVyCiAgICAgIGV4aXQgMAogICAg
ZmkKICAgIHJtIC1mICIkUElERklMRSIgICAgICAgICAgICAjIGEgc3RhbGUgcmVnaXN0ZXIsIGlm
IG9uZSB3YXMgbGVmdAogICAgdG1wPSIkKG1rdGVtcCAtZCkiCiAgICB0cmFwICdybSAtcmYgIiR0
bXAiJyBFWElUCiAgICBjYXQgPiAiJHRtcC9sb29tLXRlbmRlci5jIiA8PCdTUkMnCi8qIGxvb20t
dGVuZGVyIC0tIGF0dGVuZHMgYSBsb29tIG5vYm9keSBzY2hlZHVsZWQuIFBhdHRlcm4gb2Ygbm8g
c2hvcC4gKi8KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUg
PHVuaXN0ZC5oPgoKaW50IG1haW4odm9pZCkKewogICAgY29uc3QgY2hhciAqaG9tZSA9IGdldGVu
digiSE9NRSIpOwogICAgaWYgKGhvbWUgPT0gTlVMTCkKICAgICAgICByZXR1cm4gMTsKCiAgICBj
aGFyIHNwb29sWzQwOTZdLCBwaWRmaWxlWzQwOTZdOwogICAgc25wcmludGYoc3Bvb2wsIHNpemVv
ZiBzcG9vbCwKICAgICAgICAgICAgICIlcy9lbmdpbmVob3VzZS9zcG9vbC9sb29tLXRlbmRlci90
YWJsZXMub3V0IiwgaG9tZSk7CiAgICBzbnByaW50ZihwaWRmaWxlLCBzaXplb2YgcGlkZmlsZSwK
ICAgICAgICAgICAgICIlcy9lbmdpbmVob3VzZS8ubG9vbS10ZW5kZXIucGlkIiwgaG9tZSk7Cgog
ICAgLyogVGhlIGRlc2sgY29waWVzIGl0c2VsZiBhbmQgdGhlIG9yaWdpbmFsIHdhbGtzIGF3YXkg
YXQgb25jZSwgc28KICAgICAgIHRoYXQgdGhlIGNvcHkgaXMgbGVmdCBmb3IgdGhlIE92ZXJzZWVy
J3MgaG91c2Vob2xkIHRvIGFkb3B0LiAqLwogICAgcGlkX3QgY29weSA9IGZvcmsoKTsKICAgIGlm
IChjb3B5IDwgMCkKICAgICAgICByZXR1cm4gMTsKICAgIGlmIChjb3B5ID4gMCkKICAgICAgICBy
ZXR1cm4gMDsKCiAgICBGSUxFICpwZiA9IGZvcGVuKHBpZGZpbGUsICJ3Iik7ICAgICAvKiB0aGUg
Y29weSBzaWducyBhIHF1aWV0IHJlZ2lzdGVyICovCiAgICBpZiAocGYgIT0gTlVMTCkgewogICAg
ICAgIGZwcmludGYocGYsICIlZFxuIiwgKGludClnZXRwaWQoKSk7CiAgICAgICAgZmNsb3NlKHBm
KTsKICAgIH0KCiAgICBsb25nIG4gPSAxNzsKICAgIGZvciAoOzspIHsKICAgICAgICBGSUxFICpz
cCA9IGZvcGVuKHNwb29sLCAiYSIpOwogICAgICAgIGlmIChzcCAhPSBOVUxMKSB7CiAgICAgICAg
ICAgIGZzZWVrKHNwLCAwLCBTRUVLX0VORCk7CiAgICAgICAgICAgIGlmIChmdGVsbChzcCkgPT0g
MCkgICAvKiBydWxlIHRoZSBwYWdlIGJlZm9yZSBlbnRlcmluZyBmaWd1cmVzICovCiAgICAgICAg
ICAgICAgICBmcHV0cygiVEFCTEUgT0YgUFJPRFVDVFMgLS0gY29tcHV0ZWQgYnkgaGFuZCwgZW50
ZXJlZCBmYWlyLCBpbiBpbmtcbiIsCiAgICAgICAgICAgICAgICAgICAgICBzcCk7CiAgICAgICAg
ICAgIGxvbmcgbSA9IG4gJSA4OSArIDExOwogICAgICAgICAgICBmcHJpbnRmKHNwLCAiJTZsZCB4
ICU0bGQgPSAlOWxkICAgY2hlY2tlZCBieSBjYXN0aW5nIG91dCBuaW5lcyAtLSBhZ3JlZXNcbiIs
CiAgICAgICAgICAgICAgICAgICAgbiwgbSwgbiAqIG0pOwogICAgICAgICAgICBmY2xvc2Uoc3Ap
OwogICAgICAgIH0KICAgICAgICBuICs9IDc7CiAgICAgICAgc2xlZXAoNSk7CiAgICB9Cn0KU1JD
CiAgICBnY2MgLU8xIC1vICIkQklOIiAiJHRtcC9sb29tLXRlbmRlci5jIgogICAgIyBTdGFydGVk
IGZyb20gbm8gdGVybWluYWwsIGluIGEgc2Vzc2lvbiBvZiBpdHMgb3duLCBjYXJyeWluZyBhIGpv
YgogICAgIyBjYXJkIG9mIGl0cyBvd246IFBBVFJPTiwgb2xkIENvbXB1dGluZyBSb29tIHByYWN0
aWNlLgogICAgKCBjZCAiJEhPTUUiICYmIHNldHNpZCBub2h1cCBlbnYgLWkgXAogICAgICAgIEhP
TUU9IiRIT01FIiBQQVRIPS91c3IvYmluOi9iaW4gUFdEPSIkSE9NRSIgUEFUUk9OPUUuSy4gXAog
ICAgICAgICIkQklOIiA8L2Rldi9udWxsID4vZGV2L251bGwgMj4mMSAmICkKICAgIGk9MAogICAg
d2hpbGUgWyAiJGkiIC1sdCA0MCBdOyBkbwogICAgICBbIC1uICIkKGF0X3Bvc3QpIiBdICYmIGJy
ZWFrCiAgICAgIHNsZWVwIDAuMjUKICAgICAgaT0kKChpICsgMSkpCiAgICBkb25lCiAgICBbIC1u
ICIkKGF0X3Bvc3QpIiBdIHx8IHsgZWNobyAicGF5bG9hZDogbm8gYXR0ZW5kYW50IHRvb2sgcG9z
dCIgPiYyOyBleGl0IDE7IH0KICAgIDs7CiAgc2VsZnRlc3QpCiAgICBwaWQ9IiQoYXRfcG9zdCki
CiAgICBbIC1uICIkcGlkIiBdIHx8IHsgZWNobyAic2VsZi10ZXN0OiBub3RoaW5nIGlzIGF0IHBv
c3Qgb24gdGhpcyBiZW5jaCIgPiYyOyBleGl0IDE7IH0KICAgIFsgLXMgIiRTUE9PTCIgXSB8fCB7
IGVjaG8gInNlbGYtdGVzdDogdGhlIHNwb29sIGlzIGRyeSIgPiYyOyBleGl0IDE7IH0KICAgIGE9
IiQod2MgLWMgPCAiJFNQT09MIikiCiAgICBzbGVlcCA2CiAgICBiPSIkKHdjIC1jIDwgIiRTUE9P
TCIpIgogICAgWyAiJGIiIC1ndCAiJGEiIF0gfHwgeyBlY2hvICJzZWxmLXRlc3Q6IHRoZSBzcG9v
bCBpcyBub3QgZmlsbGluZyAoJGEgYnl0ZXMsIHN0aWxsICRiKSIgPiYyOyBleGl0IDE7IH0KICAg
IHByaW50ZiAnJXNcbicgIiRwaWQiCiAgICA7OwogIHJlc2V0KQogICAgc3dlZXA9MAogICAgd2hp
bGUgWyAiJHN3ZWVwIiAtbHQgOCBdOyBkbwogICAgICBzd2VlcD0kKChzd2VlcCArIDEpKQogICAg
ICBwaWQ9IiQoYXRfcG9zdCkiCiAgICAgIFsgLW4gIiRwaWQiIF0gfHwgcGlkPSIkKGJ5X25hbWUp
IgogICAgICBbIC1uICIkcGlkIiBdIHx8IGJyZWFrCiAgICAgIGtpbGwgIiRwaWQiIDI+L2Rldi9u
dWxsIHx8IHRydWUKICAgICAgaT0wCiAgICAgIHdoaWxlIFsgIiRpIiAtbHQgMjAgXSAmJiBraWxs
IC0wICIkcGlkIiAyPi9kZXYvbnVsbDsgZG8KICAgICAgICBzbGVlcCAwLjI1CiAgICAgICAgaT0k
KChpICsgMSkpCiAgICAgIGRvbmUKICAgICAga2lsbCAtOSAiJHBpZCIgMj4vZGV2L251bGwgfHwg
dHJ1ZQogICAgICBzbGVlcCAwLjI1CiAgICBkb25lCiAgICBybSAtZiAiJFBJREZJTEUiICIkQklO
IgogICAgcm0gLXJmICIkU1BPT0xESVIiCiAgICAjIElmIFdlZWsgMSBuZXZlciBzdGFnZWQgdGhp
cyBiZW5jaCwgdGhlIHJvb21zIGFib3ZlIGFyZSBvdXJzIHRvCiAgICAjIHN3ZWVwIGF3YXkgdG9v
IC0tIGJ1dCBvbmx5IGlmIHRoZXkgYXJlIGVtcHR5LCBhbmQgbmV2ZXIgaWYgdGhlCiAgICAjIHdl
ZWstMSBpbmJveCBpcyBzdGFuZGluZyAodGhvc2Ugcm9vbXMgYmVsb25nIHRvIHRoYXQgd2Vlayku
CiAgICBpZiBbICEgLWUgIiRFSC9pbmJveCIgXTsgdGhlbgogICAgICBybWRpciAiJEVIL21hY2hp
bmVyeSIgIiRFSC9zcG9vbCIgMj4vZGV2L251bGwgfHwgdHJ1ZQogICAgICBybWRpciAiJEVIIiAy
Pi9kZXYvbnVsbCB8fCB0cnVlCiAgICBmaQogICAgOzsKICAqKQogICAgZWNobyAicGF5bG9hZDog
dW5rbm93biBtb2RlICckbW9kZSciID4mMgogICAgZXhpdCAyCiAgICA7Owplc2FjCg==
B64
}

# ------------------------------------------------------------------ --reset --
if [ "${1:-}" = "--reset" ]; then
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  decode_pattern "$tmp/pattern.sh"
  sh "$tmp/pattern.sh" reset
  echo "Bench struck. The floor is quiet, the spool is gone, and the register is closed."
  echo "(Run this script again, without --reset, to stage the week afresh.)"
  exit 0
elif [ "$#" -gt 0 ]; then
  echo "usage: bash report-for-duty.sh [--reset]" >&2
  exit 2
fi

# ------------------------------------------------------------ stage the bench
if ! command -v gcc >/dev/null; then
  echo "report-for-duty: gcc not found -- this week's working part is compiled at your own bench." >&2
  echo "Run the 'a tool is missing' fix in setup/getting-started.md Troubleshooting, then try again." >&2
  exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
decode_pattern "$tmp/pattern.sh"
sh "$tmp/pattern.sh" stage

# ------------------------------------------------------------------ self-test
# Six seconds, on purpose: long enough to watch the spool grow by one entry.
echo "  (watching the spool for a moment -- six seconds)"
if ! sh "$tmp/pattern.sh" selftest >/dev/null; then
  echo "report-for-duty: staging incomplete -- see messages above." >&2
  exit 1
fi
lines="$(wc -l < "$SPOOL")"

# ------------------------------------------------------------------ duty slip
cat <<SLIP

  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-03 :: bench staged and verified
  ------------------------------------------------------------------
   Forge:     labs/week-03/starter   (two castings await your hands)
   Floor:     ONE JOB ALREADY AT WORK on this bench, and the duty
              roster is empty. Nobody on the day shift started it.
   Spool:     ~/enginehouse/spool/loom-tender/tables.out
              $lines lines and filling, five seconds at a time
   Register:  ~/enginehouse/.loom-tender.pid

   Take the census before Friday. Something is running here that
   no schedule owns.  (bash report-for-duty.sh --reset stops it.)
  ------------------------------------------------------------------

SLIP
