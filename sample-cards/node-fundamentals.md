---
deck: Node.js Fundamentals
---

# What is Node.js?

A JavaScript runtime built on Chrome's V8 engine that runs outside the browser. Uses an event-driven, non-blocking I/O model. Single main thread with a thread pool (libuv) for heavy operations. Ideal for I/O-bound network services, not CPU-heavy computation.

---

# How do you run a Node.js script?

`node filename.js` from the terminal. Node reads the file, compiles it with V8, and executes it. No HTML or browser needed. You can also use `node -e "code"` for one-liners or `node --watch filename.js` (Node 18+) for auto-restart on file changes during development.

---

# What is `npm`?

Node Package Manager — the default package manager for Node. `npm init` creates a `package.json`. `npm install <pkg>` adds a dependency. `npm run <script>` runs scripts defined in `package.json`. The npm registry hosts over 2 million packages. Alternatives: `yarn`, `pnpm`.

---

# What is `package.json`?

The project manifest. Contains: name, version, description, entry point (`main`/`exports`), scripts, dependencies, devDependencies, engines, and more. `scripts` defines commands like `"start": "node index.js"`. The `"type": "module"` field enables ES module syntax.

---

# What is `package-lock.json`?

Records the exact dependency tree (versions, resolved URLs, integrity hashes). Ensures deterministic installs across machines and CI. Always commit it. `npm ci` uses the lock file exclusively — faster, stricter, fails if lock is out of sync with `package.json`.

---

# What is the difference between `dependencies` and `devDependencies`?

`dependencies` are needed at runtime (express, pg, axios). `devDependencies` are only needed during development/build (jest, typescript, eslint). `npm install --omit=dev` skips devDependencies — important for keeping Docker images small and production deploys lean.

---

# What is `process` in Node?

A global object providing info about the current Node process. Key properties: `process.env` (environment variables), `process.argv` (CLI arguments), `process.cwd()` (working directory), `process.exit(code)`, `process.pid`. Also an EventEmitter — listen for `'exit'`, `'uncaughtException'`, signals like `'SIGTERM'`.

---

# What is the difference between `require` and `import`?

`require` is CommonJS — synchronous, evaluated at runtime, can be conditional. `import` is ESM — static, parsed before execution, enables tree-shaking. Node supports both. Use `"type": "module"` in `package.json` or `.mjs` extension for ESM. Use `.cjs` to force CommonJS in an ESM project.

---

# What is `module.exports` vs `exports`?

`exports` is a shorthand reference to `module.exports`. `exports.fn = ...` works. But `exports = { fn }` breaks the reference — it no longer points to `module.exports`. Always use `module.exports = { ... }` to be safe. In ESM, use `export` / `export default` instead.

---

# How does `__dirname` and `__filename` work?

In CommonJS, they're free variables: `__dirname` is the directory of the current file, `__filename` is its full path. In ESM, they don't exist — use `import.meta.url` and convert: `const __dirname = path.dirname(fileURLToPath(import.meta.url))`.

---

# What is the `fs` module?

Node's file system API. Three flavors: callback (`fs.readFile`), synchronous (`fs.readFileSync`), and promise-based (`fs.promises.readFile` or `import { readFile } from 'fs/promises'`). Prefer the promises API with async/await. Sync versions block the event loop — only use at startup.

---

# What is the `path` module?

Utilities for working with file and directory paths. `path.join()` joins segments (handles separators). `path.resolve()` creates absolute paths. `path.basename()`, `path.extname()`, `path.dirname()` extract parts. Always use `path` instead of string concatenation — it handles OS differences (Windows backslashes).

---

# What is middleware in Express?

A function with signature `(req, res, next)`. Sits in the request pipeline. Can modify req/res, end the response, or call `next()` to pass control. Applied globally (`app.use()`) or per-route. Order matters — they execute sequentially. Error middleware has four params: `(err, req, res, next)`.

---

# What is the `http` module?

Node's built-in module for creating HTTP servers and making requests. `http.createServer((req, res) => { ... })` creates a server. Low-level — you handle routing, parsing, headers manually. Express, Fastify, and Koa are frameworks built on top of it.

---

# What is the event loop in Node.js?

Node's mechanism for non-blocking I/O. Phases: timers (setTimeout/setInterval) → pending callbacks → idle/prepare → poll (I/O) → check (setImmediate) → close callbacks. Microtasks (Promises, `process.nextTick`) run between phases. `process.nextTick` fires before Promise microtasks.

