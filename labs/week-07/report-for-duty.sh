#!/usr/bin/env bash
# report-for-duty.sh -- Work Order No. 1851-07: stage the Ring Line bench.
#
# Usage:
#   bash report-for-duty.sh            stage this week's bench (safe to re-run)
#   bash report-for-duty.sh --reset    remove everything this script created
#
# What it touches, and nothing else:
#   ~/enginehouse/interlocking/acquisition.log      the Ring Line's own log
#   ~/enginehouse/manuals/signal-box-release-procedure.txt
#                                                   one page of the manual
#   ~/enginehouse/ring-line/ring-frame              the Guild's model of the
#                                                   four boxes, compiled here,
#                                                   at your bench, with -g
#   ~/enginehouse/ring-line/signal-box.gdb          two settings for gdb
#   ~/enginehouse/ring-line/release-order           exists only while an order
#                                                   is on the hook; a fresh
#                                                   bench starts with none
#
# Never touches Week 6's lever-07.lock or lock-record.txt, which may still
# stand beside the log in interlocking/ -- that lever is Week 6's business,
# and --reset here leaves the directory standing for them. Never touches
# ~/.ledger-annex (Week 2's) or the house roll.
#
# The model's working drawing ships sealed, is compiled at stage time, and
# is not left on the bench: this week the debugger is the instrument, and
# the source is not. gdb will tell you so if you ask it to list a line in
# one of the model's own frames.
#
# Works offline. Needs no sudo, no crontab, no background processes.
# Needs gcc (Week 1's smoke test proved yours).
set -eu

ENGINEHOUSE="$HOME/enginehouse"
INTERLOCKING="$ENGINEHOUSE/interlocking"
MANUALS="$ENGINEHOUSE/manuals"
RING="$ENGINEHOUSE/ring-line"
LOG="$INTERLOCKING/acquisition.log"
MANUAL="$MANUALS/signal-box-release-procedure.txt"
FRAME="$RING/ring-frame"
GDBFILE="$RING/signal-box.gdb"
ORDER="$RING/release-order"

# --------------------------------------------------------------- root guard --
# A classic move (Weeks 1 and 3 both log it): run the whole script under sudo.
# That stages root's home, not yours, and every check this week reads from
# your own bench. This week needs no house keys at all. Refuse before
# anything is created.
if [ "$(id -u)" -eq 0 ]; then
  echo "report-for-duty: run this as YOURSELF, not as root."                >&2
  echo "  This week needs no house keys at all, and running it under sudo"  >&2
  echo "  stages root's home directory instead of yours -- nothing this"    >&2
  echo "  week will find it there. Nothing has been staged. Run it again"   >&2
  echo "  as yourself:"                                                     >&2
  echo "    bash report-for-duty.sh"                                        >&2
  exit 1
fi

# ------------------------------------------------------------------ --reset --
if [ "${1:-}" = "--reset" ]; then
  rm -f "$LOG" "$MANUAL" "$FRAME" "$GDBFILE" "$ORDER"
  # Each room goes only if this week leaves it empty. interlocking/ is
  # Week 6's room as much as ours, and ring-line/ may hold something of
  # yours (a core file from gcore, say) -- rmdir refuses a room that is not
  # empty, which is exactly the guard wanted.
  rmdir "$RING" 2>/dev/null || true
  rmdir "$MANUALS" 2>/dev/null || true
  rmdir "$INTERLOCKING" 2>/dev/null || true
  # enginehouse/ is shared with other weeks (Week 1 lays the rooms down), so
  # it goes only if this week leaves it empty and only if Week 1's own marker
  # is gone too -- the same guard Weeks 4, 5 and 6 use.
  if [ ! -e "$ENGINEHOUSE/inbox" ]; then
    rmdir "$ENGINEHOUSE" 2>/dev/null || true
  fi
  echo "Bench struck. The log, the manual page and the Ring Line model are withdrawn."
  if [ -d "$INTERLOCKING" ]; then
    echo "interlocking/ still holds another week's papers, and they were not touched."
  fi
  if [ -d "$RING" ]; then
    echo "ring-line/ still holds files this script did not make; they are yours, and left."
  fi
  echo "(Run this script again, without --reset, to stage the week afresh.)"
  exit 0
elif [ "$#" -gt 0 ]; then
  echo "usage: bash report-for-duty.sh [--reset]" >&2
  exit 2
