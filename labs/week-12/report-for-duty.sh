#!/usr/bin/env bash
# report-for-duty.sh -- Work Order No. 1851-12: stage the pneumatic post.
#
# Usage:
#   bash report-for-duty.sh            stage this week's bench (safe to re-run)
#   bash report-for-duty.sh --reset    remove everything this script created
#
# The post splices a passive copier -- tube-tee, running as the archive account
# (uid 1849, gid 100) -- into a FIFO line. A capsule the student sends down
# `outbound` passes through the copier to `exchange-line` UNCHANGED, and a copy
# is dropped into `.drop-box/outbound-copy.txt`: the line hisses twice. The
# copier is a living process, launched under the house keys once, exactly as
# Week 10's keeper is; it does NOT survive `wsl --shutdown`.
#
# The copier's C source and the drop box's pre-written capsules both live here
# as sealed base64 payloads (decode_tube_tee, decode_capsules). The C source is
# decoded and compiled at staging and swept up: no source and no binary is left
# in the repo. The payloads carry the archive account only as a number, never
# by name.
#
# What it touches, and nothing else:
#   ~/enginehouse/post/                     yours: the line, fitting by fitting
#     exchange-line                         a FIFO, yours -- the exchange end
#     .listening-tube                       a FIFO, uid 1849 (others may write)
#     outbound                              a symlink -> .listening-tube, uid 1849
#     .drop-box/outbound-copy.txt           a directory and file, uid 1849
#   ~/enginehouse/post-works/tube-tee       the copier, compiled here
#   ~/enginehouse/tube-shop/                yours, empty: your own fittings go here
#   the house roll                          one dormant entry restored, by
#                                           labs/lib/archive-roll.sh
#
# Never touches Week 10's survey/ or its keeper, Week 11's cabinets/, mnt/,
# recovered/ or ledger-halls/, Week 9's src/, Week 2's ~/.ledger-annex, or any
# other room. The roll entry is the course's, not this week's: no week's
# --reset removes it (bash ../lib/archive-roll.sh teardown, at end of term).
#
# Re-running stages the post afresh: the copier is stood down, the line is
# rebuilt, the copier is relaunched on the new fittings and the drop box is
# refilled. Anything you sent down the line before is swept away with it.
#
# Sudo: this week asks for the house keys ONCE. Every job that needs root is
# named below before any of it happens, and all of it is done inside the one
# window. If this bench cannot get root, the script says so and stands down
# having staged nothing.
#
# Works offline. Needs gcc (Week 1's smoke test proved yours).
set -eu

ENGINEHOUSE="$HOME/enginehouse"
POST="$ENGINEHOUSE/post"
POSTWORKS="$ENGINEHOUSE/post-works"
TUBESHOP="$ENGINEHOUSE/tube-shop"
LISTENING="$POST/.listening-tube"       # FIFO, 1849:100 -- the tap's mouth
OUTBOUND="$POST/outbound"               # symlink -> .listening-tube, 1849:100
EXCHANGE="$POST/exchange-line"          # FIFO, yours -- the far end
DROPBOX="$POST/.drop-box"               # dir, 1849:100
DROPFILE="$DROPBOX/outbound-copy.txt"   # -, 1849:100 -- what the tap has drunk
BIN="$POSTWORKS/tube-tee"               # the compiled copier, outside post/
HOLDER_UID=1849
HOLDER_GID=100
UNIT="tube-tee-$(id -u)"                # per-home: benches are single-user, but
                                        # a harness may hold two of these

