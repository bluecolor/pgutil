CREATE OR REPLACE FUNCTION util.truncate_partition(i_table character varying, i_date date DEFAULT now())
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
  v_sql text;
  v_date_str varchar(20);
  v_max_partition character varying;
  v_us_count int;
begin

  v_max_partition = util.get_max_partition(i_table);
  v_us_count = char_length(v_max_partition) - char_length(replace(v_max_partition, '_', ''));
  v_date_str = split_part(v_max_partition, '_', v_us_count + 1);

  if char_length(v_date_str) = 8 then
    v_sql = 'truncate table ' || split_part(i_table, '.', 2) || '_' ||to_char(i_date, 'yyyymmdd');
  else
    v_sql = 'truncate table ' || split_part(i_table, '.', 2) || '_' ||to_char(i_date, 'yyyymm');
  end if;

  execute v_sql;
  execute util.log_success('truncate_partition '|| i_table, v_sql);

exception
  when others then
	  execute util.log_error('add_partition '|| i_table, v_sql, sqlerrm);
  	raise exception 'error name:%',sqlerrm;
  	raise exception 'error state:%', sqlstate;
end;
$function$
