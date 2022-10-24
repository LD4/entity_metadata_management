---
title: Entity Metadata Management API 0.1
permalink: api/0.1/recommendations.html
layout: spec
cssversion: 3
tags: [specifications, recommendations, api]
major: 0
minor: 0
patch: 1
pre: final
redirect_from:
  - /index.html
  - /recommendations.html
  - /api/
  - /api/index.html
  - /api/recommendations.html
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
  - name: Steven Folsom
    orcid: https://orcid.org/0000-0003-3427-5769
    institution: Cornell University Library
  - name: Kevin M. Ford
    orcid: https://orcid.org/0000-0002-9066-2408
    institution: Library of Congress
  - name: Jim Hahn   
    orcid: https://orcid.org/0000-0001-7924-5294
    institution: University of Pennsylvania Libraries
  - name: Kirk Hess
    orcid: https://orcid.org/0000-0002-9559-6649
    institution: OCLC R&D
  - name: Anna Lionetti
    orcid: https://orcid.org/0000-0001-6157-8808
    institution: Casalini Libri
  - name: Tiziana Possemato
    orcid: https://orcid.org/0000-0002-7184-4070
    institution: Casalini Libri
  - name: Erik Radio
    orcid: https://orcid.org/0000-0003-0734-1978
    institution: University of Colorado Boulder
  - name: E. Lynette Rayle
    orcid: https://orcid.org/0000-0001-7707-3572
    institution: Cornell University Library
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

_This is a very preliminary draft. Expect considerable changes to this document._
{:.todo}

{:.no_toc}
__This Version:__ {{ page.major }}.{{ page.minor }}.{{ page.patch }}{% if page.pre != 'final' %}-{{ page.pre }}{% endif %}

__Latest Stable Version:__ [{{ site.change_api.stable.major }}.{{ site.change_api.stable.minor }}.{{ site.change_api.stable.patch }}][change-stable-version]

__Previous Version:__

**Editors**

{% include api/editors.md editors=page.editors %}

{% include api/copyright.md %}

----