# --------------------------------------------------------------- the payloads --
# The copier's drawing, kept only here. Decoded at stage time, compiled with the
# student's own gcc, executed as root (which drops itself to uid 1849), and
# swept up: only the built copier is left on the bench. The source names the
# archive account as a number, never by name, so the publish gate (which scans
# both this source and the decoded payloads for instructor filenames and story
# names) passes it.
#
# tube-tee <listening-tube> <exchange-line> <drop-file>
#   opens all three while root (the home is 750, F-8), holds both FIFOs O_RDWR
#   (F-9), drops to uid 1849 / gid 100 (F-11), chdir /, forks ONLY when started
#   as root, then forwards every chunk unchanged to the exchange line and
#   appends it to the drop file. Ignores SIGPIPE; never exits on EOF; stands
#   until stopped. Run by hand as an ordinary user it stays in the foreground
#   and drops nothing, so the copy logic is testable under `timeout`.
decode_tube_tee() { # writes tube-tee's C source to $1
  base64 -d > "$1" <<'B64'
LyogdHViZS10ZWUuYyAtLSBhIHBhc3NpdmUgY29waWVyIHNwbGljZWQgaW50byB0aGUgcG5ldW1h
dGljIHBvc3QncyBsaW5lLgogKgogKiBVc2FnZTogIHR1YmUtdGVlIDxsaXN0ZW5pbmctdHViZT4g
PGV4Y2hhbmdlLWxpbmU+IDxkcm9wLWZpbGU+CiAqCiAqIEEgRklGTyBjYW5ub3QgYmUgb3Zlcmhl
YXJkOiB0d28gcmVhZGVycyBzcGxpdCBpdHMgdHJhZmZpYywgdGhleSBkbyBub3QKICogYm90aCBo
ZWFyIGl0IChXZWVrIDEyLCBmaW5kaW5nIEYtNCkuIFNvIHRvIGNvcHkgYSBsaW5lIHlvdSBtdXN0
IHN0YW5kIElOCiAqIGl0LiB0dWJlLXRlZSByZWFkcyBmcm9tIHRoZSBsaXN0ZW5pbmcgdHViZSBh
bmQsIGZvciBldmVyeSBjaHVuaywgd3JpdGVzIGl0CiAqIFVOQ0hBTkdFRCBhbmQgYXQgb25jZSB0
byB0aGUgZXhjaGFuZ2UgbGluZSwgdGhlbiBhcHBlbmRzIHRoYXQgc2FtZSBjaHVuayB0bwogKiB0
aGUgZHJvcCBmaWxlLiBFdmVyeSBieXRlIHJlYWNoZXMgdGhlIGV4Y2hhbmdlIHVuYWx0ZXJlZCBh
bmQgdW5kZWxheWVkOyB0aGUKICogY29weSBpcyB0YWtlbiBhZnRlciB0aGUgZm9yd2FyZCwgc28g
aXQgbmV2ZXIgZGVsYXlzIHRoZSBsaW5lLgogKgogKiBJdCBvcGVucyBhbGwgdGhyZWUgcGF0aHMg
d2hpbGUgc3RpbGwgcm9vdCwgYmVjYXVzZSB0aGUgc3R1ZGVudCdzIGhvbWUgaXMKICogbW9kZSA3
NTAgYW5kIGEgcHJvY2VzcyBydW5uaW5nIGFzIHRoZSBhcmNoaXZlIGFjY291bnQgY291bGQgbm90
IHRyYXZlcnNlIGl0CiAqIChGLTgpLiBPcGVuIGRlc2NyaXB0b3JzIHN1cnZpdmUgdGhlIHByaXZp
bGVnZSBkcm9wLiBJdCB0aGVuIGRyb3BzIHRvIHRoZQogKiBhcmNoaXZlIGFjY291bnQgKHVpZCAx
ODQ5LCBnaWQgMTAwKSwgZXhhY3RseSBhcyBXZWVrIDEwJ3Mga2VlcGVyIGRvZXMuCiAqCiAqIEJv
dGggRklGT3MgYXJlIGhlbGQgT19SRFdSIHNvIHRoZSB0ZWUgaXMgaXRzZWxmIGEgcmVhZGVyIGFu
ZCBhIHdyaXRlciBvbgogKiBlYWNoOiBvcGVuaW5nIG5ldmVyIGJsb2NrcyB3YWl0aW5nIGZvciB0
aGUgZmFyIGVuZCwgYW5kIHRoZSB0ZWUgbmV2ZXIgc2VlcwogKiBFT0Ygd2hlbiBhIHNlbmRlciBj
b21lcyBhbmQgZ29lcyAoRi05KS4gVGhlIGZsaXAgc2lkZSAtLSB0aGF0IHRoZSBleGNoYW5nZQog
KiBlbmQgbmV2ZXIgc2VlcyBFT0YgZWl0aGVyIC0tIGlzIHRoZSB3ZWVrJ3MgbGVzc29uLCBub3Qg
dGhpcyBwcm9ncmFtJ3MgYnVnLgogKgogKiBUaGUgZm9yd2FyZCBpcyBhIHBsYWluIGJsb2NraW5n
IHdyaXRlLiBCZWNhdXNlIHRoZSB0ZWUgaG9sZHMgdGhlIGV4Y2hhbmdlCiAqIGxpbmUgT19SRFdS
IHRoZXJlIGlzIGFsd2F5cyBhIHJlYWRlciwgc28gYSBmdWxsIDY0IEtpQiBidWZmZXIgbWFrZXMg
dGhlCiAqIHdyaXRlIGJsb2NrIChhbmQgdGhlbiB0aGUgc2VuZGVyIGJsb2NrcyksIG5ldmVyIGZh
aWw7IG5vIGJ5dGUgaXMgZHJvcHBlZC4KICogVGhlIHdvcmsgb3JkZXIga2VlcHMgc2VuZHMgc21h
bGwsIHNvIG5vIHN0dWRlbnQgbWVldHMgdGhhdCBzdGFsbC4KICoKICogSXQgZm9ya3Mgb25jZSBP
TkxZIHdoZW4gc3RhcnRlZCBhcyByb290LCBzbyBzeXN0ZW1kIChUeXBlPWZvcmtpbmcpIGFkb3B0
cwogKiB0aGUgc3RhbmRpbmcgY29weSBhbmQgdGhlIGxhdW5jaGluZyBzaGVsbCByZXR1cm5zLiBS
dW4gYnkgaGFuZCBhcyBhbgogKiBvcmRpbmFyeSB1c2VyIGl0IG5laXRoZXIgZHJvcHMgcHJpdmls
ZWdlcyBub3IgZm9ya3M6IGl0IHN0YXlzIGluIHRoZQogKiBmb3JlZ3JvdW5kLCBzbyB0aGUgY29w
eSBsb2dpYyBjYW4gYmUgcHJvdmVuIHVuZGVyIGB0aW1lb3V0YCB3aXRoIG5vIHByb2Nlc3MKICog
bGVmdCBiZWhpbmQuCiAqCiAqIEl0IGlnbm9yZXMgU0lHUElQRSAoYSBkZXBhcnRlZCBleGNoYW5n
ZSByZWFkZXIgbXVzdCBub3Qga2lsbCBpdCksIG5ldmVyCiAqIGV4aXRzIG9uIEVPRiwgYW5kIHN0
YW5kcyB1bnRpbCBpdCBpcyBzdG9wcGVkIChTSUdURVJNLCB0aGUgZGVmYXVsdCkuCiAqCiAqIEdl
bmVyYXRlZCBmcm9tIGEgYmFzZTY0IHBheWxvYWQgYXQgc3RhZ2luZzsgdGhlIHNvdXJjZSBpcyBu
b3QgbGVmdCBiZWhpbmQuCiAqIEl0IGNhcnJpZXMgdGhlIGFyY2hpdmUgYWNjb3VudCBvbmx5IGFz
IGEgbnVtYmVyLCBuZXZlciBieSBuYW1lLgogKi8KI2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVk
ZSA8ZXJybm8uaD4KI2luY2x1ZGUgPGZjbnRsLmg+CiNpbmNsdWRlIDxncnAuaD4KI2luY2x1ZGUg
PHNpZ25hbC5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CiNpbmNsdWRlIDxzeXMvdHlwZXMuaD4KCi8q
IFRoZSBhcmNoaXZlIGFjY291bnQsIGFzIHRoZSBob3VzZSByb2xsIGNhcnJpZXMgaXQ6IHVpZCAx
ODQ5LCBwcmltYXJ5IGdyb3VwCiAqIDEwMCAoInVzZXJzIiwgdGhlIGRlZmF1bHQgZ3JvdXAgdXNl
cmFkZCAtTiBsZWF2ZXMgaXQgaW4pLiBOZXZlciB0aGUgbmFtZS4gKi8KI2RlZmluZSBBUkNISVZF
X1VJRCAxODQ5CiNkZWZpbmUgQVJDSElWRV9HSUQgMTAwCgovKiBUaGUgZm9yd2FyZGluZyBidWZm
ZXI6IG9uZSBkZWZhdWx0IHBpcGUgYnVmZmVyJ3Mgd29ydGggKEYtNikuICovCiNkZWZpbmUgQ0hV
TksgNjU1MzYKCi8qIFdyaXRlIGFsbCBuIGJ5dGVzLCByZXRyeWluZyBzaG9ydCB3cml0ZXMgYW5k
IEVJTlRSLiAwIG9uIHN1Y2Nlc3MsIC0xIG9uIGEKICogcmVhbCBlcnJvci4gKi8Kc3RhdGljIGlu
dCB3cml0ZV9hbGwoaW50IGZkLCBjb25zdCBjaGFyICpidWYsIHNzaXplX3QgbikKewogICAgc3Np
emVfdCBvZmYgPSAwOwogICAgd2hpbGUgKG9mZiA8IG4pIHsKICAgICAgICBzc2l6ZV90IHcgPSB3
cml0ZShmZCwgYnVmICsgb2ZmLCAoc2l6ZV90KShuIC0gb2ZmKSk7CiAgICAgICAgaWYgKHcgPCAw
KSB7CiAgICAgICAgICAgIGlmIChlcnJubyA9PSBFSU5UUikKICAgICAgICAgICAgICAgIGNvbnRp
bnVlOwogICAgICAgICAgICByZXR1cm4gLTE7CiAgICAgICAgfQogICAgICAgIG9mZiArPSB3Owog
ICAgfQogICAgcmV0dXJuIDA7Cn0KCmludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikKewog
ICAgaWYgKGFyZ2MgIT0gNCkKICAgICAgICByZXR1cm4gMjsKCiAgICBpbnQgd2FzX3Jvb3QgPSAo
Z2V0ZXVpZCgpID09IDApOwoKICAgIC8qIE9wZW4gYWxsIHRocmVlIHdoaWxlIHN0aWxsIHJvb3Qg
KEYtOCk7IHRoZSBkZXNjcmlwdG9ycyBvdXRsaXZlIHRoZSBkcm9wLgogICAgICogQm90aCBGSUZP
cyBPX1JEV1Igc28gdGhlIG9wZW4gZG9lcyBub3QgYmxvY2sgYW5kIG5vIEVPRiBpcyBldmVyIHNl
ZW4KICAgICAqIChGLTkpLiBUaGUgZHJvcCBmaWxlIGlzIGFwcGVuZC1vbmx5OiBhIGxhdGVyIGlu
LXBsYWNlIGB0cnVuY2F0ZSAtcyAwYAogICAgICoga2VlcHMgdGhlIGlub2RlLCBhbmQgdGhpcyBo
ZWxkIGRlc2NyaXB0b3Iga2VlcHMgd3JpdGluZyB0byBpdCAoRi0xMykuICovCiAgICBpbnQgaW4g
PSBvcGVuKGFyZ3ZbMV0sIE9fUkRXUik7CiAgICBpZiAoaW4gPCAwKQogICAgICAgIHJldHVybiAx
OwogICAgaW50IG91dCA9IG9wZW4oYXJndlsyXSwgT19SRFdSKTsKICAgIGlmIChvdXQgPCAwKQog
ICAgICAgIHJldHVybiAxOwogICAgaW50IGRyb3AgPSBvcGVuKGFyZ3ZbM10sIE9fV1JPTkxZIHwg
T19BUFBFTkQpOwogICAgaWYgKGRyb3AgPCAwKQogICAgICAgIHJldHVybiAxOwoKICAgIC8qIEEg
ZGVwYXJ0ZWQgZXhjaGFuZ2UgcmVhZGVyIG11c3Qgbm90IGZlbGwgdGhlIHRlZS4gKi8KICAgIHNp
Z25hbChTSUdQSVBFLCBTSUdfSUdOKTsKCiAgICAvKiBEcm9wIHRvIHRoZSBhcmNoaXZlIGFjY291
bnQsIGJ1dCBvbmx5IHdoZW4gc3RhcnRlZCBhcyByb290LiBHcm91cHMKICAgICAqIGZpcnN0LCB0
aGVuIGdpZCwgdGhlbiB1aWQgbGFzdCAtLSBvbmNlIHRoZSB1aWQgaXMgZHJvcHBlZCB0aGUgb3Ro
ZXJzIGNhbgogICAgICogbm8gbG9uZ2VyIGJlIHNldC4gKi8KICAgIGlmICh3YXNfcm9vdCkgewog
ICAgICAgIGlmIChzZXRncm91cHMoMCwgTlVMTCkgIT0gMCkKICAgICAgICAgICAgcmV0dXJuIDE7
CiAgICAgICAgaWYgKHNldHJlc2dpZChBUkNISVZFX0dJRCwgQVJDSElWRV9HSUQsIEFSQ0hJVkVf
R0lEKSAhPSAwKQogICAgICAgICAgICByZXR1cm4gMTsKICAgICAgICBpZiAoc2V0cmVzdWlkKEFS
Q0hJVkVfVUlELCBBUkNISVZFX1VJRCwgQVJDSElWRV9VSUQpICE9IDApCiAgICAgICAgICAgIHJl
dHVybiAxOwogICAgfQoKICAgIGlmIChjaGRpcigiLyIpICE9IDApCiAgICAgICAgcmV0dXJuIDE7
CgogICAgLyogRm9yayBvbmx5IHdoZW4gc3RhcnRlZCBhcyByb290LCBzbyB0aGUgcGFyZW50IHJl
dHVybnMgdG8gdGhlIGxhdW5jaGluZwogICAgICogc2hlbGwgYW5kIHN5c3RlbWQgYWRvcHRzIHRo
ZSBzdGFuZGluZyBjaGlsZC4gKi8KICAgIGlmICh3YXNfcm9vdCkgewogICAgICAgIHBpZF90IHBp
ZCA9IGZvcmsoKTsKICAgICAgICBpZiAocGlkIDwgMCkKICAgICAgICAgICAgcmV0dXJuIDE7CiAg
ICAgICAgaWYgKHBpZCA+IDApCiAgICAgICAgICAgIHJldHVybiAwOwogICAgICAgIHNldHNpZCgp
OwogICAgfQoKICAgIC8qIFN0YW5kIGluIHRoZSBsaW5lOiByZWFkIGEgY2h1bmssIGZvcndhcmQg
aXQgdW5jaGFuZ2VkLCB0aGVuIGNvcHkgaXQuICovCiAgICBmb3IgKDs7KSB7CiAgICAgICAgY2hh
ciBidWZbQ0hVTktdOwogICAgICAgIHNzaXplX3QgbiA9IHJlYWQoaW4sIGJ1Ziwgc2l6ZW9mIGJ1
Zik7CiAgICAgICAgaWYgKG4gPCAwKSB7CiAgICAgICAgICAgIGlmIChlcnJubyA9PSBFSU5UUikK
ICAgICAgICAgICAgICAgIGNvbnRpbnVlOwogICAgICAgICAgICByZXR1cm4gMTsKICAgICAgICB9
CiAgICAgICAgaWYgKG4gPT0gMCkgICAgICAgIC8qIGFuIE9fUkRXUiBGSUZPIGRvZXMgbm90IHJl
YWNoIGhlcmU7IGJlIHNhZmUgKi8KICAgICAgICAgICAgY29udGludWU7CiAgICAgICAgaWYgKHdy
aXRlX2FsbChvdXQsIGJ1ZiwgbikgIT0gMCkKICAgICAgICAgICAgY29udGludWU7ICAgICAgLyog
a2VlcCBzdGFuZGluZyBldmVuIGlmIGEgZm9yd2FyZCBmYWlscyAqLwogICAgICAgIGlmICh3cml0
ZV9hbGwoZHJvcCwgYnVmLCBuKSAhPSAwKQogICAgICAgICAgICBjb250aW51ZTsKICAgIH0KICAg
IHJldHVybiAwOwp9Cg==
B64
}

