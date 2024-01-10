---
title: Entity Metadata Management API 0.1
layout: spec
cssversion: 3
tags: [specifications, api]
major: 0
minor: 0
patch: 1
pre: final
redirect_from:
  - /
editors:
  - name: David Eichmann
    orcid: https://orcid.org/0000-0003-3150-8758
    institution: School of Library & Information Science, University of Iowa
  - name: Christine Fernsebner Eslao
    orcid: https://orcid.org/0000-0002-7621-916X
    institution: Harvard Library
  - name: Nancy J. Fallgren
    orcid: https://orcid.org/0000-0002-2232-6293
    institution: National Library of Medicine
  - name: Steven M. Folsom
    orcid: https://orcid.org/0000-0003-3427-5769
    institution: Cornell University Library
  - name: Kevin M. Ford
    orcid: https://orcid.org/0000-0002-9066-2408
    institution: Library of Congress
  - name: Gregory F. Reeve
    orcid: https://orcid.org/0000-0002-7908-3755
    institution: Brigham Young University
  - name: Vitus Tang
    orcid: https://orcid.org/0000-0003-1946-3518
    institution: Stanford University Libraries
  - name: Simeon Warner
    orcid: https://orcid.org/0000-0002-7970-7855
    institution: Cornell University Library
---

## Status of this Document

_This is a draft API specification. Expect changes to this document._
{:.todo}

{:.no_toc}
__This Version:__ {{ page.major }}.{{ page.minor }}.{{ page.patch }}{% if page.pre != 'final' %}-{{ page.pre }}{% endif %}

__Latest Stable Version:__ None

__Previous Version:__ None

**Editors**

{% include api/editors.md editors=page.editors %}

{% include api/copyright.md %}

----

