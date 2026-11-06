import { div, image, svg } from "gpui-kit";

// Pixel art for the office: sprites are rows of palette letters, "." is see-through.
export const PX = "PxPlus IBM VGA 8x16";
export const ink = "#3b2a1c";
export const WALL = 150;

export const r = (x, y, w, h, c) => div().absolute().left(x).top(y).w(w).h(h).bg(c);
export const icon = (p, s = 16) => p?.icon ? (p.tint ? svg(p.icon).text_color(p.color ?? ink) : image(p.icon)).size(s) : div().size(s);
export const txt = (s, size = 16, c = ink) => div().font_family(PX).text_size(size).line_height(`${size}px`).text_color(c).child(s);

export const hash = (s) => { let h = 2166136261; for (let i = 0; i < s.length; i++) h = Math.imul(h ^ s.charCodeAt(i), 16777619); return h >>> 0; };
export const rng = (seed) => () => {
  seed = (seed + 0x6d2b79f5) | 0;
  let t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
  t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
  return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
};
export const pick = (R, list) => list[Math.floor(R() * list.length)];

// One div per horizontal run of a colour.
export function sprite(rows, pal, s) {
  const out = [];
  rows.forEach((row, y) => {
    for (let x = 0; x < row.length;) {
      let e = x;
      while (e < row.length && row[e] === row[x]) e++;
      if (pal[row[x]]) out.push(r(x * s, y * s, (e - x) * s, s, pal[row[x]]));
      x = e;
    }
  });
  return div().relative().w(rows[0].length * s).h(rows.length * s).children(out);
}

// ---- people ---------------------------------------------------------------

export const HAIR = ["#3a2618", "#c98b3c", "#151515", "#8a3b1f", "#e6c76a", "#5b5b66", "#d8d8d8", "#6b2fa0"];
export const SKIN = ["#f1c9a5", "#e0ac84", "#c68a5e", "#9a6440", "#6e4429", "#f5d7c0"];
export const SHIRT = ["#4f7dc9", "#c9504f", "#5aa064", "#d79a3a", "#8a62b8", "#3f9aa6", "#e07a9a", "#7a8a3a"];
export const STYLES = ["short", "long", "bun", "bald", "spiky"];
const KIND = { claude: "#d97757", codex: "#2f3640", gemini: "#4f7dc9", opencode: "#8a62b8", pi: "#e58fb6", grok: "#5b5b66", hermes: "#d79a3a", cursor: "#3f9aa6", copilot: "#24292f" };

// Everything random about a worker, fixed by their address so they look the same every render.
export function look(a) {
  const R = rng(hash(a.address));
  const kind = `${a.app ?? ""} ${a.program?.name ?? ""}`.toLowerCase();
  const shirt = Object.entries(KIND).find(([k]) => kind.includes(k))?.[1];
  return {
    hair: pick(R, HAIR), skin: pick(R, SKIN), style: pick(R, STYLES), glasses: R() < 0.3,
    shirt: shirt ?? pick(R, SHIRT), bob: 280 + Math.floor(R() * 220), book: pick(R, ["#7a2f2f", "#2f5a7a", "#3f6b3a", "#8a6a2a"]),
  };
}

