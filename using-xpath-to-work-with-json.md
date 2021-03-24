# Using XPath 3.1 (and its friends) to work with JSON

My name is Ash Clark and my pronouns are e, em, eir. I’m the XML Applications Developer for the Northeastern University Digital Scholarship Group and the Women Writers Project.

I turn Text Encoding Initiative XML documents into APIs and interfaces. To support these, I write RESTXQ applications which are served out of XML databases eXist-DB and BaseX. I work heavily with XQuery, a scripting language that extends the functionality of XPath. Also: XSLT, CSS. Reluctantly: Javascript.

Lots of people prefer to get JSON responses from APIs. I like XML better, but I want my APIs to support both, especially because I’m working in the Digital Humanities. There’s no one tool that the field is guaranteed to be comfortable with. And each API I make could be someone’s first.

I warmed to JSON when I realized there was actually a good deal of overlap between JSON and XML:

* one “root”,
* hierarchy,
* meaningful groupings, and
* common formats for data interchange

(But I’ll never recommend JSON for marking up documents. Use XML or HTML!)

Enter XPath and XQuery 3.1, and XSLT 3.0! The W3C recommendations were published in 2017. The functionality is available in Saxon processors, and the eXist-DB and BaseX databases.

Crucially, the new versions integrate support for working with JSON! They introduce new complex data structures: *maps*, which are key-value pairs; and *arrays*, ordered groupings of values. Both of these can nest, unlike the standard sequences. And both can accept any type of value, including XML nodes and the new inline functions! I’ve been working with maps and arrays for most of my time at NU, and I love them. So much.

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

You can access data in them with functions or with terse lookup operators.
```
map:get($myMap, "greeting")
  eq  $myMap("greeting")
  eq  $myMap?greeting
(: true(), these accessors all retrieve the same value :)

array:get($myArray, 1)
  eq  $myArray(1)
  eq  $myArray?1
(: true(), these accessors all retrieve the same value :)
```

You can qualify the results you expect, as you can with XPath expressions:
```
(: Return $myMap, but only if the key "greeting" has the string value "Hello" :)
$myMap[?greeting eq "Hello"]

(: Return $myArray, but only if one of its values is the string "World" :)
$myArray[?*[. eq "World"]]
```

The new XPath, XQuery, and XSLT can convert JSON strings or files into maps and arrays. They can *also* serialize maps and arrays back to JSON. *And* they can convert JSON to XML, and vice versa! (With the caveat that the equivalent XML must follow a W3C-defined schema.)

My uses:

* Key-value pairs are *great* for mapping parameter names onto human-readable labels!
* The nesting of arrays means I can do complex ordering of values, e.g. position one of the outer array is all the records which sort to X value
* I can cache the XML representation of JSON in my XML database, which gives me indexing and quick query results
* I can create RESTXQ APIs which return XML or JSON on request (or HTML, after applying an XSL transformation)
* I can pass maps around instead of creating XQuery functions with oodles of required parameters


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
