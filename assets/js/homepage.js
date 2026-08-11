const menuButton = document.querySelector(".menu-toggle");
const navigation = document.querySelector(".site-nav");
const navigationLinks = [...document.querySelectorAll(".site-nav a")];

function closeMobileNavigation() {
  menuButton?.setAttribute("aria-expanded", "false");
  navigation?.classList.remove("is-open");
}

menuButton?.addEventListener("click", () => {
  const willOpen = menuButton.getAttribute("aria-expanded") !== "true";
  menuButton.setAttribute("aria-expanded", String(willOpen));
  navigation?.classList.toggle("is-open", willOpen);
});

navigationLinks.forEach((link) => link.addEventListener("click", closeMobileNavigation));

const filterButtons = [...document.querySelectorAll(".filter-button")];
const publications = [...document.querySelectorAll(".publication")];
const publicationSearch = document.querySelector("#publication-search-input");
const publicationEmpty = document.querySelector(".publication-empty");
let activePublicationTopic = "all";

function updatePublications() {
  const query = publicationSearch?.value.trim().toLocaleLowerCase() ?? "";
  let visibleCount = 0;

  publications.forEach((publication) => {
    const matchesTopic = activePublicationTopic === "all" || publication.dataset.topic === activePublicationTopic;
    const matchesQuery = !query || publication.textContent.toLocaleLowerCase().includes(query);
    publication.hidden = !(matchesTopic && matchesQuery);
    visibleCount += publication.hidden ? 0 : 1;
  });

  if (publicationEmpty) publicationEmpty.hidden = visibleCount !== 0;
}

function resetPublicationFilters() {
  activePublicationTopic = "all";
  filterButtons.forEach((button) => button.classList.toggle("is-active", button.dataset.filter === "all"));
  if (publicationSearch) publicationSearch.value = "";
  updatePublications();
}

filterButtons.forEach((button) => {
  button.addEventListener("click", () => {
    activePublicationTopic = button.dataset.filter ?? "all";
    filterButtons.forEach((candidate) => candidate.classList.toggle("is-active", candidate === button));
    updatePublications();
  });
});

publicationSearch?.addEventListener("input", updatePublications);
document.querySelectorAll('.experience-papers a[href^="#pub-"]').forEach((link) => {
  link.addEventListener("click", resetPublicationFilters);
});

const searchToggle = document.querySelector(".search-toggle");
const searchOverlay = document.querySelector(".search-overlay");
const searchClose = document.querySelector(".search-close");
const siteSearchInput = document.querySelector("#site-search-input");
const searchResults = document.querySelector(".search-results");
const sectionSearchEntries = [
  { id: "about", title: "Home", detail: "Profile and research overview" },
  {
    id: "research",
    title: "Featured Research",
    detail: "Selected research highlights",
  },
  {
    id: "publications",
    title: "Publications",
    detail: "Papers, venues, and links",
  },
  {
    id: "experience",
    title: "Experience",
    detail: "Research story and education",
  },
  { id: "contact", title: "Contact", detail: "Email and profile links" },
];
const publicationSearchEntries = publications.map((publication) => ({
  id: publication.id,
  title: publication.querySelector("h3")?.textContent.trim() ?? "Publication",
  detail: publication.querySelector(".venue")?.textContent.trim() ?? "Publication",
  text: publication.textContent,
  publication: true,
}));
const siteSearchEntries = [...sectionSearchEntries, ...publicationSearchEntries];

function renderSiteSearch() {
  if (!searchResults) return;
  const query = siteSearchInput?.value.trim().toLocaleLowerCase() ?? "";
  const matches = siteSearchEntries
    .filter((entry) => !query || `${entry.title} ${entry.detail} ${entry.text ?? ""}`.toLocaleLowerCase().includes(query))
    .slice(0, query ? 10 : 5);

  searchResults.replaceChildren();

  if (matches.length === 0) {
    const message = document.createElement("p");
    message.textContent = "No matching sections or publications.";
    searchResults.append(message);
    return;
  }

  matches.forEach((entry) => {
    const link = document.createElement("a");
    const detail = document.createElement("small");
    link.className = "search-result";
    link.href = `#${entry.id}`;
    link.append(document.createTextNode(entry.title));
    detail.textContent = entry.detail;
    link.append(detail);
    link.addEventListener("click", () => {
      if (entry.publication) resetPublicationFilters();
      closeSiteSearch();
    });
    searchResults.append(link);
  });
}

