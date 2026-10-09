// notif-center window: the history of every desktop notification. Vanilla JS, no build step;
// shared helpers in webview.js.

import {
  api, closeWindow, focusedKey, h, imgUrl, initial, moveFocus, pad, plural, relTime, restoreFocus, timeEl, toast,
} from "/static/webview.js";

const main = document.getElementById("main");
const POLL_MS = 3000;
const LOG_PAGE = 500;

const UNDO_MS = 6000;

const nl = { data: null, q: "", app: "", limit: LOG_PAGE, confirm: false, dnd: null, showDismissed: false };
let stamp = null;

async function loadLog() {
  const params = new URLSearchParams({ limit: String(nl.limit) });
  if (nl.q) params.set("q", nl.q);
  if (nl.app) params.set("app", nl.app);
  if (nl.showDismissed) params.set("dismissed", "1");
  const [data, dnd] = await Promise.all([api(`/api/log?${params}`), loadDnd()]);
  nl.data = data;
  nl.dnd = dnd;
}

// null when swaync is unreachable: the toggle is hidden then.
async function loadDnd() {
  try { return (await api("/api/dnd")).dnd; } catch { return null; }
}

async function setDnd(on) {
  try {
    nl.dnd = (await api("/api/dnd", { on })).dnd;
    drawLog();
    main.querySelector(".dnd")?.focus();
  } catch (e) {
    toast(e.message, "error");
  }
}

async function openEntry(entry) {
  try {
    const res = await api("/api/log/open", { n: entry.n });
    toast(res.action === "open" ? "Открыто в браузере" : "Текст скопирован");
  } catch (e) {
    toast(e.message, "error");
  }
}

function undoToast(text, ids) {
  const el = h("div", { class: "toast undo", role: "status" }, h("span", {}, text),
    h("button", { class: "undo-btn", onclick: async () => { el.remove(); await undo(ids); } }, "Вернуть"));
  document.getElementById("toasts").append(el);
  setTimeout(() => el.remove(), UNDO_MS);
}

async function undo(ids) {
  try {
    const res = await api("/api/log/undo", ids ? { ids } : {});
    await refreshLog();
    if (res.ids.length) toast(`Возвращено: ${res.ids.length}`);
  } catch (e) {
    toast(e.message, "error");
  }
}

// After a row disappears the focus moves to its neighbour, so `d` can be pressed repeatedly.
function neighbourKey(key) {
  const rows = [...main.querySelectorAll("[data-key]")];
  const at = rows.findIndex((row) => row.dataset.key === key);
  if (at < 0) return null;
  return (rows[at + 1] || rows[at - 1] || null)?.dataset.key ?? null;
}

async function dismissEntry(entry) {
  if (entry.dismissed) return;
  const hadFocus = main.contains(document.activeElement) && document.activeElement.dataset.key === `n${entry.n}`;
  const next = hadFocus && !nl.showDismissed ? neighbourKey(`n${entry.n}`) : null;
  try {
    const res = await api("/api/log/dismiss", { id: entry.id });
    await loadLog();
    drawLog();
    if (hadFocus) main.querySelector(`[data-key="${CSS.escape(next || `n${entry.n}`)}"]`)?.focus({ preventScroll: true });
    if (res.ids.length) undoToast("Уведомление скрыто", res.ids);
  } catch (e) {
    toast(e.message, "error");
  }
}

async function dismissAll() {
  try {
    const res = await api("/api/log/dismiss-all", { q: nl.q, app: nl.app });
    await loadLog();
    drawLog();
    const n = res.ids.length;
    if (n) undoToast(`Скрыто ${n} ${plural(n, "уведомление", "уведомления", "уведомлений")}`, res.ids);
  } catch (e) {
    toast(e.message, "error");
  }
}

async function clearLog() {
  try {
    await api("/api/log/clear", {});
    nl.confirm = false;
    nl.limit = LOG_PAGE;
    await loadLog();
    drawLog();
    toast("Журнал удалён");
  } catch (e) {
    toast(e.message, "error");
  }
}

function dayKey(ts) {
  const d = new Date(ts * 1000);
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
}

function dayLabel(ts) {
  const d = new Date(ts * 1000);
  const today = new Date();
  const yesterday = new Date(today);
  yesterday.setDate(today.getDate() - 1);
  if (d.toDateString() === today.toDateString()) return "Сегодня";
  if (d.toDateString() === yesterday.toDateString()) return "Вчера";
  const opts = { day: "numeric", month: "long", weekday: "short" };
  if (d.getFullYear() !== today.getFullYear()) opts.year = "numeric";
  return d.toLocaleDateString("ru-RU", opts);
}

function rowTime(ts) {
  if (!ts) return timeEl(ts);
  const d = new Date(ts * 1000);
  const today = d.toDateString() === new Date().toDateString();
  return timeEl(ts, today ? relTime(ts) : `${pad(d.getHours())}:${pad(d.getMinutes())}`);
}

