--
-- PostgreSQL database dump
--

-- Dumped from database version 15.10 (Homebrew)
-- Dumped by pg_dump version 15.10 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: reservation_status_enum; Type: TYPE; Schema: public; Owner: dev
--

CREATE TYPE public.reservation_status_enum AS ENUM (
    'PENDING',
    'CONFIRMED',
    'CANCELED'
);


ALTER TYPE public.reservation_status_enum OWNER TO dev;

--
-- Name: role_type_enum; Type: TYPE; Schema: public; Owner: dev
--

CREATE TYPE public.role_type_enum AS ENUM (
    'ADMINISTRATOR',
    'HOST',
    'CUSTOMER'
);


ALTER TYPE public.role_type_enum OWNER TO dev;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity_log; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.activity_log (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    external_user_id integer,
    request_body character varying,
    response_body character varying,
    ip_address character varying(45),
    headers text,
    method character varying NOT NULL,
    uri character varying NOT NULL,
    status_code integer NOT NULL,
    duration integer NOT NULL,
    resource_name character varying NOT NULL,
    resource_id character varying,
    description character varying,
    user_id integer
);


ALTER TABLE public.activity_log OWNER TO dev;

--
-- Name: activity_log_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.activity_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activity_log_id_seq OWNER TO dev;

--
-- Name: activity_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.activity_log_id_seq OWNED BY public.activity_log.id;


--
-- Name: menu_item; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.menu_item (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying NOT NULL,
    description text NOT NULL,
    price integer NOT NULL,
    image_url character varying NOT NULL,
    category character varying NOT NULL,
    is_available boolean DEFAULT true NOT NULL
);


ALTER TABLE public.menu_item OWNER TO dev;

--
-- Name: menu_item_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.menu_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.menu_item_id_seq OWNER TO dev;

--
-- Name: menu_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.menu_item_id_seq OWNED BY public.menu_item.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.migrations OWNER TO dev;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.migrations_id_seq OWNER TO dev;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: reservation; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.reservation (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    number_of_guests smallint NOT NULL,
    reservation_date timestamp with time zone NOT NULL,
    status public.reservation_status_enum DEFAULT 'PENDING'::public.reservation_status_enum NOT NULL,
    user_id integer NOT NULL,
    table_id integer,
    time_slot_id integer NOT NULL
);


ALTER TABLE public.reservation OWNER TO dev;

--
-- Name: reservation_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.reservation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reservation_id_seq OWNER TO dev;

--
-- Name: reservation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.reservation_id_seq OWNED BY public.reservation.id;


--
-- Name: role; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.role (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    name character varying NOT NULL,
    type public.role_type_enum NOT NULL,
    description character varying NOT NULL
);


ALTER TABLE public.role OWNER TO dev;

--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_id_seq OWNER TO dev;

--
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.role_id_seq OWNED BY public.role.id;


--
-- Name: table; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public."table" (
    id integer NOT NULL,
    capacity smallint NOT NULL,
    table_number character varying NOT NULL
);


ALTER TABLE public."table" OWNER TO dev;

--
-- Name: table_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.table_id_seq OWNER TO dev;

--
-- Name: table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.table_id_seq OWNED BY public."table".id;


--
-- Name: time_slot; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.time_slot (
    id integer NOT NULL,
    start timestamp with time zone NOT NULL,
    "end" timestamp with time zone NOT NULL,
    available_seats smallint NOT NULL
);


ALTER TABLE public.time_slot OWNER TO dev;

--
-- Name: time_slot_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.time_slot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.time_slot_id_seq OWNER TO dev;

--
-- Name: time_slot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.time_slot_id_seq OWNED BY public.time_slot.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    role_id integer
);


ALTER TABLE public."user" OWNER TO dev;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO dev;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: activity_log id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.activity_log ALTER COLUMN id SET DEFAULT nextval('public.activity_log_id_seq'::regclass);


--
-- Name: menu_item id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.menu_item ALTER COLUMN id SET DEFAULT nextval('public.menu_item_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: reservation id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.reservation ALTER COLUMN id SET DEFAULT nextval('public.reservation_id_seq'::regclass);


--
-- Name: role id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);


--
-- Name: table id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public."table" ALTER COLUMN id SET DEFAULT nextval('public.table_id_seq'::regclass);


