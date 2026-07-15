# ADK + Regulus checkout — repo index & governance watch-list

Snapshot: **2026-07-15**. Working dir: `/Users/jz/code/adk`.

Eight are Google's **Agent Development Kit (ADK)** repos; one (`regulus`) is a
third-party **AI-governance / compliance layer** built on top of ADK-Java. The
reason to keep them checked out together: they are the closest public prior art
for the **AI + governance features** we want in Akka — ADK shows the *runtime
extension points* an agent framework exposes, and Regulus shows *what a
regulated-enterprise governance layer bolts onto those hooks*.

---

## Repositories

| Repo | Remote | Lang / build | What it is | HEAD (as of snapshot) |
|---|---|---|---|---|
| [adk-python](adk-python/) | `google/adk-python` | Python | Reference ADK implementation ("ADK 2.0"). Richest, most current feature set — watch here first. | 2026-07-14 |
| [adk-java](adk-java/) | `google/adk-java` | Java · Maven | Java ADK, `1.6.1-SNAPSHOT`. **The runtime Regulus targets.** Java-1.0 GA was Mar 2026. | 2026-07-14 |
| [adk-go](adk-go/) | `google/adk-go` | Go | Go ADK (`v2`). Independent plugin + A2A server implementation. | 2026-07-14 |
| [adk-js](adk-js/) | `google/adk-js` | TypeScript · npm | TS/JS ADK (`@google/adk`). Notably ships a `security_plugin.ts` in core. | 2026-07-14 |
| [adk-kotlin](adk-kotlin/) | `google/adk-kotlin` | Kotlin · Gradle · multiplatform | Kotlin ADK (`commonMain`). Closest idiom to Akka's Scala/JVM world. | 2026-07-14 |
| [adk-docs](adk-docs/) | `google/adk-docs` | Markdown (mkdocs) | Canonical cross-language docs. Start here for conceptual model. | 2026-07-14 |
| [adk-samples](adk-samples/) | `google/adk-samples` | Python + others | Official sample agents / recipes. | 2026-07-14 |
| [adk-web](adk-web/) | `google/adk-web` | Angular/TS | Dev-UI web front-end for driving/inspecting agents. | 2026-07-14 |
| [regulus](regulus/) | `neul-labs/regulus` | Java 21 · Gradle | **Third-party governance/compliance layer over ADK-Java.** "Where Google ADK ends, regulated builds begin." MIT. | 2026-07-02 |

> Provenance note: the ADK repos are Apache-2.0 Google projects; **Regulus is a
> Neul Labs product** ("Not endorsed by Google"). Treat it as competitive/prior-art
> reference, not as a Google artifact.

---

## Curated documentation links

**ADK — canonical docs** live at **[adk.dev](https://adk.dev)** (the old
`google.github.io/adk-docs` now 301s here). Language-agnostic; concept pages are
the same regardless of which SDK you use.