const BACK = {
  short: ["................", ".....HHHHHH.....", "....HHHHHHHH....", "...HHHHHHHHHH...", "...HHHHHHHHHH...", "...SHHHHHHHHS...", "....HHHHHHHH....", ".....SSSSSS....."],
  long: ["................", ".....HHHHHH.....", "....HHHHHHHH....", "...HHHHHHHHHH...", "...HHHHHHHHHH...", "...HHHHHHHHHH...", "...HHHHHHHHHH...", "....HHHHHHHH...."],
  bun: ["......HHHH......", ".....HHHHHH.....", "....HHHHHHHH....", "...HHHHHHHHHH...", "...HHHHHHHHHH...", "...SHHHHHHHHS...", "....HHHHHHHH....", ".....SSSSSS....."],
  bald: ["................", ".....SSSSSS.....", "....SSSSSSSS....", "...SSSSSSSSSS...", "...HSSSSSSSSH...", "...SHHHHHHHHS...", "....HHHHHHHH....", ".....SSSSSS....."],
  spiky: ["....H.H.H.H.....", "....HHHHHHHH....", "...HHHHHHHHHH...", "...HHHHHHHHHH...", "...HHHHHHHHHH...", "...SHHHHHHHHS...", "....HHHHHHHH....", ".....SSSSSS....."],
};
const SEATED = ["..TTTTTTTTTTTT..", ".TTTTTTTTTTTTTT.", ".TTccccccccccTT.", ".STCCCCCCCCCCTS.", "..SCCCCCCCCCCS..", "...CCCCCCCCCC...", "...CCCCCCCCCC...", "...CCCCCCCCCC...", "...CCCCCCCCCC...", ".......KK.......", ".......KK.......", "....KKKKKKKK...."];
const FRONT = {
  short: ["...HHHHHH...", "..HHHHHHHH..", "..HSSSSSSH..", "..SSESSESS..", "..SSSSSSSS..", "...SSmmSS...", "....SSSS...."],
  long: ["...HHHHHH...", "..HHHHHHHH..", "..HSSSSSSH..", "..HSESSESH..", "..HSSSSSSH..", "..HSSmmSSH..", "..H.SSSS.H.."],
  bun: ["....HHHH....", "...HHHHHH...", "..HSSSSSSH..", "..SSESSESS..", "..SSSSSSSS..", "...SSmmSS...", "....SSSS...."],
  bald: ["...SSSSSS...", "..SSSSSSSS..", "..HSSSSSSH..", "..SSESSESS..", "..SSSSSSSS..", "...SSmmSS...", "....SSSS...."],
  spiky: ["..H.H.H.H...", "..HHHHHHHH..", "..HSSSSSSH..", "..SSESSESS..", "..SSSSSSSS..", "...SSmmSS...", "....SSSS...."],
};
const STAND = [".TTTTTTTTTT.", "TTTTTTTTTTTT", "STTTTTTTTTTS", "STTTTTTTTTTS", "S.TTTTTTTT.S", "..PPPPPPPP.."];

const palette = (lk) => ({ H: lk.hair, S: lk.skin, E: "#1b1b1b", m: "#a0522d", G: "#222222", T: lk.shirt, C: "#3d4454", c: "#525b6e", K: "#2b2f3a", P: "#3b4252" });

// Seated at the desk, seen from behind. 16×20 art pixels.
export function seated(lk, s, sleeping) {
  const pal = palette(lk);
  return div().relative().w(16 * s).h(20 * s)
    .child(sprite(SEATED, pal, s).absolute().left(0).top(8 * s))
    .child(sprite(BACK[lk.style], pal, s).absolute().left(0).top(sleeping ? 3 * s : 0));
}

// Standing, facing you ("front") or the wall ("back"), legs swinging while walking. 16×17.
export function standing(lk, s, facing, walking, item, id) {
  const pal = palette(lk);
  let head = facing === "front" ? FRONT[lk.style] : BACK[lk.style].map((row) => row.slice(2, 14));
  if (facing === "front" && lk.glasses) head = head.map((row, i) => (i === 3 ? row.slice(0, 2) + "SGEGGEGS" + row.slice(10) : row));
  const leg = (x, from, to) => {
    const el = r(2 * s + x * s, 13 * s, 2 * s, 4 * s, "#2b2f3a").id(`${id}-leg${x}`);
    return walking ? el.loop("height", { from: from * s, to: to * s, period: 360, easing: "linear" }) : el;
  };
  return div().relative().w(16 * s).h(17 * s)
    .child(leg(3, 4, 2)).child(leg(7, 2, 4))
    .child(sprite(STAND, pal, s).absolute().left(2 * s).top(7 * s))
    .child(sprite(head, pal, s).absolute().left(2 * s).top(0))
    .when(item === "cup", (e) => e.child(r(13 * s, 9 * s, 2 * s, 3 * s, "#f4f4f0")))
    .when(item === "book", (e) => e.child(r(12 * s, 8 * s, 3 * s, 4 * s, lk.book)));
}

const CAT = [".......O.O", ".......OOO", "O......OEO", "O..OOOOOOO", ".OOOOOOOO.", "..OOOOOOO.", "..O.O..O.O"];
export const CATS = ["#e0913a", "#5b5b66", "#2a2a2a", "#f4f0e6", "#a0704a"];
export const cat = (coat, s, left) => sprite(left ? CAT.map((row) => [...row].reverse().join("")) : CAT, { O: coat, E: "#7bd389" }, s);

// ---- the room -------------------------------------------------------------

