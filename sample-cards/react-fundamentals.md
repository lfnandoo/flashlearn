---
deck: React Fundamentals
---

# What is React?

A JavaScript library for building user interfaces using components. Components are functions (or classes) that return JSX describing what the UI should look like. React efficiently updates the DOM when data changes through a process called reconciliation.

---

# What is JSX?

A syntax extension that lets you write HTML-like markup inside JavaScript. `<div className="box">{name}</div>` compiles to `React.createElement('div', { className: 'box' }, name)`. Differences from HTML: `className` instead of `class`, `htmlFor` instead of `for`, camelCase attributes, self-closing tags required.

---

# What is the difference between a component and an element?

A component is a function (or class) that returns React elements. An element is a plain object describing what to render: `{ type: 'div', props: { children: 'hi' } }`. JSX creates elements. Elements are cheap to create; components are the blueprints that produce them.

---

# What is `useState`?

A hook that adds state to function components. `const [value, setValue] = useState(initialValue)`. Calling `setValue` triggers a re-render. Pass a function to `setValue(prev => prev + 1)` when the new state depends on the previous. Initial value can also be a function (lazy initialization) for expensive computations.

---

# What are props?

Data passed from parent to child component. Read-only — a child must never modify its own props. Any JS value can be a prop: strings, numbers, objects, functions, even other components. `children` is a special prop containing whatever is between opening and closing tags.

---

# How does conditional rendering work?

Use JavaScript expressions inside JSX: ternary (`{cond ? <A /> : <B />}`), logical AND (`{cond && <A />}`), or early return. No special template syntax. Watch out: `{0 && <A />}` renders `0`, not nothing — use `{count > 0 && <A />}` instead.

---

# How do you render lists in React?

Use `array.map()` inside JSX: `{items.map(item => <li key={item.id}>{item.name}</li>)}`. Every list item needs a stable, unique `key` prop so React can track which items changed, moved, or were removed. Never use array index as key if the list can be reordered.

---

# What is the `key` prop and why does it matter?

A special prop that identifies list items during reconciliation. Must be stable and unique among siblings. Using array index as key causes bugs when the list is reordered — items get wrong state. Use IDs from your data. Keys also force remounting when changed on a single element.

---

# What is `useEffect` and when does it run?

A hook for side effects: fetching data, subscriptions, DOM manipulation, timers. Runs after render. Dependency array controls timing: `[]` = mount only, `[a, b]` = when a or b changes, omitted = every render. Return a cleanup function for teardown (runs before the next effect and on unmount).

---

# What is the difference between controlled and uncontrolled components?

Controlled: React state drives the input value (`value={state}` + `onChange`). Uncontrolled: the DOM manages the value, accessed via `ref`. Controlled gives full control (validation, formatting, conditional updates). Uncontrolled is simpler for quick forms.

---

# How do you handle events in React?

Pass event handlers as props: `<button onClick={handleClick}>`. Handlers receive a `SyntheticEvent` (cross-browser wrapper). No need for `addEventListener`. Arrow functions in JSX (`onClick={() => fn(id)}`) are fine for most cases — memoize with `useCallback` only if causing measurable performance issues.

---

# What are fragments?

`<React.Fragment>` or shorthand `<>...</>` lets you group multiple elements without adding an extra DOM node. Useful when a component needs to return siblings. The long form supports `key`: `<Fragment key={id}>` — needed when rendering fragments in a list.

---

# What is lifting state up?

When two sibling components need to share state, move that state to their closest common parent. The parent passes the state down as props and provides a callback to update it. This is React's primary mechanism for sharing state between components without a global store.

---

# What is React Context?

A way to pass data through the tree without prop drilling. `createContext(default)` → `<Context.Provider value={...}>` → `useContext(Context)`. Every consumer re-renders when the context value changes (referential equality). Split contexts by update frequency or memoize values to avoid unnecessary re-renders.

