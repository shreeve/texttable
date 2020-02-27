# texttable

`texttable` is a Ruby gem that provides an easy way to ingest, manage, and output rows and columns as simple tables.

## Simple Example

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

## Loading Example

This code:

```ruby
require "texttable"

info = TextTable.csv("data.csv")
info.show!
```

With the file `data.csv`:

```csv
id,first_name,last_name,email,cell,dept,photo,status
28,Mark,Jones,mark@bigcompany.com,800-555-1000,Finance,mark-jones.jpg,2
29,Sally,Miller,sally@bigcompany.com,800-555-2000,Accounting,sally-miller.jpg,1
```

Will produce:

```text
+----+------------+-----------+----------------------+--------------+------------+------------------+--------+
| id | first_name | last_name | email                | cell         | dept       | photo            | status |
+----+------------+-----------+----------------------+--------------+------------+------------------+--------+
| 28 | Mark       | Jones     | mark@bigcompany.com  | 800-555-1000 | Finance    | mark-jones.jpg   | 2      |
| 29 | Sally      | Miller    | sally@bigcompany.com | 800-555-2000 | Accounting | sally-miller.jpg | 1      |
+----+------------+-----------+----------------------+--------------+------------+------------------+--------+
2 rows displayed
```
