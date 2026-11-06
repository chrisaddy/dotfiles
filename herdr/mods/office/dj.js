import { div, svg } from "gpui-kit";
import { exec, hc, notify, shared, setShared } from "herdr";
import { r, txt, sprite } from "./art.js";

// The office DJ: a booth in the bottom-left corner of the floor. With the music on he spins
// records behind the booth; with it off he sleeps in a beanbag beside it.
//
// The music is mpv (audio only, through yt-dlp) in a herdr-core terminal with no herdr.space
// label, so it never shows up as a pane or an agent. The core keeps it running across reloads
// and window closes; the terminal being alive is the only state ("is the music on"). herdr's
// terminals() leaves out terminals without herdr labels, so ask the core.
export const DJ_URL = "https://www.youtube.com/watch?v=OVEspa2yBQE";
const NAME = "office-dj";
// mpv's control socket, for changing the volume while it plays.
const SOCK = "/tmp/office-dj.sock";

// 0–100, kept in shared state so it survives restarts and the next play starts there.
export const volume = () => shared("office.dj.volume") ?? 60;

export function setVolume(v) {
  setShared("office.dj.volume", v);
  const cmd = JSON.stringify({ command: ["set_property", "volume", v] });
  return exec("/bin/sh", ["-c", `printf '%s\\n' '${cmd}' | nc -U -w 1 ${SOCK}`]).catch(() => null);
}

export async function playing() {
  const res = await hc(["get", NAME, "--json"]).catch(() => null);
  try { return res?.code === 0 && JSON.parse(res.stdout).state === "live"; } catch { return false; }
}

export async function toggleMusic(on) {
  if (on) return hc(["kill", NAME]);
  // Through a login shell, so mpv and yt-dlp come from the Nix profile whatever PATH the core has.
  const tools = await exec("/bin/zsh", ["-lc", "command -v mpv && command -v yt-dlp"]).catch(() => ({ code: 1 }));
  if (tools.code !== 0) {
    notify({ title: "The DJ has no decks", body: "mpv and yt-dlp aren't installed: run home-manager switch.", level: "warning" });
    return;
  }
  // --rm: if the stream dies, the terminal goes and the DJ goes back to sleep on his own.
  return hc(["run", "--bg", "--no-parent", "--rm", "--name", NAME, "--label", "office.dj=1", "--",
    "/bin/zsh", "-lc", `exec mpv --no-video --really-quiet --loop-playlist=inf --volume=${volume()} --input-ipc-server=${SOCK} '${DJ_URL}'`]);
}

const PAL = { H: "#151515", S: "#c68a5e", E: "#1b1b1b", T: "#3f9aa6", P: "#e05a8a", K: "#2b2f3a", m: "#a0522d" };

// Standing behind the decks, headphones on. 16×10: only head and shoulders clear the booth.
const STANDING = [
  "....PPPPPPPP....",
  "...PHHHHHHHHP...",
  "..PPHSSSSSSHPP..",
  "..PPSSESSESSPP..",
  "....SSSSSSSS....",
  ".....SSmmSS.....",
  "......SSSS......",
  "...TTTTTTTTTT...",
  "..TTTTTTTTTTTT..",
  "..TTTTTTTTTTTT..",
];

// Asleep on his back, head on the left, headphones round his neck. 22×6.
const ASLEEP = [
  ".HHHH.................",
  "HHHHHH................",
  "HSSSSHPPTTTTTTTT......",
  "SEESSSPPTTTTTTTTKKKKKK",
  ".SSSS..TTTTTTTTTKKKKKK",
  "........SS........KKKK",
];

// A beanbag: an ellipse with its bottom cut flat, lit from the top left.
function beanbag(w, h) {
  const cy = h * 0.56;
  return Array.from({ length: h }, (_, y) => Array.from({ length: w }, (_, x) => {
    const nx = (x + 0.5 - w / 2) / (w / 2), ny = (y + 0.5 - cy) / cy;
    if (nx * nx + ny * ny > 1) return ".";
    if (nx < -0.15 && ny < -0.25 && nx * nx + ny * ny < 0.5) return "h";
    return ny > 0.4 ? "b" : "B";
  }).join(""));
}
const BAG = beanbag(26, 17);
const BAG_PAL = { B: "#8a62b8", b: "#6a4a94", h: "#a888d4" };

function record(x, y, s, on) {
  const d = 12 * s;
  return div().absolute().left(x).top(y).w(d).h(d).rounded_full().bg("#1b1b1b")
    .child(svg("mods/office/record.svg").absolute().left(0).top(0).size(d).text_color("#c8ccd6")
      .when(on, (e) => e.id(`rec-${x}`).spin(1800)))
    .child(r(4 * s, 4 * s, 4 * s, 4 * s, on ? "#e0c040" : "#c08ae0").rounded_full())
    .child(r(5.5 * s, 5.5 * s, s, s, "#1b1b1b"));
}

