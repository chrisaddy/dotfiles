import { View, div } from "gpui-kit";
import { h_flex, v_flex } from "gpui-base";
import { agents, spaces, panes, props, run, setAgentOrder, knownAgents } from "herdr";
import { ink, WALL, SLOT_W, SLOT_H, SCREEN, CATS, RUGS, r, icon, txt, hash, rng, pick, look, deskLook, clutter, seated, standing, cat, heart, catCorner, catFlap, room } from "./art.js";
import { djCorner, playing, toggleMusic } from "./dj.js";
import { whiteboards, loadArtifacts } from "./whiteboards.js";

// A pixel-art office: every agent is a little worker at a desk, and each space gets its own
// group of desks on a rug. Idle workers wander, and everyone (the cat too) keeps to the walkways:
// the corridor along the wall, the aisle behind each row of desks, and the lanes past both ends
// of the rows and between the groups.
const wood = "#8a5530";
const DEMO = [["working", "fix login"], ["blocked", "migrate db"], ["done", "write tests"], ["idle", "docs"], ["working", "refactor api"], ["idle", "triage"], ["idle", "lunch"], ["done", "ship it"], ["working", "perf pass"], ["idle", "standup"], ["blocked", "deploy"], ["idle", "coffee"]]
  .map(([status, tab_name], i) => {
    const space_name = i < 5 ? "web" : i < 9 ? "api" : "infra";
    return { address: `demo${i}`, status, tab_name, space: space_name, space_name, title: "", program: null, focused: i === 0 };
  });
// Everyone at work: the agents, plus panes running an agent that reports no status (Claude
// Code without Herdr's status hook). Herdr names the program from what runs in the pane, which
// misses Claude started under a wrapper (`devenv shell`), so Claude's title counts too: it puts
// ✳ there while idle and a spinner (◐◓◑◒ or braille) while it works.
const CLAUDE_IDLE = /^✳/, CLAUDE_BUSY = /^[◐◓◑◒\u2800-\u28ff]/;
function workers() {
  const list = agents(), seen = new Set(list.map((a) => a.address));
  const order = [];
  for (const sp of spaces()) sp.tabs.forEach((t, ti) => order.push({ sp, t, ti }));
  for (const p of panes()) {
    if (!p.terminal || seen.has(p.terminal) || !(p.program?.agent || CLAUDE_IDLE.test(p.title) || CLAUDE_BUSY.test(p.title))) continue;
    const at = order.find((o) => o.t.id === p.tab);
    if (!at) continue;
    list.push({ address: p.terminal, pane: p.pane, space: at.sp.id, space_name: at.sp.name, tab: p.tab,
      tab_index: at.ti, tab_name: at.t.name ?? String(at.ti + 1), status: CLAUDE_BUSY.test(p.title) ? "working" : "idle",
      app: p.app, program: p.program, title: p.title, focused: p.focused, unreported: true });
  }
  // Keep space, then tab, order: the desks group by space.
  const rank = (a) => order.findIndex((o) => o.t.id === a.tab);
  return list.map((a, i) => ({ a, i })).sort((x, y) => rank(x.a) - rank(y.a) || x.i - y.i).map((x) => x.a);
}
const focusRun = (a) => run(a.unreported ? "pane.focus" : "agent.focus", { terminal: a.address });

const THOUGHTS = ["?", "!", "♪", "♥", "...", "☼", "$", "#"];
const SPOTS = ["cooler", "cooler", "shelfL", "shelfR", "window", "door", "plant", "floor", "floor", "chat", "chat"];
const WALK = 0.11, CAT_WALK = 0.07; // px per ms
const busy = (a) => a.status === "working" || a.status === "blocked";

const GAP = 60; // the walkway between two spaces' desks, in slot units
const DVD = ["#e05a8a", "#5ab0e0", "#e0c040", "#7ee0a0", "#c08ae0", "#f08a4a"];

// Two rows of desks (more only when two would get too small), one group of columns per space,
// sized to fit. The scale snaps to whole half pixels per art pixel (s), so desks and workers
// grow together and stay crisp.
function fit(groups, w, h) {
  let best;
  for (let rows = 2; rows <= 6; rows++) {
    const cols = groups.map((n) => Math.max(groups.length > 1 ? 1 : 3, Math.ceil(n / rows)));
    const units = cols.reduce((a, b) => a + b, 0) * SLOT_W + (groups.length - 1) * GAP;
    const k = Math.min(1, (w - 200) / units, (h - WALL) / (rows * SLOT_H + 40));
    if (!best || k > best.k + 0.08) best = { k, cols, rows };
  }
  const s = Math.max(1, Math.floor(best.k * 6) / 2);
  return { ...best, k: s / 3, s };
}

