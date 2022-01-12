---
title: EMM Change Document API 0.1
title_override: EMM Change Document API 0.1
id: change-api
layout: spec
cssversion: 3
tags: [specifications, change-api]
major: 0
minor: 1
patch: 0
pre: final
redirect_from:
- /change/
- /change/index.html
- /change/1/index.html
  editors:
- name: E. Lynette Rayle
  orcid: https://orcid.org/0000-0001-7707-3572
  institution: Cornell University
---

## Status of this Document
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

TODO: Review the intro to tighten it up so that the purpose of the document is easily discernible. May need to move some of the other information to a Background section.



Entity metadata providers curate aggregations of entities and their metadata within an area of interest.  These organizations have expertise in the areas they manage.  The Entity Metadata Consumers may have expertise as well and may participate in the creation of new entities or changes to metadata for existing entities.  The providers generally have a review process for accepting changes.

The community of consumers of entity metadata depend on the providers to publish accurate and up to date metadata.  The consumer may fully or partially cache entity metadata which requires periodic updates to remain in sync with the source data.  This document describes an approach that Entity Metadata Providers can use to communicate changes to the community of Entity Metadata Consumers.  The examples in this document come primarily from the library and museum communities, but the described principles can be applied to manage entity metadata in other communities as well.

These recommendations leverages existing techniques, specifications, and tools in order to promote widespread adoption of an easy-to-implement service. The service describes changes to entity metadata and the location of those resources to harvest. Content providers can implement this API to enable notifications of change and incremental cache updates.

