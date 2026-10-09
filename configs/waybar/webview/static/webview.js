// Helpers shared by the gh-feed and notif-center pages. Vanilla ES module, no build step.

export const TOKEN = document.querySelector('meta[name="webview-token"]').content;

export function h(tag, attrs = {}, ...children) {
  const el = document.createElement(tag);
  for (const [k, v] of Object.entries(attrs)) {
    if (v === false || v === null || v === undefined) continue;
    if (k === "class") el.className = v;
    else if (k.startsWith("on")) el.addEventListener(k.slice(2), v);
    else if (k === "dataset") Object.assign(el.dataset, v);
    else if (v === true) el.setAttribute(k, "");
    else el.setAttribute(k, v);
  }
  for (const c of children.flat()) {
    if (c === null || c === undefined || c === false) continue;
    el.append(c instanceof Node ? c : document.createTextNode(String(c)));
  }
  return el;
}

export async function api(path, body) {
  const headers = { "X-Webview-Token": TOKEN };
  const opts = { headers };
  if (body !== undefined) {
    opts.method = "POST";
    headers["Content-Type"] = "application/json";
    opts.body = JSON.stringify(body);
  }
  const res = await fetch(path, opts);
  let data = null;
  try { data = await res.json(); } catch { /* empty body */ }
  if (!res.ok) throw new Error((data && data.error) || `${res.status} ${res.statusText}`);
  return data;
}

export function imgUrl(path) {
  return `${path}?t=${encodeURIComponent(TOKEN)}`;
}

export function toast(text, kind = "") {
  const el = h("div", { class: `toast ${kind}`, role: kind === "error" ? "alert" : "status" }, text);
  document.getElementById("toasts").append(el);
  setTimeout(() => el.remove(), kind === "error" ? 6000 : 2600);
}

export function closeWindow() {
  const bridge = window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.webview;
  if (bridge) bridge.postMessage("close");
  else window.close();
}

export function plural(n, one, few, many) {
  if (n % 10 === 1 && n % 100 !== 11) return one;
  if (n % 10 >= 2 && n % 10 <= 4 && !(n % 100 >= 12 && n % 100 <= 14)) return few;
  return many;
}

export const pad = (n) => String(n).padStart(2, "0");

// Short Russian age: сейчас, 5 мин, 3 ч, вчера, 12.09.
export function relTime(ts) {
  if (!ts) return "";
  const now = Date.now() / 1000;
  const delta = Math.max(0, now - ts);
  const d = new Date(ts * 1000);
  const today = new Date();
  if (delta < 60) return "сейчас";
  if (delta < 3600) return `${Math.floor(delta / 60)} мин`;
  if (d.toDateString() === today.toDateString() || delta < 6 * 3600) return `${Math.floor(delta / 3600)} ч`;
  const yesterday = new Date(today);
  yesterday.setDate(today.getDate() - 1);
  if (d.toDateString() === yesterday.toDateString()) return "вчера";
  const date = `${pad(d.getDate())}.${pad(d.getMonth() + 1)}`;
  return d.getFullYear() === today.getFullYear() ? date : `${date}.${String(d.getFullYear()).slice(2)}`;
}

export function fullTime(ts) {
  return ts ? new Date(ts * 1000).toLocaleString("ru-RU", { dateStyle: "medium", timeStyle: "short" }) : "";
}

export function timeEl(ts, text = relTime(ts)) {
  return h("time", { datetime: ts ? new Date(ts * 1000).toISOString() : null, title: fullTime(ts) }, text);
}

export function initial(text) {
  const ch = (text || "?").trim().charAt(0);
  return ch ? ch.toUpperCase() : "?";
}

// Re-rendering on every poll must not steal the keyboard focus.
export function focusedKey(root) {
  const el = document.activeElement;
  if (!el || !root.contains(el)) return null;
  if (el.dataset && el.dataset.key) return { key: el.dataset.key };
  if (el.dataset && el.dataset.focus) return { focus: el.dataset.focus, start: el.selectionStart, end: el.selectionEnd };
  return null;
}

export function restoreFocus(root, saved) {
  if (!saved) return;
  if (saved.key) {
    root.querySelector(`[data-key="${CSS.escape(saved.key)}"]`)?.focus({ preventScroll: true });
    return;
  }
  const el = root.querySelector(`[data-focus="${saved.focus}"]`);
  if (!el) return;
  el.focus({ preventScroll: true });
  if (typeof saved.start === "number" && el.setSelectionRange) el.setSelectionRange(saved.start, saved.end);
}

export function moveFocus(root, step) {
  const rows = [...root.querySelectorAll("[data-key]")];
  if (!rows.length) return;
  const at = rows.indexOf(document.activeElement);
  const next = at < 0 ? (step > 0 ? 0 : rows.length - 1) : Math.min(rows.length - 1, Math.max(0, at + step));
  rows[next].focus();
  rows[next].scrollIntoView({ block: "nearest" });
}
