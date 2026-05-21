---
slug: blog/cupertino-v1-2-0-ironclad
title: "cupertino v1.2.0: lands the right Apple doc 9 times in 10"
description: Search-quality release. Rank-1 accuracy on canonical Apple API queries went from 52% to 92%, cross-validated on three independent corpora, zero regressions across 110 paired queries. No embeddings, no vector database, no reranker. Just BM25 over a schema-enriched FTS5 index, which is what Anthropic's published RAG recipe also keeps as its non-optional floor.
date: 2026-05-21
draft: false
image: /images/blog/cupertino-v1-2-0-ironclad/hero.png
---

# cupertino v1.2.0: lands the right Apple doc 9 times in 10

*Released 2026-05-20.*

## What you actually get

If you use Claude Desktop, Claude Code, Cursor, Zed, or any MCP-compatible AI agent to write Swift code, v1.2.0 is the upgrade where:

- Asking for `URLSession` async/await lands the modern API at rank 1, not a completion-handler page from 2017.
- Asking about `@Observable` doesn't fuse it with the older `ObservableObject`.
- Asking "what replaced `NSURLConnection`" goes straight to `URLSession`.
- Asking for a SwiftUI modifier finds the doc on the first try, not somewhere in the top 5.
- Asking your agent to compare Combine and AsyncSequence returns both pages, not a hallucinated synthesis of the two.
- The bundle is bigger and quieter: 352,712 indexed documents, zero poison rows across the 13-category audit. The agent has more to draw on and less garbage to wade through.

In plain numbers: 9 out of 10 canonical Apple API queries land the right page at rank 1 in v1.2.0, up from 5 out of 10 in v1.1.0. Same query against the same database, byte-identical result, no matter who runs it.

Upgrade is one command:

```bash
brew upgrade cupertino && cupertino setup
```

The rest of this post is for readers who want the receipts.

## The receipts

v1.2.0 is the release where every claim above can be re-derived from files in the repo.

The headline claim: rank-1 accuracy on a 50-query canonical-lookup corpus went from **52% in v1.1.0** to **92% in v1.2.0**. McNemar two-sided p ≤ 1e-5. Zero regressions across 110 paired queries. Cross-validated on two additional corpora.

If you doubt that, the methodology is at `docs/design/search-quality-eval.md`. The queries, the per-query rank movements, and the p-values are in `docs/audits/search-quality-*-v1.2.0.md`. The live page at <https://cupertino.aleahim.com/> is a thin renderer over those files. If a number is wrong on the page, an audit markdown is wrong; fix the markdown, push, watch the page change.

## The numbers, in one table, so we can move on

| Corpus | v1.1.0 | v1.2.0 | What moved |
|---|---:|---:|---|
| Canonical lookup (50 queries) | MRR 0.69, 26/50 rank-1 | MRR 0.95, 46/50 rank-1 | 20 queries climbed to rank 1 |
| Canonical lookup V2 (30 queries, zero overlap with the first set) | MRR 0.80, 19/30 rank-1 | MRR 0.95, 28/30 rank-1 | 9 queries climbed to rank 1 |
| Deprecation pairs (30 modern/legacy triples like `URLSession` vs `NSURLConnection`) | 27/30 prefers the modern variant | 30/30 prefers the modern variant | The three holdouts finally agree |

Three independent samples, same direction, similar effect size. Not a fluke.

## What changed

Three things changed. Each was boring on its own. They reinforced each other.

