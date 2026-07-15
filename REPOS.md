# ADK + Regulus checkout — repo index & governance watch-list

Snapshot: **2026-07-15**. Working dir: `/Users/jz/code/adk`.

Eight are Google's **Agent Development Kit (ADK)** repos; one (`regulus`) is a
third-party **AI-governance / compliance layer** built on top of ADK-Java. The
reason to keep them checked out together: they are the closest public prior art
for the **AI + governance features** we want in Akka — ADK shows the *runtime
extension seams* an agent framework exposes, and Regulus shows *what a
regulated-enterprise governance layer bolts onto those seams*.

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

## The ADK extension surface — the seams to watch

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

Governance value of each seam:
- **before_model / after_model** — policy checks, prompt/response redaction, model-risk gating, audit capture. The busiest governance seam.
- **before_tool / after_tool** — tool authorization, argument validation, egress control.
- **before_agent / after_agent** — kill-switch, data-residency admission control.
- **on_\*_error** — failure capture for the audit trail.

**Adjacent seams that matter for governance** (also worth tracking in each repo):
- **Tool confirmation / HITL** — ADK's human-in-the-loop primitive (`ToolConfirmation`). The hook for approval gates & dual control.
- **Session / Memory / Artifact services** — pluggable persistence SPIs; the place residency and retention are enforced at construction.
- **Event compaction** — retention/aging of the event log.
- **A2A (agent-to-agent)** — cross-agent RPC. Dirs: [`adk-java/a2a`](adk-java/a2a/), [`adk-go/server/adka2a`](adk-go/server/adka2a/), `adk-python/contributing/samples/a2a`. Trust-boundary surface for cross-org calls.
- **MCP (Model Context Protocol)** — external tool integration; the untrusted-tool boundary.

---

## Regulus — a worked governance layer over the seams above

Regulus is the most useful single artifact here: it's a concrete answer to
"what does an enterprise governance layer *add* to a bare agent framework?"
Multi-module Gradle build under [`regulus/platform/`](regulus/platform/).

**How it maps onto ADK seams** (from its README — this table is the crux):

| ADK seam | Regulus control |
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
| Policy engine | `regulus-ai-policy`, `-adk-plugins` (`DefaultPolicyEngine`, `PolicyDecision`) | allow/deny decisioning at the seams |
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

## Key areas to watch for Akka's AI + governance features

Concrete carry-overs when designing the equivalent Akka surface:

1. **A first-class plugin/callback lifecycle.** ADK's `before/after {agent,model,tool}` + `on_*_error` is the minimum viable interception surface. Any Akka agent runtime needs the analogue before governance can attach non-invasively.
2. **Governance as plugins, not framework forks.** Regulus's whole thesis: every control is a `BasePlugin` on the *official* contract — "not Spring AOP, not bytecode rewriting." Design our seams so a compliance layer never has to monkey-patch.
3. **Mutating pre/post-model hooks.** Redaction requires callbacks that can *rewrite* the request/response, not just observe. Confirm our seam contract allows mutation and defines ordering (Regulus runs expiry-guard → policy → privacy → model-risk).
4. **Deterministic plugin ordering + a manager.** All five ADK langs ship a `PluginManager`. Ordering is a governance-correctness property (guard must run first).
5. **Pluggable persistence SPIs (session/memory/artifact).** Residency & retention are enforced where these are *constructed*. Akka already has strong persistence primitives — this is a natural strength to lean on.
6. **Tamper-evident audit trail.** Hash-chained events + offline verifier is the differentiated bit auditors actually want. Akka's event-sourcing/journal story maps unusually well here — a potential advantage over ADK.
7. **Canonical identity plane.** One `Principal`/`Claims` with adapter SPI (OIDC/SAML/mTLS), tenant + jurisdiction as first-class claims on every decision and event.
8. **HITL / dual-control primitive.** ADK's `ToolConfirmation`; Regulus reuses it for kill-switch dual control with approver-distinctness. Decide our HITL primitive early — everything approval-shaped rides on it.
9. **Cross-org A2A trust boundary.** Signed envelopes (RFC 9421), replay protection, reconstruct caller identity *before* policy runs. Relevant if Akka agents federate across clusters/orgs.
10. **Framework/regulation mapping as data.** Regulus emits regulation-clause + framework-control-id + risk-tier *per event*. The evidence model (not just the enforcement) is half the product.

**Fastest way to re-orient after an ADK bump:**
`git -C adk-python log --oneline` for feature direction, then diff the
`plugins/` and services SPI dirs; check `regulus/CHANGELOG.md` for how the
governance layer reacted ("Tracking ADK releases since").