# The drop box's pre-written traffic: twelve capsules of ordinary Exhibition
# post, in arrival order, dated Fri 30 Oct to Mon 2 Nov 1851 (the 2026 calendar,
# year 1851). This is what the tap had already drunk before staging. No capsule
# carries a clock time (the headers carry dates only). Every
# header begins `CAPSULE ` so `grep -c '^CAPSULE '` counts the twelve whatever
# the student later sends.
decode_capsules() { # writes the twelve capsules to $1
  base64 -d > "$1" <<'B64'
Q0FQU1VMRSAwMSAtLSBGcmkgMzAgT2N0IDE4NTEgLS0gRlJPTSBUSEUgVEVMRUdSQVBIIEVYQ0hB
TkdFIFRPIFRIRSBCT0FSRCBPRiBUSEUgRU5HSU5FSE9VU0UKTm90aWNlIHRvIGFsbCBvZmZpY2Vz
OiBmcm9tIE1vbmRheSAyIE5vdmVtYmVyIDE4NTEsIG91dGJvdW5kIEV4aGliaXRpb24KdHJhZmZp
YyBsZWF2ZXMgdGhlIHdpcmVzIGFuZCBnb2VzIGJ5IHBuZXVtYXRpYyBwb3N0IHRvIHRoZSB1cGdy
YWRlZApleGNoYW5nZS4gRGlyZWN0IHlvdXIgY2Fwc3VsZXMgdG8gdGhlIHBvc3QgY2xlcmsgaGVu
Y2Vmb3J0aC4KCkNBUFNVTEUgMDIgLS0gRnJpIDMwIE9jdCAxODUxIC0tIEZST00gVEhFIEVYSElC
SVRJT04gT0ZGSUNFIFRPIFRIRSBCT0FSRCBPRiBUSEUgRU5HSU5FSE9VU0UKVGhlIGdhbGxlcnkg
Zmxvb3IgaXMgbGFpZCBhbmQgdGhlIEVuZ2luZSdzIHBsaW50aCBpcyBzZXQuIFdlIHdhbnQgdGhl
CmZpbmFsIHRhbGx5IG9mIHZpc2l0aW5nIEJvYXJkcyBiZWZvcmUgdGhlIHdlZWsgaXMgb3V0LgoK
Q0FQU1VMRSAwMyAtLSBGcmkgMzAgT2N0IDE4NTEgLS0gRlJPTSBUSEUgUE9SVEVSUycgTE9ER0Ug
VE8gVEhFIFRFTEVHUkFQSCBFWENIQU5HRQpUd28gY2FydHMgb2YgY3JhdGluZyBkZWxpdmVyZWQg
dG8gdGhlIGVhc3QgZG9vci4gVGhlIHBvcnRlcnMgcmVwb3J0IHRoZQpuZXcgcG9zdCBsaW5lIGhp
c3NlcyB3aGVuIGEgY2Fwc3VsZSBwYXNzZXMuIFdlIHRoaW5rIG5vdGhpbmcgb2YgaXQuCgpDQVBT
VUxFIDA0IC0tIEZyaSAzMCBPY3QgMTg1MSAtLSBGUk9NIChub25lIGdpdmVuKSBUTyBUSEUgRVhD
SEFOR0UgLS0gSE9MRApUbyB0aGUgQm9hcmRzIG9mIHRoZSBmaXZlIHNpc3RlciBjaXRpZXMsIGZv
ciB0aGUgRXhoaWJpdGlvbidzIG9wZW5pbmcgbW9ybmluZyAtLQpHZW50bGVtZW46IHlvdSBhcmUg
YnVpbGRpbmcgRW5naW5lcyBvZiB5b3VyIG93biwgYW5kIHlvdSBhcmUgaW52aXRlZCB0byBhZG1p
cmUgb3Vycy4KQWRtaXJlIGl0LiBUaGVuIGNoZWNrIGl0LiBJdHMgdGFibGVzIGhhdmUgY2Fycmll
ZCBlcnJvcnMgZm9yIHllYXJzLAphbmQgdGhlIG1lbiB3aG8gY291bGQgaGF2ZSBjYXVnaHQgdGhl
bSB3ZXJlIHNlbnQgaG9tZS4KQSBtYWNoaW5lIHRoYXQgaXMgbmV2ZXIgY2hlY2tlZCBpcyBub3Qg
dHJ1c3RlZC4gSXQgaXMgb25seSBiZWxpZXZlZC4KQmVmb3JlIHlvdSB0cnVzdCB5b3VycywgZmlu
ZCBzb21lb25lIHdobyB3aWxsIGNoZWNrIGl0Lgp5b3VyIGRpbGlnZW50IHNlcnZhbnQsCgpDQVBT
VUxFIDA1IC0tIEZyaSAzMCBPY3QgMTg1MSAtLSBGUk9NIFRIRSBHQVpFVFRFIFRPIFRIRSBFWEhJ
QklUSU9OIE9GRklDRQpXZSB3aWxsIHJ1biB0aGUgRXhoaWJpdGlvbiBzdXBwbGVtZW50IG9uIHRo
ZSBldmUgb2YgdGhlIG9wZW5pbmcuIFNlbmQgdXMKdGhlIGxpc3Qgb2YgZW5naW5lcyBvbiBzaG93
IGFuZCB0aGUgbmFtZXMgb2YgdGhlIHZpc2l0aW5nIEJvYXJkcy4KCkNBUFNVTEUgMDYgLS0gU2F0
IDMxIE9jdCAxODUxIC0tIEZST00gVEhFIEJPQVJEIE9GIFRIRSBFTkdJTkVIT1VTRSBUTyBUSEUg
RVhISUJJVElPTiBPRkZJQ0UKVGhlIHRhbGx5IHN0YW5kcyBhdCBmaXZlIHZpc2l0aW5nIEJvYXJk
cyBjb25maXJtZWQuIFJvb21zIGFyZSByZXNlcnZlZC4KV2Ugd2lsbCBtZWV0IHRoZW0gYXQgdGhl
IGV4Y2hhbmdlIG9uIHRoZSBmaXJzdCBkYXkuCgpDQVBTVUxFIDA3IC0tIFNhdCAzMSBPY3QgMTg1
MSAtLSBGUk9NIFRIRSBFWEhJQklUSU9OIE9GRklDRSBUTyBUSEUgUE9SVEVSUycgTE9ER0UKQ2xl
YXIgdGhlIGVhc3QgZ2FsbGVyeSBmb3IgdGhlIHZpc2l0aW5nIGRlbGVnYXRpb25zLiBUaGUgcGxp
bnRoIHJhaWwgaXMKdG8gYmUgcG9saXNoZWQgYW5kIHRoZSBmbG9vciBzd2VwdCB0d2ljZSBiZWZv
cmUgTW9uZGF5LgoKQ0FQU1VMRSAwOCAtLSBTdW4gMSBOb3YgMTg1MSAtLSBGUk9NIFRIRSBQT1JU
RVJTJyBMT0RHRSBUTyBUSEUgQk9BUkQgT0YgVEhFIEVOR0lORUhPVVNFCkdhbGxlcnkgY2xlYXJl
ZCBhbmQgc3dlcHQuIFRoZSBwb3N0IGxpbmUgd2FzIHRlc3RlZCB3aXRoIGFuIGVtcHR5IGNhcHN1
bGUKYW5kIHJhbiBjbGVhbi4gQWxsIGZpdHRpbmdzIGhvbGQuCgpDQVBTVUxFIDA5IC0tIFN1biAx
IE5vdiAxODUxIC0tIEZST00gVEhFIFRFTEVHUkFQSCBFWENIQU5HRSBUTyBUSEUgQk9BUkQgT0Yg
VEhFIEVOR0lORUhPVVNFClRoZSB1cGdyYWRlZCBleGNoYW5nZSBpcyByZWFkeSBmb3IgTW9uZGF5
J3MgZmlyc3QgdHJhZmZpYy4gT3BlcmF0b3JzIGFyZQpicmllZmVkLiBQbmV1bWF0aWMgcG9zdCBj
YXJyaWVzIGFsbCBFeGhpYml0aW9uIGNhcHN1bGVzIGZyb20gdG9tb3Jyb3cuCgpDQVBTVUxFIDEw
IC0tIE1vbiAyIE5vdiAxODUxIC0tIEZST00gVEhFIEJPQVJEIE9GIFRIRSBFTkdJTkVIT1VTRSBU
TyBUSEUgRVhISUJJVElPTiBPRkZJQ0UKRmlyc3QgcG9zdCBhd2F5IHRoaXMgbW9ybmluZy4gVGhl
IGxpbmUgY2FycmllZCB0aGUgZGF5J3Mgbm90aWNlcyB3aXRob3V0CmZhdWx0LiBXZWxjb21lIHRo
ZSBCb2FyZHMgYXMgdGhleSBhcnJpdmUuCgpDQVBTVUxFIDExIC0tIE1vbiAyIE5vdiAxODUxIC0t
IEZST00gVEhFIEVYSElCSVRJT04gT0ZGSUNFIFRPIFRIRSBHQVpFVFRFClRoZSBzdXBwbGVtZW50
IG1heSBhbm5vdW5jZSB0aGF0IHRoZSBFeGhpYml0aW9uIG9wZW5zIHRvIHRoZSBwdWJsaWMgd2l0
aGluCnRoZSBtb250aC4gVGhlIEVuZ2luZSB3aWxsIGJlIHNob3duIHdvcmtpbmcgb24gdGhlIGhv
dXIuCgpDQVBTVUxFIDEyIC0tIE1vbiAyIE5vdiAxODUxIC0tIEZST00gVEhFIEdBWkVUVEUgVE8g
VEhFIEJPQVJEIE9GIFRIRSBFTkdJTkVIT1VTRQpTdXBwbGVtZW50IHNldCBpbiB0eXBlLiBXZSBo
b2xkIHRoZSBmcm9udCBwYWdlIGZvciB0aGUgb3BlbmluZy4gU2VuZCBhbnkKZmluYWwgd29yZCBi
eSBwb3N0IGJlZm9yZSB0aGUgcHJlc3NlcyBydW4uCg==
B64
}

