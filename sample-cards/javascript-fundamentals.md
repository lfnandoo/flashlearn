---
deck: JavaScript Fundamentals
---

# What are the primitive data types in JavaScript?

`string`, `number`, `bigint`, `boolean`, `undefined`, `null`, and `symbol`. Primitives are immutable and compared by value. Everything else (objects, arrays, functions) is a reference type.

---

# What is the difference between `let`, `const`, and `var`?

`var` is function-scoped and hoisted (initialized as `undefined`). `let` and `const` are block-scoped and hoisted but not initialized (Temporal Dead Zone). `const` prevents reassignment but doesn't make objects immutable. Prefer `const` by default, `let` when rebinding is needed.

---

# What are template literals?

Strings delimited by backticks that support interpolation (`${expr}`) and multi-line content without escape characters. Tagged templates (`tag\`...\``) let you process the string with a function — used by libraries like `styled-components` and `graphql-tag`.

---

# What is the difference between `==` and `===`?

`==` performs type coercion before comparing (e.g., `"1" == 1` is `true`). `===` checks value and type with no coercion. Always prefer `===` to avoid surprising coercion rules like `"" == false` being `true`.

---

# What is the difference between `null` and `undefined`?

`undefined` means a variable was declared but not assigned, or a property doesn't exist. `null` is an intentional assignment of "no value." `typeof undefined` is `"undefined"`, but `typeof null` is `"object"` (legacy bug from the first JS engine).

---

# How do `if`, `else if`, and `else` work?

Conditional branching. JavaScript evaluates conditions top-down and enters the first truthy branch. Values that are falsy: `false`, `0`, `-0`, `""`, `null`, `undefined`, `NaN`, `0n`. Everything else is truthy, including empty arrays and objects.

---

# What are arrow functions?

Compact function syntax: `(params) => expression` or `(params) => { statements }`. Key difference from regular functions: arrow functions don't have their own `this`, `arguments`, or `super` — they inherit `this` lexically from the enclosing scope. Cannot be used as constructors.

---

# What is destructuring?

Syntax for extracting values from arrays or properties from objects into variables. Array: `const [a, b] = [1, 2]`. Object: `const { name, age } = person`. Supports defaults (`{ x = 5 }`), renaming (`{ name: n }`), nesting, and rest patterns (`{ a, ...rest }`).

---

# What is the spread operator (`...`)?

Expands an iterable into individual elements. Array: `[...arr1, ...arr2]`. Object: `{ ...obj1, ...obj2 }` (shallow copy, later properties win). Function args: `fn(...args)`. Different from rest parameters, which collect multiple elements into an array in function signatures or destructuring.

---

# What are `map`, `filter`, and `reduce`?

`map` transforms each element → new array of same length. `filter` keeps elements passing a test → new array of equal or shorter length. `reduce((acc, item) => ..., initial)` accumulates all elements into a single value. All return new arrays/values — they don't mutate the original.

---

# What is `for...of` vs `for...in`?

`for...of` iterates over values of an iterable (arrays, strings, Maps, Sets). `for...in` iterates over enumerable property keys of an object (including inherited ones). Use `for...of` for arrays, `for...in` for object keys (or better, `Object.keys()`/`Object.entries()`).

---

# How does `try/catch/finally` work?

`try` wraps code that might throw. `catch(err)` handles the error. `finally` runs regardless of success or failure — useful for cleanup. You can throw any value, but best practice is to throw `Error` instances for stack traces. Errors not caught propagate up the call stack.

---

# What is a callback function?

A function passed as an argument to another function, to be called later. Common in async code (event listeners, `setTimeout`, file I/O). Callback hell (deeply nested callbacks) is solved by Promises and async/await. Node uses the error-first pattern: `callback(err, result)`.

---

# What are Promises?

An object representing the eventual completion or failure of an async operation. States: pending → fulfilled or rejected (settled). Chain with `.then(onFulfilled, onRejected)` and `.catch(onRejected)`. `.finally()` runs regardless. Promises are microtasks — they execute before the next macrotask (setTimeout, I/O).

---

# What is `async/await`?

