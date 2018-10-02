CREATE OR REPLACE FUNCTION util.truncate_partitions_gt(i_table character varying, i_date date DEFAULT now())
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
  v_sql text;
  v_table varchar(100);
  d date;
  v_max_date date;
  v_date_str varchar(20);
  v_max_partition character varying;
  v_us_count int;
  i interval;
begin

  v_max_partition = util.get_max_partition(i_table);
  v_us_count = char_length(v_max_partition) - char_length(replace(v_max_partition, '_', ''));
  v_date_str = split_part(v_max_partition, '_', v_us_count + 1);

  if char_length(v_date_str) = 8 then
    v_max_date = to_date(v_date_str, 'yyyymmdd');
    i = interval '1 day';
  else
    v_max_date = to_date(v_date_str, 'yyyymm');
    i = interval '1 month';
  end if;

  d := i_date + i;
  loop
    exit when d > v_max_date;

    if char_length(v_date_str) = 8 then
      v_table = split_part(i_table, '.', 2) || '_' ||to_char(i_date, 'yyyymmdd');
    else
      v_table = split_part(i_table, '.', 2) || '_' ||to_char(i_date, 'yyyymm');
    end if;

    v_sql = 'truncate table ' || v_table;
    execute v_sql;
    execute util.log_success('truncate_partition '|| v_table , v_sql);
    d = d + i;
  end loop;


exception
  when others then
	  execute util.log_error('add_partition '|| i_table, v_sql, sqlerrm);
  	raise exception 'error name:%',sqlerrm;
  	raise exception 'error state:%', sqlstate;
end;
$function$