HERE="$(cd "$(dirname "$0")" && pwd)"
ROLL="$HERE/../lib/archive-roll.sh"
LC_ALL=C          # stat's file-type words are read back in English
export LC_ALL

# --------------------------------------------------------------- root guard --
# A classic move (Weeks 1 and 3 both log it): run the whole script under sudo
# instead of letting it ask for root itself. That stages root's home, not
# yours, and every check this week reads from your own bench. Refuse before
# anything is created.
if [ "$(id -u)" -eq 0 ]; then
  echo "report-for-duty: run this as YOURSELF, not as root."                >&2
  echo "  This script asks for the house keys itself, once, exactly when"   >&2
  echo "  it needs them -- running it under sudo stages root's home"        >&2
  echo "  directory instead of yours, and nothing this week will find it"   >&2
  echo "  there. Nothing has been staged. Run it again as yourself:"        >&2
  echo "    bash report-for-duty.sh"                                        >&2
  exit 1
fi

# Is systemd the init here, and is systemd-run on the bench? If so, the copier
# is launched as a transient unit, which systemd keeps alive past the shell
# that staged it. If not, we fall back to setsid (see launch_tee).
have_systemd_run() {
  command -v systemd-run >/dev/null 2>&1 && [ -d /run/systemd/system ]
}

