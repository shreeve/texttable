# texttable

`texttable` is a Ruby gem that provides an easy way to print rows and columns as simple tables.

## Examples

This code:

```ruby
require "texttable"

info = TextTable.new
info.add(name: "Tom"  , age: 34, city: "New York")
info.add(name: "Dick" , age: 25, city: "Tuscaloosa")
info.add(name: "Harry", age: 61, city: "Jackson Hole")
info.add(name: "Sally", age: 25, city: "Salt Lake")
info.show
```

Will produce:

```text
+-------+-----+--------------+
| name  | age | city         |
+-------+-----+--------------+
| Tom   | 34  | New York     |
| Dick  | 25  | Tuscaloosa   |
| Harry | 61  | Jackson Hole |
| Sally | 25  | Salt Lake    |
+-------+-----+--------------+
4 rows displayed
```
