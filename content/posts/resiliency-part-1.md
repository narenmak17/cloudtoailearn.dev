---
title: "From Failure to Resiliency: Building Resilient Systems - Embracing Failure Part-1"
date: 2026-04-01
draft: true
author: "Naren"
description: "Placeholder — real content coming soon in resiliency-series--long-part1.md"
tags: ["resiliency"]
categories: ["resiliency"]
---

After 15 years of building cloud infrastructure, I've watched the industry shift from bare metal to VMs, VMs to containers, and containers to serverless. Each wave changed how we think about architecture.

AI is the next wave — and it's different from all the others.

This post is about what that shift means for cloud architects, and the concrete changes you need to make to your infrastructure thinking today.

---

## Why AI Workloads Are Different

Traditional cloud workloads are **deterministic**. You deploy an API, it handles requests, it returns predictable responses. You scale it horizontally, you monitor latency and error rates, you're done.

AI workloads break almost every assumption we've built our architectures around:

| Traditional Workload | AI Workload |
|---|---|
| Deterministic output | Non-deterministic output |
| CPU-bound | GPU/TPU-bound |
| Stateless scaling | Stateful model serving |
| Fast cold starts | Slow model loading (seconds to minutes) |
| Small payloads | Large embeddings, vectors, model weights |
| Standard monitoring | Requires evaluation, not just metrics |

This isn't a reason to panic. It's a reason to **evolve your architecture patterns**.

---

## The 3 Layers of AI-Ready Infrastructure

### Layer 1: Compute

The first thing you need to rethink is compute. AI inference and training require GPUs, and GPUs behave very differently from CPUs in a cloud environment.

**Key decisions:**
- Use **spot/preemptible instances** for training jobs — they're 60–80% cheaper and training jobs can be checkpointed
- Use **on-demand GPU instances** for inference serving where latency matters
- Consider **AWS Inferentia** or **Google TPUs** for cost-optimized inference at scale

```yaml
# Example: Kubernetes GPU node selector for inference pods
spec:
  nodeSelector:
    cloud.google.com/gke-accelerator: nvidia-l4
  resources:
    limits:
      nvidia.com/gpu: 1
```

> **Lesson learned:** Don't run inference on the same node pool as your regular services. GPU contention will hurt both workloads.

### Layer 2: Data & Vector Storage

AI systems are hungry for data — and not just relational data. You need to think about:

- **Object storage** (S3 / GCS) for model weights, training datasets, and embeddings
- **Vector databases** (Pinecone, Weaviate, pgvector) for semantic search and RAG pipelines
- **Feature stores** (Feast, Tecton) if you're doing real-time ML inference

A pattern I've found works well in production:

```
User Query
    ↓
Embedding Model (text-embedding-3-small)
    ↓
Vector DB Similarity Search (top-k results)
    ↓
Context Assembly
    ↓
LLM (GPT-4 / Claude / Llama)
    ↓
Response
```

This is the core of a **RAG (Retrieval Augmented Generation)** pipeline, and it's what most enterprise AI applications are built on today.

### Layer 3: Observability

This is where most teams get it wrong. They apply standard APM tools to AI systems and wonder why they can't debug quality issues.

AI systems need **two types of observability**:

1. **Infrastructure observability** — latency, throughput, GPU utilization, memory (standard stuff)
2. **Model observability** — output quality, hallucination rate, relevance scores, user feedback

Tools worth knowing:
- **LangSmith** — tracing for LLM chains
- **Weights & Biases** — experiment tracking and model monitoring
- **Prometheus + Grafana** — GPU metrics via DCGM exporter

---

## What This Means for Your Architecture Reviews

Next time you're reviewing an architecture for an AI system, ask these questions:

- Where are the model weights stored, and how are they versioned?
- How does the system handle model updates without downtime?
- What's the cold start time for the inference service, and is that acceptable?
- How do you know if the model output quality degrades in production?
- What's the cost per inference, and how does it scale?

These are the questions that separate a cloud architect who understands AI from one who doesn't.

---

## Where to Start

If you're a cloud architect looking to get AI-ready, here's my recommended starting point:

1. **Deploy a simple RAG pipeline** on your existing cloud — use LangChain + any vector DB + an LLM API
2. **Add GPU nodes** to your Kubernetes cluster and deploy a small inference service
3. **Set up LangSmith or W&B** to understand what model observability actually looks like
4. **Read the MLOps Specialization** on Coursera — it's the best structured path I've found

The goal isn't to become an ML engineer. The goal is to build infrastructure that ML engineers can actually use.

---

## Final Thought

The cloud architects who will matter most in the next 5 years are the ones who understand both sides — the infrastructure and the AI systems running on top of it.

You already have the infrastructure knowledge. Now it's time to learn the AI layer.

That's what this blog is about.

---

*Have questions or want to discuss your AI infrastructure setup? Connect with me on [LinkedIn](https://linkedin.com).*
