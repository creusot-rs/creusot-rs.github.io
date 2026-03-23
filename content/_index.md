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

# Features & Examples

## Prophecies

Prophecies are the logical model that powers Creusot's first-class support for mutable borrows
while preserving the simplicity of first-order logic (as opposed to separation logic).

```rust
// Choose an integer depending on a boolean
#[ensures(
    if b { result == x && ^y == *y }
    else { result == y && ^x == *x }
)]
pub fn choose<'a, T>(
    b: bool,
    x: &'a mut T,
    y: &'a mut T,
) -> &'a mut T {
    if b { x } else { y }
}
```

## Pearlite

Pearlite is the rich language of contracts in Creusot in which you specify the expected functional behavior of functions.

```rust
// A sequence is sorted
#[logic(open)]
pub fn is_sorted<T>(s: Seq<T>) -> bool
where
    T: DeepModel,
    T::DeepModelTy: OrdLogic,
{
    pearlite! {
        forall<i: Int, j: Int>
            0 <= i && i < j && j < s.len()
            ==> s[i].deep_model() <= s[j].deep_model()
    }
}

// Contract for sorting
#[ensures(is_sorted((^s)@))]
#[ensures((^s)@.is_permutation((*s)@))]
pub fn sort<T>(s: &mut [T])
where
    T: DeepModel,
    T::DeepModelTy: OrdLogic,
{
    // ...
}
```

## Termination checking

Prove that your programs terminate using variants and well-founded relations.

```rust
// Sum from 1 to n
#[check(terminates)]
#[requires(n@ * (n@ + 1) / 2 <= u32::MAX@)]
#[ensures(result@ == n@ * (n@ + 1) / 2)]
pub fn sum_first_n(n: u32) -> u32 {
    let mut sum = 0;
    let mut i = 0;
    #[variant(n@ - i@)]
    #[invariant(sum@ == i@ * (i@ + 1) / 2)]
    #[invariant(i@ <= n@)]
    while i < n {
        i += 1;
        sum += i;
    }
    sum
}
```

## Ghost ownership

A technique for verifying code featuring interior mutability, raw pointers, and/or atomics.

```rust
// ...
```

## Automated solvers

Creusot uses off-the-shelf SMT solvers to prove verification conditions. Multiple solvers can be used to leverage their respective strengths. Not everything can be automated, of course. To make this method work, you still have to annotate functions with contracts and loops with loop invariants.

# How it works

Creusot leverages the Why3 Platform for program verification.
Creusot compiles Rust programs to [Coma, an intermediate verification language](https://coma.paulpatault.fr/), from which Why3 generates verification conditions to be dispatched to SMT solvers.

# [Related projects](./related-projects)