# THIS HOME'S COPIER: every uid-1849 process named exactly tube-tee that is
# alive in /proc AND whose command line names a fitting under this home's
# post/. A bare `pgrep -u 1849 -x tube-tee` would also find another home's
# copier on a shared bench, so it is never used alone. (Not kill -0: you may
# not signal another account's process, so the knock fails with EPERM.)
tee_pids() {
  for _p in $(pgrep -u "$HOLDER_UID" -x tube-tee 2>/dev/null || true); do
    [ -d "/proc/$_p" ] || continue
    if tr '\0' '\n' < "/proc/$_p/cmdline" 2>/dev/null |
       awk -v p="$POST/" 'index($0, p) == 1 { f = 1 } END { exit !f }'; then
      echo "$_p"
    fi
  done
}
tee_pid() { tee_pids | head -1; }
tee_up()  { [ -n "$(tee_pid)" ]; }

# Can this session get root? sudo, either already open or with a terminal to
# ask for the password on.
get_root() {
  command -v sudo >/dev/null 2>&1 || return 1
  sudo -n true 2>/dev/null && return 0
  { [ -t 0 ] && [ -t 1 ]; } || return 1
  sudo -v
}

# Stand this home's copier down, and nobody else's. The unit first; then, as
# a backstop (or where it was launched without systemd), by pid -- SIGTERM,
# and SIGKILL if it will not go. Needs root: the copier is not yours. True
# only if no copier of this home's is left standing.
stop_tee() {
  if have_systemd_run; then
    sudo systemctl stop "$UNIT" 2>/dev/null || true
  fi
  for _p in $(tee_pids); do
    sudo kill -TERM "$_p" 2>/dev/null || true
    _i=0
    while [ "$_i" -lt 40 ] && [ -d "/proc/$_p" ]; do sleep 0.1; _i=$((_i + 1)); done
    if [ -d "/proc/$_p" ]; then sudo kill -KILL "$_p" 2>/dev/null || true; fi
  done
  if have_systemd_run; then
    sudo systemctl reset-failed "$UNIT" 2>/dev/null || true
  fi
  _i=0
  while [ "$_i" -lt 20 ] && tee_up; do sleep 0.1; _i=$((_i + 1)); done
  ! tee_up
}

