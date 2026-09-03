# Certified Received — prototype review environment (spike)

Personal spike by Cristhian implementing `SPEC-prototype-review-environment.md` from the
`certified-received` planning repo, so the idea can be seen working before bringing it to
Exequiel/Engineering for the real `koombea/certified-received-prototype` repo.

Not affiliated with Koombea's build — Rails app generated fresh, SQLite instead of Postgres,
one screen instead of the real 23-screen catalog. The point of this repo is the **review/tooling
layer**, not product breadth.

## Two layers

- **`app/**/product/**`, routes under `/product/*`** — Layer 1, the product. Pure screens, no
  tooling chrome. This is what would ship to a real `main`.
- **`ScreensController`, `app/views/screens/**`, `app/views/layouts/tooling.html.erb`,
  `app/javascript/controllers/tooling_controller.js`** — Layer 2, the review tooling: catalog
  index, device toggle, scenario selector, email/notification overlay. Deliberately isolated so
  it's easy to keep out of a real `main` later (drop the namespace, gate the routes, whatever
  Engineering decides).

`ScreenCatalog` (`app/models/screen_catalog.rb`) is the seeded, deterministic registry of
screens × scenarios — no DB, no randomness, no wall-clock, per the spec.

## Run it

```bash
bin/dev
```

Then open `http://localhost:3000/screens` for the catalog, or `http://localhost:3000/screens/claim`
directly.

## What's implemented

- **Control A — device toggle.** Real `<iframe>` at a device width, not a fixed-width `div`
  (the Myylestone lesson the spec calls out — a div breaks `vw`/`vh`/`@media`).
- **Control B — scenario selector.** URL-per-scenario (`?scenario=...`), bookmarkable, reloads
  both the wrapper and the iframed product screen against the new seed.
- **Control C — email/notification overlay.** Floating button with a badge count, opens an
  independent modal mailbox above the browser view (not a navigation of the product iframe).
  Reading an email shows the invitation number; closing returns to the product screen untouched.
  "Type-it-not-click-it" is honored literally — the claim field accepts any value and doesn't
  validate yet, per the spec's interim decision.
- **Tokens.** Two separate `@theme` namespaces in `app/assets/tailwind/application.css`:
  `--color-product-*` (brand) and `--color-tool-*` (deliberately neutral "paper" chrome) — no
  inline styles, no hardcoded colors anywhere in the views/JS.

## What's not here yet

- Only one screen (`claim`) and 4 scenarios, to prove the mechanism — not the full CR catalog.
- No harness/CI gate (the real repo's `/design-review` + 3 confirmed rules) — this is a personal
  spike, not the client-facing repo.
- Postgres, Devise, the sealing/anchoring pipeline — none of that; this only spikes the tooling
  layer, not the product build.

See the source repo's `atlas/design/SPEC-prototype-review-environment.md` and
`atlas/design/prototype-workflow-and-harness.md` for the full context and open decisions.
