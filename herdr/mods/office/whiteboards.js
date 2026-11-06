import { div } from "gpui-kit";
import { exec, home, readTextFile } from "herdr";
import { r, txt, hash, rng, pick, ink } from "./art.js";

// Whiteboards on the right-hand wall, one per artifact we've published. The list is
// ~/.config/herdr-app/office-artifacts.json ([{ title, url, at }], oldest first), appended to by
// the `office-artifact` Claude Code hook. Newest board hangs on the right; clicking one opens it.
export const ARTIFACTS = "/.config/herdr-app/office-artifacts.json";

export async function loadArtifacts() {
  try {
    const list = JSON.parse(await readTextFile(home() + ARTIFACTS));
    return Array.isArray(list) ? list.filter((a) => a?.url) : [];
  } catch { return []; }
}

const MARKERS = ["#2f5a7a", "#a8322a", "#3f6b3a", "#2b2f3a"];
const BW = 64, BH = 52, GAP = 10;

function board(a, x, fresh, onHover) {
  const R = rng(hash(a.url)), title = (a.title || "untitled").slice(0, 22);
  // A few lines of marker scribble under the title, fixed by the artifact's url.
  const lines = Array.from({ length: 3 }, (_, i) => r(6, 22 + i * 7, 14 + Math.floor(R() * 34), 2, pick(R, MARKERS)));
  return div().id(`wb-${hash(a.url)}`).absolute().left(x).top(28).w(BW).h(BH + 6).cursor_pointer()
    .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
    .on_click(() => exec("open", [a.url]))
    .on_hover((hov, cx) => onHover(hov ? a : null, cx))
    .child(r(0, 0, BW, BH, "#f8f8f4").border(3).border_color("#9aa0ac")
      .child(div().absolute().left(5).top(5).w(BW - 16).overflow_hidden().child(txt(title, 8, ink).truncate()))
      .children(lines)
      .when(fresh, (e) => e.child(r(BW - 18, 4, 10, 10, "#e0c040").id(`wb-new-${hash(a.url)}`)
        .loop("opacity", { from: 0.3, to: 1, period: 900 }))))
    // the marker tray
    .child(r(6, BH, BW - 12, 4, "#7a808c")).child(r(10, BH - 2, 8, 2, pick(R, MARKERS)));
}

// Boards fill the wall from `right` leftwards to `left`; older ones that don't fit are counted.
export function whiteboards(list, left, right, hovered, onHover) {
  const fit = Math.max(0, Math.floor((right - left + GAP) / (BW + GAP)));
  const shown = list.slice(-fit).reverse(), hidden = list.length - shown.length, now = Date.now();
  const el = div().absolute().left(0).top(0)
    .children(shown.map((a, i) => board(a, right - BW - i * (BW + GAP), now - (a.at ?? 0) * 1000 < 3600_000, onHover)));
  if (hidden > 0 && shown.length) el.child(txt(`+${hidden}`, 12, "#3b4252").absolute().left(right - shown.length * (BW + GAP) - 22).top(48));
  if (hovered) {
    const i = shown.findIndex((a) => a.url === hovered.url);
    if (i >= 0) el.child(div().absolute().left(Math.max(4, right - BW - i * (BW + GAP) - 60)).top(28 + BH + 10).w(200).p(6)
      .bg("#fff27a").border(2).border_color("#d8c440")
      .child(txt(hovered.title || "untitled", 12, ink).truncate())
      .child(txt("click to open", 10, "#6b5a4a")));
  }
  return el;
}