| Topic | Link | Why it matters for us |
|---|---|---|
| Docs home / get-started | [adk.dev](https://adk.dev) · [Quickstart](https://adk.dev/get-started/quickstart/) | Conceptual model, one read for all languages |
| **Plugins** (the hook) | [adk.dev/plugins](https://adk.dev/plugins/) | The governance interception contract — read first |
| **Callbacks** | [adk.dev/callbacks](https://adk.dev/callbacks/) | Per-agent hooks (vs. global plugins) |
| **Safety & security** | [adk.dev/safety](https://adk.dev/safety/) | Google's own guardrail guidance |
| Runtime & events | [adk.dev/runtime](https://adk.dev/runtime/) · [events](https://adk.dev/events/) | Run loop + event log (what the audit trail is built from) |
| Sessions / memory / artifacts | [adk.dev/sessions](https://adk.dev/sessions/) | Pluggable persistence SPIs (residency/retention) |
| A2A (agent-to-agent) | [adk.dev/a2a](https://adk.dev/a2a/) · [a2aprotocol.ai](https://a2aprotocol.ai) | Cross-agent/-org trust boundary |
| MCP | [adk.dev/mcp](https://adk.dev/mcp/) · [modelcontextprotocol.io](https://modelcontextprotocol.io) | External-tool boundary |
| Evaluation | [adk.dev/evaluate](https://adk.dev/evaluate/) | Eval harness shape |
| Observability | [adk.dev/observability](https://adk.dev/observability/) | Tracing/telemetry hooks |
| Release notes | [adk.dev/release-notes](https://adk.dev/release-notes/) | Track feature drift |

**Per-repo entry points**

| Repo | Docs / package |
|---|---|
| adk-python | [PyPI `google-adk`](https://pypi.org/project/google-adk/) · docs at [adk.dev](https://adk.dev) |
| adk-java | [Maven `com.google.adk:google-adk`](https://central.sonatype.com/artifact/com.google.adk/google-adk) · [Javadoc](https://javadoc.io/doc/com.google.adk/google-adk) |
| adk-go | [pkg.go.dev/google.golang.org/adk/v2](https://pkg.go.dev/google.golang.org/adk/v2) |
| adk-js | [npm `@google/adk`](https://www.npmjs.com/package/@google/adk) |
| adk-kotlin | [Maven `com.google.adk:google-adk-kotlin-core`](https://central.sonatype.com/artifact/com.google.adk/google-adk-kotlin-core) |
| adk-samples | [github.com/google/adk-samples](https://github.com/google/adk-samples) |
| adk-web | [github.com/google/adk-web](https://github.com/google/adk-web) |
| Community | [r/agentdevelopmentkit](https://www.reddit.com/r/agentdevelopmentkit/) |
| **Regulus** | [docs.neullabs.com/regulus](https://docs.neullabs.com/regulus/) · [regulus.neullabs.com](https://regulus.neullabs.com) · [Maven `com.neullabs`](https://central.sonatype.com/namespace/com.neullabs) |

**Comparators referenced below**

- LangChain4j — [docs.langchain4j.dev](https://docs.langchain4j.dev) · [github.com/langchain4j/langchain4j](https://github.com/langchain4j/langchain4j)
- Akka Agentic Platform — [doc.akka.io](https://doc.akka.io/) · [Agent component](https://doc.akka.io/java/agents.html) · [Ask Akka tutorial](https://doc.akka.io/getting-started/ask-akka-agent/the-agent.html)

---

## Project histories

Rough timeline, reconstructed from `git log` in each checkout (first-commit
dates) plus public announcements. Useful context: **ADK is young** — barely over
a year old — which is why the extension contract is still visibly settling and
why a third-party governance layer had room to exist.

| Milestone | When | Note |
|---|---|---|
| **adk-python** first commit | 2025-04-02 | The reference implementation; announced around Google Cloud Next '25 |
| adk-samples / adk-docs first commits | 2025-04-08 / 04-09 | Docs + samples landed within a week of the core |
| **adk-java** first commit | 2025-05-10 | Java port begins (internal seed) |
| adk-go / adk-web first commits | 2025-05-19 | Go port + the dev UI |
| **adk-js** upstreamed to git | 2025-08-14 | TS port made public (developed internally earlier) |
| **adk-java 1.0 GA** | ~2026-03 | Regulus README pegs it: it shipped "ten days ahead of ADK Java 1.0 GA" |
| **Regulus** first public release | 2026-03-20 | Neul Labs governance plane, on ADK-Java 1.2.0 |
| **adk-kotlin** first commit | 2026-05-13 | Newest language; multiplatform (`commonMain`) |
| Regulus 0.2.0 "enterprise security plane" | 2026-05-23 | Canonical identity, hash-chain audit, RFC 9421 A2A signing |

Where each sits **today** (snapshot 2026-07-15) — very different maturities:

- **adk-python** — by far the most active (~3,300 commits), tags in the **v2.x**
  line (`v2.4.0`). Treat as the leading indicator of where the contract goes.
- **adk-java** — ~1,150 commits, **v1.6.x**. The runtime Regulus targets; the
  one closest to Akka's JVM/enterprise audience.
- **adk-go** — ~470 commits, already **v2.0.0** (its own cadence).
- **adk-js** — ~400 commits, **v1.3.x**, split package tags (`adk-*`,
  `devtools-*`, `main-*`).
- **adk-kotlin** — youngest (~200 commits), tracking the others; the closest
  idiom to Scala/Akka.
- **adk-web / adk-docs / adk-samples** — supporting repos, high churn, follow core.
- **Regulus** — ~48 commits, **v0.2.1**, pre-1.0 (API may change between minors).
  Explicitly "tracking ADK releases since" — a live experiment in how a
  governance layer keeps pace with a moving base.

---

## The ADK extension surface — the hooks to watch

Every ADK language exposes the same core idea: a **plugin** (a.k.a. callback)
contract that fires at fixed points in the agent run loop. This is the single
most important thing to study — it is the shape any governance layer (theirs or
ours) has to hook into.

**Where it lives:**
- Python — [`adk-python/src/google/adk/plugins/`](adk-python/src/google/adk/plugins/) (`base_plugin.py`, `plugin_manager.py`)
- Java — [`adk-java/core/.../plugins/`](adk-java/core/src/main/java/com/google/adk/plugins/) (`BasePlugin`, `PluginManager`)
- Go — [`adk-go/plugin/`](adk-go/plugin/) + `internal/plugininternal/plugin_manager.go`
- Kotlin — [`adk-kotlin/core/.../plugins/`](adk-kotlin/core/src/commonMain/kotlin/com/google/adk/kt/plugins/) (`Plugin.kt`, `PluginManager.kt`)
- JS — [`adk-js/core/src/plugins/`](adk-js/core/src/plugins/) (`base_plugin.ts`, **`security_plugin.ts`**)

**The callback lifecycle** (canonical list, from `base_plugin.py`) — these are
the interception points:

```
on_user_message  →  before_run  →  before_agent
    →  before_model / after_model  (+ on_model_error)
    →  before_tool  / after_tool   (+ on_tool_error)
    →  on_event  →  after_agent  →  after_run
    (+ on_agent_error / on_run_error)
```

Governance value of each hook:
- **before_model / after_model** — policy checks, prompt/response redaction, model-risk gating, audit capture. The busiest one by far.
- **before_tool / after_tool** — tool authorization, argument validation, egress control.
- **before_agent / after_agent** — kill-switch, data-residency admission control.
- **on_\*_error** — failure capture for the audit trail.

**Adjacent extension points that matter for governance** (also worth tracking in each repo):
- **Tool confirmation / HITL** — ADK's human-in-the-loop primitive (`ToolConfirmation`). The hook for approval gates & dual control.
- **Session / Memory / Artifact services** — pluggable persistence SPIs; the place residency and retention are enforced at construction.
- **Event compaction** — retention/aging of the event log.
- **A2A (agent-to-agent)** — cross-agent RPC. Dirs: [`adk-java/a2a`](adk-java/a2a/), [`adk-go/server/adka2a`](adk-go/server/adka2a/), `adk-python/contributing/samples/a2a`. Trust-boundary surface for cross-org calls.
- **MCP (Model Context Protocol)** — external tool integration; the untrusted-tool boundary.

---

## Regulus — a worked governance layer over the hooks above

Regulus is the most useful single artifact here: it's a concrete answer to
"what does an enterprise governance layer *add* to a bare agent framework?"
Multi-module Gradle build under [`regulus/platform/`](regulus/platform/).

**How it maps onto ADK hooks** (from its README — this table is the crux):

| ADK hook | Regulus control |
|---|---|
| Inbound HTTP / SecurityContext | `OidcSecurityContextFilter` → `IdentityAdapter` → canonical `Identity` |
| `BeforeAgentCallback` | kill-switch, data-residency admission |
| `BeforeModelCallback` | identity-expiry guard → policy → privacy (redact) → model-risk |
| `AfterModelCallback` | privacy re-redact, audit (hash-chain sealed) |
| `BeforeToolCallback` | policy, model-risk (for code executors) |
| `ToolConfirmation` | dual-control kill-switch, vulnerable-customer HITL, Art. 22 |
| `EventCompactor` | regulation-aware retention |
| Session/Memory/Artifact services | residency-bound variants |
| A2A executor | RFC 9421 signed cross-org envelopes |

**Module map** ([`regulus/platform/core/`](regulus/platform/core/)) — the governance concerns enumerated:

| Concern | Module | Watch for |
|---|---|---|
| Canonical identity + adapter SPI | `regulus-ai-identity`, `-identity-bridge` | one `Principal`/`Claims` shape; OIDC/SAML/mTLS adapters |
| Policy engine | `regulus-ai-policy`, `-adk-plugins` (`DefaultPolicyEngine`, `PolicyDecision`) | allow/deny decisioning at each hook |
| Privacy / redaction | `regulus-ai-privacy` (`RegulusPrivacyPlugin`) | PII detection + mutating redaction pre/post model |
| Kill switch + dual control | `regulus-ai-kill-switch` (`KillSwitchStore`) | identity-gated activation, approver-distinctness |
| Audit / observability | `regulus-ai-observability` (`RegulusAuditPlugin`, `KafkaAuditSink`) | **SHA-256 hash-chained, tamper-evident** event log; offline verifier |
| Model risk / registry | `regulus-ai-model-registry`, `RegulusModelRiskPlugin` | model-risk tiering per tenant |
| Compliance profiles | `regulus-ai-compliance` | EU AI Act, GDPR/UK-GDPR, DORA, NIS2, FCA SYSC, PRA, NHS DSPT, EHDS |
| Governance frameworks | `regulus-ai-governance` | NIST AI RMF, ISO/IEC 42001 (SoA gen), 23894, 23053 |
| GRC export | `regulus-ai-grc-adapters` | ServiceNow IRM, OneTrust, MetricStream, HMAC webhook |
| A2A signing | `regulus-ai-adk-a2a` | RFC 9421 HTTP Message Signatures, nonce/replay |
| Packaging | `starters/*` (Spring Boot), `dsl/*` (Kotlin+YAML), `gradle-plugin`, `cli` | scaffold / doctor / scan / audit-verify |

**Governance docs worth reading directly:**
[`regulus/docs/governance/`](regulus/docs/governance/) — `kill-switch.md`,
`model-registry.md`, `risk-control-matrix.md`, `risk-simulation.md`,
`consumer-duty.md`, `governance-security.md`; and
[`regulus/docs/architecture/adk-extension-architecture.md`](regulus/docs/architecture/adk-extension-architecture.md).

---

## Compare & contrast — ADK vs LangChain4j vs Akka AI

Three points of the JVM/agent design space, worth holding side by side. (Python
ADK is the reference, but for *our* purposes the JVM story — ADK-Java, Regulus,
LangChain4j, Akka — is the relevant frame.)

| Axis | **Google ADK** | **LangChain4j** | **Akka Agentic Platform** |
|---|---|---|---|
| Origin / age | Google, first commit Apr 2025 | Community/OSS, JVM port of LangChain, mature 1.x | Lightbend/Akka, Agent component launched Jul 2025 |
| Primary shape | Opinionated **agent runtime** with a fixed run loop | **Library / unified API** over LLM providers + vector stores | **Full-stack platform**: runtime + orchestration + memory + streaming |
| Extension point | `BasePlugin` callbacks (`before/after {agent,model,tool}`) + per-agent callbacks | AiServices, tools, `ChatMemory`, **guardrails API**, `langchain4j-agentic` module | Agent component + Orchestration; governance/eval as platform features |
| Multi-agent | Workflow/graph agents + **A2A** | `langchain4j-agentic` (MCP + A2A sub-modules) | **Akka Orchestration** (sequential/parallel/hierarchical), durable |
| Memory | Pluggable `SessionService`/`MemoryService` SPIs | `ChatMemory` + community vector stores | **Akka Memory** — in-memory + durable, sharded/replicated across the cluster |
| Durability / resilience | Not intrinsic (bring your own persistence) | Not intrinsic | **Intrinsic** — durable execution, survives crashes; its core differentiator |
| Governance built-in? | Hooks exist; **guardrails are your job** (or Regulus's) | Guardrails API + provider abstraction; compliance not built-in | Built-in **agent/tool/resource registry**, inline eval, cost/quality interrupts |
| Deployment | Vertex Agent Engine / self-host | Embed in Quarkus/Spring Boot app | Akka runtime / self-managed cluster / Akka platform |
| Language reach | Py · Java · Go · JS · Kotlin | JVM (Java/Kotlin/Scala-callable) | JVM (Java SDK; Scala underneath) |

### vs LangChain4j
- **Same layer, different philosophy.** LangChain4j is the closest JVM analogue to ADK, but it's a **library** you compose, where ADK is a **runtime** you plug into. LangChain4j's `langchain4j-agentic` (MCP + A2A + agentic patterns) and **guardrails API** cover much of ADK's plugin surface, but as opt-in building blocks rather than a fixed lifecycle.
- **Directly relevant to Regulus:** Regulus's *legacy* examples ([`examples/quickstart`](regulus/examples/quickstart/), [`agent-demo`](regulus/examples/agent-demo/)) are on a **LangChain4j path**, retained as an "alternative runtime" — evidence the governance layer was first prototyped against LangChain4j before committing to ADK's `BasePlugin` contract. Tells us both frameworks were live candidates for a compliance overlay.
- **Takeaway for Akka:** LangChain4j shows the "unified provider API + guardrails" surface an enterprise expects; ADK shows the "fixed lifecycle to hook" surface. Akka needs a clear answer to *both* — a provider abstraction **and** a deterministic interception point.

### vs Akka AI
- **Different scope.** ADK (and LangChain4j) are agent frameworks; **Akka is a platform** — its pitch is runtime + orchestration + memory + streaming + governance as one integrated system. The overlap with ADK is the Agent component + governance registry; the non-overlap is Akka's **durable, fault-tolerant execution**, which ADK explicitly does not provide.
- **Where Akka is already ahead:** durability, cluster-native sharded/replicated memory, and orchestration are Akka's 15-year strengths — exactly the things ADK leaves to "bring your own." An ADK-style agent that crashes mid-run loses its work; an Akka agent is designed not to.
- **Where ADK/Regulus are ahead (the gap to close):** a **proper ordered plugin lifecycle** that a governance layer can attach to without patching the framework, and — critically — the **regulator-facing evidence model** Regulus builds (hash-chained tamper-evident audit, regulation-clause + framework-control-id per event, canonical identity plane, kill-switch dual control, ISO 42001 / EU AI Act mappings). Akka has an agent/tool/resource **registry** and inline eval; it does **not** yet advertise the audit-trail-as-legal-artefact story that Regulus makes its whole product.
- **The synthesis worth pursuing:** Akka's durable event journal is an unusually good foundation for exactly the tamper-evident, replayable audit trail Regulus hash-chains by hand. The differentiated Akka position is *governance evidence that falls out of the runtime's own durable event log* — rather than bolted on as plugins after the fact.

---

## Key areas to watch for Akka's AI + governance features

Concrete carry-overs when designing the equivalent Akka surface:

1. **A built-in plugin/callback lifecycle.** ADK's `before/after {agent,model,tool}` + `on_*_error` is the minimum viable interception surface. Any Akka agent runtime needs the analogue before governance can attach without patching the framework.
2. **Governance as plugins, not framework forks.** Regulus's whole thesis: every control is a `BasePlugin` on the *official* contract — "not Spring AOP, not bytecode rewriting." Design our hooks so a compliance layer never has to monkey-patch.
3. **Mutating pre/post-model hooks.** Redaction requires callbacks that can *rewrite* the request/response, not just observe. Confirm our callback contract allows mutation and defines ordering (Regulus runs expiry-guard → policy → privacy → model-risk).
4. **Deterministic plugin ordering + a manager.** All five ADK langs ship a `PluginManager`. Ordering is a governance-correctness property (guard must run first).
5. **Pluggable persistence SPIs (session/memory/artifact).** Residency & retention are enforced where these are *constructed*. Akka already has strong persistence primitives — this is a natural strength to lean on.
6. **Tamper-evident audit trail.** Hash-chained events + offline verifier is the differentiated bit auditors actually want. Akka's event-sourcing/journal story maps unusually well here — a potential advantage over ADK.
7. **Canonical identity plane.** One `Principal`/`Claims` with adapter SPI (OIDC/SAML/mTLS), tenant + jurisdiction as top-level claims on every decision and event.
8. **HITL / dual-control primitive.** ADK's `ToolConfirmation`; Regulus reuses it for kill-switch dual control with approver-distinctness. Decide our HITL primitive early — everything approval-shaped rides on it.
9. **Cross-org A2A trust boundary.** Signed envelopes (RFC 9421), replay protection, reconstruct caller identity *before* policy runs. Relevant if Akka agents federate across clusters/orgs.
10. **Framework/regulation mapping as data.** Regulus emits regulation-clause + framework-control-id + risk-tier *per event*. The evidence model (not just the enforcement) is half the product.

**Fastest way to re-orient after an ADK bump:**
`git -C adk-python log --oneline` for feature direction, then diff the
`plugins/` and services SPI dirs; check `regulus/CHANGELOG.md` for how the
governance layer reacted ("Tracking ADK releases since").
