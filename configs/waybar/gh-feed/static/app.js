// gh-feed window: the GitHub feed. Vanilla JS, no build step; shared helpers in webview.js.

import {
  api, closeWindow, focusedKey, h, imgUrl, initial, moveFocus, plural, restoreFocus, timeEl, toast,
} from "/static/webview.js";

const main = document.getElementById("main");
const POLL_MS = 3000;
const KINDS = { review: "ревью", mention: "меншн", comment: "комменты", status: "статус" };

const gh = { items: null, unread: 0, kind: "", repo: "" };
let stamp = null;

function setCount(unread) {
  const el = document.getElementById("gh-count");
  el.hidden = !unread;
  el.textContent = unread;
}

async function loadGithub() {
  const data = await api("/api/github");
  gh.items = data.items;
  gh.unread = data.unread;
  setCount(gh.unread);
}

function chip(label, n, pressed, onclick) {
  return h("button", { class: "chip", "aria-pressed": pressed ? "true" : "false", onclick },
    label, n === null ? null : h("span", { class: "n" }, n));
}

function avatarEl(item) {
  const wrap = h("div", { class: "avatar", "aria-hidden": "true" });
  const fallback = h("div", { class: "initial" }, initial(item.actor || item.repo));
  if (item.avatar) {
    const img = h("img", { src: imgUrl(`/api/avatar/${item.avatar}`), alt: "", loading: "lazy" });
    img.addEventListener("error", () => img.replaceWith(fallback));
    wrap.append(img);
  } else {
    wrap.append(fallback);
  }
  if (item.emoji) wrap.append(h("span", { class: "kind-badge" }, item.emoji));
  return wrap;
}

function markLocal(id) {
  const item = gh.items.find((i) => i.id === id);
  if (item && !item.read) {
    item.read = true;
    gh.unread -= 1;
    setCount(gh.unread);
  }
}

async function openItem(item) {
  try {
    await api("/api/github/open", { id: item.id });
    markLocal(item.id);
    drawGithub();
  } catch (e) {
    toast(e.message, "error");
  }
}

async function readItem(item) {
  try {
    await api("/api/github/read", { id: item.id });
    markLocal(item.id);
    drawGithub();
  } catch (e) {
    toast(e.message, "error");
  }
}

async function readAll() {
  try {
    await api("/api/github/read-all", {});
    gh.items.forEach((i) => { i.read = true; });
    gh.unread = 0;
    setCount(0);
    drawGithub();
  } catch (e) {
    toast(e.message, "error");
  }
}

function githubCard(item) {
  const head = item.actor
    ? h("div", { class: "head" }, h("span", { class: "actor" }, item.actor), " ", item.verb, " ", h("span", { class: "ref" }, item.ref))
    : h("div", { class: "head" }, item.verb);
  return h("li", {
    class: `item ${item.read ? "read" : "unread"}`,
    tabindex: "0",
    dataset: { key: item.id },
    title: item.click || null,
    onclick: () => openItem(item),
    onkeydown: (e) => {
      if (e.target !== e.currentTarget) return;
      if (e.key === "Enter") { e.preventDefault(); openItem(item); }
      if ((e.key === "r" || e.key === "к") && !item.read) { e.preventDefault(); readItem(item); }
    },
  },
    avatarEl(item),
    h("div", { class: "text" },
      head,
      item.subject ? h("div", { class: "subject" }, item.subject) : null,
      item.snippet ? h("div", { class: "snippet" }, item.snippet) : null),
    h("div", { class: "side" },
      timeEl(item.time),
      item.read ? null : h("button", {
        class: "btn small ghost mark",
        title: "Отметить прочитанным (r)",
        onclick: (e) => { e.stopPropagation(); readItem(item); },
      }, "прочитано")));
}

function drawGithub() {
  if (!gh.items) return;
  const saved = focusedKey(main);
  const items = gh.items;
  if (!items.length) {
    main.replaceChildren(h("div", { class: "empty" }, h("h2", {}, "Нет уведомлений"), h("p", {}, "Сюда попадает лента GitHub из ntfy.")));
    return;
  }
  const kinds = new Map();
  const repos = new Map();
  for (const i of items) {
    if (KINDS[i.kind]) kinds.set(i.kind, (kinds.get(i.kind) || 0) + 1);
    if (i.repo) repos.set(i.repo, (repos.get(i.repo) || 0) + 1);
  }
  if (gh.kind && !kinds.has(gh.kind)) gh.kind = "";
  if (gh.repo && !repos.has(gh.repo)) gh.repo = "";
  const shown = items.filter((i) => (!gh.kind || i.kind === gh.kind) && (!gh.repo || i.repo === gh.repo));

  const kindChips = [chip("Все", items.length, !gh.kind && !gh.repo, () => { gh.kind = ""; gh.repo = ""; drawGithub(); })];
  for (const [kind, label] of Object.entries(KINDS)) {
    if (kinds.has(kind)) kindChips.push(chip(label, kinds.get(kind), gh.kind === kind, () => { gh.kind = gh.kind === kind ? "" : kind; drawGithub(); }));
  }
  const repoChips = [...repos.entries()].sort((a, b) => b[1] - a[1])
    .map(([repo, n]) => chip(repo, n, gh.repo === repo, () => { gh.repo = gh.repo === repo ? "" : repo; drawGithub(); }));

  const status = gh.unread
    ? `${gh.unread} ${plural(gh.unread, "непрочитанное", "непрочитанных", "непрочитанных")}`
    : "Всё прочитано";

  main.replaceChildren(h("div", { class: "page" },
    h("div", { class: "toolbar" },
      h("span", { class: "summary-line" }, status),
      h("span", { class: "spacer" }),
      h("button", { class: "btn small", disabled: !gh.unread, onclick: readAll }, "Отметить всё прочитанным")),
    h("div", { class: "filters" },
      h("div", { class: "chips" }, kindChips),
      repoChips.length > 1 ? h("div", { class: "chips" }, repoChips) : null),
    shown.length
      ? h("ul", { class: "feed" }, shown.map(githubCard))
      : h("div", { class: "empty" }, "Ничего не подходит под фильтр")));
  restoreFocus(main, saved);
}

async function start() {
  try {
    await loadGithub();
    drawGithub();
    main.focus({ preventScroll: true });
  } catch (e) {
    main.replaceChildren(h("div", { class: "empty" }, h("h2", {}, "Что-то пошло не так"), h("p", { class: "err" }, e.message)));
  }
}

async function poll() {
  let s;
  try { s = await api("/api/stamp"); } catch { return; }
  const changed = stamp !== null && s.github !== stamp;
  stamp = s.github;
  if (!changed) return;
  try {
    await loadGithub();
    drawGithub();
  } catch { /* the next tick retries */ }
}

document.addEventListener("visibilitychange", () => { if (!document.hidden) poll(); });

document.addEventListener("keydown", (e) => {
  if (e.key === "Escape") { e.preventDefault(); closeWindow(); return; }
  if (e.ctrlKey || e.altKey || e.metaKey) return;
  if (e.key === "ArrowDown" || e.key === "j" || e.key === "о") { e.preventDefault(); moveFocus(main, 1); return; }
  if (e.key === "ArrowUp" || e.key === "k" || e.key === "л") { e.preventDefault(); moveFocus(main, -1); }
});

start();
poll();
setInterval(poll, POLL_MS);