fi

# The Guild's sealed drawing of the Ring Line. Decoded at stage time,
# compiled, and swept up: only the built model is left on the bench.
decode_frame() { # writes the frame's C source to $1
  base64 -d > "$1" <<'B64'
LyogcmluZy1mcmFtZS5jIC0tIHRoZSBHdWlsZCdzIG1vZGVsIG9mIHRoZSBSaW5nIExpbmU6IGZv
dXIgc2lnbmFsIGJveGVzLgogKgogKiBFYWNoIGJveCBob2xkcyBpdHMgb3duIHJpbmcganVuY3Rp
b24gbGV2ZXIgYW5kIG5lZWRzIHRoZSBuZXh0IGJveCdzCiAqIGxldmVyIHRvIHBhc3MgaXRzIHRy
YWluIG9uLiBUaGUgYm94ZXMgdGFrZSB0aGVpciBob2xkcyBvbmUgYWZ0ZXIKICogYW5vdGhlciwg
aW4gdGhlIG9yZGVyIHRoZSBhY3F1aXNpdGlvbiBsb2cgYm9va3MgdGhlbSwgYW5kIHRoZW4gZWFj
aAogKiByZWFjaGVzIGZvciBpdHMgbmVpZ2hib3VyJ3MgbGV2ZXIuIFRoZSBtb2RlbCBzYXlzIHdo
YXQgZWFjaCBib3ggaG9sZHMKICogYW5kIG5ldmVyIHdoYXQgaXQgd2FpdHMgZm9yOiB0aGF0IGlz
IHRoZSBkZWJ1Z2dlcidzIHRvIGZpbmQuCiAqCiAqIEl0IHN0YW5kcyB1bnRpbCBhIHJlbGVhc2Ug
b3JkZXIgaXMgaHVuZyBvbiB0aGUgaG9vayBhdAogKiB+L2VuZ2luZWhvdXNlL3JpbmctbGluZS9y
ZWxlYXNlLW9yZGVyIG5hbWluZyBvbmUgYm94LiBUaGF0IGJveAogKiByZXR1cm5zIGl0cyBvd24g
bGV2ZXIsIHdhaXRzIGl0cyB0dXJuLCBhbmQgdGhlIHJpbmcgY2xlYXJzLgogKgogKiBCdWlsdCBv
biB0aGUgYmVuY2ggYnkgcmVwb3J0LWZvci1kdXR5LnNoIHdpdGggLWcsIGFuZCBub3Qga2VwdCB0
aGVyZS4KICovCiNkZWZpbmUgX0dOVV9TT1VSQ0UKI2luY2x1ZGUgPHB0aHJlYWQuaD4KI2luY2x1
ZGUgPHN0ZGF0b21pYy5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgoj
aW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDx0aW1lLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4K
CiNkZWZpbmUgQk9YRVMgICAgICAgICAgICAgNAojZGVmaW5lIENMQUlNX0dBUF9NUyAgICA1MDAg
ICAvKiBiZXR3ZWVuIG9uZSBib3gncyBob2xkIGFuZCB0aGUgbmV4dCAgKi8KI2RlZmluZSBDVUVf
TElNSVRfTVMgICA1MDAwICAgLyogbm9ib2R5IHJlYWNoZXMgYmVmb3JlIGFsbCBmb3VyIGhvbGQg
ICAqLwojZGVmaW5lIFNUQU5EX05PVEVfTVMgICAzMDAgICAvKiB0aGVuIGEgbW9tZW50IGJlZm9y
ZSBzYXlpbmcgc28gICAgICAgICovCiNkZWZpbmUgTE9PS19VUF9TICAgICAgICAgMSAgIC8qIGEg
d2FpdGluZyBib3ggbG9va3MgYXQgdGhlIGhvb2sgICAgICAgKi8KI2RlZmluZSBUVVJOX0xJTUlU
X01TICA1MDAwICAgLyogYSByZWxlYXNlZCBib3ggd2FpdHMgaXRzIHR1cm4gICAgICAgICAqLwoK
c3RhdGljIHB0aHJlYWRfbXV0ZXhfdCBsZXZlcl9ub3J0aGdhdGUgID0gUFRIUkVBRF9NVVRFWF9J
TklUSUFMSVpFUjsKc3RhdGljIHB0aHJlYWRfbXV0ZXhfdCBsZXZlcl93YXRlcnNpZGUgID0gUFRI
UkVBRF9NVVRFWF9JTklUSUFMSVpFUjsKc3RhdGljIHB0aHJlYWRfbXV0ZXhfdCBsZXZlcl9vbGRx
dWFydGVyID0gUFRIUkVBRF9NVVRFWF9JTklUSUFMSVpFUjsKc3RhdGljIHB0aHJlYWRfbXV0ZXhf
dCBsZXZlcl9raWxucm93ICAgID0gUFRIUkVBRF9NVVRFWF9JTklUSUFMSVpFUjsKCnN0cnVjdCBk
aXN0cmljdCB7CiAgICBjb25zdCBjaGFyICAgICAgKm5hbWU7CiAgICBwdGhyZWFkX211dGV4X3Qg
Km93bjsKICAgIHB0aHJlYWRfbXV0ZXhfdCAqbmV4dDsKfTsKCnN0YXRpYyBzdHJ1Y3QgZGlzdHJp
Y3QgcmluZ1tCT1hFU10gPSB7CiAgICB7ICJOb3J0aGdhdGUiLCAgICZsZXZlcl9ub3J0aGdhdGUs
ICAmbGV2ZXJfd2F0ZXJzaWRlICB9LAogICAgeyAiV2F0ZXJzaWRlIiwgICAmbGV2ZXJfd2F0ZXJz
aWRlLCAgJmxldmVyX29sZHF1YXJ0ZXIgfSwKICAgIHsgIk9sZCBRdWFydGVyIiwgJmxldmVyX29s
ZHF1YXJ0ZXIsICZsZXZlcl9raWxucm93ICAgIH0sCiAgICB7ICJLaWxuIFJvdyIsICAgICZsZXZl
cl9raWxucm93LCAgICAmbGV2ZXJfbm9ydGhnYXRlICB9LAp9OwoKc3RhdGljIGF0b21pY19pbnQg
aG9sZHNfdGFrZW47CnN0YXRpYyBhdG9taWNfaW50IGJveGVzX3JlYWNoaW5nOwpzdGF0aWMgYXRv
bWljX2ludCBib3hlc19tb3ZlZDsKc3RhdGljIHB0aHJlYWRfbXV0ZXhfdCBvcmRlcl9ob29rID0g
UFRIUkVBRF9NVVRFWF9JTklUSUFMSVpFUjsKc3RhdGljIGNoYXIgb3JkZXJfcGF0aFs0MDk2XTsK
CnN0YXRpYyB2b2lkIHBhdXNlX21zKGxvbmcgbXMpCnsKICAgIHN0cnVjdCB0aW1lc3BlYyB0ID0g
eyBtcyAvIDEwMDAsIChtcyAlIDEwMDApICogMTAwMDAwMEwgfTsKICAgIG5hbm9zbGVlcCgmdCwg
TlVMTCk7Cn0KCi8qIEZpcnN0IGxpbmUgb25seSwgbG93ZXIgY2FzZSwgc3BhY2VzIGFuZCBoeXBo
ZW5zIGdvbmU6IEtpbG4tUm93IGlzIGtpbG5yb3cuICovCnN0YXRpYyB2b2lkIHBsYWluX25hbWUo
Y29uc3QgY2hhciAqZnJvbSwgY2hhciAqdG8sIHNpemVfdCByb29tKQp7CiAgICBzaXplX3QgbiA9
IDA7CgogICAgZm9yICg7ICpmcm9tICE9ICdcMCcgJiYgKmZyb20gIT0gJ1xuJyAmJiAqZnJvbSAh
PSAnXHInICYmIG4gKyAxIDwgcm9vbTsgZnJvbSsrKSB7CiAgICAgICAgY2hhciBjID0gKmZyb207
CiAgICAgICAgaWYgKGMgPT0gJyAnIHx8IGMgPT0gJy0nIHx8IGMgPT0gJ1x0JyB8fAogICAgICAg
ICAgICBjID09ICdceGEwJyB8fCAoYyA9PSAnXHhjMicgJiYgZnJvbVsxXSA9PSAnXHhhMCcpKSAg
IC8qIGEgaGFyZCBzcGFjZSAqLwogICAgICAgICAgICBjb250aW51ZTsKICAgICAgICBpZiAoYyA+
PSAnQScgJiYgYyA8PSAnWicpCiAgICAgICAgICAgIGMgPSAoY2hhcikoYyAtICdBJyArICdhJyk7
CiAgICAgICAgdG9bbisrXSA9IGM7CiAgICB9CiAgICB0b1tuXSA9ICdcMCc7Cn0KCi8qIFRoZSBv
cmRlciBpcyB0aGUgZmlyc3QgbGluZSBvbiB0aGUgaG9vayB0aGF0IGlzIG5vdCBibGFuay4gQmxh
bmtzIGFsb25lCiAqIGFyZSBhbiBvcmRlciBzdGlsbCBiZWluZyB3cml0dGVuLCBhbmQgYXJlIGxl
dCBiZS4gQW4gb3JkZXIgbmFtaW5nIHRoaXMKICogYm94IGlzIHRha2VuIGRvd24gYW5kIDEgY29t
ZXMgYmFjazsgb25lIG5hbWluZyBubyBib3ggb24gdGhlIHJpbmcgaXMgdGFrZW4KICogZG93biwg
d2l0aCBhIGxpbmUgcXVvdGluZyBpdDsgb25lIG5hbWluZyBhbm90aGVyIGJveCBpcyBsZWZ0IGZv
ciB0aGF0IGJveC4gKi8Kc3RhdGljIGludCBvcmRlcl9uYW1lcyhjb25zdCBjaGFyICpkaXN0cmlj
dCkKewogICAgY2hhciB0ZXh0WzI1Nl0gPSAiIiwgZ290WzY0XSwgd2FudFszMl0sIHNlZW5bNDFd
LCAqbGluZSA9IHRleHQ7CiAgICBpbnQgbWluZSA9IDAsIGFueWJvZHkgPSAwLCBpOwogICAgc2l6
ZV90IG4sIGsgPSAwOwogICAgRklMRSAqZjsKCiAgICBwdGhyZWFkX211dGV4X2xvY2soJm9yZGVy
X2hvb2spOwogICAgZiA9IGZvcGVuKG9yZGVyX3BhdGgsICJyIik7CiAgICBpZiAoZiAhPSBOVUxM
KSB7CiAgICAgICAgbiA9IGZyZWFkKHRleHQsIDEsIHNpemVvZiB0ZXh0IC0gMSwgZik7ICAgLyog
dGV4dCBzdGF5cyBOVUwtZW5kZWQgKi8KICAgICAgICBmY2xvc2UoZik7CiAgICAgICAgbGluZSAr
PSBzdHJuY21wKGxpbmUsICJceGVmXHhiYlx4YmYiLCAzKSA9PSAwID8gMyA6IDA7ICAgLyogYnl0
ZS1vcmRlciBtYXJrICovCiAgICAgICAgbGluZSArPSBzdHJzcG4obGluZSwgIiBcdFxyXG4iKTsK
ICAgICAgICBwbGFpbl9uYW1lKGxpbmUsIGdvdCwgc2l6ZW9mIGdvdCk7CiAgICAgICAgZm9yIChp
ID0gMDsgaSA8IEJPWEVTOyBpKyspIHsKICAgICAgICAgICAgcGxhaW5fbmFtZShyaW5nW2ldLm5h
bWUsIHdhbnQsIHNpemVvZiB3YW50KTsKICAgICAgICAgICAgYW55Ym9keSB8PSBzdHJjbXAoZ290
LCB3YW50KSA9PSAwOwogICAgICAgIH0KICAgICAgICBwbGFpbl9uYW1lKGRpc3RyaWN0LCB3YW50
LCBzaXplb2Ygd2FudCk7CiAgICAgICAgaWYgKHN0cmNtcChnb3QsIHdhbnQpID09IDApIHsKICAg
ICAgICAgICAgdW5saW5rKG9yZGVyX3BhdGgpOwogICAgICAgICAgICBtaW5lID0gMTsKICAgICAg
ICB9IGVsc2UgaWYgKCFhbnlib2R5ICYmICpsaW5lICE9ICdcMCcpIHsKICAgICAgICAgICAgdW5s
aW5rKG9yZGVyX3BhdGgpOwogICAgICAgICAgICBmb3IgKG4gPSAwOyBsaW5lW25dICE9ICdcMCcg
JiYgbGluZVtuXSAhPSAnXG4nICYmIGxpbmVbbl0gIT0gJ1xyJyAmJiBrIDwgNDA7IG4rKykKICAg
ICAgICAgICAgICAgIHNlZW5baysrXSA9IChsaW5lW25dID49ICcgJyAmJiBsaW5lW25dIDw9ICd+
JykgPyBsaW5lW25dIDogJz8nOwogICAgICAgICAgICBzZWVuW2tdID0gJ1wwJzsKICAgICAgICAg
ICAgcHJpbnRmKCIgIFJlbGVhc2Ugb3JkZXIgaWdub3JlZCBhbmQgdGFrZW4gZG93bjogbm8gYm94
IGlzIGNhbGxlZCBcIiVzXCIuXG4iLCBzZWVuKTsKICAgICAgICAgICAgZmZsdXNoKHN0ZG91dCk7
CiAgICAgICAgfQogICAgfQogICAgcHRocmVhZF9tdXRleF91bmxvY2soJm9yZGVyX2hvb2spOwog
ICAgcmV0dXJuIG1pbmU7Cn0KCi8qIFRha2UgYSBsZXZlciwgaG93ZXZlciBsb25nIGl0IHRha2Vz
LiBBIGJveCBrZXB0IHdhaXRpbmcgbG9va3MgYXQgdGhlIGhvb2sKICogb25jZSBhIHNlY29uZC4g
MTogdGhlIGxldmVyIGlzIGluIGhhbmQuIDA6IGFuIG9yZGVyIG5hbWVkIHRoaXMgYm94LiAqLwpz
dGF0aWMgaW50IHRha2VfbGV2ZXIoY29uc3QgY2hhciAqZGlzdHJpY3QsIHB0aHJlYWRfbXV0ZXhf
dCAqbGV2ZXIpCnsKICAgIGZvciAoOzspIHsKICAgICAgICBzdHJ1Y3QgdGltZXNwZWMgdW50aWw7
CgogICAgICAgIGNsb2NrX2dldHRpbWUoQ0xPQ0tfUkVBTFRJTUUsICZ1bnRpbCk7CiAgICAgICAg
dW50aWwudHZfc2VjICs9IExPT0tfVVBfUzsKICAgICAgICBpZiAocHRocmVhZF9tdXRleF90aW1l
ZGxvY2sobGV2ZXIsICZ1bnRpbCkgPT0gMCkKICAgICAgICAgICAgcmV0dXJuIDE7CiAgICAgICAg
aWYgKG9yZGVyX25hbWVzKGRpc3RyaWN0KSkKICAgICAgICAgICAgcmV0dXJuIDA7CiAgICB9Cn0K
Ci8qIEFsbCBmb3VyIGhvbGRzIGluIHBsYWNlIGJlZm9yZSBhbnlvbmUgcmVhY2hlcyAtLSBvciBn
aXZlIHVwIHdhaXRpbmcuICovCnN0YXRpYyB2b2lkIHdhaXRfZm9yX3RoZV9jdWUodm9pZCkKewog
ICAgbG9uZyB3YWl0ZWQgPSAwOwoKICAgIHdoaWxlIChhdG9taWNfbG9hZCgmaG9sZHNfdGFrZW4p
IDwgQk9YRVMgJiYgd2FpdGVkIDwgQ1VFX0xJTUlUX01TKSB7CiAgICAgICAgcGF1c2VfbXMoMSk7
CiAgICAgICAgd2FpdGVkKys7CiAgICB9Cn0KCi8qIEEgcmVsZWFzZWQgYm94IHN0YW5kcyBiYWNr
IHVudGlsIHRoZSBvdGhlciB0aHJlZSBoYXZlIG1vdmVkLiAqLwpzdGF0aWMgdm9pZCB3YWl0X2l0
c190dXJuKHZvaWQpCnsKICAgIGxvbmcgd2FpdGVkID0gMDsKCiAgICB3aGlsZSAoYXRvbWljX2xv
YWQoJmJveGVzX21vdmVkKSA8IEJPWEVTIC0gMSAmJiB3YWl0ZWQgPCBUVVJOX0xJTUlUX01TKSB7
CiAgICAgICAgcGF1c2VfbXMoMTApOwogICAgICAgIHdhaXRlZCArPSAxMDsKICAgIH0KfQoKc3Rh
dGljIHZvaWQgKnNpZ25hbF9ib3godm9pZCAqYXJnKQp7CiAgICBzdHJ1Y3QgZGlzdHJpY3QgKmQg
PSBhcmc7CiAgICBwdGhyZWFkX211dGV4X3QgKmhvbGRpbmcgPSBkLT5vd247CgogICAgcHRocmVh
ZF9zZXRuYW1lX25wKHB0aHJlYWRfc2VsZigpLCBkLT5uYW1lKTsKICAgIHB0aHJlYWRfbXV0ZXhf
bG9jayhob2xkaW5nKTsKICAgIHByaW50ZigiICAlLTEycyBob2xkcyBpdHMgcmluZyBqdW5jdGlv
biBsZXZlci5cbiIsIGQtPm5hbWUpOwogICAgZmZsdXNoKHN0ZG91dCk7CiAgICBhdG9taWNfZmV0
Y2hfYWRkKCZob2xkc190YWtlbiwgMSk7CgogICAgd2FpdF9mb3JfdGhlX2N1ZSgpOwogICAgYXRv
bWljX2ZldGNoX2FkZCgmYm94ZXNfcmVhY2hpbmcsIDEpOwogICAgd2hpbGUgKCF0YWtlX2xldmVy
KGQtPm5hbWUsIGQtPm5leHQpKSB7CiAgICAgICAgcHJpbnRmKCIgICUtMTJzIHJlbGVhc2Ugb3Jk
ZXIgaG9ub3VyZWQuIExldmVyIGJhY2sgdG8gbm9ybWFsOyB3YWl0aW5nIGl0cyB0dXJuLlxuIiwK
ICAgICAgICAgICAgICAgZC0+bmFtZSk7CiAgICAgICAgZmZsdXNoKHN0ZG91dCk7CiAgICAgICAg
cHRocmVhZF9tdXRleF91bmxvY2soaG9sZGluZyk7CiAgICAgICAgd2FpdF9pdHNfdHVybigpOwog
ICAgICAgIHB0aHJlYWRfbXV0ZXhfbG9jayhob2xkaW5nKTsKICAgIH0KCiAgICBwcmludGYoIiAg
JS0xMnMgYm90aCBsZXZlcnMgaW4gaGFuZC4gVHJhaW4gcGFzc2VkLlxuIiwgZC0+bmFtZSk7CiAg
ICBmZmx1c2goc3Rkb3V0KTsKICAgIGF0b21pY19mZXRjaF9hZGQoJmJveGVzX21vdmVkLCAxKTsK
ICAgIHB0aHJlYWRfbXV0ZXhfdW5sb2NrKGQtPm5leHQpOwogICAgcHRocmVhZF9tdXRleF91bmxv
Y2soaG9sZGluZyk7CiAgICByZXR1cm4gTlVMTDsKfQoKaW50IG1haW4odm9pZCkKewogICAgcHRo
cmVhZF90IGJveFtCT1hFU107CiAgICBjb25zdCBjaGFyICpob21lID0gZ2V0ZW52KCJIT01FIik7
CiAgICBpbnQgaTsKCiAgICBzbnByaW50ZihvcmRlcl9wYXRoLCBzaXplb2Ygb3JkZXJfcGF0aCwg
IiVzL2VuZ2luZWhvdXNlL3JpbmctbGluZS9yZWxlYXNlLW9yZGVyIiwKICAgICAgICAgICAgIGhv
bWUgIT0gTlVMTCA/IGhvbWUgOiAiLiIpOwogICAgaWYgKHVubGluayhvcmRlcl9wYXRoKSA9PSAw
KSB7CiAgICAgICAgcHJpbnRmKCIgIEEgcmVsZWFzZSBvcmRlciB3YXMgb24gdGhlIGhvb2sgYmVm
b3JlIHRoZSBtb2RlbCBzdGFydGVkLiBUYWtlbiBkb3duLFxuIgogICAgICAgICAgICAgICAiICB1
bmhlZWRlZDogaGFuZyBpdCBhZ2FpbiBvbmNlIHRoZSBmcmFtZSBzdGFuZHMuXG4iKTsKICAgIH0K
CiAgICBmb3IgKGkgPSAwOyBpIDwgQk9YRVM7IGkrKykgewogICAgICAgIGlmIChpID4gMCkKICAg
ICAgICAgICAgcGF1c2VfbXMoQ0xBSU1fR0FQX01TKTsKICAgICAgICBpZiAocHRocmVhZF9jcmVh
dGUoJmJveFtpXSwgTlVMTCwgc2lnbmFsX2JveCwgJnJpbmdbaV0pICE9IDApIHsKICAgICAgICAg
ICAgZnByaW50ZihzdGRlcnIsICJyaW5nLWZyYW1lOiBjb3VsZCBub3Qgb3BlbiBhIHNpZ25hbCBi
b3hcbiIpOwogICAgICAgICAgICByZXR1cm4gMTsKICAgICAgICB9CiAgICAgICAgd2hpbGUgKGF0
b21pY19sb2FkKCZob2xkc190YWtlbikgPD0gaSkKICAgICAgICAgICAgcGF1c2VfbXMoMSk7CiAg
ICB9CiAgICB3aGlsZSAoYXRvbWljX2xvYWQoJmJveGVzX3JlYWNoaW5nKSA8IEJPWEVTKQogICAg
ICAgIHBhdXNlX21zKDEpOwogICAgcGF1c2VfbXMoU1RBTkRfTk9URV9NUyk7CiAgICBwcmludGYo
IlRoZSBmcmFtZSBzdGFuZHMuIChDdHJsLUMgc3RvcHMgdGhlIG1vZGVsLilcbiIpOwogICAgZmZs
dXNoKHN0ZG91dCk7CgogICAgZm9yIChpID0gMDsgaSA8IEJPWEVTOyBpKyspCiAgICAgICAgcHRo
cmVhZF9qb2luKGJveFtpXSwgTlVMTCk7CiAgICBwcmludGYoIlJpbmcgY2xlYXIuIEFsbCBmb3Vy
IGJveGVzIGhhdmUgbW92ZWQuXG4iKTsKICAgIHJldHVybiAwOwp9Cg==
B64
}