// The room (wall, floor, furniture) is half of everything drawn, and changes only with the size,
// the minute and the door: a retained view of its own, rebuilt only then.
class Room extends View {
  init(p) { this.p = p; }
  update(p) { this.p = p; }
  render() {
    const { w, h, seed, at, door } = this.p;
    return div().absolute().left(0).top(0).w(w).h(h).children(room(w, h, { seed, now: new Date(at), doorOpen: door }));
  }
}

export default class Office extends View {
  init(_p, cx) {
    this.size = { width: 1200, height: 420 };
    this.seed = Math.floor(Math.random() * 2 ** 31);
    this.trips = {};     // address → { phase: enter|going|there|back, path, i, until, spot, hurry }
    this.thoughts = {};  // address → { sym, until }
    this.seats = {};     // address → { x, y, row }
    this.geo = null;
    this.known = null;
    this.door = 0;
    this.hover = null;
    this.minute = -1;
    this.n = 0;
    // Cannoli and Twitch: they wander, nap in their bed, and play when they meet.
    this.cats = CATS.map((c, i) => ({ ...c, home: i ? 0.62 : 0.33, path: null, i: 0, until: 0, left: i === 1 }));
    this.play = null;    // { start, until, x, y } while the cats play
    this.playNext = 0;
    this.flap = 0;       // the cat flap swings until then
    this.catHover = null;
    this.list = [];
    if (props()?.role) return;
    this.roomView = cx.new(Room, this.roomProps());
    this.music = false;
    cx.timer.every(3000, (cx) => this.checkMusic(cx));
    this.checkMusic(cx);
    this.boards = [];
    this.boardHover = null;
    cx.timer.every(5000, (cx) => this.loadBoards(cx));
    this.loadBoards(cx);
    cx.timer.every(250, (cx) => { this.syncRoom(); if (this.tick()) cx.notify(); });
  }

  loadBoards(cx) {
    cx.spawn(async (cx) => {
      const list = await loadArtifacts(), key = JSON.stringify(list);
      if (key !== this.boardsKey) { this.boardsKey = key; this.boards = list; cx.notify(); }
    });
  }

  checkMusic(cx) {
    cx.spawn(async (cx) => {
      const on = await playing();
      if (on !== this.music) { this.music = on; cx.notify(); }
    });
  }

  roomProps() {
    const { width: w, height: h } = this.size;
    return { w, h, seed: this.seed, at: Math.floor(Date.now() / 60000) * 60000, door: this.door > Date.now() };
  }

  syncRoom() {
    const p = this.roomProps(), key = JSON.stringify(p);
    if (key !== this.roomKey) { this.roomKey = key; this.roomView.set_props(p); }
  }

  // ---- walkways -------------------------------------------------------------
  // A place is { r, x }: r = -1 is the corridor along the wall, r ≥ 0 the aisle behind desk row r.
  // A seat adds { seat: y }: one step up from its row's aisle.

  laneY(row, off = 0) { const g = this.geo; return off + (row < 0 ? g.topY : g.top + row * g.sh + Math.round(128 * g.k)); }

  // Everyone keeps to their own line in a walkway (off), so passers-by don't merge.
  path(from, to, speed = WALK, off = 0) {
    const g = this.geo, pts = [];
    const add = (x, y, row) => pts.push({ x: Math.round(x), y: Math.round(y), r: row });
    if (from.seat != null) add(from.x, this.laneY(from.r, off), from.r);
    if (from.r !== to.r) {
      const side = [...g.lanes].sort((a, b) => Math.abs(from.x - a) + Math.abs(to.x - a) - Math.abs(from.x - b) - Math.abs(to.x - b))[0];
      add(side, this.laneY(from.r, off), from.r);
      add(side, this.laneY(to.r, off), to.r);
    }
    add(to.x, this.laneY(to.r, off), to.r);
    if (to.seat != null) add(to.x, to.seat, to.r);
    let prev = { x: from.x, y: from.seat ?? this.laneY(from.r) };
    for (const p of pts) {
      p.ms = Math.max(16, Math.round(Math.hypot(p.x - prev.x, p.y - prev.y) / speed));
      p.facing = p.y > prev.y ? "front" : p.y < prev.y ? "back" : "front";
      p.left = p.x < prev.x;
      prev = p;
    }
    return pts;
  }