--
-- Name: time_slot id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.time_slot ALTER COLUMN id SET DEFAULT nextval('public.time_slot_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: activity_log; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.activity_log (id, created_at, external_user_id, request_body, response_body, ip_address, headers, method, uri, status_code, duration, resource_name, resource_id, description, user_id) FROM stdin;
1	2025-05-26 12:02:31.325771	\N	\N	\N	\N	\N	POST	development script	201	8023	user	1	Create user from development script	\N
2	2025-05-26 16:58:00.872211	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748271480836","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	2	reservation	available	Get a reservation by id	3
3	2025-05-26 17:09:21.763021	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272161732","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
4	2025-05-26 17:10:34.857168	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272234836","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
5	2025-05-26 17:10:37.871603	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272237864","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
6	2025-05-26 17:10:38.275884	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272238271","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	0	reservation	available	Get a reservation by id	3
7	2025-05-26 17:10:38.595441	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272238591","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
8	2025-05-26 17:10:38.783186	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272238778","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	0	reservation	available	Get a reservation by id	3
9	2025-05-26 17:10:38.929943	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272238926","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	0	reservation	available	Get a reservation by id	3
10	2025-05-26 17:10:39.078273	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272239074","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	0	reservation	available	Get a reservation by id	3
11	2025-05-26 17:10:39.225773	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272239220","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	0	reservation	available	Get a reservation by id	3
12	2025-05-26 17:10:42.329051	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272242322","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
13	2025-05-26 17:10:44.722853	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272244718","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	0	reservation	available	Get a reservation by id	3
14	2025-05-26 17:10:46.622454	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272246618","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4	400	1	reservation	available	Get a reservation by id	3
15	2025-05-26 17:10:48.559816	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272248555","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	0	reservation	available	Get a reservation by id	3
16	2025-05-26 17:11:21.130023	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272281106","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
17	2025-05-26 17:11:25.892267	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272285886","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	0	reservation	available	Get a reservation by id	3
18	2025-05-26 17:11:51.530804	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272311509","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
19	2025-05-26 17:11:55.44408	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272315438","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	0	reservation	available	Get a reservation by id	3
20	2025-05-26 17:11:55.582451	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272315577","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	0	reservation	available	Get a reservation by id	3
21	2025-05-26 17:11:55.721487	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748272315717","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	0	reservation	available	Get a reservation by id	3
22	2025-05-26 17:26:05.510153	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273165471","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
23	2025-05-26 17:34:21.199954	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273661179","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
24	2025-05-26 17:34:37.307012	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273677294","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	0	reservation	available	Get a reservation by id	3
25	2025-05-26 17:35:03.635745	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273703611","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
26	2025-05-26 17:35:19.10083	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273719079","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
27	2025-05-26 17:35:46.687825	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273746665","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
28	2025-05-26 17:36:49.235832	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273809199","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
29	2025-05-26 17:37:16.440901	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273836428","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
30	2025-05-26 17:37:46.792647	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273866774","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
31	2025-05-26 17:37:54.707529	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273874690","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	0	reservation	available	Get a reservation by id	3
32	2025-05-26 17:37:55.984684	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273875980","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
33	2025-05-26 17:38:20.527645	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273900512","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	0	reservation	available	Get a reservation by id	3
34	2025-05-26 17:38:38.273762	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273918255","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	available	Get a reservation by id	3
35	2025-05-26 17:38:54.933747	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273934909","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	2	reservation	available	Get a reservation by id	3
36	2025-05-26 17:38:58.944512	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273938938","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	0	reservation	available	Get a reservation by id	3
37	2025-05-26 17:39:05.286045	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273945280","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available	400	0	reservation	available	Get a reservation by id	3
38	2025-05-26 17:39:05.791707	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273945786","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available	400	0	reservation	available	Get a reservation by id	3
39	2025-05-26 17:39:05.948834	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273945944","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available	400	0	reservation	available	Get a reservation by id	3
40	2025-05-26 17:39:06.094084	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273946090","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available	400	0	reservation	available	Get a reservation by id	3
41	2025-05-26 17:39:06.247092	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273946243","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available	400	0	reservation	available	Get a reservation by id	3
42	2025-05-26 17:39:10.979897	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273950974","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available	400	0	reservation	available	Get a reservation by id	3
43	2025-05-26 17:39:11.528408	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273951523","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available	400	0	reservation	available	Get a reservation by id	3
44	2025-05-26 17:39:11.837324	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273951833","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available	400	0	reservation	available	Get a reservation by id	3
45	2025-05-26 17:39:50.237262	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Validation failed (numeric string is expected)"}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748273990215","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available	400	1	reservation	available	Get a reservation by id	3
46	2025-05-26 17:40:09.079296	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[]}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748274009044","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available	200	11	reservation	\N	Get available reservations	3
47	2025-05-26 17:41:32.508523	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":{"response":"INVALID_DTO","status":400,"message":"Error on submitted data","name":"InvalidDtoException","code":"INVALID_DTO","_details":{"errors":[{"field":"seats","messages":["seats must not be less than 1","seats must be a number conforming to the specified constraints"]},{"field":"date","messages":["date must be a valid ISO 8601 date string"]}]}}}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748274092487","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available	400	2	reservation	\N	Get available reservations	3
48	2025-05-26 17:41:44.531716	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":{"response":"INVALID_DTO","status":400,"message":"Error on submitted data","name":"InvalidDtoException","code":"INVALID_DTO","_details":{"errors":[{"field":"seats","messages":["seats must not be less than 1","seats must be a number conforming to the specified constraints"],"value":"4"}]}}}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748274104518","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	\N	Get available reservations	3
49	2025-05-26 17:41:57.196676	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":{"response":"INVALID_DTO","status":400,"message":"Error on submitted data","name":"InvalidDtoException","code":"INVALID_DTO","_details":{"errors":[{"field":"seats","messages":["seats must not be less than 1","seats must be a number conforming to the specified constraints"],"value":"4"}]}}}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748274117178","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	400	1	reservation	\N	Get available reservations	3
50	2025-05-26 17:42:53.105694	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[]}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748274173075","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	200	12	reservation	\N	Get available reservations	3
51	2025-05-26 17:44:17.586329	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[]}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748274257555","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-26	200	6	reservation	\N	Get available reservations	3
52	2025-05-26 17:44:20.616391	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[]}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MTE4MywiZXhwIjoxNzQ4MzU3NTgzfQ.TTwUBIK_1IvI2GvjXERG6rT1ZqoEEGPDU6bixIxs3gw","request-start-time":"1748274260609","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-27	200	1	reservation	\N	Get available reservations	3
53	2025-05-26 17:50:40.867984	\N	{"capacity":10,"tableNumber":"1"}	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":{"capacity":10,"tableNumber":"1","id":1}}	::1	{"accept":"application/json, text/plain, */*","content-type":"application/json","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748274640855","user-agent":"axios/1.7.2","content-length":"33","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	POST	/api/v1/reservations/tables	201	7	reservation	\N	Create a new table	1
54	2025-05-26 17:50:47.736744	\N	{"capacity":4,"tableNumber":"2"}	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":{"capacity":4,"tableNumber":"2","id":2}}	::1	{"accept":"application/json, text/plain, */*","content-type":"application/json","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748274647731","user-agent":"axios/1.7.2","content-length":"32","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	POST	/api/v1/reservations/tables	201	2	reservation	\N	Create a new table	1
55	2025-05-26 17:50:51.46897	\N	{"capacity":4,"tableNumber":"3"}	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":{"capacity":4,"tableNumber":"3","id":3}}	::1	{"accept":"application/json, text/plain, */*","content-type":"application/json","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748274651462","user-agent":"axios/1.7.2","content-length":"32","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	POST	/api/v1/reservations/tables	201	2	reservation	\N	Create a new table	1
56	2025-05-26 17:50:56.645975	\N	{"capacity":5,"tableNumber":"4"}	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":{"capacity":5,"tableNumber":"4","id":4}}	::1	{"accept":"application/json, text/plain, */*","content-type":"application/json","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748274656640","user-agent":"axios/1.7.2","content-length":"32","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	POST	/api/v1/reservations/tables	201	1	reservation	\N	Create a new table	1
57	2025-05-26 17:51:01.886109	\N	{"capacity":2,"tableNumber":"6"}	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":{"capacity":2,"tableNumber":"6","id":5}}	::1	{"accept":"application/json, text/plain, */*","content-type":"application/json","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748274661877","user-agent":"axios/1.7.2","content-length":"32","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	POST	/api/v1/reservations/tables	201	3	reservation	\N	Create a new table	1
58	2025-05-26 17:51:05.485954	\N	{"capacity":2,"tableNumber":"7"}	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":{"capacity":2,"tableNumber":"7","id":6}}	::1	{"accept":"application/json, text/plain, */*","content-type":"application/json","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748274665480","user-agent":"axios/1.7.2","content-length":"32","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	POST	/api/v1/reservations/tables	201	2	reservation	\N	Create a new table	1
59	2025-05-26 17:51:10.030994	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":4},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T14:00:00.000Z","availableSeats":4}]}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748274670022","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-27	200	3	reservation	\N	Get available reservations	1
60	2025-05-26 17:53:49.804706	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":4},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":4}]}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748274829777","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-27	200	8	reservation	\N	Get available reservations	1
61	2025-05-26 17:56:56.037432	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":4,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":4,"table":{"id":1,"capacity":10,"tableNumber":"1"}}]}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748275016011","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-27	200	9	reservation	\N	Get available reservations	1
62	2025-05-26 17:57:30.304522	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":4,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":4,"table":{"id":1,"capacity":10,"tableNumber":"1"}}]}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748275050279","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-27	200	10	reservation	\N	Get available reservations	1
63	2025-05-26 17:58:40.225513	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"Property \\"table\\" was not found in \\"TimeSlot\\". Make sure your query is correct."}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748275120161","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-27	200	5	reservation	\N	Get available reservations	1
64	2025-05-26 17:59:26.80618	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":4,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":4,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":4,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":4,"table":{"id":4,"capacity":5,"tableNumber":"4"}}]}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748275166766","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-27	200	23	reservation	\N	Get available reservations	1
65	2025-05-26 18:00:33.289548	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":{"response":"INVALID_DTO","status":400,"message":"Error on submitted data","name":"InvalidDtoException","code":"INVALID_DTO","_details":{"errors":[{"field":"seats","messages":["seats must not be less than 1","seats must be a number conforming to the specified constraints"],"value":"4"}]}}}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748275233260","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-27	400	2	reservation	\N	Get available reservations	1
66	2025-05-26 18:02:10.06288	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}}]}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748275330029","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-27	200	10	reservation	\N	Get available reservations	1
67	2025-05-26 18:02:17.445955	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}}]}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748275337421","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?date=2024-03-27	200	19	reservation	\N	Get available reservations	1
68	2025-05-26 18:02:24.2432	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2024-03-27T11:00:00.000Z","end":"2024-03-27T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2024-03-27T12:00:00.000Z","end":"2024-03-27T13:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}}]}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748275344233","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/available?seats=4&date=2024-03-27	200	3	reservation	\N	Get available reservations	1
69	2025-05-26 18:15:21.337504	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json"}	GET	/api/v1/reservations/available?date=2025-05-26	200	12	reservation	\N	Get available reservations	3
70	2025-05-26 18:15:30.41857	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json"}	GET	/api/v1/reservations/available?date=2025-05-26&seats=4	200	5	reservation	\N	Get available reservations	3
71	2025-05-26 18:19:04.641288	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json"}	GET	/api/v1/reservations/available?date=2025-05-26	200	11	reservation	\N	Get available reservations	3
72	2025-05-26 18:19:12.089205	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json"}	GET	/api/v1/reservations/available?date=2025-05-26&seats=2	200	4	reservation	\N	Get available reservations	3
73	2025-05-26 18:22:24.91055	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json"}	GET	/api/v1/reservations/available?date=2025-05-26	200	13	reservation	\N	Get available reservations	3
74	2025-05-26 18:29:09.758627	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json"}	GET	/api/v1/reservations/available?date=2025-05-26	200	17	reservation	\N	Get available reservations	3
75	2025-05-26 18:29:17.880664	\N	{"tableId":1,"startTime":"2025-05-26T10:00:00.000Z","numberOfGuests":1}	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"null value in column \\"name\\" of relation \\"reservation\\" violates not-null constraint"}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","content-length":"71","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json; charset=utf-8"}	POST	/api/v1/reservations/with-time	201	8	reservation	\N	La ressource reservation a été créée	3
76	2025-05-26 18:31:53.723106	\N	{"tableId":1,"startTime":"2025-05-26T10:00:00.000Z","numberOfGuests":1}	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"null value in column \\"reservation_date\\" of relation \\"reservation\\" violates not-null constraint"}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","content-length":"71","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json; charset=utf-8"}	POST	/api/v1/reservations/with-time	201	20	reservation	\N	La ressource reservation a été créée	3
77	2025-05-26 18:32:26.370535	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json"}	GET	/api/v1/reservations/available?date=2025-05-26&seats=4	200	6	reservation	\N	Get available reservations	3
78	2025-05-26 18:32:27.725245	\N	{"tableId":2,"startTime":"2025-05-26T10:00:00.000Z","numberOfGuests":4}	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":"null value in column \\"reservation_date\\" of relation \\"reservation\\" violates not-null constraint"}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","content-length":"71","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json; charset=utf-8"}	POST	/api/v1/reservations/with-time	201	7	reservation	\N	La ressource reservation a été créée	3
79	2025-05-26 18:33:27.997629	\N	{"tableId":2,"startTime":"2025-05-26T10:00:00.000Z","numberOfGuests":4}	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":{"numberOfGuests":4,"reservationDate":"2025-05-26T10:00:00.000Z","user":{"id":3,"createdAt":"2025-05-26T14:41:18.378Z","updatedAt":"2025-05-26T14:41:18.378Z","deletedAt":null,"firstName":"Loan","lastName":"CB","email":"loan@cb.fr","role":{"id":3,"createdAt":"2025-05-26T10:02:17.931Z","updatedAt":"2025-05-26T10:02:17.931Z","name":"Client","type":"CUSTOMER","description":"Compte en lecture seule"}},"table":{"id":2,"capacity":4,"tableNumber":"2"},"timeSlot":{"id":4,"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4},"id":4,"createdAt":"2025-05-26T16:33:27.991Z","updatedAt":"2025-05-26T16:33:27.991Z","status":"PENDING"}}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","content-length":"71","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json; charset=utf-8"}	POST	/api/v1/reservations/with-time	201	14	reservation	\N	La ressource reservation a été créée	3
80	2025-05-26 18:33:30.246935	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json"}	GET	/api/v1/reservations/available?date=2025-05-26	200	12	reservation	\N	Get available reservations	3
81	2025-05-26 18:37:25.475954	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json"}	GET	/api/v1/reservations/available?date=2025-05-26	200	20	reservation	\N	Get available reservations	3
82	2025-05-26 18:38:08.522008	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json"}	GET	/api/v1/reservations/available?date=2025-05-26	200	17	reservation	\N	Get available reservations	3
83	2025-05-26 18:43:52.458292	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"id":4,"createdAt":"2025-05-26T16:33:27.991Z","updatedAt":"2025-05-26T16:33:27.991Z","numberOfGuests":4,"reservationDate":"2025-05-26T10:00:00.000Z","status":"PENDING","user":{"id":3,"createdAt":"2025-05-26T14:41:18.378Z","updatedAt":"2025-05-26T14:41:18.378Z","deletedAt":null,"firstName":"Loan","lastName":"CB","email":"loan@cb.fr"},"table":{"id":2,"capacity":4,"tableNumber":"2"},"timeSlot":{"id":4,"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json"}	GET	/api/v1/reservations/my-reservations	200	7	reservation	\N	Get user reservations	3
84	2025-05-26 18:46:38.580136	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[]}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc0NjM2LCJleHAiOjE3NDgzNjEwMzZ9.vK-vGDSKg5oLJ4n9jzp5Tw7MZatli_ayNhoRJFFSx1o","request-start-time":"1748277998555","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/my-reservations	200	4	reservation	\N	Get user reservations	1
85	2025-05-26 18:46:56.061783	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"id":4,"createdAt":"2025-05-26T16:33:27.991Z","updatedAt":"2025-05-26T16:33:27.991Z","numberOfGuests":4,"reservationDate":"2025-05-26T10:00:00.000Z","status":"PENDING","user":{"id":3,"createdAt":"2025-05-26T14:41:18.378Z","updatedAt":"2025-05-26T14:41:18.378Z","deletedAt":null,"firstName":"Loan","lastName":"CB","email":"loan@cb.fr"},"table":{"id":2,"capacity":4,"tableNumber":"2"},"timeSlot":{"id":4,"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4}}]}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3ODAxNCwiZXhwIjoxNzQ4MzY0NDE0fQ.KVpIolXz1k38DTsQ0KDdz0JFYTmtKeM1dG5bbBQoGZE","request-start-time":"1748278016051","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/my-reservations	200	3	reservation	\N	Get user reservations	3
86	2025-05-26 18:49:46.936284	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"id":4,"createdAt":"2025-05-26T16:33:27.991Z","updatedAt":"2025-05-26T16:33:27.991Z","numberOfGuests":4,"reservationDate":"2025-05-26T10:00:00.000Z","status":"PENDING","user":{"id":3,"createdAt":"2025-05-26T14:41:18.378Z","updatedAt":"2025-05-26T14:41:18.378Z","deletedAt":null,"firstName":"Loan","lastName":"CB","email":"loan@cb.fr"},"table":{"id":2,"capacity":4,"tableNumber":"2"},"timeSlot":{"id":4,"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json"}	GET	/api/v1/reservations/my-reservations	200	4	reservation	\N	Get user reservations	3
87	2025-05-26 18:55:56.119584	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"id":4,"createdAt":"2025-05-26T16:33:27.991Z","updatedAt":"2025-05-26T16:33:27.991Z","numberOfGuests":4,"reservationDate":"2025-05-26T10:00:00.000Z","status":"PENDING","user":{"id":3,"createdAt":"2025-05-26T14:41:18.378Z","updatedAt":"2025-05-26T14:41:18.378Z","deletedAt":null,"firstName":"Loan","lastName":"CB","email":"loan@cb.fr"},"table":{"id":2,"capacity":4,"tableNumber":"2"},"timeSlot":{"id":4,"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json"}	GET	/api/v1/reservations/my-reservations	200	3	reservation	\N	Get user reservations	3
88	2025-05-26 18:58:39.632153	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3MDU5NywiZXhwIjoxNzQ4MzU2OTk3fQ.yEtlzSnWQcn2NlHZHXJmR4FyQ4BnguI_AtVpTUiwS2Q","content-type":"application/json"}	GET	/api/v1/reservations/available?date=2025-05-26	200	36	reservation	\N	Get available reservations	3
89	2025-05-26 19:00:01.284016	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc4ODAxLCJleHAiOjE3NDgzNjUyMDF9.-cGkf-bru-mFNbp7SyWb2sPgdsJZAP25dplbg02YbSk","content-type":"application/json"}	GET	/api/v1/reservations/my-reservations	200	3	reservation	\N	Get user reservations	1
90	2025-05-26 19:04:31.346835	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3OTA2MywiZXhwIjoxNzQ4MzY1NDYzfQ.cdVxr6T5BWedpz4TmC-GHyihvhohE15zOisNbY5cvBI","content-type":"application/json"}	GET	/api/v1/reservations/available?date=2025-05-26	200	21	reservation	\N	Get available reservations	3
91	2025-05-26 19:05:06.231836	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3OTA2MywiZXhwIjoxNzQ4MzY1NDYzfQ.cdVxr6T5BWedpz4TmC-GHyihvhohE15zOisNbY5cvBI","content-type":"application/json"}	GET	/api/v1/reservations/available?date=2025-05-26	200	10	reservation	\N	Get available reservations	3
92	2025-05-26 19:05:10.18393	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":2,"capacity":4,"tableNumber":"2"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3OTA2MywiZXhwIjoxNzQ4MzY1NDYzfQ.cdVxr6T5BWedpz4TmC-GHyihvhohE15zOisNbY5cvBI","content-type":"application/json"}	GET	/api/v1/reservations/available?date=2025-05-26&seats=4	200	6	reservation	\N	Get available reservations	3
93	2025-05-26 19:05:14.733327	\N	{"tableId":2,"startTime":"2025-05-26T11:00:00.000Z","numberOfGuests":4}	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":{"numberOfGuests":4,"reservationDate":"2025-05-26T11:00:00.000Z","user":{"id":3,"createdAt":"2025-05-26T14:41:18.378Z","updatedAt":"2025-05-26T14:41:18.378Z","deletedAt":null,"firstName":"Loan","lastName":"CB","email":"loan@cb.fr","role":{"id":3,"createdAt":"2025-05-26T10:02:17.931Z","updatedAt":"2025-05-26T10:02:17.931Z","name":"Client","type":"CUSTOMER","description":"Compte en lecture seule"}},"table":{"id":2,"capacity":4,"tableNumber":"2"},"timeSlot":{"id":5,"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4},"id":5,"createdAt":"2025-05-26T17:05:14.727Z","updatedAt":"2025-05-26T17:05:14.727Z","status":"PENDING"}}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","content-length":"71","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3OTA2MywiZXhwIjoxNzQ4MzY1NDYzfQ.cdVxr6T5BWedpz4TmC-GHyihvhohE15zOisNbY5cvBI","content-type":"application/json; charset=utf-8"}	POST	/api/v1/reservations/with-time	201	10	reservation	\N	La ressource reservation a été créée	3
94	2025-05-26 19:11:04.155782	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc5MTQ2LCJleHAiOjE3NDgzNjU1NDZ9.uwoVF2WcPuFEXZn_tvWgP_TfKGiQYsFsQ5otDxpaa1c","content-type":"application/json"}	GET	/api/v1/reservations/my-reservations	200	5	reservation	\N	Get user reservations	1
95	2025-05-26 19:11:32.170333	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"id":5,"createdAt":"2025-05-26T17:05:14.727Z","updatedAt":"2025-05-26T17:05:14.727Z","numberOfGuests":4,"reservationDate":"2025-05-26T11:00:00.000Z","status":"PENDING","user":{"id":3,"createdAt":"2025-05-26T14:41:18.378Z","updatedAt":"2025-05-26T14:41:18.378Z","deletedAt":null,"firstName":"Loan","lastName":"CB","email":"loan@cb.fr"},"table":{"id":2,"capacity":4,"tableNumber":"2"},"timeSlot":{"id":5,"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4}},{"id":4,"createdAt":"2025-05-26T16:33:27.991Z","updatedAt":"2025-05-26T16:33:27.991Z","numberOfGuests":4,"reservationDate":"2025-05-26T10:00:00.000Z","status":"CONFIRMED","user":{"id":3,"createdAt":"2025-05-26T14:41:18.378Z","updatedAt":"2025-05-26T14:41:18.378Z","deletedAt":null,"firstName":"Loan","lastName":"CB","email":"loan@cb.fr"},"table":{"id":2,"capacity":4,"tableNumber":"2"},"timeSlot":{"id":4,"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3OTQ5MiwiZXhwIjoxNzQ4MzY1ODkyfQ.XK8AZabEpf9RysvP5Q4pe8Ux0SGQFGzCtWYnI-ZWHU8","content-type":"application/json"}	GET	/api/v1/reservations/my-reservations	200	2	reservation	\N	Get user reservations	3
96	2025-05-26 19:17:26.846573	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"id":4,"createdAt":"2025-05-26T16:33:27.991Z","updatedAt":"2025-05-26T16:33:27.991Z","numberOfGuests":4,"reservationDate":"2025-05-26T10:00:00.000Z","status":"CONFIRMED","user":{"id":3,"createdAt":"2025-05-26T14:41:18.378Z","updatedAt":"2025-05-26T14:41:18.378Z","deletedAt":null,"firstName":"Loan","lastName":"CB","email":"loan@cb.fr"},"table":{"id":2,"capacity":4,"tableNumber":"2"},"timeSlot":{"id":4,"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4}},{"id":5,"createdAt":"2025-05-26T17:05:14.727Z","updatedAt":"2025-05-26T17:05:14.727Z","numberOfGuests":4,"reservationDate":"2025-05-26T11:00:00.000Z","status":"PENDING","user":{"id":3,"createdAt":"2025-05-26T14:41:18.378Z","updatedAt":"2025-05-26T14:41:18.378Z","deletedAt":null,"firstName":"Loan","lastName":"CB","email":"loan@cb.fr"},"table":{"id":2,"capacity":4,"tableNumber":"2"},"timeSlot":{"id":5,"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4}}]}	::1	{"accept":"application/json, text/plain, */*","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc5ODE2LCJleHAiOjE3NDgzNjYyMTZ9.5j0cWLaR6GLbiziNeRznyGb6o1RZ8b8eUKvQjeY3cIo","request-start-time":"1748279846826","user-agent":"axios/1.7.2","accept-encoding":"gzip, compress, deflate, br","host":"localhost:3010","connection":"keep-alive"}	GET	/api/v1/reservations/today	200	5	reservation	\N	Get today reservations	1
97	2025-05-26 19:18:40.928574	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"id":5,"createdAt":"2025-05-26T17:05:14.727Z","updatedAt":"2025-05-26T17:05:14.727Z","numberOfGuests":4,"reservationDate":"2025-05-26T11:00:00.000Z","status":"PENDING","user":{"id":3,"createdAt":"2025-05-26T14:41:18.378Z","updatedAt":"2025-05-26T14:41:18.378Z","deletedAt":null,"firstName":"Loan","lastName":"CB","email":"loan@cb.fr"},"table":{"id":2,"capacity":4,"tableNumber":"2"},"timeSlot":{"id":5,"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4}},{"id":4,"createdAt":"2025-05-26T16:33:27.991Z","updatedAt":"2025-05-26T16:33:27.991Z","numberOfGuests":4,"reservationDate":"2025-05-26T10:00:00.000Z","status":"CONFIRMED","user":{"id":3,"createdAt":"2025-05-26T14:41:18.378Z","updatedAt":"2025-05-26T14:41:18.378Z","deletedAt":null,"firstName":"Loan","lastName":"CB","email":"loan@cb.fr"},"table":{"id":2,"capacity":4,"tableNumber":"2"},"timeSlot":{"id":4,"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJuYW1lIjoibG9hbkBjYi5mciIsImlhdCI6MTc0ODI3OTQ5MiwiZXhwIjoxNzQ4MzY1ODkyfQ.XK8AZabEpf9RysvP5Q4pe8Ux0SGQFGzCtWYnI-ZWHU8","content-type":"application/json"}	GET	/api/v1/reservations/my-reservations	200	3	reservation	\N	Get user reservations	3
98	2025-05-26 19:19:19.806491	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc5OTU5LCJleHAiOjE3NDgzNjYzNTl9.1Ja9P1szEF0F3NjNWi7xUpluY_1Z_lg3bGO_qLlxNPo","content-type":"application/json"}	GET	/api/v1/reservations/my-reservations	200	4	reservation	\N	Get user reservations	1
99	2025-05-26 19:19:35.415008	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc5OTU5LCJleHAiOjE3NDgzNjYzNTl9.1Ja9P1szEF0F3NjNWi7xUpluY_1Z_lg3bGO_qLlxNPo","content-type":"application/json"}	GET	/api/v1/reservations/my-reservations	200	2	reservation	\N	Get user reservations	1
100	2025-05-26 19:19:42.62733	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":10,"table":{"id":1,"capacity":10,"tableNumber":"1"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4,"table":{"id":3,"capacity":4,"tableNumber":"3"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":5,"table":{"id":4,"capacity":5,"tableNumber":"4"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":5,"capacity":2,"tableNumber":"6"}},{"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":2,"table":{"id":6,"capacity":2,"tableNumber":"7"}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc5OTU5LCJleHAiOjE3NDgzNjYzNTl9.1Ja9P1szEF0F3NjNWi7xUpluY_1Z_lg3bGO_qLlxNPo","content-type":"application/json"}	GET	/api/v1/reservations/available?date=2025-05-26	200	10	reservation	\N	Get available reservations	1
101	2025-05-26 19:21:01.682786	\N	\N	{"headers":{"x-powered-by":"Express","vary":"Origin","access-control-allow-credentials":"true"},"body":[{"id":4,"createdAt":"2025-05-26T16:33:27.991Z","updatedAt":"2025-05-26T16:33:27.991Z","numberOfGuests":4,"reservationDate":"2025-05-26T10:00:00.000Z","status":"CONFIRMED","user":{"id":3,"createdAt":"2025-05-26T14:41:18.378Z","updatedAt":"2025-05-26T14:41:18.378Z","deletedAt":null,"firstName":"Loan","lastName":"CB","email":"loan@cb.fr"},"table":{"id":2,"capacity":4,"tableNumber":"2"},"timeSlot":{"id":4,"start":"2025-05-26T10:00:00.000Z","end":"2025-05-26T11:00:00.000Z","availableSeats":4}},{"id":5,"createdAt":"2025-05-26T17:05:14.727Z","updatedAt":"2025-05-26T17:05:14.727Z","numberOfGuests":4,"reservationDate":"2025-05-26T11:00:00.000Z","status":"PENDING","user":{"id":3,"createdAt":"2025-05-26T14:41:18.378Z","updatedAt":"2025-05-26T14:41:18.378Z","deletedAt":null,"firstName":"Loan","lastName":"CB","email":"loan@cb.fr"},"table":{"id":2,"capacity":4,"tableNumber":"2"},"timeSlot":{"id":5,"start":"2025-05-26T11:00:00.000Z","end":"2025-05-26T12:00:00.000Z","availableSeats":4}}]}	::ffff:127.0.0.1	{"user-agent":"Dart/3.7 (dart:io)","accept":"application/json","accept-encoding":"gzip","host":"10.0.2.2:3010","authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW5AYWRtaW4uY29tIiwiaWF0IjoxNzQ4Mjc5OTU5LCJleHAiOjE3NDgzNjYzNTl9.1Ja9P1szEF0F3NjNWi7xUpluY_1Z_lg3bGO_qLlxNPo","content-type":"application/json"}	GET	/api/v1/reservations/today	200	5	reservation	\N	Get today reservations	1
\.


--
-- Data for Name: menu_item; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.menu_item (id, created_at, updated_at, name, description, price, image_url, category, is_available) FROM stdin;
1	2025-05-26 18:57:36.07471	2025-05-26 18:57:36.07471	Spaghetti Carbonara	Pâtes traditionnelles italiennes aux œufs, fromage et pancetta	1450	https://images.unsplash.com/photo-1551892589-865f69869476?w=500	Plats principaux	t
2	2025-05-26 18:57:36.07471	2025-05-26 18:57:36.07471	Pizza Margherita	Pizza classique avec tomate, mozzarella et basilic frais	1250	https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=500	Plats principaux	t
3	2025-05-26 18:57:36.07471	2025-05-26 18:57:36.07471	Salade César	Salade romaine, croûtons, parmesan et sauce César	950	https://images.unsplash.com/photo-1551248429-40975aa4de74?w=500	Entrées	t
4	2025-05-26 18:57:36.07471	2025-05-26 18:57:36.07471	Soupe de tomates	Soupe de tomates fraîches avec basilic et crème	650	https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=500	Entrées	t
5	2025-05-26 18:57:36.07471	2025-05-26 18:57:36.07471	Risotto aux champignons	Risotto crémeux aux champignons porcini	1350	https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=500	Plats principaux	t
6	2025-05-26 18:57:36.07471	2025-05-26 18:57:36.07471	Tiramisu	Dessert italien traditionnel au café et mascarpone	750	https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=500	Desserts	t
7	2025-05-26 18:57:36.07471	2025-05-26 18:57:36.07471	Panna Cotta	Dessert italien à la vanille avec coulis de fruits rouges	650	https://images.unsplash.com/photo-1488477181946-6428a0291777?w=500	Desserts	t
8	2025-05-26 18:57:36.07471	2025-05-26 18:57:36.07471	Bruschetta	Pain grillé avec tomates, ail et basilic	550	https://images.unsplash.com/photo-1572441713132-51c75654db73?w=500	Entrées	t
9	2025-05-26 18:57:36.07471	2025-05-26 18:57:36.07471	Lasagnes	Lasagnes traditionnelles à la bolognaise	1550	https://images.unsplash.com/photo-1574894709920-11b28e7367e3?w=500	Plats principaux	t
10	2025-05-26 18:57:36.07471	2025-05-26 18:57:36.07471	Gelato Vanille	Glace artisanale à la vanille	450	https://images.unsplash.com/photo-1567206563064-6f60f40a2b57?w=500	Desserts	t
11	2025-05-26 18:57:36.07471	2025-05-26 18:57:36.07471	Carpaccio de bœuf	Fines lamelles de bœuf avec roquette et parmesan	1100	https://images.unsplash.com/photo-1544025162-d76694265947?w=500	Entrées	t
12	2025-05-26 18:57:36.07471	2025-05-26 18:57:36.07471	Escalope Milanaise	Escalope de veau panée à la milanaise avec spaghetti	1650	https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500	Plats principaux	t
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.migrations (id, "timestamp", name) FROM stdin;
2	1748253160575	UserModule1748253160575
3	1748264527210	ReservationModule1748264527210
4	1748277080000	UpdateUser1748277080000
5	1748270000000	CreateMenuItemTable1748270000000
6	1748270002000	SeedCleanMenuItems1748270002000
\.


--
-- Data for Name: reservation; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.reservation (id, created_at, updated_at, number_of_guests, reservation_date, status, user_id, table_id, time_slot_id) FROM stdin;
5	2025-05-26 19:05:14.727993	2025-05-26 19:05:14.727993	4	2025-05-26 13:00:00+02	PENDING	3	2	5
4	2025-05-26 18:33:27.991913	2025-05-26 18:33:27.991913	4	2025-05-26 12:00:00+02	CONFIRMED	3	2	4
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.role (id, created_at, updated_at, name, type, description) FROM stdin;
1	2025-05-26 12:02:17.931434	2025-05-26 12:02:17.931434	Administrateur	ADMINISTRATOR	Administrateur possédant un accès total à l'application
2	2025-05-26 12:02:17.931434	2025-05-26 12:02:17.931434	Hôte	HOST	Compte d'un hôte
3	2025-05-26 12:02:17.931434	2025-05-26 12:02:17.931434	Client	CUSTOMER	Compte en lecture seule
\.


--
-- Data for Name: table; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public."table" (id, capacity, table_number) FROM stdin;
1	10	1
2	4	2
3	4	3
4	5	4
5	2	6
6	2	7
\.


--
-- Data for Name: time_slot; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.time_slot (id, start, "end", available_seats) FROM stdin;
1	2025-05-26 12:00:00+02	2025-05-26 13:00:00+02	10
2	2025-05-26 12:00:00+02	2025-05-26 13:00:00+02	10
3	2025-05-26 12:00:00+02	2025-05-26 13:00:00+02	4
4	2025-05-26 12:00:00+02	2025-05-26 13:00:00+02	4
5	2025-05-26 13:00:00+02	2025-05-26 14:00:00+02	4
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public."user" (id, created_at, updated_at, deleted_at, first_name, last_name, email, password, role_id) FROM stdin;
2	2025-05-26 12:12:36.791532	2025-05-26 12:12:36.791532	\N	John	Doe	john-doe@example.com	348143c2efa30f63ef8396a85cf13240:6c69579bda3a081900a501031e4b756af6a2b1633b8baefff29f45a68bbb500f883988973675b60f275adca2011b1adc4887427bedec77713f38b2152ca0a660	3
3	2025-05-26 16:41:18.378252	2025-05-26 16:41:18.378252	\N	Loan	CB	loan@cb.fr	b9436a5d96410abc8492716093e52fc2:07136cb0ae0c935a1e30b47d869a237257e0424829f626c42bd0997e9ada961e6013d51b5182ade4307faa2a6c393da68c09e2120217746804bbe52c7f6ca8bb	3
1	2025-05-26 12:02:31.318052	2025-05-26 12:02:31.318052	\N	admin	Admin	admin@admin.com	b9436a5d96410abc8492716093e52fc2:07136cb0ae0c935a1e30b47d869a237257e0424829f626c42bd0997e9ada961e6013d51b5182ade4307faa2a6c393da68c09e2120217746804bbe52c7f6ca8bb	2
\.


--
-- Name: activity_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.activity_log_id_seq', 101, true);


--
-- Name: menu_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.menu_item_id_seq', 12, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.migrations_id_seq', 6, true);


