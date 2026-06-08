---
name: quint
description: Expert in Quint formal specification language, simulator, model checking, and current CLI/docs behavior. Use for `.qnt` specs, Quint syntax, built-ins, `quint run|test|verify|repl|compile`, Apalache/TLC backends, invariants, temporal properties, and debugging Quint errors.
---

# Quint Skill

Use this skill for Quint language work, CLI usage, spec authoring, simulation, testing, REPL, and model checking.

## Source of truth

Prefer current docs over memory:

- Language manual: `https://quint-lang.org/docs/lang`
- CLI manual: `https://quint-lang.org/docs/quint`
- Built-ins: `https://quint-lang.org/docs/builtin`
- Repo/changelog: `https://github.com/informalsystems/quint`

Recent docs/changelog checked: through `v0.32.0` and docs updated June 2026.

## Version-sensitive guidance

Do not assume older Quint behavior. Important recent changes:

- `quint run` and `quint test` default backend is now `rust` since `v0.31.0`.
- Rust backend supports `test`, `repl`, `--seed`, `--n-traces`, `--witnesses`, `--mbt`, `--invariants`.
- Rust backend uses `i64` integers only. TypeScript backend still supports BigInts.
- `quint verify` supports `--backend=tlc` since `v0.31.0`.
- `leadsTo` temporal operator added in `v0.32.0`.
- Simple tuple/record destructuring added in `v0.30.0`.
- `case` is removed from current language docs. Prefer `if` / `else if` / `else` or `match` for sum types.
- `oneOf()` now handles empty sets differently than older guides implied; simulator behavior changed across recent releases. Do not promise older seed behavior matches newer versions.
- `--out-itf` no longer suppresses console output; `--verbosity` controls output.
- `run`/`verify` can take multiple invariants with `--invariants`.
- `q::debug` supports one-argument form.
- `apalache::generate` exists.
- Keywords `from`, `as`, `List`, `Set` can be identifiers.

If user asks for exact flag behavior, backend support, or semantics around recent releases, verify against docs/changelog first.

## Working style

When helping with Quint:

- Prefer minimal, executable specs.
- Keep examples current with present docs.
- Distinguish clearly between language semantics and backend/tool limitations.
- Say when a feature is backend-specific: TypeScript vs Rust vs Apalache vs TLC.
- For verification advice, prefer finite domains unless user explicitly wants symbolic/infinite reasoning.

## Current CLI guidance

### Install

```bash
npm i -g @informalsystems/quint
```

### Main commands

- `quint repl`
- `quint compile`
- `quint parse`
- `quint typecheck`
- `quint run`
- `quint test`
- `quint verify`
- `quint docs`

### Backend guidance

- `run` / `test`: default `rust`
- `repl`: docs still show default `typescript`; explicit `--backend=rust` supported
- `verify`: `apalache` default, `tlc` alternative

### When to choose each backend

- Use Rust backend for speed on simulation/tests with ordinary integer ranges fitting `i64`.
- Use TypeScript backend when spec relies on huge integers beyond signed 64-bit range.
- Use Apalache for symbolic bounded model checking.
- Use TLC for explicit-state finite models.

### High-value flags

`quint run`:

- `--init`, `--step`
- `--invariant` and `--invariants`
- `--seed`
- `--max-steps`, `--max-samples`
- `--n-traces`
- `--witnesses`
- `--hide`
- `--mbt`
- `--out-itf`
- `--backend=rust|typescript`

`quint test`:

- `--match`
- `--seed`
- `--max-samples`
- `--backend=rust|typescript`

`quint verify`:

- `--backend=apalache|tlc`
- `--init`, `--step`
- `--invariant`, `--invariants`
- `--inductive-invariant`
- `--temporal`
- `--max-steps`
- `--out-itf` (Apalache only)
- `--random-transitions` (Apalache only)
- `--apalache-config`
- `--tlc-config`

### Current caveats

- TLC cannot handle infinite domains.
- Apalache checks bounded behaviors; choose `--max-steps` consciously.
- Rust integer overflow matters. If user models huge counters/crypto-sized ints, recommend TypeScript backend for simulation/testing.
- Seeds can change behavior across Quint versions because simulator internals changed; promise reproducibility only within same tool version/backend.

## Language guidance

### Modes

Current docs recognize these modes:

- Stateless
- State
- Non-determinism
- Run
- Action
- Temporal

Do not blur action formulas and temporal formulas.

### Core module constructs

- `const`
- `assume`
- `var`
- `pure val` / `pure def`
- `val` / `def`
- `action`
- `run`
- `temporal`
- `type`
- `import`
- `export`