---

# What is `useRef`?

Returns a mutable object `{ current: initialValue }` that persists across renders without causing re-renders when mutated. Two uses: 1) DOM node access: `<div ref={myRef}>`. 2) Mutable instance variable: storing timers, previous values, flags that shouldn't trigger renders.

---

# What is the difference between `useEffect` and `useLayoutEffect`?

`useEffect` fires asynchronously after the browser paints — preferred for most side effects. `useLayoutEffect` fires synchronously after DOM mutations but before paint — use for DOM measurements or mutations that must happen before the user sees the update (prevents visual flicker). Blocking paint means slower renders if overused.

---

# What is `useMemo`?

Memoizes a computed value: `const result = useMemo(() => expensive(a, b), [a, b])`. Recomputes only when dependencies change. Use when you have actually expensive calculations or need referential stability for objects/arrays passed to memoized children. Don't wrap everything — the overhead of memoization has its own cost.

---

# What is `useCallback`?

Memoizes a function reference: `const fn = useCallback(() => { ... }, [deps])`. Equivalent to `useMemo(() => fn, [deps])`. Useful when passing callbacks to `React.memo` children — without it, a new function reference on every render defeats memoization.

---

# What is `React.memo`?

A higher-order component that skips re-rendering if props haven't changed (shallow comparison by default). Wrap components that receive the same props frequently but whose parent re-renders often. Combine with `useCallback`/`useMemo` to stabilize function and object props. Accept a custom comparator as second argument.

---

# What is `useReducer`?

An alternative to `useState` for complex state. `const [state, dispatch] = useReducer(reducer, initialState)`. Reducer: `(state, action) => newState` — a pure function. Better when next state depends on previous, when state has multiple sub-values, or when you want to centralize update logic. Similar to Redux pattern.

---

# What is reconciliation?

React's diffing algorithm. When state changes, React builds a new element tree and compares it with the previous. Heuristics: 1) Different element types → full remount. 2) Same type → update props and recurse. 3) `key` identifies which children moved/added/removed. O(n) complexity via these assumptions.

---

# What is the Virtual DOM?

A lightweight in-memory representation of the real DOM tree. On each render, React creates a new virtual DOM, diffs it with the previous (reconciliation), and computes the minimal set of real DOM mutations. Batching updates and minimizing DOM operations is what makes React performant.

---

# What is Suspense?

A component that shows a fallback while children are loading. `<Suspense fallback={<Spinner />}><LazyComp /></Suspense>`. Works with `React.lazy()` for code-splitting and with data-fetching libraries that support the Suspense protocol (throwing Promises). Nested Suspense boundaries create granular loading states.

---

# What is `React.lazy` and code splitting?

`const LazyComp = React.lazy(() => import('./Component'))`. Splits the component into a separate bundle loaded on demand. Wrap with `<Suspense>` for a loading fallback. Reduces initial bundle size. Route-level splitting is the most impactful first step.

---

# What is error boundary?

A class component with `static getDerivedStateFromError` or `componentDidCatch` that catches rendering errors in its subtree and displays a fallback UI instead of crashing the whole app. No hook equivalent yet. Doesn't catch errors in event handlers, async code, or SSR — only during render and lifecycle methods.

---

# What are custom hooks?

Functions prefixed with `use` that compose built-in hooks. They share stateful logic, not state itself — each call gets its own state. Examples: `useLocalStorage`, `useDebounce`, `useFetch`, `useMediaQuery`. Extract when the same hook combination appears in multiple components.

---

# What are Server Components?

Components that render on the server and send serialized output to the client — zero JS bundle cost. Can directly access databases, file systems, backend services. Cannot use hooks, browser APIs, or event handlers. Client Components (`'use client'`) handle interactivity. They compose in the same tree. Default in Next.js App Router.

---

# What is `useTransition`?

