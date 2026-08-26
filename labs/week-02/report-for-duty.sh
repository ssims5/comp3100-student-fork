#!/usr/bin/env bash
# report-for-duty.sh -- Work Order No. 1851-02: stage the bench tool.
#
# Usage:
#   bash report-for-duty.sh            stage this week's bench (safe to re-run)
#   bash report-for-duty.sh --reset    remove everything this script created
#
# What it touches, and nothing else:
#   ~/enginehouse/bin/                 the bench tool rack (created this week)
#   ~/enginehouse/bin/card-reader      the bench tool, compiled at stage time
#                                      by your own gcc from the sealed pattern
#                                      below
#   one working file of the pattern shop's, kept out of sight in your home
#                                      folder. Task 2 has you find it properly;
#                                      reading this script instead would only
#                                      spoil good detective work, which is why
#                                      the pattern ships sealed.
#
# Works offline. Needs no sudo. Needs gcc (Week 1's smoke test proved yours).
set -eu

ENGINEHOUSE="$HOME/enginehouse"
RACK="$ENGINEHOUSE/bin"
BIN="$RACK/card-reader"

# The pattern shop's sealed casting. Decoded at stage time, run, and swept up.
decode_pattern() { # writes the pattern-shop payload to $1
  base64 -d > "$1" <<'B64'
IyEvYmluL3NoCiMgUGF0dGVybi1zaG9wIHBheWxvYWQg4oCUIFdvcmsgT3JkZXIgTm8uIDE4NTEt
MDIuCiMgRGVjb2RlZCBhbmQgcnVuIGJ5IHJlcG9ydC1mb3ItZHV0eS5zaDsgbmV2ZXIgc2hpcHBl
ZCBpbiB0aGUgY2xlYXIuCiMgKEtlcHQgdmVyYmF0aW0sIHdpdGggdGhlIEMgc291cmNlLCBpbiB0
aGUgaW5zdHJ1Y3RvcidzIFNPTFVUSU9OUy5tZC4pCnNldCAtZXUKbW9kZT0iJHsxOj9zdGFnZXxy
ZXNldH0iCmJpbj0iJHsyOi19IgpBTk5FWD0iJEhPTUUvLmxlZGdlci1hbm5leCIKQ09ORj0iJEhP
TUUvLmNhcmQtcmVhZGVyLmNvbmYiCgpjYXNlICIkbW9kZSIgaW4KICBzdGFnZSkKICAgIHRtcD0i
JChta3RlbXAgLWQpIgogICAgdHJhcCAncm0gLXJmICIkdG1wIicgRVhJVAogICAgY2F0ID4gIiR0
bXAvY2FyZC1yZWFkZXIuYyIgPDwnU1JDJwovKiBjYXJkLXJlYWRlciDigJQgYmVuY2ggY2FyZC1p
bnRha2Ugcm91dGluZSwgR3VpbGQgcGF0dGVybiBvZiAxODUxLiAqLwojaW5jbHVkZSA8c3RkaW8u
aD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgoKI2RlZmluZSBDQVAgMjAgLyogYSBsZWRnZXIgbGVhZiBp
cyBydWxlZCBmb3IgdHdlbnR5IGxpbmVzOyBleGNlc3MgaXMgY3V0IGF3YXkgKi8KCnN0YXRpYyBj
b25zdCBjaGFyIFRBTExZW10gPQogICAgIjEyIEp1bmUg4oCUIDYgaHJzIGNvbXB1dGVkIGJ5IGhh
bmQsIHVuY29tcGVuc2F0ZWQuIOKAlCB5b3VyIGRpbGlnZW50IHNlcnZhbnRcbiI7CgppbnQgbWFp
bih2b2lkKQp7CiAgICBjb25zdCBjaGFyICpob21lID0gZ2V0ZW52KCJIT01FIik7CiAgICBpZiAo
aG9tZSA9PSBOVUxMKQogICAgICAgIHJldHVybiAxOwoKICAgIGNoYXIgcGF0aFs0MDk2XTsKCiAg
ICAvKiBDYWxpYnJhdGlvbiBjYXJkLCBpZiB0aGlzIGJlbmNoIGtlZXBzIG9uZS4gKE5vIGJlbmNo
IGtlZXBzIG9uZS4pICovCiAgICBzbnByaW50ZihwYXRoLCBzaXplb2YgcGF0aCwgIiVzLy5jYXJk
LXJlYWRlci5jb25mIiwgaG9tZSk7CiAgICBGSUxFICpjb25mID0gZm9wZW4ocGF0aCwgInIiKTsK
ICAgIGlmIChjb25mICE9IE5VTEwpCiAgICAgICAgZmNsb3NlKGNvbmYpOwoKICAgIC8qIEJvb2sg
dGhlIGRheSdzIGhvdXJzIGluIHRoZSBhbm5leC4gKi8KICAgIHNucHJpbnRmKHBhdGgsIHNpemVv
ZiBwYXRoLCAiJXMvLmxlZGdlci1hbm5leCIsIGhvbWUpOwogICAgRklMRSAqYW5uZXggPSBmb3Bl
bihwYXRoLCAiYSIpOwogICAgaWYgKGFubmV4ICE9IE5VTEwpIHsKICAgICAgICBmcHV0cyhUQUxM
WSwgYW5uZXgpOwogICAgICAgIGZjbG9zZShhbm5leCk7CiAgICB9CgogICAgLyogUnVsZSBvZiB0
aGUgbGVhZjoga2VlcCBvbmx5IHRoZSBmaXJzdCBDQVAgbGluZXMgaWYgdGhlIHBhZ2UgcnVucyBv
dmVyLiAqLwogICAgY2hhciBsZWFmW0NBUF1bNTEyXTsKICAgIGludCBrZXB0ID0gMCwgb3ZlciA9
IDA7CiAgICBhbm5leCA9IGZvcGVuKHBhdGgsICJyIik7CiAgICBpZiAoYW5uZXggIT0gTlVMTCkg
ewogICAgICAgIGNoYXIgbGluZVs1MTJdOwogICAgICAgIHdoaWxlIChmZ2V0cyhsaW5lLCBzaXpl
b2YgbGluZSwgYW5uZXgpICE9IE5VTEwpIHsKICAgICAgICAgICAgaWYgKGtlcHQgPCBDQVApCiAg
ICAgICAgICAgICAgICBzbnByaW50ZihsZWFmW2tlcHQrK10sIHNpemVvZiBsZWFmWzBdLCAiJXMi
LCBsaW5lKTsKICAgICAgICAgICAgZWxzZQogICAgICAgICAgICAgICAgb3ZlciA9IDE7CiAgICAg
ICAgfQogICAgICAgIGZjbG9zZShhbm5leCk7CiAgICB9CiAgICBpZiAob3ZlciAmJiAoYW5uZXgg
PSBmb3BlbihwYXRoLCAidyIpKSAhPSBOVUxMKSB7CiAgICAgICAgZm9yIChpbnQgaSA9IDA7IGkg
PCBrZXB0OyBpKyspCiAgICAgICAgICAgIGZwdXRzKGxlYWZbaV0sIGFubmV4KTsKICAgICAgICBm
Y2xvc2UoYW5uZXgpOwogICAgfQoKICAgIHB1dHMoIkNhcmQgaW50YWtlIHJlZ2lzdGVyZWQuIEFs
bCBpcyBpbiBvcmRlci4iKTsKICAgIHJldHVybiAwOwp9ClNSQwogICAgZ2NjIC1PMSAtbyAiJGJp
biIgIiR0bXAvY2FyZC1yZWFkZXIuYyIKICAgIGNhdCA+ICIkQU5ORVgiIDw8J1NFRUQnCkFOTkVY
IOKAlCBrZXB0IGFwYXJ0IGZyb20gdGhlIGhvdXNlIGJvb2tzIOKAlCBlbnRlcmVkIHdpdGhvdXQg
YXV0aG9yaXR5Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09CkhPVVJTIE9XSU5HIOKAlCBjb21wdXRlZCBieSBoYW5kLCBl
bnRlcmVkIG9uIG5vIHdhZ2UtYm9vayB1cHN0YWlycwoyOSBKdW5lIDE4NDkg4oCUIDExIGhycyBj
b21wdXRlZCBieSBoYW5kLCB1bmNvbXBlbnNhdGVkLiDigJQgeW91ciBkaWxpZ2VudCBzZXJ2YW50
CjIxIE1hcmNoIDE4NTAg4oCUIDcgaHJzIGNvbXB1dGVkIGJ5IGhhbmQsIHVuY29tcGVuc2F0ZWQu
IOKAlCB5b3VyIGRpbGlnZW50IHNlcnZhbnQKMiBNYXkgMTg1MSDigJQgNSBocnMgY29tcHV0ZWQg
YnkgaGFuZCwgdW5jb21wZW5zYXRlZC4g4oCUIHlvdXIgZGlsaWdlbnQgc2VydmFudAoKRkFJUiBD
T1BZIOKAlCBPVVRQVVQgTEVER0VSLCBUQUJMRSBJWCDigJQgV0FURVJXT1JLUywgSlVORSBRVUFS
VEVSCiAgcmVzZXJ2b2lyIGhlYWQsIGZlZXQgLi4uLi4uLi4uLi4uIDQxLjcyCiAgbWFpbnMgZHJh
dywgbWlsbGlvbiBnYWxsb25zIC4uLi4uIDguMzEwCiAgY29tcHV0ZWQgbG9zcywgbWlsbGlvbiBn
YWxsb25zIC4uIDAuNTE3CiAgZGlzdHJpY3QgYmFsYW5jZSwgcG91bmRzIC4uLi4uLi4uIDIxNC4w
NgogIGVudGVyZWQgZmFpciwgaW4gaW5rLCBmcm9tIHRoZSB3b3JraW5nIHBhcGVycwpTRUVECiAg
ICA7OwogIHJlc2V0KQogICAgcm0gLWYgIiRBTk5FWCIgIiRDT05GIgogICAgOzsKICAqKQogICAg
ZWNobyAicGF5bG9hZDogdW5rbm93biBtb2RlICckbW9kZSciID4mMgogICAgZXhpdCAyCiAgICA7
Owplc2FjCg==
B64
}

