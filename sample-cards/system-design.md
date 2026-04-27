---
deck: System Design
---

# What is latency vs throughput?

Latency: time for a single request to complete (measured in ms). Throughput: number of requests handled per unit time (measured in QPS/RPS). Optimizing one can hurt the other — batching increases throughput but adds latency. Design for the metric that matters most for your use case.

---

# What is horizontal vs vertical scaling?

Vertical: bigger machine (more CPU/RAM). Horizontal: more machines behind a load balancer. Vertical is simpler but has a ceiling and a single point of failure. Horizontal scales further but requires stateless services, distributed data, and more operational complexity. Most systems use both.

---

# What is a load balancer?

Distributes incoming traffic across multiple servers. Algorithms: round-robin, least connections, IP hash, weighted. Operates at L4 (TCP — fast, no inspection) or L7 (HTTP — can route by path, header, cookie). Enables horizontal scaling, health checks, SSL termination, and zero-downtime deploys.

---

# What is a reverse proxy?

Sits in front of backend servers, forwarding client requests. Benefits: SSL termination, compression, caching, load balancing, rate limiting, hiding backend topology. NGINX, HAProxy, Caddy are common. A forward proxy sits in front of clients (VPN, corporate proxy). Most production services sit behind a reverse proxy.

---

# What is a CDN?

Content Delivery Network — caches content at edge servers geographically close to users. Reduces latency and offloads origin servers. Caches static assets (images, JS, CSS) and sometimes dynamic content. Configure TTLs carefully — stale caches after deploys cause bugs. Examples: CloudFront, Cloudflare, Fastly.

---

# What is DNS and how does it work at a high level?

Domain Name System translates domain names to IP addresses. Flow: client → recursive resolver (ISP/Cloudflare) → root nameserver → TLD nameserver (.com) → authoritative nameserver → IP returned. Results cached per TTL. DNS enables load balancing (multiple A records), geo-routing, and failover.

---

# What is the difference between SQL and NoSQL?

SQL: relational, schema-enforced, ACID transactions, joins. Best for structured data with relationships. NoSQL: flexible schemas, horizontal scaling, various consistency models. Types: document (MongoDB), key-value (Redis), wide-column (Cassandra), graph (Neo4j). Choose based on access patterns and consistency requirements.

---

# What is ACID?

Properties of reliable database transactions. Atomicity: all or nothing. Consistency: transaction moves DB from one valid state to another. Isolation: concurrent transactions don't interfere. Durability: committed data survives crashes. SQL databases guarantee ACID. Many NoSQL databases trade some ACID properties for performance/availability.

---

# What is an index in a database?

A data structure (usually B-tree or hash) that speeds up reads by avoiding full table scans. Trade-off: faster reads but slower writes (index must be updated). Composite indexes cover multiple columns. Covering indexes include all queried columns. Too many indexes waste storage and slow writes. Explain/analyze queries to verify index usage.

---

# What is database normalization?

Organizing tables to reduce data redundancy. Normal forms: 1NF (atomic values), 2NF (no partial dependencies), 3NF (no transitive dependencies). Reduces storage and update anomalies. Denormalization is the opposite — duplicating data for read performance. Most production systems are partially denormalized.

---

# What is caching and where can it be applied?

Storing frequently accessed data in a faster layer. Layers: browser, CDN, reverse proxy, application (Redis/Memcached), database query cache. Strategies: cache-aside (app manages), write-through (write to cache + DB), write-behind (write to cache, async to DB). Key decisions: TTL, invalidation strategy, cache size, eviction policy (LRU, LFU).

---

# What is CAP theorem?

In a distributed system during a network partition, you must choose between Consistency (every read sees the latest write) and Availability (every request gets a response). Partition tolerance is mandatory in distributed systems. CP systems (HBase, MongoDB): reject requests during partitions. AP systems (Cassandra, DynamoDB): serve stale data.

---

# What is eventual consistency?

After a write, replicas may temporarily return stale data but will converge given enough time. Common in distributed databases (DynamoDB, Cassandra). Acceptable for many use cases (social feeds, analytics, search). Unacceptable for others (financial transactions, inventory counts). Strong consistency guarantees linearizability but costs latency.

---

# What is database replication?

Copying data across multiple nodes. Leader-follower: one writer, many readers (read scaling but replication lag). Leader-leader: multiple writers (conflict resolution needed). Synchronous replication: strong consistency, higher latency. Asynchronous: lower latency, risk of data loss. Replication provides redundancy, read scaling, and geographic distribution.

