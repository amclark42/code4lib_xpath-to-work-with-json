xquery version "3.1";

(:  NAMESPACES  :)
  declare namespace array="http://www.w3.org/2005/xpath-functions/array";
  declare namespace map="http://www.w3.org/2005/xpath-functions/map";
  declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
(:  OPTIONS  :)
  declare option output:method "json";

(:~
  @author Ash Clark
  2021
 :)


(:  MAIN QUERY  :)

let $attendees-from-Northeastern := ( "Ash", "Patrick", "Bill", "Amy" )
let $myMap := map {
    "greeting": "Hello",
    "who": [
        "World",
        <orgName>Code4Lib 2021</orgName>,
        $attendees-from-Northeastern
      ]
  }
let $myArray := $myMap?who
return map {
    
    "comparing map accessors": [
        map:get($myMap, "greeting") eq $myMap("greeting"),
        $myMap("greeting") eq $myMap?greeting
      ],
    
    "comparing array accessors": [
        array:get($myArray, 1) eq $myArray(1),
        $myArray(1) eq $myArray?1
      ],
    
    "checking if the map has a certain value":
      exists( $myMap[?greeting eq "Hello"] ),
    
    "checking if the array has a certain value":
      exists( $myArray[?*[. eq "World"]] )
  }
