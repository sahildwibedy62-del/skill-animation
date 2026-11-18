"""Cue table for "The Soldier Who Never Left" -> music.wav + sfx.wav (stems only).

Run:  python3 audio.py      then:  python3 mix.py voice.mp3 music.wav sfx.wav
For a new story keep the structure and rewrite only the cue list. Times are frames (T.F) or seconds.
Do NOT mix, duck or compress here: mix.py sets the final levels (music and SFX at 50 % of the voice).
"""
from synth import *

T = Track.for_voice()          # 19.72 s for this short
music, sfx = T.new(), T.new()
F = T.F

# ---------------- music ----------------
TWIST = 14.15                  # music stops on "The bridge is not safe."
march(T, music, end=TWIST, bpm=104, prog=PROG_MINOR)
drone(T, music, TWIST)

# ---------------- sfx cue table ----------------
T.place(sfx, whoosh(0.6), F(18), 0.5)            # hook camera pull-back
T.place(sfx, leaves(2.2), F(62), 0.35)           # the years blow past
T.place(sfx, thunk(85, 0.35), F(120), 1.0)       # spear stamp on "post"
T.place(sfx, rumble(2.2), F(176), 0.9)           # empire collapses
T.place(sfx, crash(1.4), F(186), 0.7)
T.place(sfx, whoosh(0.5), F(196), 0.35)          # rack to the soldier
T.place(sfx, cuckoo(), F(255), 0.35)             # "crazy"
T.place(sfx, whoosh(0.4), F(276), 0.6)           # time-jump flash
for k in range(2):
    T.place(sfx, snore(1.15), F(286) + k * 1.45, 0.45)
T.place(sfx, scrape(0.9), F(316), 0.6)           # helmet lifted
T.place(sfx, ting(), F(392), 0.55)               # the carving glints
T.place(sfx, sting(), 14.18, 0.85)               # "The bridge is not safe."
T.place(sfx, creak(0.55, 120), F(464), 0.9); T.place(sfx, creak(0.5, 160), F(473), 0.7)
T.place(sfx, whoosh(0.7), F(484), 0.5)           # crane under the deck
T.place(sfx, water(T.dur - F(484)), F(484), 0.35)
T.place(sfx, creak(0.8, 90), F(536), 1.0)
T.place(sfx, snap(), F(548), 0.9)                # brace breaks on "rotting"
T.place(sfx, splash(1.0), F(580), 0.9)

T.save(music, "music.wav")
T.save(sfx, "sfx.wav", crest_db=14)   # tame transients so SFX can sit near 50 % under the peak cap