# ------------------------------------------------------------ build the model
# Built before anything is staged, so a bench that cannot build it is left
# exactly as it was found.
if ! command -v gcc >/dev/null 2>&1; then
  echo "report-for-duty: gcc not found -- this week's model is compiled at your own bench." >&2
  echo "Run the 'a tool is missing' fix in setup/getting-started.md Troubleshooting, then try again." >&2
  exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
decode_frame "$tmp/ring-frame.c"
# -g for the debugger, -O0 so it shows what the program really does. The
# prefix map records ring-line/ as the drawing's home, so gdb names a real
# place on your bench when it says the source is not there.
if ! ( cd "$tmp" && gcc -g -O0 -Wall -Wextra -pthread \
         "-fdebug-prefix-map=$tmp=$RING" -o ring-frame ring-frame.c ); then
  echo "report-for-duty: the Ring Line model did not build on this bench. The" >&2
  echo "  messages above are gcc's. Nothing has been staged. Take this to your"  >&2
  echo "  instructor rather than working around it."                             >&2
  exit 1
fi

# ------------------------------------------------------------------ the bench
mkdir -p "$INTERLOCKING" "$MANUALS" "$RING"
rm -f "$ORDER"                     # a fresh bench has nothing on the hook

# The log and the page are yours to read and stay in your hands, so both are
# rewritten every time -- which is why running this script twice is dull.
cat > "$LOG" <<'LOG'
ACQUISITION LOG -- RING LINE INTERLOCKING
Brassbridge Enginehouse, Work Order No. 1851-07

  frame ............ the Ring Line: four signal boxes, one ring
  lever ............ each box holds its own ring junction lever
  day .............. Saturday, 26 September 1851

  Northgate ........ hold taken 1851-09-26 18:51:07
  Waterside ........ hold taken 1851-09-26 18:51:21
  Old Quarter ...... hold taken 1851-09-26 18:51:35
  Kiln Row ......... hold taken 1851-09-26 18:51:49

  The frame books a hold when it grants one. What a box is waiting
  for is not a hold, and is not booked here.
