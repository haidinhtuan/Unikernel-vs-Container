# Unikernel-vs-Container


# Unikernel vs Container Benchmark

## 📌 Purpose

This project **benchmarks the performance of Nanos Unikernel vs Docker Containers** for typical edge/Industry 4.0 workloads, focusing on:

- **HTTP request handling throughput and latency.**
- **CPU-bound computation workloads (hashing).**

The goal is to empirically compare how much performance improvement (or penalty) unikernels provide over Docker containers in real-world microservice-style workloads, using **Go and Node.js** applications.

---

## 🗂️ Folder Structure

### `go-http-app`
- HTTP server written in **Go**.
- Exposes:
  - `GET /hello` endpoint returning `Hello, World!`.
- Used to **benchmark HTTP request throughput and latency** on Nanos vs Docker.

### `node-http-app`
- HTTP server written in **Node.js**.
- Exposes:
  - `GET /hello` endpoint returning `Hello, World!`.
- Similar purpose as `go-http-app`, allowing **runtime comparison between Go and Node.js** on Nanos vs Docker.

### `go-compute-app`
- CPU-bound benchmark application written in **Go**.
- Exposes:
  - `POST /compute` endpoint which:
    - Accepts a payload.
    - Performs **100 iterations of SHA-256 hashing** on the payload.
- Used to benchmark **compute-intensive workloads** under Nanos vs Docker.

### `node-compute-app`
- CPU-bound benchmark application written in **Node.js**.
- Exposes:
  - `POST /compute` endpoint which:
    - Accepts a payload.
    - Performs **100 iterations of SHA-256 hashing** on the payload.
- Used to benchmark **compute-intensive workloads** under Nanos vs Docker for Node.js runtime.

---

## 🧪 Benchmark Goals

1. **HTTP I/O-bound workload:**
   - Measure requests/sec and latency for simple HTTP GET handling.
   - Compare Go vs Node.js on both Nanos and Docker.

2. **CPU-bound workload:**
   - Measure throughput (requests/sec) for hashing-heavy POST `/compute` workloads.
   - Assess raw compute efficiency under Nanos vs Docker with Go and Node.js runtimes.

---

## 🚀 How to Use

Benchmarks are performed using `wrk` with configurable concurrency and connection settings.

Example benchmark for Go HTTP app:
```bash
wrk -t4 -c100 -d30s http://localhost:8080/hello
```
For CPU-bound compute app:
```bash
echo '{"data":"your_payload_here"}' | \
wrk -t4 -c100 -d30s -s post.lua http://localhost:8080/compute
```