---

# What is `EventEmitter`?

The core pattern for event-driven architecture. `.on(event, listener)` subscribes, `.emit(event, ...args)` fires. `.once()` listens once. Streams, HTTP servers, and most core modules extend it. Watch listener count — `setMaxListeners()` warns of leaks. Remove listeners with `.off()` to prevent memory leaks.

---

# How do Streams work?

Process data in chunks without loading everything into memory. Four types: Readable, Writable, Duplex (both), Transform (modify in transit). Pipe them: `readable.pipe(transform).pipe(writable)`. Handle backpressure (when the writable is slower than the readable). Essential for large files, HTTP bodies, and network data.

---

# What is the `Buffer` class?

A fixed-size chunk of raw binary data, allocated outside V8's heap. Used for file I/O, network protocols, cryptography. Created with `Buffer.from('text')`, `Buffer.alloc(size)` (zero-filled), `Buffer.allocUnsafe(size)` (faster but uninitialized — fill it yourself). Can convert between encodings: utf8, base64, hex.

---

# What is `process.env` and how should secrets be managed?

An object containing environment variables. Never hardcode secrets in source. For local dev: `.env` files via `dotenv` (keep in `.gitignore`). For production: platform secret managers (AWS SSM, Vault, GCP Secret Manager). Validate required env vars at startup — fail fast, not at first request.

---

# What is error handling strategy in Node?

Callbacks: error-first pattern `(err, result)`. Promises: `.catch()` or `try/catch` with async/await. EventEmitters: listen to `'error'` event (unhandled error events crash). Unhandled rejections crash in Node 15+. Use `process.on('uncaughtException')` only for logging before exit, not recovery. Always handle errors at system boundaries.

---

# What is the `cluster` module?

Spawns multiple Node processes (workers) sharing the same server port. The master forks workers (typically one per CPU core). Each has its own V8 and event loop. OS distributes connections (round-robin on Linux, random on macOS). Use PM2 or Kubernetes for production clustering instead of rolling your own.

---

# What is `libuv`?

The C library powering Node's event loop and async I/O. Provides: the thread pool (default 4 threads, configurable via `UV_THREADPOOL_SIZE`) for fs operations, DNS lookups, compression. Network I/O uses OS async primitives (epoll on Linux, kqueue on macOS, IOCP on Windows) — no thread pool needed.

---

# What is the `child_process` module?

Spawns OS processes from Node. `exec(cmd)` runs in a shell, buffers output — good for small commands. `spawn(cmd, args)` streams I/O — good for long-running or large-output processes. `fork(file)` spawns a Node process with IPC channel for message passing. `execFile` runs a binary without a shell (safer).

---

# What are Worker Threads?

Run CPU-intensive JavaScript in parallel threads. Each worker has its own V8 instance and event loop. Communicate via `postMessage` (structured clone) or `SharedArrayBuffer` + `Atomics` for zero-copy sharing. Use for image processing, parsing, compression — not for I/O (the main thread handles that efficiently).

---

# What is graceful shutdown?

Handle `SIGTERM`/`SIGINT` → stop accepting new connections → finish in-flight requests → close DB pools/caches → exit. Critical for zero-downtime deploys. Kubernetes sends SIGTERM, waits `terminationGracePeriodSeconds` (default 30s), then SIGKILL. Without graceful shutdown, active requests get dropped mid-flight.

---

# What is the `crypto` module?

Node's built-in cryptography. Hashing: `crypto.createHash('sha256').update(data).digest('hex')`. HMAC, AES encryption/decryption, RSA key generation, random bytes (`crypto.randomBytes`), `crypto.randomUUID()`. Use `scrypt` or `argon2` for password hashing — never raw SHA/MD5.

---

# What are environment-specific configs (NODE_ENV)?

`NODE_ENV` is a convention (not built-in): `development`, `production`, `test`. Express uses it to toggle error details and view caching. Many libraries use it. Set it explicitly — don't rely on defaults. Use a config library (e.g., `convict`, `dotenv-flow`) to manage per-environment settings.

---

# What is connection pooling?

Reusing a set of pre-established database/service connections instead of creating one per request. Creating connections is expensive (TCP handshake, TLS, auth). Libraries like `pg` (PostgreSQL) provide built-in pools. Configure min/max pool size based on expected concurrency. Close pools on graceful shutdown.