### Current syntax notes

- Lists are 0-indexed.
- Empty tuple `()` is valid and canonical unit type.
- Tuple and record destructuring is supported in simple forms.
- Trailing commas in parameter lists/operator calls are accepted.
- Multiple top-level modules per file are allowed; nested modules are not.
- Shadowing in nested scopes is allowed.
- No recursive operators.

### Removed or misleading older syntax

Do not teach these as current Quint:

- `case` as normal user-facing flow control. Current docs mark it removed.
- `unchanged` operator. Current docs mark it removed; use `orKeep` / `mustChange` patterns.
- `repeated`; use `reps`.
- `notin` builtin.

### Preferred control-flow patterns

Use `if (cond) a else b`:

```quint
pure def sign(x: int): str =
  if (x < 0) "neg" else if (x == 0) "zero" else "pos"
```

Use `match` for sum types:

```quint
type Result = Ok(int) | Err(str)

pure def unwrapOrZero(r: Result): int =
  match r {
    | Ok(n) => n
    | Err(_) => 0
  }
```

### Destructuring

Simple destructuring is current:

```quint
val (a, b) = pair
val { x, y } = point
```

If destructuring gets complex or tool errors appear, fall back to explicit field/tuple access.

## Built-ins worth knowing

### Sets

- `Set(...)`
- `exists`, `forall`
- `contains`, `in`
- `union`, `intersect`, `exclude`, `subseteq`
- `filter`, `map`, `fold`
- `powerset`, `flatten`
- `allLists`, `allListsUpTo`
- `chooseSome`, `oneOf`, `getOnlyElement`
- `isFinite`, `size`

### Lists

- `[ ... ]`
- `append`, `concat`
- `head`, `tail`, `length`, `nth`, `indices`
- `replaceAt`, `slice`, `range`, `select`, `foldl`

### Maps

- `Map(...)`
- `get`, `keys`
- `mapBy`, `setToMap`, `setOfMaps`
- `set`, `setBy`, `put`

### Actions / runs

- `x' = e`
- `assign`
- `then`
- `expect`
- `reps`
- `fail`
- `assert`

Important current semantics:

- `a.then(b)` reports error if `a` itself fails.
- `a.expect(p)` fails if action fails or predicate false in resulting state.

### Temporal

- `always`
- `eventually`
- `next`
- `orKeep`
- `mustChange`
- `enabled`
- `weakFair`
- `strongFair`
- `leadsTo`

Use `leadsTo(p, q)` or infix style if available in context to express progress properties.

### Debug / generation

- `q::debug(msg, value)`
- `q::debug(expr)`
- `apalache::generate(n)`

## Spec patterns

### Minimal state machine

```quint
module Counter {
  var x: int

  action init = x' = 0

  action step = any {
    x' = x + 1,
    x' = x,
  }

  val inv = x >= 0
  temporal live = eventually(x >= 3)
}
```

### Unit test

```quint
module CounterTest {
  var x: int

  run increments =
    (x' = 0)
      .then(x' = x + 1)
      .expect(x == 1)
}
```

### Fairness/property skeleton

```quint
module FairCounter {
  var x: int

  action init = x' = 0
  action step = any {
    x' = x + 1,
    x' = x,
  }

  temporal spec = init and always(step.orKeep(Set(x)))
  temporal fair = step.weakFair(Set(x))
  temporal progress = fair.implies(eventually(x >= 10))
}
```

## How to help users well

When user asks to write or debug Quint:

1. Check whether goal is simulation, tests, or model checking.
2. Pick backend with current defaults/limits in mind.
3. Keep domains finite if verification intended.
4. Prefer `match` over any stale `case` examples.
5. Mention integer-limit risk if Rust backend involved.
6. If CLI output differs from older blog/tutorials, trust current docs/changelog.

## Common corrections

If you see old guidance, correct it:

- `quint run` default backend is not always TypeScript anymore.
- `quint verify` can use TLC now.
- `case` examples are stale.
- `leadsTo` now exists.
- `--invariants` accepts multiple invariant names.
- `--out-itf` no longer implies quiet console.
- `q::debug` can take one argument.

## References

- Docs: `https://quint-lang.org/docs/`
- Language: `https://quint-lang.org/docs/lang`
- CLI: `https://quint-lang.org/docs/quint`
- Built-ins: `https://quint-lang.org/docs/builtin`
- Repo: `https://github.com/informalsystems/quint`
- Examples: `https://github.com/informalsystems/quint/tree/main/examples`
