---
title: EMM Change Document API 0.1
title_override: EMM Change Document API 0.1
permalink: api/0.1/recommendations.html
id: change-api
layout: spec
cssversion: 3
tags: [specifications, recommendations, change-api]
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
---

## Status of this Document

_This is a very preliminary draft.  Expect considerable changes to this document._
{:.todo}

{:.no_toc}
__This Version:__ {{ page.major }}.{{ page.minor }}.{{ page.patch }}{% if page.pre != 'final' %}-{{ page.pre }}{% endif %}

__Latest Stable Version:__ [{{ site.change_api.stable.major }}.{{ site.change_api.stable.minor }}.{{ site.change_api.stable.patch }}][change-stable-version]

__Previous Version:__

**Editors**

{% include api/editors.md editors=page.editors %}

{% include api/copyright.md %}

----

<div class="todo">
TODOS
<ul>
  <li>update context to emm context</li>
  <li>fill in more terminology</li>
  <li>update diagram to more closely follow ER diagram conventions</li>
  <li>set up page that lists existing implementations</li>
</ul>

QUESTIONS
<ul>
  <li>decide on recommendations for date handling (options: startTime, endTime, updated, published)</li>
  <li>is there a good way to point to documentation, downloads, etc. for an authority?</li>
  <li>should this point to our original documentation as a reference or is this document sufficient?</li>
</ul>
</div>