---

# How does Node handle memory and what are common leaks?

V8 has a default heap limit (~1.5-4GB depending on platform). Common leaks: growing arrays/maps never pruned, closures holding references, event listeners not removed, global caches without eviction. Debug with `--inspect` + Chrome DevTools heap snapshots, or `process.memoryUsage()`. Increase heap with `--max-old-space-size=N`.

---

# What is `AsyncLocalStorage`?

Node's equivalent of thread-local storage for async contexts. Creates a store that propagates through the async call chain without passing it explicitly. Use cases: request-scoped logging (trace IDs), user context, transaction management. Part of `async_hooks` module. `new AsyncLocalStorage()` → `.run(store, callback)` → `.getStore()`.

---

# What is `AbortController` in Node?

A standard API for canceling async operations. Create a controller, pass its `signal` to fetch, `setTimeout`, streams, or custom code. `controller.abort()` triggers cancellation. `signal.addEventListener('abort', handler)`. Supported by `fetch`, `fs` operations (Node 20+), `child_process`, and many libraries.

---

# What is the `net` module?

Low-level TCP networking. `net.createServer()` creates a TCP server. `net.createConnection()` creates a TCP client. Returns `Socket` objects (Duplex streams). HTTP, WebSocket, and database protocols are built on top of TCP. Use when you need raw socket access or custom binary protocols.

---

# What are `async_hooks`?

A module for tracking the lifecycle of async resources. Provides `init`, `before`, `after`, `destroy`, and `promiseResolve` callbacks for every async operation. Foundation for `AsyncLocalStorage`. Performance-sensitive — enabling hooks adds overhead. Used by APM tools (Datadog, New Relic) for request tracing.

---

# What is HTTP/2 support in Node?

The `http2` module provides full HTTP/2 with multiplexing (multiple requests over one TCP connection), header compression (HPACK), and server push. `http2.createSecureServer()` for TLS. Faster than HTTP/1.1 for many concurrent requests. Most frameworks now support it, or use a reverse proxy (NGINX) to handle HTTP/2.

---

# What are diagnostic channels?

A pub/sub API (`diagnostics_channel` module, Node 16+) for emitting and subscribing to diagnostic events inside application and library code. Zero overhead when no subscribers. Libraries can publish events (request start/end, query execution) without depending on specific APM tools. Lighter than `async_hooks`.

---

# What is the V8 garbage collector and how does it affect Node?

V8 uses generational GC: young generation (Scavenge — frequent, fast) and old generation (Mark-Sweep-Compact — less frequent, can pause). GC pauses block the event loop. Avoid creating excessive short-lived objects in hot paths. Monitor with `--trace-gc`. Large heaps increase pause times — keep the working set lean.

---

# What is `node:test` (built-in test runner)?

Node 18+ includes a native test runner. `import { test, describe, it } from 'node:test'`. Supports subtests, `beforeEach`/`afterEach`, mocking (`mock.fn()`, `mock.method()`), snapshot testing (Node 22+), and code coverage (`--experimental-test-coverage`). Run with `node --test`. Reduces dependency on Jest/Mocha for simpler projects.

---

# What are Node.js single executable applications (SEA)?

Node 20+ can bundle your app into a single executable binary. Inject a blob into the node binary using `postject`. Distributable without requiring Node installed. Limitations: no native addons easily, large binary size. Alternatives: `pkg`, `nexe`, or Bun's `bun build --compile`.

---

# What is the permission model in Node?

Node 20+ introduced `--experimental-permission` for restricting file system, child process, and worker thread access. `--allow-fs-read=/app` limits reads to `/app`. `--allow-child-process` controls spawning. Similar to Deno's security model. Useful for running untrusted code or locking down production environments.

---

# What is `vm` module and its security limitations?

`vm.createContext()` and `vm.runInContext()` run code in a separate V8 context. Provides isolation of global scope but NOT a security sandbox — code can escape via prototype chain, constructor access, or `process` references. For true sandboxing, use `worker_threads` with the permission model, or a separate process with OS-level isolation.

---

# What is backpressure in streams and how do you handle it?

When a Writable can't consume data as fast as a Readable produces it. `writable.write()` returns `false` when the internal buffer is full. Stop reading until the `'drain'` event fires. `pipe()` handles this automatically. Ignoring backpressure causes unbounded memory growth and OOM crashes. Always respect it in manual stream wiring.
