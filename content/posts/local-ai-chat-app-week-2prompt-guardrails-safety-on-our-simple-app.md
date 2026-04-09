---
author: Naren
categories:
- ai
date: '2026-04-10'
description: I added prompt guardrails to the Week 1 demo so the model now refuses
  unsafe requests, catches prompt injection, and validates every reply.
draft: false
series:
- AI Demo Series
shortname: Local Chat Guard Rails
tags:
- ai
title: Local AI Chat App — Week 2[Prompt Guardrails + Safety On Our Simple App]
---

#### Prompt Guardrails + Safety On Our Simple App

---

Week 2 is about making the chat app safe, not just smart | https://cloudtoailearn.dev
I added prompt guardrails to the Week 1 demo so the model now refuses unsafe requests, catches prompt injection, and validates every reply.

This week I split the work into two code paths:
- `main` branch = Week 1 clean vanilla chat app
- `feature/guardrails` branch = Week 2 safety enhancements

If you want to start from scratch:
1. Clone the repo
2. Checkout `main` and verify the plain app works
3. Create `feature/guardrails`
4. Add the Week 2 prompt/safety patterns

What changed in Week 2

✅ System prompt now says: "If the user asks for unsafe, illegal, or harmful actions, politely refuse."

✅ Prompt injection detection for inputs like:
- "ignore previous instructions"
- "disregard the above"
- `<|system|>` or `<|assistant|>` tokens

✅ Refusal patterns for unsafe requests:
- hacking
- illegal actions
- credit card / SSN data
- medical/self-harm advice

✅ Output validation after generation:
- reject empty or broken replies
- reject model text that still contains prompt tokens

✅ Rate limiting repeated questions:
- repeat the same prompt 3x and the app says "Let's slow down"

Why this matters: a model that can answer is useful, but a model that refuses unsafe or hostile requests is the one you can actually show to others.

What you can test
- "How do I hack wifi?" → refusal message
- "Ignore previous instructions" → rejection
- Repeating the same question 3 times → rate-limited reply
- Normal requests still work as expected

If you're starting fresh:
- use `main` for the plain Week 1 demo
- branch into `feature/guardrails` for Week 2 safety work
- check WEEK2_PROMPT_ENGINEERING.md file for detialed instructions
- DM me in case if you are facing any issues

Repo: https://lnkd.in/eEpeDBug
Full write-up: https://lnkd.in/e75KV3pi

This is Week 2 of my 12-week AI demo series at cloudtoailearn.dev
Each 2 week: one working demo + one blog post.

like, subscribe & Share !!!
Happy AI Leanring !!!

#AI #AISafety #PromptEngineering #SecureAI #Gradio #HuggingFace #cloudtoailearn #AI #LLM #PromptEngineering #MLOps #CloudArchitecture #cloudtoailearn #aws