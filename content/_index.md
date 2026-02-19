+++
title = "Creusot"
[extra]
authors = [{ name = "Developed at Laboratoire Méthodes Formelles", url = "https://lmf.cnrs.fr/" }]
venue = { name = "wat" }
buttons = [
    {name = "Source", url = "https://github.com/creusot-rs/creusot", icon = "Code"},
    {name = "Install", url = "https://creusot-rs.github.io/creusot/guide/installation.html", icon = "Paper"},
    {name = "Tutorial", url = "https://github.com/creusot-rs/tutorial", icon = "Paper"},
    {name = "Papers", url = "/research", icon = "Paper"},
    {name = "Devlog", url = "https://creusot-rs.github.io/devlog/", icon = "Slides"}
]
large_card = false
+++

# Contracts for Rust, formally proved

Creusot helps you verify that your code is free of errors—panics, overflows, undefined behaviors, *etc.*—by proving that it conforms
to a formal specification.

Deductive verification provides high-assurance in the correctness of your programs.
It combines a specification language which is both expressive and precise,
with a formal logic where proofs soundly connect programs and specifications.

In Creusot, you will find the true meaning of "*if it compiles, it works*."

# Features

- **Pearlite**: the rich language of contracts in Creusot,
enabling you to specify the expected functional behavior of functions.

- **Prophecies**: the flexible logical model of mutable borrows at the core of Creusot.

- **Ghost ownership**: a technique for verifying code featuring interior mutability, including raw pointers and atomic variables.

- **Termination checking**: prove that your programs terminate using variants and well-founded relations.

# Verified examples

```rust
/// Choose one of two mutable borrows using a boolean
#[ensures(
    if b { result == x && ^y == *y }
    else { result == y && ^x == *x }
)]
pub fn choose<'a, T>(b: bool, x: &'a mut T, y: &'a mut T) -> &'a mut T {
    if b { x } else { y }
}
```

```rust
/// Sum of integers from 1 to n
#[requires(n@ * (n@ + 1) / 2 <= u32::MAX@)]
#[ensures(result@ == n@ * (n@ + 1) / 2)]
pub fn sum_first_n(n: u32) -> u32 {
    let mut sum = 0;
    let mut i = 0;
    #[invariant(sum@ == i@ * (i@ + 1) / 2)]
    #[invariant(i@ <= n@)]
    while i < n {
        i += 1;
        sum += i;
    }
    sum
}
```

# How it works

Creusot leverages the Why3 Platform for program verification.
Creusot compiles Rust programs to [Coma, an intermediate verification language](https://coma.paulpatault.fr/), from which Why3 generates verification conditions to be dispatched to SMT solvers.

# Credits

Creusot is powered by the following projects:

- [Rust](https://rust-lang.org)
- [Why3](https://www.why3.org/)
- [Why3find](https://git.frama-c.com/pub/why3find)
- SMT Solvers:

    - [Alt-ergo](https://alt-ergo.ocamlpro.com/)
    - [Z3](https://github.com/Z3Prover/z3)
    - [CVC5](https://cvc5.github.io/), [CVC4](https://cvc4.github.io/)

# A big family

Creusot is but one in a long line of formal verification tools,
going all the way back to the fundamental idea of [Floyd-Hoare logic](https://en.wikipedia.org/wiki/Hoare_logic).

The following is not an exhaustive list of related tools.

For Rust:

- [Verus](https://github.com/verus-lang/verus)
- [Refined Rust](https://plv.mpi-sws.org/refinedrust/)
- [Aeneas](https://github.com/AeneasVerif/aeneas)
- [Verifast](https://verifast.github.io/verifast/rust-reference/intro.html)
- [Flux](https://flux-rs.github.io/flux/)

Other languages:

- [WhyML](https://www.why3.org/)
- [SPARK Ada](https://www.adacore.com/languages/spark)
- [Frama-C](https://www.frama-c.com/)
- [F*](https://fstar-lang.org/)
