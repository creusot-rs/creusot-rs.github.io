+++
title = "Creusot"
[extra]
authors = [{ name = "Developed at Laboratoire Méthodes Formelles", url = "https://lmf.cnrs.fr/" }]
venue = { name = "wat" }
buttons = [
    {name = "Source", url = "https://github.com/creusot-rs/creusot", icon = "Code"},
    {name = "Install & Guide", url = "https://guide.creusot.rs/installation.html", icon = "Paper"},
    {name = "API", url = "https://doc.creusot.rs/creusot_std", icon = "Paper"},
    {name = "Tutorial", url = "https://github.com/creusot-rs/tutorial", icon = "Code"},
    {name = "Papers", url = "/research", icon = "Paper"},
    {name = "Devlog", url = "https://devlog.creusot.rs", icon = "Slides"},
    {name = "Zulip", url = "https://why3.zulipchat.com/#narrow/channel/341707-creusot", icon = "Zulip"}
]
large_card = false
+++

# Contracts for Rust, formally proved

Creusot helps you verify that your code is free of errors—panics, overflows, undefined behaviors,
*etc.*—by proving that it conforms to a formal specification.

Deductive verification provides high confidence in the correctness of your programs
by connecting code to specifications with mathematically rigorous proofs.

In Creusot, you will find the true meaning of "*if it compiles, it works*."

# Features

- **Pearlite**: the rich language of contracts in Creusot in which you specify the expected functional behavior of functions.

- **Prophecies**: the logical model that powers Creusot's first-class support for mutable borrows
while preserving the simplicity of first-order logic (as opposed to separation logic).

- **Termination checking**: prove that your programs terminate using variants and well-founded relations.

- **Ghost ownership**: a technique for verifying code featuring interior mutability, raw pointers, and/or atomics.

- **Automated solvers**: Creusot uses off-the-shelf SMT solvers to prove verification conditions. Multiple solvers can be used to leverage their respective strengths.

# Examples

## Sum from 1 to n

```rust
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

## Reasoning about mutable borrows

```rust
#[ensures(
    if b { result == x && ^y == *y }
    else { result == y && ^x == *x }
)]
pub fn choose<'a, T>(b: bool, x: &'a mut T, y: &'a mut T) -> &'a mut T {
    if b { x } else { y }
}
```

# How it works

Creusot leverages the Why3 Platform for program verification.
Creusot compiles Rust programs to [Coma, an intermediate verification language](https://coma.paulpatault.fr/), from which Why3 generates verification conditions to be dispatched to SMT solvers.

# [Related projects](./related-projects)