Syntactic sugar over Promises. `async` functions always return a Promise. `await` pauses execution until the Promise settles. Use `try/catch` for error handling. `await` only works inside `async` functions (or at the top level of ES modules). Makes async code read like synchronous code.

---

# What is `this` in JavaScript?

Depends on call-site: method call → the object; plain function → `undefined` (strict) or `globalThis`; arrow function → lexically inherited from enclosing scope; `new` → the new instance; `call`/`apply`/`bind` → the explicitly provided value. Arrow functions and `bind` lock `this` permanently.

---

# What is a closure?

A function that retains access to variables from its outer (lexical) scope even after the outer function has returned. The closed-over variables live on the heap, not the stack. Common uses: data privacy, factory functions, partial application, maintaining state in callbacks.

---

# What is hoisting?

JavaScript moves declarations to the top of their scope before execution. `var` declarations are hoisted and initialized to `undefined`. `let`/`const` are hoisted but uninitialized (TDZ). Function declarations are fully hoisted (body included). Function expressions are not hoisted.

---

# What is the Temporal Dead Zone (TDZ)?

The period between entering a block scope and the `let`/`const` declaration being reached. Accessing the variable during TDZ throws a `ReferenceError`. Exists to catch use-before-declaration bugs that `var` hoisting silently allowed.

---

# What are classes in JavaScript?

Syntactic sugar over prototypal inheritance. `class Foo { constructor() {} method() {} }`. Support `extends` for inheritance, `super` to call parent, `static` methods, getters/setters, and private fields (`#field`). Under the hood, it's still prototype chain + constructor functions.

---

# What is the event loop?

JavaScript is single-threaded. The event loop runs continuously: execute the call stack → drain microtask queue (Promises, queueMicrotask, MutationObserver) → run one macrotask (setTimeout, setInterval, I/O, UI rendering) → repeat. Microtasks always fully drain before the next macrotask.

---

# What is event delegation?

Attaching a single event listener to a parent element instead of individual listeners on each child. Events bubble up the DOM, so the parent catches them. Check `event.target` to identify the source. More memory-efficient and works with dynamically added children.

---

# What is prototypal inheritance?

Objects inherit directly from other objects via the prototype chain. When a property isn't found on an object, the engine walks up `__proto__` until it finds it or reaches `null`. `class` is syntactic sugar. `Object.create(proto)` creates an object with a specific prototype.

---

# What is the difference between shallow copy and deep copy?

Shallow copy (`{ ...obj }`, `Object.assign`) copies top-level properties — nested objects are still shared references. Deep copy (`structuredClone()`, `JSON.parse(JSON.stringify())`) recursively copies everything. `structuredClone` handles circular refs and more types than the JSON trick (which fails on `Date`, `undefined`, functions, etc.).

---

# What is optional chaining (`?.`)?

Safely accesses nested properties without throwing if an intermediate value is `null`/`undefined`. `obj?.a?.b` returns `undefined` instead of throwing. Works with methods (`obj.fn?.()`) and bracket access (`obj?.[key]`). Combine with nullish coalescing: `obj?.name ?? 'default'`.

---

# What is the nullish coalescing operator (`??`)?

Returns the right operand when the left is `null` or `undefined` (not just falsy). `0 ?? 5` → `0`, `"" ?? "default"` → `""`. Unlike `||`, which treats `0`, `""`, and `false` as falsy and would return the right side. Use `??` when `0` or `""` are valid values.

---

# What is `Object.freeze()` vs `Object.seal()`?

`freeze`: properties can't be added, removed, or changed. `seal`: properties can't be added or removed, but existing ones can be modified. Both are shallow — nested objects are unaffected. Neither throws in non-strict mode; they silently fail. Use `structuredClone` + freeze for deep immutability.

---

# What are Symbols?

A primitive type for creating unique, non-string property keys. `Symbol('desc')` creates a unique symbol. Used for: meta-programming hooks (`Symbol.iterator`, `Symbol.toPrimitive`), truly private-ish properties (not enumerable in `for...in` or `Object.keys`), avoiding name collisions in libraries.

---

# What are iterators and iterables?