// The whole corner, about `scale` px per art pixel, its bottom-left at (x, bottom). Art pixels
// are whole screen pixels: a fractional size anti-aliases each run's edges into seams.
export function djCorner(x, bottom, scale, on, onClick) {
  const s = Math.max(1, Math.round(scale));
  x = Math.round(x); bottom = Math.round(bottom);
  const bw = 44 * s, bh = 21 * s, by = bottom - bh;
  const bagX = x + bw + 6 * s, bagY = bottom - BAG.length * s;
  const lights = ["#e05a8a", "#5ab0e0", "#e0c040", "#7ee0a0", "#c08ae0", "#f08a4a"];
  const el = div().id("dj").absolute().left(0).top(0);
  const hit = div().id("dj-hit").cursor_pointer().absolute().left(x).top(by - 14 * s).w(bw + 32 * s).h(30 * s)
    .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
    .on_click((_e, cx) => onClick(cx));

  // Behind the booth: the DJ nodding along, one hand working the left record.
  if (on) el.child(div().absolute().left(x + 14 * s).top(by - 10 * s).id("dj-nod")
    .loop("top", { from: by - 10 * s, to: by - 9 * s, period: 900 })
    .child(sprite(STANDING, PAL, s)));
  // The booth.
  el.child(r(x, by, bw, 3 * s, "#2b2f3a"))
    .child(r(x + s, by + 3 * s, bw - 2 * s, bh - 3 * s, "#3a3f4a"))
    .child(r(x + 18 * s, by - 2 * s, 8 * s, 3 * s, "#555b68")
      .children([1, 3, 5].map((k) => r(k * s, s, s, s, on ? "#7ee0a0" : "#777"))))
    .child(record(x + 3 * s, by - 7 * s, s, on))
    .child(record(x + 29 * s, by - 7 * s, s, on))
    .children(lights.map((c, i) => {
      const light = r(x + (4 + i * 6) * s, by + 5 * s, 3 * s, 2 * s, on ? c : "#4a4f5a");
      return on ? light.id(`dj-light-${i}`).loop("opacity", { from: 0.25, to: 1, period: 500 + i * 130 }) : light;
    }))
    .child(div().absolute().left(x + s).top(by + 9 * s).w(bw - 2 * s).flex().justify_center()
      .child(txt(on ? "ON AIR" : "OFF AIR", Math.max(8, 4 * s), on ? "#ff8a8a" : "#8a8f9c")));
  if (on) el.child(r(x + 9 * s, by - 3 * s, 3 * s, 2 * s, PAL.S).id("dj-scratch")
    .loop("left", { from: x + 7 * s, to: x + 10 * s, period: 600 }));

  // The beanbag, with him asleep in it when the music's off.
  el.child(sprite(BAG, BAG_PAL, s).absolute().left(bagX).top(bagY));
  if (!on) el.child(div().absolute().left(bagX + 2 * s).top(bagY + 2 * s).id("dj-breathe")
    .loop("top", { from: bagY + 2 * s, to: bagY + s, period: 2400 })
    .child(sprite(ASLEEP, PAL, s)))
    .child(txt("z", Math.max(10, 5 * s), "#24406e").absolute().left(bagX + 4 * s).top(bagY - 6 * s)
      .id("dj-z").frames(["z", "zZ", "zZz", ""], 700));

  // Notes drifting up while it plays.
  if (on) el.children(["♪", "♫", "♪"].map((n, i) => txt(n, Math.max(10, 5 * s), ["#e05a8a", "#5ab0e0", "#e0c040"][i])
    .absolute().left(x + (8 + i * 12) * s).id(`dj-note-${i}`)
    .loop("top", { from: by - 12 * s, to: by - 30 * s, period: 2600 + i * 700 })));

  return el.child(hit).child(fader(x + 3 * s, by + 15 * s, bw - 6 * s, s, on));
}

// The volume fader along the bottom of the booth: ten steps, click one to set it. It sits
// below the click area that toggles the music, so it gets its own clicks.
function fader(x, y, w, s, on) {
  const v = Math.round(volume() / 10), label = 9 * s, cw = Math.floor((w - label) / 10);
  return div().absolute().left(x).top(y).w(w).h(4 * s)
    .child(div().absolute().left(0).top(0).child(txt("VOL", Math.max(8, 3.5 * s), "#8a8f9c")))
    .children(Array.from({ length: 10 }, (_, i) => {
      const lit = i < v, c = i >= 8 ? "#e05a5a" : i >= 6 ? "#e0c040" : "#7ee0a0";
      return div().id(`dj-vol-${i}`).absolute().left(label + i * cw).top(0).w(cw).h(4 * s).cursor_pointer()
        .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
        .on_click(() => setVolume((i + 1) * 10))
        .child(r(Math.max(1, s / 2), s, cw - s, 2 * s, lit ? (on ? c : "#6a7080") : "#2b2f3a")
          .when(i === v - 1, (e) => e.child(r(cw / 2 - s, -s, 2 * s, 4 * s, "#e7e9ee"))));
    }));
}