  off(addr) { return ((hash(addr) % 5) - 2) * Math.round(4 * this.geo.k); }

  // Someone (or the cat) is standing at, or heading for, the spot p: wait a moment.
  crowded(self, p) {
    const near = (q) => q && Math.abs(q.x - p.x) < 12 * this.geo.s && Math.abs(q.y - p.y) < 8 * this.geo.s;
    if (!self.startsWith("cat:") && this.cats.some((c) => near(c.path?.[c.i]))) return true;
    return Object.entries(this.trips).some(([addr, t]) => addr !== self && t.phase !== "enter" && near(t.path[t.i]));
  }

  seatPlace(addr) { const s = this.seats[addr]; return s && { r: s.row, x: s.x, seat: s.y }; }

  spotPlace(sp) {
    const { width: w } = this.size, g = this.geo, mid = Math.round(w / 2);
    const wall = { cooler: w - 150, shelfL: mid - 250, shelfR: mid + 200, window: w - 320, door: mid - 24 }[sp.key];
    if (wall != null) return { r: -1, x: Math.round(wall + sp.jx) };
    if (sp.key === "chat" && this.seats[sp.other]) { const o = this.seats[sp.other]; return { r: o.row, x: o.x + Math.round(30 * g.k) }; }
    if (sp.key === "plant") return { r: g.rows - 1, x: Math.max(g.rightX, w - 150) };
    return { r: Math.floor(sp.fy * (g.rows + 1)) - 1, x: Math.round(8 + sp.fx * (w - 70)) };
  }

  // Four times a second: walkers turn corners. About once a second: who gets up, thoughts, the cat.
  tick() {
    if (!this.geo) return false;
    const now = Date.now(), slow = this.n++ % 4 === 0;
    let changed = false;
    const minute = new Date().getMinutes();
    if (minute !== this.minute) { this.minute = minute; changed = true; }
    for (const a of this.list) {
      const t = this.trips[a.address];
      if (t) {
        if (busy(a) && t.phase === "there") this.headBack(a, t, t.path[t.i], now), changed = true;
        else if (busy(a) && t.phase === "going") t.hurry = true;
        if (now < t.until) continue;
        changed = true;
        if (t.i < t.path.length - 1 && !(t.hurry && t.phase === "going")) {
          if ((t.wait ?? 0) < 6 && this.crowded(a.address, t.path[t.i + 1])) { t.wait = (t.wait ?? 0) + 1; t.until = now + 250; continue; }
          t.wait = 0; t.i++; t.until = now + t.path[t.i].ms; continue;
        }
        const at = t.path[t.i];
        if (t.phase === "going" && !t.hurry) Object.assign(t, { phase: "there", until: now + 3000 + Math.random() * 8000 });
        else if (t.phase === "back") delete this.trips[a.address];
        else this.headBack(a, t, at, now);
      } else if (slow && !busy(a) && Math.random() < (a.status === "done" ? 0.015 : 0.035) * (this.demo ? 4 : 1)) {
        const others = this.list.filter((o) => o.address !== a.address && !this.trips[o.address]);
        let key = SPOTS[Math.floor(Math.random() * SPOTS.length)];
        if (key === "chat" && !others.length) key = "floor";
        const spot = { key, other: key === "chat" ? others[Math.floor(Math.random() * others.length)].address : null,
          jx: Math.random() * 30 - 15, fx: Math.random(), fy: Math.random() };
        const path = this.path(this.seatPlace(a.address), this.spotPlace(spot), WALK, this.off(a.address));
        this.trips[a.address] = { phase: "going", spot, path, i: 0, until: now + path[0].ms };
        changed = true;
      } else if (slow && !this.thoughts[a.address] && Math.random() < (busy(a) ? 0.006 : 0.025)) {
        this.thoughts[a.address] = { sym: THOUGHTS[Math.floor(Math.random() * THOUGHTS.length)], until: now + 2500 + Math.random() * 3000 };
        changed = true;
      }
    }
    for (const [k, t] of Object.entries(this.thoughts)) if (now >= t.until) { delete this.thoughts[k]; changed = true; }
    for (const c of this.cats) changed = this.moveCat(c, now) || changed;
    changed = this.catsPlay(now) || changed;
    if (this.door && now >= this.door) { this.door = 0; changed = true; }
    if (this.flap && now >= this.flap) { this.flap = 0; changed = true; }
    return changed;
  }