## 1. Introduction
{: #introduction}

The Entity Metadata Management API is intended to establish a pattern that supports sharing changes to entities and their metadata curated by Entity Metadata Providers with the community of Entity Metadata Consumers (e.g. libraries, museums, galleries, archives). Use of a consistent pattern allows for the creation of software tools for producing and consuming changes in entity metadata.

The recommendations in this document leverage existing techniques, specifications, and tools in order to promote widespread adoption of an easy-to-implement service. The service describes changes to entity metadata and the location of those resources to harvest. Content providers can implement this API to record and publish a list of changes and incremental cache updates.

### 1.1. Objectives and Scope
{: #objectives-and-scope}

The objective of these recommendations is to provide a machine to machine API that provides the information needed to describe changes to entity metadata across the lifecycle of an entity. The intended audiences are Entity Metadata Providers who curate aggregations of entity metadata within an area of interest, Entity Metadata Consumers who use the entity metadata, and developers who create applications and tools that help consumers connect to entity metadata from providers. While this work may benefit others wanting to express changes in data, the objective of the API is to specify an interoperable solution that best and most easily fulfills the need to express and process changes in entity metadata within the community of participating organizations.

The discovery of changes to entity metadata requires a consistent and well understood pattern for entity metadata providers to publish lists of links to entities that have metadata changes and details on changes that have occurred. Changes include newly available entities with metadata, removed entities, as well as, changes to entities and their metadata. This allows a baseline implementation of change management systems that process the list of changes.

This process can be optimized by allowing the content providers to publish changes in chronological order including descriptions of how their content has changed, enabling consuming systems to retrieve only the resources that have been modified since they were last retrieved.

__Change Notifications__<br>These recommendations do not include a subscription mechanism for enabling change notifications to be pushed to remote systems. Only periodic polling for the set of changes that must be processed is supported. A subscription/notification pattern may be added in a future version after implementation experience with the polling pattern has demonstrated that it would be valuable.
{: .warning}

Work that is out of scope of this API includes the recommendation or creation of any descriptive metadata formats, and the recommendation or creation of metadata search APIs or protocols. The diverse domains represented across the entity metadata already have successful standards fulfilling these use cases. Also out of scope is optimization of the transmission mechanisms providing access points for consumers to query.

### 1.2. Use Cases
{: #use-cases}

Three primary use cases were identified that drive the recommendations in this document. The use cases are listed from a simple change document with minimal information to a fully defined change document including details about what changed.

#### 1.2.1. Entity Change Activities List
{: #entity-change-activities-list}

Entity metadata consumers want to learn of any modifications or deletions for entities on their interest list, as well as new entities. This allows for a comparison between the consumer's list and the producer's entity change activity list of modified and deleted entities. For any that overlap, the consumer will take additional actions if needed.

To address this use case, the provider creates and makes available a list of the URIs for any new, modified, or deleted entities. The consumer will need to take additional actions to identify specific changes to entities of interest.

#### 1.2.2. Local Cache of Labels
{: #local-cache-of-labels}

Entity metadata consumers persist references to entity metadata by saving the URI as part of their local datastore. URIs may not be understandable to application users. In order to be able to display a human readable label, a label may be retrieved from the producer's datastore by dereferencing the URI. For performance reasons, the label is generally cached in the local datastore to avoid having to fetch the label every time the entity reference is displayed to an end user. If the label changes in the producer's datastore, the consumer would like to update the local cache of the label.

To address this use case, the provider creates and makes available a list of URIs and their new labels. The consumer can compare the list of URIs with those stored in the local application and update the cached labels.

__Additional Cached Metadata__<br>In some cases, additional metadata is also cached as part of the external reference, but this is less common. Verification of the additional metadata may require the consumer to take additional actions.
{: .warning}

#### 1.2.3. Local Cache of Full Dataset
{: #local-cache-of-full-dataset}

A consumer may decide to make a full cache of a dataset of entity metadata. This is commonly done for one or more reasons including, but not limited to, increased control over uptime, throughput, and indexing for search. The cache needs to stay in sync with the source dataset as near to real time as is possible using incremental updates.

To address this use case, the provider creates and makes available a dated list of all new, modified, and deleted entities along with specifics about how the entities have changed. The consumer can process a stream of change documents, from oldest to newest, that was published since their last incremental update. Specific details about each change can be used to update the local cache.

### 1.3. Terminology
{: #terminology}

#### 1.3.1. Roles
{: #roles}

TODO:  Maybe put a list of providers in an appendix instead of here.
{:.todo}

* Entity Metadata Provider: An organization that collects, curates, and provides access to metadata about entities within an area of interest. The Library of Congress maintains several [collections](https://id.loc.gov/), including but not limited to, Library Subject Headings, Name Authority, Genres/Form Terms. The Getty maintains several [vocabularies](https://www.getty.edu/research/tools/vocabularies/index.html). There are many other providers.
* Entity Metadata Consumer: Any institution that references or caches entity metadata from a provider. The use cases driving the recommendations were created from libraries, museums, galleries, and archives.

#### 1.3.2. Terms about Entities
{: #terms-about-entities}

* Entity: An entity is any resource (a thing or a concept) identified with a URI that we may want to reference or make use of in data set. Entities include, but are not limited to, what are referred to _authorities_, _controlled vocabulary terms_, or _real world objects (RWOs)_ in library, archives, and museum domains.
* Entity Set: A set of entities that are grouped together by an Entity Metadata Provider. Entities can be grouped based on various criteria (e.g. subject headings, names, thesaurus, controlled vocabulary).

#### 1.3.3. Terms from Activity Streams
{: #terms-from-activity-streams}

This recommendation is based on the [Activity Streams 2.0 specification][org-w3c-activitystreams] and uses the following key terms from Activity Streams:

* [Activity](https://www.w3.org/TR/activitystreams-core/#activity): `Activity` objects are used to describe an individual change to the metadata of an Entity Set. These often affect just one Entity but in the case of changes such as Entity merges and splits, more than one Entity may be involved and sometimes subordinate Actions.
* [Collection](https://www.w3.org/TR/activitystreams-core/#collections): The entry point for all the information about changes to the metadata of an Entity Set is modeled as a Collection, using the [`OrderedCollection`](https://www.w3.org/TR/activitystreams-core/#dfn-orderedcollection) type to indicate that the activities in the collection are in time order.
* [`OrderedCollectionPage`](https://www.w3.org/TR/activitystreams-core/#dfn-orderedcollectionpage): The completed `OrderedCollection` of changes is expressed as a set of `OrderedCollectionPage` to ensure that there are manageable chunks of change activities described even for large and long-running sets of updates.

Many properties from Activity Streams are used, and are described throughout this document.

#### 1.3.4. Terms from Specifications
{: #terms-from-specifications}

The recommendations use the following terms:

* __HTTP(S)__: The HTTP or HTTPS URI scheme and internet protocol.
* [Javascript Object Notation (JSON)][org-rfc-8259]: The terms _array_, _JSON object_, _number_, and _string_ in this document are to be interpreted as defined by the Javascript Object Notation (JSON) specification.
* [JSON-LD][org-w3c-json-ld]: Entitiy Metadata Management context is defined following JSON-LD specification.
* [RFC 2119][org-rfc-2119]: The key words _MUST_{:.strong-term}, _MUST NOT_{:.strong-term}, _REQUIRED_{:.strong-term}, _SHALL_{:.strong-term}, _SHALL NOT_{:.strong-term}, _SHOULD_{:.strong-term}, _SHOULD NOT_{:.strong-term}, _RECOMMENDED_{:.strong-term}, _MAY_{:.strong-term}, and _OPTIONAL_{:.strong-term} in this document are to be interpreted as described in RFC 2119.
* [URI][org-iana-uri-schemes]: URIs are defined following the IANA URI-Schemes specification.


## 2. Architecture
{: #architecture}

This recommendation is based on the [Activity Streams 2.0 specification][org-w3c-activitystreams]. Changes in entity metadata over time are communicated from providers to consumers via _Entity Change Activities_{:.term} that describe a change to an entity. These are collected together in _Change Set_{:.term} documents that are organized as shown in the diagram below.

<img src="{{site.baseurl}}/assets/images/figures/emm_architecture.png">

### 2.1. JSON-LD Representation

The use of JSON-LD with a specific `@context` that extends the [Activity Streams 2.0 specification][org-w3c-activitystreams] allows Entity Metadata Consumers to parse the resulting documents using standard JSON tools, and also allows the data to be interpreted according to the RDF Data Model (see [Relationship to RDF](https://www.w3.org/TR/json-ld/#relationship-to-rdf)).


## 3. Organizational Structures
{: #organizational-structures}

### 3.1. Entry Point
{: #entry-point}

Reference:  [Ordered Collection][org-w3c-activitystreams-coretype-orderedcollection] in the [Activity Stream specification][org-w3c-activitystreams]
{:.reference}

Each _Entity Set_{:.term} _MUST_{:.strong-term} have at least one Entry Point. It _MAY_{:.strong-term} have multiple Entry Points to satisfy different use cases. For example, one Entry Point may provide detailed changes to support incremental updates of a full cache and a second may only provide a list of primary label changes.

The Entry Point _MUST_{:.strong-term} be implemented as an _Ordered Collection_{:.term} following the definition in the Activity Stream specification. The key points are repeated here with examples specific to Entity Metadata Management.

#### FULL EXAMPLE for Entry Point:

QUESTION: should the example include published for first?
{:.todo}
QUESTION: should the example include published for last?
{:.todo}

```json-doc
{
  "@context": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json",
  "summary": "My Authority - Change Documents",
  "type": "OrderedCollection",
  "id": "https://data.my.authority/change_documents/2021/activity-stream",
  "url": "https://my.authority/2021-01-01/full_download",
  "first": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/1",
    "published": "2021-01-01T05:00:01Z"
  },
  "last": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/12",
    "published": "2021-08-27T05:00:01Z"
  },
  "totalItems": 123
}
```

<a id="entry-point-context" class="anchor-definition">
__@context__

Reference: [JSON-LD scoped context][org-w3c-json-ld-scoped-contexts]
{:.reference}

The `@context` is used to refer a JSON-LD context which, in its simplest form, maps terms to IRIs.

_Entity Metadata Management_{:.term} activity streams _MUST_{:.strong-term} include the following [context][emm-context-api-01] definition at the top-level of each API response:

```json-doc
{
  "@context": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json",
  // rest of API response
}
```

The _Entity Metadata Management_{:.term} context includes information for all parts of this recommendation and thus the same context definition is used in all API responses. The _Entity Metadata Management_{:.term} context imports the _Activity Stream_{:.term} [context][org-w3c-activitystreams-context-definition] and thus it is not necessarily to specify that explicitly in API responses.

Implementations _MAY_{:.strong-term} include additional extension contexts, in which case the value of `@context` will be a list with the _Entity Metadata Management_{:.term} context first. Extension contexts _MUST NOT_{:.strong-term} override terms defined in the _Entity Metadata Management_{:.term} context or the underlying _Activity Stream_{:.term} context. Implementations _MAY_ also use additional properties and values not defined in a JSON-LD `@context` with the understanding that any such properties will likely be unsupported and ignored by consuming implementations that use the standard JSON-LD algorithms.

<a id="entry-point-summary" class="anchor-definition">
__summary__

Reference:  [summary][org-w3c-activitystreams-property-summary] property definition
{:.reference}

The summary is a natural language summarization of the purpose of the _Entry Point_{:.term}

The _Entry Point_{:.term} _SHOULD_{:.strong-term} have a _summary_{:.term} property. For an _Entry Point_{:.term}, the summary _MAY_{:.strong-term} be a brief description of the _Entity Set_{:.term} in which the described changes occurred. If there are multiple entry points to the same collection, it is _RECOMMENDED_{:.strong-term} that the summary include information that distinguishes each entry point from the others.

```json-doc
{ "summary": "My Authority - Entity Change List" }
```

```json-doc
{ "summary": "My Authority - Incremental Updates from 2022-01-01 Full Download" }
```

<a id="entry-point-type" class="anchor-definition">
__type__

Reference:  [type][org-w3c-activitystreams-property-type] property definition
{:.reference}

The type property identifies the Activity Stream type for the _Entry Point_{:.term}.

The _Entry Point_{:.term} _MUST_{:.strong-term} have a _type_{:.term} property. The value _MUST_{:.strong-term} be `OrderedCollection`.

```json-doc
{ "type": "OrderedCollection" }
```

<a id="entry-point-id" class="anchor-definition">
__id__

Reference:  [id][org-w3c-activitystreams-property-id] property definition
{:.reference}

The id is a unique identifier of the _Entry Point_{:.term}.

The _Entry Point_{:.term} _MUST_{:.strong-term} have an _id_{:.term} property. The value _MUST_{:.strong-term} be a string and it _MUST_{:.strong-term} be an HTTP(S) URI. The JSON representation of the _Ordered Collection_{:.term} _Entry Point_{:.term} _MUST_{:.strong-term} be available at the URI.

```json-doc
{ "id": "https://data.my.authority/change_documents/2021/activity-stream" }
```

<a id="entry-point-url" class="anchor-definition">
__url__

Reference: [url][org-w3c-activitystreams-property-url] property definition
{:.reference}

The _Entry Point_{:.term} _MAY_{:.strong_term} have a `url` property providing one or more links to representations of the _Entity Set_{:.term}. If there are multiple links then the value of the `url` property will be an array.

A common use of the `url` property is a link to the full download for the collection.

```json-doc
{ "url": "https://my.authority/2021-01-01/full_download" }
```

<a id="entry-point-first" class="anchor-definition">
__first__

Reference:  [first][org-w3c-activitystreams-property-first] property definition
{:.reference}

A link to the first _Change Set_{:.term} in this _Entry Point_{:.term} for the _Entity Collection_{:.term}.

The _Entry Point_{:.term} _MUST_{:.strong-term} have a _first_{:.term} property. The value _MUST_{:.strong-term} be a JSON object, with the _id_{:.term} and _type_{:.term} properties. The value of the _id_{:.term} property _MUST_{:.strong-term} be a string, and it _MUST_{:.strong-term} be the HTTP(S) URI of the first page of items in the _Entry Point_{:.term}. The value of the _type_{:.term} property _MUST_{:.strong-term} be the string `OrderedCollectionPage`.

QUESTION: should the example include published?
{:.todo}

```json-doc
{
  "first": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/1",
    "published": "2021-01-01T05:00:01Z"
  }  
}
```

<a id="entry-point-last" class="anchor-definition">
__last__

Reference:  [last][org-w3c-activitystreams-property-last] property definition
{:.reference}

A link to the last _Change Set_{:.term} in this _Entry Point_{:.term} for the _Entity Collection_{:.term}.

The _Entry Point_{:.term} _MUST_{:.strong-term} have a _last_{:.term} property. The value _MUST_{:.strong-term} be a JSON object, with the _id_{:.term} and _type_{:.term} properties. The value of the _id_{:.term} property _MUST_{:.strong-term} be a string, and it _MUST_{:.strong-term} be the HTTP(S) URI of the last page of items in the _Entry Point_{:.term}. The value of the _type_{:.term} property _MUST_{:.strong-term} be the string `OrderedCollectionPage`.

QUESTION: should the example include published?
{:.todo}

```json-doc
{
  "last": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/12",
    "published": "2021-08-27T05:00:01Z"
  }  
}
```

<a id="entry-point-totalitems" class="anchor-definition">
__totalItems__

Reference: [totalItems][org-w3c-activitystreams-property-totalitems] property definition
{:.reference}

The count of all _Entity Change Activities_{:.term} across all _Change Sets_{:.term} in the _Entry Point_{:term} for the _Entity Collection_{:.term}.

The _Entry Point_{:.term} _MAY_{:.strong-term} have a _totalItems_{:.term} property. If included, the value _MUST_{:.strong-term} be an integer, and it _SHOULD_{:.strong-term} be the cumulative count of _Entity Change Activities_{:.term} across all _Change Sets_{:.term}.

```json-doc
{
  "totalItems": 123
}
```

### 3.2. Change Set
{: #change-set}

Reference:  [Ordered Collection Page][org-w3c-activitystreams-coretype-orderedcollectionpage] in the [Activity Stream specification][org-w3c-activitystreams]
{:.reference}

Each time a set of changes is published, changes _MUST_{:.strong-term} be released in at least one _Change Set_{:.term}. Changes _MAY_{:.strong-term} be published across multiple _Change Sets_{:.term}. For example, a site may decide that each _Change Set_{:.term} will have at most 50 changes and if that maximum is exceeded during the release time period, then a second _Change Set_{:.term} will be created. All changes within a _Change Set_{:.term} and, if applicable, across  Change Sets _MUST_{:.strong-term} be sorted in date-time order in the _orderedItems_{:.term} property with the earliest change in the set appearing first and most recent change in the set appearing last.

It is _RECOMMENDED_{:.strong-term} that change sets be published on a regular schedule. It is recognized that there are many factors that can impact this recommendation, including but not limited to, the volume of changes, the consistency of timing of changes, the tolerance of consumers for delays in the publication schedule, resources for producing _Change Sets_{:.term}.

_Change Sets_{:.term} _MUST_{:.strong-term} be implemented as an _Ordered Collection Page_{:.term} following the definition in the Activity Stream specification. The key points are repeated here with examples specific to Entity Metadata Management.

#### FULL EXAMPLE for Change Set:

```json-doc
{
  "@context": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json",
  "type": "OrderedCollectionPage",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2",
  "partOf": {
    "type": "OrderedCollection",
    "id": "https://data.my.authority/change_documents/2021/activity-stream"
  },
  "totalItems": 2,
  "prev": {
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/1",
    "type": "OrderedCollectionPage",
    "published": "2021-01-01T05:00:01Z"
  },
  "next": {
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/3",
    "type": "OrderedCollectionPage",
    "published": "2021-03-01T05:00:01Z"
  },
  "orderedItems": [{
      "type": "Create",
      "id": "https://data.my.authority/change_documents/2021/activity-stream/cd1",
      "updated": "2021-02-01T15:04:22Z",
      "object": {
        "id": "https://my.authority/term/milk",
        "type": "Term"
      }
    },
    {
      "type": "Deprecate",
      "id": "https://data.my.authority/change_documents/2021/activity-stream/cd2",
      "updated": "2021-02-01T17:11:03Z",
      "orderedItems": [{
          "id": "https://data.my.authority/change_documents/2021/activity-stream/cd3",
          "type": "Create",
          "updated": "2021-02-01T17:11:03Z",
          "object": {
            "id": "https://my.authority/term/bovine_milk",
            "type": "Term"
          }
        },
        {
          "id": "https://data.my.authority/change_documents/2021/activity-stream/cd4",
          "type": "Update",
          "updated": "2021-02-01T17:11:03Z",
          "object": {
            "id": "https://my.authority/term/cow_milk",
            "type": "Term"
          }
        }
      ]
    }
  ]
}
```

NOTE: See [Entity Change Activity](#entity-change-activity) under [Entity Level Structures](#entity-level-structures) for more information on the data to be included in the `orderedItems` property.
{: .info}


## 4. Entity Level Structures
{: #entity-level-structures}

Entity level structures describe the individual changes to entity metadata within an _Entity Set_{:.term}.

The structures described in this section are used in the _orderedItems_{:.term} property of the [Change Set](#change-set). The level of detail in the _orderedItems_{:.term} depends on the use case being addressed. The [Entity Change Activities List](#entity-change-activities-list) use case can be addressed by the [Entity Change Activity](#entity-change-activities). The [Local Cache of Labels](#local-cache-of-labels) and [Local Cache of Full Dataset](#local-cache-of-full-dataset) use cases can be addressed more efficiently by also including an [Entity Patch](#entity-patch). Without an [Entity Patch](#entity-patch), the consumer must dereference the entity URI to obtain the updated entity description.

### 4.1. Entity Change Activities
{: #entity-change-activities}

Reference:  [Activity][org-w3c-activitystreams-coretype-activity] in the [Activity Stream specification][org-w3c-activitystreams]
{:.reference}

A change to Entity Metadata _MUST_{:.strong-term} be described in an _Entity Change Activity_{:.term}. An _Entity Change Activity_{:.term} _MUST_{:.strong-term} be implemented as an [Activity Streams][org-w3c-activitystreams] [`Activity`](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-activity). The activity _MUST_{:.strong-term} provide information about the type of change and the entity or entities changed. It _MAY_{:.strong-term} provide links that facilitate the consumer gathering additional information from the source dataset. This level is sufficient to address the [Entity Change Activities List](#entity-change-activities-list) use case.

#### FULL EXAMPLE for Entity Change Activity:

```json-doc
{
  "@context": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json",
  "summary": "Add entity for subject Science",
  "updated": "2021-08-02T16:59:54Z",
  "type": "Add",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/cd11",
  "partOf": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
  },
  "object": {
    "type": "Subject",
    "id": "http://my_repo/entity/science"
  }
}
```

Properties shared across all _Entity Change Activity_{:.term} types are described here. If a specific activity type handles a property differently, it will be described with that activity type in section [Types of Change](#types-of-change).

<a id="entity-change-activity-context" class="anchor-definition">
__@context__

Follow the recommendations for [@context](#entry-point-context) as described in the [Entry Point](#entry-point) section.

<a id="entity-change-activity-summary" class="anchor-definition">
__summary__

Reference:  [summary][org-w3c-activitystreams-property-summary] property definition
{:.reference}

For an _Entity Change Activity_{:.term}, the summary is a brief description of the change to entity metadata that the activity represents. It is _RECOMMENDED_{:.strong-term} that a summary be included and that it reference the type of change (e.g. "Add entity") and the entity being changed (e.g. "subject Science").

There are a limited set of types of change. See [Types of Change](#types-of-change) section for a list of types and example summaries for each. Identification of the entity will vary depending on the data represented in the _Entity Set_{:.term}.

```json-doc
{ "summary": "Add entity for subject Science" }
```

<a id="entity-change-activity-type" class="anchor-definition">
__type__

Reference:  [type][org-w3c-activitystreams-property-type] property definition
{:.reference}

Each _Entity Change Activity_{:.term} _MUST_{:.strong-term} have a _type_{:.term} property.

The type is the one of a set of predefined _Entity Change Activity_{:.term} types. See [Types of Change](#type-of-change) section for a list of types and recommendations for the value of type for each activity type.

```json-doc
{ "type": "Create" }
```

<a id="entity-change-activity-id" class="anchor-definition">
__id__

Reference:  [id][org-w3c-activitystreams-property-id] property definition
{:.reference}

The unique identifier of the _Entity Change Activity_{:.term}.

The _Entity Change Activity_{:.term} _MUST_{:.strong-term} have an _id_{:.term} property. The value _MUST_{:.strong-term} be a string and it _MUST_{:.strong-term} be an HTTP(S) URI. The JSON representation of the _Entity Change Activity_{:.term} _MUST_{:.strong-term} be available at the URI.

```json-doc
{ "id": "https://data.my.authority/change_documents/2021/activity-stream/cd11" }
```

<a id="entity-change-activity-partof" class="anchor-definition">
__partOf__

Reference:  [partOf][org-w3c-activitystreams-property-partof] property definition
{:.reference}

The _partOf_ property identifies the _Change Set_{:.term} in which this activity was published.

An _Entity Change Activity_{:.term} _MAY_{:.strong-term} use the _partOf_ property to refer back to the _Change Set_{:.term} that includes the activity. The _partOf_ property _MUST NOT_{:.strong-term} be used for any other purpose. The value _MUST_{:.strong-term} be a string and it _MUST_{:.strong-term} be an HTTP(S) URI. The JSON representation of the _Change Set_{:.term} publishing this activity _MUST_{:.strong-term} be available at the URI.

```json-doc
"partOf": {
  "type": "OrderedCollectionPage",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
}
```

### 4.2. Entity Patch
{: #entity-patch}

To support the [Local Cache of Labels](#local-cache-of-labels) or the [Local Cache of Full Dataset](#local-cache-of-full-dataset) use cases efficiently, it is _OPTIONAL_{:.strong-term} that each [Entity Change Activity](#entity-change-activity) include the _instrument_{:.term} property which provides a link an _Entity Patch_{:.term}. Without an [Entity Patch](#entity-patch), the consumer must dereference the entity URI to obtain the updated entity description.

#### FULL EXAMPLE for Entity Patch

```json-doc

{
  "@context": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json",
  "summary": "rdf_patch to create entity for term milk",
  "type": "rdf_patch",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/cd11/instrument/1",
  "partOf": {
    "type": "Create",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/cd11"
  },
  "content":
    "A <https://my_repo/entity/cow_milk>
         <https://my.authority/vocab/hasLabel> 'cow milk'@en.
     A <https://my_repo/entity/cow_milk>
         <https://my.authority/vocab/broaderTerm> <https://my_repo/entity/milk>.
     A <https://my_repo/entity/cow_milk>
         <https://my.authority/vocab/narrow_term>
         <https://my_repo/entity/bovine_milk>."
```


## 5. Types of Change
{: #types-of-change}

All _Entity Change Activities_{:.term} have a core set of properties that are described in the [Entity Change Activity](#entity-change-activity) section. Some properties are specific to the _Types of Change_. This section provides examples and descriptions of the _Entity Change Notification_{:.term} and _Entity Patch_{:.term} for each type of change. They also describe differences between similar Activity Types (e.g. _Create_{:.term} vs. _Add_{:.term}).

### 5.1. New Entity
{: #new-entity}

Reference: [add][org-w3c-activitystreams-activity-add] activity definition
{:.reference}
Reference: [create][org-w3c-activitystreams-activity-create] activity definition
{:.reference}

A new entity _SHOULD_{:.strong-term} have an [Entity Change Activity](#entity-change-Activity) with a _type_{:.term} of either _"Create"_{:.term} or _"Add"_{:.term}.

A new entity _MUST_{:.strong-term} be implemented as an _Activity_{:.term} following the [Create type definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-create) or the [Add type definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-add) in the [Activity Stream specification][org-w3c-activitystreams]. The key points are repeated here with examples specific to Entity Metadata Management.

#### Create vs. Add

An entity appearing in an _Entry Point_{:.term} stream for the first time _MUST_{:.strong-term} use _Activity_{:.term} type _Create_{:.term} or _Add_{:.term}.

_Create_{:.term} _SHOULD_{:.strong-term} be used when the entity is new in the source dataset.

_Add_{:.term} _SHOULD_{:.strong-term} be used when the entity exists in the source dataset, but was previously not available through the _Entry Point_{:.term} and now is being made available in the stream. Situations where this might happen include, but are not limited to, change in permissions, end of an embargo, temporary removal and now being made available again.

A new _Entry Point_{:.term} _MAY_{:.strong-term} choose to populate the stream with all existing entities. In this case, the initial population of the stream with all existing entities _SHOULD_{:.strong-term} use _Add_{:.term}.

#### EXAMPLE Entity Change Activity for Create

Complete Example

```json-doc
{
  "@context": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json",
  "summary": "New entity for term milk",
  "updated": "2021-08-02T16:59:54Z",
  "type": "Create",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/cd11",
  "partOf": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
  },
  "object": {
    "type": "Term",
    "id": "http://my_repo/entity/cow_milk"
  },
  "instrument":
  {
    "type": "rdf_patch",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/cd11/instrument/1"
  }
}
```

__summary__

Reference:  [summary][org-w3c-activitystreams-property-summary] property definition
{:.reference}

A summary is a brief description of a change to entity metadata. It is _RECOMMENDED_{:.strong-term} that a summary be included and that it reference the type of change and the entity being changed.

```json-doc
{ "summary": "Add entity for subject Science" }
```

__type__

Reference:  [type][org-w3c-activitystreams-property-type] property definition
{:.reference}

The type is the one of a set of predefined _Entity Change Activity_{:.term} types.

Each _Entity Change Activity_{:.term} _MUST_{:.strong-term} have a _type_{:.term} property. For an activity for a newly available entity, the value _SHOULD_{:.strong-term} be one of either `Create` or `Add`.

```json-doc
{ "type": "Create" }
```
or
```json-doc
{ "type": "Add" }
```

__id__

Reference:  [id][org-w3c-activitystreams-property-id] property definition
{:.reference}

The unique identifier of the _Entity Change Activity_{:.term}.

The _Entity Change Activity_{:.term} _MUST_{:.strong-term} have an _id_{:.term} property. The value _MUST_{:.strong-term} be a string and it _MUST_{:.strong-term} be an HTTP(S) URI. The JSON representation of the _Entity Change Activity_{:.term} _MUST_{:.strong-term} be available at the URI.

```json-doc
{ "id": "https://data.my.authority/change_documents/2021/activity-stream/cd11" }
```

__partOf__

Reference:  [partOf][org-w3c-activitystreams-property-partof] property definition
{:.reference}

The _partOf_ property identifies the _Change Set_{:.term} in which this activity was published.

An _Entity Change Activity_{:.term} _MAY_{:.strong-term} use the _partOf_ property to refer back to the _Change Set_{:.term} that includes the activity. The _partOf_ property _MUST NOT_{:.strong-term} be used for any other purpose.

```json-doc
"partOf": {
  "type": "OrderedCollectionPage",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
}
```

#### EXAMPLE Entity Patch for Create

Complete Example

```json-doc
{
  "@context": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json",
  "summary": "rdf_patch to create entity for term milk",
  "type": "rdf_patch",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/cd11/instrument/1",
  "partOf": {
    "type": "Create",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/cd11"
  },
  "content":
    "A <https://my_repo/entity/cow_milk>
         <https://my.authority/vocab/hasLabel> 'cow milk'@en.
     A <https://my_repo/entity/cow_milk>
         <https://my.authority/vocab/broaderTerm> <https://my_repo/entity/milk>.
     A <https://my_repo/entity/cow_milk>
         <https://my.authority/vocab/narrow_term>
         <https://my_repo/entity/bovine_milk>."
}  
```

### 5.2. Update Entity
{: #update-entity}

An updated entity _SHOULD_{:.strong-term} have an [Entity Change Activity](#entity-change-activity) with a _type_{:.term} of _"Update"_{:.term}.

An updated entity _MUST_{:.strong-term} be implemented as an _Activity_{:.term} following the [Update type definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-update)in the [Activity Stream specification][org-w3c-activitystreams]. The key points are repeated here with examples specific to Entity Metadata Management.

EXAMPLE Entity Change Activity for Update

```json-doc
{
  "@context": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json",
  "summary": "Update entity term milk",
  "updated": "2021-08-02T16:59:54Z",
  "type": "Update",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/cd31",
  "partOf": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
  },
  "object": {
    "type": "Term",
    "id": "http://my_repo/entity/milk"
  },
  "instrument": {
    "type": "rdf_patch",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/cd31/instrument/1"
  }
}
```

EXAMPLE Entity Patch for Update

```json-doc
{
  "@context": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json",
  "summary": "rdf_patch to update entity term milk",
  "type": "rdf_patch",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/cd31/instrument/1",
  "partOf": {
    "type": "Update",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/cd31",
  },
  "content":
    "A <http://my_repo/entity/milk> <http://my.authority/vocab/hasLabel> 'Milk'@en.
     D <http://my_repo/entity/milk> <http://my.authority/vocab/hasLabel> 'milk'@en."
```

### 5.3. Delete Entity
{: #delete-entity}

It is _RECOMMENDED_{:.strong-term} that entities be marked as _Deprecated_{:.term} in the source dataset instead of deleting the entity from the source dataset. If the entity is deprecated, follow the _Entity Change Activity_{:.term} described in [Deprecate Entity](#deprecate-entity).
{: .warning}

An entity that has been fully deleted from the source dataset _SHOULD_{:.strong-term} have an [Entity Change Activity](#entity-change-activity) with a _type_{:.term} of _"Delete"_{:.term} or _"Remove"_{:.term}.

A deleted entity _MUST_{:.strong-term} be implemented as an _Activity_{:.term} following the [Delete type definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-delete) or the [Remove type definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-remove) in the [Activity Stream specification][org-w3c-activitystreams]. The key points are repeated here with examples specific to Entity Metadata Management.

EXAMPLE Entity Change Activity for Delete

```json-doc
{
  "@context": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json",
  "summary": "Delete term cow_milk",
  "updated": "2021-08-02T16:59:54Z",
  "type": "Delete",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/cd21",
  "partOf": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
  },
  "object": {
    "type": "Term",
    "id": "http://my_repo/entity/cow_milk"
  },
  "instrument": {
    "type": "rdf_patch",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/cd21/instrument/1"
  }
}
```

EXAMPLE Entity Patch for Delete

```json-doc
{
  "@context": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json",
  "summary": "rdf_patch to delete entity term cow_milk",
  "type": "rdf_patch",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/cd21/instrument/1",
  "partOf": {
    "type": "Delete",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/cd21"
  },
  "content":
    "D <http://my_repo/entity/cow_milk>
         <http://my.authority/vocab/hasLabel> 'cow milk'@en.
     D <http://my_repo/entity/cow_milk>
         <http://my.authority/vocab/broaderTerm> <http://my_repo/entity/milk>.
     D <http://my_repo/entity/cow_milk>
         <http://my.authority/vocab/narrow_term>
         <http://my_repo/entity/bovine_milk>."
}  
```

### 5.4. Deprecate Entity
{: #deprecate-entity}

Deprecation indicates that an existing entity in the authority has been updated to indicate that it should no longer be used. Whenever possible, the description should indicate which entity should be used instead.

There are two common scenarios. In the first, the replacement entity already exists and the deprecation updates the deprecated entity only. In the second scenario, the replacement entity does not exist prior to the deprecation. In this case, the replacement entity is created and the deprecation updates the deprecated entity.

An entity that has been deprecated _SHOULD_{:.strong-term} have an [Entity Change Activity](#entity-change-activity) with the _type_{:.term} `Deprecate`. The `Deprecate` activity _MUST_{:.strong-term} be implemented as either a single activity (similar to the [Update Entity](#update-entity) case but with more specific semantics), or using the `orderedItems` property with a sequence of activities that implement the deprecation. In the second scenario this would typically involve a `Create` activity for the replacement entity, and an `Update` activity for the deprecated entity.

EXAMPLE Entity Change Activity for Deprecate in the Scenario where a Replacement Entity Already Exists

```json-doc
{
  "@context": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json",
  "summary": "Deprecate term cow milk",
  "updated": "2021-08-02T16:59:57Z",
  "type": "Deprecate",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/cd47",
  "partOf": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
  },
  "object": {
     "type": "Term",
     "id": "http://my_repo/entity/cow_milk"
  },
  "instrument": {
    "type": "rdf_patch",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/cd42/instrument/2"
  }
}
```

EXAMPLE Entity Change Activity for Deprecate in the Scenario where a Replacement Entity is Created

```json-doc
{
  "@context": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json",
  "summary": "Create term bovine milk and Deprecate term cow milk",
  "updated": "2021-08-02T16:59:54Z",
  "type": "Deprecate",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/cd42",
  "partOf": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
  },
  "totalItems": 2,
  "orderedItems": [
    {
      "summary": "Create term bovine milk",
      "type": "Create",
      "object": {
        "type": "Term",
        "id": "http://my_repo/entity/bovine_milk"
      },
      "instrument": {
        "type": "rdf_patch",
        "id": "https://data.my.authority/change_documents/2021/activity-stream/cd42/instrument/1"
      }
    },
    {
      "summary": "Deprecate term cow milk",
      "type": "Update",
      "object": {
        "type": "Term",
        "id": "http://my_repo/entity/cow_milk"
      },
      "instrument": {
        "type": "rdf_patch",
        "id": "https://data.my.authority/change_documents/2021/activity-stream/cd42/instrument/2"
      }
    }
  ]
}
```

### 5.5. Split Entity
{: #split-entity}

An entity that has been split into two or more new entities _SHOULD_{:.strong-term} have an [Entity Change Activity](#entity-change-activity) with the _type_{:.term} `Split`. The `Split` activity _MUST_{:.strong-term} be implemented using the `orderedItems` property with a sequence of activities that implement the split. This typically involves multiple `Create` activities for new entities created by the split, and deprecation of the original entity that was split through a `Deprecate` activity.

EXAMPLE Entity Change Activity for Split

```json-doc
{
  "@context": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json",
  "summary": "Split cow milk into bovine milk and oxen milk",
  "updated": "2021-08-02T16:59:54Z",
  "type": "Split",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/cd51",
  "partOf": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
  },
  "totalItems": 3,
  "orderedItems": [
    {
      "summary": "Create term bovine milk",
      "type": "Create",
      "object": {
        "type": "Term",
        "id": "http://my_repo/entity/bovine_milk"
      },
      "instrument": {
        "type": "rdf_patch",
        "id": "https://data.my.authority/change_documents/2021/activity-stream/cd51/instrument/1"
      }
    },
    {
      "summary": "Create term oxen milk",
      "type": "Create",
      "object": {
        "type": "Term",
        "id": "http://my_repo/entity/oxen_milk"
      },
      "instrument": {
        "type": "rdf_patch",
        "id": "https://data.my.authority/change_documents/2021/activity-stream/cd51/instrument/2"
      }
    },
    {
      "summary": "Deprecate term cow milk",
      "type": "Deprecate",
      "object": {
        "type": "Term",
        "id": "http://my_repo/entity/cow_milk"
      },
      "instrument": {
        "type": "rdf_patch",
        "id": "https://data.my.authority/change_documents/2021/activity-stream/cd51/instrument/3"
      }
    }
  ]
}
```

### 5.6. Merge Entities
{: #merge-entity}

Two or more entities that have been merged into one new entity _SHOULD_{:.strong-term} have an [Entity Change Activity](#entity-change-activity) with the _type_{:.term} `Merge`. The `Merge` activity _MUST_{:.strong-term} be implemented using the `orderedItems` property with a sequence of activities that implement the merge. This typically involves a `Create` activity for a new entity created by the merge, and deprecation of the original entities that were merged through `Deprecate` activities.

EXAMPLE Entity Change Activity for Merge

```json-doc
{
  "@context": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json",
  "summary": "Merge bovine milk and oxen milk into cow milk",
  "updated": "2021-08-02T16:59:54Z",
  "type": "Merge",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/cd61",
  "partOf": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
  },
  "totalItems": 3,
  "orderedItems": [
    {
      "summary": "Create term cow milk",
      "type": "Create",
      "object": {
        "type": "Term",
        "id": "http://my_repo/entity/cow_milk"
      },
      "instrument": {
        "type": "rdf_patch",
        "id": "https://data.my.authority/change_documents/2021/activity-stream/cd61/instrument/1"
      }
    },
    {
      "summary": "Deprecate term bovine milk",
      "type": "Deprecate",
      "object": {
        "type": "Term",
        "id": "http://my_repo/entity/bovine_milk"
      },
      "instrument": {
        "type": "rdf_patch",
        "id": "https://data.my.authority/change_documents/2021/activity-stream/cd61/instrument/2"
      }
    },
    {
      "summary": "Deprecate term oxen milk",
      "type": "Deprecate",
      "object": {
        "type": "Term",
        "id": "http://my_repo/entity/oxen_milk"
      },
      "instrument": {
        "type": "rdf_patch",
        "id": "https://data.my.authority/change_documents/2021/activity-stream/cd61/instrument/3"
      }
    }
  ]
}
```


## 6. Producing Entity Change Sets
{: #producing-entity-change-sets}

Refer to individual sections for detailed examples of all structures being created by these steps.
{:.info}

#### Decision points

##### When to release

How often do you want to create change sets?  Some common approaches are:
* at predetermined time intervals (e.g. hourly, nightly, weekly, monthly, quarterly)
* after a certain number of changes have occurred (e.g. 10, 20, 50, 100, 500 changes)

Considerations for this decision:
* How often does you data change?
* How much of your data typically changes during a time interval?
* What is the tolerance of consumers for delays before a change is available?

##### What date property to use?

Reference:  [Date and Times][org-w3c-activitystreams-core-datetime]
{:.reference}
Reference:  [endTime][org-w3c-activitystreams-property-endtime] property definition
{:.reference}
Reference:  [startTime][org-w3c-activitystreams-property-starttime] property definition
{:.reference}
Reference:  [published][org-w3c-activitystreams-property-published] property definition
{:.reference}
Reference:  [updated][org-w3c-activitystreams-property-updated] property definition
{:.reference}
Reference:  [deleted][org-w3c-activitystreams-property-deleted] property definition
{:.reference}

TODO: Add discussion and reasoning for when to use each type of date. Still need to determine our recommendations around dates.
{:.todo}

### For Activities

QUESTION: Should each place that talks about a part of the feed include a link into the examples of that part?  For example, include link to Entry Point in the instructions to create it; a link to a Change Set when it is created; etc. OR as is done here, a link at the top of the section to the entry point for the use case being described.
{:.todo}

[Live Example of an Activity Entry Point][emm-change-api-example-activities]

#### When a full download of the dataset is created

* Note the datetime when the snapshot for the download was taken.
* On your download page, include a link to the download file.
* Beside the download link, mark the datetime stamp.
* Create an entry point.

#### As changes are made to the dataset

TODO: What entity types do we want to list?  These aren't formally defined.
{:.todo}

Record information about the entity and the changes
* dereferencable URI for the entity in your system
* summary description of change (e.g. Add term Science)
* type of entity (e.g. Term, ...)
* type of change (e.g. `Add`, `Remove`, `Update`, `Deprecate`, `Split`, `Merge`)
* RDF patch steps describing what was changed (optional, see note)

NOTE: Storing RDF patch steps is optional for Activities. All changes are required for Incremental Updates and changes to labels are required for Label Changes.
{:.info}

#### When ready to publish a change set

Determine URIs for new and existing objects that will be referenced in various properties:
* `entry_point_uri` = get the URI of the newly created or existing entry point
* `prev_change_set_uri` = get the previous change set URI from the entry point's `last` property
* `change_set_uri` = determine URI that will resolve to the change set
* `entity_uri` = the dereferencable URI for the entity that return the entity graph
* `change_activity_uri` = determine URI that will resolve to each entity change activity
* `change_rdf_patch_uri` = determine URI that will resolve to the instrument holding the RDF patch for each activity

Create the change set:
* set `id` property to `change_set_uri`
* set `published` property to the datetime this change set will become public
* set `partOf` property to use `entry_point_uri` for `id`
* set `prev` property to use `prev_change_set_uri` for `id`
* set `totalItems` property to the number of change activities that will be in this change set
* for each change activity from oldest to newest, add it to the `orderedItems` property array
  * set `type` property to the change type (e.g. `Add`, `Remove`, etc.)
  * set `id` property to the `change_activity_uri` for this change
  * set a date
    * the `published` property to the datetime the change set is being published
    * the `endDate` property to the datetime the change was completed in the system of record
  * set `object` to use `entity_uri` for `id`

Update previous change set:
* add a `next` property that points to the new change set

Update entry point:
* if this is the first change set published for an entry point, add the `first` property in the entry point with
    * set `type` property to `OrderCollectionPage`
    * set `id` property to the _URI resolving to the new change set_
    * set `published` property to the  _datetime the change set is published_
* add or update the `last` property in the entry point
    * set `type` property to `OrderCollectionPage`
    * set `id` property to the _URI resolving to the new change set_
    * set `published` property to the _datetime the change set is published_

Create each change activity:
* create a change activity using the information saved as changes were created

### For Label Changes

[Live Example of Label Changes Entry Point][emm-change-api-example-partialcache]

The process for creating Label Changes is the same as for Activities with a few additional steps noted in this section if RDF patches are implemented.

#### As changes are made to the dataset

Record all the information listed under Entity Change Activity and also:
* RDF patch steps describing the label changes

#### When ready to publish a change set

Create the change set as described for Entity Change Activities and also:
* for each change activity:
    * set `instrument` property to use `change_rdf_patch_uri` for `id`

Create an RDF patch for each change activity:
* record the RDF patch statements in the order that they need to be applied to recreate the label changes to an entity

### For Incremental Updates

[Live Example of Incremental Updates Entry Point][emm-change-api-example-fullcache]

The process for creating Incremental Updates is the same as for Activities with a few additional steps noted in this section if RDF patches are implemented.

#### As changes are made to the dataset

Record all the information listed under Entity Change Activity and also:
* RDF patch steps describing what was changed

#### When ready to publish a change set

Create the change set as described for Entity Change Activities and also:
* for each change activity:
    * set `instrument` property to use `change_rdf_patch_uri` for `id`

Create an RDF patch for each change activity:
* record the RDF patch statements in the order that they need to be applied to recreate the changes to an entity


## 7. Consuming Entity Change Sets
{: #consuming-entity-change-sets}

### 7.1 Example consuming Library of Congress Activity Stream

_CAUTION: This section is under construction. This section may or may not be removed from the final draft, in lieu of, a section that is a general example based off the final recommendations._
{:.todo}

Library of Congress provides an activity stream for several authorities (e.g. names, genre/forms, subjects, etc.).

Characteristics:
* an entity will appear in the activity stream at most one time
* the date of the activity for an entity will be the date of the most recent change
* the first page of the stream has the most recent activities
* activities on a page are listed from newest to oldest
* the date of an activity is the time the ???

_What does the date of an activity represent?_
{:.todo}

Assumptions:
* the activity MUST includes a URL that dereferences to a first order graph that
  * MUST include all triples where the entity is the subject (<entity_uri> <predicate> <object>)
  * MUST include all blanknodes, and related sub-graph, where the blanknode is the object and the entity is the subject (<entity_uri> <predicate> <_:b1>)
  * MAY include triples for entities that are external to the base datasource if the entity is not available in another activity stream
* the activity MAY include another URL that derefences to a graph that
  * MAY include additional triple for other entities that are external to the base datasource that serve as object of the entity's triple (<entity_uri> <predicate> <another_entity_uri)

_NOTE: A site may choose to use the second graph if they do not process other activity streams nor maintain their cache of each datasource in a separate triple store._
{:.note}

Recommendations:
* if maintaining a full cache, ingest latest full download before processing the related activity stream
* each time the activity stream is processed, save the date of the more recently processed entity

Processing for a full cache:
* navigate to the entry point for the activity stream
* navigate to the first page of the activity stream
* starting with the first activity on the first page and continue processing until the date of the activity is older than the date recorded the last time the stream was processed
  * if activity type == REMOVE, remove the following triples from the cache
    * blank nodes, and related sub-graph, where the blank nodes is the object for a triple with the entity as subject (<entity_uri> <predicate> <_:b1>)
    * triples where the entity is the subject (<entity_uri> <predicate> <object>)
  * if activity type == ADD, dereference the entity URI and add the following triples to the cache
    * all triples where the entity is subject (<entity_uri> <predicate> <object>)
    * all triples, and related sub-graph, where the entity is subject and a blank node is object (<entity_uri> <predicate> <_:b1>)
  * if activity type == UPDATE, dereference the entity URI and add the following triples to the cache
    * perform the steps for a REMOVE
    * perform the steps for an ADD
  * next activity if there is one OR first activity on the next page OR stop if no next page  
  * stop if date of the activity is later than saved last processed date

Pseudocode:
```
go to activity stream
page = activity_stream.first
activity = page.activities.first
LOOP
  switch(activity.type)
  case REMOVE, UPDATE
    remove all triples, and sub-graph, where <subject_uri> == activity.object.id && <object_uri>.is_a? blank_node
    remove all triples where <subject_uri> == activity.object.id
  case ADD, UPDATE
    graph = dereference(activity.object.url.skos.nt)
    add all triples, and sub-graph, where graph.triple.subject == activity.object.id && <object_uri>.is_a? blank_node
    add all triples where graph.triple.subject == activity.object.id  
  end

  if activity == page.last_activity
    page = page.next
    activity == page.first_activity
  else
    activity == activity.next_activity
  end
  STOP if activity.date < last_process_date
end
```

{% include api/links.md %}
