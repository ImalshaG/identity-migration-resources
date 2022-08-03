IF EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[UM_USER]') AND TYPE IN (N'U'))
	begin
		DECLARE @ConstraintName0 nvarchar(200)
		SELECT @ConstraintName0 = CONSTRAINT_NAME  FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME='UM_USER' AND COLUMN_NAME='UM_USER_ID'
		IF @ConstraintName0 IS NOT NULL
	    begin
			EXEC('ALTER TABLE UM_USER DROP CONSTRAINT ' + @ConstraintName0);
		end
		ALTER TABLE UM_USER ADD UNIQUE(UM_USER_ID);
		DECLARE @ConstraintName1 nvarchar(200)
		SELECT @ConstraintName1 = CONSTRAINT_NAME  FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME='UM_USER' AND COLUMN_NAME='UM_USER_NAME'
		IF @ConstraintName1 IS NULL
		begin
			ALTER TABLE UM_USER ADD UNIQUE(UM_USER_NAME, UM_TENANT_ID);
		end
	end

CREATE UNIQUE INDEX INDEX_UM_USERNAME_UM_TENANT_ID ON UM_USER(UM_USER_NAME, UM_TENANT_ID);

ALTER TABLE UM_TENANT ADD UM_ORG_UUID VARCHAR(36) DEFAULT NULL;