  headBack(a, t, at, now) {
    const path = this.path({ r: at.r, x: at.x }, this.seatPlace(a.address), WALK, this.off(a.address));
    Object.assign(t, { phase: "back", path, i: 0, until: now + path[0].ms, hurry: false });
  }

  // Where a cat is right now: partway along the leg it's walking.
  catAt(c, now) {
    const to = c.path?.[c.i];
    if (!to) return { r: -1, x: Math.round(this.size.width * c.home), y: this.geo.topY };
    const from = c.path[c.i - 1];
    if (!from || now >= c.until) return to;
    const u = 1 - (c.until - now) / to.ms;
    return { r: to.r, x: Math.round(from.x + (to.x - from.x) * u), y: Math.round(from.y + (to.y - from.y) * u) };
  }

  // The cats' corner, top right: the bed's x, where a napping cat lies.
  bedX() { return this.size.width - 6 - Math.round(14 * this.geo.s); }
  // Where a cat stands to use the flap in the front door.
  flapX() { return Math.round(this.size.width / 2) - Math.round(5 * this.geo.s); }

  moveCat(c, now) {
    const g = this.geo;
    if (now < c.until) return false;
    // Back in through the flap after a while outside.
    if (c.away) {
      Object.assign(c, { away: false, path: [{ x: this.flapX(), y: g.topY, r: -1, ms: 16 }], i: 0, resting: true, until: now + 1500 });
      this.flap = now + 900;
      return true;
    }
    if (c.path && c.i < c.path.length - 1) {
      if ((c.wait ?? 0) < 8 && this.crowded(`cat:${c.name}`, c.path[c.i + 1])) { c.wait = (c.wait ?? 0) + 1; c.until = now + 250; return false; }
      c.wait = 0; c.i++; c.until = now + c.path[c.i].ms; c.left = c.path[c.i].left; return true; }
    const at = this.catAt(c, now);
    if (c.outing && !c.resting) {
      Object.assign(c, { outing: false, away: true, until: now + 20000 + Math.random() * 40000 });
      this.flap = now + 900;
      return true;
    }
    if (c.path && !c.resting) {
      const nap = c.nap ? 15000 + Math.random() * 25000 : Math.random() < 0.4 ? 8000 + Math.random() * 15000 : 1000 + Math.random() * 3000;
      c.resting = true; c.until = now + nap; return false;
    }
    // Off again: to find the other cat, to bed, or anywhere.
    const other = this.catAt(this.cats.find((o) => o !== c), now), roll = Math.random();
    let to, off = Math.round((Math.random() * 16 - 8) * g.k), nap = false, outing = false;
    if (roll < 0.25) to = { r: other.r, x: other.x + (Math.random() < 0.5 ? -1 : 1) * Math.round(14 * g.s) };
    else if (roll < 0.45) { to = { r: -1, x: this.bedX() + Math.round(2 * g.s) }; off = 0; nap = true; }
    else if (roll < 0.52) { to = { r: -1, x: this.flapX() }; off = 0; outing = true; }
    else to = { r: Math.floor(Math.random() * (g.rows + 1)) - 1, x: Math.round(8 + Math.random() * (this.size.width - 60)) };
    to.x = Math.max(8, Math.min(this.size.width - 6 - Math.round(10 * g.s), to.x));
    c.path = this.path({ r: at.r, x: at.x }, to, CAT_WALK, off);
    Object.assign(c, { i: 0, until: now + c.path[0].ms, left: c.path[0].left, resting: false, nap, outing });
    return true;
  }

  // When the cats meet they stop, face each other and play for a few seconds, with hearts.
  catsPlay(now) {
    if (this.play) { if (now >= this.play.until) this.play = null; return true; }
    if (now < this.playNext) return false;
    const [a, b] = this.cats, s = this.geo.s, pa = this.catAt(a, now), pb = this.catAt(b, now);
    if (a.away || b.away || a.outing || b.outing) return false;
    if (Math.abs(pa.x - pb.x) > 20 * s || Math.abs(pa.y - pb.y) > 8 * s) return false;
    const until = now + 3600;
    for (const [c, at, o] of [[a, pa, pb], [b, pb, pa]])
      Object.assign(c, { path: [{ ...at, ms: 16 }], i: 0, until: until + 500 + Math.random() * 1500,
        resting: true, nap: false, wait: 0, left: o.x < at.x });
    this.play = { start: now, until, x: Math.round((pa.x + pb.x) / 2), y: Math.min(pa.y, pb.y) };
    this.playNext = until + 25000;
    return true;
  }

