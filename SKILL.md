---
name: cartoon-audio-short
description: Make a vertical 9:16 animated cartoon short with flat 2D bean-head characters in a colourful inked 3D world. Pitches 10 verified story ideas, writes a timed script, then turns the user's voiceover into a finished 1080x1920 MP4 with music and SFX at half the voice level. Use for any cartoon short, animated story video, or history/science Short.
---

# Cartoon Audio Short (v2)
Created by the WHATIF ANIMATIONSTORYS channel.
Pipeline: idea → script → voiceover → finished MP4.
Reference build: "The Soldier Who Never Left" (19.7 s, 8 shots), included in `kit/example/soldier/`.

## The look
- **Characters:** flat 2D bean-head cartoon "cards" drawn on canvas. They have plum outlines and big readable expressions, and they always idle (breathing, blinking, head bobs).
- **World:** a saturated 3D set built from simple shapes. Painted flat textures with dark seams, black ink outlines, toon shading, and fog the colour of the horizon.
- **Camera:** gliding, eased moves, with depth of field on close-ups. Nothing is ever static.
- **Format:** 1080x1920, 30 fps, exactly as long as the voiceover.
- **Sound:** the user's voice untouched. A synthesized march-style music bed and SFX sit at 50 % (−6 dB) of the voice level.

## Hard rules
1. Original only. Never recreate another creator's video shot for shot; offer an original take on the same idea.
2. No real, named living people as characters. No brand mascots, logos or copyrighted characters.
3. No captions unless asked. Diegetic text (signs, carvings) is fine but must read correctly, never mirrored.
4. Never edit, trim, speed up or re-time the voice. The picture is timed to the voice. Every visual reaction lands 0–3 frames before its word.
5. The audio ratio is fixed:
   - Music sits at −6.0 dB vs the voice (gated RMS).
   - SFX sit at or below −6 dB, with peaks at most 0.7× the voice peak.
   - Always mix with `mix.py`. No ducking, no compression on the mix.
   - Only one linear gain plus one peak limiter go on the whole mix (`finish.sh`).
6. Check facts presented as true with a web search first. Frame viral legends as "legend says".
7. Nothing graphic, nothing political, and no real living person as the butt of a joke.
8. Keep working without approval stops. Ask a question only when the work truly can't continue without the answer.
9. Keep the user informed with a task list. Send a stills contact sheet before the long render.

## Routing (pick the entry point)
| User has | Go to |
|---|---|
| Audio attached (+ script) | Stage 4 immediately |
| Audio, no script | Ask for the script text (Claude can't hear audio without ASR) → Stage 4 |
| A script, no voice | Stage 3 (tighten) → wait for the audio |
| A topic only | Stage 3 directly (verify facts) |
| Nothing / "give me ideas" | Stage 2 |

If it's unclear, ask ONE question: "Where are you starting from? (ideas / script / voiceover ready)". Also ask the target length if not given. The default is 20–30 s; up to 60 s is allowed.

## Stage 2: 10 ideas
Give exactly 10, numbered, in one reply. End with: "Reply with a number, or 'more' for 10 new ones."

```
N. TITLE (5–8 words, curiosity-driven)
   Hook: the first spoken sentence — a paradox stated as fact.
   Twist: the ironic last line.
   Big visuals: 2–3 moments (collapse / reveal / chase / transformation).
   Status: TRUE (documented) · DISPUTED · LEGEND
```

A perfect idea has:
- One surprising story with a physical cause and effect you can SHOW.
- An everyman hero, stakes that escalate, and a twist in the last line.
- A set buildable from boxes, cylinders and spheres plus cards (town, bridge, ship, castle, desert, lab, palace, farm, harbour, mine).
- A "before vs after" you can see in one frame, which makes a strong thumbnail.

Spread the 10 across ancient, medieval, 1800s, modern, science, animals, inventions, disasters, weird laws and lucky accidents. Verify every TRUE or DISPUTED idea with a web search before listing it.

## Stage 3: Script
Size the script at about 3.7 spoken words per second: 20 s ≈ 75 words, 30 s ≈ 110, 45 s ≈ 165, 60 s ≈ 220.

Structure:
1. **Hook** (sentence 1, zero setup): the absurd fact. It must land in the first 1.5 s.
2. **Setting** (1–2 lines): when, where, who, and one concrete detail.
3. **Escalation** (2–4 beats, each bigger). Others doubt or mock. Include one exaggeration joke.
4. **Pivot:** "But when…" / "You see…" introduces the real mechanism, ideally with an everyday analogy.
5. **Twist:** short and ironic, and the LAST words of the video. Bonus: let it loop back into the hook so the Short replays naturally.

Style:
- Plain spoken English with contractions.
- Sentences of 8–15 words; numbers written as words.
- No stage directions in the spoken text.
- Never describe what the viewer already sees.

Self-check (fix silently if any fail): word count within ±10 % of target; the hook is a statement, not a question; every sentence can be illustrated literally; the twist is 12 words or fewer and comes last; the facts match the sources.

Reply with:
- **a)** The script in a code block, with the word count and estimated seconds.
- **b)** A one-paragraph visual plan.
- **c)** Recording tips:
  - One warm, steady narrator. ElevenLabs works well: a deep narrator voice, speed ~1.05–1.1, stability ~45–55 %.
  - MP3 or WAV is fine.
  - Leave natural pauses at sentence ends.
  - Export with NO music.