# ------------------------------------------------------------------ --reset --
if [ "${1:-}" = "--reset" ]; then
  # The copier and its drop box belong to uid 1849, not to you, so striking
  # them needs the house keys. If either is on the bench and root cannot be
  # had, nothing at all is removed: a half-struck post is worse than an
  # untouched one.
  if tee_up || [ -e "$DROPBOX" ]; then
    echo "Striking the post. One step, via sudo: it stands down the copier"
    echo "(uid $HOLDER_UID) and removes the drop box it writes to -- neither is"
    echo "yours, so neither will yield to you. sudo may ask for your password now."
    if ! get_root; then
      echo "report-for-duty: this bench cannot get root, so the post could not"  >&2
      echo "  be struck. Nothing has been removed -- the post is exactly as you"  >&2
      echo "  found it. Take this to your instructor rather than working"         >&2
      echo "  around it."                                                         >&2
      exit 1
    fi
    # The copier goes FIRST. While it stands, it holds the drop file open for
    # appending; removing the file under it would leave it writing into a
    # file that is no longer on the bench.
    if ! stop_tee; then
      echo "report-for-duty: the copier would not stand down. Nothing has been" >&2
      echo "  removed. Take this to your instructor."                           >&2
      exit 1
    fi
    if [ -e "$DROPBOX" ]; then
      sudo rm -rf "$DROPBOX"
    fi
  else
    # Not standing -- a reboot or wsl --shutdown may have taken it. Clear a
    # stale unit if root is free, but do not demand it just to sweep files.
    if have_systemd_run && sudo -n true 2>/dev/null; then
      sudo systemctl reset-failed "$UNIT" 2>/dev/null || true
    fi
  fi

  # The rest is yours: the post's own directory (its two uid-1849 fittings
  # sit in a directory you own, so you may remove them), the copier's
  # workshop, and your tube shop with everything you built in it.
  rm -rf "$POST" "$POSTWORKS" "$TUBESHOP"
  # enginehouse/ is shared. It goes only if this week leaves it empty and
  # Week 1's own marker is gone too -- the guard the other weeks use.
  if [ ! -e "$ENGINEHOUSE/inbox" ]; then
    rmdir "$ENGINEHOUSE" 2>/dev/null || true
  fi
  echo "Bench struck. The copier is stood down, and the post and tube shop with it."
  if [ -d "$ENGINEHOUSE" ]; then
    echo "~/enginehouse still holds other weeks' papers; they were not touched."
  fi
  echo "The house roll is untouched -- that entry belongs to the course and not"
  echo "to this week, and later work still rests on it. (bash ../lib/archive-roll.sh"
  echo "teardown removes it, once, at the end of term.)"
  echo "(Run this script again, without --reset, to stage the week afresh.)"
  exit 0
elif [ "$#" -gt 0 ]; then
  echo "usage: bash report-for-duty.sh [--reset]" >&2
  exit 2
fi

# Launch the copier as root, on this home's three fittings. It opens them,
# drops its own privileges to uid 1849 / gid 100, and forks, so the unit is
# Type=forking: a default (simple) unit would take the parent's exit for the
# end and reap the copy.
#
# Preferred: a transient systemd unit, alive past the shell that staged it,
# its chain topping out at PID 1. Fallback (no systemd as PID 1, or no
# systemd-run): setsid, which may not outlive its login session.
launch_tee() {
  if have_systemd_run; then
    sudo systemctl reset-failed "$UNIT" 2>/dev/null || true
    sudo systemd-run --collect --quiet --unit="$UNIT" -p Type=forking \
      "$BIN" "$LISTENING" "$EXCHANGE" "$DROPFILE"
  else
    sudo setsid "$BIN" "$LISTENING" "$EXCHANGE" "$DROPFILE" </dev/null >/dev/null 2>&1
  fi
}

# The inode behind the copier's descriptor for the drop file, read from its
# open-file table (root only). Prints nothing if the copier holds no file at
# that path -- including one that has been replaced under it, which the
# table shows as "(deleted)".
held_drop_inode() {
  for _fd in $(sudo ls "/proc/$1/fd" 2>/dev/null); do
    if [ "$(sudo readlink "/proc/$1/fd/$_fd" 2>/dev/null)" = "$DROPFILE" ]; then
      sudo stat -L -c %i "/proc/$1/fd/$_fd" 2>/dev/null
      return 0
    fi
  done
  return 0
}

# ------------------------------------------------------ what still wants doing
# Worked out before anything root happens, so a bench that cannot get root is
# left as it was found rather than half-staged.
need_roll=0
bash "$ROLL" check || need_roll=1
restage=0
if tee_up || [ -e "$POST" ]; then restage=1; fi

# ------------------------------------------------------------ build the copier
# Built before the root window, so a bench that cannot build it is left
# exactly as it was found.
if ! command -v gcc >/dev/null 2>&1; then
  echo "report-for-duty: gcc not found -- this week's copier is compiled at your own bench." >&2
  echo "Run the 'a tool is missing' fix in setup/getting-started.md Troubleshooting, then try again." >&2
  exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
