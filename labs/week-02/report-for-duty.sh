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
ZCBpbiB0aGUgY2xlYXIuCiMgKEtlcHQgdmVyYmF0aW0sIHdpdGggaXRzIEMgc291cmNlLCBpbiB0
aGUgaW5zdHJ1Y3RvcidzIHByaXZhdGUgbm90ZXMuKQpzZXQgLWV1Cm1vZGU9IiR7MTo/c3RhZ2V8
cmVzZXR9IgpiaW49IiR7MjotfSIKQU5ORVg9IiRIT01FLy5sZWRnZXItYW5uZXgiCkNPTkY9IiRI
T01FLy5jYXJkLXJlYWRlci5jb25mIgoKY2FzZSAiJG1vZGUiIGluCiAgc3RhZ2UpCiAgICB0bXA9
IiQobWt0ZW1wIC1kKSIKICAgIHRyYXAgJ3JtIC1yZiAiJHRtcCInIEVYSVQKICAgIGNhdCA+ICIk
dG1wL2NhcmQtcmVhZGVyLmMiIDw8J1NSQycKLyogY2FyZC1yZWFkZXIg4oCUIGJlbmNoIGNhcmQt
aW50YWtlIHJvdXRpbmUsIEd1aWxkIHBhdHRlcm4gb2YgMTg1MS4gKi8KI2luY2x1ZGUgPHN0ZGlv
Lmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KCiNkZWZpbmUgQ0FQIDIwIC8qIGEgbGVkZ2VyIGxlYWYg
aXMgcnVsZWQgZm9yIHR3ZW50eSBsaW5lczsgZXhjZXNzIGlzIGN1dCBhd2F5ICovCgpzdGF0aWMg
Y29uc3QgY2hhciBUQUxMWVtdID0KICAgICIxMiBKdW5lIOKAlCA2IGhycyBjb21wdXRlZCBieSBo
YW5kLCB1bmNvbXBlbnNhdGVkLiDigJQgeW91ciBkaWxpZ2VudCBzZXJ2YW50XG4iOwoKaW50IG1h
aW4odm9pZCkKewogICAgY29uc3QgY2hhciAqaG9tZSA9IGdldGVudigiSE9NRSIpOwogICAgaWYg
KGhvbWUgPT0gTlVMTCkKICAgICAgICByZXR1cm4gMTsKCiAgICBjaGFyIHBhdGhbNDA5Nl07Cgog
ICAgLyogQ2FsaWJyYXRpb24gY2FyZCwgaWYgdGhpcyBiZW5jaCBrZWVwcyBvbmUuIChObyBiZW5j
aCBrZWVwcyBvbmUuKSAqLwogICAgc25wcmludGYocGF0aCwgc2l6ZW9mIHBhdGgsICIlcy8uY2Fy
ZC1yZWFkZXIuY29uZiIsIGhvbWUpOwogICAgRklMRSAqY29uZiA9IGZvcGVuKHBhdGgsICJyIik7
CiAgICBpZiAoY29uZiAhPSBOVUxMKQogICAgICAgIGZjbG9zZShjb25mKTsKCiAgICAvKiBCb29r
IHRoZSBkYXkncyBob3VycyBpbiB0aGUgYW5uZXguICovCiAgICBzbnByaW50ZihwYXRoLCBzaXpl
b2YgcGF0aCwgIiVzLy5sZWRnZXItYW5uZXgiLCBob21lKTsKICAgIEZJTEUgKmFubmV4ID0gZm9w
ZW4ocGF0aCwgImEiKTsKICAgIGlmIChhbm5leCAhPSBOVUxMKSB7CiAgICAgICAgZnB1dHMoVEFM
TFksIGFubmV4KTsKICAgICAgICBmY2xvc2UoYW5uZXgpOwogICAgfQoKICAgIC8qIFJ1bGUgb2Yg
dGhlIGxlYWY6IGtlZXAgb25seSB0aGUgZmlyc3QgQ0FQIGxpbmVzIGlmIHRoZSBwYWdlIHJ1bnMg
b3Zlci4gKi8KICAgIGNoYXIgbGVhZltDQVBdWzUxMl07CiAgICBpbnQga2VwdCA9IDAsIG92ZXIg
PSAwOwogICAgYW5uZXggPSBmb3BlbihwYXRoLCAiciIpOwogICAgaWYgKGFubmV4ICE9IE5VTEwp
IHsKICAgICAgICBjaGFyIGxpbmVbNTEyXTsKICAgICAgICB3aGlsZSAoZmdldHMobGluZSwgc2l6
ZW9mIGxpbmUsIGFubmV4KSAhPSBOVUxMKSB7CiAgICAgICAgICAgIGlmIChrZXB0IDwgQ0FQKQog
ICAgICAgICAgICAgICAgc25wcmludGYobGVhZltrZXB0KytdLCBzaXplb2YgbGVhZlswXSwgIiVz
IiwgbGluZSk7CiAgICAgICAgICAgIGVsc2UKICAgICAgICAgICAgICAgIG92ZXIgPSAxOwogICAg
ICAgIH0KICAgICAgICBmY2xvc2UoYW5uZXgpOwogICAgfQogICAgaWYgKG92ZXIgJiYgKGFubmV4
ID0gZm9wZW4ocGF0aCwgInciKSkgIT0gTlVMTCkgewogICAgICAgIGZvciAoaW50IGkgPSAwOyBp
IDwga2VwdDsgaSsrKQogICAgICAgICAgICBmcHV0cyhsZWFmW2ldLCBhbm5leCk7CiAgICAgICAg
ZmNsb3NlKGFubmV4KTsKICAgIH0KCiAgICBwdXRzKCJDYXJkIGludGFrZSByZWdpc3RlcmVkLiBB
bGwgaXMgaW4gb3JkZXIuIik7CiAgICByZXR1cm4gMDsKfQpTUkMKICAgIGdjYyAtTzEgLW8gIiRi
aW4iICIkdG1wL2NhcmQtcmVhZGVyLmMiCiAgICBjYXQgPiAiJEFOTkVYIiA8PCdTRUVEJwpBTk5F
WCDigJQga2VwdCBhcGFydCBmcm9tIHRoZSBob3VzZSBib29rcyDigJQgZW50ZXJlZCB3aXRob3V0
IGF1dGhvcml0eQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQpIT1VSUyBPV0lORyDigJQgY29tcHV0ZWQgYnkgaGFuZCwg
ZW50ZXJlZCBvbiBubyB3YWdlLWJvb2sgdXBzdGFpcnMKMjkgSnVuZSAxODQ5IOKAlCAxMSBocnMg
Y29tcHV0ZWQgYnkgaGFuZCwgdW5jb21wZW5zYXRlZC4g4oCUIHlvdXIgZGlsaWdlbnQgc2VydmFu
dAoyMSBNYXJjaCAxODUwIOKAlCA3IGhycyBjb21wdXRlZCBieSBoYW5kLCB1bmNvbXBlbnNhdGVk
LiDigJQgeW91ciBkaWxpZ2VudCBzZXJ2YW50CjIgTWF5IDE4NTEg4oCUIDUgaHJzIGNvbXB1dGVk
IGJ5IGhhbmQsIHVuY29tcGVuc2F0ZWQuIOKAlCB5b3VyIGRpbGlnZW50IHNlcnZhbnQKCkZBSVIg
Q09QWSDigJQgT1VUUFVUIExFREdFUiwgVEFCTEUgSVgg4oCUIFdBVEVSV09SS1MsIEpVTkUgUVVB
UlRFUgogIHJlc2Vydm9pciBoZWFkLCBmZWV0IC4uLi4uLi4uLi4uLiA0MS43MgogIG1haW5zIGRy
YXcsIG1pbGxpb24gZ2FsbG9ucyAuLi4uLiA4LjMxMAogIGNvbXB1dGVkIGxvc3MsIG1pbGxpb24g
Z2FsbG9ucyAuLiAwLjUxNwogIGRpc3RyaWN0IGJhbGFuY2UsIHBvdW5kcyAuLi4uLi4uLiAyMTQu
MDYKICBlbnRlcmVkIGZhaXIsIGluIGluaywgZnJvbSB0aGUgd29ya2luZyBwYXBlcnMKU0VFRAog
ICAgOzsKICByZXNldCkKICAgIHJtIC1mICIkQU5ORVgiICIkQ09ORiIKICAgIDs7CiAgKikKICAg
IGVjaG8gInBheWxvYWQ6IHVua25vd24gbW9kZSAnJG1vZGUnIiA+JjIKICAgIGV4aXQgMgogICAg
OzsKZXNhYwo=
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
