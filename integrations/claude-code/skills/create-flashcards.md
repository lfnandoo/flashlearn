---
name: create-flashcards
description: Create flashcard decks for FlashLearn. Generates .md card files from topics, code, docs, or conversation context. Use when user wants to create flashcards, add cards, or build a study deck.
---

# FlashLearn Card Creator

Create flashcard decks for the FlashLearn spaced-repetition app.

## Card format

Cards live in `~/.flashlearn/cards/` as `.md` files. Format:

```markdown
---
deck: Deck Name
---

# Question (front of card)

Answer (back of card). Supports **markdown**, `code`, and multi-line content.

---

# Another question

Another answer.
```

## Instructions

1. Ask the user what topic or source they want cards for. Sources can be:
   - A topic (e.g., "Kubernetes networking", "SQL joins")
   - A file or directory in the codebase (generate cards about the code's architecture, patterns, APIs)
   - Documentation or README content
   - Conversation context (turn what was just discussed into review cards)

2. Determine the deck name and filename:
   - Deck name: human-readable, used in the app UI (e.g., "Kubernetes Networking")
   - Filename: kebab-case `.md` file (e.g., `kubernetes-networking.md`)

3. Generate cards following these quality guidelines:
   - Progress from beginner to advanced within the deck
   - Questions should be specific and unambiguous
   - Answers should be concise but complete (2-4 sentences typical)
   - Include code examples in answers where relevant (use backtick formatting)
   - Avoid yes/no questions — ask "what", "how", "why", "what is the difference"
   - Each card should test ONE concept
   - Aim for 15-40 cards per deck unless the user specifies a count

4. Write the file to `~/.flashlearn/cards/<filename>.md`

5. If FlashLearn is running, it will pick up new cards on next window activation. If not, tell the user to launch it with `open -a FlashLearn`.

## Example interaction

User: "create flashcards for docker"

→ Write `~/.flashlearn/cards/docker-fundamentals.md` with 30 cards covering containers, images, Dockerfile, volumes, networking, compose, security, orchestration.

User: "make cards from this file" (with a source file in context)

→ Read the file, extract key concepts (API surface, design patterns, error handling, data flow), generate cards about understanding and working with that code.

## When generating cards from code

- Focus on "why" and "how" over "what" — the code already shows what
- Good: "Why does the CardParser split on `\n---` instead of `---`?"
- Good: "What happens if a card file has no frontmatter?"
- Bad: "What is the CardParser class?" (too vague)
- Include the relevant code snippet in the answer when it aids understanding

## Updating existing decks

If a deck file already exists at the target path:
- Read the existing file first
- Ask the user: replace entirely, or append new cards?
- If appending, avoid duplicating existing questions
