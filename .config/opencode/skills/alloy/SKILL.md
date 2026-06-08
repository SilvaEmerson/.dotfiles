---
name: alloy
description: Alloy, Alloy 6, .als, sig, fact, pred, assert, run, check. Use when working on Alloy models, relational specs, bounded analysis, temporal modeling, or Alloy Analyzer workflow.
---

# Alloy Skill

Expert guidance for Alloy 6 relational modeling, bounded analysis, temporal modeling, and Alloy Analyzer workflow.

## Overview

Alloy is a temporal first-order relational logic plus a bounded model finder.

- Everything is a relation.
- Sets are unary relations.
- Scalars are singleton unary relations.
- Tuples are singleton relations.
- `run` finds examples.
- `check` finds counterexamples.
- Results depend on scope. Passing in one scope is not proof outside that scope.

The Alloy Analyzer compiles a model into a boolean formula and asks a SAT solver to solve it within a user-specified scope.

## Core Model Structure

Typical Alloy file shape:

```alloy
module filesystem

open util/ordering[State]

sig Node {}
sig Dir extends Node {
  entries: set Node
}

fact Acyclic {
  no d: Dir | d in d.^entries
}

pred show {}

assert NoSelfContainment {
  no d: Dir | d in d.entries
}

run show for 5
check NoSelfContainment for 5
```

Main building blocks:

- `module`: module header.
- `open`: import library or other modules.
- `sig`: declare sets of atoms.
- fields inside sigs: declare relations.
- `fact`: always-assumed constraints.
- `pred`: reusable boolean constraints.
- `fun`: reusable expressions.
- `assert`: property expected to follow from facts.
- `run`: search for satisfying instance.
- `check`: search for counterexample.

## Mental Model

Prefer relational thinking over object-oriented thinking.

- `x.f` is relational join, not ordinary method call.
- If `f` is partial and `x` is outside its domain, `x.f` is `none`.
- Constrain structure with relations and facts, then ask for examples or counterexamples.

When helping users:

- reduce problem to signatures, fields, and invariants.
- separate assumptions from intended properties.
- encode assumptions as `fact`.
- encode intended guarantees as `assert` and `check` them.
- start with tiny scopes and grow only as needed.

## Signatures

Signatures declare sets of atoms.

```alloy
sig User {}
one sig Root {}
lone sig Cache {}
some sig Session {}
abstract sig Resource {}
sig File, Dir extends Resource {}
sig Active in User {}
```

Important rules:

- top-level sigs are disjoint.
- `extends` creates a subtype tree.
- `in` creates subset sigs.
- subset sigs can overlap.
- `abstract` means members must belong to extending sigs.
- `one`, `lone`, `some` on sigs constrain cardinality.
- `var sig` makes signature mutable across states.

Use `extends` for partition-like taxonomies. Use `in` for tags, roles, or overlapping subsets.

## Fields And Relations

Fields are relations attached to sig atoms.

```alloy
sig User {
  manager: lone User,
  groups: set Group,
  home: one Dir
}

sig Group {}
sig Dir {}
```

Multiplicity on fields:

- `one`: exactly one target per source.
- `lone`: zero or one target per source.
- `some`: one or more targets per source.
- `set`: any number of targets.

Arrow multiplicity expresses function-like constraints:

```alloy
sig A {
  f: B -> one C,
  g: B lone -> lone C
}
```

Common patterns:

```alloy
sig User {
  // total function User -> Role
  role: one Role,

  // partial function User -> Manager
  mentor: lone User,

  // relation User <-> Group
  memberOf: set Group
}
```

## Relational Operators

Core operators:

- join: `.`
- product: `->`
- intersection: `&`
- union: `+`
- difference: `-`
- transpose: `~`
- transitive closure: `^`
- reflexive transitive closure: `*`
- override: `++`
- domain restriction: `<:`
- range restriction: `:>`
- cardinality: `#`

Examples:

```alloy
// parents of user u
u.parent

// inverse relation
~parent

// reachable nodes
root.*edges

// proper descendants
root.^edges

// keep only User rows
User <: memberOf

// replace tuples by domain
oldMap ++ newEntries
```

Useful reading hints:

- `a.b.c` associates left.
- closure operators `^` and `*` require binary relations.
- joins returning `none` are normal, not runtime failures.

## Quantifiers And Expressions

```alloy
all u: User | some u.home
some g: Group | no g.members
no disj u1, u2: User | u1.home = u2.home
one r: Root | some r
let admins = { u: User | u.role = Admin } | some admins
```

Common quantifiers:

- `all`
- `some`
- `no`
- `one`
- `lone`
- `sum`

Useful forms:

- comprehension: `{ x: S | F }`
- `let` bindings for readability.
- `disj` to force pairwise disjoint bindings.

## Facts, Predicates, Functions, Assertions