---

# What is database sharding?

Splitting a database horizontally — each shard holds a subset of rows. Shard key determines distribution (e.g., hash of user_id). Enables write scaling beyond a single machine. Pain points: cross-shard queries/joins, resharding when data grows unevenly, hotspots from bad shard keys. Start without sharding; add when you actually need it.

---

# What is a message queue?

Async communication between services. Producer → queue → consumer. Decouples services, absorbs traffic spikes, enables retry and failure isolation. Key concepts: at-least-once delivery, idempotency, dead-letter queues, ordering guarantees. Examples: RabbitMQ (traditional queue), SQS (managed), Kafka (distributed log with replay).

---

# What is the difference between a queue and a stream (Kafka)?

A traditional queue: message consumed by one consumer, then removed. A stream (Kafka): messages are appended to a log, retained for a configurable period, and multiple consumer groups can read independently at their own pace. Streams enable replay, event sourcing, and multiple independent consumers from one topic.

---

# What is an API gateway?

Single entry point for client requests routing to backend services. Handles cross-cutting concerns: authentication, rate limiting, request routing, transformation, circuit breaking, logging, SSL termination. Avoids duplicating this logic in every microservice. Examples: Kong, AWS API Gateway, Envoy.

---

# What is REST vs GraphQL vs gRPC?

REST: resource-based URLs, HTTP verbs, simple, widely understood. GraphQL: client specifies exactly what data it needs, reduces over/under-fetching, single endpoint. gRPC: binary protocol (protobuf), HTTP/2, strongly typed, streaming, efficient — best for service-to-service. Choose based on clients, data shape, and performance needs.

---

# What is rate limiting and how do you design it?

Controlling request frequency to protect services. Algorithms: token bucket (smooth, allows bursts), sliding window log (accurate), fixed window counter (simple). Store counters in Redis for distributed limiting. Return 429 + `Retry-After` header. Apply per-user, per-IP, per-API-key, and globally. Place at API gateway or per-service.

---

# What is an idempotent operation?

Produces the same result regardless of how many times it's applied. Critical in distributed systems where retries happen (network timeouts, at-least-once delivery). GET, PUT, DELETE are naturally idempotent; POST isn't. For mutations, use idempotency keys — client sends a unique ID, server deduplicates.

---

# What is microservices vs monolith?

Monolith: single deployable unit, shared DB, simpler ops, faster development initially. Microservices: independently deployable services, each owns its data, communicate via APIs/events. Enable independent scaling and team autonomy but add complexity (network latency, partial failures, distributed transactions). Start monolith, extract when you have clear bounded contexts.

---

# What is service discovery?

How services find each other in a dynamic environment where instances come and go. Client-side: service queries a registry (Consul, etcd, Eureka) and load-balances itself. Server-side: load balancer queries the registry. DNS-based: services register DNS entries. Kubernetes uses built-in DNS (`service-name.namespace.svc.cluster.local`).

---

# What is a circuit breaker?

Prevents cascading failures. Tracks failures to a downstream service — when threshold exceeded, circuit "opens" and requests fail fast (no call made). After a timeout, "half-opens" to test recovery. Prevents thread/connection pool exhaustion and gives failing services time to recover. Libraries: resilience4j, Polly. Often built into service meshes.

---

# What is consistent hashing?

Distributes data across nodes so that adding/removing a node remaps only ~1/N of keys. Nodes and keys sit on a hash ring; each key maps to the next clockwise node. Virtual nodes (multiple positions per physical node) improve balance. Used in distributed caches, Cassandra, DynamoDB, CDN routing.

---

# What is event-driven architecture?

Services publish events to a broker; consumers subscribe and react independently. Producers don't know about consumers. Enables loose coupling, independent scaling, and new consumers without changing producers. Tradeoffs: harder to trace flows, eventual consistency, need robust event infrastructure. Combine with request-response for queries.

---

# What is event sourcing?

Storing state as a sequence of immutable events rather than current state. "UserCreated", "EmailChanged", "AccountDeactivated". Current state is derived by replaying events. Benefits: full audit trail, temporal queries, easy debugging. Costs: complexity, eventual consistency, storage growth, schema evolution of events.

---

# What is CQRS (Command Query Responsibility Segregation)?

