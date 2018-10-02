CREATE OR REPLACE FUNCTION util.add_partitions(i_table character varying, i_date date DEFAULT now())
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
  v_start_date date = now();
  v_date_str varchar(20);
  v_last_date date;
  v_sql text;
  d date;
  i interval;
begin
  select
    split_part(part_name, '_', us_cnt + 1) date_str
  into v_date_str
  from
	(
	  select
		  max(inhrelid::regclass::varchar) part_name,
		  (select count(1)::int from (select regexp_matches(max(inhrelid::regclass::varchar), '_', 'g')) a) us_cnt
		from pg_inherits
		where
		  upper(inhparent::regclass::varchar) = upper(i_table)
	) a;

  if char_length(v_date_str) = 8 then
    i = interval '1 day';
    v_last_date = to_date(v_date_str, 'yyyymmdd');
  else
    i = interval '1 month';
    v_last_date = to_date(v_date_str, 'yyyymm');
  end if;

  d := v_last_date + i;

  loop
    exit when d > i_date;
    v_sql =
    'CREATE TABLE '||split_part(i_table,'.', 2) ||'_'|| to_char(d, 'yyyymmdd') ||' partition of '||i_table||'
      FOR VALUES FROM ('''||to_char(d, 'yyyy-mm-dd')||''') to ('''||to_char(d + i, 'yyyy-mm-dd') ||''')
    ';
    execute v_sql;
    execute util.log_success('add_partition '|| i_table, v_sql);
    d = d + i;
  end loop;

exception
  when others then
	execute util.log_error('add_partition '|| i_table, v_sql, sqlerrm);
  	raise exception 'error name:%',sqlerrm;
  	raise exception 'error state:%', sqlstate;
end;
$function$