An iterable is any object with a `[Symbol.iterator]()` method that returns an iterator. An iterator has a `next()` method returning `{ value, done }`. Arrays, strings, Maps, Sets are built-in iterables. `for...of`, spread, and destructuring all consume iterables.

---

# What are generators?

Functions declared with `function*` that can pause with `yield` and resume. Calling returns an iterator. `yield` sends a value out; `iterator.next(val)` sends a value in. Useful for lazy evaluation, infinite sequences, custom iterables, and (historically) async flow control.

---

# What are WeakMap and WeakSet?

Collections where keys (WeakMap) or values (WeakSet) are held weakly — they don't prevent garbage collection. Keys must be objects (or symbols). Not iterable, no `.size`. Use cases: attaching metadata to DOM nodes or objects without memory leaks, caching computed results per object.

---

# What are tagged template literals?

A function called with a template literal: `` tag`Hello ${name}` ``. The tag receives an array of string parts and the interpolated values separately. Enables DSLs: `css\`color: red\``, `gql\`query { ... }\``, `html\`<div>...</div>\``. The tag can return anything, not just strings.

---

# What is `Proxy` and `Reflect`?

`Proxy` wraps an object and intercepts operations (get, set, delete, has, apply, construct, etc.) via handler traps. `Reflect` provides the default behavior for each trap. Use cases: validation, logging, reactive systems (Vue 3), auto-populating objects, access control. Powerful but adds overhead.

---

# What is the module system (ESM)?

ES Modules use `import`/`export` with static structure (analyzable at parse time). Named exports: `export { fn }` / `import { fn }`. Default export: `export default fn` / `import fn`. Tree-shaking works because imports are statically determinable. Modules are strict mode by default, have their own scope, and are evaluated once (singleton).

---

# What is `queueMicrotask` and how does it differ from `setTimeout`?

`queueMicrotask(fn)` schedules a microtask — runs after the current task but before any macrotask (rendering, setTimeout). `setTimeout(fn, 0)` schedules a macrotask — runs after microtasks and potentially rendering. Microtasks can starve the event loop if they keep queueing more microtasks.

---

# What is tail call optimization (TCO)?

When a function's last action is calling another function, the engine can reuse the current stack frame instead of adding a new one — preventing stack overflow for recursive functions. Only Safari implements TCO in strict mode. Other engines don't, so use iterative loops or trampolines for deep recursion.

---

# What is `FinalizationRegistry` and `WeakRef`?

`WeakRef` holds a weak reference to an object — doesn't prevent GC. `FinalizationRegistry` lets you register a callback that runs when an object is garbage collected. Use cases: caching, resource cleanup. Avoid relying on timing — GC is non-deterministic. These are last-resort APIs.

---

# What is the `structuredClone` algorithm?

The native deep-clone function. Handles circular references, `Date`, `RegExp`, `ArrayBuffer`, `Map`, `Set`, `Blob`, `File`, and more. Fails on functions, DOM nodes, and `Error` objects. Faster than `JSON.parse(JSON.stringify())` and handles more types. Available in browsers and Node 17+.

---

# What is `SharedArrayBuffer` and `Atomics`?

`SharedArrayBuffer` creates memory shared between the main thread and Web Workers — true shared memory, not message passing. `Atomics` provides atomic operations (load, store, add, compareExchange, wait, notify) to prevent race conditions. Requires `Cross-Origin-Isolation` headers (`COOP` + `COEP`).

---

# What is the TC39 proposal process?

How new features enter JavaScript. Stage 0: strawperson idea. Stage 1: formal proposal with champion. Stage 2: draft spec with initial semantics. Stage 2.7: spec text approved, tests written. Stage 3: candidate, ready for implementation. Stage 4: finished, included in the next ECMAScript edition. Takes years per feature.

---

# What is the difference between `Object.is()`, `===`, and `SameValueZero`?

`===` treats `+0 === -0` as `true` and `NaN === NaN` as `false`. `Object.is()` fixes both: `Object.is(+0, -0)` is `false`, `Object.is(NaN, NaN)` is `true`. `SameValueZero` (used by Map, Set, includes) is like `Object.is` but treats `+0` and `-0` as equal. Three slightly different equality semantics in one language.
