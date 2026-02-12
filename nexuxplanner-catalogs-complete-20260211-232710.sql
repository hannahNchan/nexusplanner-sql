--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.8

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
-- Data for Name: epic_phases; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

INSERT INTO public.epic_phases (id, name, color, "position") VALUES ('5070e09a-410a-4050-92ac-8adf3c2e867d', 'Backlog', '#647488', 1);
INSERT INTO public.epic_phases (id, name, color, "position") VALUES ('ed35caea-669a-4bba-a398-ca62d63ba75a', 'Planificación', '#3B82F6', 2);
INSERT INTO public.epic_phases (id, name, color, "position") VALUES ('86ae1558-d425-44f0-95c2-8a1043e602d5', 'En Desarrollo', '#F59E0B', 3);
INSERT INTO public.epic_phases (id, name, color, "position") VALUES ('9bf1af58-f1c7-4c82-b393-83c4e2fa372d', 'En Pruebas', '#8B5CF6', 4);
INSERT INTO public.epic_phases (id, name, color, "position") VALUES ('009157fa-87ed-4da2-9ed3-e7a059ee989b', 'Completado', '#10B981', 5);
INSERT INTO public.epic_phases (id, name, color, "position") VALUES ('cb1d48af-c2e1-4110-8267-c43aa25f4186', 'Cancelado', '#EF4444', 6);
INSERT INTO public.epic_phases (id, name, color, "position") VALUES ('49538d2b-b283-4f86-a957-e37ac0c08a71', 'QA Completado', '#647488', 6);


--
-- Data for Name: issue_types; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

INSERT INTO public.issue_types (id, name, icon, color, "position") VALUES ('b7abdd2d-199e-4d43-8634-0139459cb238', 'bloqueadores', 'edit', '#3B82F6', 0);
INSERT INTO public.issue_types (id, name, icon, color, "position") VALUES ('a8e014ac-5a37-40d8-8450-ad5aaef3747a', 'Task', 'random', '#4CAF50', 1);
INSERT INTO public.issue_types (id, name, icon, color, "position") VALUES ('2f57207d-0285-404f-8766-8af73ce6db72', 'Bug', 'bug', '#F44336', 2);
INSERT INTO public.issue_types (id, name, icon, color, "position") VALUES ('90223423-2e32-49c9-bd3b-05c4eaed8840', 'Story', 'book', '#2196F3', 3);
INSERT INTO public.issue_types (id, name, icon, color, "position") VALUES ('7758a129-a102-410d-afed-a54bbee2b270', 'Epic', 'bolt', '#9C27B0', 4);


--
-- Data for Name: point_systems; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

INSERT INTO public.point_systems (id, name, description, is_default) VALUES ('9d5aec3e-ce96-4613-a0f3-535241dcb434', 'Fibonacci', 'Fibonacci sequence', true);


--
-- Data for Name: point_values; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

INSERT INTO public.point_values (id, system_id, value, numeric_value, "position") VALUES ('f99022c7-138f-4b47-9f9b-afe7103b3f81', '9d5aec3e-ce96-4613-a0f3-535241dcb434', '1', 1, 1);
INSERT INTO public.point_values (id, system_id, value, numeric_value, "position") VALUES ('abfb93bc-2453-4b13-aa8c-e55a5590b760', '9d5aec3e-ce96-4613-a0f3-535241dcb434', '2', 2, 2);
INSERT INTO public.point_values (id, system_id, value, numeric_value, "position") VALUES ('67ed463d-8817-46a9-847f-28e71a52cd98', '9d5aec3e-ce96-4613-a0f3-535241dcb434', '3', 3, 3);
INSERT INTO public.point_values (id, system_id, value, numeric_value, "position") VALUES ('4bf6fabc-b37b-4b09-8ea0-685a6f74c40b', '9d5aec3e-ce96-4613-a0f3-535241dcb434', '5', 5, 4);
INSERT INTO public.point_values (id, system_id, value, numeric_value, "position") VALUES ('674ee002-5947-4fc0-bd6b-4788f7c63c92', '9d5aec3e-ce96-4613-a0f3-535241dcb434', '8', 8, 5);
INSERT INTO public.point_values (id, system_id, value, numeric_value, "position") VALUES ('be167521-c768-4698-9221-ff48aff05763', '9d5aec3e-ce96-4613-a0f3-535241dcb434', '13', 13, 6);
INSERT INTO public.point_values (id, system_id, value, numeric_value, "position") VALUES ('4beb2ea3-e4ea-4aa8-b4f0-d572b4e8ddbd', '9d5aec3e-ce96-4613-a0f3-535241dcb434', '21', 21, 7);


--
-- Data for Name: priorities; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

INSERT INTO public.priorities (id, name, level, color, "position") VALUES ('52f382fa-302d-4347-b116-744c0ac0bb67', 'Lowest', 1, '#94A3B8', 0);
INSERT INTO public.priorities (id, name, level, color, "position") VALUES ('bb2ed14b-e741-4ead-b7d8-a8648e9084b2', 'Low', 2, '#3B82F6', 1);
INSERT INTO public.priorities (id, name, level, color, "position") VALUES ('5d528611-7307-4e84-a619-07d00fec2a22', 'Medium', 3, '#F59E0B', 2);
INSERT INTO public.priorities (id, name, level, color, "position") VALUES ('c66e5adf-14be-4e3c-a28b-8239e48f6b17', 'High', 4, '#EF4444', 3);
INSERT INTO public.priorities (id, name, level, color, "position") VALUES ('85667e40-def5-4bf0-aa3b-d19b4a6b824a', 'Highest', 5, '#DC2626', 4);


--
-- PostgreSQL database dump complete
--