LOG
# The log's own date on the house calendar. Only the log carries one: every
# other file here is dated the moment you staged it.
touch -d '2026-09-26 18:51:49' "$LOG"

cat > "$MANUAL" <<'PAGE'
THE HONOURABLE GUILD OF ENGINEWRIGHTS
Manual of Signal-Box Working -- Brassbridge Enginehouse

  entered: 1851-09-23

RELEASE OF A RING STANDSTILL

  When every box on a ring stands waiting upon its neighbour, each one
  holding the lever the next box wants, the ring is at a standstill. It
  will not clear itself: it will stand, quite correctly, until someone
  with the authority to do so tells one box to give way.

  1. No box shall be forced. A lever wrenched from a box's hand is how
     trains come to meet. The frame fails stopped, and stopped is safe.

  2. The duty enginewright files a release order naming ONE box, and
     one only: the box whose claim is youngest -- that is, the box that
     took its hold last. It has held its lever the shortest while, and
     so it has the smallest share of the ring's work to lose by standing
     back.

  3. The order bears the box's name as the acquisition log books it,
     and nothing more, and it is hung on the frame's order hook:

         ~/enginehouse/ring-line/release-order

  4. The box so named returns its lever to normal and waits its turn.
     The box that was waiting on that lever takes it and passes its
     train; then the box that was waiting on that one; and so round the
     ring. The named box goes last. Nothing is forced, and nothing
     collides.

  5. An order naming no box on the ring is taken down unheeded. File it
     again, correctly.