## 1. Introduction
{: #introduction}

The Entity Metadata Management API is intended to establish a pattern that supports sharing changes to entities and their metadata curated by entity metadata providers with the community of entity metadata consumers (e.g. libraries, museums, galleries, archives). Use of a consistent pattern allows for the creation of software tools for producing and consuming changes in entity metadata.

This specification is based on the [Activity Streams 2.0 specification][org-w3c-activitystreams]. It defines a usage pattern and minor extensions specific to entity metadata management.

### 1.1. Objectives and Scope
{: #objectives-and-scope}

The objective of this specification is to provide a machine to machine API that conveys the information needed for an entity metadata consumer to understand all the changes to entity metadata across the lifecycle of an entity. The intended audiences are Entity Metadata Providers who curate and publish entity metadata within an area of interest, Entity Metadata Consumers who use the entity metadata, and developers who create applications and tools that help consumers connect to entity metadata from providers.

The discovery of changes to entity metadata requires a consistent pattern for entity metadata providers to publish lists of links to entities that have metadata changes and the types of changes that have occurred. Changes include newly available entities with metadata, removed entities, as well as changes to entities and their metadata.

This process can be optimized if metadata providers publish changes in chronological order, including descriptions of how their entity descriptions have changed, enabling consuming systems to retrieve only the resources that have been modified since they were last retrieved.

This specification does not include a mechanism for enabling change notifications to be pushed to remote systems. Only periodic polling for the set of changes that must be processed is supported. Addition of a push mechanism may be added in a future version.
{: .warning}

Work that is out of scope of this API includes the recommendation or creation of any descriptive metadata formats, and the recommendation or creation of metadata search APIs or protocols. The diverse domains represented across the entity metadata already have successful standards fulfilling these use cases. Also out of scope is optimization of the transmission mechanisms providing access points for consumers to query.
{: .warning}

### 1.2. Use Cases
{: #use-cases}

The following three use cases motivate this specification. They are drawn from workflows needed by libraries, museums, galleries, and archives.

#### 1.2.1. Change Tracking
{: #change-tracking}

Entity metadata consumers may want to learn about modifications or deletions for entities they use, or about the creation of new entities by the same provider.

To address this generic use case, the provider creates and makes available a list of changes with the URIs for any new, modified, or deleted entities. While the provider may have internal needs for tracking more than these three moments in an entity's lifecycle (e.g. if the provider workflow requires a review activity), this specification focuses on public changes to the dataset that may require action from a consumer. The consumer will need to take additional actions to identify and act on changes to entities of interest, which many be automatic or manual.

#### 1.2.2. Local Cache of Labels
{: #local-cache-of-labels}

Entity metadata consumers persist references to entity metadata by saving the URI as part of their local datastore. URIs may not be understandable to application users. In order to be able to display a human readable label, a label may be retrieved from the provider's datastore by dereferencing the URI. For performance reasons, the label is generally cached in the local datastore to avoid having to fetch the label every time the entity reference is displayed to an end user. If the label changes in the provider's datastore, the consumer would like to update the local cache of the label.

To address this use case, the provider creates and makes available a list of URIs and their new labels. The consumer can compare the list of URIs with those stored in the local application and update the cached labels.

In some cases, additional metadata is also cached as part of the external reference, but this is less common. Verification of the additional metadata may require the consumer to take additional actions.

#### 1.2.3. Local Cache of Full Entity Metadata
{: #local-cache-of-full-entity-metadata}

A consumer may decide to make a cache of a dataset of full entity metadata. This is commonly done for increased control over uptime, throughput, and indexing for search. The cache needs timely updates to stay in sync with the source dataset.

To address this use case, the provider creates and makes available a dated list of all new, modified, and deleted entities along with specifics about how the entities have changed. The consumer can process a stream of change documents that was published since their last incremental update. Specific details about each change can be used to update the local cache.

In some cases, caching of full descriptions of select entities may desired, by limiting to only those entities referenced in local bibliographic data.

### 1.3. Terminology
{: #terminology}

#### 1.3.1. Roles
{: #roles}

* Entity Metadata Provider: An organization that collects, curates, and provides access to metadata about entities within an area of interest.
* Entity Metadata Consumer: Any institution that references or caches entity metadata from a provider.

#### 1.3.2. Terms about Entities
{: #terms-about-entities}

* Entity: An entity is any resource (a thing or a concept) identified with a URI that we may want to reference or make use of in data set. Entities include, but are not limited to, what are referred to _authorities_, _controlled vocabulary terms_, or _real world objects (RWOs)_ in library, archives, and museum domains.
* Entity Set: A set of entities that are grouped together by an Entity Metadata Provider. Entities can be grouped based on various criteria (e.g. subject headings, names, thesaurus, controlled vocabulary).

#### 1.3.3. Terms from Activity Streams
{: #terms-from-activity-streams}

This specification is based on the [Activity Streams 2.0 specification][org-w3c-activitystreams] and uses the following key terms from Activity Streams:

* [Activity](https://www.w3.org/TR/activitystreams-core/#activity): `Activity` objects are used to describe an individual change to the metadata of an Entity Set.
* [Collection](https://www.w3.org/TR/activitystreams-core/#collections): The entry point for all the information about changes to the metadata of an Entity Set is modeled as a Collection, using the [`OrderedCollection`](https://www.w3.org/TR/activitystreams-core/#dfn-orderedcollection) type to indicate that the activities in the collection are in time order.
* [OrderedCollectionPage](https://www.w3.org/TR/activitystreams-core/#dfn-orderedcollectionpage): The complete Collection of changes is expressed as a set of `OrderedCollectionPage` objects to ensure that there are manageable chunks of change activities described even for large and long-running sets of updates.

Many properties from Activity Streams are used, and are described throughout this document.

#### 1.3.4. Terms from Other Specifications
{: #terms-from-specifications}

This specification uses the following terms:

* HTTP(S): The HTTP or HTTPS URI scheme and internet protocol.
* [Javascript Object Notation (JSON)][org-rfc-8259]: The terms _array_, _JSON object_, _number_, and _string_ in this document are to be interpreted as defined by the Javascript Object Notation (JSON) specification.
* [JSON-LD][org-w3c-json-ld]: Entitiy Metadata Management context is defined following JSON-LD specification.
* [RFC 2119][org-rfc-2119]: The key words _MUST_{:.strong-term}, _MUST NOT_{:.strong-term}, _REQUIRED_{:.strong-term}, _SHALL_{:.strong-term}, _SHALL NOT_{:.strong-term}, _SHOULD_{:.strong-term}, _SHOULD NOT_{:.strong-term}, _RECOMMENDED_{:.strong-term}, _MAY_{:.strong-term}, and _OPTIONAL_{:.strong-term} in this document are to be interpreted as described in RFC 2119.
* [URI][org-iana-uri-schemes]: URIs are defined following the IANA URI-Schemes specification.


## 2. Architecture
{: #architecture}

This specification provides an API via which Entity Metadata Providers can publish information about changes in entity metadata, which Entity Metadata Consumers can follow. Changes in entity metadata over time are communicated from providers to consumers via _Entity Change Activities_{:.term} that describe a change to an entity. These are collected together in _Change Set_{:.term} documents that are organized under an _Entry Point_{:.term} as shown in the diagram below.

#### Entity Metadata Management API Architecture representing changes using Activity Streams
<img src="{{site.baseurl}}/assets/images/figures/EMM_API_Architecture.png">

### 2.1. Activity Streams and Extensibility

This specification is based on the [Activity Streams 2.0 specification][org-w3c-activitystreams]. The following sections describe the use of Activity Streams to meet Entity Metadata Management use cases. They describe only the Activity Streams classes and properties used, and any restrictions or additional semantics in the context of this specification. Implementations _MAY_{:.strong-term} use other properties from Activity Streams or elsewhere for extension, consumers _SHOULD_{:.strong-term} ignore any properties not defined in this specification that they don't understand.

### 2.2. JSON-LD Representation
{: #jsonld-representation}

The use of [JSON-LD][org-w3c-json-ld] with a specific `@context` allows Entity Metadata Consumers to parse the resulting documents using standard JSON tools, and also allows the data to be interpreted according to the RDF Data Model (see [Relationship to RDF](https://www.w3.org/TR/json-ld/#relationship-to-rdf)).

In the simplest form, a JSON-LD `@context` maps terms to IRIs. All Entity Metadata Management API responses _MUST_{:.strong-term} include the [Activity Streams 2.0 context][org-w3c-activitystreams-context-definition] definition at the top-level of each API response:

```json-doc
{
  "@context": "https://www.w3.org/ns/activitystreams",
  // rest of API response
}
```

It is _RECOMMENDED_{:.strong-term} that implementations also include the [Entity Metadata Management context][emm-context-api-01], in which case the value of `@context` will be a list. The Entity Metadata Management context includes definition of the term `Deprecate` and _MUST_{:.strong-term} thus be included if the [`Deprecate` activity](#deprecate-entity) is used. Including the Entity Metadata Management context also serves to signal to consumers that this specification is being followed.

```json-doc
{
  "@context": [
    "https://www.w3.org/ns/activitystreams",
    "https://emm-spec.org/0.1/context.json"
  ],
  // rest of API response
}
```

Implementations _MAY_{:.strong-term} include additional extension contexts. Extension contexts _MUST_{:.strong-term} be listed before the _Activity Stream_{:.term} context and Entity Metadata Management contexts. Implementations _MAY_{:.strong-term} also use additional properties and values not defined in a JSON-LD `@context` with the understanding that any such properties will likely be unsupported and ignored by consuming implementations that use the standard JSON-LD algorithms.

## 3. API Responses
{: #api-responses}

### 3.1. Entry Point
{: #entry-point}

Reference: [OrderedCollection][org-w3c-activitystreams-coretype-orderedcollection] description
{:.reference}

An _Entry Point_{:.term} is an ActivityStreams Collection resource identifying a dataset whose changes are published using the Activity Streams vocabulary with Entity Metadata Management enhancements. It provides pointers to one or more Change Sets.

The _Entry Point_{:.term} _MUST_{:.strong-term} be implemented as an _OrderedCollection_{:.term} following the definition in the Activity Stream specification. The key points are repeated here with examples specific to Entity Metadata Management.

Each _Entity Set_{:.term} _MUST_{:.strong-term} have at least one _Entry Point_{:.term}. It _MAY_{:.strong-term} have multiple Entry Points to satisfy different use cases. For example, one Entry Point may provide detailed changes to support incremental updates of a full cache and a second may only provide a list of primary label changes.

#### Complete example for an Entry Point

```json-doc
{
  "@context": [
    "https://www.w3.org/ns/activitystreams",
    "https://emm-spec.org/0.1/context.json"
  ],
  "summary": "My Authority - Change Documents",
  "type": "OrderedCollection",
  "id": "https://data.my.authority/change_documents/2021/activity-stream",
  "url": "https://my.authority/2021-01-01/full_download",
  "first": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/1"
  },
  "last": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/12"
  },
  "totalItems": 123
}
```

<a id="entry-point-context" class="anchor-definition" />
__@context__

Reference: [JSON-LD context][org-w3c-json-ld-context]
{:.reference}

The _Entry Point_{:.term} _MUST_{:.strong-term} have a `@context` property as described in [JSON-LD Representation](#jsonld-representation).

<a id="entry-point-summary" class="anchor-definition" />
__summary__

Reference: [summary][org-w3c-activitystreams-property-summary] property definition
{:.reference}

The `summary` is a natural language summarization of the purpose of the _Entry Point_{:.term}

The _Entry Point_{:.term} _SHOULD_{:.strong-term} have a `summary` property. For an _Entry Point_{:.term}, the summary _MAY_{:.strong-term} be a brief description of the _Entity Set_{:.term} in which the described changes occurred. If there are multiple entry points to the same collection, it is _RECOMMENDED_{:.strong-term} that the summary include information that distinguishes each entry point from the others.

```json-doc
  "summary": "My Authority - Entity Change List"
```

```json-doc
  "summary": "My Authority - Incremental Updates from 2022-01-01 Full Download"
```

<a id="entry-point-type" class="anchor-definition" />
__type__

Reference: [type][org-w3c-activitystreams-property-type] property definition
{:.reference}

The `type` property identifies the Activity Stream type for the _Entry Point_{:.term}.

The _Entry Point_{:.term} _MUST_{:.strong-term} have a `type` property. The value _MUST_{:.strong-term} be `OrderedCollection`.

```json-doc
  "type": "OrderedCollection"
```

<a id="entry-point-id" class="anchor-definition" />
__id__

Reference: [id][org-w3c-activitystreams-property-id] property definition
{:.reference}

The `id` is a unique identifier of the _Entry Point_{:.term}.

The _Entry Point_{:.term} _MUST_{:.strong-term} have an `id` property. The value _MUST_{:.strong-term} be a string and it _MUST_{:.strong-term} be an HTTP(S) URI. The JSON representation of the _Entry Point_{:.term} _MUST_{:.strong-term} be available at the URI.

```json-doc
  "id": "https://data.my.authority/change_documents/2021/activity-stream"
```

<a id="entry-point-url" class="anchor-definition" />
__url__

Reference: [url][org-w3c-activitystreams-property-url] property definition
{:.reference}

The _Entry Point_{:.term} _MAY_{:.strong_term} have a `url` property providing one or more links to representations of the _Entity Set_{:.term}. If there are multiple links then the value of the `url` property will be an array.

A common use of the `url` property is a link to the full download for the collection.

```json-doc
  "url": "https://my.authority/2021-01-01/full_download"
```

<a id="entry-point-first" class="anchor-definition" />
__first__

Reference: [first](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-first) property definition
{:.reference}

The _Entry Point_{:.term} _SHOULD_{:.strong-term} have a `first` property to indicate the first _Change Set_{:.term} in this _Entry Point_{:.term} for the _Entity Collection_{:.term}. If present, the value _MUST_{:.strong-term} be either:
  * a string that is HTTP(S) URI of the first page of items in the _Entry Point_{:.term}, or
  * a JSON object, with at least the `id` and `type` properties. The value of the `id` property _MUST_{:.strong-term} be a string that is the HTTP(S) URI of the first page of items in the _Entry Point_{:.term}. The value of the `type` property _MUST_{:.strong-term} be the string `OrderedCollectionPage`.

```json-doc
  "first": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/1"
  }  
```

<a id="entry-point-last" class="anchor-definition" />
__last__

Reference: [last](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-last) property definition
{:.reference}

The _Entry Point_{:.term} _SHOULD_{:.strong-term} have a `last` property to indicate the last _Change Set_{:.term} in this _Entry Point_{:.term} for the _Entity Collection_{:.term}. If present, the value _MUST_{:.strong-term} be either:
  * a string that is HTTP(S) URI of the last page of items in the _Entry Point_{:.term}, or
  * a JSON object, with at least the `id` and `type` properties. The value of the `id` property _MUST_{:.strong-term} be a string that is the HTTP(S) URI of the last page of items in the _Entry Point_{:.term}. The value of the `type` property _MUST_{:.strong-term} be the string `OrderedCollectionPage`.

```json-doc
  "last": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/12"
  }
```

<a id="entry-point-totalitems" class="anchor-definition" />
__totalItems__

Reference: [totalItems][org-w3c-activitystreams-property-totalitems] property definition
{:.reference}

The count of all _Entity Change Activities_{:.term} across all _Change Sets_{:.term} in the _Entry Point_{:term} for the _Entity Collection_{:.term}.

The _Entry Point_{:.term} _MAY_{:.strong-term} have a `totalItems` property. If included, the value _MUST_{:.strong-term} be an integer, and it _SHOULD_{:.strong-term} be the cumulative count of _Entity Change Activities_{:.term} across all _Change Sets_{:.term}.

```json-doc
  "totalItems": 123
```

### 3.2. Change Set
{: #change-set}

Reference: [OrderedCollectionPage][org-w3c-activitystreams-coretype-orderedcollectionpage] description
{:.reference}

A _Change Set_{:.term} is an Activity Streams Ordered Collection Page resource identifying individual _Entity Change Activities_{:.term}, which are resources that have been created, modified, or deprecated. It may additionally identifying preceding or subsequent _Change Sets_{:.term} for automated crawling.

Each time a set of changes is published, changes _MUST_{:.strong-term} be released in at least one _Change Set_{:.term}. Changes _MAY_{:.strong-term} be published across multiple _Change Sets_{:.term}. For example, a site may decide that each _Change Set_{:.term} will have at most 50 changes and if that maximum is exceeded during the release time period, then a second _Change Set_{:.term} will be created.

The _Entity Change Activities_{:.term} within a _Change Set_{:.term} _MUST_{:.strong-term} be sorted in date-time order in the `orderedItems` array. The _Entity Change Activities_{:.term} _MAY_{:.strong-term} be in ascending or descending order, but the order _MUST_{:.strong-term} be consistent within the _Collection_{:.term}.

Where there are multiple _Change Sets_{:.term}, these sets _MUST_{:.strong-term} be arranged in ascending or descending date-time order, consistent with the _Entity Change Activity_{:.term} ordering within each _Change Set_{:.term}.

It is _RECOMMENDED_{:.strong-term} that change sets be published on a regular schedule. It is recognized that there are many factors that can impact implementation, including but not limited to, the volume of changes, the consistency of timing of changes, the tolerance of consumers for delays in the publication schedule, and resources for producing _Change Sets_{:.term}.

_Change Sets_{:.term} _MUST_{:.strong-term} be implemented as an _OrderedCollectionPage_{:.term} following the definition in the Activity Stream specification. The key points are repeated here with examples specific to Entity Metadata Management.

#### Complete example for a Change Set

```json-doc
{
  "@context": [
    "https://www.w3.org/ns/activitystreams",
    "https://emm-spec.org/0.1/context.json"
  ],
  "type": "OrderedCollectionPage",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2",
  "partOf": {
    "type": "OrderedCollection",
    "id": "https://data.my.authority/change_documents/2021/activity-stream"
  },
  "totalItems": 2,
  "prev": {
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/1",
    "type": "OrderedCollectionPage"
  },
  "next": {
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/3",
    "type": "OrderedCollectionPage"
  },
  "orderedItems": [
    {
      "type": "Create",
      "published": "2021-02-01T15:04:22Z",
      "object": {
        "id": "https://my.authority/term/milk",
        "type": "http://www.w3.org/2004/02/skos/core#Concept",
        "updated": "2021-02-01T15:04:22Z"
      }
    },
    {
      "type": "Create",
      "published": "2021-02-01T17:11:03Z",
      "object": {
        "id": "https://my.authority/term/bovine_milk",
        "type": "http://www.w3.org/2004/02/skos/core#Concept",
        "updated": "2021-02-01T17:11:03Z"
      }
    },
    {
      "type": "Deprecate",
      "published": "2021-02-01T17:11:03Z",
      "object": {
        "id": "https://my.authority/term/cow_milk",
        "type": "http://www.w3.org/2004/02/skos/core#Concept",
        "updated": "2021-02-01T17:11:03Z"
      }
    }
  ]
}
```

<a id="change-set-context" class="anchor-definition" />
__@context__

Reference: [JSON-LD context][org-w3c-json-ld-context]
{:.reference}

The _Change Set_{:.term} _MUST_{:.strong-term} have a `@context` property as described in [JSON-LD Representation](#jsonld-representation).

<a id="change-set-type" class="anchor-definition" />
__type__

Reference: [type][org-w3c-activitystreams-property-type] property definition
{:.reference}

The `type` property identifies the Activity Stream type for the _Change Set_{:.term}.

The _Change Set_{:.term} _MUST_{:.strong-term} have a `type` property. The value _MUST_{:.strong-term} be `OrderedCollectionPage`.

```json-doc
  "type": "OrderedCollectionPage"
```

<a id="change-set-id" class="anchor-definition" />
__id__

Reference: [id][org-w3c-activitystreams-property-id] property definition
{:.reference}

The `id` is a unique identifier of the _Change Set_{:.term}.

The _Change Set_{:.term} _MUST_{:.strong-term} have an `id` property. The value _MUST_{:.strong-term} be a string and it _MUST_{:.strong-term} be an HTTP(S) URI. The JSON representation of the _Change Set_{:.term} _MUST_{:.strong-term} be available at the URI given.

```json-doc
  "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
```

<a id="change-set-partOf" class="anchor-definition" />
__partOf__

Reference: [id][org-w3c-activitystreams-property-partof] property definition
{:.reference}

The `partOf` property provides a link from the _Change Set_{:.term} to the _Entry Point_{:.term} is it part of.

The _Change Set_{:.term} _MUST_{:.strong-term} have a `partOf` property. The value _MUST_{:.strong-term} be either:
  * a string that is HTTP(S) URI of the _Entry Point_{:.term}, or
  * a JSON object, with at least the `id` and `type` properties. The value of the `id` property _MUST_{:.strong-term} be a string that is the HTTP(S) URI of the _Entry Point_{:.term}. The value of the `type` property _MUST_{:.strong-term} be the string `OrderedCollection`.

```
  "partOf": {
    "type": "OrderedCollection",
    "id": "https://data.my.authority/change_documents/2021/activity-stream"
  }
```

<a id="change-set-totalItems" class="anchor-definition" />
__totalItems__

Reference: [id][org-w3c-activitystreams-property-totalitems] property definition
{:.reference}

A count of the number of items in the _Change Set_{:.term}.

The _Change Set_{:.term} _SHOULD_{:.strong-term} have a `totalItems` property. If present, the value _MUST_{:.strong-term} be a non-negative integer that corresponds with the number of items in the `orderedItems` array in this _Change Set_{:.term}.

```
  "totalItems": 3
```

<a id="change-set-prev" class="anchor-definition" />
__prev__

Reference: [prev](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-prev) property definition
{:.reference}

A link to the previous _Change Set_{:.term} in this _Entry Point_{:.term} for the _Entity Collection_{:.term}.

The _Change Set_{:.term} _MAY_{:.strong-term} have a `prev` property if there are preceding _Change Sets_{:.term} in the _Entry Point_{:.term} for this _Entity Collection_{:.term}. If present, the value _MUST_{:.strong-term} be either:
  * a string that is HTTP(S) URI of the previous page of items in the _Entry Point_{:.term}, or
  * a JSON object, with at least the `id` and `type` properties. The value of the `id` property _MUST_{:.strong-term} be a string that is the HTTP(S) URI of the previous page of items in the _Entry Point_{:.term}. The value of the `type` property _MUST_{:.strong-term} be the string `OrderedCollectionPage`.

```json-doc
  "prev": "https://data.my.authority/change_documents/2021/activity-stream/page/1"
```

<a id="change-set-next" class="anchor-definition" />
__next__

Reference: [next](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-next) property definition
{:.reference}

A link to the next _Change Set_{:.term} in this _Entry Point_{:.term} for the _Entity Collection_{:.term}.

The _Change Set_{:.term} _MUST_{:.strong-term} have a `next` property if there are
subsequent _Change Sets_ in the _Entry Point_{:.term} for this _Entity Collection_. The value _MUST_{:.strong-term} be either:
  * a string that is HTTP(S) URI of the next page of items in the _Entry Point_{:.term}, or
  * a JSON object, with at least the `id` and `type` properties. The value of the `id` property _MUST_{:.strong-term} be a string that is the HTTP(S) URI of the next page of items in the _Entry Point_{:.term}. The value of the `type` property _MUST_{:.strong-term} be the string `OrderedCollectionPage`.

```json-doc
  "next": "https://data.my.authority/change_documents/2021/activity-stream/page/3"
```

<a id="change-set-ordereditems" class="anchor-definition" />
__orderedItems__

The list of _Entity Change Activity_{:.term} entries in the _Change Set_{:.term}.

The _Change Set_{:.term} _MUST_{:.strong-term} have an `orderedItems` property which is an array of [Entity Change Activity](#entity-change-activity) objects as described below.

```json-doc
  "ordredItems": [
    // Entity Change Activity objects inserted here
  ]
```


### 3.3. Entity Change Activities
{: #entity-change-activities}

Reference: [Activity][org-w3c-activitystreams-coretype-activity] description
{:.reference}

An _Entity Change Activity_{:.term} advertises a change to a resource. The change may be its creation, a modification, or its deprecation, among others.

A change to Entity Metadata _MUST_{:.strong-term} be described in an _Entity Change Activity_{:.term}. An _Entity Change Activity_{:.term} _MUST_{:.strong-term} be implemented as an [Activity Streams][org-w3c-activitystreams] [`Activity`](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-activity). The activity _MUST_{:.strong-term} provide information about the type of change and the entity or entities changed. It _MAY_{:.strong-term} provide links that facilitate the consumer gathering additional information from the source dataset.

Not all implementations will store every change for an entity over time. A _Collection_{:.term} _MAY_{:.strong-term} provide feeds of only the last known metadata update for each entity. In the case where the _Collection_ provides feeds of only the last known metadata update for each entity case, the page identifier cannot be used to know the last _Activities_{:.term} processed by a consumer. For this reason the _Activities_{:.term} within the _Collection_{:.term} _MUST_{:.strong-term} have either a `published` or `endTime` datetime property as described below. The `updated` property _SHOULD_{:.strong-term} be used on the entity description `object` to indicate when the entity change actually occurred. This level is sufficient to address the [Change Tracking](#change-tracking) use case.

_Entity Change Activity_{:.term} objects appear in the `orderedItems` array within a [Change Set](#change-set) response.

#### Example excerpt for an Entity Change Activity

```json-doc
{
  "summary": "Add entity for subject Science",
  "published": "2021-08-02T16:59:54Z",
  "type": "Add",
  "partOf": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
  },
  "object": {
    "type": "http://www.w3.org/2004/02/skos/core#Concept",
    "id": "http://my_repo/entity/science",
    "updated": "2021-08-02T16:59:54Z"
  }
}
```

Properties shared across all _Entity Change Activity_{:.term} types are described here. Specific activity types relevant to Entity Metadata Management are describe in the [Types of Change](#types-of-change) section.

<a id="entity-change-activity-summary" class="anchor-definition" />
__summary__

Reference: [summary][org-w3c-activitystreams-property-summary] property definition
{:.reference}

For an _Entity Change Activity_{:.term}, the `summary` is a brief description of the change to entity metadata that the activity represents. It is _RECOMMENDED_{:.strong-term} that a summary be included and that it reference the type of change (e.g. "Add entity") and the entity being changed (e.g. "subject Science").

```json-doc
  "summary": "Add entity for subject Science"
```

There are a limited set of types of change. See [Types of Change](#types-of-change) section for a list of types and example summaries for each. Identification of the entity will vary depending on the data represented in the _Entity Set_{:.term}.

<a id="entity-change-activity-published" class="anchor-definition" />
__published__ or __endTime__

Reference: [published][org-w3c-activitystreams-property-published] and [endTime][org-w3c-activitystreams-property-endtime] property definitions
{:.reference}

The datetime at which the _Entity Change Activity_{:.term} ended or was added to the _Change Set_{:.term}.

Each _Entity Change Activity_{:.term} _MUST_{:.strong-term} have either a `published` property or an `endTime` property. It is _RECOMMENDED_{:.strong-term} that the `published` property is used. In either case, the value must be a datetime as defined in the corresponding Activity Streams property definitions (e.g. [`published`][org-w3c-activitystreams-property-published]).

```json-doc
  "published": "2021-08-02T16:59:54Z"
```

```json-doc
  "endTime": "2021-08-02T16:59:54Z"
```

<a id="entity-change-activity-type" class="anchor-definition" />
__type__

Reference: [type][org-w3c-activitystreams-property-type] property definition
{:.reference}

Each _Entity Change Activity_{:.term} _MUST_{:.strong-term} have a `type` property.

The type is the one of a set of predefined _Entity Change Activity_{:.term} types: `Create`, `Add`, `Update`, `Deprecate`, `Delete` or `Remove`. See [Types of Change](#types-of-change) section for more details.

```json-doc
  "type": "Create"
```

<a id="entity-change-activity-partof" class="anchor-definition" />
__partOf__

Reference: [partOf][org-w3c-activitystreams-property-partof] property definition
{:.reference}

The _partOf_ property identifies the _Change Set_{:.term} in which this activity was published.

An _Entity Change Activity_{:.term} _MAY_{:.strong-term} use the `partOf` property to refer back to the _Change Set_{:.term} that includes the activity. When used on an Activity, the `partOf` property _MUST NOT_{:.strong-term} be used for any other purpose. The value _MUST_{:.strong-term} be a string and it _MUST_{:.strong-term} be an HTTP(S) URI. The JSON representation of the _Change Set_{:.term} publishing this activity _MUST_{:.strong-term} be available at the URI.

```json-doc
  "partOf": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
  }
```

<a id="entity-change-activity-object" class="anchor-definition" />
__object__

Reference: [object][org-w3c-activitystreams-property-object] property definition
{:.reference}

The entity that is the subject of the _Entity Change Activity_{:.term}, along with its update datetime.

An _Entity Change Activity_{:.term} _MUST_{:.strong-term} include an `object` property. The value _MUST_{:.strong-term} be a JSON object with the following sub-properties:
  * A _RECOMMENDED_{:.strong-term} `type` property that is either a URI string or a plain string indicating the entity type.
  * A _REQUIRED_{:.strong-term} `id` property that is the URI of the entity involved in the _Entity Change Activity_{:.term}.
  * A _RECOMMENDED_{:.strong-term} `updated` property that gives the datetime of the change to the entity.

```json-doc
  "object": {
    "type": "http://www.w3.org/2004/02/skos/core#Concept",
    "id": "http://my_repo/entity/science",
    "updated": "2021-08-02T16:59:54Z"
  }
```

## 4. Types of Change
{: #types-of-change}

All _Entity Change Activities_{:.term} have a core set of properties that are described in the [Entity Change Activity](#entity-change-activity) section. Some properties are specific to the _Types of Change_. This section provides examples and descriptions of the _Entity Change Notification_{:.term} for each type of change. They also describe the relationship between similar Activity Types (e.g. `Create` vs. `Add`).

### 4.1. New Entity
{: #new-entity}

Reference: [add][org-w3c-activitystreams-activity-add] and [create][org-w3c-activitystreams-activity-create] activity definitions
{:.reference}

A new entity _SHOULD_{:.strong-term} have an [Entity Change Activity](#entity-change-Activity) with a `type` of either `Create` or `Add`.

A new entity _MUST_{:.strong-term} be implemented as an _Activity_{:.term} following the [Create type definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-create) or the [Add type definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-add) in the [Activity Stream specification][org-w3c-activitystreams]. The key points are repeated here with examples specific to Entity Metadata Management.

#### Create vs. Add

An entity appearing in an _Entry Point_{:.term} stream for the first time _MUST_{:.strong-term} use _Activity_{:.term} type `Create` and/or `Add`.

`Create` _SHOULD_{:.strong-term} be used when the entity is new in the source dataset and available for use. A provider _MUST NOT_{:.strong-term} use `Create` to broadcast that an entity exists unless it can be dereferenced at the entity URI. A Create activity indicates that the entity is new and available for use by consumers, see also `Add` below.

`Add` _SHOULD_{:.strong-term} be used when the entity exists in the source dataset, but was previously not available through the _Entry Point_{:.term} and now is being made available in the stream. Situations where this might happen include, but are not limited to, change in permissions, end of an embargo, temporary removal and now being made available.

A new _Entry Point_{:.term} _MAY_{:.strong-term} choose to populate the stream with all existing entities. In this case, the initial population of the stream with all existing entities _SHOULD_{:.strong-term} use `Add`.

#### Example Entity Change Activity excerpt for Create

```json-doc
{
  "summary": "New entity for term milk",
  "published": "2021-08-02T16:59:54Z",
  "type": "Create",
  "partOf": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
  },
  "object": {
    "type": "http://www.w3.org/2004/02/skos/core#Concept",
    "id": "http://my_repo/entity/cow_milk",
    "updated": "2021-08-02T16:59:54Z"
  }
}
```

### 4.2. Update Entity
{: #update-entity}

An updated entity _SHOULD_{:.strong-term} have an [Entity Change Activity](#entity-change-activity) with a `type` of `Update`.

An updated entity _MUST_{:.strong-term} be implemented as an _Activity_{:.term} following the [Update type definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-update) in the [Activity Stream specification][org-w3c-activitystreams]. The key points are repeated here with examples specific to Entity Metadata Management.

Examples of updates in the library domain include splits and merges. See the [Deprecate Entity](#deprecate-entity) below for an illustration of how you can reflect these scenarios without explicitly typing them as splits or merge activities using a sequence of related activities.

#### Example Entity Change Activity excerpt for Update

```json-doc
{
  "summary": "Update entity term milk",
  "published": "2021-08-02T16:59:54Z",
  "type": "Update",
  "partOf": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
  },
  "object": {
    "type": "http://www.w3.org/2004/02/skos/core#Concept",
    "id": "http://my_repo/entity/milk",
    "updated": "2021-08-02T16:59:54Z"
  }
}
```

### 4.3. Deprecate Entity
{: #deprecate-entity}

Deprecation indicates that an existing entity in the authority has been updated to reflect that it should no longer be used though the URI remains dereferencable reflecting the deprecation. Whenever possible, the entity description should indicate which entity or entities should be used instead.

There are two common scenarios. In the first, the replacement entity or entities already exist and the deprecation updates the deprecated entity only. In the second scenario, the replacement entity or entities do not exist prior to the deprecation. In this case, the replacement entity or entities are created and the status of the original entity is changed to deprecrated.

An entity that has been deprecated _SHOULD_{:.strong-term} have an [Entity Change Activity](#entity-change-activity) with the `type` `Deprecate`. The two scenarios are implemented as follows:
  * A single `Deprecate` activity when the entity that is replacing the deprecated entity already exists, or if the deprecated entity is not replaced.
  * A `Deprecate` activity for the deprecated entity, and one or more activities (e.g. Create, Update, Add) for the replacement entity or entities. In all cases, it is expected that the consumer will dereference the deprecated entity URI to obtain the updated entity description, including whether it was replaced.


Note that the Entity Metadata Management context includes definition of the term `Deprecate` and thus _MUST_{:strong-term} be included in the `@context` definition if `Deprecate` activities are used. See [JSON-LD Representation](#jsondld-representation) for more details.

#### Example Entity Change Activity excerpt for Deprecate in the Scenario where a Replacement Entity Already Exists

```json-doc
{
  "summary": "Deprecate term cow milk",
  "published": "2021-08-02T16:59:57Z",
  "type": "Deprecate",
  "partOf": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
  },
  "object": {
    "type": "http://www.w3.org/2004/02/skos/core#Concept",
    "id": "http://my_repo/entity/cow_milk",
    "updated": "2021-08-02T16:59:57Z"
  }
}
```

#### Example Entity Change Activity excerpt for Deprecate in the Scenario where a Replacement Entity is Created

```json-doc
  {
    "type": "Create",
    "published": "2021-02-01T17:11:03Z",
    "object": {
      "id": "https://my.authority/term/bovine_milk",
      "type": "http://www.w3.org/2004/02/skos/core#Concept",
      "updated": "2021-02-01T17:11:03Z"
    }
  },
  {
    "type": "Deprecate",
    "published": "2021-02-01T17:11:03Z",
    "object": {
      "id": "https://my.authority/term/cow_milk",
      "type": "http://www.w3.org/2004/02/skos/core#Concept",
      "updated": "2021-02-01T17:11:03Z"
    }
  }
```

### 4.4. Delete Entity
{: #delete-entity}

It is _RECOMMENDED_{:.strong-term} that entities be marked as _Deprecated_{:.term} in the source dataset instead of deleting the entity from the source dataset. If the entity is deprecated, follow the _Entity Change Activity_{:.term} described in [Deprecate Entity](#deprecate-entity).
{: .warning}

An entity that has been fully deleted from the source dataset where the entity URI is no longer dereferencable _SHOULD_{:.strong-term} have an [Entity Change Activity](#entity-change-activity) with a `type` of `Delete` or `Remove`.

A deleted entity _MUST_{:.strong-term} be implemented as an _Activity_{:.term} following the [Delete type definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-delete) or the [Remove type definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-remove) in the [Activity Stream specification][org-w3c-activitystreams]. The key points are repeated here with examples specific to Entity Metadata Management.

#### Example Entity Change Activity excerpt for Delete

```json-doc
{
  "summary": "Delete term cow_milk",
  "published": "2021-08-02T16:59:54Z",
  "type": "Delete",
  "partOf": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
  },
  "object": {
    "type": "http://www.w3.org/2004/02/skos/core#Concept",
    "id": "http://my_repo/entity/cow_milk",
    "updated": "2021-08-02T16:59:54Z"
  }
}
```

## Appendices
### A. Provider Workflows
{: #provider-workflows}

The section describes how an Entity Metadata Provider can implement this specification to allow consumer to follow changes in a set of entities they manage.

#### A.1 Provider Decisions

The choice of how often to create new Change Sets will depend upon how frequently entities are updated, expected needs of consumers for timely updates, resource constraints, and likely other local consideration. Two common approaches are to create Change Sets at predetermined time intervals (e.g. hourly, nightly, weekly, monthly), or after a certain number of changes have occurred (e.g. 10, 20, 100, 500 changes).

The [Local Cache of Labels](#local-cache-of-labels) and [Local Cache of Full Dataset](#local-cache-of-full-entity-metadata) use cases require the consumer to be able to download a copy of all entities in the dataset before following changes. Coordination of snapshots with the production of Changes Sets will make this easier.

#### A.2 Creating Full Downloads

When a full download of the dataset is created, the producer should:

* If already creating Change Sets, write any unrecorded entity changes to a last [Change Set](#change-set) before the snapshot.
* Record the datetime when the snapshot for the download was taken.
* On the human-readable download page, include a link to the download file and indicate the datatime of creation.
* Create or update the [Entry Point](#entry-point) to include the new download in the `url` property.

#### A.3 Creating Change Sets

The provider must record information about changes in the Entity Set as they occur, then at some point write a Change Set and make accompanying changes to the Entry Point.

##### Recording Changes Made to the Entity Set

For each change in an Entity Set, the provider must record all information necessary to write the Activity entry in a Change Set. This includes:
* The dereferencable URI for the entity
* The `type` of entity (e.g. `http://vocab.getty.edu/ontology#Subject`)
* The Activity `type` of change (e.g. `Add`, `Update`, `Deprecate`)
* The datetime of the change to the entity
* A recommended summary description of change (e.g. "Add term Science")

##### Publishing a Change Set

After some time recording changes, a provider publishes a new Change Set linked from an Entry Point. Several URIs for new and existing objects will be referenced in the algorithm below:
* _entry_point_uri_ - the URI of the newly created or existing Entry Point
* _prev_change_set_uri_ - the previous Change Set URI in the Entry Point's `last` property
* _change_set_uri_ - the new URI that will resolve to the new Change Set

and for each change recorded:
* _entity_uri_ - the URI of the entity changed
* _change_activity_uri_ - the new URI that will resolve to the new  Entity Change Activity describing the change

With these URIs the new [Change Set](#change-set) can be created as follows:
* set the `id` property to _change_set_uri_
* set the `partOf` property to use _entry_point_uri_ for `id`
* set the `prev` property to use _prev_change_set_uri_ for `id`
* set the `totalItems` property to the number of change activities that will be in this change set
* for each change, from oldest to newest or newest to oldest, add an Activity to the `orderedItems` property array, and:
    * set the `summary` property to the human readable description of the change
    * set the `published` (or `endTime`) property to the datetime the activity is being published
    * set the `type` property to the change type (e.g. `Add`, `Update`, etc.)
    * set the `id` property to the _change_activity_uri_ for this change
    * set the `object` property to be a JSON object with the following properties:
        * set the `id` property to the _entity_uri_
        * set the `type` property to the entity type
        * set the `updated` property to the datetime of the change to the entity
        * set the `summary` property to the human readable description of the change

Update the previous Change Set:
* add a `next` property that points to the new Change Set

Update the Entry Point:
* if this is the first Change Set published, add the `first` property in the entry point with:
    * set the `type` property to `OrderCollectionPage`
    * set the `id` property to the _change_set_uri_
    * set the `published` property to the datetime the Change Set is being published
* add or update the `last` property in the Entry Point:
    * set the `type` property to `OrderCollectionPage`
    * set the `id` property to the _change_set_uri_
    * set the `published` property to the datetime the Change Set is being published

For each change create a separate [Entity Change Activity](#entity-change-activities) document at the _change_activity_uri_ with the same information used in the Change Set.


## 6. Consuming Entity Change Sets
{: #consuming-entity-change-sets}

Activity streams are inherently temporal constructs, and as such, the order of presentation in a stream may be _forward_ (i.e. the starting point
in the stream reflects its oldest elements and consuming the stream involves newer and newer elements) or it may be _reverse_ (i.e. the starting
point in the stream reflects its most recent elements and consuming the stream involves older and older elements). Likewise, the content of a given page in the stream may be _immutable_ (i.e. once published the content of a given page never changes) or it may be _mutable_ (i.e. the content of a given page can be updated and can differ from release to release). This specification espouses
no preference of either approach. Rather example approaches to each are presented below.

| | Forward | Reverse |
| --- | --- | --- |
| **Mutable** | **Mutable Forward** Pages can be updated, and the content of a given page can differ by release. Older pages appear earlier in the stream than newer pages. | **Mutable Reverse** Pages can be updated, and the content of a given page can differ by release. Older pages appear later in the stream than newer pages. |
| **Immutable** | **Immutable Forward** Once published, pages never change. Older pages appear earlier in the stream than newer pages. | **Immutable Reverse** Once published, pages never change. Older pages appear later in the stream than newer pages. |

Of these four possibilities, we describe _mutable reverse_, of which the Library of Congress is an example, and _immutable forward_, of which Getty is an example. Regarding the remaining two possibilities, _mutable forward_, while feasible, requires the entire stream to be processed at each release, as there is no way of establishing where in the stream a change might occur. _Immutable reverse_ is inherently infeasible, as it requires that new content appear first, but on a page that cannot be changed.

### 6.1 Consuming a _mutable reverse_ stream (e.g. Library of Congress)

Library of Congress provides an activity stream for several authorities (e.g. names, genre/forms, subjects, etc.).

Characteristics:
* an entity will appear in the activity stream at most one time
* the `published` date of the activity for an entity will be the date of the most recent change of the object of the activity
* the first page of the stream has the most recent activities
* activities on a page are listed from newest to oldest

Assumptions:
* the consumer processes activities in descending date order, as presented in the stream
* the consumer maintains a persistent reference to the last activity date processed in the stream (`published`)

Recommendations:
* if maintaining a full cache, ingest latest full download before processing the related activity stream
* each time the activity stream is processed, save the date of the more recently processed entity

Pseudocode (to consume updated resources since a specific date):
```
# uri_of_first_activity_stream_page = Input URI of first Activity Stream page
# date_from = Date of last activity processed in previous processing run.
# last_update = Date of last activity processed in current processing run.

func process_as(date_from, as_uri)
    activity_stream_page = get as_uri
    for each activity in activity_stream_page
        if activity.published >= date_from then
            process activity by type
            last_update = activity.published
        else
            return

        if activity.last == true and activity.published >= date_from then
            process_as(date_from, activity_stream.next)
end func

process_as(date_from, uri_of_first_activity_stream_page)
# for next run: date_from = last_update
```

### 6.2 Consuming an _immutable forward_ stream (e.g. Getty)

Characteristics:
* an entity will appear in the activity stream one or more times
* the first page of the stream has the oldest activities
* activities on a page are listed from oldest to newest
* the date of an activity is the time of that given modification

Assumptions:
* the consumer fully processes all activities appearing in a given page in the stream
* the consumer maintains a persistent reference to the last page processed in the stream (last_page)

Pseudocode:
```
go to the activity stream
current = activity.last_page

while (current.next != null)
  for each activity in current
    process activity by type
  end
end
```

### 6.3 Discussion

The Library of Congress' mutable reverse approach is inherently the most compact, as any given entity appears in the stream exactly once, at its most recent
point of modification. However, this is accomplished by completely regenerating the activity stream in its entirety whenever new content is
made available. Getty's immutable forward approach yields pages that are immutable – once issued a page will never be altered – with new content
appearing incrementally on new pages attached to the end of page sequence comprising the stream. Any given entity may appear multiple times in the
stream, reflecting the number of modifications it has undergone over its life, and each appearance need only update the entity rather than
provide a complete representation.

## Acknowledgements

We are grateful to all participants in the LD4 [Best Practices for Authoritative Data Working Group](https://wiki.lyrasis.org/x/pgFrD), within which this specification was created. [E. Lynette Rayle](https://orcid.org/0000-0001-7707-3572) (formerly at Cornell University) led the initial development of this specification. [Jim Hahn](https://orcid.org/0000-0001-7924-5294) (University of Pennsylvania Libraries), [Kirk Hess](https://orcid.org/0000-0002-9559-6649) (OCLC R&D), [Anna Lionetti](https://orcid.org/0000-0001-6157-8808) (Casalini Libri), [Tiziana Possemato](https://orcid.org/0000-0002-7184-4070) (Casalini Libri), and [Erik Radio](https://orcid.org/0000-0003-0734-1978) (University of Colorado Boulder) also contributed to this work.

This specification was influenced by prior implementations for [Library of Congress entity sets](https://id.loc.gov/) and [Getty vocabularies](https://www.getty.edu/research/tools/vocabularies/index.html).

{% include api/links.md %}