--
-- Name: reservation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.reservation_id_seq', 5, true);


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.role_id_seq', 3, true);


--
-- Name: table_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.table_id_seq', 6, true);


--
-- Name: time_slot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.time_slot_id_seq', 5, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.user_id_seq', 3, true);


--
-- Name: time_slot PK_03f782f8c4af029253f6ad5bacf; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.time_slot
    ADD CONSTRAINT "PK_03f782f8c4af029253f6ad5bacf" PRIMARY KEY (id);


--
-- Name: activity_log PK_067d761e2956b77b14e534fd6f1; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.activity_log
    ADD CONSTRAINT "PK_067d761e2956b77b14e534fd6f1" PRIMARY KEY (id);


--
-- Name: table PK_28914b55c485fc2d7a101b1b2a4; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public."table"
    ADD CONSTRAINT "PK_28914b55c485fc2d7a101b1b2a4" PRIMARY KEY (id);


--
-- Name: reservation PK_48b1f9922368359ab88e8bfa525; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT "PK_48b1f9922368359ab88e8bfa525" PRIMARY KEY (id);


--
-- Name: migrations PK_8c82d7f526340ab734260ea46be; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);


--
-- Name: role PK_b36bcfe02fc8de3c57a8b2391c2; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "PK_b36bcfe02fc8de3c57a8b2391c2" PRIMARY KEY (id);


