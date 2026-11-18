# cartoon-short-kit (v2)
Created by the WHATIF ANIMATIONSTORYS channel.
Audio in, finished vertical cartoon short out. 2D bean-head cards in an inked, painted 3D world
(three.js in headless Chromium, no Remotion and no GPU needed), with a synthesized music bed and SFX.

- `engine/` renderer: world helpers, cards, ink pass, lens blur, grade (`main.js`), painted textures (`paint.js`),
  cast drawing (`roman.js` on top of the Pen library), motion helpers (`motion.js`).
- `example/soldier/` worked example "The Soldier Who Never Left" (story.js shot plan + audio.py cue table).
- `tools/`
  - `setup.sh` new project (offline: uses `vendor/`, caches in ~/.cache/cartoon-short-kit)
  - `short.sh` one entry point: doctor, timing, cast, stills, sound, render, progress, finish
  - `timing.py` word/phrase timings + warnings
  - `render.mjs` frames (parallel WORKERS, RESUME, progress/ETA, atomic writes, retries)
  - `castsheet.mjs` character test sheet
  - `sheet.py` labelled contact sheets
  - `synth.py` music + SFX synths
  - `mix.py` level-locked mix (music/SFX at 50 % of voice)
  - `finish.sh` linear loudness gain + limiter, encode, QA report
- `vendor/` three.js r160 and toon.ts (both MIT) so setup needs no network.

Quick start:
```
bash tools/setup.sh ~/shorts/my-short && cd ~/shorts/my-short
cp /path/voice.mp3 voice.mp3 && echo "script text" > script.txt
./short.sh doctor && ./short.sh timing && ./short.sh stills "5,40,90" a
./short.sh sound && WORKERS=2 ./short.sh render && ./short.sh finish "My Short"
```

## What changed in v2
- **Added `mix.py`.** The skill required it, but it was missing. It locks music at exactly −6 dB vs the voice and SFX at or below that, with a peak cap. There's no ducking or saturation any more; the old example mix had both.
- **`finish.sh` uses one measured linear gain** to −14 LUFS plus a −1 dBFS limiter, replacing the dynamic single-pass loudnorm. It also checks that frames are complete and writes a PASS/FAIL QA report (`out/qa.txt`).
- **Synths moved into `synth.py`** with new SFX (pop, boing, steps, wind, crowd) and a major-key progression. Each project's `audio.py` is now just a cue table that writes stems.
- **Durations come from decoded audio.** MP3 padding no longer adds an extra frame.
- **`setup.sh` works offline** from `vendor/`. It never writes into the kit, checks every requirement, syntax-checks `toon.js`, and copies all the tools (the old one skipped `finish.sh`).
- **`render.mjs` gained** parallel workers, progress with ETA, safe resume (no half-written frames), retry on page crash, and exit codes.
- **New tools:** `castsheet.mjs` (character test sheet without three.js), `short.sh` (one-command steps and a machine doctor), and frame/time labels on contact sheets.
- **Timing warnings:** `timing.py` now flags very short phrases, overlaps, a late start, and a recording that doesn't match the script.
- **`index.html`** reports module-load failures instead of hanging.

Built on github.com/mromidev/claude-animated-shorts (MIT): toon.ts, look values and readability rules. three.js r160 (MIT).
