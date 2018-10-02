CREATE OR REPLACE FUNCTION util.log_warning(i_name character varying, i_statement text, i_message character varying DEFAULT NULL::character varying, i_start_date date DEFAULT now())
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
  insert into util.logs(
    name, log_level, start_date, end_date, message, statement
  )
  values (i_name, 'WARNING', i_start_date, now(), i_message, i_statement);
END; $function$