--
-- Name: menu_item PK_c3ac1c33365213a052a0bd0df5b; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.menu_item
    ADD CONSTRAINT "PK_c3ac1c33365213a052a0bd0df5b" PRIMARY KEY (id);


--
-- Name: user PK_cace4a159ff9f2512dd42373760; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "PK_cace4a159ff9f2512dd42373760" PRIMARY KEY (id);


--
-- Name: reservation REL_27946d68ea9576710cdb689669; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT "REL_27946d68ea9576710cdb689669" UNIQUE (time_slot_id);


--
-- Name: user UQ_e12875dfb3b1d92d7d7c5377e22; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "UQ_e12875dfb3b1d92d7d7c5377e22" UNIQUE (email);


--
-- Name: reservation FK_27946d68ea9576710cdb689669c; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT "FK_27946d68ea9576710cdb689669c" FOREIGN KEY (time_slot_id) REFERENCES public.time_slot(id);


--
-- Name: activity_log FK_81615294532ca4b6c70abd1b2e6; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.activity_log
    ADD CONSTRAINT "FK_81615294532ca4b6c70abd1b2e6" FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: reservation FK_d3321fc44e70fd7e803491513d6; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT "FK_d3321fc44e70fd7e803491513d6" FOREIGN KEY (table_id) REFERENCES public."table"(id);


--
-- Name: reservation FK_e219b0a4ff01b85072bfadf3fd7; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT "FK_e219b0a4ff01b85072bfadf3fd7" FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user FK_fb2e442d14add3cefbdf33c4561; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "FK_fb2e442d14add3cefbdf33c4561" FOREIGN KEY (role_id) REFERENCES public.role(id);


--
-- PostgreSQL database dump complete
--

