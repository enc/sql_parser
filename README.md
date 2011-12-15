#SQL Parser

SQL is not SQL!
Nearly everybody has it's own little dialect. I had a lot of problems
migrating from MS Access to SQL Server.

This tool reads a SQL-File parses it and writes a file in a specified
SQL format.

## Installation

```
gem install sql_parser
```

## Usage

parsesql -i access -o sqlserver in.sql out.sql

This will do the work

Supported formats:
* MS Access
* Ms SQL Server
* Postgresql