PAGE

printf '%s\n' 'set debuginfod enabled off' 'set pagination off' > "$GDBFILE"

# rename, not copy: a model left running in another terminal keeps its old
# file, and the new one takes its place without a fuss.
mv -f "$tmp/ring-frame" "$FRAME"

# ------------------------------------------------------------------ self-test
fail=0
if [ ! -x "$FRAME" ]; then
  echo "self-test: $FRAME missing or not executable" >&2; fail=1
elif ! readelf -S "$FRAME" 2>/dev/null | grep -q '\.debug_info'; then
  echo "self-test: $FRAME carries no debug information" >&2; fail=1
fi
for leftover in "$RING"/*.c; do
  [ -e "$leftover" ] || continue
  echo "self-test: $leftover was left on the bench" >&2; fail=1
done
[ -f "$GDBFILE" ] || { echo "self-test: $GDBFILE missing" >&2; fail=1; }
if [ -f "$LOG" ]; then
  holds="$(grep -c 'hold taken 1851-09-26 18:51:' "$LOG" || true)"
  if [ "$holds" != "4" ]; then
    echo "self-test: $LOG books $holds holds, not 4" >&2; fail=1
  fi
  for s in 07 21 35 49; do
    grep -q "hold taken 1851-09-26 18:51:$s\$" "$LOG" \
      || { echo "self-test: $LOG has no hold at :$s" >&2; fail=1; }
  done
else
  echo "self-test: $LOG missing" >&2; fail=1
fi
if [ ! -f "$MANUAL" ]; then
  echo "self-test: $MANUAL missing" >&2; fail=1
elif ! grep -q '^  entered: 1851-09-23$' "$MANUAL"; then
  echo "self-test: $MANUAL carries no entry stamp" >&2; fail=1
fi
if [ "$fail" -ne 0 ]; then
  echo "report-for-duty: staging incomplete -- see messages above." >&2
  exit 1
fi

# ------------------------------------------------------------------ duty slip
cat <<'SLIP'

  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-07 :: bench staged and verified
  ------------------------------------------------------------------
   Log:     ~/enginehouse/interlocking/acquisition.log
   Manual:  ~/enginehouse/manuals/signal-box-release-procedure.txt
   Model:   ~/enginehouse/ring-line/ring-frame   (built just now)
            ~/enginehouse/ring-line/signal-box.gdb

   Four boxes on the Ring Line took their holds one after another,
   and then not one of them would move. Nothing collided. Read the
   log and the manual page before you go near the model.

   The model is built from sealed drawings, on this bench, and the
   drawings were not left behind: the debugger is this week's
   instrument. It stands until you stop it, and Ctrl-C stops it.
   No house keys were wanted this week.
   (bash report-for-duty.sh --reset withdraws all of it.)
  ------------------------------------------------------------------

SLIP

# Every task after the first is done in gdb. It is on every setup path, but
# a bench that lost it should hear so now rather than at the first command.
if ! command -v gdb >/dev/null 2>&1; then
  echo "report-for-duty: note -- gdb is not on this bench, and Tasks 2 and 3 need it." >&2
  echo "Run the 'a tool is missing' fix in setup/getting-started.md Troubleshooting." >&2
fi
