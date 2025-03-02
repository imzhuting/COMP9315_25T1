DROP TYPE IF EXISTS SchemaTuple CASCADE;
CREATE TYPE SchemaTuple AS ("table" TEXT, "attributes" TEXT);

CREATE OR REPLACE FUNCTION schema1() RETURNS SETOF SchemaTuple
AS $$
DECLARE
        rec   RECORD;
        rel   TEXT := '';
	attr  TEXT := '';
        attrs TEXT := '';
        out   SchemaTuple;
	len   INTEGER := 0;
BEGIN
	FOR rec IN
		SELECT r.relname, a.attname, t.typname, a.atttypmod
		FROM   PG_CLASS r
			JOIN PG_NAMESPACE n ON (r.relnamespace = n.oid)
			JOIN PG_ATTRIBUTE a ON (a.attrelid = r.oid)
			JOIN PG_TYPE t ON (a.atttypid = t.oid)
		WHERE  r.relkind='r'
			AND n.nspname = 'public'
			AND attnum > 0
		ORDER BY relname, attnum
	LOOP
		IF (rec.relname <> rel) THEN
			IF (rel <> '') THEN
				out."table" := rel;
				out.attributes := attrs;
				RETURN NEXT out;
			END IF;
			rel := rec.relname;
			attrs := '';
			len := 0;
		END IF;
		IF (attrs <> '') THEN
			attrs := attrs || ', ';
			len := len + 2;
		END IF;
		IF (rec.typname = 'varchar') THEN
			rec.typname := 'VARCHAR('||(rec.atttypmod-4)||')';
		ELSIF (rec.typname = 'bpchar') THEN
			rec.typname := 'CHAR('||(rec.atttypmod-4)||')';
		ELSIF (rec.typname = 'int4') THEN
			rec.typname := 'INTEGER';
		ELSIF (rec.typname = 'float8') THEN
			rec.typname := 'FLOAT';
		END IF;
		attr := rec.attname||':'||rec.typname;
		IF (len + LENGTH(attr) > 50) THEN
			attrs := attrs || E'\n';
			len := 0;
		END IF;
		attrs := attrs || attr;
		len := len + LENGTH(attr);
	END LOOP;
	-- DEAL WITH LAST TABLE
	IF (rel <> '') THEN
		out."table" := rel;
		out.attributes := attrs;
		RETURN NEXT out;
	END IF;
END;
$$ LANGUAGE PLPGSQL;