### 1.1 Use Cases
{: #use-cases}

Three primary use cases were identified that drive the recommendations in this document.  This recommendations can be used to address one or more of the use cases.

#### 1.1.1 Notifications
{: #notifications}

Entity metadata consumers want to be notified of any modifications or deletions for entities on their list of entities of interest, as well as new entities.  They typically compare the list of modified and deleted entities against their list of entities of interest.  For any that overlap, the consumer will take additional actions if needed.

To address this use case, the provider creates and makes available a list of the URIs for any new, modified, or deleted entities.  The consumer will need to take additional actions to identify specific changes to entities of interest.

#### 1.1.2 Local Cache of Labels
{: #local-cache-of-labels}

Applications commonly save external references to entity metadata.  The data that is saved as part of the local record is the URI of the entity.  When the external reference is displayed to end users, the primary label associated with the URI is typically displayed as it is easier for end users to understand than a URI.  For performance reasons, the primary label is generally cached in the local application to avoid having to fetch the label every time the entity reference is displayed to the end user.

To address this use case, the provider creates and makes available a list of URIs and their new labels.  The consumer can compare the list of URIs with those stored in the local application and update the cached labels.

NOTE: In some cases, additional metadata is also cached as part of the external reference, but this is less common.  Verification of the additional metadata may require the consumer to take additional actions.

#### 1.1.3 Local Cache of Full Dataset
{: #local-cache-of-full-dataset}

A consumer may decide to make a full cache of a dataset of entity metadata.  This is commonly done for several reasons including, but not limited to, increased control over uptime, throughput, and indexing for search.  The cache needs to stay in sync with the source dataset as near to real time as is possible using incremental updates.

To address this use case, the provider creates and makes available a dated list of all new, modified, and deleted entities along with specifics about how the entities have changed.  The consumer can process each list, from oldest to newest, that was published since their last incremental update, and use the specific details about changes to update their cache.







### 1.2. Objectives and Scope
{: #objectives-and-scope}

TODO: Add more about objectives and scope

__Change Notifications__<br>This specification does not include a subscription mechanism for enabling change notifications to be pushed to remote systems. Only periodic polling for the set of changes that must be processed is supported. A subscription/notification pattern may be added in a future version after implementation experience with the polling pattern has demonstrated that it would be valuable.
{: .warning}






### 1.3. Terminology
{: #terminology}

#### 1.3.1 Roles
{: #roles}

* Entity Metadata Provider - An organization that collects, curates, and provides access to metadata about entities within an area of interest.  The Library of Congress maintains several [collections](https://id.loc.gov/), including but not limited to, Library Subject Headings, Name Authority, Genres/Form Terms.  The Getty maintains several [vocabularies](https://www.getty.edu/research/tools/vocabularies/index.html).  There are many other providers.  TODO:  Maybe put a list of providers in an appendix instead of here.
* Entity Metadata Consumer - Any institution that references or caches entity metadata from a provider.  The use cases driving the recommendations were created from libraries, museums, galleries, and archives.
* Entity Metadata Developer - Software developers that create applications and tools that help consumers connect to entity metadata from providers.  The developer may be associated with the provider, consumer, or a third party.

#### 1.3.2 Terms about Entities
{: #terms-about-entities}

* Entity Metadata Collection - Entities can be grouped based on varying criteria (e.g. subject headings, names, thesaurus, controlled vocabulary).  The term Entity Metadata Collection will be used as a generic representation of these grouping regardless of type.

#### 1.3 3 Terms from Activity Streams
{: #terms-from-activity-streams}


#### 1.3.4 Terms from Specifications
{: #terms-from-specifications}

The recommendations use the following terms:

* __HTTP(S)__: The HTTP or HTTPS URI scheme and internet protocol.

The terms _array_, _JSON object_, _number_, and _string_ in this document are to be interpreted as defined by the [Javascript Object Notation (JSON)][org-rfc-8259] specification.

The key words _MUST_{:.strong-term}, _MUST NOT_{:.strong-term}, _REQUIRED_{:.strong-term}, _SHALL_{:.strong-term}, _SHALL NOT_{:.strong-term}, _SHOULD_{:.strong-term}, _SHOULD NOT_{:.strong-term}, _RECOMMENDED_{:.strong-term}, _MAY_{:.strong-term}, and _OPTIONAL_{:.strong-term} in this document are to be interpreted as described in [RFC 2119][org-rfc-2199].



## 2. Architecture
{: #architecture}

The proposed structure for expressing change of entity metadata over time uses Activity Streams to notify consumers of changes to each entity.

<img src="{{site.baseurl}}/assets/images/figures/emm_architecture.png">

## 3. Organizational Structures
{: #organizational-structures}

### 3.1 Entry Point
{: #entry-point}

Each _Entity Metadata Collection_{:.term} _MUST_{:.strong-term} have at least one Entry Point.  It _MAY_{:.strong-term} have multiple Entry Points to satisfy different use cases.  For example, one Entry Point may provide incremental updates for a full cache and a second may provide primary label updates only.

The Entry Point _MUST_{:.strong-term} be implemented as an _Ordered Collection_{:.term} following the [definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-orderedcollection) in the [Activity Stream specification][org-w3c-activitystreams].  The key points are repeated here with examples specific to Entity Metadata Management.

Example Entry Point:

```json-doc
{
  "@context": "https://www.w3.org/ns/activitystreams",
  "summary": "My Authority - Change Documents",
  "type": "OrderedCollection",
  "id": "https://data.my.authority/change_documents/2021/activity-stream",
  "url": "https://my.authority/2021-01-01/full_download",
  "totalItems": 123,
  "first": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/1",
    "published": "2021-01-01T05:00:01Z"
  },
  "last": {
    "type": "OrderedCollectionPage",
    "id": "https://data.my.authority/change_documents/2021/activity-stream/page/12",
    "published": "2021-08-27T05:00:01Z"
  }
}
```

### 3.2 Change Set
{: #change-set}

Each time a set of changes is published, changes _MUST_{:.strong-term} be released in at least one _Change Set_{:.term}.  Changes _MAY_{:.strong-term} be published across multiple _Change Sets_{:.term}.  For example, a site may decide that each _Change Set_{:.term} will have at most 50 changes and if that maximum is exceeded during the release time period, then a second _Change Set_{:.term} will be created. All changes within a _Change Set_{:.term} and, if applicable, across  Change Sets _MUST_{:.strong-term} be sorted in date-time order in the "orderedItems" field with the earliest change in the set appearing first and most recent change in the set appearing last.

It is _RECOMMENDED_{:.strong-term} that change sets be published on a regular schedule.  It is recognized that there are many factors that can impact this recommendation, including but not limited to, the volume of changes, the consistency of timing of changes, the tolerance of consumers for delays in notifications, resources for producing _Change Sets_{:.term}.

_Change Sets_{:.term} _MUST_{:.strong-term} be implemented as an _Ordered Collection Page_{:.term} following the [definition](https://www.w3.org/TR/activitystreams-vocabulary/#dfn-orderedcollectionpage) in the [Activity Stream specification][org-w3c-activitystreams].  The key points are repeated here with examples specific to Entity Metadata Management.

Example Change Set:

```json-doc
{
  "@context": "https://www.w3.org/ns/activitystreams",
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

### 4.1 Entity Change Notification
{: #entity-change-notification}

A change to Entity Metadata _MUST_{:.strong-term} be described in an _Entity Change Notification_{:.term}.  The notification _MUST_{:.strong-term} provide information about the type of change and _SHOULD_{:.strong-term} provide links that facilitate the consumer gathering additional information from the source dataset.

### 4.2 Entity Patch
{: #entity-patch}


## 5. Types of Change
{: #types-of-change}

### 5.1 New Entity
{: #new-entity}

### 5.2 Update Entity
{: #update-entity}

### 5.3 Deprecate Entity
{: #deprecate-entity}

### 5.4 Delete Entity
{: #delete-entity}

### 5.5 Split Entity
{: #split-entity}

### 5.6 Merge Entities
{: #merge-entity}

## 6. Consuming Entity Change Sets
{: #consuming-entity-change-sets}