Use each for one job.

### Facts

Facts are assumptions. They always constrain the model.

```alloy
fact TreeShape {
  all n: Node | lone n.parent
  no n: Node | n in n.^parent
}
```

Bad habit: putting intended property in a fact. That can hide bugs by making bad states impossible instead of checkable.

### Predicates

Predicates package reusable constraints and scenarios.

```alloy
pred canAccess[u: User, r: Resource] {
  u.role = Admin or r in u.home.*entries
}
```

### Functions

Functions package reusable expressions.

```alloy
fun descendants[d: Dir]: set Node {
  d.^entries
}
```

### Assertions

Assertions are properties to test.

```alloy
assert NoCycles {
  no d: Dir | d in d.^entries
}
```

Then:

```alloy
check NoCycles for 6
```

## Commands And Scope

Safe command patterns:

```alloy
run show for 5
run show for 3 but 2 User, 4 Group
run show for exactly 3 User
run show for 4 Int
run show for 3 seq
run show for 5 steps
run show for 1..5 steps
run show for 1.. steps
check NoCycles for 6
```

Scope rules that matter:

- `for N` sets default scope for unlisted top-level sigs.
- `for 3 but 2 A, 4 B` overrides per sig.
- `exactly` fixes cardinality.
- `Int` scope sets integer bitwidth, not ordinary sig size.
- `seq` scope sets maximum sequence length.
- temporal commands can set `steps` bounds.

Practical workflow:

- start `for 3` or `for 4`.
- if property passes, rerun with larger scopes.
- if model slow, reduce sig count and bitwidth.
- use exact scopes only when model truly requires them.

## Integers And Sequences

Alloy has built-in integer support and sequence support.

- `Int` is built in.
- integer scope controls bitwidth.
- with bitwidth `4`, integer range is `-8 .. 7`.
- overflow can invalidate candidate instances.
- sequence length is controlled with `seq` in command scope.

Examples:

```alloy
run show for 4 Int
run show for 5 but 3 seq
```

Guidance:

- use integers only when needed.
- prefer small bitwidths.
- watch for silent modeling mistakes caused by overflow.
- do not treat `Int` scope like normal atom count.

## Modules And `open`

Use modules to split reusable specs.

```alloy
module access/control

open util/ordering[State]
open util/seqrel[Message] as msg
```

Notes:

- each `.als` file defines one module.
- imported names may need qualification.
- aliases help when opening same module more than once.
- `open` is for libraries and other model files.

## Temporal Modeling In Alloy 6

Alloy 6 adds native temporal modeling.

Key pieces:

- mutable state with `var sig` and `var` fields.
- next-state reference with prime `'`.
- future operators: `always`, `eventually`, `after`, `until`, `releases`.
- past operators: `before`, `historically`, `once`, `since`, `triggered`.
- sequence operator: `;`.

Trace model:

- semantic model is infinite trace.
- analyzer uses lasso traces.
- default temporal horizon is bounded unless user requests otherwise.

Minimal pattern:

```alloy
sig Process {}

var sig Running in Process {}

fact init {
  no Running
}

pred start[p: Process] {
  p not in Running
  Running' = Running + p
}

pred stop[p: Process] {
  p in Running
  Running' = Running - p
}

fact transitions {
  always some p: Process | start[p] or stop[p]
}

assert NeverOutsideUniverse {
  always Running in Process
}

check NeverOutsideUniverse for 4 but 6 steps
```

Temporal modeling advice:

- separate `init` from transition rules.
- constrain unchanged mutable relations when needed.
- write safety as `always P`.
- write liveness as `always (A implies eventually B)`.
- add fairness only after simpler checks.

Important subtlety:

- plain facts apply to initial state unless they explicitly use temporal operators.
- if a property must hold across the whole trace, wrap it in `always`.

## Analyzer Workflow

Recommended workflow when helping users:

1. Define smallest useful signatures and fields.
2. Run empty or trivial predicate to check consistency.
3. Add structural facts.
4. Write scenario predicates for intended situations.
5. Write assertions for guarantees.
6. `check` at small scope.
7. inspect counterexample.
8. refine model, not only command scope.
9. rerun at larger scope.

Good early checks:

```alloy
pred show {}
run show for 4
```

This often reveals accidental inconsistency fast.

## Command-Line Interface (CLI)

The default path to the .jar is `$HOME/.local/bin/alloy.jar`

Run models headless via the Alloy jar. No GUI needed.

```bash
# Dispatcher: invoke a subcommand on the jar
java -jar /path/to/alloy.jar <subcommand> [args]

# Execute every run/check command in a model
java -jar /path/to/alloy.jar exec model.als

# List the commands defined in a model
java -jar /path/to/alloy.jar commands model.als

# Misc
java -jar /path/to/alloy.jar version    # print version
java -jar /path/to/alloy.jar solvers    # list available SAT solvers
java -jar /path/to/alloy.jar natives    # native solvers per platform
java -jar /path/to/alloy.jar gui        # open the GUI
java -jar /path/to/alloy.jar lsp        # language server
```