function shelf(x, R) {
  const books = ["#7a2f2f", "#2f5a7a", "#3f6b3a", "#8a6a2a", "#5a3a7a", "#2f2f2f", "#a14a2a", "#c9a23a"];
  return r(x, 30, 70, 110, "#9c6436").border(3).border_color("#6b3f1f")
    .children([8, 38].map((y) => r(4, y, 56, 3, "#6b3f1f")))
    .children([0, 1].flatMap((row) => Array.from({ length: 7 }, (_, i) => {
      const tall = 16 + Math.floor(R() * 7);
      return R() < 0.12 ? null : r(5 + i * 8, row * 30 + 30 - tall + 6, 6, tall, pick(R, books));
    }).filter(Boolean)))
    .child(r(4, 70, 26, 30, "#b77a45").border(2).border_color("#6b3f1f"))
    .child(r(34, 70, 26, 30, "#b77a45").border(2).border_color("#6b3f1f"));
}

function clock(x, y, now) {
  // 48px face with hour marks; long black minute hand, short red hour hand.
  const face = r(x, y, 48, 48, "#f4f4f0").border(3).border_color("#5a5a66");
  const c = 19, marks = Array.from({ length: 12 }, (_, i) => {
    const a = (i / 12) * 2 * Math.PI, big = i % 3 === 0, d = big ? 16 : 17, sz = big ? 4 : 2;
    return r(c + 1 + Math.round(Math.sin(a) * d) - sz / 2, c + 1 - Math.round(Math.cos(a) * d) - sz / 2, sz, sz, big ? "#333" : "#9a9aa6");
  });
  const hand = (turns, len, sz, col) => Array.from({ length: len }, (_, i) => {
    const a = turns * 2 * Math.PI;
    return r(c + Math.round(Math.sin(a) * (i + 1)), c + -Math.round(Math.cos(a) * (i + 1)), sz, sz, col);
  });
  const m = now.getMinutes(), h = (now.getHours() % 12) + m / 60;
  return face.children(marks).children(hand(h / 12, 9, 3, "#a8322a")).children(hand(m / 60, 14, 2, "#222")).child(r(c - 1, c - 1, 4, 4, "#222"));
}

function window_(x, hour) {
  const night = hour >= 19 || hour < 6, dusk = hour >= 17 && hour < 19;
  const sky = night ? "#1d2547" : dusk ? "#f2a65a" : "#8fd0f5";
  const el = r(x, 26, 90, 76, "#f4f4f0").border(4).border_color("#6b3f1f").child(r(2, 2, 78, 64, sky));
  if (dusk) el.child(r(2, 40, 78, 26, "#e0705a")).child(r(52, 30, 14, 10, "#ffd86a"));
  else if (night) el.child(r(56, 10, 10, 10, "#f4f0c8")).children([[12, 14], [30, 8], [22, 40], [44, 30], [66, 48]].map(([a, b]) => r(a, b, 2, 2, "#f4f0c8")));
  else el.child(r(10, 14, 26, 8, "#ffffff")).child(r(16, 10, 14, 6, "#ffffff")).child(r(52, 34, 20, 6, "#ffffff"));
  return el.child(r(40, 2, 4, 64, "#f4f4f0")).child(r(2, 32, 78, 4, "#f4f4f0"));
}

