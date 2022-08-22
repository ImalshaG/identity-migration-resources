ALTER TABLE IDN_SAML2_ASSERTION_STORE ADD COLUMN ASSERTION BLOB;

ALTER TABLE WF_BPS_PROFILE ADD CALLBACK_USERNAME VARCHAR(45);

ALTER TABLE WF_BPS_PROFILE ADD CALLBACK_PASSWORD VARCHAR(255);

ALTER TABLE IDN_OAUTH_CONSUMER_APPS ALTER COLUMN CALLBACK_URL VARCHAR(2048);

ALTER TABLE IDN_OAUTH1A_REQUEST_TOKEN ALTER COLUMN CALLBACK_URL VARCHAR(2048);

ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ALTER COLUMN CALLBACK_URL VARCHAR(2048);

CREATE TABLE IF NOT EXISTS IDN_AUTH_USER (
	USER_ID VARCHAR(255) NOT NULL,
	USER_NAME VARCHAR(255) NOT NULL,
	TENANT_ID INTEGER NOT NULL,
	DOMAIN_NAME VARCHAR(255) NOT NULL,
	IDP_ID INTEGER NOT NULL,
	PRIMARY KEY (USER_ID),
	CONSTRAINT USER_STORE_CONSTRAINT UNIQUE (USER_NAME, TENANT_ID, DOMAIN_NAME, IDP_ID));

CREATE TABLE IF NOT EXISTS IDN_AUTH_USER_SESSION_MAPPING (
	USER_ID VARCHAR(255) NOT NULL,
	SESSION_ID VARCHAR(255) NOT NULL,
	CONSTRAINT USER_SESSION_STORE_CONSTRAINT UNIQUE (USER_ID, SESSION_ID));

CREATE INDEX IF NOT EXISTS IDX_USER_ID ON IDN_AUTH_USER_SESSION_MAPPING (USER_ID);

CREATE INDEX IF NOT EXISTS IDX_SESSION_ID ON IDN_AUTH_USER_SESSION_MAPPING (SESSION_ID);

CREATE INDEX IF NOT EXISTS IDX_OCA_UM_TID_UD_APN ON IDN_OAUTH_CONSUMER_APPS(USERNAME,TENANT_ID,USER_DOMAIN, APP_NAME);

CREATE INDEX IF NOT EXISTS IDX_SPI_APP ON SP_INBOUND_AUTH(APP_ID);

CREATE INDEX IF NOT EXISTS IDX_IOP_TID_CK ON IDN_OIDC_PROPERTY(TENANT_ID,CONSUMER_KEY);

-- IDN_OAUTH2_ACCESS_TOKEN --

CREATE INDEX IF NOT EXISTS IDX_AT_AU_TID_UD_TS_CKID ON IDN_OAUTH2_ACCESS_TOKEN(AUTHZ_USER, TENANT_ID, USER_DOMAIN, TOKEN_STATE, CONSUMER_KEY_ID);

CREATE INDEX IF NOT EXISTS IDX_AT_AT ON IDN_OAUTH2_ACCESS_TOKEN(ACCESS_TOKEN);

CREATE INDEX IF NOT EXISTS IDX_AT_AU_CKID_TS_UT ON IDN_OAUTH2_ACCESS_TOKEN(AUTHZ_USER, CONSUMER_KEY_ID, TOKEN_STATE, USER_TYPE);

CREATE INDEX IF NOT EXISTS IDX_AT_RTH ON IDN_OAUTH2_ACCESS_TOKEN(REFRESH_TOKEN_HASH);

CREATE INDEX IF NOT EXISTS IDX_AT_RT ON IDN_OAUTH2_ACCESS_TOKEN(REFRESH_TOKEN);

-- IDN_OAUTH2_AUTHORIZATION_CODE --

CREATE INDEX IF NOT EXISTS IDX_AC_CKID ON IDN_OAUTH2_AUTHORIZATION_CODE(CONSUMER_KEY_ID);

CREATE INDEX IF NOT EXISTS IDX_AC_TID ON IDN_OAUTH2_AUTHORIZATION_CODE(TOKEN_ID);

CREATE INDEX IF NOT EXISTS IDX_AC_AC_CKID ON IDN_OAUTH2_AUTHORIZATION_CODE(AUTHORIZATION_CODE, CONSUMER_KEY_ID);

-- IDN_OAUTH2_SCOPE --

CREATE INDEX IF NOT EXISTS IDX_SC_TID ON IDN_OAUTH2_SCOPE(TENANT_ID);

CREATE INDEX IF NOT EXISTS IDX_SC_N_TID ON IDN_OAUTH2_SCOPE(NAME, TENANT_ID);

-- IDN_OAUTH2_SCOPE_BINDING --

CREATE INDEX IF NOT EXISTS IDX_SB_SCPID ON IDN_OAUTH2_SCOPE_BINDING(SCOPE_ID);

-- IDN_OIDC_REQ_OBJECT_REFERENCE --

CREATE INDEX IF NOT EXISTS IDX_OROR_TID ON IDN_OIDC_REQ_OBJECT_REFERENCE(TOKEN_ID);

-- IDN_OAUTH2_ACCESS_TOKEN_SCOPE --

CREATE INDEX IF NOT EXISTS IDX_ATS_TID ON IDN_OAUTH2_ACCESS_TOKEN_SCOPE(TOKEN_ID);

-- IDN_AUTH_USER --

CREATE INDEX IF NOT EXISTS IDX_AUTH_USER_UN_TID_DN ON IDN_AUTH_USER (USER_NAME, TENANT_ID, DOMAIN_NAME);

CREATE INDEX IF NOT EXISTS IDX_AUTH_USER_DN_TOD ON IDN_AUTH_USER (DOMAIN_NAME, TENANT_ID);