- **d)** "Upload the voiceover when it's ready and I'll make the full video."

Keep the final script text, because it drives the timing. If they recorded a changed version, ask for the final text.

## Stage 4: Build (no stops from here)
Create the task list: Setup · Timing · Shot plan · World · Cast · Motion · Contact sheet → user · Sound · Full render · Finish + QA · Deliver.

### 4.0 Setup
```bash
SK=$(dirname "$(find / -name SKILL.md -path '*cartoon-audio-short*' 2>/dev/null | head -1)")
bash "$SK/kit/tools/setup.sh" ~/shorts/<slug>      # treat $SK/kit as read-only
cd ~/shorts/<slug> && cp <uploaded voice> voice.mp3 && printf '%s' "<final script>" > script.txt
./short.sh doctor
```
- `setup.sh` copies the engine, the tools and the worked example (as the starting `web/story.js` and `audio.py`). It installs three.js r160 and the toon base from `kit/vendor/` (no network needed), builds and syntax-checks `web/toon.js`, and links Playwright. It exits 3 if three.js is missing.
- Requirements: Node 22.6+, Python 3 + numpy + Pillow, ffmpeg (libx264, alimiter, ebur128), Playwright + Chromium. If Playwright is missing: `npm i -g playwright && npx playwright install chromium`.
- Never disable TLS or bypass a proxy. If an install is blocked, say which package and continue with what's installed.
- Chromium uses CPU WebGL (swiftshader) at about 3–5 s per frame per worker. A 20 s short (600 frames) takes roughly 20–50 min; plan for it.

