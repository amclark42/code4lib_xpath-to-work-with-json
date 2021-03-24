<title>Using XPath 3.1 (and its friends) to work with JSON</title>

# Using XPath 3.1 (and its friends) to work with JSON

Before I get started, my script for this talk is available in a [GitHub repository](https://github.com/amclark42/code4lib_xpath-to-work-with-json).

My name is Ash Clark and my pronouns are e, em, eir. My job is XML Applications Developer for the Northeastern University Digital Scholarship Group and for the Northeastern Women Writers Project.

What I do is: I turn Text Encoding Initiative XML documents into APIs and web interfaces. To support these, I write RESTXQ applications which are served out of XML databases (eXist-DB and BaseX). I work heavily with XQuery, a scripting language that extends the functionality of XPath. I also work with XSLT, CSS. And reluctantly: Javascript.

Lots of people prefer to get JSON responses from APIs. I like XML better, but I want my APIs to support both, especially because I’m working in the Digital Humanities. There’s no one tool or programming language that the field is guaranteed to be comfortable with. And each API I make could be someone’s first.

I warmed to JSON when I realized there was actually a good deal of overlap between JSON and XML:

* one “root”,
* hierarchy,
* meaningful groupings, and
* common formats for data interchange.

(But I’ll never recommend JSON for marking up documents. Use XML or use HTML!)

Enter XPath and XQuery 3.1, and XSLT 3.0! The W3C recommendations were published in 2017. The functionality is available in Saxon processors, and the eXist-DB and BaseX databases.

Crucially, the new versions integrate support for working with JSON! They introduce new complex data structures: *maps*, which are key-value pairs; and *arrays*, ordered groupings of values. Both of these can nest, unlike the standard sequences. And both can accept any type of value, including XML nodes and the new inline functions! I’ve been working with maps and arrays for most of my time at Northeastern, and I love them. So much.

Here’s an example of both:
```
map {
    "greeting": "Hello",
    "who": [
        "World",
        <orgName>Code4Lib 2021</orgName>,
        $attendees-from-Northeastern
      ]
  }
```
This is a map with two keys, "greeting" and "who". The value of "greeting" is a string "hello", and the value of "who" is a three-item array consisting of a string, an XML element node, and whatever’s in the variable `$attendees-from-Northeastern`.

You can access data in maps and arrays with functions or with terse lookup operators.
```
map:get($myMap, "greeting")
  eq  $myMap("greeting")
  eq  $myMap?greeting

array:get($myArray, 1)
  eq  $myArray(1)
  eq  $myArray?1
```
These are two expressions which test alternate ways of getting at the values in `$myMap` and `$myArray`. Both should return `true()`, since the accessors are equivalent.

You can qualify the results you expect, as you can with XPath expressions:
```
$myMap[?greeting eq "Hello"]

$myArray[?*[. eq "World"]]
```
In the first expression, we want to return `$myMap`, but only if the key "greeting" has the string value "Hello". In the second, we want to get $myArray, but only if one of its values is the string "World".

Excitingly, the new XPath, XQuery, and XSLT can convert JSON strings or files into maps and arrays. They can *also* serialize maps and arrays back to JSON. *And* they can convert JSON to XML, and vice versa! (With the caveat that the equivalent XML must follow a W3C-defined schema.)

Some takeaways from my use of maps and arrays:

* Key-value pairs are *great* for mapping parameter names onto human-readable labels!
* The nesting of arrays means I can do complex ordering of values.
  * For example, I can have an outer array corresponding to a sort order, and inner ones corresponding to a secondary sort order.
* I can cache the XML representation of JSON in my XML database, which gives me indexing and quick query results.
* I can create RESTXQ APIs which return XML or JSON on request (or HTML, after applying an XSL transformation).
* I can pass maps around instead of creating XQuery functions with oodles of required parameters.

I don’t have time to give detailed examples of my own work, but feel free to start up a conversation in the Code4Lib Slack! I’m super enthusiastic about these new features. Come geek out with me!


## Links and references:

* [Northeastern University Digital Scholarship Group](https://dsg.northeastern.edu/)
  * [GitHub organization](https://github.com/NEU-DSG)
  * [Women Writers Project](https://wwp.northeastern.edu/)
* [Text Encoding Initiative (TEI)](https://tei-c.org/)
* [Saxon processors](https://www.saxonica.com/welcome/welcome.xml)
* [eXist-DB XML database](http://exist-db.org/exist/apps/homepage/index.html)
* [BaseX XML database](https://basex.org/)
* [RESTXQ](http://exquery.github.io/exquery/exquery-restxq-specification/restxq-1.0-specification.html) (XQuery annotations for defining API endpoints)
  * The [BaseX documentation](https://docs.basex.org/wiki/RESTXQ) is *fantastic*
* [“Maps and Arrays”](https://www.w3.org/TR/xpath-31/#id-maps-and-arrays), XPath and XQuery 3.1 W3C recommendation
* [“JSON Output Method”](https://www.w3.org/TR/xslt-xquery-serialization-31/#json-output), XSLT and XQuery Serialization 3.1 W3C recommendation
* [“Conversion to and from JSON”](https://www.w3.org/TR/xpath-functions-31/#json), XPath and XQuery Functions and Operators 3.1 W3C recommendation
  * [“Schema for the result of `fn:json-to-xml`”](https://www.w3.org/TR/xpath-functions-31/#schema-for-json)
* [The second edition of *XQuery*](https://www.oreilly.com/library/view/xquery-2nd-edition/9781491915080/) by Priscilla Walmsley has a whole chapter on maps, arrays, and JSON
