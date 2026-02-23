---
name: quint
description: Skill for writing, reviewing, and explaining Quint specifications, particularly focused on actions, temporal properties, and typing.
---

# Quint Language Skill

Use this skill when you need to **write, review, or explain Quint specifications**, especially around **actions, temporal properties, and typing**.

## Quick Start Template

```quint
module Spec {
  // Constants & state
  const N: int
  var x: int

  // Stateless operators
  pure def clamp(v, lo, hi) =
    if (v < lo) lo else if (v > hi) hi else v

  // Initial state
  action init = x' = 0

  // Next-state relation
  action step = x' = x + 1

  // System behavior
  temporal spec = init.then(always(step))

  // Safety property
  temporal invariant = always(x >= 0)
}
```

---

## Core Language Concepts

### Modules & Declarations
- `module Name { ... }`
- `const` — constant (stateless, typed)
- `var` — state variable (typed)
- `pure val / pure def` — **stateless** operators
- `val / def` — **stateful** operators
- `action` — action-mode definition (uses primed vars)
- `temporal` — temporal formulas
- `assume` — constraints on constants
- `import` / `export`

### Modes (Expression Levels)
Quint separates expressions by **mode** (increasing power):
1. **Stateless** — no state access
2. **State** — can read `var`s
3. **Non‑determinism** — uses `oneOf`
4. **Action** — next‑state assignments `x' = e`
5. **Run** — sequences of actions
6. **Temporal** — temporal logic formulas

**Rule:** don’t mix modes incorrectly (e.g., action inside temporal directly).

---

## Types

Basic: `bool`, `int`, `str`

Complex:
- `Set[T]`, `List[T]`, `(T1, T2, ...)` tuples
- `{ field: T, ... }` records
- `T1 -> T2` functions
- `(T1, ..., Tn) => R` operator type
- Sum types:

```quint
type Option[a] = Some(a) | None
```

**Constants and variables require type annotations.**

---

## Literals & Comments

```quint
true false
0 1 100_000 0xFF
"string"
// line comment
/* block comment */
```

Special sets: `Int`, `Nat`

---

## Operators & Collections

### Boolean
`not`, `and`, `or`, `iff`, `implies`, `==`, `!=`

### Arithmetic
`+ - * / % ^` and comparisons `< <= > >=`

### Sets
```quint
Set(1,2,3)
S.union(T)      S.intersect(T)   S.exclude(T)
S.contains(x)   x.in(S)
S.map(x => e)   S.filter(x => p)
S.forall(x => p)  S.exists(x => p)
S.powerset()    S.size()
oneOf(S)        // nondet choice (S must be nonempty)
```

### Lists (0‑indexed!)
```quint
[1,2,3]
range(0, 3)       // [0,1,2]
l.length()
l[i] / l.nth(i)
l.append(x)       l.concat(t)
l.replaceAt(i,x)
l.slice(start,end)
l.foldl(init, (acc,v) => e)
```

### Maps / Functions
```quint
Map("a" -> 1, "b" -> 2)
f.get(k)
f.set(k, v)
f.setBy(k, old => old + 1)
S.mapBy(x => e)    // [x \in S |-> e]
```

### Records
```quint
{ a: 1, b: 2 }
r.a
r.with("a", 3)
{ a: 1, ...r }
```

### Tuples
```quint
(1, "x")
t._1  t._2
tuples(S1, S2)
```

### Sum Types & Matching
```quint
type Elem = S(str) | I(int)
match e {
  | S(s) => s
  | I(i) => "int"
}
```

---

## Control & Composition

### Conditional
```quint
if (p) e1 else e2
```

### Case (requires default)
```quint
case (
  | p1 -> e1
  | p2 -> e2
  | _  -> e_default
)
```

### Blocks
```quint
and { p1, p2, p3 }
or  { p1, p2, p3 }
all { a1, a2, a3 }
any { a1, a2, a3 }
```

### Lambdas
```quint
x => x * x
(x, y) => x + y
_ => 42
```

---

## Actions & State Updates

- Next‑state assignment: `x' = e` (or `x.assign(e)`)
- Each `var` is assigned **at most once per action**
- Use `all { ... }` to combine multiple assignments/guards

```quint
action step = {
  all {
    x' = x + 1,
    x' >= 0
  }
}
```

---

## Temporal Logic

```quint
always(p)       eventually(p)
next(p)         p.until(q)
p.releases(q)
enabled(action)
fairness(action)
```

Other helpers:
`p.orkeep(q)`, `p.mustChange(q)`

---

## Imports & Namespaces

```quint
import Math.*
import Voting(Value = Set(0,1)) as V
V::Value
export Math.*
```

---

## Common Pitfalls

1. **Lists are 0‑indexed** (unlike TLA+).
2. **No recursion** — use `map`, `filter`, `fold`.
3. **Case requires default** (`| _ -> ...`).
4. **oneOf requires nonempty set**.
5. **Mixing modes** (action vs temporal) is invalid.
6. **Every var assigned at most once per action.**

---

## When to Use This Skill

- Writing Quint specs, actions, or temporal properties.
- Translating TLA+ into Quint.
- Checking typing and mode correctness.
- Reviewing specs for safety/liveness mistakes.