### 4.1 Timing: `./short.sh timing`
- If whisper or faster-whisper is installed, it uses word timestamps. Otherwise it aligns script phrases to silence-detected speech with a syllable/duration DP.
- It prints the phrases with frame ranges and WARN lines (very short phrases, overlaps, long tails, a late start, a recording that doesn't match the script). Resolve the warnings by merging shots, fixing `work/phrases.json` by hand, or asking for the final text.
- N = total frames = `frames30` in `work/phrases.json` (measured from the decoded audio).

### 4.2 Shot plan: `work/PLAN.md`, before any code
Make one row per shot: `| # | frames | words | setting | light | camera | cast/pose/face | FX | SFX |`
- Frame 0 IS the hook image: no fade-in, no title card.
- About one shot per phrase. Merge phrases shorter than 0.6 s into the next shot.
- Illustrate every sentence literally; props carry the jokes.
- Shot-size rhythm: hook MCU → wide reveal → two-shot → insert on the key object → reaction close-up → environment move for the payoff. Never use the same size twice in a row.
- Light sets the mood: day (normal), golden (drama/decline), night-blue (explanation). A time jump gets a 6-frame white flash.
- The twist gets a sting: music stops, a low hit, a push-in with a 3–5° roll. The physical payoff lands on the final word.
- The last frame should be a strong still that cuts cleanly back to frame 0 for looping.

### 4.3 World (`web/main.js`, `web/story.js`)
- Keep the engine sections in `main.js`: toon materials, ink contract, add/tbox, sky, lights, cards, render targets/post, applyLight, drawActors, swapForNd, renderFrame.
- Replace only the example world between `// ---------- world ----------` and `// ---------- cards ----------`, plus the story parts of `worldState()` and any props (the soldier example has a 3D helmet prop).
- `story.js` exports SHOTS, TOTAL, shotAt, camAt, dofAt, LIGHTS/lightFor, worldAt, actorsAt(f, T) and fxAt(f, T). All are pure functions of the frame. Set `TOTAL` = N.
- Textures come from `paint.js`: planks, beam, rotten, stone, mossy, grass, dirt, plaster, roof, marble, banner, carved text. New painters use the same flat-colour-with-dark-seams style.
- Use `tbox` for constant texel density, a 2-step toon gradient, and fog = horizon colour.
- Backdrop layers: half-buried sphere hills, cone mountains with snow caps, cypress/pine trees, distant houses, and painted cloud billboards.
- Set pieces (collapses, falls, doors) are pivoted groups driven by 0..1 progress from `worldAt(f)`, eased and staggered.
- Curved diegetic text uses planar UVs. Check it isn't mirrored.

### 4.4 Cast (`web/roman.js` → `web/toon.js`)
- `romanFront(p, outfitKey, opts)` draws on a 600x1000 design canvas with soles at y=975. The card is 2.25 m tall, so 1 design unit = 0.00225 m.
- Outfits (`OUTFITS`): legion, old, toga, civA, civB, civC, workA, workB. Add new ones with tunic/cape/armor/helmet/hair/cap/beard/apron/dress/toga keys.
- Arm poses: hang, spear, point, up, wave, hip, belly, temple(+swirl), lift, reach(+lift), cheek, shield, cross, thumb.
- Faces: the toon base FACE set plus snore, stubborn and squint. Extend FACE for more.
- After cast edits, rebuild with `cat web/toonbase.js web/roman.js > web/toon.js`. Then run `./short.sh cast` and LOOK at `stills/cast_sheet.png` before using a design.
- Billboards turn on yaw only, get a contact blob and an alpha-tested shadow, and are never inked by the world pass.
- Build card keys from `q()`-rounded values so the canvas redraws only on a visible change.
- A detached part (e.g. a lifted helmet) is its own card: `y = DECK + (partY − hc) × 0.00225`, aligned with `headCenter(seed)`.
- Give the hero ONE signature trait (colour, hat, prop) so they read instantly at phone size.

### 4.5 Motion (`web/motion.js`): smooth and alive
**Cameras:**
- Use `camFromKeys(keys, f, {kicks})`: smootherstep glides of 18–45 frames, easeOut for reveals and whips, and `path` via-points (Catmull-Rom) for curves.
- Every hold creeps; nothing is static for 4+ frames.
- Drama gets a 3–5° roll; impacts get a 7-frame flip-shake via `kicks`.
- Prefer continuous moves (pull-back, rack focus, crane, push-in). Hard-cut only on place or time jumps, with a flash.

**Characters:**
- They never freeze: apply `idle(f, seed)` to every card, `blinkAt` for blinks, and head bobs on stressed words.
- Actions follow anticipation → overshoot → spring settle (`M.anticip`, `M.back`, `M.spring`). A stamp is a 2-frame dip + dust puff + kick. A laugh is an alternating tilt + bob.
- Walks: `walk()` gives distance plus step phase. Keep feet planted with a 3–7 % bob.

**Secondary motion** is always present: cloth, leaves, dust, drips, Zzz, water.

**Lens:** depth of field on close-ups and mediums (cInf 8–14 px), focused on the eyes. Wides stay sharp. Racks take ~14 frames.

### 4.6 Look check (MANDATORY before the full render)
Run `./short.sh stills "5,40,90,..." a`, picking the middle of each shot plus the transitions and key actions. It writes `stills/sheet_a.jpg` with frame labels. Open it and fix every trap:
- [ ] **Framing:** half-width = d·tan(hfov/2), where hfov = 2·atan(tan(vfov/2)·0.5625). At 4 m and fov 40 that's only ±0.8 m, so stage characters in DEPTH.
- [ ] **Obstructions:** no rails or posts across faces; the camera is not inside rails, houses, roofs or bushes.
- [ ] **Clearance:** no foreground prop closer than ~2 m; the hero is never hidden behind a pillar.
- [ ] **Text and parts:** text is not mirrored; detached-part cards are offset correctly.
- [ ] **Extrude groups:** 0 = caps, 1 = sides + top.
- [ ] **Ink:** present everywhere. If not, debug with `HASH=#e` (edges only) and `HASH=#nd` (normal/depth). Ink radius is ~2.5 px at 1080; the sky counts as far depth, not a card.
- [ ] **Phone size:** faces still read with the sheet viewed at 25 %.

Send the sheet to the user with a one-line-per-shot summary, then start the full render without waiting.

### 4.7 Sound: `./short.sh sound`
- Lock picture timing first. Any timing change means re-running sound.
- `audio.py` holds ONLY the cue table. The synths live in `synth.py`:
  - **Music:** `march`, `drone`, PROG_MINOR/PROG_MAJOR, pluck, brass, drum.
  - **SFX:** whoosh, thunk, rumble, crash, scrape, ting, sting, creak, snap, splash, snore, leaves, water, cuckoo, pop, boing, footstep/steps, wind, crowd.
- Music stops on the twist line (`march(..., end=TWIST)`), then `drone` continues to the end.
- Save the SFX stem with `crest_db=14`. This tames transients so the SFX can sit near 50 % under the peak cap.
- `mix.py` prints the levels. Confirm music shows −6.0 dB vs the voice (OK) and SFX at or below it (OK). Never hand-adjust; fix the stems instead.

### 4.8 Render + finish
- Render with `WORKERS=2 ./short.sh render` using Bash `run_in_background`. Check `./short.sh progress` (done, s/frame, ETA) from a Monitor loop.
- Frames are written atomically. After an interruption, use `RESUME=1 WORKERS=2 ./short.sh render`.
- Use WORKERS=1 on machines with 4 cores or fewer. Don't run heavy Python alongside.
- Then run `./short.sh finish "Title"`:
  - It checks the frames are complete and contiguous.
  - It applies ONE measured linear gain to −14 LUFS plus a −1 dBFS limiter, and encodes H.264 CRF 17 + AAC.
  - QA covers size, duration vs voice, freeze/black frames, loudness and mix levels. It writes `out/qa.txt` and `out/qa_sheet.jpg` and exits 1 on any FAIL.

### 4.9 Definition of done
- [ ] Duration = voice duration (±1 frame); 1080x1920; 30 fps
- [ ] No frozen span ≥ 0.4 s and no black frames
- [ ] ≈ −14 LUFS, true peak ≤ −1 dBFS
- [ ] Music −6.0 dB vs voice; SFX at or below it
- [ ] Voice untouched; QA sheet viewed; no mirrored text or missing ink

### 4.10 Deliver
- Send the MP4 with SendUserFile, with one line per shot describing what it shows.
- Add a Shorts title (≤ 60 characters), a one-sentence description and 3 hashtags.
- Offer captions, tweaks, or the next idea from the list.

## Troubleshooting
| Symptom | Fix |
|---|---|
| Render says "page failed to load" | `./short.sh doctor`; usually a missing `web/lib/three.module.js` or a JS error in story.js (see the ERR lines) |
| Very slow (>8 s/frame/worker) | Lower WORKERS; reduce DOF on wides (cinf 0); RT samples 4→2 in main.js |
| Characters cut off at the edges | Re-check the framing math in §4.6; stage in depth |
| No ink on cards | Expected: cards are never world-inked; their outline is drawn on the card |
| Mirrored text | Flip the UV u, or rotate the mesh 180° on Y |
| Phrases land in the wrong gaps | Check `work/phrases.json` against the waveform; hand-fix; re-run sound |
| SFX far below −6 dB | Very peaky cues; raise their cue gains less, or use `crest_db=12` |
| `finish` FAIL: missing frames | `RESUME=1 ./short.sh render`, then finish again |

## Engine gotchas (keep if rebuilding)
- `#include <fog_vertex>` / `<fog_fragment>` go on their own lines.
- The final pass writes `linearToOutputTexel(...)` (render targets are linear HalfFloat).
- The normal+depth pass swaps materials per mesh:
  - world → normal/depth
  - cards → alpha-tested mask (rgb 0, a = depth)
  - blobs/clouds/sky → hidden
  - water → flat normal

  Fog and shadows are OFF during this pass.
- Ink goes only on the near side of depth jumps. Creases come from the normal dot. Card neighbours are skipped. Ink fades from ~140 to 520 m.
- DOF: 48 taps with a per-sample CoC test (no foreground bleed).
- The sun comes from az/el per light preset. The shadow camera is centred on each shot's action (`C.shadowAt` or the look point).

## Kit map
```
kit/engine/    main.js (renderer, world, cards, passes), paint.js (textures), roman.js (cast), motion.js, index.html
kit/tools/     setup.sh, short.sh, timing.py, render.mjs, castsheet.mjs, sheet.py, synth.py, mix.py, finish.sh
kit/example/   soldier/ story.js, audio.py, stills.jpg — the worked example
kit/vendor/    three.module.js (three.js r160, MIT), toon.ts (Pen library, MIT, github.com/mromidev/claude-animated-shorts)
```