decode_tube_tee "$tmp/tube-tee.c"
decode_capsules "$tmp/capsules.txt"
if ! ( cd "$tmp" && gcc -O2 -s -Wall -Wextra -o tube-tee tube-tee.c ); then
  echo "report-for-duty: the copier did not build on this bench. The messages"  >&2
  echo "  above are gcc's. Nothing has been staged. Take this to your"          >&2
  echo "  instructor rather than working around it."                            >&2
  exit 1
fi

# -------------------------------------------------------------- the house keys
stand_down() {
  echo "report-for-duty: this bench cannot get root -- either sudo is not"      >&2
  echo "  installed, or it wants a password prompt this session has no"         >&2
  echo "  terminal to give. Nothing has been staged: the post is exactly"       >&2
  echo "  as you found it. Take this to your instructor rather than working"    >&2
  echo "  around it."                                                           >&2
  exit 1
}

echo "Before the post can be staged, the house keys are wanted. They are"
echo "asked for once, for the whole of the following, and for nothing else:"
echo
if [ "$need_roll" -ne 0 ]; then
  echo "  * The roll. One dormant entry is restored to it (useradd, by"
  echo "    labs/lib/archive-roll.sh): no password, no home directory, no"
  echo "    login shell -- nothing can log in as it. Reversible by name, and"
  echo "    shared with later weeks, so no week's --reset takes it away."
fi
if [ "$restage" -ne 0 ]; then
  echo "  * The old post. Its copier is stood down and its drop box removed,"
  echo "    so the line can be rebuilt clean. (Only this home's: another"
  echo "    account's post on this machine is not touched.)"
fi
echo "  * The fittings. Three are made over to uid $HOLDER_UID: the tube"
echo "    .listening-tube, the symlink outbound that leads into it, and the"
echo "    drop box .drop-box/ with its one file. The rest of the post is yours."
if have_systemd_run; then
  echo "  * The copier. It is launched as a transient unit named '$UNIT'"
  echo "    (systemd-run), opens the line's fittings, then drops itself to"
  echo "    uid $HOLDER_UID and stands. systemd keeps it alive past this shell;"
  echo "    its chain tops out at PID 1, so no schedule owns it."
else
  echo "  * The copier. It is launched (setsid), opens the line's fittings,"
  echo "    then drops itself to uid $HOLDER_UID and stands. This bench has no"
  echo "    systemd to keep it, so it may not outlive this login session."
fi
echo "  * The drop box's papers. One test capsule is sent down the line and"
echo "    looked for at both ends; the drop box is then emptied in place and"
echo "    its papers written in."
echo "  * One look at the copier's open files (only root may read them), to"
echo "    confirm it writes to the very drop box you can see."
echo
echo "One prompt covers all of it. sudo may ask for your password now, once,"
echo "and everything listed above happens inside that one window."
if [ "$need_roll" -ne 0 ]; then
  echo "(The roll office adds its own note on the first item as it works. It"
  echo "will not ask you for anything.)"
fi
echo

command -v sudo >/dev/null 2>&1 || stand_down
if ! sudo -n true 2>/dev/null; then
  { [ -t 0 ] && [ -t 1 ]; } || stand_down
  sudo -v || stand_down
fi

# -------------------------------------------------------------- the house roll
if [ "$need_roll" -ne 0 ]; then
  if ! bash "$ROLL" ensure; then
    echo "report-for-duty: the house roll was not restored, so the post has"    >&2
    echo "  been left unstaged rather than half-staged. The message above is"   >&2
    echo "  the roll office's -- take it to your instructor."                    >&2
    exit 1
  fi
  echo
fi

# ------------------------------------------------------------- strike the old
# The copier goes first, before anything it holds is touched: its descriptors
# are bound to the old fittings, so a copier left standing would carry on
# with a line and a drop box that are no longer on the bench.
if ! stop_tee; then
  echo "report-for-duty: the old copier would not stand down. Nothing has been" >&2
  echo "  rebuilt. Take this to your instructor."                                >&2
  exit 1
fi
if [ -e "$DROPBOX" ]; then
  sudo rm -rf "$DROPBOX"
fi
rm -rf "$POST"

# -------------------------------------------------------------------- the post
mkdir -p "$POST" "$POSTWORKS" "$TUBESHOP"
chmod 755 "$POST"
mv -f "$tmp/tube-tee" "$BIN"
chmod 755 "$BIN"
mkfifo -m 644 "$EXCHANGE"
sudo mkfifo -m 622 "$LISTENING"
sudo chown "$HOLDER_UID:$HOLDER_GID" "$LISTENING"
sudo ln -s .listening-tube "$OUTBOUND"
sudo chown -h "$HOLDER_UID:$HOLDER_GID" "$OUTBOUND"
sudo install -d -o "$HOLDER_UID" -g "$HOLDER_GID" -m 755 "$DROPBOX"
sudo install -o "$HOLDER_UID" -g "$HOLDER_GID" -m 644 /dev/null "$DROPFILE"

# ------------------------------------------------------------ launch the copier
if ! launch_tee; then
  echo "report-for-duty: the copier could not be launched. Take this to your" >&2
  echo "  instructor."                                                        >&2
  exit 1
fi
i=0
while [ "$i" -lt 40 ] && ! tee_up; do sleep 0.1; i=$((i + 1)); done
if ! tee_up; then
  echo "report-for-duty: the copier did not come up after launch. Take this"  >&2
  echo "  to your instructor."                                                >&2
  exit 1
fi

# ----------------------------------------------------------- the drop box fill
# The drop file is NEVER rewritten, moved or replaced while the copier holds
# it open: an in-place rewrite gives the file a new inode, and the copier's
# appends would go to the old one, which nobody can see. So, in this order:
# it was made empty above; the copier is up; a test capsule goes down the
# line and is looked for at the exchange end and (it lands just after the
# forward) in the drop file; then the file is emptied IN PLACE and the
# papers are appended to it.
probe="STAGING PROBE -- line test $$"
probe_out=0
probe_drop=0
# Someone must be reading at the exchange end, or the test capsule would sit
# there and be the first thing you received. A small capsule; a short read.
timeout 2 cat "$EXCHANGE" > "$tmp/exchange.out" 2>/dev/null &
reader=$!
sleep 0.2
timeout 3 sh -c 'printf "%s\n" "$1" > "$2"' sh "$probe" "$OUTBOUND" || true
wait "$reader" || true      # timeout's 124: the exchange end never ends (F-9)
if [ "$(cat "$tmp/exchange.out")" = "$probe" ]; then probe_out=1; fi
i=0
while [ "$i" -lt 20 ]; do
  if grep -qxF -- "$probe" "$DROPFILE" 2>/dev/null; then probe_drop=1; break; fi
  sleep 0.1; i=$((i + 1))