**The corpus got bigger and quieter.** 352,712 indexed documents in v1.2.0, up from 285,735 in v1.1.0. The new pages came from a 5.5-day crawl that picked up gaps in the last snapshot. 498 thin stubs got richer overwrites. 153 React-SPA-404 poison files (Apple's docs site occasionally serves a JS shell for pages that fail to render server-side; the indexer would dutifully save the shell as the page) were caught at the merge boundary. The 13-category poison audit on the merged corpus returns zero rows.

**The packages indexer learned to read `import` statements.** This sounds dull. It is the change with the largest visible effect. Pre-v1.2.0, `packages.db` knew that `pointfreeco/swift-composable-architecture` declared a Swift module named `ComposableArchitecture`. It did not know that `Reducer.swift` imported `Combine` and `SwiftUI`. After #860, every `.swift` file's `import X` lines are extracted into a new `package_imports` table. Coverage on the brew packages corpus jumped from 1 of 183 packages with `apple_imports_json` populated to 164 of 183. The `swift_tools_version` field went from 0 of 183 to 182 of 183 after #861 added a manifest-line-1 fallback.

**The search.db ranker started using columns it had been ignoring.** Schema `user_version` bumped 15 to 18 across #225, #668, #669, #673. The two that mattered: a `docs_structured` enrichment that fixed ~3.4% of pages the indexer was treating as near-empty, and an inheritance fallback that resolves class symbols that only document themselves through their parent's symbol set. The fallback alone was the difference between "this class has no docs" and "this class inherits from `NSObject`, here's what that means".

## The R in RAG, without the vectors

cupertino is the R in RAG and nothing else. The A (augmented context) and the G (generation) live in whatever MCP client you're using. cupertino's only job is to return the right Apple page when an LLM asks for one.

It does that without embeddings, without a vector database, without a reranker, without LLM-driven query rewriting. The substrate is SQLite FTS5 with BM25F (field-weighted BM25): title weights more than body, symbol-name weights more than prose, deprecated marker down-weights, exact framework match boosts. The columns BM25 ranks over are filled by an AST extraction pass at index time: symbol signatures, generic constraints, platform availability, isolation modifiers, deprecation. No LLM rewrites a chunk's preface before indexing. The structure is mechanical.

Anthropic's own published RAG recipe ([Contextual Retrieval](https://www.anthropic.com/news/contextual-retrieval), September 2024) keeps a BM25 stage alongside the dense one. Their best configuration is Contextual Embeddings + Contextual BM25 + a reranker, dropping top-20 retrieval failure from 5.7% to 1.9%. The BM25 stage is non-optional in that result.

cupertino's bet is that on an identifier-heavy, terminology-precise corpus like Apple's API docs, the BM25 stage alone gets you most of the way: 92% rank-1 on the canonical-lookup class. The trade-off is that the remaining 8% that pure BM25 can't catch is the class (prose, acronyms, attribute lookups) where dense retrieval would actually help. Those queries are documented one section down.

This is not an argument that vectors are wrong. It is an argument that for this corpus, on this query class, lexical-and-structural retrieval is sufficient on its own. Anthropic's recipe and cupertino's substrate agree on the floor: BM25 is non-optional. What you add on top of it is where the engineering trade-offs live.

## What still does not work

There is a section of the live page at <https://cupertino.aleahim.com/> titled "Standing weak spots". Three rows:

| Query class | Rank-1 | Status |
|---|---:|---|
| Prose / conceptual | ~27% | Open: design candidate, not yet measured |
| Acronym / synonym ("KVO", "GCD", "CALayer") | ~18% | Open: needs a new index pass |
| Symbol-attribute (querying by `actor type`, `initializer`, `Hashable conformance`, etc.) | P@5 ~0.25 | Open: default search path doesn't consult `doc_symbols` metadata |

These are not regressions against v1.1.0. They were weak then too. They are weak in v1.2.0. They will be weak in v1.2.0 forever, because the bundle is now frozen at that tag. v1.3.x is meant to move them. If it does, you will see the row change colour on the live page. If it does not, you will see the row keep its colour and you will know.

This is not a feature roadmap. It is a list of things the tool does badly, published next to the things it does well.

## "Ironclad"

The working name for this round was "ironclad". The intent, originally, was hardening: schema invariants, WAL checkpoint discipline, triage gates that catch a corrupted DB before you waste 12 hours re-indexing. All of that landed.

The name earned itself for a different reason. Every claim in this post is reproducible. Run `scripts/eval/search-quality-phase1.py` against the v1.2.0 bundle and you get byte-identical per-query rank assignments to what's on the live page. The methodology is `docs/design/search-quality-eval.md`. The audit markdown for every measurement is `docs/audits/search-quality-*-v1.2.0.md`. The live page is a thin renderer over those files. If a number changes on the page, an audit markdown changed first. Nothing on the page is curated copy.

"Ironclad" is not a metaphor. It is the property of being able to fail an audit and have nowhere to hide.

## Live page

<https://cupertino.aleahim.com/> shows:

- The three paired version-diff results (v1.1.0 → v1.2.0), per-query rank movement, McNemar and Wilcoxon p-values
- The seven absolute baselines (canonical, deprecation, cross-source, fragment, acronym, prose, symbol-attribute) measured at v1.2.0
- The "Standing weak spots" row, with open issue numbers
- Source citation on every card, linking back to the audit markdown the numbers were rendered from

It auto-rebuilds on every commit to `main`. If a number is wrong, find the audit markdown, fix it, push, watch the page change.

## Upgrade

```bash
brew upgrade cupertino
cupertino setup
```

`cupertino setup` pulls `cupertino-databases-v1.2.0.zip` (690 MiB compressed, sha256 `097d663341dcd16b05de8c33ebde96b310b689797c74f3450f4c31199af47747`) from the cupertino-docs repo's GitHub Releases. If you had v1.1.0 installed and rebuilt your databases locally, the migrator handles the schema bumps idempotently. Most people don't rebuild locally. Most people run `cupertino setup` and get the published bundle.

282 commits since v1.1.0. 120+ CHANGELOG entries. 2,408 tests across 347 suites, all green. Zero bug-labelled issues open at the moment the tag landed.

## Room for improvement

v1.2.0 is good at the queries it has been tuned for and bad at the queries it has not. Prose-and-conceptual, acronym/synonym, and symbol-attribute are all open. Each has an issue number, each has a candidate fix in design, none has a measurement attached yet.

v1.3.x is the round where those rows are supposed to move. If they do, the live page will say so. If they don't, the same page will say that too, in the same rows, without anyone editing copy.

That is the only release promise this post makes.

---

*Full release write-up: [docs/release-writeup-v1.2.0.md](https://github.com/mihaelamj/cupertino/blob/main/docs/release-writeup-v1.2.0.md). Source for every measurement: [docs/audits/search-quality-\*-v1.2.0.md](https://github.com/mihaelamj/cupertino/tree/main/docs/audits). Live page: <https://cupertino.aleahim.com/>.*
