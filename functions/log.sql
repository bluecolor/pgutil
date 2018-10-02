CREATE OR REPLACE FUNCTION util.log(name character varying, message character varying, statement text DEFAULT NULL::text, log_level character varying DEFAULT 'INFO'::character varying, start_date date DEFAULT now(), end_date date DEFAULT now())
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
  insert into util.logs(
    name, log_level, start_date, end_date, message, statement
  )
  values (name, log_level, start_date, end_date, message, statement);
END; $function$
