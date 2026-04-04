---
title: "I Built a Local AI Chat App — Here's the Architecture (Week 1)"
date: 2026-04-08
draft: false
author: "Naren"
description: "Zero API costs, runs on CPU, honest account of what broke and why — Week 1 of my hands-on AI demo series."
tags: ["ai", "llm", "python", "gradio", "tinyllama", "huggingface", "hands-on"]
categories: ["ai"]
shortname: "Local Chat App"
series: ["AI Demo Series"]
cover: "/images/posts/ai-series/week01-cover.png"
---

> Week 1 of my AI Demo Series · [cloudtoailearn.dev](https://cloudtoailearn.dev/)
> 🔗 **Live demo:** [Hugging Face Spaces](#) · 🔗 **GitHub repo:** [Add repo link]

Every AI tutorial starts with "call the OpenAI API". That's fine until you're paying per token just to experiment with prompt design.

**What if you could build a working chat app with zero API costs?**

That's exactly what Week 1 of my demo series tackles — and it didn't go smoothly. Here's the honest account.

---

## What I Started With — And Why It Failed

I started with **distilgpt2** — small, free, runs on CPU. Seemed like the obvious choice.

Every response was my question repeated back in a loop:

```
User: what is cloud computing
Assistant: what is cloud computing
Assistant: what is cloud computing...
```

This is not a bug. This is exactly what a **base model** does.

distilgpt2 was trained to predict the next token on internet text — it has no concept of answering a question. It just continues whatever pattern it sees. When it sees `Assistant:` followed by the user's words, it keeps repeating that pattern.

**The fix: switch to an instruction-tuned model.**

---

## What Actually Works — TinyLlama-1.1B-Chat

TinyLlama-1.1B-Chat is the same size class as distilgpt2 but fine-tuned on conversation data. It knows what `<|assistant|>` means — generate a helpful reply.

Same CPU requirement. Same free download. Completely different behaviour.

```
User: what is cloud computing
Assistant: Cloud computing is a technology that allows users to access
applications and data on the internet through a computer network called
the cloud. You don't need your own server or storage devices...
```

> **Key insight:** Model size alone doesn't determine quality. Fine-tuning purpose matters more. A 1.1B instruction-tuned model beats a 1.5B base model for chat every time.

---

## The Architecture That Works

```
User → Gradio UI → Prompt Builder → TinyLlama (CPU) → Reply → UI
                        ↓
              TinyLlama chat template
              <|system|> + <|user|> + <|assistant|>
```

![Week 1 Architecture — Local Chat App](/images/posts/ai-series/week01-architecture.png)
*Figure 1: Full flow from user input to model response via Gradio and TinyLlama on CPU*

The prompt builder uses TinyLlama's specific chat template:

```
<|system|>
You are a helpful assistant.
<|user|>
What is cloud computing?
<|assistant|>
```

This structure is what tells the model to **generate an answer** rather than continue text. Without it, you get the loop problem above.

---

## Other Things That Broke

### Gradio 6.x Changed the Chat History Format

Older tutorials use `(user, assistant)` tuples. Gradio 6.x requires role/content dicts:

```python
# broken in Gradio 6.x
history.append((user_message, reply))

# correct for Gradio 6.x
history.append({"role": "user", "content": user_message})
history.append({"role": "assistant", "content": reply})
```

This silently breaks the UI — the chat renders blank even though the model is responding correctly. Took longer to debug than it should have.

### `server_name="0.0.0.0"` Doesn't Work on Windows

The port was listening but the browser couldn't connect. Fix:

```python
# broken on Windows
demo.launch(server_name="0.0.0.0")

# correct on Windows
demo.launch(server_name="127.0.0.1")
```

---

## The Model is Swappable — No Code Changes

The app reads `MODEL_NAME` and `PROVIDER` from environment variables:

```bash
# better local quality
set MODEL_NAME=microsoft/phi-2

# best local quality via Ollama
set PROVIDER=ollama
set MODEL_NAME=mistral

# free cloud API (no local GPU needed)
set PROVIDER=groq
set GROQ_API_KEY=your_key_here
```

![Model Provider Options](/images/posts/ai-series/week01-model-options.png)
*Figure 2: Three provider modes — local HuggingFace, local Ollama, and cloud Groq API*

This design means the same app code works across all three modes. You pick the provider based on your environment — laptop, server, or cloud.

---

## What I Learned This Week

| Lesson | Detail |
|---|---|
| Base model ≠ chat model | distilgpt2 repeats input — always use instruction-tuned for chat |
| Chat template is mandatory | Without `<\|system\|>/<\|user\|>/<\|assistant\|>` the model doesn't know its role |
| Gradio 6.x breaking change | History format changed from tuples to role/content dicts |
| Windows networking quirk | `0.0.0.0` doesn't bind correctly — use `127.0.0.1` |
| Environment variables > hardcoding | Makes model swapping trivial without touching app code |

---

## Tech Stack

| Component | Tool |
|---|---|
| UI | Gradio 6.x |
| Model (default) | TinyLlama-1.1B-Chat (HuggingFace) |
| Inference | HuggingFace Transformers (CPU) |
| Alternative providers | Ollama (local), Groq API (cloud) |
| Hosting | Hugging Face Spaces (free, public) |
| CI/CD | GitHub Actions |

---

## What's Next — Week 2

**Prompt guardrails and safety patterns** — system prompts, refusal handling, and unit tests that prove the guardrails actually work.

Follow along at [cloudtoailearn.dev](https://cloudtoailearn.dev/) or star the repo.

---

*Have questions about the architecture or ran into similar issues? Connect with me on [LinkedIn](https://linkedin.com).*
