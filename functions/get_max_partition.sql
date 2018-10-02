CREATE OR REPLACE FUNCTION util.get_max_partition(i_table character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare
  v_max_partition varchar(20);
begin
  select
    max(inhrelid::regclass::varchar) part_name
  into v_max_partition
  from pg_inherits
  where
    upper(inhparent::regclass::varchar) = upper(i_table);

  return v_max_partition;
exception
  when others then
	execute util.log_error('add_partition '|| i_table, v_sql, sqlerrm);
  	raise exception 'error name:%',sqlerrm;
  	raise exception 'error state:%', sqlstate;
end;
$function$