function logIcon(entry) {
  const fallback = h("div", { class: "icon tile", "aria-hidden": "true" }, initial(entry.app || entry.summary));
  if (!entry.icon) return fallback;
  const img = h("img", { class: "icon", src: imgUrl(`/api/log/${entry.n}/icon`), alt: "", loading: "lazy" });
  img.addEventListener("error", () => img.replaceWith(fallback));
  return img;
}

function logRow(entry) {
  const title = entry.summary.split("\n")[0] || entry.app;
  const classes = [entry.critical ? "critical" : "", entry.dismissed ? "dismissed" : ""].filter(Boolean).join(" ");
  const close = entry.dismissed ? h("span", { class: "dismiss", "aria-hidden": "true" }) : h("button", {
    class: "dismiss",
    tabindex: "-1",
    title: "Скрыть (d)",
    "aria-label": "Скрыть",
    onclick: (e) => { e.stopPropagation(); dismissEntry(entry); },
  }, "×");
  return h("li", {
    class: classes || null,
    tabindex: "0",
    dataset: { key: `n${entry.n}` },
    title: entry.url || null,
    onclick: () => openEntry(entry),
    onkeydown: (e) => {
      if (e.ctrlKey || e.altKey || e.metaKey) return;
      if (e.key === "Enter") { e.preventDefault(); openEntry(entry); }
      else if (e.key === "d" || e.key === "в" || e.key === "Delete") { e.preventDefault(); dismissEntry(entry); }
    },
  },
    logIcon(entry),
    h("div", { class: "text" },
      h("div", { class: "title" }, h("b", {}, title), entry.app ? h("span", { class: "app" }, entry.app) : null),
      entry.body ? h("div", { class: "body" }, entry.body) : null),
    h("div", { class: "side" },
      h("div", { class: "side-top" }, rowTime(entry.time), close),
      h("span", { class: "action" }, entry.dismissed ? "скрыто" : entry.url ? "открыть ↗" : "копировать")));
}

function dayGroups(entries) {
  const groups = [];
  for (const entry of entries) {
    const key = dayKey(entry.time || 0);
    const last = groups[groups.length - 1];
    if (last && last.key === key) last.entries.push(entry);
    else groups.push({ key, time: entry.time, entries: [entry] });
  }
  return groups.map((g) => h("section", { class: "day" },
    h("h3", { class: "day-head" }, dayLabel(g.time), h("span", { class: "n" }, g.entries.length)),
    h("ul", { class: "log" }, g.entries.map(logRow))));
}

let searchTimer = null;

