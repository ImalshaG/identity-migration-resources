ALTER TABLE CM_PURPOSE
  ADD PURPOSE_GROUP VARCHAR(255) DEFAULT 'DEFAULT_PURPOSE_GROUP' NOT NULL;
ALTER TABLE CM_PURPOSE
  ADD GROUP_TYPE VARCHAR(255) DEFAULT 'DEFAULT_GROUP_TYPE' NOT NULL;

CREATE ALIAS IF NOT EXISTS DROP_FK AS $$ void executeSql(Connection conn, String sql) throws SQLException { conn.createStatement().executeUpdate(sql); } $$;
call drop_fk('ALTER TABLE CM_PURPOSE DROP CONSTRAINT ' || (SELECT tc.CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc JOIN INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS ccu ON tc.CONSTRAINT_NAME = ccu.CONSTRAINT_NAME WHERE tc.TABLE_NAME = 'CM_PURPOSE' AND CONSTRAINT_TYPE = 'UNIQUE' AND (COLUMN_NAME = 'NAME' OR COLUMN_NAME = 'TENANT_ID') GROUP BY tc.CONSTRAINT_NAME HAVING COUNT(tc.CONSTRAINT_NAME) = 2));
DROP ALIAS IF EXISTS DROP_FK;

ALTER TABLE CM_PURPOSE
  ADD CONSTRAINT PURPOSE_CONSTRAINT UNIQUE (NAME, TENANT_ID, PURPOSE_GROUP, GROUP_TYPE);

UPDATE CM_PURPOSE
SET
PURPOSE_GROUP =
CASE WHEN NAME = 'DEFAULT' THEN 'DEFAULT' ELSE 'SIGNUP' END;

UPDATE CM_PURPOSE
SET
GROUP_TYPE =
CASE WHEN NAME = 'DEFAULT' THEN 'SP' ELSE 'SYSTEM' end;

ALTER TABLE CM_PURPOSE_PII_CAT_ASSOC
ADD IS_MANDATORY INTEGER DEFAULT 1 NOT NULL;