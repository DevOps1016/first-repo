--DROP DATABASE IF EXISTS test_p2x
--CREATE DATABASE test_p2x

CREATE SCHEMA infra;

CREATE SEQUENCE infra.project_code_seq START 1;

CREATE TABLE IF NOT EXISTS infra.project
(
    project character varying(100) COLLATE pg_catalog."default" NOT NULL,
    project_code character varying(10) COLLATE pg_catalog."default" NOT NULL DEFAULT ('PS'::text || lpad((nextval('infra.project_code_seq'::regclass))::text, 3, '0'::text)),
    created_by character varying(20) COLLATE pg_catalog."default" DEFAULT 'admin'::character varying,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(20) COLLATE pg_catalog."default" DEFAULT 'admin'::character varying,
    updated_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    description text COLLATE pg_catalog."default",
    is_active boolean DEFAULT true,
    status boolean DEFAULT true,
    CONSTRAINT project_pkey PRIMARY KEY (project_code)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS infra.project
    OWNER to postgres;
	
INSERT INTO infra.project (project, description) VALUES ('Cloud Migration Project', 'Migrating on-premise systems to the cloud');



CREATE TABLE IF NOT EXISTS infra.roles
(
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    role character varying(200) COLLATE pg_catalog."default",
    description character varying(500) COLLATE pg_catalog."default",
    created_by character varying(20) COLLATE pg_catalog."default" DEFAULT 'admin'::character varying,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(20) COLLATE pg_catalog."default" DEFAULT 'admin'::character varying,
    updated_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT roles_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS infra.roles
    OWNER to postgres;
	
INSERT INTO infra.roles (id, role, description) VALUES ('69fd89dc-b2bf-49af-a42b-5ef014c3c484', 'Administrator', 'Has full access to the system');
INSERT INTO infra.roles (id, role, description) VALUES ('136d7ac8-f283-43b7-8e0f-7f7c9e5815f5', 'Developer', 'Has Access to application with minimum rights');



CREATE TABLE IF NOT EXISTS infra.users
(
    user_id character varying(50) COLLATE pg_catalog."default" NOT NULL,
    full_name character varying(150) COLLATE pg_catalog."default",
    email_id character varying(255) COLLATE pg_catalog."default",
    otp character varying(6) COLLATE pg_catalog."default",
    otp_expiry_time timestamp without time zone,
    role_id uuid,
    created_by character varying(20) COLLATE pg_catalog."default" DEFAULT 'admin'::character varying,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(20) COLLATE pg_catalog."default" DEFAULT 'admin'::character varying,
    updated_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    password_hash character varying(255) COLLATE pg_catalog."default",
    project_code character varying(50) COLLATE pg_catalog."default" NOT NULL,
    is_active boolean DEFAULT true,
    CONSTRAINT users_pkey PRIMARY KEY (user_id, project_code),
    CONSTRAINT users_project_code_fkey FOREIGN KEY (project_code)
        REFERENCES infra.project (project_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id)
        REFERENCES infra.roles (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS infra.users
    OWNER to postgres;
	
INSERT INTO infra.users (user_id, full_name, email_id, role_id,password_hash, project_code) VALUES ('105330', 'Admin', 'Admin@p2x.com','69fd89dc-b2bf-49af-a42b-5ef014c3c484','c8837b23ff8aaa8a2dde915473ce099','PS001');
INSERT INTO infra.users (user_id, full_name, email_id, role_id,password_hash, project_code) VALUES ('105332', 'Admin_new', 'admin_new@p2x.com','69fd89dc-b2bf-49af-a42b-5ef014c3c484','0e7517141fb53f21ee439b355b5a1d0a','PS001');


CREATE SEQUENCE infra.access_requests_seq START 1;


CREATE TABLE IF NOT EXISTS infra.access_requests
(
    request_id character varying(15) COLLATE pg_catalog."default" NOT NULL DEFAULT ('REQ'::text || lpad((nextval('infra.access_requests_seq'::regclass))::text, 4, '0'::text)),
    full_name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    email text COLLATE pg_catalog."default" NOT NULL,
    company_name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    why_need_access text COLLATE pg_catalog."default" NOT NULL,
    project_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    project_code character varying(10) COLLATE pg_catalog."default" NOT NULL,
    request_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) COLLATE pg_catalog."default" DEFAULT 'pending'::character varying,
    CONSTRAINT access_requests_pkey PRIMARY KEY (request_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS infra.access_requests
    OWNER to postgres;
	

CREATE TABLE IF NOT EXISTS infra.ai_models
(
    provider_name character varying(100) COLLATE pg_catalog."default",
    model_name character varying(100) COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS infra.ai_models
    OWNER to postgres;


INSERT INTO infra.ai_models (provider_name, model_name) VALUES ('OpenAI', 'gpt-4o');
INSERT INTO infra.ai_models (provider_name, model_name) VALUES ('Google', 'gemini-2.0-flash');
INSERT INTO infra.ai_models (provider_name, model_name) VALUES ('Meta', 'llama-3.2-3b');
INSERT INTO infra.ai_models (provider_name, model_name) VALUES ('Anthropic', 'claude-3-7-sonnet-latest');
INSERT INTO infra.ai_models (provider_name, model_name) VALUES ('Anthropic', 'claude-3-opus-latest');
INSERT INTO infra.ai_models (provider_name, model_name) VALUES ('Google', 'gemini-2.5-pro');
INSERT INTO infra.ai_models (provider_name, model_name) VALUES ('Google Vertex AI', 'gemini-2.0-flash-001');
INSERT INTO infra.ai_models (provider_name, model_name) VALUES ('Open Source LLM', 'qwen3:30b');

CREATE SEQUENCE infra.connection_details_seq START 1;


CREATE TABLE IF NOT EXISTS infra.connection_details
(
    connection_id character varying(10) COLLATE pg_catalog."default" NOT NULL DEFAULT ('CON'::text || lpad((nextval('infra.connection_details_seq'::regclass))::text, 3, '0'::text)),
    connection_name character varying(120) COLLATE pg_catalog."default" NOT NULL,
    db_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    database character varying(120) COLLATE pg_catalog."default" NOT NULL,
    project_code character varying(10) COLLATE pg_catalog."default",
    project_name character varying(100) COLLATE pg_catalog."default",
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    requested_by character varying(150) COLLATE pg_catalog."default" NOT NULL,
    approved_by character varying(150) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    connection_key jsonb NOT NULL,
    connection_status character varying(10) COLLATE pg_catalog."default" DEFAULT 'PENDING'::character varying,
    connection_test character varying(10) COLLATE pg_catalog."default",
    isactive boolean DEFAULT true,
    region character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT connection_details_pkey PRIMARY KEY (connection_id),
    CONSTRAINT connection_details_project_code_fkey FOREIGN KEY (project_code)
        REFERENCES infra.project (project_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS infra.connection_details
    OWNER to postgres;


CREATE TABLE IF NOT EXISTS infra.job_details
(
    run_id character varying(255) COLLATE pg_catalog."default" NOT NULL,
    xml text COLLATE pg_catalog."default",
    user_id character varying(255) COLLATE pg_catalog."default",
    project_code character varying(255) COLLATE pg_catalog."default",
    status character varying(255) COLLATE pg_catalog."default" DEFAULT 'IN PROGRESS'::character varying,
    step character varying(255) COLLATE pg_catalog."default" DEFAULT 'Parsing'::character varying,
    data_handling character varying(255) COLLATE pg_catalog."default",
    validation_status character varying(255) COLLATE pg_catalog."default" DEFAULT 'NA'::character varying,
    xml_type character varying(255) COLLATE pg_catalog."default",
    workflow_name character varying(255) COLLATE pg_catalog."default",
    session_name character varying(255) COLLATE pg_catalog."default",
    mapping_name character varying(255) COLLATE pg_catalog."default",
    metadata jsonb,
    sql_file text COLLATE pg_catalog."default",
    total_transformations integer,
    sources integer,
    targets integer,
    total_input_tokens bigint,
    total_output_tokens bigint,
    total_validation_time text COLLATE pg_catalog."default" DEFAULT 'NA'::text,
    created_by character varying(255) COLLATE pg_catalog."default",
    created_on timestamp without time zone,
    updated_by character varying(255) COLLATE pg_catalog."default",
    updated_on timestamp without time zone,
    is_active boolean,
    target_tech character varying(50) COLLATE pg_catalog."default",
    xml_hash_key character varying COLLATE pg_catalog."default",
    reusable_query text COLLATE pg_catalog."default",
    is_reusable boolean,
    folder_name character varying(100) COLLATE pg_catalog."default",
    reusable_session_name character varying(100) COLLATE pg_catalog."default",
    reusable_worklet_name character varying(100) COLLATE pg_catalog."default",
    visualisation_data jsonb,
    misc_data jsonb,
    schema_details jsonb,
    llm_used character varying(50) COLLATE pg_catalog."default",
    conn_name character varying(255) COLLATE pg_catalog."default",
    param_file_name character varying(255) COLLATE pg_catalog."default",
    topological_sort jsonb,
    total_nodes integer,
    mapplet integer,
    unconnected integer,
    transformation integer,
    version integer NOT NULL,
    reusable_run_id character varying(255) COLLATE pg_catalog."default",
    xml_file_location character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT job_details_pkey PRIMARY KEY (run_id, version),
    CONSTRAINT fk_user_id_key FOREIGN KEY (user_id, project_code)
        REFERENCES infra.users (user_id, project_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT job_details_project_code_fkey FOREIGN KEY (project_code)
        REFERENCES infra.project (project_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS infra.job_details
    OWNER to postgres;

CREATE OR REPLACE FUNCTION infra.get_next_version(run_id_param VARCHAR)
RETURNS INTEGER AS $$
DECLARE 
    next_version INTEGER;
BEGIN
    SELECT COALESCE(MAX(version), 0) + 1
    INTO next_version
    FROM infra.job_details
    WHERE run_id = run_id_param;

    RETURN next_version;
END;
$$ LANGUAGE plpgsql;

-- Step 2: Create trigger function to set version before insert
CREATE OR REPLACE FUNCTION infra.set_version_before_insert()
RETURNS TRIGGER AS $$
BEGIN
    NEW.version := infra.get_next_version(NEW.run_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 3: Create trigger on job_details table
CREATE TRIGGER before_insert_set_version
BEFORE INSERT ON infra.job_details
FOR EACH ROW
EXECUTE FUNCTION infra.set_version_before_insert();

CREATE SEQUENCE infra.llm_model_seq START 1;


CREATE TABLE IF NOT EXISTS infra.llm_models
(
    model_id character varying(10) COLLATE pg_catalog."default" NOT NULL DEFAULT ('LLM'::text || lpad((nextval('infra.llm_model_seq'::regclass))::text, 3, '0'::text)),
    llm_provider character varying(100) COLLATE pg_catalog."default",
    model_name character varying(100) COLLATE pg_catalog."default",
    project_code character varying(10) COLLATE pg_catalog."default",
    project_name character varying(200) COLLATE pg_catalog."default",
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying(50) COLLATE pg_catalog."default",
    updated_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(50) COLLATE pg_catalog."default",
    api_key jsonb,
    status character varying(50) COLLATE pg_catalog."default",
    is_active boolean DEFAULT true,
    CONSTRAINT llm_models_pkey PRIMARY KEY (model_id),
    CONSTRAINT fk_project_code FOREIGN KEY (project_code)
        REFERENCES infra.project (project_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS infra.llm_models
    OWNER to postgres;


CREATE TABLE IF NOT EXISTS infra.project_configurations
(
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    project_code character varying(10) COLLATE pg_catalog."default",
    type character varying(100) COLLATE pg_catalog."default",
    value character varying(500) COLLATE pg_catalog."default",
    created_by character varying(20) COLLATE pg_catalog."default",
    created_on timestamp without time zone,
    updated_by character varying(20) COLLATE pg_catalog."default",
    updated_on timestamp without time zone,
    CONSTRAINT project_configurations_pkey PRIMARY KEY (id),
    CONSTRAINT project_configurations_project_code_fkey FOREIGN KEY (project_code)
        REFERENCES infra.project (project_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS infra.project_configurations
    OWNER to postgres;


CREATE TABLE IF NOT EXISTS infra.schema_details
(
    run_id character varying(255) COLLATE pg_catalog."default" NOT NULL,
    con_id character varying(10) COLLATE pg_catalog."default",
    con_name character varying(120) COLLATE pg_catalog."default" NOT NULL,
    target_tech character varying(100) COLLATE pg_catalog."default",
    table_name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    table_type character varying(100) COLLATE pg_catalog."default",
    db_name character varying(255) COLLATE pg_catalog."default",
    schema_name character varying(255) COLLATE pg_catalog."default",
    created_by character varying(20) COLLATE pg_catalog."default",
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(20) COLLATE pg_catalog."default",
    updated_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS infra.schema_details
    OWNER to postgres;
	

CREATE TABLE IF NOT EXISTS infra.transformation_level_details
(
    run_id character varying(255) COLLATE pg_catalog."default" NOT NULL,
    transformation_name character varying(256) COLLATE pg_catalog."default" NOT NULL,
    sql_file text COLLATE pg_catalog."default",
    iteration integer NOT NULL,
    status character varying(20) COLLATE pg_catalog."default",
    transformation_type character varying(50) COLLATE pg_catalog."default",
    metadata jsonb,
    failure_message text COLLATE pg_catalog."default",
    input_tokens bigint,
    llm_used character varying(60) COLLATE pg_catalog."default",
    output_tokens bigint,
    created_by character varying(20) COLLATE pg_catalog."default",
    created_on timestamp without time zone,
    updated_by character varying(20) COLLATE pg_catalog."default",
    updated_on timestamp without time zone,
    CONSTRAINT transformation_level_details_pkey PRIMARY KEY (run_id, iteration, transformation_name)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS infra.transformation_level_details
    OWNER to postgres;

-- Trigger: before_insert_set_iteration
	
CREATE OR REPLACE FUNCTION infra.get_next_iteration(run_id_param VARCHAR, transformation_name_param VARCHAR)
RETURNS INTEGER AS $$
DECLARE 
    next_iteration INTEGER;
BEGIN
    -- Get the max iteration for the given run_id and transformation_name
    SELECT COALESCE(MAX(iteration), 0) + 1 
    INTO next_iteration
    FROM infra.Transformation_Level_Details
    WHERE run_id = run_id_param
    AND transformation_name = transformation_name_param;

    RETURN next_iteration;
END;
$$ LANGUAGE plpgsql;


-- Create Trigger Function to Set iteration Before Insert
CREATE OR REPLACE FUNCTION infra.set_iteration_before_insert()
RETURNS TRIGGER AS $$
BEGIN
    -- Automatically set iteration before inserting a new row
    NEW.iteration := infra.get_next_iteration(NEW.run_id, NEW.transformation_name);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a Trigger to Execute the Function

CREATE TRIGGER before_insert_set_iteration
BEFORE INSERT ON infra.Transformation_Level_Details
FOR EACH ROW EXECUTE FUNCTION infra.set_iteration_before_insert();


CREATE TABLE IF NOT EXISTS infra.user_projects
(
    user_id character varying(50) COLLATE pg_catalog."default",
    project_code character varying(10) COLLATE pg_catalog."default",
    created_by character varying(20) COLLATE pg_catalog."default" DEFAULT 'admin'::character varying,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_by character varying(20) COLLATE pg_catalog."default" DEFAULT 'admin'::character varying,
    updated_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS infra.user_projects
    OWNER to postgres;



