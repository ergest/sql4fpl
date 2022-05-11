--
-- PostgreSQL database dump
--

-- Dumped from database version 13.6
-- Dumped by pg_dump version 13.6

-- Started on 2022-03-01 20:57:12

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

DROP DATABASE fantasypl;
--
-- TOC entry 3063 (class 1262 OID 16395)
-- Name: fantasypl; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE fantasypl WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United States.1252';


ALTER DATABASE fantasypl OWNER TO postgres;

\connect fantasypl

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 200 (class 1259 OID 16506)
-- Name: player_positions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.player_positions (
    id integer,
    singular_name_short character(3),
    squad_select integer,
    squad_min_play integer,
    squad_max_play integer,
    ui_shirt_specific integer
);


ALTER TABLE public.player_positions OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 25878)
-- Name: v_playerhistory2016; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_playerhistory2016 AS
 SELECT ph.element AS player_id,
    p.web_name,
    (((p.first_name)::text || '_'::text) || (p.second_name)::text) AS player_name,
    pos.singular_name_short AS player_position,
    ph.round AS gameweek,
    ((ph.value)::numeric / (10)::numeric) AS value,
    (ph.influence)::numeric AS influence,
    (ph.creativity)::numeric AS creativity,
    (ph.threat)::numeric AS threat,
    (ph.ict_index)::numeric AS ict_index,
    (ph.minutes)::numeric AS minutes,
    (ph.total_points)::numeric AS total_points,
    (ph.bps)::numeric AS bonus_points_system,
    COALESCE(sum((ph.total_points)::numeric) OVER form, (0)::numeric) AS total_points_form,
    COALESCE(sum((ph.minutes)::numeric) OVER form, (0)::numeric) AS total_minutes_form,
    COALESCE(sum((ph.total_points)::numeric) OVER prev_form, (0)::numeric) AS total_points_prev_form,
    round((sum((ph.total_points)::numeric) OVER per_game / (ph.round)::numeric), 2) AS points_per_game,
    row_number() OVER (PARTITION BY ph.element ORDER BY ph.round DESC) AS row_id
   FROM ((public.player_history_2016 ph
     JOIN public.player_2016 p ON ((p.id = ph.element)))
     JOIN public.player_positions pos ON ((pos.id = p.element_type)))
  WHERE true
  WINDOW form AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN 3 PRECEDING AND CURRENT ROW), prev_form AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN 4 PRECEDING AND 1 PRECEDING), per_game AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW);


ALTER TABLE public.v_playerhistory2016 OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 25957)
-- Name: v_playerhistory2017; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_playerhistory2017 AS
 SELECT ph.element AS player_id,
    p.web_name,
    (((p.first_name)::text || '_'::text) || (p.second_name)::text) AS player_name,
    pos.singular_name_short AS player_position,
    ph.round AS gameweek,
    ((ph.value)::numeric / (10)::numeric) AS value,
    (ph.influence)::numeric AS influence,
    (ph.creativity)::numeric AS creativity,
    (ph.threat)::numeric AS threat,
    (ph.ict_index)::numeric AS ict_index,
    (ph.minutes)::numeric AS minutes,
    (ph.total_points)::numeric AS total_points,
    (ph.bps)::numeric AS bonus_points_system,
    COALESCE(sum((ph.total_points)::numeric) OVER form, (0)::numeric) AS total_points_form,
    COALESCE(sum((ph.minutes)::numeric) OVER form, (0)::numeric) AS total_minutes_form,
    COALESCE(sum((ph.total_points)::numeric) OVER prev_form, (0)::numeric) AS total_points_prev_form,
    round((sum((ph.total_points)::numeric) OVER per_game / (ph.round)::numeric), 2) AS points_per_game,
    row_number() OVER (PARTITION BY ph.element ORDER BY ph.round DESC) AS row_id
   FROM ((public.player_history_2017 ph
     JOIN public.player_2017 p ON ((p.id = ph.element)))
     JOIN public.player_positions pos ON ((pos.id = p.element_type)))
  WHERE true
  WINDOW form AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN 3 PRECEDING AND CURRENT ROW), prev_form AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN 4 PRECEDING AND 1 PRECEDING), per_game AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW);


ALTER TABLE public.v_playerhistory2017 OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 25962)
-- Name: v_playerhistory2018; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_playerhistory2018 AS
 SELECT ph.element AS player_id,
    p.web_name,
    (((p.first_name)::text || '_'::text) || (p.second_name)::text) AS player_name,
    pos.singular_name_short AS player_position,
    ph.round AS gameweek,
    ((ph.value)::numeric / (10)::numeric) AS value,
    (ph.influence)::numeric AS influence,
    (ph.creativity)::numeric AS creativity,
    (ph.threat)::numeric AS threat,
    (ph.ict_index)::numeric AS ict_index,
    (ph.minutes)::numeric AS minutes,
    (ph.total_points)::numeric AS total_points,
    (ph.bps)::numeric AS bonus_points_system,
    COALESCE(sum((ph.total_points)::numeric) OVER form, (0)::numeric) AS total_points_form,
    COALESCE(sum((ph.minutes)::numeric) OVER form, (0)::numeric) AS total_minutes_form,
    COALESCE(sum((ph.total_points)::numeric) OVER prev_form, (0)::numeric) AS total_points_prev_form,
    round((sum((ph.total_points)::numeric) OVER per_game / (ph.round)::numeric), 2) AS points_per_game,
    row_number() OVER (PARTITION BY ph.element ORDER BY ph.round DESC) AS row_id
   FROM ((public.player_history_2018 ph
     JOIN public.player_2018 p ON ((p.id = ph.element)))
     JOIN public.player_positions pos ON ((pos.id = p.element_type)))
  WHERE true
  WINDOW form AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN 3 PRECEDING AND CURRENT ROW), prev_form AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN 4 PRECEDING AND 1 PRECEDING), per_game AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW);


