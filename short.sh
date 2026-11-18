#!/usr/bin/env bash
# One entry point for every step. Run inside the project folder.
#   ./short.sh doctor                 check the machine (node, ffmpeg, python, chromium, webgl)
#   ./short.sh timing                 voice.mp3 + script.txt -> work/phrases.json
#   ./short.sh cast [outfits]         character test sheet -> stills/cast_sheet.png
#   ./short.sh stills "5,40,90" [a]   render stills + contact sheet -> stills/sheet_<a>.jpg
#   ./short.sh sound                  audio.py -> stems, mix.py -> mix_raw.wav (prints levels)
#   ./short.sh render                 all frames (background-safe; RESUME=1 to continue; WORKERS=n)
#   ./short.sh finish "Title"         encode + loudness + QA -> out/<Title>.mp4
#   ./short.sh progress               show render progress
set -uo pipefail
cd "$(dirname "$0")"
cmd="${1:-help}"; shift || true
N() { python3 -c "import json;print(json.load(open('work/phrases.json'))['frames30'])"; }
case "$cmd" in
  doctor)
    for c in node ffmpeg ffprobe python3; do command -v $c >/dev/null && echo "ok   $c" || echo "MISS $c"; done
    python3 -c "import numpy,PIL;print('ok   numpy + Pillow')" 2>/dev/null || echo "MISS numpy/Pillow"
    python3 -c "import faster_whisper;print('ok   faster-whisper (word timestamps)')" 2>/dev/null || echo "info no whisper: timing uses script + silence alignment (needs script.txt)"
    ffmpeg -hide_banner -filters 2>/dev/null | grep -w alimiter >/dev/null && echo "ok   ffmpeg alimiter/ebur128" || echo "MISS ffmpeg alimiter"
    ffmpeg -hide_banner -encoders 2>/dev/null | grep -w libx264 >/dev/null && echo "ok   libx264" || echo "MISS libx264"
    [ -s web/lib/three.module.js ] && echo "ok   three.js" || echo "MISS web/lib/three.module.js (re-run setup.sh with network)"
    node -e "
      const {chromium}=require('playwright');(async()=>{const b=await chromium.launch({args:['--use-angle=swiftshader','--enable-unsafe-swiftshader','--ignore-gpu-blocklist']});
      const p=await b.newPage();const ok=await p.evaluate(()=>!!document.createElement('canvas').getContext('webgl2'));console.log(ok?'ok   chromium + WebGL2 (CPU)':'MISS WebGL2 in chromium');await b.close();})().catch(e=>console.log('MISS chromium: '+e.message.split('\n')[0]))" ;;
  timing)  python3 timing.py voice.mp3 script.txt --out work ;;
  cast)    node castsheet.mjs stills/cast_sheet.png "${1:-}" ;;
  stills)  L="${2:-a}"; node render.mjs "stills/$L" "${1:?frames, e.g. \"5,40,90\"}" && python3 sheet.py "stills/$L" "stills/sheet_$L.jpg" ;;
  sound)   python3 audio.py && python3 mix.py voice.mp3 music.wav sfx.wav ;;
  render)  node render.mjs frames "0-$(( $(N) - 1 ))" 2>&1 | tee work/render.log ;;
  progress) cat frames/progress.json 2>/dev/null && echo || echo "no render running"; tail -2 work/render.log 2>/dev/null ;;
  finish)  bash finish.sh "${1:-short}" ;;
  *) sed -n '2,11p' "$0" ;;
esac
