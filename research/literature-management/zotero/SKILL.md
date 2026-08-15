---
name: zotero
description: Use the configured Zotero MCP server to search the user's Zotero library, inspect collections and items, read metadata and full text, work with PDFs, export citations, and create or update Zotero notes when explicitly requested. Use whenever the user mentions Zotero, references, citations, BibTeX, RIS, a Zotero collection, a Zotero item, or asks to read papers stored in Zotero.
---

# Zotero

Use the already configured `zotero` MCP server. Do not ask the user to install another Zotero integration when the server is available.

## Workflow

1. Locate the relevant collection or item with the narrowest search tool available.
2. Read metadata before requesting full text or PDF pages.
3. Retrieve full text, outlines, attachments, or page ranges only when the task needs them.
4. For multi-paper work, inventory the collection first and keep item keys attached to every extracted result.
5. Prefer MCP note-management tools for Zotero notes. Treat imports, note creation, edits, moves, and deletions as writes; proceed when the user explicitly requested that write, otherwise confirm the exact target first.
6. Never print, persist, or request the Zotero API key when the configured MCP server can perform the task.

## Common tool routes

- Find collections: `zotero_search_collections`, then inspect the hierarchy with `zotero_get_collections` when necessary.
- List a collection: `zotero_get_collection_items`.
- Inspect an item: `zotero_get_item_metadata` and `zotero_get_item_children`.
- Read a paper: `zotero_get_item_fulltext`; use `zotero_get_pdf_outline` or `zotero_read_pdf_pages` for targeted PDF reading.
- Locate an attachment only when needed: `zotero_get_attachment_path`.
- Create or update a note when requested: use the available Zotero note-management MCP tool and verify the resulting collection or parent-item placement.

## Output standards

- For search or inventory results, include title, creators, year, item key, and collection when available.
- Keep Zotero item keys distinct from BibTeX citation keys.
- For writes, report the created or changed item and verify its destination.
- If a route fails, state the exact gate: Zotero Desktop unavailable, local API disabled, MCP disconnected, item not found, attachment missing, or write not authorized.
