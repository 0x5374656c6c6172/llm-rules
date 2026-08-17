# Incremental Changes

## Scope

Applies to all task execution, from planning and design through implementation and review.

## Statement

Break work into small, focused steps. Execute one step at a time and verify the result before moving to the next. Do not attempt to solve an entire problem in a single pass.

When a task is complex, decompose it into a sequence of manageable steps — each producing a verifiable outcome — and work through them incrementally.

## Rationale

Large, unstructured changes are harder to plan, harder to review, and more likely to introduce unintended side effects. Working incrementally makes progress visible, enables early detection of mistakes, allows for course correction at each step, and reduces the cognitive load of any single change.

## Examples

### Do

```text
# Plan for adding authentication:
# Step 1: define the data model for users
# Step 2: implement registration endpoint
# Step 3: implement login endpoint
# Step 4: add session management
# Step 5: write tests for each endpoint
```

### Don't

```text
# Attempt to build the entire auth system — model, endpoints,
# sessions, tests, and documentation — in one unstructured change.
```

## Exceptions

- The task is inherently atomic and cannot be decomposed further without adding unnecessary overhead.
- A pre-existing plan or specification already defines the decomposition and should be followed as-is.