done
if [ "$probe_out" -ne 1 ] || [ "$probe_drop" -ne 1 ]; then
  echo "report-for-duty: the line did not carry its test capsule (exchange end:" >&2
  echo "  $probe_out, drop box: $probe_drop). The copier is up but the post is"  >&2
  echo "  not filled. Run this script again; if it fails twice, run"             >&2
  echo "  bash report-for-duty.sh --reset and take this to your instructor."     >&2
  exit 1
fi
ino_before="$(stat -c %i "$DROPFILE")"
sudo truncate -s 0 "$DROPFILE"
sudo sh -c 'cat "$1" >> "$2"' sh "$tmp/capsules.txt" "$DROPFILE"

# ------------------------------------------------------------------ self-test
fail=0
me="$(id -u):$(id -g)"
expect() { # expect <path> <%F> <uid:gid> <mode, or - for any>
  _got="$(stat -c '%F|%u:%g|%a' "$1" 2>/dev/null || echo missing)"
  _want="$2|$3|$4"
  [ "$4" = - ] && _got="${_got%|*}|-"
  if [ "$_got" != "$_want" ]; then
    echo "self-test: $1 is '$_got', not '$_want'" >&2; fail=1
  fi
}
expect "$POST"      directory        "$me"                        755
expect "$EXCHANGE"  fifo             "$me"                        644
expect "$LISTENING" fifo             "$HOLDER_UID:$HOLDER_GID"    622
expect "$OUTBOUND"  "symbolic link"  "$HOLDER_UID:$HOLDER_GID"    777
expect "$DROPBOX"   directory        "$HOLDER_UID:$HOLDER_GID"    755
expect "$DROPFILE"  "regular file"   "$HOLDER_UID:$HOLDER_GID"    644
expect "$BIN"       "regular file"   "$me"                        755
expect "$TUBESHOP"  directory        "$me"                        -
if [ "$(readlink "$OUTBOUND")" != ".listening-tube" ]; then
  echo "self-test: outbound does not lead to .listening-tube" >&2; fail=1
fi
if [ "$(ls -A "$POST" | sort | tr '\n' ' ')" != ".drop-box .listening-tube exchange-line outbound " ]; then
  echo "self-test: post/ does not hold exactly its four fittings" >&2; fail=1
fi
# The kernel's FIFO and symlink protections bite only in sticky,
# world-writable directories (like /tmp). post/ must be neither, or your own
# capsule would be refused at outbound.
if [ -k "$POST" ] || [ -n "$(find "$POST" -maxdepth 0 -perm -0002)" ]; then
  echo "self-test: post/ is sticky or world-writable" >&2; fail=1
fi
pids="$(tee_pids)"
if [ "$(printf '%s\n' "$pids" | grep -c .)" -ne 1 ]; then
  echo "self-test: want exactly one copier on this home's post, found: ${pids:-none}" >&2; fail=1
fi
pid="$(tee_pid)"
if [ -n "$pid" ]; then
  uids="$(awk '/^Uid:/{print $2, $3, $4, $5}' "/proc/$pid/status" 2>/dev/null)"
  gids="$(awk '/^Gid:/{print $2, $3, $4, $5}' "/proc/$pid/status" 2>/dev/null)"
  if [ "$uids" != "$HOLDER_UID $HOLDER_UID $HOLDER_UID $HOLDER_UID" ] ||
     [ "$gids" != "$HOLDER_GID $HOLDER_GID $HOLDER_GID $HOLDER_GID" ]; then
    echo "self-test: the copier runs as uid '$uids' gid '$gids', not $HOLDER_UID/$HOLDER_GID" >&2; fail=1
  fi
  if [ "$(tr '\0' '\n' < "/proc/$pid/cmdline")" != "$(printf '%s\n' "$BIN" "$LISTENING" "$EXCHANGE" "$DROPFILE")" ]; then
    echo "self-test: the copier's command line does not name this home's three fittings" >&2; fail=1
  fi
  held="$(held_drop_inode "$pid")"
  now="$(stat -c %i "$DROPFILE")"
  if [ -z "$held" ] || [ "$held" != "$now" ] || [ "$now" != "$ino_before" ]; then
    echo "self-test: the copier holds drop-box inode '${held:-none}', the bench shows $now (was $ino_before)" >&2; fail=1
  fi
fi
if have_systemd_run && ! systemctl is-active --quiet "$UNIT"; then
  echo "self-test: the unit $UNIT is not active" >&2; fail=1
fi
if ! cmp -s "$tmp/capsules.txt" "$DROPFILE"; then
  echo "self-test: the drop box does not hold exactly its staged papers" >&2; fail=1
fi
if [ "$(grep -c '^CAPSULE ' "$DROPFILE")" -ne 12 ]; then
  echo "self-test: the drop box does not hold twelve capsules" >&2; fail=1
fi
if ! bash "$ROLL" check; then
  echo "self-test: the house roll does not carry uid $HOLDER_UID" >&2; fail=1
fi
if [ "$fail" -ne 0 ]; then
  echo "report-for-duty: staging incomplete -- see messages above." >&2
  exit 1
fi

# ------------------------------------------------------------------ duty slip
cat <<'SLIP'

  ------------------------------------------------------------------
   DUTY SLIP -- Honourable Guild of Enginewrights
   Work Order No. 1851-12 :: bench staged and verified
  ------------------------------------------------------------------
   Post:      ~/enginehouse/post/        the line to the exchange
   Workshop:  ~/enginehouse/tube-shop/   yours -- your own fittings

   The post's line is live: a capsule sent down outbound comes out
   at exchange-line. Not every fitting on it is yours. You can see
   which are, and whose the others are, from your own screen. The
   work order shows you where to look.

   The line's copier is a living process, not a file: it does NOT
   survive `wsl --shutdown`, a reboot, or (on WSL) closing every
   Ubuntu window. Re-run this script to stage it afresh -- that
   rebuilds the post and refills its drop box, and sweeps away
   anything you sent down the line before.
   (bash report-for-duty.sh --reset strikes the post. The house roll
   stays -- later weeks are standing on it.)
  ------------------------------------------------------------------

SLIP

# This week's instruments. They are on every setup path, but a bench that
# lost one should hear so now rather than at the first command.
for t in lsof fuser mkfifo timeout; do
  if ! command -v "$t" >/dev/null 2>&1; then
    echo "report-for-duty: note -- $t is not on this bench, and this week needs it." >&2
    echo "Run the 'a tool is missing' fix in setup/getting-started.md Troubleshooting." >&2
  fi
done