  // ---- drawing --------------------------------------------------------------

  desk(a, i, x, y, k, night, space) {
    const q = (v) => Math.round(v * k), R2 = (x, y, w, h, c) => r(q(x), q(y), q(w), q(h), c);
    const dl = deskLook(i, this.seed), status = a?.status;
    const lit = a && (a.focused || night);
    const el = div().absolute().left(x).top(y).w(q(SLOT_W)).h(q(130))
      .child(R2(52, 0, 66, 44, "#2b2f3a").child(a ? this.screen(a, k) : R2(6, 5, 54, 34, "#1c2028")))
      .child(R2(80, 44, 10, 6, "#2b2f3a")).child(R2(70, 50, 30, 3, "#2b2f3a"))
      .child(R2(24, 52, 122, 12, "#f0dcb0")).child(R2(24, 64, 122, 20, "#d4b27c")).child(R2(24, 64, 122, 3, "#b48a52"))
      .child(R2(28, 84, 8, 18, "#b48a52")).child(R2(134, 84, 8, 18, "#b48a52"))
      .child(R2(66, 54, 38, 6, "#e7e9ee")).child(R2(110, 44, 9, 10, dl.mug))
      // lamp
      .child(R2(30, 50, 14, 3, "#3a3a3a")).child(R2(35, 32, 3, 18, "#3a3a3a")).child(R2(28, 26, 18, 8, dl.lamp))
      .when(lit, (e) => e.child(R2(26, 34, 22, 18, "#ffe9a055")).child(R2(31, 34, 12, 3, "#fff3b0")))
      .children(clutter(dl.clutter, R2))
      .child(R2(150, 58, 16, 40, dl.tower ? "#d9dce3" : "#3a3f4a").child(R2(3, 6, 8, 2, "#555")).child(R2(5, 26, 4, 4, status === "working" ? "#5ee08a" : "#777")));
    if (status === "working") el.child(txt("~", Math.max(8, q(12)), "#ffffff99").absolute().left(q(110)).top(q(30)).id(`steam-${i}`).frames(["", "~", "≈", "~"], 450));
    if (!a) {
      el.child(R2(70, 78, 30, 26, "#3d4454")).child(R2(83, 104, 4, 8, "#2b2f3a")).child(R2(72, 112, 26, 4, "#2b2f3a"));
      if (this.demo) return el;
      return el.id(`empty-${i}`).cursor_pointer().on_mouse_down("left", (_e, cx) => cx.stop_propagation())
        .on_click((_e, cx) => cx.spawn(async () => {
          const ag = (await knownAgents()).find((x) => x.installed);
          run("tab.new", { ...(space ? { space } : {}), ...(ag ? { argv: ag.run } : {}) });
        }));
    }
    return el.id(`desk-${a.address}`).cursor_pointer()
      .on_mouse_down("left", (_e, cx) => cx.stop_propagation())
      .on_click(() => !this.demo && focusRun(a))
      .on_hover((hov, cx) => {
        // Only a real change redraws: a redraw re-reports hover, and notifying again would loop.
        const next = hov ? a.address : this.hover === a.address ? null : this.hover;
        if (next !== this.hover) { this.hover = next; cx.notify(); }
      });
  }

  label(a, x, y, k) {
    const q = (v) => Math.round(v * k);
    return h_flex().absolute().left(x).top(y + q(130)).w(q(SLOT_W)).justify_center().gap(q(6)).items_center()
      .child(icon(a.program, q(14))).child(txt(a.tab_name.slice(0, 16), Math.max(8, q(12)), a.focused ? "#fff8e1" : ink));
  }

