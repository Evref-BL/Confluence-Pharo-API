# Confluence-Pharo-API

This is a client for the [Confluence REST API](https://developer.atlassian.com/cloud/confluence/rest/v2/intro/#about).

## Installation

```st
Metacello new
  githubUser: 'Evref-BL' project: 'Confluence-Pharo-API' commitish: 'main' path: 'src';
  baseline: 'ConfluencePharoAPI';
  load
```

## Connect the API to Confluence

The first step before querying is to connect to the Confluence API.

On the official atlassian Confluence, perform the following script:

```smalltalk
confluenceAPI := ConfluencePharoAPI new.
confluenceAPI endpoint: '<your endpoint>'.
confluenceAPI basePath: '<basePath>/rest/api/latest/'.
confluenceAPI beHttps.

confluenceAPI user: '<Your username (can be email)>'.
confluenceAPI apiToken: '<Your apiToken>'.
```

## Example

### Get information about one page

```smalltalk
page := confluenceAPI getContent: <page id>
```