export function room(w, h, { seed, now, doorOpen }) {
  const R = rng(seed);
  const planks = [];
  for (let y = WALL + 14, row = 0; y < h; y += 22, row++) {
    planks.push(r(0, y, w, 2, "#c98a4f"));
    const off = Math.floor(R() * 80);
    for (let x = off - 80; x < w; x += 80) planks.push(r(x, y - 20, 2, 20, "#c98a4f"));
  }
  // a few knots and scuffs on the floor
  const knots = Array.from({ length: Math.floor(w * (h - WALL) / 40000) }, () => r(Math.floor(R() * w), WALL + 20 + Math.floor(R() * (h - WALL - 20)), 4, 2, "#cf9055"));
  const mid = Math.round(w / 2), hour = now.getHours();
  return [
    r(0, 0, w, WALL, "#c3cfe0"),
    r(0, 0, w, 6, "#9aa9bf"),
    r(0, 80, w, WALL - 80, "#8796b0"),
    r(0, 80, w, 4, "#6e7c96"),
    r(0, WALL - 10, w, 10, "#7a4a28"),
    r(0, WALL, w, h - WALL, "#e2a465"),
    ...planks, ...knots,
    // door: opens while someone arrives
    r(mid - 40, 22, 80, WALL - 22, "#6b3f1f"),
    doorOpen
      ? r(mid - 34, 28, 68, WALL - 28, "#2b1a10").child(r(0, 0, 14, WALL - 28, "#a8643a")).child(r(14, WALL - 40, 54, 12, "#c47d4a"))
      : r(mid - 34, 28, 68, WALL - 28, "#a8643a").child(r(10, 10, 48, 30, "#c47d4a").border(2).border_color("#7a4426")).child(r(56, 62, 6, 6, "#f0c860")),
    shelf(mid - 260, R), shelf(mid + 190, R),
    clock(mid - 165, 34, now),
    r(mid + 90, 36, 26, 32, "#fbfbf6").border(2).border_color("#9a9a9a").children([6, 12, 18, 24].map((y) => r(4, y, 8 + Math.floor(R() * 8), 2, "#777"))),
    window_(w - 340, hour),
    r(w - 200, 40, 50, 60, "#d9b25a").border(4).border_color("#6b3f1f")
      .child(r(0, 0, 42, 52, "#8fc6e8")).child(r(0, 28, 42, 24, "#5aa064")).child(r(18, 18, 6, 22, "#7a4a28")).child(r(12, 10, 18, 14, "#3f7a3a")),
    // water cooler
    r(w - 107, 56, 30, 34, "#7fb8e8").border(3).border_color("#4a86c0"),
    r(w - 112, 90, 40, 60, "#d8dce4").border(3).border_color("#8a90a0").child(r(10, 10, 12, 6, "#4a86c0")),
    // plant
    ...[[30, 0, 10, 60], [10, 14, 22, 12], [40, 8, 24, 12], [4, 34, 26, 12], [42, 30, 24, 12], [22, 24, 26, 10]]
      .map(([x, y, ww, hh]) => r(w - 100 + x, h - 136 + y, ww, hh, y % 2 ? "#4f8a3a" : "#3c7030")),
    r(w - 87, h - 70, 44, 36, "#b0563a").border(3).border_color("#7a3020"),
  ];
}

// ---- desks ----------------------------------------------------------------

export const SLOT_W = 170, SLOT_H = 190;
// Each space (project) gets a rug under its desks.
export const RUGS = [["#7d93b8", "#5c7298"], ["#8fae7c", "#6a8a58"], ["#c08a94", "#9a6470"], ["#9a88bd", "#76649a"], ["#6fa8a8", "#4f8686"], ["#b89a6a", "#94764a"]];

export const SCREEN = { working: "#1f4d3a", blocked: "#a8322a", done: "#24406e", idle: "#36404c", unknown: "#36404c" };

// Desk clutter, fixed per desk.
export function deskLook(i, seed) {
  const R = rng(hash(`desk${i}`) ^ seed);
  return {
    mug: pick(R, ["#c94a3a", "#f4f4f0", "#4a86c0", "#e6c76a", "#5aa064"]),
    lamp: pick(R, ["#2f6b4f", "#a8322a", "#2f5a7a", "#d79a3a"]),
    clutter: pick(R, ["papers", "plant", "photo", "duck", "none", "papers", "cactus"]),
    tower: R() < 0.5,
  };
}

export function clutter(kind, R2) {
  switch (kind) {
    case "papers": return [R2(124, 46, 18, 6, "#fbfbf6"), R2(126, 43, 16, 4, "#f0f0e6")];
    case "plant": return [R2(128, 42, 10, 10, "#b0563a"), R2(126, 32, 6, 10, "#4f8a3a"), R2(134, 30, 6, 12, "#3c7030")];
    case "cactus": return [R2(128, 44, 10, 8, "#d79a3a"), R2(131, 30, 4, 14, "#5aa064"), R2(127, 34, 4, 3, "#5aa064"), R2(135, 36, 4, 3, "#5aa064")];
    case "photo": return [R2(126, 36, 14, 14, "#6b3f1f"), R2(128, 38, 10, 10, "#8fc6e8"), R2(128, 44, 10, 4, "#5aa064")];
    case "duck": return [R2(128, 42, 10, 8, "#f0d040"), R2(134, 38, 6, 6, "#f0d040"), R2(140, 40, 3, 2, "#e07a2a")];
    default: return [];
  }
}