ALTER TABLE public.v_playerhistory2018 OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 25967)
-- Name: v_playerhistory2019; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_playerhistory2019 AS
 SELECT ph.element AS player_id,
    p.web_name,
    (((p.first_name)::text || '_'::text) || (p.second_name)::text) AS player_name,
    pos.singular_name_short AS player_position,
    ph.round AS gameweek,
    ((ph.value)::numeric / (10)::numeric) AS value,
    (ph.influence)::numeric AS influence,
    (ph.creativity)::numeric AS creativity,
    (ph.threat)::numeric AS threat,
    (ph.ict_index)::numeric AS ict_index,
    (ph.minutes)::numeric AS minutes,
    (ph.total_points)::numeric AS total_points,
    (ph.bps)::numeric AS bonus_points_system,
    COALESCE(sum((ph.total_points)::numeric) OVER form, (0)::numeric) AS total_points_form,
    COALESCE(sum((ph.minutes)::numeric) OVER form, (0)::numeric) AS total_minutes_form,
    COALESCE(sum((ph.total_points)::numeric) OVER prev_form, (0)::numeric) AS total_points_prev_form,
    round((sum((ph.total_points)::numeric) OVER per_game / (ph.round)::numeric), 2) AS points_per_game,
    row_number() OVER (PARTITION BY ph.element ORDER BY ph.round DESC) AS row_id
   FROM ((public.player_history_2019 ph
     JOIN public.player_2019 p ON ((p.id = ph.element)))
     JOIN public.player_positions pos ON ((pos.id = p.element_type)))
  WHERE true
  WINDOW form AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN 3 PRECEDING AND CURRENT ROW), prev_form AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN 4 PRECEDING AND 1 PRECEDING), per_game AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW);


ALTER TABLE public.v_playerhistory2019 OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 25972)
-- Name: v_playerhistory2020; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_playerhistory2020 AS
 SELECT ph.element AS player_id,
    p.web_name,
    (((p.first_name)::text || '_'::text) || (p.second_name)::text) AS player_name,
    pos.singular_name_short AS player_position,
    ph.round AS gameweek,
    ((ph.value)::numeric / (10)::numeric) AS value,
    (ph.influence)::numeric AS influence,
    (ph.creativity)::numeric AS creativity,
    (ph.threat)::numeric AS threat,
    (ph.ict_index)::numeric AS ict_index,
    (ph.minutes)::numeric AS minutes,
    (ph.total_points)::numeric AS total_points,
    (ph.bps)::numeric AS bonus_points_system,
    (ph."xP")::numeric AS expected_points,
    COALESCE(sum((ph.total_points)::numeric) OVER form, (0)::numeric) AS total_points_form,
    COALESCE(sum((ph.minutes)::numeric) OVER form, (0)::numeric) AS total_minutes_form,
    COALESCE(sum((ph.total_points)::numeric) OVER prev_form, (0)::numeric) AS total_points_prev_form,
    round((sum((ph.total_points)::numeric) OVER per_game / (ph.round)::numeric), 2) AS points_per_game,
    row_number() OVER (PARTITION BY ph.element ORDER BY ph.round DESC) AS row_id
   FROM ((public.player_history_2020 ph
     JOIN public.player_2020 p ON ((p.id = ph.element)))
     JOIN public.player_positions pos ON ((pos.id = p.element_type)))
  WHERE true
  WINDOW form AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN 3 PRECEDING AND CURRENT ROW), prev_form AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN 4 PRECEDING AND 1 PRECEDING), per_game AS (PARTITION BY ph.element ORDER BY ph.round ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW);


ALTER TABLE public.v_playerhistory2020 OWNER TO postgres;

--
-- TOC entry 3057 (class 0 OID 16506)
-- Dependencies: 200
-- Data for Name: player_positions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.player_positions VALUES (1, 'GKP', 2, 1, 1, 1);
INSERT INTO public.player_positions VALUES (2, 'DEF', 5, 3, 5, 0);
INSERT INTO public.player_positions VALUES (3, 'MID', 5, 2, 5, 0);
INSERT INTO public.player_positions VALUES (4, 'FWD', 3, 1, 3, 0);


-- Completed on 2022-03-01 20:57:13

--
-- PostgreSQL database dump complete
--