## 1. Introduction
{: #introduction}

The primary purpose of this document is to establish a pattern that supports sharing changes to entities and their metadata curated by Entity Metadata Providers with the community of Entity Metadata Consumers (e.g. libraries, museums, galleries, archives).  Use of a consistent pattern allows for the creation of software tools for producing and consuming changes in entity metadata.

The recommendations in this document leverage existing techniques, specifications, and tools in order to promote widespread adoption of an easy-to-implement service. The service describes changes to entity metadata and the location of those resources to harvest. Content providers can implement this API to enable notifications of change and incremental cache updates.

### 1.1. Objectives and Scope
{: #objectives-and-scope}

The objective of these recommendations is to provide a machine to machine API that provides the information needed to describe changes to entity metadata across the lifecycle of an entity.  The intended audiences are Entity Metadata Provides who curate aggregations of entity metadata within an area of interest, Entity Metadata Consumers who use the entity metadata, and Entity Metadata Developers who create applications and tools that help consumers connect to entity metadata from providers. While this work may benefit others wanting to express changes in data, the objective of the API is to specify an interoperable solution that best and most easily fulfills the need to express and process changes in entity metadata within the community of participating organizations.

The discovery of changes to entity metadata requires a consistent and well understood pattern for entity metadata providers to publish lists of links to entities that have metadata changes and details on changes that have occurred.  Changes include newly available entities with metadata, removed entities, as well as, changes to entities and their metadata.  This allows a baseline implementation of change management systems that process the list of changes. 

This process can be optimized by allowing the content providers to publish changes in chronological order including descriptions of how their content has changed, enabling consuming systems to retrieve only the resources that have been modified since they were last retrieved. Finally, for rapid synchronization, a system of notifications pushed from the publisher to a set of subscribers can reduce the amount of effort required to constantly poll multiple sources to see if anything has changed.

__Change Notifications__<br>These recommendations do not include a subscription mechanism for enabling change notifications to be pushed to remote systems. Only periodic polling for the set of changes that must be processed is supported. A subscription/notification pattern may be added in a future version after implementation experience with the polling pattern has demonstrated that it would be valuable.
{: .warning}

Work that is out of scope of this API includes the recommendation or creation of any descriptive metadata formats, and the recommendation or creation of metadata search APIs or protocols. The diverse domains represented across the entity metadata already have successful standards fulfilling these use cases. Also out of scope is optimization of the transmission mechanisms providing access points for consumers to query.

### 1.2. Use Cases
{: #use-cases}

Three primary use cases were identified that drive the recommendations in this document.  The use cases are listed from a simple change document with minimal information to a fully defined change document including details about what changed. 

#### 1.2.1. Notifications
{: #notifications}

Entity metadata consumers want to be notified of any modifications or deletions for entities on their interest list, as well as new entities.  This allows for a comparison between the consumer's list and the producer's notification list of modified and deleted entities.  For any that overlap, the consumer will take additional actions if needed.

To address this use case, the provider creates and makes available a list of the URIs for any new, modified, or deleted entities.  The consumer will need to take additional actions to identify specific changes to entities of interest.

#### 1.2.2. Local Cache of Labels
{: #local-cache-of-labels}

Entity metadata consumers persist references to entity metadata by saving the URI as part of their local datastore.  URIs may not be understandable to application users.  In order to be able to display a human readable label, a label may be retrieved from the producer's datastore by dereferencing the URI.  For performance reasons, the label is generally cached in the local datastore to avoid having to fetch the label every time the entity reference is displayed to an end user.  If the label changes in the producer's datastore, the consumer would like to update the local cache of the label.

To address this use case, the provider creates and makes available a list of URIs and their new labels.  The consumer can compare the list of URIs with those stored in the local application and update the cached labels.

__Additional Cached Metadata__<br>In some cases, additional metadata is also cached as part of the external reference, but this is less common.  Verification of the additional metadata may require the consumer to take additional actions.
{: .warning}


#### 1.2.3. Local Cache of Full Dataset
{: #local-cache-of-full-dataset}

A consumer may decide to make a full cache of a dataset of entity metadata.  This is commonly done for several reasons including, but not limited to, increased control over uptime, throughput, and indexing for search.  The cache needs to stay in sync with the source dataset as near to real time as is possible using incremental updates.

To address this use case, the provider creates and makes available a dated list of all new, modified, and deleted entities along with specifics about how the entities have changed.  The consumer can process a stream of change documents, from oldest to newest, that was published since their last incremental update.  Specific details about each change can be used to update the local cache.

### 1.3. Terminology
{: #terminology}

#### 1.3.1. Roles
{: #roles}

TODO:  Maybe put a list of providers in an appendix instead of here.
{:.todo}

* Entity Metadata Provider: An organization that collects, curates, and provides access to metadata about entities within an area of interest.  The Library of Congress maintains several [collections](https://id.loc.gov/), including but not limited to, Library Subject Headings, Name Authority, Genres/Form Terms.  The Getty maintains several [vocabularies](https://www.getty.edu/research/tools/vocabularies/index.html).  There are many other providers.
* Entity Metadata Consumer: Any institution that references or caches entity metadata from a provider.  The use cases driving the recommendations were created from libraries, museums, galleries, and archives.
* Entity Metadata Developer: Software developers that create applications and tools that help consumers connect to entity metadata from providers.  The developer may be associated with the provider, consumer, or a third party.

#### 1.3.2. Terms about Entities
{: #terms-about-entities}

* Entity Metadata Collection: Entities can be grouped based on varying criteria (e.g. subject headings, names, thesaurus, controlled vocabulary).  The term Entity Metadata Collection will be used as a generic representation of these grouping regardless of type.
* Authority: 
* Controlled Vocabulary: 
* Collection: 

#### 1.3 3. Terms from Activity Streams
{: #terms-from-activity-streams}



#### 1.3.4. Terms from Specifications
{: #terms-from-specifications}

The recommendations use the following terms:

* __HTTP(S)__: The HTTP or HTTPS URI scheme and internet protocol.
* [Javascript Object Notation (JSON)][org-rfc-8259]: The terms _array_, _JSON object_, _number_, and _string_ in this document are to be interpreted as defined by the Javascript Object Notation (JSON) specification.
* [JSON-LD][org-w3c-json-ld]: Entitiy Metadata Management context is defined following JSON-LD specification.
* [RFC 2119][org-rfc-2199]: The key words _MUST_{:.strong-term}, _MUST NOT_{:.strong-term}, _REQUIRED_{:.strong-term}, _SHALL_{:.strong-term}, _SHALL NOT_{:.strong-term}, _SHOULD_{:.strong-term}, _SHOULD NOT_{:.strong-term}, _RECOMMENDED_{:.strong-term}, _MAY_{:.strong-term}, and _OPTIONAL_{:.strong-term} in this document are to be interpreted as described in RFC 2119.
* [URI][org-iana-uri-schemes]: URIs are defined following the IANA URI-Schemes specification.


## 2. Architecture
{: #architecture}

The proposed structure for expressing change of entity metadata over time uses the [Activity Stream specification][org-w3c-activitystreams] to notify consumers of changes to each entity.

<img src="{{site.baseurl}}/assets/images/figures/emm_architecture.png">

## 3. Organizational Structures
{: #organizational-structures}

### 3.1. Entry Point
{: #entry-point}

Reference:  [Ordered Collection][org-w3c-activitystreams-coretype-orderedcollection] in the [Activity Stream specification][org-w3c-activitystreams]
{:.reference}

Each _Entity Metadata Collection_{:.term} _MUST_{:.strong-term} have at least one Entry Point.  It _MAY_{:.strong-term} have multiple Entry Points to satisfy different use cases.  For example, one Entry Point may provide detailed changes to support incremental updates of a full cache and a second may only provide notifications of primary label changes.

The Entry Point _MUST_{:.strong-term} be implemented as an _Ordered Collection_{:.term} following the definition in the Activity Stream specification.  The key points are repeated here with examples specific to Entity Metadata Management.

#### FULL EXAMPLE for Entry Point:

QUESTION: should the example include published for first?
{:.todo}
QUESTION: should the example include published for last?
{:.todo}
QUESTION: should the example include url?</span>
{:.todo}

```json-doc
{
  "@context": {
    "@vocab": "https://www.w3.org/ns/activitystreams",
    "emm": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json"
  },
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

The @context URL _MUST_{:.strong-term} point to a JSON-LD context which, in its simplest form, maps terms to IRIs and can define a context for values of properties. 

_Entity Metadata Management_{:.term} activity streams _MUST_{:.strong-term} include @context at each level in order to conform to [JSON-LD][org-w3c-json-ld] syntax.  The _Entity Metadata Management_{:.term} [context definition][emm-context-api-01] includes information for all levels, and as such, the same context definition is used for all levels. 

Implementations may augment the provided @context with additional @context definitions but must not override or change the normative context of the _Activity Stream_{:.term} context or the _Entity Metadata Management_{:.term} context. Implementations may also use additional properties and values not defined in the JSON-LD @context with the understanding that any such properties will likely be unsupported and ignored by consuming implementations that use the standard JSON-LD algorithms.

The @context _SHOULD_ be `"https://ld4.github.io/entity_metadata_management/api/0.1/activitystreams-extensions"`, or an extension of this definition.  The _Entity Metadata Management_{:.term} context is an extension of the _Activity Streams_{:.term} [context][org-w3c-activitystreams-context-definition].

TODO: Link to EMM context once it is created.
{:.todo}

<a id="entry-point-summary" class="anchor-definition">
__summary__

Reference:  [summary][org-w3c-activitystreams-property-summary] property definition
{:.reference}

The summary is a natural language summarization of the purpose of the _Entry Point_{:.term}

The _Entry Point_{:.term} _SHOULD_{:.strong-term} have a _summary_{:.term} property.  For an _Entry Point_{:.term}, the summary _CAN_{:.strong-term} be a brief description of the _Entity Metadata Collection_{:.term} in which the described changes occurred.  If there are multiple entry points to the same collection, it is _RECOMMENDED_{:.strong-term} that the summary include information that distinguishes each entry point from the others.

```json-doc
{ "summary": "My Authoritity - Notifications of Change" }
```

```json-doc
{ "summary": "My Authoritity - Incremental Updates from 2022-01-01 Full Download" }
```

<a id="entry-point-type" class="anchor-definition">
__type__

Reference:  [type][org-w3c-activitystreams-property-type] property definition
{:.reference}

The type property identifies the Activity Stream type for the _Entry Point_{:.term}.

The _Entry Point_{:.term} _MUST_{:.strong-term} have a _type_{:.term} property.  The value _MUST_{:.strong-term} be `"OrderedCollection"`.

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

Reference:  [first][org-w3c-activitystreams-property-url] property definition
{:.reference}

The url property identifies one or more links to representations of the _Entity Metadata Collection_{:.term}

The _Entry Point_{:.term} _MAY_{:.strong_term} have one or more URLs listed.  If there are multiple URLs, the value of the url property will be an array.  A common value for the url property is a link to the full download for the collection.

```json-doc
{ "url": "https://my.authority/2021-01-01/full_download" }
```

<a id="entry-point-first" class="anchor-definition">
__first__

Reference:  [first][org-w3c-activitystreams-property-first] property definition
{:.reference}

A link to the first _Change Set_{:.term} in this _Entry Point_{:.term} for the _Entity Collection_{:.term}.

The _Entry Point_{:.term} _MUST_{:.strong-term} have a _first_{:.term} property. The value _MUST_{:.strong-term} be a JSON object, with the _id_{:.term} and _type_{:.term} properties. The value of the _id_{:.term} property _MUST_{:.strong-term} be a string, and it _MUST_{:.strong-term} be the HTTP(S) URI of the first page of items in the _Entry Point_{:.term}. The value of the _type_{:.term} property _MUST_{:.strong-term} be the string `"OrderedCollectionPage"`.

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

The _Entry Point_{:.term} _MUST_{:.strong-term} have a _last_{:.term} property. The value _MUST_{:.strong-term} be a JSON object, with the _id_{:.term} and _type_{:.term} properties. The value of the _id_{:.term} property _MUST_{:.strong-term} be a string, and it _MUST_{:.strong-term} be the HTTP(S) URI of the last page of items in the _Entry Point_{:.term}. The value of the _type_{:.term} property _MUST_{:.strong-term} be the string `"OrderedCollectionPage"`.

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

Reference:  [totalItems][org-w3c-activitystreams-property-totalitems] property definition
{:.reference}

The count of all _Entity Change Notifications_{:.term} across all _Change Sets_{:.term} in the _Entry Point_{:term} for the _Entity Collection_{:.term}.

The _Entry Point_{:.term} _MAY_{:.strong-term} have a _totalItems_{:.term} property.  If included, the value _MUST_{:.strong-term} be an integer, and it _SHOULD_{:.strong-term} be the cumulative count of _Entity Change Notifications_{:.term} across all _Change_sets_{:.term}.

```json-doc
{
  "totalItems": 123
}
```


### 3.2. Change Set
{: #change-set}

Reference:  [Ordered Collection Page][org-w3c-activitystreams-coretype-orderedcollectionpage] in the [Activity Stream specification][org-w3c-activitystreams]
{:.reference}

Each time a set of changes is published, changes _MUST_{:.strong-term} be released in at least one _Change Set_{:.term}.  Changes _MAY_{:.strong-term} be published across multiple _Change Sets_{:.term}.  For example, a site may decide that each _Change Set_{:.term} will have at most 50 changes and if that maximum is exceeded during the release time period, then a second _Change Set_{:.term} will be created. All changes within a _Change Set_{:.term} and, if applicable, across  Change Sets _MUST_{:.strong-term} be sorted in date-time order in the _orderedItems_{:.term} property with the earliest change in the set appearing first and most recent change in the set appearing last.

It is _RECOMMENDED_{:.strong-term} that change sets be published on a regular schedule.  It is recognized that there are many factors that can impact this recommendation, including but not limited to, the volume of changes, the consistency of timing of changes, the tolerance of consumers for delays in notifications, resources for producing _Change Sets_{:.term}.

_Change Sets_{:.term} _MUST_{:.strong-term} be implemented as an _Ordered Collection Page_{:.term} following the definition in the Activity Stream specification.  The key points are repeated here with examples specific to Entity Metadata Management.

#### FULL EXAMPLE for Change Set:

```json-doc
{
  "@context": {
    "@vocab": "https://www.w3.org/ns/activitystreams",
    "emm": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json"
  },
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
      "published": "2021-02-01T15:04:22Z",
      "object": {
        "id": "https://my.authority/term/milk",
        "type": "Term"
      }
    },
    {
      "type": "Deprecate",
      "id": "https://data.my.authority/change_documents/2021/activity-stream/cd2",
      "published": "2021-02-01T17:11:03Z",
      "orderedItems": [{
          "id": "https://data.my.authority/change_documents/2021/activity-stream/cd3",
          "type": "Create",
          "published": "2021-02-01T17:11:03Z",
          "object": {
            "id": "https://my.authority/term/bovine_milk",
            "type": "Term"
          }
        },
        {
          "id": "https://data.my.authority/change_documents/2021/activity-stream/cd4",
          "type": "Update",
          "published": "2021-02-01T17:11:03Z",
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

NOTE: See [Entity Change Notification](#entity-change-notification) under [Entity Level Structures](#entity-level-structures) for more information on the data to be included under "orderedItems".
{: .info}

## 4. Entity Level Structures
{: #entity-level-structures}

The structures described in this section are used in the _ordered_items_{:.term} property of of the [Change Set](#change-set).  The level of detail in the _ordered_items_{:.term} depends on the use case being addressed.  The [Notifications](#notifications) use case can be addressed by the [Entity Change Notification](#entity-change-notification).  The [Local Cache of Labels](#local-cache-of-labels) and [Local Cache of Full Dataset](#local-cache-of-full-dataset) use cases can be addressed by also including an [Entity Patch](#entity-patch).

### 4.1. Entity Change Notification
{: #entity-change-notification}

Reference:  [Activity][org-w3c-activitystreams-coretype-activity] in the [Activity Stream specification][org-w3c-activitystreams]
{:.reference}

QUESTION: To tie the language we are using closer to the Activity Stream, should we rename Entity Change Notification to Entity Change Activity?
{:.todo}

A change to Entity Metadata _MUST_{:.strong-term} be described in an _Entity Change Notification_{:.term}.  The notification _MUST_{:.strong-term} provide information about the type of change and _SHOULD_{:.strong-term} provide links that facilitate the consumer gathering additional information from the source dataset.  This level is sufficient to address the Notifications use case.

_Entity Change Notifications_{:.term} _MUST_{:.strong-term} be implemented as an _Activity_{:.term} following the [definition](https://www.w3.org/TR/activitystreams-vocabulary/#activity) in the [Activity Stream specification][org-w3c-activitystreams].  The key points are repeated here with examples specific to Entity Metadata Management.

#### FULL EXAMPLE for Entity Change Notification:

```json-doc
{
  "@context": {
    "@vocab": "https://www.w3.org/ns/activitystreams",
    "emm": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json"
  },
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
  },
  "instrument":
  {
    "type": "rdf_patch",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/cd11/instrument/1"
  }
}
```

Properties shared across all _Entity Change Notification_{:.term} types are described here.  If a specific notification type handles a property different, it will be described with that notification type in section [Types of Change](#types-of-change).

<a id="entity-change-notification-context" class="anchor-definition">
__@context__

Follow the recommendations for [@context](#entry-point-context) as described in the [Entry Point](#entry-point) section.

<a id="entity-change-notification-summary" class="anchor-definition">
__summary__

Reference:  [summary][org-w3c-activitystreams-property-summary] property definition
{:.reference}

For _Entity Change Notification_{:.term}, the summary is a brief description of the change to entity metadata that the notification represents.  It is _RECOMMENDED_{:.strong-term} that a summary be included and that it reference the type of change (e.g. "Add entity") and the entity being changed (e.g. "subject Science").  

There are a limited set of types of change.  See [Types of Change](#type-of-change) section for a list of types and example summaries for each.  Identification of the entity will vary depending on the data represented in the _Entity Metadata Collection_{:.term}.

```json-doc
{ "summary": "Add entity for subject Science" }
```

<a id="entity-change-notification-type" class="anchor-definition">
__type__

Reference:  [type][org-w3c-activitystreams-property-type] property definition
{:.reference}

Each _Entity Change Notification_{:.term} _MUST_{:.strong-term} have a _type_{:.term} property.

The type is the one of a set of predefined _Entity Change Notification_{:.term} activity types.  See [Types of Change](#type-of-change) section for a list of types and recommendations for the value of type for each activity type.

```json-doc
{ "type": "Create" }
```

<a id="entity-change-notification-id" class="anchor-definition">
__id__

Reference:  [id][org-w3c-activitystreams-property-id] property definition
{:.reference}

The unique identifier of the _Entity Change Notification_{:.term}.

The _Entity Change Notification_{:.term} _MUST_{:.strong-term} have an _id_{:.term} property. The value _MUST_{:.strong-term} be a string and it _MUST_{:.strong-term} be an HTTP(S) URI. The JSON representation of the _Entity Change Notification_{:.term} _MUST_{:.strong-term} be available at the URI.

```json-doc
{ "id": "https://data.my.authority/change_documents/2021/activity-stream/cd11" }
```

<a id="entity-change-notification-partof" class="anchor-definition">
__partOf__

Reference:  [partOf][org-w3c-activitystreams-property-partof] property definition
{:.reference}

The _partOf_ property identifies the _Change Set_{:.term} in which this notification was published.

Each _Entity Change Notification_{:.term} _MUST_{:.strong-term} use the _partOf_ property if referring back to the _Change Set_{:.term} that includes this notification.  The value _MUST_{:.strong-term} be a string and it _MUST_{:.strong-term} be an HTTP(S) URI. The JSON representation of the _Change Set_{:.term} publishing this notification _MUST_{:.strong-term} be available at the URI.

```json-doc
"partOf": {
  "type": "OrderedCollectionPage",
  "id": "https://data.my.authority/change_documents/2021/activity-stream/page/2"
}
```


### 4.2. Entity Patch
{: #entity-patch}

To support the [Local Cache of Labels](#local-cache-of-labels) or the [Local Cache of Full Dataset](#local-cache-of-full-dataset), it is _RECOMMENDED_{:.strong-term} that each [Entity Change Notification](#entity-change-notification) include the _instrument_{:.term} property which provides a link an _Entity Patch_{:.term}.

#### FULL EXAMPLE for Entity Patch

```json-doc

{
  "@context": {
    "@vocab": "https://www.w3.org/ns/activitystreams",
    "emm": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json"
  },
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

All {Entity Change Notifications_{:.term} have a core set of properties that are described in the [Entity Change Notification](#entity-change-notification) section.  Some properties are specific to the _Types of Change_.  This section provides examples and descriptions of the _Entity Change Notification_{:.term} and _Entity Patch_{:.term} for each type of change.  They also describe differences between similar Activity Types (e.g. _Create_{:.term} vs. _Add_{:.term}).

### 5.1. New Entity
{: #new-entity}

Reference: [add][org-w3c-activitystreams-activity-add] activity definition
{:.reference}
Reference: [create][org-w3c-activitystreams-activity-create] activity definition
{:.reference}


A new entity _SHOULD_{:.strong-term} have an [Entity Change Notification](#entity-change-notification) with a _type_{:.term} of either _"Create"_{:.term} or _"Add"_{:.term}.

A new entity _MUST_{:.strong-term} be implemented as an _Activity_{:.term} following the [Create type definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-create) or the [Add type definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-add) in the [Activity Stream specification][org-w3c-activitystreams].  The key points are repeated here with examples specific to Entity Metadata Management.

#### Create vs. Add

An entity appearing in an _Entry Point_{:.term} stream for the first time _MUST_{:.strong-term} use _Activity_{:.term} type _Create_{:.term} or _Add_{:.term}.

_Create_{:.term} _SHOULD_{:.strong-term} be used when the entity is new in the source dataset.

_Add_{:.term} _SHOULD_{:.strong-term} be used when the entity exists in the source dataset, but was previously not available through the _Entry Point_{:.term} and now is being made available in the stream.  Situations where this might happen include, but are not limited to, change in permissions, end of an embargo, temporary removal and now being made available again.  

A new _Entry Point_{:.term} _MAY_{:.strong-term} choose to populate the stream with all existing entities.  In this case, the initial population of the stream with all existing entities _SHOULD_{:.strong-term} use _Add_{:.term}.

#### EXAMPLE Entity Change Notification for Create

Complete Example

```json-doc
{
  "@context": {
    "@vocab": "https://www.w3.org/ns/activitystreams",
    "emm": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json"
  },
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

A summary is a brief description of a change to entity metadata.  It is _RECOMMENDED_{:.strong-term} that a summary be included and that it reference the type of change and the entity being changed.

```json-doc
{ "summary": "Add entity for subject Science" }
```

__type__

Reference:  [type][org-w3c-activitystreams-property-type] property definition
{:.reference}

The type is the one of a set of predefined _Entity Change Notification_{:.term} activity types.

Each _Entity Change Notification_{:.term} _MUST_{:.strong-term} have a _type_{:.term} property.  For a notification of a newly available entity, the value _SHOULD_{:.strong-term} be one of either `"Create"` or `"Add"`.

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

The unique identifier of the _Entity Change Notification_{:.term}.

The _Entity Change Notification_{:.term} _MUST_{:.strong-term} have an _id_{:.term} property. The value _MUST_{:.strong-term} be a string and it _MUST_{:.strong-term} be an HTTP(S) URI. The JSON representation of the _Entity Change Notification_{:.term} _MUST_{:.strong-term} be available at the URI.

```json-doc
{ "id": "https://data.my.authority/change_documents/2021/activity-stream/cd11" }
```

__partOf__

Reference:  [partOf][org-w3c-activitystreams-property-partof] property definition
{:.reference}

The _partOf_ property identifies the _Change Set_{:.term} in which this notification was published.

Each _Entity Change Notification_{:.term} _MUST_{:.strong-term} use the _partOf_ property if referring back to the _Change Set_{:.term} that includes this notification.

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
  "@context": {
    "@vocab": "https://www.w3.org/ns/activitystreams",
    "emm": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json"
  },
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

An updated entity _SHOULD_{:.strong-term} have an [Entity Change Notification](#entity-change-notification) with a _type_{:.term} of _"Update"_{:.term}.

An updated entity _MUST_{:.strong-term} be implemented as an _Activity_{:.term} following the [Update type definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-update)in the [Activity Stream specification][org-w3c-activitystreams].  The key points are repeated here with examples specific to Entity Metadata Management.

EXAMPLE Entity Change Notification for Update

```json-doc
{
  "@context": {
    "@vocab": "https://www.w3.org/ns/activitystreams",
    "emm": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json"
  },
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
  "@context": {
    "@vocab": "https://www.w3.org/ns/activitystreams",
    "emm": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json"
  },
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

It is _RECOMMENDED_{:.strong-term} that entities be marked as _Deprecated_{:.term} in the source dataset instead of deleting the entity from the source dataset. If the entity is deprecated, follow the _Entity Change Notification_{:.term} described in [Deprecate Entity](#deprecate-entity).
{: .warning}

An entity that has been fully deleted from the source dataset _SHOULD_{:.strong-term} have an [Entity Change Notification](#entity-change-notification) with a _type_{:.term} of _"Delete"_{:.term} or _"Remove"_{:.term}.

A deleted entity _MUST_{:.strong-term} be implemented as an _Activity_{:.term} following the [Delete type definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-delete) or the [Remove type definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-remove) in the [Activity Stream specification][org-w3c-activitystreams].  The key points are repeated here with examples specific to Entity Metadata Management.

EXAMPLE Entity Change Notification for Delete

```json-doc
{
  "@context": {
    "@vocab": "https://www.w3.org/ns/activitystreams",
    "emm": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json"
  },
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
  "@context": {
    "@vocab": "https://www.w3.org/ns/activitystreams",
    "emm": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json"
  },
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

An entity that has been deprecated _SHOULD_{:.strong-term} have an [Entity Change Notification](#entity-change-notification) with a _type_{:.term} of _"Deprecate"_{:.term}.

A deprecated entity _MUST_{:.strong-term} be implemented as an _Activity_{:.term} following the [Deprecate extended type definition](https://docs.google.com/document/d/1eiFANJvR6cYE3Tx3cTsLhDO_BxZFr7NKPrQnBPh48rk/edit#heading=h.u6iw3ncw6945)  in the [Entity Metadata Management extension](https://docs.google.com/document/d/1eiFANJvR6cYE3Tx3cTsLhDO_BxZFr7NKPrQnBPh48rk/edit) to the [Activity Stream specification][org-w3c-activitystreams].  The key points are repeated here with examples.

EXAMPLE Entity Change Notification for Deprecate

```json-doc
{
  "@context": {
    "@vocab": "https://www.w3.org/ns/activitystreams",
    "emm": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json"
  },
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
      "instrument":
      {
        "type": "rdf_patch",
        "id":
          "https://data.my.authority/change_documents/2021/activity-stream/cd42/instrument/1"
      }
    },
    {
      "summary": "Deprecate term cow milk",
      "type": "Update",
      "object": {
        "type": "Term",
        "id": "http://my_repo/entity/cow_milk"
      },
      "instrument":
      {
        "type": "rdf_patch",
        "id":
          "https://data.my.authority/change_documents/2021/activity-stream/cd42/instrument/2"
      }
    }
  ]
}
```


### 5.5. Split Entity
{: #split-entity}

An entity that has been split into two or more new entities _SHOULD_{:.strong-term} have an [Entity Change Notification](#entity-change-notification) with a _type_{:.term} of _"Split"_{:.term}.

A split entity _MUST_{:.strong-term} be implemented as an _Activity_{:.term} following the [Split extended type definition](https://docs.google.com/document/d/1eiFANJvR6cYE3Tx3cTsLhDO_BxZFr7NKPrQnBPh48rk/edit#heading=h.jlx8rz32qnvm)  in the [Entity Metadata Management extension](https://docs.google.com/document/d/1eiFANJvR6cYE3Tx3cTsLhDO_BxZFr7NKPrQnBPh48rk/edit) to the [Activity Stream specification][org-w3c-activitystreams].  The key points are repeated here with examples.

EXAMPLE Entity Change Notification for Split

```json-doc
{
  "@context": {
    "@vocab": "https://www.w3.org/ns/activitystreams",
    "emm": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json"
  },
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
      "instrument":
      {
        "type": "rdf_patch",
        "id":
          "https://data.my.authority/change_documents/2021/activity-stream/cd51/instrument/1"
      }
    },
    {
      "summary": "Create term oxen milk",
      "type": "Create",
      "object": {
        "type": "Term",
        "id": "http://my_repo/entity/oxen_milk"
      },
      "instrument":
      {
        "type": "rdf_patch",
        "id":
          "https://data.my.authority/change_documents/2021/activity-stream/cd51/instrument/2"
      }
    },
    {
      "summary": "Deprecate term cow milk",
      "type": "Deprecate",
      "object": {
        "type": "Term",
        "id": "http://my_repo/entity/cow_milk"
      },
      "instrument":
      {
        "type": "rdf_patch",
        "id":
          "https://data.my.authority/change_documents/2021/activity-stream/cd51/instrument/3"
      }
    }
  ]
}
```

### 5.6. Merge Entities
{: #merge-entity}


Entities that has been merged into one new entity _SHOULD_{:.strong-term} have an [Entity Change Notification](#entity-change-notification) with a _type_{:.term} of _"Merge"_{:.term}.

A change that merges entities _MUST_{:.strong-term} be implemented as an _Activity_{:.term} following the [Merge extended type definition](https://docs.google.com/document/d/1eiFANJvR6cYE3Tx3cTsLhDO_BxZFr7NKPrQnBPh48rk/edit#heading=h.e7zppj5vycms)  in the [Entity Metadata Management extension](https://docs.google.com/document/d/1eiFANJvR6cYE3Tx3cTsLhDO_BxZFr7NKPrQnBPh48rk/edit) to the [Activity Stream specification][org-w3c-activitystreams].  The key points are repeated here with examples.

EXAMPLE Entity Change Notification for Merge

```json-doc
{
  "@context": {
    "@vocab": "https://www.w3.org/ns/activitystreams",
    "emm": "https://ld4.github.io/entity_metadata_management/api/0.1/context.json"
  },
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
      "instrument":
      {
        "type": "rdf_patch",
        "id":
          "https://data.my.authority/change_documents/2021/activity-stream/cd61/instrument/1"
      }
    },
    {
      "summary": "Deprecate term bovine milk",
      "type": "Deprecate",
      "object": {
        "type": "Term",
        "id": "http://my_repo/entity/bovine_milk"
      },
      "instrument":
      {
        "type": "rdf_patch",
        "id":
          "https://data.my.authority/change_documents/2021/activity-stream/cd61/instrument/2"
      }
    },
    {
      "summary": "Deprecate term oxen milk",
      "type": "Deprecate",
      "object": {
        "type": "Term",
        "id": "http://my_repo/entity/oxen_milk"
      },
      "instrument":
      {
        "type": "rdf_patch",
        "id":
          "https://data.my.authority/change_documents/2021/activity-stream/cd61/instrument/3"
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

TODO: Add discussion and reasoning for when to use each type of date.  Still need to determine our recommendations around dates.
{:.todo}

### For Notifications

QUESTION: Should each place that talks about a part of the feed include a link into the examples of that part?  For example, include link to Entry Point in the instructions to create it; a link to a Change Set when it is created; etc.  OR as is done here, a link at the top of the section to the entry point for the use case being described.
{:.todo}

[Live Example of Notifications Entry Point][emm-change-api-example-notifications]

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
* type of change (e.g. Add, Remove, Update, Deprecate, Split, Merge)
* RDF patch steps describing what was changed (optional, see note)

NOTE: Storing RDF patch steps is optional for Notifications.  All changes are required for Incremental Updates and changes to labels are required for Label Changes.
{:.info}

#### When ready to publish a change set

Determine URIs for new and existing objects that will be referenced in various properties:
* `entry_point_uri` = get the URI of the newly created or existing entry point
* `prev_change_set_uri` = get the previous change set URI from the entry point's `"last"` property
* `change_set_uri` = determine URI that will resolve to the change set
* `entity_uri` = the dereferencable URI for the entity that return the entity graph
* `change_activity_uri` = determine URI that will resolve to each entity change activity
* `change_rdf_patch_uri` = determine URI that will resolve to the instrument holding the RDF patch for each activity

Create the change set:
* set `"id"` property to `change_set_uri`
* set `"published"` property to the datetime this change set will become public
* set `"partOf"` property to use `entry_point_uri` for `"id"`
* set `"prev"` property to use `prev_change_set_uri` for `"id"`
* set `"totalItems"` property to the number of change activities that will be in this change set
* for each change activity from oldest to newest, add it to the `"orderedItems"` property array
  * set `"type"` property to the change type (e.g. Add, Remove, etc.)
  * set `"id"` property to the `change_activity_uri` for this change
  * set a date
    * the `"published"` property to the datetime the change set is being published
    * the `"endDate"` property to the datetime the change was completed in the system of record 
  * set `"object"` to use `entity_uri` for `"id"`

Update previous change set:
* add a "next" property that points to the new change set

Update entry point:
* if this is the first change set published for an entry point, add the "first" property in the entry point
    * "type": "OrderCollectionPage"
    * "id": _URI resolving to the new change set_
    * "published": _datetime the change set is published_
* add or update the "last" property in the entry point
    * "type": "OrderCollectionPage"
    * "id": _URI resolving to the new change set_
    * "published": _datetime the change set is published_

Create each change activity:
* create a change activity using the information saved as changes were created

### For Label Changes

[Live Example of Label Changes Entry Point][emm-change-api-example-partialcache]

The process for creating Label Changes is the same as for Notifications with a few additional steps noted in this section.

#### As changes are made to the dataset

Record all the information listed under Notification and also:
* RDF patch steps describing the label changes

#### When ready to publish a change set

Create the change set as described for Notifications and also:
* for each change activity:
    * set `"instrument"` property to use `change_rdf_patch_uri` for `"id"`

Create an RDF patch for each change activity:
* record the RDF patch statements in the order that they need to be applied to recreate the label changes to an entity

### For Incremental Updates

[Live Example of Incremental Updates Entry Point][emm-change-api-example-fullcache]

The process for creating Incremental Updates is the same as for Notifications with a few additional steps noted in this section.

#### As changes are made to the dataset

Record all the information listed under Notification and also:
* RDF patch steps describing what was changed

#### When ready to publish a change set

Create the change set as described for Notifications and also:
* for each change activity:
    * set `"instrument"` property to use `change_rdf_patch_uri` for `"id"`

Create an RDF patch for each change activity:
* record the RDF patch statements in the order that they need to be applied to recreate the changes to an entity


## 7. Consuming Entity Change Sets
{: #consuming-entity-change-sets}




{% include api/links.md %}