Separate models for reads and writes. Write model handles commands (optimized for validation and consistency). Read model handles queries (optimized for query patterns, possibly denormalized). Often paired with event sourcing — events update the read model asynchronously. Adds complexity; use when read and write patterns diverge significantly.

---

# How do you design a URL shortener?

Write: generate short code (base62 encoding of auto-increment ID or hash), store mapping in DB. Read (high volume): look up code → redirect (301/302). Scale: cache hot URLs in Redis, use read replicas, CDN for popular links. Considerations: custom aliases, expiration, analytics, collision handling. ~1KB per URL × billions = TB scale.

---

# How do you design a notification system?

Components: API for sending, priority queue/router, per-channel workers (push, email, SMS, in-app). Templates and user preferences (opt-out, frequency caps). Rate limiting per user. Retry with exponential backoff + DLQ. Store notification history. Scale channels independently. Track delivery status and open rates.

---

# What is back-of-the-envelope estimation?

Quick capacity math to validate designs. Key numbers: ~86K seconds/day, ~2.6M/month. SSD read ~100μs, memory ~100ns, cross-continent RTT ~150ms. Example: 100M DAU × 5 req/day = ~5,800 QPS avg, ~17K peak (3x). 1 photo (200KB) × 10M uploads/day = 2TB/day storage. Get within an order of magnitude.

---

# What is the difference between TCP and UDP?

TCP: connection-oriented, reliable (guaranteed delivery, ordering, retransmission), flow/congestion control. Higher latency. Used for HTTP, databases, file transfer. UDP: connectionless, unreliable (no guarantees), but faster. Used for DNS, video streaming, gaming, VoIP. QUIC (HTTP/3) builds reliability on top of UDP.

---

# What is a distributed transaction and how do you handle it?

A transaction spanning multiple services/databases. Two-Phase Commit (2PC): coordinator asks all participants to prepare, then commit/abort. Blocking and slow. Saga pattern: sequence of local transactions with compensating actions on failure. Choreography (events) or orchestration (central coordinator). Prefer sagas for microservices.

---

# What is a bloom filter?

A space-efficient probabilistic data structure that tests set membership. Can say "definitely not in set" or "probably in set" (false positives possible, false negatives impossible). Uses multiple hash functions mapping to a bit array. Use cases: cache miss reduction, spam filtering, duplicate detection. Very compact — millions of items in KB.

---

# What is leader election?

Selecting one node as the coordinator in a distributed system. Algorithms: Bully, Raft, Paxos. Implementation via distributed locks (ZooKeeper, etcd). The leader handles writes or coordination; followers replicate. Must handle leader failure (heartbeat timeout → new election). Split-brain (two leaders) is the worst-case scenario — use fencing tokens.

---

# What is a write-ahead log (WAL)?

An append-only log of all changes written before they're applied to the actual data store. Ensures durability — on crash, replay the WAL to recover. Used by virtually all databases (Postgres WAL, MySQL redo log), message brokers (Kafka log), and distributed consensus (Raft log). Foundation of crash recovery.

---

# What is gossip protocol?

A peer-to-peer protocol where each node periodically shares state with random peers. Information propagates exponentially — like gossip spreading. Eventually consistent. Used for: failure detection, membership, metadata propagation (Cassandra, DynamoDB, Consul). Pros: decentralized, fault-tolerant. Cons: eventual convergence, bandwidth overhead at scale.

---

# What is a service mesh?

An infrastructure layer handling service-to-service communication. A sidecar proxy (Envoy) is deployed alongside each service, handling: mTLS, load balancing, retries, circuit breaking, observability (metrics, traces). Control plane (Istio, Linkerd) configures the proxies. Moves networking concerns out of application code. Adds latency and operational complexity.

---

# What is data partitioning strategy (hot/warm/cold)?

Tiered storage based on access patterns. Hot: frequently accessed, fast storage (SSD, in-memory). Warm: occasionally accessed, cheaper storage. Cold: rarely accessed, archive (S3 Glacier, tape). Partition by time (recent data is hot) or access frequency. Reduces costs dramatically — most data is cold. Automate tiering with lifecycle policies.

---

# What is chaos engineering?

Intentionally injecting failures into production to test system resilience. Principles: define steady state, hypothesize behavior under failure, introduce real-world events (kill instances, inject latency, partition network), observe. Tools: Chaos Monkey, Gremlin, Litmus. Start small (staging, single host), expand gradually. Reveals failure modes you can't find in testing.
