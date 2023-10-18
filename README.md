- create util schema

```sql
  CREATE SCHEMA util
```

- create functions under `functions`


# example usage:

- create a demo table
```sql
create table util.dropme ( -- can be any name
	a text
);
```

- call the drop method from util

```sql
DO $$
BEGIN
  perform util.drop_table('util.dropme');
END;
$$;

```

- see the logs with:
```sql
select * from util.logs
```