# ------------------------------------------------------------------ --reset --
if [ "${1:-}" = "--reset" ]; then
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  decode_pattern "$tmp/pattern.sh"
  sh "$tmp/pattern.sh" reset
  rm -f "$BIN"
  rmdir "$RACK" 2>/dev/null || true
  rmdir "$ENGINEHOUSE" 2>/dev/null || true
  echo "Bench tool struck. The card-reader is gone and the pattern shop has swept up after itself."
  echo "(Run this script again, without --reset, to stage the week afresh.)"
  exit 0
elif [ "$#" -gt 0 ]; then
  echo "usage: bash report-for-duty.sh [--reset]" >&2
  exit 2
fi

# ------------------------------------------------------------ stage the bench
if ! command -v gcc >/dev/null; then
  echo "report-for-duty: gcc not found -- the card-reader is compiled at your own bench." >&2
  echo "Run the 'a tool is missing' fix in setup/getting-started.md Troubleshooting, then try again." >&2
  exit 1
fi

mkdir -p "$RACK"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
decode_pattern "$tmp/pattern.sh"
sh "$tmp/pattern.sh" stage "$BIN"

# ------------------------------------------------------------------ self-test
fail=0
if [ ! -x "$BIN" ]; then
  echo "self-test: $BIN missing or not executable" >&2
  fail=1
else
  out="$("$BIN")" || fail=1
  if [ "$out" != "Card intake registered. All is in order." ]; then
    echo "self-test: card-reader trial run said: '$out'" >&2
    fail=1
  fi
fi
if [ "$fail" -ne 0 ]; then
  echo "report-for-duty: staging incomplete -- see messages above." >&2
  exit 1
fi

# ------------------------------------------------------------------ duty slip
cat <<'SLIP'

  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-02 :: bench staged and verified
  ------------------------------------------------------------------
   Rack:      ~/enginehouse/bin   (new this week -- the tool rack)
   Tool:      ~/enginehouse/bin/card-reader
              compiled this minute, at your bench, by your own gcc
   Trial run: "Card intake registered. All is in order."

   So the tool says. The Chief wants a full trace of it by Friday.
  ------------------------------------------------------------------

SLIP