function openSiteSearch() {
  if (!searchOverlay) return;
  searchOverlay.hidden = false;
  document.body.classList.add("search-open");
  if (siteSearchInput) siteSearchInput.value = "";
  renderSiteSearch();
  window.requestAnimationFrame(() => siteSearchInput?.focus());
}

function closeSiteSearch() {
  if (!searchOverlay || searchOverlay.hidden) return;
  searchOverlay.hidden = true;
  document.body.classList.remove("search-open");
  searchToggle?.focus();
}

searchToggle?.addEventListener("click", openSiteSearch);
searchClose?.addEventListener("click", closeSiteSearch);
siteSearchInput?.addEventListener("input", renderSiteSearch);
searchOverlay?.addEventListener("click", (event) => {
  if (event.target === searchOverlay) closeSiteSearch();
});

const themeToggle = document.querySelector(".theme-toggle");
const themeMenu = document.querySelector(".theme-menu");
const themeButtons = [...document.querySelectorAll("[data-theme-value]")];
const themeIconUse = themeToggle?.querySelector("use");
const colorScheme = window.matchMedia("(prefers-color-scheme: dark)");
const themeStorageKey = "deokhyun-home-theme";
const validThemes = new Set(["light", "dark", "auto"]);
let themeChoice = "auto";

try {
  const storedTheme = window.localStorage.getItem(themeStorageKey);
  if (storedTheme && validThemes.has(storedTheme)) themeChoice = storedTheme;
} catch {
  themeChoice = "auto";
}

function applyTheme(choice, persist = false) {
  themeChoice = validThemes.has(choice) ? choice : "auto";
  const effectiveTheme = themeChoice === "auto" ? (colorScheme.matches ? "dark" : "light") : themeChoice;
  document.documentElement.dataset.theme = effectiveTheme;
  document.documentElement.dataset.themeChoice = themeChoice;
  themeButtons.forEach((button) => button.classList.toggle("is-selected", button.dataset.themeValue === themeChoice));

  if (themeIconUse) {
    const icon = themeChoice === "light" ? "#icon-sun" : themeChoice === "dark" ? "#icon-moon" : "#icon-monitor";
    themeIconUse.setAttribute("href", icon);
  }

  if (persist) {
    try {
      window.localStorage.setItem(themeStorageKey, themeChoice);
    } catch {
      // The theme still works when storage is unavailable.
    }
  }
}

function closeThemeMenu() {
  if (!themeMenu) return;
  themeMenu.hidden = true;
  themeToggle?.setAttribute("aria-expanded", "false");
}

applyTheme(themeChoice);

themeToggle?.addEventListener("click", () => {
  if (!themeMenu) return;
  const willOpen = themeMenu.hidden;
  themeMenu.hidden = !willOpen;
  themeToggle.setAttribute("aria-expanded", String(willOpen));
});

themeButtons.forEach((button) => {
  button.addEventListener("click", () => {
    applyTheme(button.dataset.themeValue ?? "auto", true);
    closeThemeMenu();
    themeToggle?.focus();
  });
});

colorScheme.addEventListener("change", () => {
  if (themeChoice === "auto") applyTheme("auto");
});

document.addEventListener("click", (event) => {
  if (!event.target.closest(".theme-picker")) closeThemeMenu();
});

document.addEventListener("keydown", (event) => {
  if (event.key !== "Escape") return;
  closeSiteSearch();
  closeThemeMenu();
  closeMobileNavigation();
});

const observedSections = sectionSearchEntries.map((entry) => document.getElementById(entry.id)).filter(Boolean);

if ("IntersectionObserver" in window) {
  const sectionObserver = new IntersectionObserver(
    (entries) => {
      const visibleEntry = entries.filter((entry) => entry.isIntersecting).sort((left, right) => right.intersectionRatio - left.intersectionRatio)[0];
      if (!visibleEntry) return;

      navigationLinks.forEach((link) => link.classList.toggle("is-active", link.getAttribute("href") === `#${visibleEntry.target.id}`));
    },
    { rootMargin: "-18% 0px -62%", threshold: [0, 0.1, 0.25, 0.5] }
  );

  observedSections.forEach((section) => sectionObserver.observe(section));
}
