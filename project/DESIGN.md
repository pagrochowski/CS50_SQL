# Design Document

By Piotr Grochowski 

project’s title: Resources_list
your GitHub and edX usernames: pagrochowski
your city and country: Whitefield, United Kingdom
Recording date: 22 September 2024

Video overview: [https://youtu.be/6umQbT0KHZc]

## Scope

In this section you should answer the following questions:

* What is the purpose of your database?
The purpose of this database is to store and search for details of the linguists my company works with.
The actual data will be anonymised, but the core of the database will be used in commercial application at my workplace for my own account.
* Which people, places, things, etc. are you including in the scope of your database?
I am including all freelance translators and reviewers.
* Which people, places, things, etc. are *outside* the scope of your database?
I am excluding vendors (companies/agencies aggregating linguists).


## Functional Requirements

In this section you should answer the following questions:

* What should a user be able to do with your database?
Reading rows, inserting new rows and updating rows, soft deleting rows, adding views. 
* What's beyond the scope of what a user should be able to do with your database?
The end-user will not be creating new tables or indexes. 

## Representation

### Entities

In this section you should answer the following questions:

* Which entities will you choose to represent in your database?
Freelance translators. 
* What attributes will those entities have?
Name & surname, email address, location, supplier code, language pair, service rates, article codes for each service. 
* Why did you choose the types you did?
I tried to give the user flexibility, while reducing required space and speed up processing. 
* Why did you choose the constraints you did?
I want to prevent data pollution, some users might not realise that certain information is required in a certain format in order to maintain the database. 

### Relationships

In this section you should include your entity relationship diagram and describe the relationships between the entities in your database.

![Linguists.png]

flowchart TD
    A["Linguists"] --> B["Contact Details"] & C["Language Pairs"] & D["Service Type"]
    B --> E["Name"] & F["Supplier Code"]
    C --> G["Source Language"] & H["Target Language"]
    D --> I["Translation"] & J["Revision"] & K["Language Lead"]
    I --> L["Software"] & M["Documentation"]
    J --> N["Software"] & O["Documentation"]
    L --> P["Rate Per Word"] & R["Rate Per Hour"]
    M --> S["Rate Per Word"] & T["Rate Per Hour"]
    N --> U["Rate Per Word"] & W["Rate Per Hour"]
    O --> X["Rate Per Word"] & Y["Rate Per Hour"]
    K --> Z["Rate Per Hour"]
    P --> LP["Art Code"]
    R --> LR["Art Code"]
    S --> MS["Art Code"]
    T --> MT["Art Code"]
    U --> NU["Art Code"]
    W --> NW["Art Code"]
    X --> OX["Art Code"]
    Y --> OY["Art Code"]
    Z --> KZ["Art Code"]


## Optimizations

In this section you should answer the following questions:

* Which optimizations (e.g., indexes, views) did you create? Why?
Views:
LinguistServices: including Supplier name, supplier code, language pair, service type
This view will be frequently used to search through contact details, language pair and service type. These are the most basic information for any job where you are looking to send the handoff out quickly. 

Translators and Revisors views: specialized views for translators and revisors to simplify querying specific types of services.

## Limitations

In this section you should answer the following questions:

* What are the limitations of your design?
There is no differentiation for different rates per different language pair. At the moment, each linguist only has one rate for all language pairs. 
Data insertion is not completely fool proof. I did not use enumarator types for languages or service types. This may introduce human errors at some point, if somebody makes a typo or does not know exactly what to type in. 

* What might your database not be able to represent very well?
If one freelancer is able to work on multiple language pairs (rare but possible), we would need to duplicate entries for this linguist. 