function drawLog() {
  if (!nl.data) return;
  const saved = focusedKey(main);
  const { entries, total, apps, all, active, dismissed, stored } = nl.data;
  drawCounter(active);

  const search = h("input", {
    class: "input log-search",
    type: "search",
    placeholder: "Поиск по журналу  /",
    value: nl.q,
    dataset: { focus: "search" },
    oninput: (e) => {
      nl.q = e.target.value;
      clearTimeout(searchTimer);
      searchTimer = setTimeout(async () => { nl.limit = LOG_PAGE; await refreshLog(); }, 150);
    },
  });
  const appSelect = h("select", {
    class: "input",
    dataset: { focus: "app" },
    "aria-label": "Приложение",
    onchange: async (e) => { nl.app = e.target.value; nl.limit = LOG_PAGE; await refreshLog(); },
  },
    h("option", { value: "" }, "Все приложения"),
    apps.map(([app, n]) => h("option", { value: app, selected: app === nl.app }, `${app} · ${n}`)));
  if (nl.app && !apps.some(([app]) => app === nl.app)) appSelect.append(h("option", { value: nl.app, selected: true }, nl.app));

  const dndBtn = nl.dnd === null ? null : h("button", {
    class: "chip dnd",
    dataset: { focus: "dnd" },
    "aria-pressed": nl.dnd ? "true" : "false",
    title: nl.dnd ? "Всплывающие уведомления выключены — нажми, чтобы включить" : "Не показывать всплывающие уведомления",
    onclick: () => setDnd(!nl.dnd),
  }, nl.dnd ? "🔕 Не беспокоить" : "🔔 Не беспокоить");

  const visibleActive = entries.some((entry) => !entry.dismissed);
  const dismissAllBtn = h("button", {
    class: "btn small",
    disabled: !visibleActive,
    title: nl.q || nl.app ? "Скрыть все найденные уведомления" : "Скрыть все уведомления",
    onclick: dismissAll,
  }, "Скрыть всё");
  const dismissedBtn = h("button", {
    class: "chip dismissed-toggle",
    dataset: { focus: "dismissed" },
    "aria-pressed": nl.showDismissed ? "true" : "false",
    disabled: !dismissed && !nl.showDismissed,
    title: nl.showDismissed ? "Не показывать скрытые" : "Показать скрытые уведомления",
    onclick: async () => { nl.showDismissed = !nl.showDismissed; nl.limit = LOG_PAGE; await refreshLog(); },
  }, "Скрытые ", h("span", { class: "n" }, dismissed));

  const clearBtn = h("button", { class: "btn small danger", disabled: !stored, title: "Безвозвратно удалить весь журнал", onclick: () => { nl.confirm = true; drawLog(); main.querySelector(".confirm .btn")?.focus(); } }, "Удалить журнал");
  const confirm = nl.confirm ? h("div", { class: "confirm", role: "alertdialog" },
    h("span", {}, `Удалить ${stored} ${plural(stored, "запись", "записи", "записей")} из журнала, включая скрытые? Это необратимо.`),
    h("button", { class: "btn small", onclick: () => { nl.confirm = false; drawLog(); } }, "Отмена"),
    h("button", { class: "btn small danger solid", onclick: clearLog }, "Удалить")) : null;

  const filtered = nl.q || nl.app;
  const line = filtered
    ? `Найдено ${total} из ${all}`
    : `${all} ${plural(all, "уведомление", "уведомления", "уведомлений")}`;

  let body;
  if (!stored) body = h("div", { class: "empty" }, h("h2", {}, "Журнал пуст"), h("p", {}, "Сюда пишется каждое уведомление рабочего стола."));
  else if (!all) body = h("div", { class: "empty" }, h("h2", {}, "Всё скрыто"), h("p", {}, "Скрытые уведомления — по кнопке «Скрытые»."));
  else if (!entries.length) body = h("div", { class: "empty" }, "Ничего не найдено");
  else body = h("div", { class: "days" }, dayGroups(entries));

  main.replaceChildren(h("div", { class: "page" },
    h("div", { class: "toolbar" }, search, appSelect, dndBtn, dismissAllBtn, dismissedBtn, clearBtn),
    confirm,
    h("div", { class: "summary-line" }, line,
      nl.dnd ? h("span", { class: "dnd-note" }, " · не беспокоить: всплывающие уведомления скрыты, журнал пишется") : null),
    body,
    entries.length < total
      ? h("button", { class: "btn more", onclick: async () => { nl.limit += LOG_PAGE; await refreshLog(); } }, `Показать ещё (${total - entries.length})`)
      : null));
  restoreFocus(main, saved);
}

function drawCounter(active) {
  const el = document.getElementById("active-count");
  el.textContent = active ? `${active} ${plural(active, "активное", "активных", "активных")}` : "";
  el.hidden = !active;
}

async function refreshLog() {
  try {
    await loadLog();
    drawLog();
  } catch (e) {
    toast(e.message, "error");
  }
}

async function start() {
  try {
    await loadLog();
    drawLog();
    main.querySelector(".log-search")?.focus();
  } catch (e) {
    main.replaceChildren(h("div", { class: "empty" }, h("h2", {}, "Что-то пошло не так"), h("p", { class: "err" }, e.message)));
  }
}

async function poll() {
  let s;
  try { s = await api("/api/stamp"); } catch { return; }
  const changed = stamp !== null && s.log !== stamp;
  stamp = s.log;
  if (nl.confirm) return;
  try {
    if (changed) { await loadLog(); drawLog(); }
    else {
      const dnd = await loadDnd();
      if (dnd !== nl.dnd) { nl.dnd = dnd; drawLog(); }
    }
  } catch { /* the next tick retries */ }
}

document.addEventListener("visibilitychange", () => { if (!document.hidden) poll(); });

document.addEventListener("keydown", (e) => {
  const typing = (e.target instanceof HTMLInputElement && e.target.type !== "checkbox") || e.target instanceof HTMLSelectElement;
  if (e.key === "Escape") {
    e.preventDefault();
    if (typing && e.target.value && e.target.type === "search") { e.target.value = ""; e.target.dispatchEvent(new Event("input")); return; }
    if (nl.confirm) { nl.confirm = false; drawLog(); return; }
    closeWindow();
    return;
  }
  if (e.key === "ArrowDown" && e.target.type === "search") { e.preventDefault(); moveFocus(main, 1); return; }
  if (typing || e.ctrlKey || e.altKey || e.metaKey) return;
  if (e.key === "/") { e.preventDefault(); main.querySelector(".log-search")?.focus(); return; }
  if (e.key === "ArrowDown" || e.key === "j" || e.key === "о") { e.preventDefault(); moveFocus(main, 1); return; }
  if (e.key === "ArrowUp" || e.key === "k" || e.key === "л") { e.preventDefault(); moveFocus(main, -1); }
});

start();
poll();
setInterval(poll, POLL_MS);
