# Gallery catalog expansion (2.39)

**Goal:** Every **2.21…2.38** slice has a Gallery catalog entry, documented smoke consideration, and Pitfalls cross-links. This doc is the findability matrix — not a screenshot golden suite.

**Related:** [gallery-catalog-page.md](gallery-catalog-page.md) (`CatalogPage` host) · [ci-smoke.md](ci-smoke.md) (critical page loads) · [Pitfalls](../src/gallery/pages/PitfallsPage.qml) · `ControlCatalog.recentlyShipped()`.

---

## Recently shipped (Home)

`ControlCatalog.recentlyShipped()` is a **curated** list (not catalog array order). After **2.39**, the top entries surface **2.38 → 2.21** recipe pages:

| Order | Page | Slice | Notes |
|-------|------|-------|-------|
| 1 | `ThemeOverridesPage` | 2.38 | Accent packs + `_restoreTheme()` |
| 2 | `FlipViewPage` / `PipsPagerPage` | 2.37 | Carousel hosts — [carousel-recipes.md](carousel-recipes.md) |
| 3 | `CalendarViewPage` | 2.31 | Experimental month grid |
| 4 | `NotificationCenterPage` | 2.27 | Experimental in-app history |
| 5 | `FormsHubPage` | 2.25 | Industry template hub |
| 6 | `ItemsWrapGridPage` | 2.24 | Experimental wrap grid |
| 7 | `BreadcrumbBarPage` | 2.23 | NavigationView sync demo |
| 8 | `DashboardPage` | 2.22 | Responsive layout recipes |
| 9 | `TreeDataGridPage` | 2.21 | Experimental hierarchical grid |

Search still matches **component id** (e.g. `calendarview`, `treedatagrid`) from the title bar.

---

## 2.21…2.38 catalog matrix

| Slice | Gallery page(s) | New control / theme | Smoke critical? | Validator |
|-------|-----------------|---------------------|-----------------|-----------|
| **2.21** | `TreeDataGridPage` | `TreeDataGrid` (experimental) | catalog + doc | `check_tree_data_grid.py` |
| **2.22** | `DashboardPage` | layout recipes (stable charts) | catalog + doc | `check_dashboard_recipes.py` |
| **2.23** | `BreadcrumbBarPage` | NavigationView breadcrumb sync | catalog + doc | `check_breadcrumb_integration.py` |
| **2.24** | `ItemsWrapGridPage` | `ItemsWrapGrid` (experimental) | catalog + doc | `check_items_wrap_grid.py` |
| **2.25** | `FormsHubPage`, templates | Form / Settings templates | catalog + doc | `check_form_templates.py` |
| **2.26** | `ChartsPage` | deferred sibling compose | **critical** | `check_charts_recipes.py` |
| **2.27** | `FeedbackHubPage`, `NotificationCenterPage` | `NotificationCenter` (experimental) | catalog + doc | `check_notification_feedback.py` |
| **2.28** | `PerformancePage`, `NavigationViewPage` | nav skip diagnostics | catalog + doc | `check_performance_wave6.py` |
| **2.29** | `AccessibilityPage`, `FileTreePage` | a11y wave 5 on 2.21…2.24 | **critical** (`AccessibilityPage`) | `check_accessibility_wave5.py` |
| **2.30** | — (checkpoint) | audit only | — | `check_checkpoint_230.py` |
| **2.31** | `CalendarViewPage` | `CalendarView` (experimental) | catalog + doc | `check_calendar_view.py` |
| **2.32** | `MediaPlayerElementPage`, `WebView2Page` | field matrix | **critical** (`WebView2Page`) | `check_media_webview_harden.py` |
| **2.33** | `SystemIntegrationPage` | Linux portal / tray wave 3 | **critical** | `check_linux_portal_tray.py` |
| **2.34** | `PackagingConsumerPage` | consumer matrix docs | catalog + doc | `check_packaging_consumer_matrix.py` |
| **2.35** | `I18nRtlPage` | `de_DE` seed + qsTr rules | **critical** (`I18nRtlPage`) | `check_localization_wave4.py` |
| **2.36** | `SecurityTrustPage`, `FileTreePage`, `TreeDataGridPage`, `WebView2Page` | path trust + download policy | catalog + doc | `check_security_trust_wave3.py` |
| **2.37** | `FlipViewPage`, `PipsPagerPage` | carousel recipes | catalog + doc | `check_pips_pager_carousel.py` |
| **2.38** | `ThemeOverridesPage`, `ThemePrefsPage`, `SettingsPage` | branding wave 2 | catalog + doc | `check_theme_overrides_wave2.py` |

**Smoke critical** = listed in `scripts/smoke_catalog.py` `CRITICAL` and loaded in Gallery `--smoke`. **Catalog + doc** = file exists in `ControlCatalog`, slice validator green, optional manual browse — not every experimental page is in the critical set (by design; see [checkpoint-230.md](checkpoint-230.md)).

---

## Pitfalls (2.39)

Gallery **Pitfalls** gained a **2.xx tranche** checklist:

- Experimental controls (`TreeDataGrid`, `ItemsWrapGrid`, `CalendarView`, `NotificationCenter`) — confirm [stable-api.md](stable-api.md) before product ship.
- Path trust on `FileTree` / `TreeDataGrid` — [security-trust.md](security-trust.md) wave 3.
- Theme accent pack demos — restore after Gallery (`ThemeOverridesPage._restoreTheme()`).
- WebView2 — gated URLs only; not a sandbox.

---

## Maintainer checklist

1. New **2.xx** control → add `ControlCatalog` entry + slice validator + row in this table.
2. Bump `recentlyShipped()` when the slice is user-facing recipe work (not checkpoint-only).
3. Extend Pitfalls when the slice introduces a repeatable footgun.
4. Run `python scripts/check_gallery_catalog_expansion.py` (hooked from `smoke_gallery.py`).

**Out of scope (2.39):** screenshot diff every page.