  screen(a, k) {
    const q = (v) => Math.round(v * k);
    const s = r(q(6), q(5), q(54), q(34), SCREEN[a.status] ?? SCREEN.idle);
    if (a.status === "working")
      return s.children([0, 1, 2, 3].map((i) => r(q(5), q(5 + i * 7), q(10), Math.max(1, q(3)), "#7ee0a0")
        .id(`code-${a.address}-${i}`).loop("width", { from: q(6), to: q(40 - i * 6), period: 600 + ((i * 337) % 700) + (a.address.length * 53) % 300 })));
    if (a.status === "blocked") {
      const fs = Math.max(8, q(12)), roomy = q(34) >= 2 * fs + 2;
      return s.flex().items_center().justify_center().child(v_flex().items_center().id(`need-${a.address}`).loop("opacity", { from: 0.25, to: 1, period: 700 })
        .children(roomy ? [txt("NEEDS", fs, "#fff8e1"), txt("YOU", fs, "#fff8e1")] : [txt("!", fs, "#fff8e1")]));
    }
    if (a.status === "done") return s.flex().items_center().justify_center().child(txt("OK", Math.max(8, q(16)), "#bfe0ff"));
    // Idle: a screensaver logo bouncing off the edges.
    const R = rng(hash(a.address)), lw = Math.max(14, q(24)), lh = Math.max(8, q(12)), fs = Math.max(8, q(10));
    return s.child(div().absolute().top(0).w(lw).h(q(34)).id(`dvd-x-${a.address}`)
      .loop("left", { from: 0, to: q(54) - lw, period: 3600 + Math.floor(R() * 2400), easing: "linear" })
      .child(div().absolute().left(0).w(lw).h(lh).bg(pick(R, DVD)).flex().items_center().justify_center().id(`dvd-y-${a.address}`)
        .loop("top", { from: 0, to: q(34) - lh, period: 2200 + Math.floor(R() * 1600), easing: "linear" })
        .child(txt("DVD", fs, "#36404c"))));
  }

  // The worker, at their seat or out walking. Each leg of a walk animates natively.
  worker(a, k, s) {
    const lk = look(a), t = this.trips[a.address], id = `w-${a.address}`, seat = this.seats[a.address];
    let pos = seat, ms = 16, body;
    if (!t) {
      body = seated(lk, s, a.status === "done").id(`${id}-sit`);
      if (a.status === "working") body.loop("top", { from: 0, to: -Math.max(1, Math.round(s * 0.7)), period: lk.bob });
      if (a.status === "blocked") body.loop("top", { from: 0, to: -4 * s, period: 700 });
    } else {
      const p = t.path[t.i], there = t.phase === "there", enter = t.phase === "enter";
      pos = p;
      ms = enter ? 16 : p.ms;
      const wall = t.spot.key in { cooler: 1, shelfL: 1, shelfR: 1, window: 1, door: 1 };
      const facing = enter ? "front" : there ? (wall ? "back" : "front") : p.facing;
      const item = there && t.spot.key === "cooler" ? "cup" : there && t.spot.key.startsWith("shelf") ? "book" : null;
      body = standing(lk, s, facing, !there && !enter, item, id);
    }
    const th = this.thoughts[a.address];
    const chatting = t?.phase === "there" && t.spot.key === "chat";
    return div().id(id).absolute().left(pos.x).top(pos.y).w(16 * s).h(20 * s)
      .transition("left", { duration: ms, easing: "linear" }).transition("top", { duration: ms, easing: "linear" })
      .cursor_pointer().on_mouse_down("left", (_e, cx) => cx.stop_propagation())
      .on_click(() => !this.demo && focusRun(a))
      .child(body)
      .when(!t && a.status === "done", (e) => e.child(txt("z", 16, "#24406e").absolute().left(14 * s).top(-2 * s).id(`${id}-z`).frames(["z", "zZ", "zZz", ""], 500)))
      .when(chatting, (e) => e.child(bubble(txt(".", 12, ink).id(`${id}-chat`).frames([".", "..", "..."], 400)).left(10 * s).top(-6 * s)))
      .when(!!th && !chatting, (e) => e.child(bubble(txt(th.sym, 12, ink)).left(11 * s).top(-6 * s)));
  }