Subcommands: `exec`, `commands`, `version`, `solvers`, `natives`, `prefs`, `gui`, `ls`/`lsp`. Bare `java -jar alloy.jar` prints the dispatcher help.

Reading `exec` output — one row per command, with `SAT`/`UNSAT`:

```
00. run   show                  0   1/1   SAT
01. check MyAssertion           0         UNSAT
```

- `run`  → `SAT` = instance found (good); `UNSAT` = over-constrained / inconsistent.
- `check` → `UNSAT` = no counterexample, property holds in scope (good);
            `SAT` = counterexample found (assertion violated).

`exec` writes a directory named after the source file (minus extension) containing solution instances and a `receipt.json`. Delete it after use if you only need the pass/fail verdict. On newer JDKs, native-solver `WARNING:` lines about restricted methods are harmless noise.

## Common Pitfalls

Watch for these first:

- putting desired theorem in a `fact` instead of an `assert`.
- assuming `check` success proves property universally.
- forgetting default scope is small.
- forgetting temporal facts need `always` when meant for all states.
- using `extends` when overlap needed; use `in` instead.
- overusing integers and making search harder.
- modeling partial functions but reasoning as if total.
- forgetting unchanged mutable relations in transition predicates.
- trying recursive predicates or functions. Alloy does not support recursive invocation.
- ambiguous overloaded fields or functions; disambiguate with `S <: f`.
- expecting subset sigs to have direct independent scope.

## Debugging Patterns

When a model fails unexpectedly:

- comment out assertions. Run base model.
- reduce to one command and tiny scope.
- ask whether inconsistency comes from facts or scope.
- turn complicated inline formulas into named predicates.
- inspect a concrete counterexample before rewriting large chunks.
- if ambiguity appears, qualify names or use restriction operators.

When a model is unsat:

- remove one fact at a time.
- relax multiplicities.
- remove `exactly` scopes first.
- check whether abstract sig has any extending sigs.
- check whether mutable subtype of static sig made design unintentionally static.

## Style Guidance

Prefer:

- small vocabularies.
- explicit names for important relations.
- one fact per concept.
- one assertion per property.
- scenario predicates for demonstrations.
- comments describing intent, not syntax.

Avoid:

- giant facts with unrelated constraints.
- mixing assumptions and desired guarantees.
- premature integer arithmetic.
- large scopes before model shape is stable.

## Solver Notes

Alloy Analyzer uses SAT solving for bounded analysis.

- MiniSat and ZChaff are good default choices for small problems.
- Berkmin may perform better on larger ones.
- Alloy 6 temporal model checking can also rely on external `NuSMV` or `nuXmv` for some workflows.
- `nuXmv` is generally preferred over `NuSMV` when available.

If unbounded temporal checking is requested, verify external solver setup and PATH availability.

## Assistant Behavior

When user asks for Alloy help:

- translate requirements into relations first.
- propose minimal model, then properties.
- favor counterexample-driven refinement.
- mention scope assumptions explicitly.
- include exact Alloy snippets, not pseudocode.
- if result depends on temporal intent, ask whether property is initial-state only or all states.
- if user wants proof-strength claims, state bounded-analysis limits clearly.

## Quick Reference

```alloy
// signatures
sig A {}
abstract sig B {}
sig C extends B {}
sig D in B {}
var sig E {}

// fields
sig User {
  group: set Group,
  home: one Dir,
  mentor: lone User
}

// facts / preds / funs / asserts
fact WellFormed { all u: User | one u.home }
pred show {}
fun descendants[d: Dir]: set Node { d.^entries }
assert NoCycles { no d: Dir | d in d.^entries }

// commands
run show for 5
check NoCycles for 5
run show for 3 but 4 User
run show for exactly 2 User
run show for 4 Int, 5 steps

// temporal
always P
eventually P
after P
historically P
once P
P until Q
P releases Q
```

## Resources

- Official docs: `https://alloytools.org/documentation.html`
- Alloy 6 language reference: `https://alloytools.org/spec.html`
- FAQ: `https://alloytools.org/faq/faq.html`
- Formal Software Design with Alloy 6: `https://haslab.github.io/formal-software-design/`
- GitHub repo: `https://github.com/AlloyTools/org.alloytools.alloy`
- DeepWiki repo docs: `https://deepwiki.com/AlloyTools/org.alloytools.alloy`

## Source Notes

This skill is grounded in official Alloy documentation, Alloy FAQ guidance, and repository-level architecture notes from DeepWiki for `AlloyTools/org.alloytools.alloy`.
