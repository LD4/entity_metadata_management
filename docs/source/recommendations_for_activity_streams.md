---
layout: spec
title: Change Documents as Activity Streams
permalink: emm_activity_streams.html
last_updated: Nov 19, 2021
keywords: ["Entity"]
sidebar: home_sidebar
folder: spotlight/getting_started/
---

## Status of this Document
{:.no_toc}
__This Version:__ {{ page.major }}.{{ page.minor }}.{{ page.patch }}{% if page.pre != 'final' %}-{{ page.pre }}{% endif %}

__Latest Stable Version:__ [{{ site.discovery_api.stable.major }}.{{ site.discovery_api.stable.minor }}.{{ site.discovery_api.stable.patch }}][discovery-stable-version]

__Previous Version:__

**Editors**

* **[E. Lynette Rayle](https://orcid.org/0000-0001-7707-3572)** [![ORCID iD]({{ site.url }}{{ site.baseurl }}/img/orcid_16x16.png)](https://orcid.org/0000-0002-1266-298X), [_Cornell University_](https://www.cornell.edu/)
  {: .names}
  TODO: Add more names

----
# UNDER CONSTRUCTION
## Table of Contents
{:.no_toc}

* Table of Discontent (will be replaced by macro)
  {:toc}

## Status of this Document
{:.no_toc}
__This Version:__ {{ page.major }}.{{ page.minor }}.{{ page.patch }}{% if page.pre != 'final' %}-{{ page.pre }}{% endif %}

__Latest Stable Version:__ [{{ site.discovery_api.stable.major }}.{{ site.discovery_api.stable.minor }}.{{ site.discovery_api.stable.patch }}][discovery-stable-version]

__Previous Version:__

**Editors**

* **[E. Lynette Rayle](https://orcid.org/0000-0001-7707-3572)** [![ORCID iD]({{ site.url }}{{ site.baseurl }}/img/orcid_16x16.png)](https://orcid.org/0000-0002-1266-298X), [_Cornell University_](https://www.cornell.edu/)
  {: .names}
  TODO: Add more names

----
# UNDER CONSTRUCTION
## Table of Contents
{:.no_toc}

* Table of Discontent (will be replaced by macro)
  {:toc}

## 1. Introduction
{: #introduction}

TODO: Review the intro to tighten it up so that the purpose of the document is easily discernible. May need to move some of the other information to a Background section.



Entity metadata providers curate aggregations of entities and their metadata within an area of interest.  These organizations have expertise in the areas they manage.  The entity metadata consumers may have expertise as well and may participate in the creation of new entities or changes to metadata for existing entities.  The providers generally have a review process for accepting changes.  

The community of consumers of entity metadata depend on the providers to publish accurate and up to date metadata.  The consumer may fully or partially cache entity metadata which requires periodic updates to remain in sync with the source data.  This document describes an approach that entity metadata providers can use to communicate changes to the community of entity metadata consumers.  The examples in this document come primarily from the library and museum communities, but the described principles can be applied to manage entity metadata in other communities as well.

These recommendations leverages existing techniques, specifications, and tools in order to promote widespread adoption of an easy-to-implement service. The service describes changes to entity metadata and the location of those resources to harvest. Content providers can implement this API to enable notifications of change and incremental cache updates.

### 1.1 Identified Use Cases
{: #use-cases}

Three primary use cases were identified that drive the recommendations in this document.  This recommendations can be used to address one or more of the use cases.

#### 1.1.1 Notification System Use Case

Entity metadata consumers want to be notified of any modifications or deletions for entities on their list of entities of interest, as well as new entities.  They typically compare the list of modified and deleted entities against their list of entities of interest.  For any that overlap, the consumer will take additional actions if needed.

To address this use case, the provider creates and makes available a list of the URIs for any new, modified, or deleted entities.  The consumer will need to take additional actions to identify specific changes to entities of interest. 

#### 1.1.2 Local Cache of Labels

Applications commonly save external references to entity metadata.  The data that is saved as part of the local record is the URI of the entity.  When the external reference is displayed to end users, the primary label associated with the URI is typically displayed as it is easier for end users to understand than a URI.  For performance reasons, the primary label is generally cached in the local application to avoid having to fetch the label every time the entity reference is displayed to the end user. 

To address this use case, the provider creates and makes available a list of URIs and their new labels.  The consumer can compare the list of URIs with those stored in the local application and update the cached labels.

NOTE: In some cases, additional metadata is also cached as part of the external reference, but this is less common.  Verification of the additional metadata may require the consumer to take additional actions.

#### 1.1.3 Local Cache of Full Dataset

A consumer may decide to make a full cache of a dataset of entity metadata.  This is commonly done for several reasons including, but not limited to, increased control over uptime, throughput, and indexing for search.  The cache needs to stay in sync with the source dataset as near to real time as is possible using incremental updates.  

To address this use case, the provider creates and makes available a dated list of all new, modified, and deleted entities along with specifics about how the entities have changed.  The consumer can process each list, from oldest to newest, that was published since their last incremental update, and use the specific details about changes to update their cache.


### 1.2 Architecture
{: #architecture}

The proposed structure for expressing change of entity metadata over time uses Activity Streams to notify consumers of changes to each entity.

<img src="{{site.baseurl}}/assets/images/figures/emm_architecture.png">







### 1.3. Objectives and Scope
{: #objectives-and-scope}

TODO: Add more about objectives and scope

__Change Notifications__<br>This specification does not include a subscription mechanism for enabling change notifications to be pushed to remote systems. Only periodic polling for the set of changes that must be processed is supported. A subscription/notification pattern may be added in a future version after implementation experience with the polling pattern has demonstrated that it would be valuable.
{: .warning}






### 1.4. Terminology
{: #terminology}

#### 1.4.1 Roles

* entity metadata provider - An organization that collects, curates, and provides access to metadata about entities within an area of interest.  The Library of Congress maintains several [collections](https://id.loc.gov/), including but not limited to, Library Subject Headings, Name Authority, Genres/Form Terms.  The Getty maintains several [vocabularies](https://www.getty.edu/research/tools/vocabularies/index.html).  There are many other providers.  TODO:  Maybe put a list of providers in an appendix instead of here.
* entity metadata consumer - Any institution that references or caches entity metadata from a provider.  The use cases driving the recommendations were created from libraries, museums, galleries, and archives.
* entity metadata tool developer - Software developers that create tools that help consumers connect to entity metadata from providers.

#### 1.4.2 Terms about Entities


#### 1.4 3 Terms for Activity Streams


#### 1.4.4 Terms from Specifications

The recommendations use the following terms:

* __HTTP(S)__: The HTTP or HTTPS URI scheme and internet protocol.

The terms _array_, _JSON object_, _number_, and _string_ in this document are to be interpreted as defined by the [Javascript Object Notation (JSON)][org-rfc-8259] specification.

The key words _MUST_, _MUST NOT_, _REQUIRED_, _SHALL_, _SHALL NOT_, _SHOULD_, _SHOULD NOT_, _RECOMMENDED_, _MAY_, and _OPTIONAL_ in this document are to be interpreted as described in [RFC 2119][org-rfc-2119].




