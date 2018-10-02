CREATE OR REPLACE FUNCTION util.truncate_table(i_name character varying, i_schema character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
  v_start_date date = now();
  v_sql text;
  v_name character varying;
BEGIN
  if i_schema is null then v_name = i_name; else v_name = i_schema ||'.'|| i_name; end if;
  v_sql = 'truncate table '|| v_name;

  execute v_sql;
  execute util.log_success('truncate '||v_name, v_sql);

EXCEPTION
  WHEN OTHERS THEN
	perform util.log_error('truncate '||v_name, v_sql);
  	RAISE exception 'Error Name:%',SQLERRM;
  	RAISE exception 'Error State:%', SQLSTATE;
END;
$function$