  render() {
    const p = props() ?? {};
    this.demo = !!p.demo;
    if (p.role === "pane") {
      const pane = panes().find((x) => x.pane === p.pane);
      const st = pane?.status;
      return h_flex().size_full().px(10).gap(8).items_center().bg("#c99a62")
        .child(icon(pane?.program)).child(txt(pane?.program?.name ?? "Terminal", 12, ink))
        .child(div().flex_1())
        .child(txt(st === "blocked" ? "NEEDS YOU" : (st ?? "").toUpperCase(), 12, st === "blocked" ? "#a8322a" : ink));
    }
    if (p.role === "rail") {
      const s = spaces().find((s) => s.active), tab = s?.tabs.find((t) => t.active);
      return h_flex().size_full().bg(wood).px(16).items_center()
        .child(txt(`${s?.name ?? ""} / ${tab?.name ?? ""}`, 12, "#fff1d6"));
    }
    // props.demo fills the desks with sample workers in every state (for previews).
    const list = p.demo ? DEMO : workers();
    if (!p.demo) setAgentOrder(list.filter((a) => !a.unreported).map((a) => a.address));
    this.list = list;

    const { width: w, height: h } = this.size, now = new Date(), hour = now.getHours();
    const night = hour >= 19 || hour < 6;
    // Agents come in space order: one group of desks per space.
    const groups = [];
    for (const a of list) {
      const g = groups.at(-1);
      if (g && g.space === a.space) g.agents.push(a);
      else groups.push({ space: a.space, name: a.space_name, agents: [a] });
    }
    if (!groups.length) groups.push({ space: null, name: "", agents: [] });
    // A rug colour per space, fixed by its id, never the same as the group beside it.
    groups.forEach((g, gi) => {
      g.rug = hash(g.space ?? g.name) % RUGS.length;
      if (gi && g.rug === groups[gi - 1].rug) g.rug = (g.rug + 1) % RUGS.length;
    });
    const { k, s, cols, rows } = fit(groups.map((g) => g.agents.length), w, h);
    const sw = Math.round(SLOT_W * k), sh = Math.round(SLOT_H * k), gap = Math.round(GAP * k), q = (v) => Math.round(v * k);
    const width = cols.reduce((a, b) => a + b, 0) * sw + (groups.length - 1) * gap;
    const top = WALL + q(40), lanes = [];
    const desks = []; // { a, x, y, row, space }
    let x0 = Math.round((w - width) / 2);
    groups.forEach((g, gi) => {
      Object.assign(g, { x: x0, w: cols[gi] * sw });
      for (let j = 0; j < cols[gi] * rows; j++)
        desks.push({ a: g.agents[j], x: x0 + (j % cols[gi]) * sw, y: top + Math.floor(j / cols[gi]) * sh, row: Math.floor(j / cols[gi]), space: g.space });
      x0 += g.w + gap;
      if (gi < groups.length - 1) lanes.push(x0 - gap + Math.round((gap - 16 * s) / 2));
    });
    const left = groups[0].x, right = left + width;
    const leftX = Math.max(4, left - 16 * s - 6), rightX = Math.min(w - 16 * s - 4, right + 6);
    this.geo = { k, s, sh, top, rows, topY: WALL - 40, leftX, rightX, lanes: [leftX, ...lanes, rightX] };
    const taken = desks.filter((d) => d.a);

    // Newcomers walk in through the door.
    const ts = Date.now();
    for (const d of taken) {
      const a = d.a;
      this.seats[a.address] = { x: d.x + q(61), y: d.y + q(50), row: d.row };
      if (this.known && !this.known.has(a.address)) {
        const door = this.spotPlace({ key: "door", jx: 0 });
        const path = [{ x: door.x, y: this.laneY(-1), r: -1, ms: 16 }, ...this.path(door, this.seatPlace(a.address), WALK, this.off(a.address))];
        this.trips[a.address] = { phase: "enter", spot: { key: "door" }, path, i: 0, until: ts + 700 };
        this.door = ts + 4000;
      }
    }
    this.known = new Set(list.map((a) => a.address));
    for (const key of Object.keys(this.trips)) if (!this.known.has(key)) delete this.trips[key];
    for (const t of Object.values(this.trips)) if (t.phase === "enter" && ts >= t.until) t.phase = "back";

    const cy = Math.round(30 * k);
    const hd = taken.find((d) => d.a.address === this.hover), hovered = hd?.a;
    const music = this.demo || this.music;
    const toggle = (cx) => {
      if (this.demo) return;
      cx.spawn(async (cx) => { await toggleMusic(this.music); this.checkMusic(cx); });
    };
    return div().id("office-root").relative().size_full().overflow_hidden().bg("#e2a465")
      .on_size_change((size, cx) => { this.size = size; this.syncRoom(); cx.notify(); })
      .child(this.roomView)
      .child(whiteboards(this.boards, Math.round(w / 2) + 275, w - 352, this.boardHover, (a, cx) => {
        // Only a real change redraws, as with the desks.
        if ((a?.url ?? null) !== (this.boardHover?.url ?? null)) { this.boardHover = a; cx.notify(); }
      }))
      .children(groups.filter((g) => g.name).map((g) => {
        const [col, edge] = RUGS[g.rug], rw = g.w + q(16), rh = rows * sh + q(4);
        return r(g.x - q(8), top - q(8), rw, rh, col).border(3).border_color(edge)
          .child(r(q(6), q(6), rw - q(12) - 6, rh - q(12) - 6, col).border(1).border_color(`${edge}aa`));
      }))
      .child(djCorner(16, h - 14, s * 1.5, music, toggle))
      .children(desks.map((d, i) => this.desk(d.a, i, d.x, d.y, k, night, d.space)))
      .children(taken.map((d) => this.label(d.a, d.x, d.y, k)))
      .children(groups.filter((g) => g.name).map((g) => {
        const edge = RUGS[g.rug][1], ts = Math.max(8, q(16));
        return div().absolute().left(g.x - q(8)).top(top - q(8) - ts - 8).px(8).py(4).bg(edge)
          .child(txt(g.name.slice(0, 20), ts, "#fff8e1"));
      }))
      .children(catCorner(w, this.bedX(), this.geo.topY + cy + Math.round(7 * s), s))
      .when(!this.door, (e) => e.child(catFlap(Math.round(w / 2), s, ts < this.flap)))
      .children(this.cats.filter((c) => !c.away).map((c, i) => {
        const cp = c.path?.[c.i] ?? { ...this.catAt(c, ts), ms: 16 };
        // Playing, they bounce: a whole two art pixels up and down, a beat apart.
        const hop = this.play && (Math.floor(ts / 250) + i) % 2 ? -2 * s : 0;
        return div().id(`cat-${c.name}`).absolute().left(cp.x).top(cp.y + cy).w(Math.round(10 * s)).h(Math.round(7 * s))
          .transition("left", { duration: cp.ms, easing: "linear" }).transition("top", { duration: cp.ms, easing: "linear" })
          .on_hover((hov, cx) => {
            const name = hov ? c.name : this.catHover === c.name ? null : this.catHover;
            if (name !== this.catHover) { this.catHover = name; cx.notify(); }
          })
          .child(div().absolute().left(0).top(hop).child(cat(c, s, c.left)))
          .when(this.catHover === c.name, (e) => e.child(div().absolute().left(0).top(-Math.max(8, q(16)) - 10).px(4).py(2).bg(wood)
            .child(txt(c.name, Math.max(8, q(16)), "#fff8e1"))));
      }))
      .when(!!this.play, (e) => e.children([0, 1, 2].map((i) => {
        const p = this.play, age = ts - p.start - i * 500;
        if (age < 0 || age >= 2000) return div();
        const rise = Math.round((age / 2000) * 12) * s;
        return div().absolute().left(Math.round(p.x + (i * 6 - 1) * s)).top(Math.round(p.y + cy - 6 * s - rise)).child(heart(s));
      })))
      .children(list.map((a) => this.worker(a, k, s)))
      .when(night, (e) => e.child(r(0, 0, w, h, "#0b123650")))
      .when(hour >= 17 && hour < 19, (e) => e.child(r(0, 0, w, h, "#f2a65a1a")))
      .when(!!hovered, (e) => {
        const x = Math.min(hd.x + sw - 10, w - 200);
        return e.child(v_flex().absolute().left(x).top(hd.y).w(180).p(8).gap(4).bg("#fff27a").border(2).border_color("#d8c440")
          .child(txt(hovered.tab_name, 12, ink).truncate())
          .child(txt(hovered.space_name ?? "", 12, "#6b5a4a").truncate())
          .when(!!hovered.title, (e) => e.child(txt(hovered.title, 12, "#6b5a4a").truncate()))
          .child(txt(hovered.status.toUpperCase(), 12, hovered.status === "blocked" ? "#a8322a" : ink)));
      })
      .child(v_flex().absolute().left(16).top(14).gap(4).p(8).bg("#fbfbf6").border(3).border_color("#6b3f1f")
        .child(txt("THE OFFICE", 16)).child(txt(`${list.length} on the clock`, 12, "#6b5a4a"))
        .child(div().id("dj-switch").cursor_pointer().on_mouse_down("left", (_e, cx) => cx.stop_propagation())
          .on_click((_e, cx) => toggle(cx))
          .child(txt(music ? "♪ music: on" : "♪ music: off", 12, music ? "#a8322a" : "#6b5a4a"))));
  }
}

const bubble = (content) => div().absolute().px(4).py(2).bg("#ffffff").border(2).border_color(ink).child(content);
