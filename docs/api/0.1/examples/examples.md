---
title: "EMM Change Document Examples"
permalink: api/examples.html
layout: page
tags: [examples]
redirect_from:
- /examples
- /examples.html
---

## Examples for Use Cases

There are example implementations for each of the 3 [primary use cases][emm-use-cases].

* [Notifications][emm-change-api-example-notifications] - example of providing notifications only that a change has occurred
* [Partial Cache][emm-change-api-example-partialcache] - example of providing notifications of primary label change and patch data for the label change
* [Full Cache][emm-change-api-example-fullcache] - example of providing full patch data supporting incremental updates since a full data download

### Consistency Across Examples

There is intentional consistency across examples to show a path from a notification implementation to a partial cache implementation to a full cache implementation.  This allows Entity Metadata Providers to start simple and grow over time to support full incremental updates.

### Directory Structure

The directories for the three examples are the same across all use cases, although not all examples use all the directories.  The naming and structure are examples only and are not meant to be prescriptive.  The interconnected linking between files _MUST_{:.strong-term} be maintained regardless of the file naming and directory structure chosen.

For the examples, the naming and directory structures are as follows:

* `/entry-point.json` - The entry point for the Entity Metadata Change Management system.
* `/set/*.json` - The `set` directory holds all Change Set pages.
* `/document/*.json` - In the `document` directory, each change has a corresponding Change Document that gives a high level summary.  This is the same information provided for each change in the Change Set.
* `/patch/*.json` - In the `patch` directory, each change has a corresponding Patch Document describing the exact changes that occurred to all entity metadata related to the Change Document.

### Filenames

Filenames for change documents include the activity type in the name (e.g. `cd1-add.json`).  The use of this convention in the examples is to make it easier for readers exploring the code to locate an example for a specific type.  It is not a recommendation for production implementations.

### Summary Descriptions

Example summary descriptions often include additional information in parentheses.  The summary prior to the parenthetical is an example of what might be used as a summary in a production system.  The note in parentheses is additional information about the example itself to help with understanding of the example.


{% include api/links.md %}
