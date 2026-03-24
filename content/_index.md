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

Prophecies are the logical model that powers Creusot's first-class support for mutable borrows.

```rust
// Choose an integer depending on a boolean
//
// This specification says that the `result` is indeed `x` or `y`,
// but also that the other value is unchanged:
// the final value `^y` equals the initial value`*y`.
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

Pearlite is the language of contracts in Creusot for specifying Rust functions.
You can define new Pearlite functions and predicates,
and even declare Pearlite functions in traits!

```rust
// Pearlite predicate that a sequence `s` is sorted
#[logic(open)]
pub fn is_sorted(s: Seq<u64>) -> bool
{
    pearlite! {
        // A sequence `s` is sorted if `i < j` implies `s[i] <= s[j]`
        forall<i: Int, j: Int>
            0 <= i && i < j && j < s.len()
            ==> s[i] <= s[j]
    }
}

// Contract for sorting: the final slice `^s` is sorted
// and is a permutation of the initial slice `*s`
#[ensures(is_sorted((^s)@))]
#[ensures((^s)@.permutation_of((*s)@))]
pub fn sort(s: &mut [u64])
{
    // ...
}
```

## Termination checking

Prove that your programs terminate using variants and well-founded relations.

```rust
// Sum of integers from 1 to n
//
// Terminates
// Requires: the sum must not overflow
// Ensures: the result is the `n`-th triangular number
#[check(terminates)]
#[requires(n@ * (n@ + 1) / 2 <= u32::MAX@)]
#[ensures(result@ == n@ * (n@ + 1) / 2)]
pub fn sum_first_n(n: u32) -> u32 {
    let mut sum = 0;
    let mut i = 0;
    // The variant is a quantity that decreases at every iteration,
    // ensuring that the loop eventually stops.
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

A technique for verifying code featuring interior mutability, raw pointers, or atomics.

```rust
// Linked list: pointers to the first and last links,
// and a ghost sequence of pointer permissions (`Perm`)
pub struct List<T> {
    // actual data
    first: *const Link<T>,
    last: *const Link<T>,
    // ghost
    seq: Ghost<Seq<Box<Perm<*const Link<T>>>>>,
}

// Link of a linked list: value and pointer to the next link
struct Link<T> {
    value: T,
    next: *const Link<T>,
}

// ...

// Insert an element in a linked list
#[check(terminates)]
#[ensures((^self)@ == (*self)@.push_front(value))]
pub fn push_front(&mut self, value: T) {
    // Allocate a new `Link` and get the pointer and the permission to that allocation
    let (link_ptr, link_own) = Perm::new(Link { value, next: self.first });
    // Update the end pointers of the linked list
    self.first = link_ptr;
    if self.last.is_null() {
        self.last = link_ptr;
    }
    // Push the permission into the list
    ghost! { self.seq.push_front_ghost(link_own.into_inner()) };
}
```

Full example: [`linked_list.rs`](https://github.com/creusot-rs/creusot/blob/master/examples/linked_list.rs)

## Automated solvers

Creusot calls off-the-shelf SMT solvers to prove verification conditions.
Multiple solvers can be used to leverage their respective strengths. Not everything can be automated, of course. To make this method work, you still have to annotate functions with contracts and loops with loop invariants.

# How it works

Creusot leverages the Why3 Platform for program verification.
Creusot compiles Rust programs to [Coma, an intermediate verification language](https://coma.paulpatault.fr/), from which Why3 generates verification conditions to be dispatched to SMT solvers.

# [Related projects](./related-projects)
