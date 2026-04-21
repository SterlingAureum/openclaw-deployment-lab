# Troubleshooting Skill and Tool Integration

## Scope

This document collects common issues observed during the `v0.4.0` integration stage,
where skill and tool support were added on top of the existing remote vLLM workflow.

It focuses on practical problems rather than theoretical behavior.

---

## 1. Skill Is Present But The Model Does Not Follow It Strictly

This is one of the most common misunderstandings.

A skill being available does not mean the model will always follow it strictly.

Possible reasons include:

- the model is weak for the requested task
- the conversation already contains too much prior context
- the task framing is vague
- the required tool is not actually available
- the session still reflects an older config state

What to do:

- reduce ambiguity in the prompt
- use a fresh session
- confirm the tool side is actually working
- test with a smaller and clearer validation task first

---

## 2. The Model Describes Actions But Does Not Actually Use The Tool

This usually means one of two things:

- the tool is not really available to the model in the current runtime
- the model is choosing a text-only answer instead of execution

What to check:

- whether the intended tool is exposed in the current config
- whether the runtime/provider/model path supports the needed tool behavior
- whether the task clearly requires execution rather than explanation

In practice, a vague operational prompt often increases the chance of a descriptive answer instead of a real tool call.

---

## 3. Config Was Updated But Behavior Did Not Change

This often happens when testing in an older session.

Even after changing model, tool, or related config,
an existing session may continue to behave as if the previous state is still active.

What to do:

- start a new session
- re-test with a minimal prompt
- avoid using an already long conversation to validate a new config

This is a simple step, but it prevents a lot of confusion.

---

## 4. Tool Integration Works, But The Overall Result Still Feels Weak

This is possible even when the technical integration is already correct.

Typical reasons:

- the model is small or weak for multi-step operational reasoning
- the prompt is too broad
- too much context is carried into the test
- the expected format is too complex for the current model

This usually means the issue is no longer "whether the tool is connected",
but "how reliably the model can use it".

That distinction matters.

---

## 5. Context And Token Budget Reduce Stability

As the conversation becomes longer,
the model may become worse at:

- following the intended skill
- choosing the correct tool
- producing structured summaries
- keeping the result concise and relevant

This is not always a provider bug.
Often it is simply the practical limit of the current model + context budget.

What to do:

- test from a clean session
- keep validation prompts compact
- avoid overloading the same conversation with many unrelated checks
- lower the complexity of the expected output when needed

---

## 6. Better Results After Switching Models Do Not Mean All Problems Are Solved

Moving to Qwen improved the recommended path for this repository,
but that does not mean all issues disappear.

You may still see:

- inconsistent formatting
- occasional failure to call tools
- weaker performance in longer conversations
- varying behavior across sessions

The correct conclusion is not "everything is fixed",
but rather:

**the current path is more practical and less misleading than the old default**

---