Marks a state update as non-urgent: `const [isPending, startTransition] = useTransition()`. Updates inside `startTransition` can be interrupted by urgent updates (typing, clicking). React keeps showing the current UI while computing the new one in the background. `isPending` lets you show a loading indicator.

---

# What is `useDeferredValue`?

`const deferredValue = useDeferredValue(value)`. Returns a deferred version of a value that "lags behind" during urgent updates. React renders with the old value first (keeping UI responsive), then re-renders with the new value in the background. Useful for expensive renders triggered by fast-changing input.

---

# What is `useSyncExternalStore`?

A hook for subscribing to external stores (Redux, Zustand, browser APIs). `useSyncExternalStore(subscribe, getSnapshot, getServerSnapshot)`. Guarantees consistency — no tearing during concurrent renders. Required when integrating non-React state management with concurrent features. Libraries use it internally.

---

# What is concurrent rendering?

React 18's ability to prepare multiple versions of the UI simultaneously. Rendering can be interrupted, paused, or abandoned. Enables features like `useTransition`, `useDeferredValue`, and Suspense for data fetching. Doesn't make things faster — makes the UI more responsive by prioritizing urgent updates over expensive ones.

---

# What is `useId`?

Generates a stable, unique ID that's consistent between server and client renders. `const id = useId()`. Use for linking labels to inputs (`htmlFor`), ARIA attributes, or any case where you need a unique ID that doesn't change across re-renders and doesn't cause hydration mismatches.

---

# What is streaming SSR and selective hydration?

React 18 can stream HTML to the browser as components render (instead of waiting for the full page). Combined with `<Suspense>`, parts of the page arrive and become interactive independently. Selective hydration prioritizes hydrating components the user is interacting with. Dramatically improves Time to Interactive.

---

# What is the React compiler (React Forget)?

An automatic optimizing compiler that adds memoization to components and hooks at build time. Eliminates the need for manual `useMemo`, `useCallback`, and `React.memo`. Analyzes data flow to determine what can be safely memoized. Shipping in React 19+. Doesn't change how you write code — just removes the manual optimization burden.

---

# What is `useOptimistic`?

A hook for optimistic UI updates: `const [optimisticState, addOptimistic] = useOptimistic(state, updateFn)`. Shows the expected result immediately while the actual async operation (form submission, mutation) is in flight. Reverts to real state when the operation completes or fails. Pairs with Server Actions in Next.js.

---

# What is `useFormStatus`?

A hook that reads the status of a parent `<form>` element: `const { pending, data, method, action } = useFormStatus()`. Must be called from a component rendered inside the form. `pending` is `true` while the form action is executing. Use for disabling submit buttons, showing spinners.

---

# What is `useActionState`?

`const [state, formAction, isPending] = useActionState(action, initialState)`. Wraps a form action to track its result and pending state. The action receives the previous state and form data, returns the new state. Enables progressive enhancement — forms work without JS via Server Actions, enhance with client-side state.

---

# What are the rules of React (beyond hooks)?

1) Components must be pure during render — same props → same JSX, no side effects. 2) Don't mutate props, state, or context values directly. 3) React calls components — don't call them as functions yourself. 4) Only call hooks from components/custom hooks. 5) Props are immutable snapshots. These rules enable concurrent rendering.

---

# What is tearing and how does React prevent it?

Tearing: different parts of the UI show inconsistent data from the same source because an external store changed mid-render. In concurrent mode, rendering can be interrupted, so reads at different times may see different values. `useSyncExternalStore` prevents tearing by ensuring the snapshot is consistent across the entire render pass.

---

# What is hydration mismatch and how do you debug it?

When server-rendered HTML doesn't match what the client renders. Causes: using `Date.now()`, `Math.random()`, browser-only APIs, conditional rendering based on `window`. React 18 logs detailed mismatch warnings. Fix: use `useId` for IDs, `suppressHydrationWarning` for intentional differences, `useEffect` for client-only logic.
