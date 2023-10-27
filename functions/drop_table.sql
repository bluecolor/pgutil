CREATE OR REPLACE FUNCTION util.drop_table(i_name character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
  v_start_date date = now();
  v_sql text;
BEGIN
  v_sql = 'drop table '|| i_name;
  execute v_sql;
  execute util.log_success('drop '|| i_name, v_sql);
EXCEPTION
  WHEN OTHERS THEN
	  execute util.log_warning('drop '|| i_name, v_sql, SQLERRM);
  	RAISE INFO 'Error Name:%',SQLERRM;
  	RAISE INFO 'Error State:%', SQLSTATE;
END;
$function$
