--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: sky_search_data; Type: SCHEMA; Schema: -; Owner: root
--

CREATE SCHEMA sky_search_data;


ALTER SCHEMA sky_search_data OWNER TO root;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: items; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE items (
    id integer NOT NULL,
    gender integer NOT NULL,
    color integer NOT NULL,
    brand integer NOT NULL,
    season integer NOT NULL
);


ALTER TABLE items OWNER TO root;

SET search_path = sky_search_data, pg_catalog;

--
-- Name: attribute; Type: TABLE; Schema: sky_search_data; Owner: root
--

CREATE TABLE attribute (
    a_id integer NOT NULL,
    a_name character varying(256)
);


ALTER TABLE attribute OWNER TO root;

--
-- Name: attribute_a_id_seq; Type: SEQUENCE; Schema: sky_search_data; Owner: root
--

CREATE SEQUENCE attribute_a_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE attribute_a_id_seq OWNER TO root;

--
-- Name: attribute_a_id_seq; Type: SEQUENCE OWNED BY; Schema: sky_search_data; Owner: root
--

ALTER SEQUENCE attribute_a_id_seq OWNED BY attribute.a_id;


--
-- Name: attribute_dictionary; Type: TABLE; Schema: sky_search_data; Owner: root
--

CREATE TABLE attribute_dictionary (
    ad_id integer NOT NULL,
    ad_attribute_id integer,
    ad_value_integer integer,
    ad_value_string character varying(256)
);


ALTER TABLE attribute_dictionary OWNER TO root;

--
-- Name: attribute_dictionary_ad_id_seq; Type: SEQUENCE; Schema: sky_search_data; Owner: root
--

CREATE SEQUENCE attribute_dictionary_ad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE attribute_dictionary_ad_id_seq OWNER TO root;

--
-- Name: attribute_dictionary_ad_id_seq; Type: SEQUENCE OWNED BY; Schema: sky_search_data; Owner: root
--

ALTER SEQUENCE attribute_dictionary_ad_id_seq OWNED BY attribute_dictionary.ad_id;


--
-- Name: input_json; Type: TABLE; Schema: sky_search_data; Owner: root
--

CREATE TABLE input_json (
    ij_id integer NOT NULL,
    ij_created timestamp without time zone,
    ij_last_modified timestamp without time zone,
    ij_json jsonb
);


ALTER TABLE input_json OWNER TO root;

--
-- Name: input_json_ij_id_seq; Type: SEQUENCE; Schema: sky_search_data; Owner: root
--

CREATE SEQUENCE input_json_ij_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE input_json_ij_id_seq OWNER TO root;

--
-- Name: input_json_ij_id_seq; Type: SEQUENCE OWNED BY; Schema: sky_search_data; Owner: root
--

ALTER SEQUENCE input_json_ij_id_seq OWNED BY input_json.ij_id;


--
-- Name: input_normalized; Type: TABLE; Schema: sky_search_data; Owner: root
--

CREATE TABLE input_normalized (
    in_id integer NOT NULL,
    in_object_id integer,
    in_attribute_id integer,
    in_value smallint
);


ALTER TABLE input_normalized OWNER TO root;

--
-- Name: input_normalized_in_id_seq; Type: SEQUENCE; Schema: sky_search_data; Owner: root
--

CREATE SEQUENCE input_normalized_in_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE input_normalized_in_id_seq OWNER TO root;

--
-- Name: input_normalized_in_id_seq; Type: SEQUENCE OWNED BY; Schema: sky_search_data; Owner: root
--

ALTER SEQUENCE input_normalized_in_id_seq OWNED BY input_normalized.in_id;


--
-- Name: attribute a_id; Type: DEFAULT; Schema: sky_search_data; Owner: root
--

ALTER TABLE ONLY attribute ALTER COLUMN a_id SET DEFAULT nextval('attribute_a_id_seq'::regclass);


--
-- Name: attribute_dictionary ad_id; Type: DEFAULT; Schema: sky_search_data; Owner: root
--

ALTER TABLE ONLY attribute_dictionary ALTER COLUMN ad_id SET DEFAULT nextval('attribute_dictionary_ad_id_seq'::regclass);


--
-- Name: input_json ij_id; Type: DEFAULT; Schema: sky_search_data; Owner: root
--

ALTER TABLE ONLY input_json ALTER COLUMN ij_id SET DEFAULT nextval('input_json_ij_id_seq'::regclass);


--
-- Name: input_normalized in_id; Type: DEFAULT; Schema: sky_search_data; Owner: root
--

ALTER TABLE ONLY input_normalized ALTER COLUMN in_id SET DEFAULT nextval('input_normalized_in_id_seq'::regclass);


SET search_path = public, pg_catalog;

--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: root
--

COPY items (id, gender, color, brand, season) FROM stdin;
1	1	1	1	1
2	2	2	2	2
3	1	3	1	3
4	2	4	2	4
5	3	4	1	1
6	3	4	2	2
7	3	6	1	3
8	1	5	3	4
9	2	7	1	1
10	2	7	2	2
\.


SET search_path = sky_search_data, pg_catalog;

--
-- Data for Name: attribute; Type: TABLE DATA; Schema: sky_search_data; Owner: root
--

COPY attribute (a_id, a_name) FROM stdin;
\.


--
-- Name: attribute_a_id_seq; Type: SEQUENCE SET; Schema: sky_search_data; Owner: root
--

SELECT pg_catalog.setval('attribute_a_id_seq', 1, false);


--
-- Data for Name: attribute_dictionary; Type: TABLE DATA; Schema: sky_search_data; Owner: root
--

COPY attribute_dictionary (ad_id, ad_attribute_id, ad_value_integer, ad_value_string) FROM stdin;
\.


--
-- Name: attribute_dictionary_ad_id_seq; Type: SEQUENCE SET; Schema: sky_search_data; Owner: root
--

SELECT pg_catalog.setval('attribute_dictionary_ad_id_seq', 1, false);


--
-- Data for Name: input_json; Type: TABLE DATA; Schema: sky_search_data; Owner: root
--

COPY input_json (ij_id, ij_created, ij_last_modified, ij_json) FROM stdin;
\.


--
-- Name: input_json_ij_id_seq; Type: SEQUENCE SET; Schema: sky_search_data; Owner: root
--

SELECT pg_catalog.setval('input_json_ij_id_seq', 1, false);


--
-- Data for Name: input_normalized; Type: TABLE DATA; Schema: sky_search_data; Owner: root
--

COPY input_normalized (in_id, in_object_id, in_attribute_id, in_value) FROM stdin;
\.


--
-- Name: input_normalized_in_id_seq; Type: SEQUENCE SET; Schema: sky_search_data; Owner: root
--

SELECT pg_catalog.setval('input_normalized_in_id_seq', 1, false);


SET search_path = public, pg_catalog;

--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: public; Type: ACL; Schema: -; Owner: root
--

REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO root;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

