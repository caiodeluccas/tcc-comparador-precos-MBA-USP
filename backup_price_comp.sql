--
-- PostgreSQL database dump
--

\restrict 8ZYGswvE51o5EcyzJ5lW22CfPurSiGhKEZkqZYhrXQL6rdsXMFezfJZFrSqLU8q

-- Dumped from database version 16.13 (Debian 16.13-1.pgdg13+1)
-- Dumped by pg_dump version 16.13 (Debian 16.13-1.pgdg13+1)

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
-- Name: categories; Type: TABLE; Schema: public; Owner: pc_app_admin
--

CREATE TABLE public.categories (
    id_category integer NOT NULL,
    category_name character varying(100) NOT NULL
);


ALTER TABLE public.categories OWNER TO pc_app_admin;

--
-- Name: categories_id_category_seq; Type: SEQUENCE; Schema: public; Owner: pc_app_admin
--

CREATE SEQUENCE public.categories_id_category_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_category_seq OWNER TO pc_app_admin;

--
-- Name: categories_id_category_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pc_app_admin
--

ALTER SEQUENCE public.categories_id_category_seq OWNED BY public.categories.id_category;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: pc_app_admin
--

CREATE TABLE public.countries (
    id_country integer NOT NULL,
    common_name character varying(100) NOT NULL,
    native_name character varying(100),
    continent character varying(50) NOT NULL,
    iso_2_code character(2) NOT NULL,
    iso_3_code character(3) NOT NULL,
    base_unit_label character(3) NOT NULL
);


ALTER TABLE public.countries OWNER TO pc_app_admin;

--
-- Name: countries_id_country_seq; Type: SEQUENCE; Schema: public; Owner: pc_app_admin
--

CREATE SEQUENCE public.countries_id_country_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.countries_id_country_seq OWNER TO pc_app_admin;

--
-- Name: countries_id_country_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pc_app_admin
--

ALTER SEQUENCE public.countries_id_country_seq OWNED BY public.countries.id_country;


--
-- Name: country_translations; Type: TABLE; Schema: public; Owner: pc_app_admin
--

CREATE TABLE public.country_translations (
    id_translation integer NOT NULL,
    id_country integer NOT NULL,
    language_code character(5) NOT NULL,
    translated_name character varying(255) NOT NULL
);


ALTER TABLE public.country_translations OWNER TO pc_app_admin;

--
-- Name: country_translations_id_translation_seq; Type: SEQUENCE; Schema: public; Owner: pc_app_admin
--

CREATE SEQUENCE public.country_translations_id_translation_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.country_translations_id_translation_seq OWNER TO pc_app_admin;

--
-- Name: country_translations_id_translation_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pc_app_admin
--

ALTER SEQUENCE public.country_translations_id_translation_seq OWNED BY public.country_translations.id_translation;


--
-- Name: labor_indicators; Type: TABLE; Schema: public; Owner: pc_app_admin
--

CREATE TABLE public.labor_indicators (
    id_indicator integer NOT NULL,
    indicator_code character varying(50) NOT NULL,
    description character varying(255),
    unit character varying(20),
    id_source integer
);


ALTER TABLE public.labor_indicators OWNER TO pc_app_admin;

--
-- Name: labor_indicators_history; Type: TABLE; Schema: public; Owner: pc_app_admin
--

CREATE TABLE public.labor_indicators_history (
    id_salary bigint NOT NULL,
    id_country integer NOT NULL,
    id_indicator integer NOT NULL,
    id_source integer NOT NULL,
    indicator_value numeric(15,2) NOT NULL,
    unit_label character(3) NOT NULL,
    reference_year integer NOT NULL,
    collection_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.labor_indicators_history OWNER TO pc_app_admin;

--
-- Name: labor_indicators_history_id_salary_seq; Type: SEQUENCE; Schema: public; Owner: pc_app_admin
--

ALTER TABLE public.labor_indicators_history ALTER COLUMN id_salary ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.labor_indicators_history_id_salary_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: labor_indicators_id_indicator_seq; Type: SEQUENCE; Schema: public; Owner: pc_app_admin
--

CREATE SEQUENCE public.labor_indicators_id_indicator_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.labor_indicators_id_indicator_seq OWNER TO pc_app_admin;

--
-- Name: labor_indicators_id_indicator_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pc_app_admin
--

ALTER SEQUENCE public.labor_indicators_id_indicator_seq OWNED BY public.labor_indicators.id_indicator;


--
-- Name: price_history; Type: TABLE; Schema: public; Owner: pc_app_admin
--

CREATE TABLE public.price_history (
    id_history bigint NOT NULL,
    sku character varying(255) NOT NULL,
    id_source integer NOT NULL,
    id_country integer NOT NULL,
    price numeric(15,2) NOT NULL,
    unit_label character(3) NOT NULL,
    collection_timestamp timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.price_history OWNER TO pc_app_admin;

--
-- Name: price_history_id_history_seq; Type: SEQUENCE; Schema: public; Owner: pc_app_admin
--

ALTER TABLE public.price_history ALTER COLUMN id_history ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.price_history_id_history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: product_asins; Type: TABLE; Schema: public; Owner: pc_app_admin
--

CREATE TABLE public.product_asins (
    sku character varying(255) NOT NULL,
    id_country integer NOT NULL,
    search_code character varying(50) NOT NULL
);


ALTER TABLE public.product_asins OWNER TO pc_app_admin;

--
-- Name: products; Type: TABLE; Schema: public; Owner: pc_app_admin
--

CREATE TABLE public.products (
    sku character varying(255) NOT NULL,
    product_name character varying(255) NOT NULL,
    search_term character varying(255),
    description text,
    id_category integer NOT NULL
);


ALTER TABLE public.products OWNER TO pc_app_admin;

--
-- Name: sources; Type: TABLE; Schema: public; Owner: pc_app_admin
--

CREATE TABLE public.sources (
    id_source integer NOT NULL,
    source_name character varying(100) NOT NULL
);


ALTER TABLE public.sources OWNER TO pc_app_admin;

--
-- Name: sources_id_source_seq; Type: SEQUENCE; Schema: public; Owner: pc_app_admin
--

CREATE SEQUENCE public.sources_id_source_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sources_id_source_seq OWNER TO pc_app_admin;

--
-- Name: sources_id_source_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pc_app_admin
--

ALTER SEQUENCE public.sources_id_source_seq OWNED BY public.sources.id_source;


--
-- Name: staging_labor_indicators; Type: TABLE; Schema: public; Owner: pc_app_admin
--

CREATE TABLE public.staging_labor_indicators (
    iso_3_code character(3),
    indicator_code text,
    indicator_value numeric,
    reference_year integer,
    unit_label character(3)
);


ALTER TABLE public.staging_labor_indicators OWNER TO pc_app_admin;

--
-- Name: categories id_category; Type: DEFAULT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.categories ALTER COLUMN id_category SET DEFAULT nextval('public.categories_id_category_seq'::regclass);


--
-- Name: countries id_country; Type: DEFAULT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.countries ALTER COLUMN id_country SET DEFAULT nextval('public.countries_id_country_seq'::regclass);


--
-- Name: country_translations id_translation; Type: DEFAULT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.country_translations ALTER COLUMN id_translation SET DEFAULT nextval('public.country_translations_id_translation_seq'::regclass);


--
-- Name: labor_indicators id_indicator; Type: DEFAULT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.labor_indicators ALTER COLUMN id_indicator SET DEFAULT nextval('public.labor_indicators_id_indicator_seq'::regclass);


--
-- Name: sources id_source; Type: DEFAULT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.sources ALTER COLUMN id_source SET DEFAULT nextval('public.sources_id_source_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: pc_app_admin
--

COPY public.categories (id_category, category_name) FROM stdin;
1	Eletrônicos e Informática
2	Eletrodomésticos e Casa
3	Saúde e Cuidados Pessoais
4	Alimentos e Bebidas
5	Moda e Acessórios
6	Beleza e Perfumaria
7	Brinquedos e Jogos
8	Esporte e Lazer
9	Livros e Mídia
10	Automotivo
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: pc_app_admin
--

COPY public.countries (id_country, common_name, native_name, continent, iso_2_code, iso_3_code, base_unit_label) FROM stdin;
1	Andorra	Andorra	EU	AD	AND	EUR
2	United Arab Emirates	دولة الإمارات العربية المتحدة	AS	AE	ARE	AED
3	Afghanistan	افغانستان	AS	AF	AFG	AFN
4	Antigua and Barbuda	Antigua and Barbuda	NA	AG	ATG	XCD
5	Anguilla	Anguilla	NA	AI	AIA	XCD
6	Albania	Shqipëria	EU	AL	ALB	ALL
7	Armenia	Հայաստան	AS	AM	ARM	AMD
8	Angola	Angola	AF	AO	AGO	AOA
9	Antarctica	Antarctica	AN	AQ	ATA	   
10	Argentina	Argentina	SA	AR	ARG	ARS
11	American Samoa	American Samoa	OC	AS	ASM	USD
12	Austria	Österreich	EU	AT	AUT	EUR
13	Australia	Australia	OC	AU	AUS	AUD
14	Aruba	Aruba	NA	AW	ABW	AWG
15	Aland	Åland	EU	AX	ALA	EUR
16	Azerbaijan	Azərbaycan	AS	AZ	AZE	AZN
17	Bosnia and Herzegovina	Bosna i Hercegovina	EU	BA	BIH	BAM
18	Barbados	Barbados	NA	BB	BRB	BBD
19	Bangladesh	Bangladesh	AS	BD	BGD	BDT
20	Belgium	België	EU	BE	BEL	EUR
21	Burkina Faso	Burkina Faso	AF	BF	BFA	XOF
22	Bulgaria	България	EU	BG	BGR	BGN
23	Bahrain	‏البحرين	AS	BH	BHR	BHD
24	Burundi	Burundi	AF	BI	BDI	BIF
25	Benin	Bénin	AF	BJ	BEN	XOF
26	Saint Barthelemy	Saint-Barthélemy	NA	BL	BLM	EUR
27	Bermuda	Bermuda	NA	BM	BMU	BMD
28	Brunei	Negara Brunei Darussalam	AS	BN	BRN	BND
29	Bolivia	Bolivia	SA	BO	BOL	BOB
30	Bonaire	Bonaire	NA	BQ	BES	USD
31	Brazil	Brasil	SA	BR	BRA	BRL
32	Bahamas	Bahamas	NA	BS	BHS	BSD
33	Bhutan	ʼbrug-yul	AS	BT	BTN	BTN
34	Bouvet Island	Bouvetøya	AN	BV	BVT	NOK
35	Botswana	Botswana	AF	BW	BWA	BWP
36	Belarus	Беларусь	EU	BY	BLR	BYN
37	Belize	Belize	NA	BZ	BLZ	BZD
38	Canada	Canada	NA	CA	CAN	CAD
39	Cocos (Keeling) Islands	Cocos (Keeling) Islands	AS	CC	CCK	AUD
40	Democratic Republic of the Congo	République démocratique du Congo	AF	CD	COD	CDF
41	Central African Republic	Ködörösêse tî Bêafrîka	AF	CF	CAF	XAF
42	Republic of the Congo	République du Congo	AF	CG	COG	XAF
43	Switzerland	Schweiz	EU	CH	CHE	CHF
44	Ivory Coast	Côte d'Ivoire	AF	CI	CIV	XOF
45	Cook Islands	Cook Islands	OC	CK	COK	NZD
46	Chile	Chile	SA	CL	CHL	CLF
47	Cameroon	Cameroon	AF	CM	CMR	XAF
48	China	中国	AS	CN	CHN	CNY
49	Colombia	Colombia	SA	CO	COL	COP
50	Costa Rica	Costa Rica	NA	CR	CRI	CRC
51	Cuba	Cuba	NA	CU	CUB	CUP
52	Cape Verde	Cabo Verde	AF	CV	CPV	CVE
53	Curacao	Curaçao	NA	CW	CUW	ANG
54	Christmas Island	Christmas Island	AS	CX	CXR	AUD
55	Cyprus	Κύπρος	EU	CY	CYP	EUR
56	Czech Republic	Česká republika	EU	CZ	CZE	CZK
57	Germany	Deutschland	EU	DE	DEU	EUR
58	Djibouti	Djibouti	AF	DJ	DJI	DJF
59	Denmark	Danmark	EU	DK	DNK	DKK
60	Dominica	Dominica	NA	DM	DMA	XCD
61	Dominican Republic	República Dominicana	NA	DO	DOM	DOP
62	Algeria	الجزائر	AF	DZ	DZA	DZD
63	Ecuador	Ecuador	SA	EC	ECU	USD
64	Estonia	Eesti	EU	EE	EST	EUR
65	Egypt	مصر‎	AF	EG	EGY	EGP
66	Western Sahara	الصحراء الغربية	AF	EH	ESH	MAD
67	Eritrea	ኤርትራ	AF	ER	ERI	ERN
68	Spain	España	EU	ES	ESP	EUR
69	Ethiopia	ኢትዮጵያ	AF	ET	ETH	ETB
70	Finland	Suomi	EU	FI	FIN	EUR
71	Fiji	Fiji	OC	FJ	FJI	FJD
72	Falkland Islands	Falkland Islands	SA	FK	FLK	FKP
73	Micronesia	Micronesia	OC	FM	FSM	USD
74	Faroe Islands	Føroyar	EU	FO	FRO	DKK
75	France	France	EU	FR	FRA	EUR
76	Gabon	Gabon	AF	GA	GAB	XAF
77	United Kingdom	United Kingdom	EU	GB	GBR	GBP
78	Grenada	Grenada	NA	GD	GRD	XCD
79	Georgia	საქართველო	AS	GE	GEO	GEL
80	French Guiana	Guyane française	SA	GF	GUF	EUR
81	Guernsey	Guernsey	EU	GG	GGY	GBP
82	Ghana	Ghana	AF	GH	GHA	GHS
83	Gibraltar	Gibraltar	EU	GI	GIB	GIP
84	Greenland	Kalaallit Nunaat	NA	GL	GRL	DKK
85	Gambia	Gambia	AF	GM	GMB	GMD
86	Guinea	Guinée	AF	GN	GIN	GNF
87	Guadeloupe	Guadeloupe	NA	GP	GLP	EUR
88	Equatorial Guinea	Guinea Ecuatorial	AF	GQ	GNQ	XAF
89	Greece	Ελλάδα	EU	GR	GRC	EUR
90	South Georgia and the South Sandwich Islands	South Georgia	AN	GS	SGS	GBP
91	Guatemala	Guatemala	NA	GT	GTM	GTQ
92	Guam	Guam	OC	GU	GUM	USD
93	Guinea-Bissau	Guiné-Bissau	AF	GW	GNB	XOF
94	Guyana	Guyana	SA	GY	GUY	GYD
95	Hong Kong	香港	AS	HK	HKG	HKD
96	Heard Island and McDonald Islands	Heard Island and McDonald Islands	AN	HM	HMD	AUD
97	Honduras	Honduras	NA	HN	HND	HNL
98	Croatia	Hrvatska	EU	HR	HRV	EUR
99	Haiti	Haïti	NA	HT	HTI	HTG
100	Hungary	Magyarország	EU	HU	HUN	HUF
101	Indonesia	Indonesia	AS	ID	IDN	IDR
102	Ireland	Éire	EU	IE	IRL	EUR
103	Israel	יִשְׂרָאֵל	AS	IL	ISR	ILS
104	Isle of Man	Isle of Man	EU	IM	IMN	GBP
105	India	भारत	AS	IN	IND	INR
106	British Indian Ocean Territory	British Indian Ocean Territory	AS	IO	IOT	USD
107	Iraq	العراق	AS	IQ	IRQ	IQD
108	Iran	ایران	AS	IR	IRN	IRR
109	Iceland	Ísland	EU	IS	ISL	ISK
110	Italy	Italia	EU	IT	ITA	EUR
111	Jersey	Jersey	EU	JE	JEY	GBP
112	Jamaica	Jamaica	NA	JM	JAM	JMD
113	Jordan	الأردن	AS	JO	JOR	JOD
114	Japan	日本	AS	JP	JPN	JPY
115	Kenya	Kenya	AF	KE	KEN	KES
116	Kyrgyzstan	Кыргызстан	AS	KG	KGZ	KGS
117	Cambodia	កម្ពុជា	AS	KH	KHM	KHR
118	Kiribati	Kiribati	OC	KI	KIR	AUD
119	Comoros	Komori	AF	KM	COM	KMF
120	Saint Kitts and Nevis	Saint Kitts and Nevis	NA	KN	KNA	XCD
121	North Korea	북한	AS	KP	PRK	KPW
122	South Korea	대한민국	AS	KR	KOR	KRW
123	Kuwait	الكويت	AS	KW	KWT	KWD
124	Cayman Islands	Cayman Islands	NA	KY	CYM	KYD
125	Kazakhstan	Қазақстан	AS	KZ	KAZ	KZT
126	Laos	ສປປລາວ	AS	LA	LAO	LAK
127	Lebanon	لبنان	AS	LB	LBN	LBP
128	Saint Lucia	Saint Lucia	NA	LC	LCA	XCD
129	Liechtenstein	Liechtenstein	EU	LI	LIE	CHF
130	Sri Lanka	śrī laṃkāva	AS	LK	LKA	LKR
131	Liberia	Liberia	AF	LR	LBR	LRD
132	Lesotho	Lesotho	AF	LS	LSO	LSL
133	Lithuania	Lietuva	EU	LT	LTU	EUR
134	Luxembourg	Luxembourg	EU	LU	LUX	EUR
135	Latvia	Latvija	EU	LV	LVA	EUR
136	Libya	‏ليبيا	AF	LY	LBY	LYD
137	Morocco	المغرب	AF	MA	MAR	MAD
138	Monaco	Monaco	EU	MC	MCO	EUR
139	Moldova	Moldova	EU	MD	MDA	MDL
140	Montenegro	Црна Гора	EU	ME	MNE	EUR
141	Saint Martin	Saint-Martin	NA	MF	MAF	EUR
142	Madagascar	Madagasikara	AF	MG	MDG	MGA
143	Marshall Islands	M̧ajeļ	OC	MH	MHL	USD
144	North Macedonia	Северна Македонија	EU	MK	MKD	MKD
145	Mali	Mali	AF	ML	MLI	XOF
146	Myanmar (Burma)	မြန်မာ	AS	MM	MMR	MMK
147	Mongolia	Монгол улс	AS	MN	MNG	MNT
148	Macao	澳門	AS	MO	MAC	MOP
149	Northern Mariana Islands	Northern Mariana Islands	OC	MP	MNP	USD
150	Martinique	Martinique	NA	MQ	MTQ	EUR
151	Mauritania	موريتانيا	AF	MR	MRT	MRU
152	Montserrat	Montserrat	NA	MS	MSR	XCD
153	Malta	Malta	EU	MT	MLT	EUR
154	Mauritius	Maurice	AF	MU	MUS	MUR
155	Maldives	Maldives	AS	MV	MDV	MVR
156	Malawi	Malawi	AF	MW	MWI	MWK
157	Mexico	México	NA	MX	MEX	MXN
158	Malaysia	Malaysia	AS	MY	MYS	MYR
159	Mozambique	Moçambique	AF	MZ	MOZ	MZN
160	Namibia	Namibia	AF	NA	NAM	NAD
161	New Caledonia	Nouvelle-Calédonie	OC	NC	NCL	XPF
162	Niger	Niger	AF	NE	NER	XOF
163	Norfolk Island	Norfolk Island	OC	NF	NFK	AUD
164	Nigeria	Nigeria	AF	NG	NGA	NGN
165	Nicaragua	Nicaragua	NA	NI	NIC	NIO
166	Netherlands	Nederland	EU	NL	NLD	EUR
167	Norway	Norge	EU	NO	NOR	NOK
168	Nepal	नेपाल	AS	NP	NPL	NPR
169	Nauru	Nauru	OC	NR	NRU	AUD
170	Niue	Niuē	OC	NU	NIU	NZD
171	New Zealand	New Zealand	OC	NZ	NZL	NZD
172	Oman	عمان	AS	OM	OMN	OMR
173	Panama	Panamá	NA	PA	PAN	PAB
174	Peru	Perú	SA	PE	PER	PEN
175	French Polynesia	Polynésie française	OC	PF	PYF	XPF
176	Papua New Guinea	Papua Niugini	OC	PG	PNG	PGK
177	Philippines	Pilipinas	AS	PH	PHL	PHP
178	Pakistan	Pakistan	AS	PK	PAK	PKR
179	Poland	Polska	EU	PL	POL	PLN
180	Saint Pierre and Miquelon	Saint-Pierre-et-Miquelon	NA	PM	SPM	EUR
181	Pitcairn Islands	Pitcairn Islands	OC	PN	PCN	NZD
182	Puerto Rico	Puerto Rico	NA	PR	PRI	USD
183	Palestine	فلسطين	AS	PS	PSE	ILS
184	Portugal	Portugal	EU	PT	PRT	EUR
185	Palau	Palau	OC	PW	PLW	USD
186	Paraguay	Paraguay	SA	PY	PRY	PYG
187	Qatar	قطر	AS	QA	QAT	QAR
188	Reunion	La Réunion	AF	RE	REU	EUR
189	Romania	România	EU	RO	ROU	RON
190	Serbia	Србија	EU	RS	SRB	RSD
191	Russia	Россия	AS	RU	RUS	RUB
192	Rwanda	Rwanda	AF	RW	RWA	RWF
193	Saudi Arabia	المملكة العربية السعودية	AS	SA	SAU	SAR
194	Solomon Islands	Solomon Islands	OC	SB	SLB	SBD
195	Seychelles	Seychelles	AF	SC	SYC	SCR
196	Sudan	السودان	AF	SD	SDN	SDG
197	Sweden	Sverige	EU	SE	SWE	SEK
198	Singapore	Singapore	AS	SG	SGP	SGD
199	Saint Helena	Saint Helena	AF	SH	SHN	SHP
200	Slovenia	Slovenija	EU	SI	SVN	EUR
201	Svalbard and Jan Mayen	Svalbard og Jan Mayen	EU	SJ	SJM	NOK
202	Slovakia	Slovensko	EU	SK	SVK	EUR
203	Sierra Leone	Sierra Leone	AF	SL	SLE	SLL
204	San Marino	San Marino	EU	SM	SMR	EUR
205	Senegal	Sénégal	AF	SN	SEN	XOF
206	Somalia	Soomaaliya	AF	SO	SOM	SOS
207	Suriname	Suriname	SA	SR	SUR	SRD
208	South Sudan	South Sudan	AF	SS	SSD	SSP
209	Sao Tome and Principe	São Tomé e Príncipe	AF	ST	STP	STN
210	El Salvador	El Salvador	NA	SV	SLV	SVC
211	Sint Maarten	Sint Maarten	NA	SX	SXM	ANG
212	Syria	سوريا	AS	SY	SYR	SYP
213	Eswatini	Eswatini	AF	SZ	SWZ	SZL
214	Turks and Caicos Islands	Turks and Caicos Islands	NA	TC	TCA	USD
215	Chad	Tchad	AF	TD	TCD	XAF
216	French Southern Territories	Territoire des Terres australes et antarctiques fr	AN	TF	ATF	EUR
217	Togo	Togo	AF	TG	TGO	XOF
218	Thailand	ประเทศไทย	AS	TH	THA	THB
219	Tajikistan	Тоҷикистон	AS	TJ	TJK	TJS
220	Tokelau	Tokelau	OC	TK	TKL	NZD
221	East Timor	Timor-Leste	OC	TL	TLS	USD
222	Turkmenistan	Türkmenistan	AS	TM	TKM	TMT
223	Tunisia	تونس	AF	TN	TUN	TND
224	Tonga	Tonga	OC	TO	TON	TOP
225	Turkey	Türkiye	AS	TR	TUR	TRY
226	Trinidad and Tobago	Trinidad and Tobago	NA	TT	TTO	TTD
227	Tuvalu	Tuvalu	OC	TV	TUV	AUD
228	Taiwan	臺灣	AS	TW	TWN	TWD
229	Tanzania	Tanzania	AF	TZ	TZA	TZS
230	Ukraine	Україна	EU	UA	UKR	UAH
231	Uganda	Uganda	AF	UG	UGA	UGX
232	U.S. Minor Outlying Islands	United States Minor Outlying Islands	OC	UM	UMI	USD
233	United States	United States	NA	US	USA	USD
234	Uruguay	Uruguay	SA	UY	URY	UYI
235	Uzbekistan	O'zbekiston	AS	UZ	UZB	UZS
236	Vatican City	Vaticano	EU	VA	VAT	EUR
237	Saint Vincent and the Grenadines	Saint Vincent and the Grenadines	NA	VC	VCT	XCD
238	Venezuela	Venezuela	SA	VE	VEN	VES
239	British Virgin Islands	British Virgin Islands	NA	VG	VGB	USD
240	U.S. Virgin Islands	United States Virgin Islands	NA	VI	VIR	USD
241	Vietnam	Việt Nam	AS	VN	VNM	VND
242	Vanuatu	Vanuatu	OC	VU	VUT	VUV
243	Wallis and Futuna	Wallis et Futuna	OC	WF	WLF	XPF
244	Samoa	Samoa	OC	WS	WSM	WST
245	Kosovo	Republika e Kosovës	EU	XK	XKX	EUR
246	Yemen	اليَمَن	AS	YE	YEM	YER
247	Mayotte	Mayotte	AF	YT	MYT	EUR
248	South Africa	South Africa	AF	ZA	ZAF	ZAR
249	Zambia	Zambia	AF	ZM	ZMB	ZMW
250	Zimbabwe	Zimbabwe	AF	ZW	ZWE	USD
\.


--
-- Data for Name: country_translations; Type: TABLE DATA; Schema: public; Owner: pc_app_admin
--

COPY public.country_translations (id_translation, id_country, language_code, translated_name) FROM stdin;
1	1	pt-br	Andorra
2	2	pt-br	Emirados Árabes Unidos
3	3	pt-br	Afeganistão
4	4	pt-br	Antígua e Barbuda
5	5	pt-br	Anguilla
6	6	pt-br	Albânia
7	7	pt-br	Armênia
8	8	pt-br	Angola
9	9	pt-br	Antártida
10	10	pt-br	Argentina
11	11	pt-br	Samoa Americana
12	12	pt-br	Áustria
13	13	pt-br	Austrália
14	14	pt-br	Aruba
15	15	pt-br	Ilhas Aland
16	16	pt-br	Azerbaijão
17	17	pt-br	Bósnia e Herzegovina
18	18	pt-br	Barbados
19	19	pt-br	Bangladesh
20	20	pt-br	Bélgica
21	21	pt-br	Burkina Faso
22	22	pt-br	Bulgária
23	23	pt-br	Bahrein
24	24	pt-br	Burundi
25	25	pt-br	Benim
26	27	pt-br	Bermudas
27	28	pt-br	Brunei
28	29	pt-br	Bolívia
29	31	pt-br	Brasil
30	32	pt-br	Bahamas
31	33	pt-br	Butão
32	35	pt-br	Botsuana
33	36	pt-br	Belarus
34	37	pt-br	Belize
35	38	pt-br	Canadá
36	40	pt-br	Congo-Kinshasa
37	41	pt-br	República Centro-Africana
38	42	pt-br	Congo-Brazzaville
39	43	pt-br	Suíça
40	44	pt-br	Costa do Marfim
41	46	pt-br	Chile
42	47	pt-br	Camarões
43	48	pt-br	China
44	49	pt-br	Colômbia
45	50	pt-br	Costa Rica
46	51	pt-br	Cuba
47	52	pt-br	Cabo Verde
48	55	pt-br	Chipre
49	56	pt-br	Tchéquia
50	57	pt-br	Alemanha
51	58	pt-br	Djibuti
52	59	pt-br	Dinamarca
53	60	pt-br	Dominica
54	61	pt-br	República Dominicana
55	62	pt-br	Argélia
56	63	pt-br	Equador
57	64	pt-br	Estônia
58	65	pt-br	Egito
59	68	pt-br	Espanha
60	69	pt-br	Etiópia
61	70	pt-br	Finlândia
62	71	pt-br	Fiji
63	75	pt-br	França
64	76	pt-br	Gabão
65	77	pt-br	Reino Unido
66	78	pt-br	Granada
67	79	pt-br	Geórgia
68	82	pt-br	Gana
69	83	pt-br	Gibraltar
70	84	pt-br	Groenlândia
71	85	pt-br	Gâmbia
72	86	pt-br	Guiné
73	88	pt-br	Guiné Equatorial
74	89	pt-br	Grécia
75	91	pt-br	Guatemala
76	93	pt-br	Guiné-Bissau
77	94	pt-br	Guiana
78	95	pt-br	Hong Kong
79	97	pt-br	Honduras
80	98	pt-br	Croácia
81	99	pt-br	Haiti
82	100	pt-br	Hungria
83	101	pt-br	Indonésia
84	102	pt-br	Irlanda
85	103	pt-br	Israel
86	105	pt-br	Índia
87	107	pt-br	Iraque
88	108	pt-br	Irã
89	109	pt-br	Islândia
90	110	pt-br	Itália
91	112	pt-br	Jamaica
92	113	pt-br	Jordânia
93	114	pt-br	Japão
94	115	pt-br	Quênia
95	116	pt-br	Quirguistão
96	117	pt-br	Camboja
97	121	pt-br	Coreia do Norte
98	122	pt-br	Coreia do Sul
99	123	pt-br	Kuwait
100	125	pt-br	Cazaquistão
101	126	pt-br	Laos
102	127	pt-br	Líbano
103	129	pt-br	Liechtenstein
104	130	pt-br	Sri Lanka
105	131	pt-br	Libéria
106	132	pt-br	Lesoto
107	133	pt-br	Lituânia
108	134	pt-br	Luxemburgo
109	135	pt-br	Letônia
110	136	pt-br	Líbia
111	137	pt-br	Marrocos
112	138	pt-br	Mônaco
113	139	pt-br	Moldova
114	140	pt-br	Montenegro
115	142	pt-br	Madagascar
116	144	pt-br	Macedônia do Norte
117	145	pt-br	Mali
118	146	pt-br	Mianmar
119	147	pt-br	Mongólia
120	148	pt-br	Macau
121	153	pt-br	Malta
122	154	pt-br	Maurício
123	155	pt-br	Maldivas
124	156	pt-br	Malaui
125	157	pt-br	México
126	158	pt-br	Malásia
127	159	pt-br	Moçambique
128	160	pt-br	Namíbia
129	162	pt-br	Níger
130	164	pt-br	Nigéria
131	165	pt-br	Nicarágua
132	166	pt-br	Países Baixos
133	167	pt-br	Noruega
134	168	pt-br	Nepal
135	171	pt-br	Nova Zelândia
136	172	pt-br	Omã
137	173	pt-br	Panamá
138	174	pt-br	Peru
139	177	pt-br	Filipinas
140	178	pt-br	Paquistão
141	179	pt-br	Polônia
142	184	pt-br	Portugal
143	186	pt-br	Paraguai
144	187	pt-br	Catar
145	189	pt-br	Romênia
146	190	pt-br	Sérvia
147	191	pt-br	Rússia
148	192	pt-br	Ruanda
149	193	pt-br	Arábia Saudita
150	197	pt-br	Suécia
151	198	pt-br	Singapura
152	200	pt-br	Eslovênia
153	202	pt-br	Eslováquia
154	203	pt-br	Serra Leoa
155	205	pt-br	Senegal
156	206	pt-br	Somália
157	207	pt-br	Suriname
158	209	pt-br	São Tomé e Príncipe
159	210	pt-br	El Salvador
160	212	pt-br	Síria
161	218	pt-br	Tailândia
162	219	pt-br	Tajiquistão
163	221	pt-br	Timor-Leste
164	222	pt-br	Turcomenistão
165	223	pt-br	Tunísia
166	225	pt-br	Turquia
167	226	pt-br	Trinidad e Tobago
168	228	pt-br	Taiwan
169	229	pt-br	Tanzânia
170	230	pt-br	Ucrânia
171	231	pt-br	Uganda
172	233	pt-br	Estados Unidos
173	234	pt-br	Uruguai
174	235	pt-br	Uzbequistão
175	238	pt-br	Venezuela
176	241	pt-br	Vietnã
177	248	pt-br	África do Sul
178	249	pt-br	Zâmbia
179	250	pt-br	Zimbábue
\.


--
-- Data for Name: labor_indicators; Type: TABLE DATA; Schema: public; Owner: pc_app_admin
--

COPY public.labor_indicators (id_indicator, indicator_code, description, unit, id_source) FROM stdin;
1	EAR_EMTA_SEX_NB_A	Média Salarial Mensal	Mensal	1
2	EAR_EHRA_SEX_AGE_NB_A	Média Salarial por Hora	Hora	1
3	EAR_INEE_NOC_NB_A	Salário Mínimo Mensal	Mensal	1
5	HOW_2EMP_SEX_NB	Média de horas semanais trabalhadas	Horas	1
\.


--
-- Data for Name: labor_indicators_history; Type: TABLE DATA; Schema: public; Owner: pc_app_admin
--

COPY public.labor_indicators_history (id_salary, id_country, id_indicator, id_source, indicator_value, unit_label, reference_year, collection_date) FROM stdin;
1	97	1	1	11248.07	LCU	2025	2026-03-27 21:31:50.494922+00
2	38	1	1	5761.95	LCU	2025	2026-03-27 21:31:50.494922+00
3	50	1	1	606508.10	LCU	2025	2026-03-27 21:31:50.494922+00
4	49	1	1	2022657.00	LCU	2025	2026-03-27 21:31:50.494922+00
5	183	1	1	3195.10	LCU	2025	2026-03-27 21:31:50.494922+00
6	186	1	1	3385364.00	LCU	2025	2026-03-27 21:31:50.494922+00
7	31	1	1	3393.15	LCU	2025	2026-03-27 21:31:50.494922+00
8	184	1	1	1262.16	LCU	2025	2026-03-27 21:31:50.494922+00
9	61	1	1	30072.14	LCU	2025	2026-03-27 21:31:50.494922+00
10	63	1	1	538.45	LCU	2025	2026-03-27 21:31:50.494922+00
11	178	1	1	26628.50	LCU	2025	2026-03-27 21:31:50.494922+00
12	174	1	1	2008.01	LCU	2025	2026-03-27 21:31:50.494922+00
13	77	1	1	3156.79	LCU	2025	2026-03-27 21:31:50.494922+00
14	233	1	1	6272.93	LCU	2025	2026-03-27 21:31:50.494922+00
15	110	1	1	3329.88	LCU	2024	2026-03-27 21:31:50.494922+00
16	197	1	1	3987.20	LCU	2024	2026-03-27 21:31:50.494922+00
17	102	1	1	4799.09	LCU	2024	2026-03-27 21:31:50.494922+00
18	200	1	1	3053.06	LCU	2024	2026-03-27 21:31:50.494922+00
19	82	1	1	2578.89	LCU	2024	2026-03-27 21:31:50.494922+00
20	105	1	1	20811.60	LCU	2024	2026-03-27 21:31:50.494922+00
21	100	1	1	1105.32	LCU	2024	2026-03-27 21:31:50.494922+00
22	98	1	1	2283.34	LCU	2024	2026-03-27 21:31:50.494922+00
23	190	1	1	1073.30	LCU	2024	2026-03-27 21:31:50.494922+00
24	91	1	1	3604.84	LCU	2024	2026-03-27 21:31:50.494922+00
25	89	1	1	1977.88	LCU	2024	2026-03-27 21:31:50.494922+00
26	75	1	1	4301.75	LCU	2024	2026-03-27 21:31:50.494922+00
27	202	1	1	1336.42	LCU	2024	2026-03-27 21:31:50.494922+00
28	8	1	1	111867.20	LCU	2024	2026-03-27 21:31:50.494922+00
29	210	1	1	484.41	LCU	2024	2026-03-27 21:31:50.494922+00
30	157	1	1	9878.47	LCU	2024	2026-03-27 21:31:50.494922+00
31	167	1	1	5535.19	LCU	2024	2026-03-27 21:31:50.494922+00
32	166	1	1	5366.95	LCU	2024	2026-03-27 21:31:50.494922+00
33	164	1	1	76488.79	LCU	2024	2026-03-27 21:31:50.494922+00
34	179	1	1	1682.77	LCU	2024	2026-03-27 21:31:50.494922+00
35	154	1	1	32444.13	LCU	2024	2026-03-27 21:31:50.494922+00
36	147	1	1	1655390.00	LCU	2024	2026-03-27 21:31:50.494922+00
37	145	1	1	106709.90	LCU	2024	2026-03-27 21:31:50.494922+00
38	189	1	1	1413.14	LCU	2024	2026-03-27 21:31:50.494922+00
39	205	1	1	169275.70	LCU	2024	2026-03-27 21:31:50.494922+00
40	192	1	1	69850.80	LCU	2024	2026-03-27 21:31:50.494922+00
41	139	1	1	7221.35	LCU	2024	2026-03-27 21:31:50.494922+00
42	135	1	1	2138.12	LCU	2024	2026-03-27 21:31:50.494922+00
43	134	1	1	7864.73	LCU	2024	2026-03-27 21:31:50.494922+00
44	133	1	1	2106.44	LCU	2024	2026-03-27 21:31:50.494922+00
45	132	1	1	2494.24	LCU	2024	2026-03-27 21:31:50.494922+00
46	70	1	1	4928.68	LCU	2024	2026-03-27 21:31:50.494922+00
47	71	1	1	1392.11	LCU	2024	2026-03-27 21:31:50.494922+00
48	173	1	1	882.82	LCU	2024	2026-03-27 21:31:50.494922+00
49	43	1	1	6374.79	LCU	2024	2026-03-27 21:31:50.494922+00
50	35	1	1	6545.62	LCU	2024	2026-03-27 21:31:50.494922+00
51	46	1	1	966377.60	LCU	2024	2026-03-27 21:31:50.494922+00
52	33	1	1	28210.11	LCU	2024	2026-03-27 21:31:50.494922+00
53	234	1	1	47938.86	LCU	2024	2026-03-27 21:31:50.494922+00
54	29	1	1	3229.21	LCU	2024	2026-03-27 21:31:50.494922+00
55	241	1	1	8579562.00	LCU	2024	2026-03-27 21:31:50.494922+00
56	229	1	1	549783.10	LCU	2024	2026-03-27 21:31:50.494922+00
57	17	1	1	1671.40	LCU	2024	2026-03-27 21:31:50.494922+00
58	225	1	1	28173.30	LCU	2024	2026-03-27 21:31:50.494922+00
59	22	1	1	1199.78	LCU	2024	2026-03-27 21:31:50.494922+00
60	19	1	1	15516.52	LCU	2024	2026-03-27 21:31:50.494922+00
61	21	1	1	102930.90	LCU	2024	2026-03-27 21:31:50.494922+00
62	20	1	1	6240.79	LCU	2024	2026-03-27 21:31:50.494922+00
63	55	1	1	2697.70	LCU	2024	2026-03-27 21:31:50.494922+00
64	56	1	1	2378.25	LCU	2024	2026-03-27 21:31:50.494922+00
65	12	1	1	4922.56	LCU	2024	2026-03-27 21:31:50.494922+00
66	218	1	1	16519.03	LCU	2024	2026-03-27 21:31:50.494922+00
67	59	1	1	5853.42	LCU	2024	2026-03-27 21:31:50.494922+00
68	249	1	1	4458.15	LCU	2024	2026-03-27 21:31:50.494922+00
69	65	1	1	4953.56	LCU	2024	2026-03-27 21:31:50.494922+00
70	10	1	1	592570.70	LCU	2024	2026-03-27 21:31:50.494922+00
71	68	1	1	3039.89	LCU	2024	2026-03-27 21:31:50.494922+00
72	64	1	1	2626.26	LCU	2024	2026-03-27 21:31:50.494922+00
73	185	1	1	1042.37	LCU	2023	2026-03-27 21:31:50.494922+00
74	32	1	1	5778.44	LCU	2023	2026-03-27 21:31:50.494922+00
75	177	1	1	17604.96	LCU	2023	2026-03-27 21:31:50.494922+00
76	7	1	1	159067.10	LCU	2023	2026-03-27 21:31:50.494922+00
77	130	1	1	47083.58	LCU	2023	2026-03-27 21:31:50.494922+00
78	250	1	1	406978.70	LCU	2023	2026-03-27 21:31:50.494922+00
79	213	1	1	7094.84	LCU	2023	2026-03-27 21:31:50.494922+00
80	118	1	1	538.46	LCU	2023	2026-03-27 21:31:50.494922+00
81	79	1	1	866.97	LCU	2023	2026-03-27 21:31:50.494922+00
82	117	1	1	1146161.00	LCU	2023	2026-03-27 21:31:50.494922+00
83	113	1	1	341.40	LCU	2023	2026-03-27 21:31:50.494922+00
84	224	1	1	1566.63	LCU	2023	2026-03-27 21:31:50.494922+00
85	45	1	1	10125.13	LCU	2023	2026-03-27 21:31:50.494922+00
86	101	1	1	2776804.00	LCU	2023	2026-03-27 21:31:50.494922+00
87	126	1	1	2503996.00	LCU	2022	2026-03-27 21:31:50.494922+00
88	57	1	1	4412.67	LCU	2022	2026-03-27 21:31:50.494922+00
89	162	1	1	75078.92	LCU	2022	2026-03-27 21:31:50.494922+00
90	244	1	1	1648.44	LCU	2022	2026-03-27 21:31:50.494922+00
91	196	1	1	155379.20	LCU	2022	2026-03-27 21:31:50.494922+00
92	25	1	1	84524.93	LCU	2022	2026-03-27 21:31:50.494922+00
93	215	1	1	128464.40	LCU	2022	2026-03-27 21:31:50.494922+00
94	93	1	1	87940.42	LCU	2022	2026-03-27 21:31:50.494922+00
95	44	1	1	128952.50	LCU	2022	2026-03-27 21:31:50.494922+00
96	206	1	1	247.09	LCU	2022	2026-03-27 21:31:50.494922+00
97	217	1	1	85868.24	LCU	2022	2026-03-27 21:31:50.494922+00
98	13	1	1	5905.54	LCU	2021	2026-03-27 21:31:50.494922+00
99	153	1	1	3337.27	LCU	2021	2026-03-27 21:31:50.494922+00
100	221	1	1	257.59	LCU	2021	2026-03-27 21:31:50.494922+00
101	119	1	1	105355.20	LCU	2021	2026-03-27 21:31:50.494922+00
102	231	1	1	577677.90	LCU	2021	2026-03-27 21:31:50.494922+00
103	69	1	1	4195.97	LCU	2021	2026-03-27 21:31:50.494922+00
104	248	1	1	7980.25	LCU	2020	2026-03-27 21:31:50.494922+00
105	182	1	1	2232.79	LCU	2020	2026-03-27 21:31:50.494922+00
106	3	1	1	13202.25	LCU	2020	2026-03-27 21:31:50.494922+00
107	109	1	1	5558.23	LCU	2020	2026-03-27 21:31:50.494922+00
108	24	1	1	96843.79	LCU	2020	2026-03-27 21:31:50.494922+00
109	146	1	1	187872.50	LCU	2020	2026-03-27 21:31:50.494922+00
110	94	1	1	81920.78	LCU	2019	2026-03-27 21:31:50.494922+00
111	155	1	1	11551.16	LCU	2019	2026-03-27 21:31:50.494922+00
112	115	1	1	13932.87	LCU	2019	2026-03-27 21:31:50.494922+00
113	223	1	1	739.68	LCU	2019	2026-03-27 21:31:50.494922+00
114	127	1	1	1175960.00	LCU	2019	2026-03-27 21:31:50.494922+00
115	37	1	1	1269.44	LCU	2019	2026-03-27 21:31:50.494922+00
116	86	1	1	1765988.00	LCU	2019	2026-03-27 21:31:50.494922+00
117	143	1	1	798.35	LCU	2019	2026-03-27 21:31:50.494922+00
118	243	1	1	234174.40	LCU	2019	2026-03-27 21:31:50.494922+00
119	151	1	1	60522.50	LCU	2019	2026-03-27 21:31:50.494922+00
120	203	1	1	2059613.00	LCU	2018	2026-03-27 21:31:50.494922+00
121	4	1	1	2672.81	LCU	2018	2026-03-27 21:31:50.494922+00
122	160	1	1	7233.30	LCU	2018	2026-03-27 21:31:50.494922+00
123	85	1	1	3988.24	LCU	2018	2026-03-27 21:31:50.494922+00
124	238	1	1	271673.00	LCU	2017	2026-03-27 21:31:50.494922+00
125	161	1	1	220065.40	LCU	2017	2026-03-27 21:31:50.494922+00
126	209	1	1	2577499.00	LCU	2017	2026-03-27 21:31:50.494922+00
127	58	1	1	95504.29	LCU	2017	2026-03-27 21:31:50.494922+00
128	168	1	1	17801.37	LCU	2017	2026-03-27 21:31:50.494922+00
129	131	1	1	1308.61	LCU	2017	2026-03-27 21:31:50.494922+00
130	18	1	1	2680.24	LCU	2016	2026-03-27 21:31:50.494922+00
131	40	1	1	146109.90	LCU	2016	2026-03-27 21:31:50.494922+00
132	226	1	1	5758.39	LCU	2016	2026-03-27 21:31:50.494922+00
133	220	1	1	758.78	LCU	2016	2026-03-27 21:31:50.494922+00
134	128	1	1	2121.45	LCU	2016	2026-03-27 21:31:50.494922+00
135	207	1	1	2310.03	LCU	2016	2026-03-27 21:31:50.494922+00
136	142	1	1	209429.10	LCU	2015	2026-03-27 21:31:50.494922+00
137	52	1	1	32193.00	LCU	2015	2026-03-27 21:31:50.494922+00
138	47	1	1	133259.80	LCU	2014	2026-03-27 21:31:50.494922+00
139	165	1	1	9897.55	LCU	2014	2026-03-27 21:31:50.494922+00
140	112	1	1	37139.63	LCU	2014	2026-03-27 21:31:50.494922+00
141	28	1	1	1799.40	LCU	2014	2026-03-27 21:31:50.494922+00
142	246	1	1	61426.08	LCU	2014	2026-03-27 21:31:50.494922+00
143	156	1	1	21062.00	LCU	2013	2026-03-27 21:31:50.494922+00
144	36	1	1	3740100.00	LCU	2012	2026-03-27 21:31:50.494922+00
145	195	1	1	8722.00	LCU	2012	2026-03-27 21:31:50.494922+00
146	16	1	1	331.50	LCU	2010	2026-03-27 21:31:50.494922+00
147	242	1	1	40547.15	LCU	2010	2026-03-27 21:31:50.494922+00
148	144	1	1	30225.00	LCU	2010	2026-03-27 21:31:50.494922+00
149	116	1	1	6161.30	LCU	2009	2026-03-27 21:31:50.494922+00
150	42	1	1	101095.20	LCU	2009	2026-03-27 21:31:50.494922+00
151	219	1	1	370.61	LCU	2009	2026-03-27 21:31:50.494922+00
152	125	1	1	60920.83	LCU	2008	2026-03-27 21:31:50.494922+00
153	169	1	1	9359.37	LCU	2006	2026-03-27 21:31:50.494922+00
154	191	1	1	12203.00	LCU	2006	2026-03-27 21:31:50.494922+00
155	194	1	1	14206.70	LCU	2005	2026-03-27 21:31:50.494922+00
156	49	2	1	10669.62	LCU	2025	2026-03-27 21:31:51.310087+00
157	184	2	1	6.60	LCU	2025	2026-03-27 21:31:51.310087+00
158	186	2	1	20529.92	LCU	2025	2026-03-27 21:31:51.310087+00
159	38	2	1	40.11	LCU	2025	2026-03-27 21:31:51.310087+00
160	77	2	1	21.67	LCU	2025	2026-03-27 21:31:51.310087+00
161	174	2	1	12.23	LCU	2025	2026-03-27 21:31:51.310087+00
162	31	2	1	20.97	LCU	2025	2026-03-27 21:31:51.310087+00
163	50	2	1	2145.19	LCU	2025	2026-03-27 21:31:51.310087+00
164	183	2	1	15.80	LCU	2025	2026-03-27 21:31:51.310087+00
165	63	2	1	2.50	LCU	2025	2026-03-27 21:31:51.310087+00
166	61	2	1	180.33	LCU	2025	2026-03-27 21:31:51.310087+00
167	97	2	1	45.29	LCU	2025	2026-03-27 21:31:51.310087+00
168	178	2	1	142.02	LCU	2025	2026-03-27 21:31:51.310087+00
169	233	2	1	43.49	LCU	2025	2026-03-27 21:31:51.310087+00
170	91	2	1	19.10	LCU	2024	2026-03-27 21:31:51.310087+00
171	65	2	1	32.67	LCU	2024	2026-03-27 21:31:51.310087+00
172	164	2	1	432.12	LCU	2024	2026-03-27 21:31:51.310087+00
173	145	2	1	1034.67	LCU	2024	2026-03-27 21:31:51.310087+00
174	105	2	1	48.58	LCU	2024	2026-03-27 21:31:51.310087+00
175	154	2	1	297.00	LCU	2024	2026-03-27 21:31:51.310087+00
176	147	2	1	8716.37	LCU	2024	2026-03-27 21:31:51.310087+00
177	157	2	1	60.16	LCU	2024	2026-03-27 21:31:51.310087+00
178	192	2	1	711.97	LCU	2024	2026-03-27 21:31:51.310087+00
179	71	2	1	5.64	LCU	2024	2026-03-27 21:31:51.310087+00
180	82	2	1	17.30	LCU	2024	2026-03-27 21:31:51.310087+00
181	173	2	1	7.37	LCU	2024	2026-03-27 21:31:51.310087+00
182	205	2	1	1113.01	LCU	2024	2026-03-27 21:31:51.310087+00
183	234	2	1	325.17	LCU	2024	2026-03-27 21:31:51.310087+00
184	19	2	1	59.68	LCU	2024	2026-03-27 21:31:51.310087+00
185	21	2	1	1475.90	LCU	2024	2026-03-27 21:31:51.310087+00
186	229	2	1	1872.10	LCU	2024	2026-03-27 21:31:51.310087+00
187	17	2	1	9.89	LCU	2024	2026-03-27 21:31:51.310087+00
188	225	2	1	182.49	LCU	2024	2026-03-27 21:31:51.310087+00
189	10	2	1	4353.15	LCU	2024	2026-03-27 21:31:51.310087+00
190	8	2	1	526.20	LCU	2024	2026-03-27 21:31:51.310087+00
191	132	2	1	16.08	LCU	2024	2026-03-27 21:31:51.310087+00
192	249	2	1	14.59	LCU	2024	2026-03-27 21:31:51.310087+00
193	241	2	1	35894.51	LCU	2024	2026-03-27 21:31:51.310087+00
194	43	2	1	59.11	LCU	2024	2026-03-27 21:31:51.310087+00
195	210	2	1	2.37	LCU	2024	2026-03-27 21:31:51.310087+00
196	139	2	1	40.34	LCU	2024	2026-03-27 21:31:51.310087+00
197	218	2	1	91.42	LCU	2024	2026-03-27 21:31:51.310087+00
198	46	2	1	4976.86	LCU	2024	2026-03-27 21:31:51.310087+00
199	29	2	1	23.53	LCU	2024	2026-03-27 21:31:51.310087+00
200	35	2	1	39.56	LCU	2024	2026-03-27 21:31:51.310087+00
201	130	2	1	166.05	LCU	2023	2026-03-27 21:31:51.310087+00
202	177	2	1	112.42	LCU	2023	2026-03-27 21:31:51.310087+00
203	224	2	1	11.70	LCU	2023	2026-03-27 21:31:51.310087+00
204	250	2	1	3010.20	LCU	2023	2026-03-27 21:31:51.310087+00
205	213	2	1	14.74	LCU	2023	2026-03-27 21:31:51.310087+00
206	113	2	1	1.83	LCU	2023	2026-03-27 21:31:51.310087+00
207	118	2	1	5.30	LCU	2023	2026-03-27 21:31:51.310087+00
208	45	2	1	75.76	LCU	2023	2026-03-27 21:31:51.310087+00
209	101	2	1	16329.81	LCU	2023	2026-03-27 21:31:51.310087+00
210	117	2	1	4615.92	LCU	2023	2026-03-27 21:31:51.310087+00
211	206	2	1	2.76	LCU	2022	2026-03-27 21:31:51.310087+00
212	196	2	1	1029.31	LCU	2022	2026-03-27 21:31:51.310087+00
213	33	2	1	91.58	LCU	2022	2026-03-27 21:31:51.310087+00
214	126	2	1	13408.28	LCU	2022	2026-03-27 21:31:51.310087+00
215	244	2	1	11.49	LCU	2022	2026-03-27 21:31:51.310087+00
216	69	2	1	30.46	LCU	2021	2026-03-27 21:31:51.310087+00
217	119	2	1	NaN	LCU	2021	2026-03-27 21:31:51.310087+00
218	221	2	1	4.60	LCU	2021	2026-03-27 21:31:51.310087+00
219	231	2	1	4175.97	LCU	2021	2026-03-27 21:31:51.310087+00
220	3	2	1	98.41	LCU	2020	2026-03-27 21:31:51.310087+00
221	89	2	1	6.06	LCU	2020	2026-03-27 21:31:51.310087+00
222	182	2	1	20.38	LCU	2020	2026-03-27 21:31:51.310087+00
223	75	2	1	15.17	LCU	2020	2026-03-27 21:31:51.310087+00
224	110	2	1	7.85	LCU	2020	2026-03-27 21:31:51.310087+00
225	146	2	1	1407.03	LCU	2020	2026-03-27 21:31:51.310087+00
226	44	2	1	1046.40	LCU	2019	2026-03-27 21:31:51.310087+00
227	243	2	1	1676.33	LCU	2019	2026-03-27 21:31:51.310087+00
228	155	2	1	55.32	LCU	2019	2026-03-27 21:31:51.310087+00
229	143	2	1	4.75	LCU	2019	2026-03-27 21:31:51.310087+00
230	115	2	1	57.55	LCU	2019	2026-03-27 21:31:51.310087+00
231	127	2	1	6700.37	LCU	2019	2026-03-27 21:31:51.310087+00
232	32	2	1	23.94	LCU	2019	2026-03-27 21:31:51.310087+00
233	37	2	1	5.78	LCU	2019	2026-03-27 21:31:51.310087+00
234	223	2	1	2.53	LCU	2019	2026-03-27 21:31:51.310087+00
235	151	2	1	495.23	LCU	2019	2026-03-27 21:31:51.310087+00
236	94	2	1	433.02	LCU	2019	2026-03-27 21:31:51.310087+00
237	85	2	1	23.24	LCU	2018	2026-03-27 21:31:51.310087+00
238	160	2	1	39.76	LCU	2018	2026-03-27 21:31:51.310087+00
239	4	2	1	15.95	LCU	2018	2026-03-27 21:31:51.310087+00
240	203	2	1	10699.79	LCU	2018	2026-03-27 21:31:51.310087+00
241	161	2	1	1713.18	LCU	2017	2026-03-27 21:31:51.310087+00
242	238	2	1	1660.09	LCU	2017	2026-03-27 21:31:51.310087+00
243	7	2	1	552.14	LCU	2017	2026-03-27 21:31:51.310087+00
244	131	2	1	2.05	LCU	2017	2026-03-27 21:31:51.310087+00
245	168	2	1	92.04	LCU	2017	2026-03-27 21:31:51.310087+00
246	220	2	1	2.85	LCU	2016	2026-03-27 21:31:51.310087+00
247	40	2	1	1572.98	LCU	2016	2026-03-27 21:31:51.310087+00
248	248	2	1	82.75	LCU	2015	2026-03-27 21:31:51.310087+00
249	142	2	1	1301.21	LCU	2015	2026-03-27 21:31:51.310087+00
250	24	2	1	478.82	LCU	2014	2026-03-27 21:31:51.310087+00
251	28	2	1	4.94	LCU	2014	2026-03-27 21:31:51.310087+00
252	246	2	1	401.70	LCU	2014	2026-03-27 21:31:51.310087+00
253	112	2	1	134.91	LCU	2014	2026-03-27 21:31:51.310087+00
254	156	2	1	233.70	LCU	2013	2026-03-27 21:31:51.310087+00
255	165	2	1	23.70	LCU	2012	2026-03-27 21:31:51.310087+00
256	25	2	1	223.39	LCU	2011	2026-03-27 21:31:51.310087+00
257	242	2	1	449.06	LCU	2010	2026-03-27 21:31:51.310087+00
258	42	2	1	605.83	LCU	2009	2026-03-27 21:31:51.310087+00
259	219	2	1	2.03	LCU	2009	2026-03-27 21:31:51.310087+00
260	189	3	1	4050.00	LCU	2025	2026-03-27 21:31:52.092859+00
261	153	3	1	961.00	LCU	2025	2026-03-27 21:31:52.092859+00
262	102	3	1	2282.00	LCU	2025	2026-03-27 21:31:52.092859+00
263	100	3	1	290800.00	LCU	2025	2026-03-27 21:31:52.092859+00
264	200	3	1	1278.00	LCU	2025	2026-03-27 21:31:52.092859+00
265	202	3	1	816.00	LCU	2025	2026-03-27 21:31:52.092859+00
266	190	3	1	72396.00	LCU	2025	2026-03-27 21:31:52.092859+00
267	98	3	1	970.00	LCU	2025	2026-03-27 21:31:52.092859+00
268	166	3	1	2246.00	LCU	2025	2026-03-27 21:31:52.092859+00
269	55	3	1	1000.00	LCU	2025	2026-03-27 21:31:52.092859+00
270	56	3	1	20800.00	LCU	2025	2026-03-27 21:31:52.092859+00
271	57	3	1	2161.00	LCU	2025	2026-03-27 21:31:52.092859+00
272	89	3	1	1027.00	LCU	2025	2026-03-27 21:31:52.092859+00
273	68	3	1	1381.00	LCU	2025	2026-03-27 21:31:52.092859+00
274	64	3	1	886.00	LCU	2025	2026-03-27 21:31:52.092859+00
275	184	3	1	1015.00	LCU	2025	2026-03-27 21:31:52.092859+00
276	75	3	1	1802.00	LCU	2025	2026-03-27 21:31:52.092859+00
277	140	3	1	670.00	LCU	2025	2026-03-27 21:31:52.092859+00
278	179	3	1	4666.00	LCU	2025	2026-03-27 21:31:52.092859+00
279	225	3	1	26006.00	LCU	2025	2026-03-27 21:31:52.092859+00
280	6	3	1	40000.00	LCU	2025	2026-03-27 21:31:52.092859+00
281	133	3	1	1038.00	LCU	2025	2026-03-27 21:31:52.092859+00
282	20	3	1	2112.00	LCU	2025	2026-03-27 21:31:52.092859+00
283	134	3	1	2704.00	LCU	2025	2026-03-27 21:31:52.092859+00
284	135	3	1	740.00	LCU	2025	2026-03-27 21:31:52.092859+00
285	144	3	1	36037.00	LCU	2025	2026-03-27 21:31:52.092859+00
286	139	3	1	5500.00	LCU	2025	2026-03-27 21:31:52.092859+00
287	233	3	1	1257.00	LCU	2025	2026-03-27 21:31:52.092859+00
288	22	3	1	551.00	LCU	2025	2026-03-27 21:31:52.092859+00
289	230	3	1	8000.00	LCU	2025	2026-03-27 21:31:52.092859+00
290	137	3	1	3120.00	LCU	2024	2026-03-27 21:31:52.092859+00
291	138	3	1	11.65	LCU	2024	2026-03-27 21:31:52.092859+00
292	178	3	1	37000.00	LCU	2024	2026-03-27 21:31:52.092859+00
293	172	3	1	325.00	LCU	2024	2026-03-27 21:31:52.092859+00
294	171	3	1	4009.58	LCU	2024	2026-03-27 21:31:52.092859+00
295	173	3	1	482.18	LCU	2024	2026-03-27 21:31:52.092859+00
296	174	3	1	1025.00	LCU	2024	2026-03-27 21:31:52.092859+00
297	177	3	1	8302.00	LCU	2024	2026-03-27 21:31:52.092859+00
298	142	3	1	262880.00	LCU	2024	2026-03-27 21:31:52.092859+00
299	165	3	1	7692.75	LCU	2024	2026-03-27 21:31:52.092859+00
300	168	3	1	17300.00	LCU	2024	2026-03-27 21:31:52.092859+00
301	146	3	1	124800.00	LCU	2024	2026-03-27 21:31:52.092859+00
302	164	3	1	65000.00	LCU	2024	2026-03-27 21:31:52.092859+00
303	157	3	1	6467.20	LCU	2024	2026-03-27 21:31:52.092859+00
304	162	3	1	42000.00	LCU	2024	2026-03-27 21:31:52.092859+00
305	143	3	1	624.00	LCU	2024	2026-03-27 21:31:52.092859+00
306	161	3	1	166536.00	LCU	2024	2026-03-27 21:31:52.092859+00
307	185	3	1	883.00	LCU	2024	2026-03-27 21:31:52.092859+00
308	156	3	1	90000.00	LCU	2024	2026-03-27 21:31:52.092859+00
309	154	3	1	15000.00	LCU	2024	2026-03-27 21:31:52.092859+00
310	159	3	1	9497.50	LCU	2024	2026-03-27 21:31:52.092859+00
311	147	3	1	660000.00	LCU	2024	2026-03-27 21:31:52.092859+00
312	145	3	1	40000.00	LCU	2024	2026-03-27 21:31:52.092859+00
313	158	3	1	1500.00	LCU	2024	2026-03-27 21:31:52.092859+00
314	3	3	1	5500.00	LCU	2024	2026-03-27 21:31:52.092859+00
315	176	3	1	728.00	LCU	2024	2026-03-27 21:31:52.092859+00
316	218	3	1	8963.00	LCU	2024	2026-03-27 21:31:52.092859+00
317	222	3	1	1280.00	LCU	2024	2026-03-27 21:31:52.092859+00
318	221	3	1	115.00	LCU	2024	2026-03-27 21:31:52.092859+00
319	226	3	1	3550.00	LCU	2024	2026-03-27 21:31:52.092859+00
320	223	3	1	491.50	LCU	2024	2026-03-27 21:31:52.092859+00
321	228	3	1	27400.00	LCU	2024	2026-03-27 21:31:52.092859+00
322	229	3	1	150000.00	LCU	2024	2026-03-27 21:31:52.092859+00
323	231	3	1	130000.00	LCU	2024	2026-03-27 21:31:52.092859+00
324	234	3	1	22268.00	LCU	2024	2026-03-27 21:31:52.092859+00
325	235	3	1	1050000.00	LCU	2024	2026-03-27 21:31:52.092859+00
326	237	3	1	1310.00	LCU	2024	2026-03-27 21:31:52.092859+00
327	238	3	1	130.00	LCU	2024	2026-03-27 21:31:52.092859+00
328	241	3	1	4960000.00	LCU	2024	2026-03-27 21:31:52.092859+00
329	242	3	1	57165.00	LCU	2024	2026-03-27 21:31:52.092859+00
330	244	3	1	832.00	LCU	2024	2026-03-27 21:31:52.092859+00
331	248	3	1	4776.85	LCU	2024	2026-03-27 21:31:52.092859+00
332	219	3	1	800.00	LCU	2024	2026-03-27 21:31:52.092859+00
333	217	3	1	52500.00	LCU	2024	2026-03-27 21:31:52.092859+00
334	186	3	1	2798309.00	LCU	2024	2026-03-27 21:31:52.092859+00
335	215	3	1	60000.00	LCU	2024	2026-03-27 21:31:52.092859+00
336	187	3	1	1000.00	LCU	2024	2026-03-27 21:31:52.092859+00
337	130	3	1	17500.00	LCU	2024	2026-03-27 21:31:52.092859+00
338	191	3	1	19242.00	LCU	2024	2026-03-27 21:31:52.092859+00
339	192	3	1	2600.00	LCU	2024	2026-03-27 21:31:52.092859+00
340	193	3	1	4000.00	LCU	2024	2026-03-27 21:31:52.092859+00
341	196	3	1	425.00	LCU	2024	2026-03-27 21:31:52.092859+00
342	205	3	1	64175.00	LCU	2024	2026-03-27 21:31:52.092859+00
343	194	3	1	1664.00	LCU	2024	2026-03-27 21:31:52.092859+00
344	203	3	1	800.00	LCU	2024	2026-03-27 21:31:52.092859+00
345	210	3	1	365.00	LCU	2024	2026-03-27 21:31:52.092859+00
346	204	3	1	1728.38	LCU	2024	2026-03-27 21:31:52.092859+00
347	207	3	1	4160.00	LCU	2024	2026-03-27 21:31:52.092859+00
348	213	3	1	600.00	LCU	2024	2026-03-27 21:31:52.092859+00
349	195	3	1	6628.36	LCU	2024	2026-03-27 21:31:52.092859+00
350	212	3	1	14760.00	LCU	2024	2026-03-27 21:31:52.092859+00
351	132	3	1	1881.00	LCU	2024	2026-03-27 21:31:52.092859+00
352	122	3	1	2060740.00	LCU	2024	2026-03-27 21:31:52.092859+00
353	136	3	1	1000.00	LCU	2024	2026-03-27 21:31:52.092859+00
354	35	3	1	1883.03	LCU	2024	2026-03-27 21:31:52.092859+00
355	38	3	1	2884.00	LCU	2024	2026-03-27 21:31:52.092859+00
356	43	3	1	4212.22	LCU	2024	2026-03-27 21:31:52.092859+00
357	46	3	1	500000.00	LCU	2024	2026-03-27 21:31:52.092859+00
358	48	3	1	1930.00	LCU	2024	2026-03-27 21:31:52.092859+00
359	44	3	1	75000.00	LCU	2024	2026-03-27 21:31:52.092859+00
360	47	3	1	43969.00	LCU	2024	2026-03-27 21:31:52.092859+00
361	40	3	1	183950.00	LCU	2024	2026-03-27 21:31:52.092859+00
362	42	3	1	120000.00	LCU	2024	2026-03-27 21:31:52.092859+00
363	45	3	1	1974.00	LCU	2024	2026-03-27 21:31:52.092859+00
364	49	3	1	1300000.00	LCU	2024	2026-03-27 21:31:52.092859+00
365	119	3	1	55000.00	LCU	2024	2026-03-27 21:31:52.092859+00
366	52	3	1	15000.00	LCU	2024	2026-03-27 21:31:52.092859+00
367	50	3	1	358609.00	LCU	2024	2026-03-27 21:31:52.092859+00
368	51	3	1	2100.00	LCU	2024	2026-03-27 21:31:52.092859+00
369	60	3	1	1560.00	LCU	2024	2026-03-27 21:31:52.092859+00
370	61	3	1	19450.00	LCU	2024	2026-03-27 21:31:52.092859+00
371	62	3	1	20000.00	LCU	2024	2026-03-27 21:31:52.092859+00
372	41	3	1	35000.00	LCU	2024	2026-03-27 21:31:52.092859+00
373	33	3	1	3750.00	LCU	2024	2026-03-27 21:31:52.092859+00
374	131	3	1	91.00	LCU	2024	2026-03-27 21:31:52.092859+00
375	18	3	1	1473.33	LCU	2024	2026-03-27 21:31:52.092859+00
376	1	3	1	1376.27	LCU	2024	2026-03-27 21:31:52.092859+00
377	10	3	1	271571.00	LCU	2024	2026-03-27 21:31:52.092859+00
378	7	3	1	75000.00	LCU	2024	2026-03-27 21:31:52.092859+00
379	4	3	1	1558.80	LCU	2024	2026-03-27 21:31:52.092859+00
380	13	3	1	4023.44	LCU	2024	2026-03-27 21:31:52.092859+00
381	16	3	1	345.00	LCU	2024	2026-03-27 21:31:52.092859+00
382	24	3	1	4156.80	LCU	2024	2026-03-27 21:31:52.092859+00
383	25	3	1	52000.00	LCU	2024	2026-03-27 21:31:52.092859+00
384	21	3	1	45000.00	LCU	2024	2026-03-27 21:31:52.092859+00
385	19	3	1	12500.00	LCU	2024	2026-03-27 21:31:52.092859+00
386	23	3	1	300.00	LCU	2024	2026-03-27 21:31:52.092859+00
387	32	3	1	1125.80	LCU	2024	2026-03-27 21:31:52.092859+00
388	17	3	1	626.00	LCU	2024	2026-03-27 21:31:52.092859+00
389	36	3	1	626.00	LCU	2024	2026-03-27 21:31:52.092859+00
390	37	3	1	1039.20	LCU	2024	2026-03-27 21:31:52.092859+00
391	29	3	1	2500.00	LCU	2024	2026-03-27 21:31:52.092859+00
392	31	3	1	1412.00	LCU	2024	2026-03-27 21:31:52.092859+00
393	63	3	1	470.00	LCU	2024	2026-03-27 21:31:52.092859+00
394	65	3	1	6000.00	LCU	2024	2026-03-27 21:31:52.092859+00
395	107	3	1	350000.00	LCU	2024	2026-03-27 21:31:52.092859+00
396	105	3	1	4628.00	LCU	2024	2026-03-27 21:31:52.092859+00
397	109	3	1	425985.00	LCU	2024	2026-03-27 21:31:52.092859+00
398	103	3	1	5880.02	LCU	2024	2026-03-27 21:31:52.092859+00
399	112	3	1	64950.00	LCU	2024	2026-03-27 21:31:52.092859+00
400	113	3	1	260.00	LCU	2024	2026-03-27 21:31:52.092859+00
401	114	3	1	182726.00	LCU	2024	2026-03-27 21:31:52.092859+00
402	125	3	1	85000.00	LCU	2024	2026-03-27 21:31:52.092859+00
403	115	3	1	16033.14	LCU	2024	2026-03-27 21:31:52.092859+00
404	116	3	1	2534.00	LCU	2024	2026-03-27 21:31:52.092859+00
405	117	3	1	200.00	LCU	2024	2026-03-27 21:31:52.092859+00
406	118	3	1	270.40	LCU	2024	2026-03-27 21:31:52.092859+00
407	120	3	1	1560.00	LCU	2024	2026-03-27 21:31:52.092859+00
408	8	3	1	70000.00	LCU	2024	2026-03-27 21:31:52.092859+00
409	123	3	1	75.00	LCU	2024	2026-03-27 21:31:52.092859+00
410	126	3	1	1600000.00	LCU	2024	2026-03-27 21:31:52.092859+00
411	127	3	1	18000000.00	LCU	2024	2026-03-27 21:31:52.092859+00
412	108	3	1	53073300.00	LCU	2024	2026-03-27 21:31:52.092859+00
413	249	3	1	1300.00	LCU	2024	2026-03-27 21:31:52.092859+00
414	101	3	1	5067381.00	LCU	2024	2026-03-27 21:31:52.092859+00
415	82	3	1	471.53	LCU	2024	2026-03-27 21:31:52.092859+00
416	71	3	1	935.28	LCU	2024	2026-03-27 21:31:52.092859+00
417	99	3	1	17810.00	LCU	2024	2026-03-27 21:31:52.092859+00
418	97	3	1	11507.77	LCU	2024	2026-03-27 21:31:52.092859+00
419	95	3	1	40.00	LCU	2024	2026-03-27 21:31:52.092859+00
420	76	3	1	150000.00	LCU	2024	2026-03-27 21:31:52.092859+00
421	94	3	1	60147.00	LCU	2024	2026-03-27 21:31:52.092859+00
422	91	3	1	3343.01	LCU	2024	2026-03-27 21:31:52.092859+00
423	78	3	1	1200.00	LCU	2024	2026-03-27 21:31:52.092859+00
424	77	3	1	1981.40	LCU	2024	2026-03-27 21:31:52.092859+00
425	93	3	1	19030.00	LCU	2024	2026-03-27 21:31:52.092859+00
426	79	3	1	20.00	LCU	2024	2026-03-27 21:31:52.092859+00
427	85	3	1	1300.00	LCU	2024	2026-03-27 21:31:52.092859+00
428	86	3	1	550000.00	LCU	2024	2026-03-27 21:31:52.092859+00
429	88	3	1	117304.00	LCU	2023	2026-03-27 21:31:52.092859+00
430	155	3	1	5700.00	LCU	2022	2026-03-27 21:31:52.092859+00
431	151	3	1	3000.00	LCU	2022	2026-03-27 21:31:52.092859+00
432	111	3	1	6.97	LCU	2016	2026-03-27 21:31:52.092859+00
433	183	3	1	1450.00	LCU	2013	2026-03-27 21:31:52.092859+00
434	69	3	1	420.00	LCU	2011	2026-03-27 21:31:52.092859+00
435	3	5	1	35.58	HRS	2027	2026-03-27 21:31:52.950171+00
436	242	5	1	28.31	HRS	2027	2026-03-27 21:31:52.950171+00
437	244	5	1	45.09	HRS	2027	2026-03-27 21:31:52.950171+00
438	241	5	1	41.73	HRS	2027	2026-03-27 21:31:52.950171+00
439	121	5	1	41.84	HRS	2027	2026-03-27 21:31:52.950171+00
440	240	5	1	35.76	HRS	2027	2026-03-27 21:31:52.950171+00
441	238	5	1	38.21	HRS	2027	2026-03-27 21:31:52.950171+00
442	237	5	1	40.08	HRS	2027	2026-03-27 21:31:52.950171+00
443	235	5	1	40.94	HRS	2027	2026-03-27 21:31:52.950171+00
444	233	5	1	36.26	HRS	2027	2026-03-27 21:31:52.950171+00
445	234	5	1	33.68	HRS	2027	2026-03-27 21:31:52.950171+00
446	231	5	1	41.67	HRS	2027	2026-03-27 21:31:52.950171+00
447	229	5	1	40.03	HRS	2027	2026-03-27 21:31:52.950171+00
448	228	5	1	38.90	HRS	2027	2026-03-27 21:31:52.950171+00
449	209	5	1	48.99	HRS	2027	2026-03-27 21:31:52.950171+00
450	8	5	1	42.88	HRS	2027	2026-03-27 21:31:52.950171+00
451	175	5	1	35.33	HRS	2027	2026-03-27 21:31:52.950171+00
452	187	5	1	45.17	HRS	2027	2026-03-27 21:31:52.950171+00
453	189	5	1	38.47	HRS	2027	2026-03-27 21:31:52.950171+00
454	191	5	1	38.19	HRS	2027	2026-03-27 21:31:52.950171+00
455	192	5	1	29.28	HRS	2027	2026-03-27 21:31:52.950171+00
456	193	5	1	40.77	HRS	2027	2026-03-27 21:31:52.950171+00
457	205	5	1	45.64	HRS	2027	2026-03-27 21:31:52.950171+00
458	198	5	1	44.63	HRS	2027	2026-03-27 21:31:52.950171+00
459	194	5	1	34.94	HRS	2027	2026-03-27 21:31:52.950171+00
460	203	5	1	42.93	HRS	2027	2026-03-27 21:31:52.950171+00
461	210	5	1	42.90	HRS	2027	2026-03-27 21:31:52.950171+00
462	206	5	1	30.50	HRS	2027	2026-03-27 21:31:52.950171+00
463	190	5	1	37.27	HRS	2027	2026-03-27 21:31:52.950171+00
464	207	5	1	40.17	HRS	2027	2026-03-27 21:31:52.950171+00
465	225	5	1	42.81	HRS	2027	2026-03-27 21:31:52.950171+00
466	202	5	1	33.88	HRS	2027	2026-03-27 21:31:52.950171+00
467	200	5	1	33.30	HRS	2027	2026-03-27 21:31:52.950171+00
468	197	5	1	29.20	HRS	2027	2026-03-27 21:31:52.950171+00
469	213	5	1	41.20	HRS	2027	2026-03-27 21:31:52.950171+00
470	212	5	1	27.28	HRS	2027	2026-03-27 21:31:52.950171+00
471	215	5	1	30.55	HRS	2027	2026-03-27 21:31:52.950171+00
472	217	5	1	37.86	HRS	2027	2026-03-27 21:31:52.950171+00
473	218	5	1	42.18	HRS	2027	2026-03-27 21:31:52.950171+00
474	219	5	1	40.99	HRS	2027	2026-03-27 21:31:52.950171+00
475	222	5	1	41.50	HRS	2027	2026-03-27 21:31:52.950171+00
476	221	5	1	33.58	HRS	2027	2026-03-27 21:31:52.950171+00
477	224	5	1	30.79	HRS	2027	2026-03-27 21:31:52.950171+00
478	226	5	1	38.28	HRS	2027	2026-03-27 21:31:52.950171+00
479	223	5	1	44.13	HRS	2027	2026-03-27 21:31:52.950171+00
480	246	5	1	23.37	HRS	2027	2026-03-27 21:31:52.950171+00
481	248	5	1	41.07	HRS	2027	2026-03-27 21:31:52.950171+00
482	249	5	1	42.47	HRS	2027	2026-03-27 21:31:52.950171+00
483	184	5	1	33.46	HRS	2027	2026-03-27 21:31:52.950171+00
484	186	5	1	41.34	HRS	2027	2026-03-27 21:31:52.950171+00
485	182	5	1	38.30	HRS	2027	2026-03-27 21:31:52.950171+00
486	58	5	1	30.74	HRS	2027	2026-03-27 21:31:52.950171+00
487	67	5	1	39.81	HRS	2027	2026-03-27 21:31:52.950171+00
488	65	5	1	44.10	HRS	2027	2026-03-27 21:31:52.950171+00
489	63	5	1	37.16	HRS	2027	2026-03-27 21:31:52.950171+00
490	62	5	1	43.27	HRS	2027	2026-03-27 21:31:52.950171+00
491	61	5	1	39.17	HRS	2027	2026-03-27 21:31:52.950171+00
492	59	5	1	28.91	HRS	2027	2026-03-27 21:31:52.950171+00
493	57	5	1	29.66	HRS	2027	2026-03-27 21:31:52.950171+00
494	42	5	1	48.85	HRS	2027	2026-03-27 21:31:52.950171+00
495	56	5	1	34.48	HRS	2027	2026-03-27 21:31:52.950171+00
496	55	5	1	35.41	HRS	2027	2026-03-27 21:31:52.950171+00
497	51	5	1	40.83	HRS	2027	2026-03-27 21:31:52.950171+00
498	50	5	1	42.02	HRS	2027	2026-03-27 21:31:52.950171+00
499	52	5	1	46.19	HRS	2027	2026-03-27 21:31:52.950171+00
500	119	5	1	37.41	HRS	2027	2026-03-27 21:31:52.950171+00
501	66	5	1	42.31	HRS	2027	2026-03-27 21:31:52.950171+00
502	68	5	1	31.94	HRS	2027	2026-03-27 21:31:52.950171+00
503	64	5	1	31.60	HRS	2027	2026-03-27 21:31:52.950171+00
504	69	5	1	31.07	HRS	2027	2026-03-27 21:31:52.950171+00
505	70	5	1	29.10	HRS	2027	2026-03-27 21:31:52.950171+00
506	71	5	1	37.17	HRS	2027	2026-03-27 21:31:52.950171+00
507	75	5	1	30.87	HRS	2027	2026-03-27 21:31:52.950171+00
508	76	5	1	42.30	HRS	2027	2026-03-27 21:31:52.950171+00
509	77	5	1	31.17	HRS	2027	2026-03-27 21:31:52.950171+00
510	79	5	1	37.58	HRS	2027	2026-03-27 21:31:52.950171+00
511	82	5	1	32.68	HRS	2027	2026-03-27 21:31:52.950171+00
512	86	5	1	40.73	HRS	2027	2026-03-27 21:31:52.950171+00
513	85	5	1	37.83	HRS	2027	2026-03-27 21:31:52.950171+00
514	93	5	1	42.92	HRS	2027	2026-03-27 21:31:52.950171+00
515	88	5	1	44.80	HRS	2027	2026-03-27 21:31:52.950171+00
516	89	5	1	38.26	HRS	2027	2026-03-27 21:31:52.950171+00
517	91	5	1	41.40	HRS	2027	2026-03-27 21:31:52.950171+00
518	49	5	1	42.37	HRS	2027	2026-03-27 21:31:52.950171+00
519	40	5	1	35.91	HRS	2027	2026-03-27 21:31:52.950171+00
520	94	5	1	43.27	HRS	2027	2026-03-27 21:31:52.950171+00
521	24	5	1	40.96	HRS	2027	2026-03-27 21:31:52.950171+00
522	23	5	1	40.17	HRS	2027	2026-03-27 21:31:52.950171+00
523	22	5	1	37.59	HRS	2027	2026-03-27 21:31:52.950171+00
524	19	5	1	46.53	HRS	2027	2026-03-27 21:31:52.950171+00
525	21	5	1	48.18	HRS	2027	2026-03-27 21:31:52.950171+00
526	25	5	1	42.03	HRS	2027	2026-03-27 21:31:52.950171+00
527	20	5	1	31.42	HRS	2027	2026-03-27 21:31:52.950171+00
528	16	5	1	34.50	HRS	2027	2026-03-27 21:31:52.950171+00
529	47	5	1	42.29	HRS	2027	2026-03-27 21:31:52.950171+00
530	12	5	1	29.15	HRS	2027	2026-03-27 21:31:52.950171+00
531	13	5	1	31.28	HRS	2027	2026-03-27 21:31:52.950171+00
532	7	5	1	38.34	HRS	2027	2026-03-27 21:31:52.950171+00
533	10	5	1	34.99	HRS	2027	2026-03-27 21:31:52.950171+00
534	2	5	1	48.28	HRS	2027	2026-03-27 21:31:52.950171+00
535	6	5	1	41.41	HRS	2027	2026-03-27 21:31:52.950171+00
536	32	5	1	36.64	HRS	2027	2026-03-27 21:31:52.950171+00
537	17	5	1	40.81	HRS	2027	2026-03-27 21:31:52.950171+00
538	36	5	1	36.05	HRS	2027	2026-03-27 21:31:52.950171+00
539	37	5	1	40.03	HRS	2027	2026-03-27 21:31:52.950171+00
540	29	5	1	37.89	HRS	2027	2026-03-27 21:31:52.950171+00
541	31	5	1	38.08	HRS	2027	2026-03-27 21:31:52.950171+00
542	18	5	1	34.47	HRS	2027	2026-03-27 21:31:52.950171+00
543	28	5	1	44.75	HRS	2027	2026-03-27 21:31:52.950171+00
544	33	5	1	54.67	HRS	2027	2026-03-27 21:31:52.950171+00
545	35	5	1	43.32	HRS	2027	2026-03-27 21:31:52.950171+00
546	41	5	1	39.94	HRS	2027	2026-03-27 21:31:52.950171+00
547	38	5	1	31.86	HRS	2027	2026-03-27 21:31:52.950171+00
548	43	5	1	34.61	HRS	2027	2026-03-27 21:31:52.950171+00
549	46	5	1	36.38	HRS	2027	2026-03-27 21:31:52.950171+00
550	48	5	1	44.65	HRS	2027	2026-03-27 21:31:52.950171+00
551	44	5	1	41.45	HRS	2027	2026-03-27 21:31:52.950171+00
552	92	5	1	37.93	HRS	2027	2026-03-27 21:31:52.950171+00
553	95	5	1	42.99	HRS	2027	2026-03-27 21:31:52.950171+00
554	179	5	1	36.31	HRS	2027	2026-03-27 21:31:52.950171+00
555	158	5	1	44.55	HRS	2027	2026-03-27 21:31:52.950171+00
556	139	5	1	37.40	HRS	2027	2026-03-27 21:31:52.950171+00
557	142	5	1	34.74	HRS	2027	2026-03-27 21:31:52.950171+00
558	155	5	1	45.86	HRS	2027	2026-03-27 21:31:52.950171+00
559	157	5	1	41.09	HRS	2027	2026-03-27 21:31:52.950171+00
560	144	5	1	37.23	HRS	2027	2026-03-27 21:31:52.950171+00
561	145	5	1	43.73	HRS	2027	2026-03-27 21:31:52.950171+00
562	153	5	1	33.74	HRS	2027	2026-03-27 21:31:52.950171+00
563	146	5	1	42.53	HRS	2027	2026-03-27 21:31:52.950171+00
564	140	5	1	43.51	HRS	2027	2026-03-27 21:31:52.950171+00
565	147	5	1	46.62	HRS	2027	2026-03-27 21:31:52.950171+00
566	159	5	1	32.49	HRS	2027	2026-03-27 21:31:52.950171+00
567	151	5	1	39.52	HRS	2027	2026-03-27 21:31:52.950171+00
568	154	5	1	38.32	HRS	2027	2026-03-27 21:31:52.950171+00
569	156	5	1	30.75	HRS	2027	2026-03-27 21:31:52.950171+00
570	160	5	1	42.08	HRS	2027	2026-03-27 21:31:52.950171+00
571	148	5	1	45.56	HRS	2027	2026-03-27 21:31:52.950171+00
572	161	5	1	35.33	HRS	2027	2026-03-27 21:31:52.950171+00
573	162	5	1	39.96	HRS	2027	2026-03-27 21:31:52.950171+00
574	164	5	1	39.52	HRS	2027	2026-03-27 21:31:52.950171+00
575	165	5	1	35.91	HRS	2027	2026-03-27 21:31:52.950171+00
576	166	5	1	26.57	HRS	2027	2026-03-27 21:31:52.950171+00
577	167	5	1	26.58	HRS	2027	2026-03-27 21:31:52.950171+00
578	168	5	1	41.11	HRS	2027	2026-03-27 21:31:52.950171+00
579	171	5	1	33.48	HRS	2027	2026-03-27 21:31:52.950171+00
580	172	5	1	44.05	HRS	2027	2026-03-27 21:31:52.950171+00
581	178	5	1	47.62	HRS	2027	2026-03-27 21:31:52.950171+00
582	173	5	1	36.00	HRS	2027	2026-03-27 21:31:52.950171+00
583	174	5	1	37.94	HRS	2027	2026-03-27 21:31:52.950171+00
584	177	5	1	39.74	HRS	2027	2026-03-27 21:31:52.950171+00
585	176	5	1	40.83	HRS	2027	2026-03-27 21:31:52.950171+00
586	97	5	1	44.20	HRS	2027	2026-03-27 21:31:52.950171+00
587	137	5	1	44.19	HRS	2027	2026-03-27 21:31:52.950171+00
588	135	5	1	34.99	HRS	2027	2026-03-27 21:31:52.950171+00
589	125	5	1	37.99	HRS	2027	2026-03-27 21:31:52.950171+00
590	98	5	1	33.86	HRS	2027	2026-03-27 21:31:52.950171+00
591	99	5	1	41.46	HRS	2027	2026-03-27 21:31:52.950171+00
592	100	5	1	34.83	HRS	2027	2026-03-27 21:31:52.950171+00
593	101	5	1	37.67	HRS	2027	2026-03-27 21:31:52.950171+00
594	105	5	1	45.68	HRS	2027	2026-03-27 21:31:52.950171+00
595	102	5	1	30.44	HRS	2027	2026-03-27 21:31:52.950171+00
596	108	5	1	45.99	HRS	2027	2026-03-27 21:31:52.950171+00
597	107	5	1	30.35	HRS	2027	2026-03-27 21:31:52.950171+00
598	109	5	1	32.37	HRS	2027	2026-03-27 21:31:52.950171+00
599	103	5	1	34.96	HRS	2027	2026-03-27 21:31:52.950171+00
600	110	5	1	33.90	HRS	2027	2026-03-27 21:31:52.950171+00
601	112	5	1	43.47	HRS	2027	2026-03-27 21:31:52.950171+00
602	113	5	1	48.49	HRS	2027	2026-03-27 21:31:52.950171+00
603	114	5	1	31.10	HRS	2027	2026-03-27 21:31:52.950171+00
604	115	5	1	38.87	HRS	2027	2026-03-27 21:31:52.950171+00
605	136	5	1	42.44	HRS	2027	2026-03-27 21:31:52.950171+00
606	134	5	1	32.14	HRS	2027	2026-03-27 21:31:52.950171+00
607	133	5	1	35.35	HRS	2027	2026-03-27 21:31:52.950171+00
608	132	5	1	49.98	HRS	2027	2026-03-27 21:31:52.950171+00
609	130	5	1	39.45	HRS	2027	2026-03-27 21:31:52.950171+00
610	128	5	1	40.31	HRS	2027	2026-03-27 21:31:52.950171+00
611	131	5	1	48.11	HRS	2027	2026-03-27 21:31:52.950171+00
612	126	5	1	41.51	HRS	2027	2026-03-27 21:31:52.950171+00
613	123	5	1	45.74	HRS	2027	2026-03-27 21:31:52.950171+00
614	122	5	1	37.29	HRS	2027	2026-03-27 21:31:52.950171+00
615	117	5	1	46.17	HRS	2027	2026-03-27 21:31:52.950171+00
616	116	5	1	38.43	HRS	2027	2026-03-27 21:31:52.950171+00
617	250	5	1	44.42	HRS	2027	2026-03-27 21:31:52.950171+00
618	127	5	1	46.77	HRS	2023	2026-03-27 21:31:52.950171+00
619	208	5	1	37.60	HRS	2023	2026-03-27 21:31:52.950171+00
620	196	5	1	50.76	HRS	2022	2026-03-27 21:31:52.950171+00
621	183	5	1	39.68	HRS	2022	2026-03-27 21:31:52.950171+00
622	230	5	1	39.11	HRS	2021	2026-03-27 21:31:52.950171+00
\.


--
-- Data for Name: price_history; Type: TABLE DATA; Schema: public; Owner: pc_app_admin
--

COPY public.price_history (id_history, sku, id_source, id_country, price, unit_label, collection_timestamp) FROM stdin;
1	COCA_ZERO_12P	2	233	8.42	USD	2026-03-27 21:31:52.96414+00
2	COCA_ZERO_12P	2	68	9.96	EUR	2026-03-27 21:31:52.96414+00
3	COCA_ZERO_24P	2	114	11.55	JPY	2026-03-27 21:31:52.96414+00
4	COCA_ZERO_24P	2	105	2899.00	INR	2026-03-27 21:31:52.96414+00
5	HAVAIANAS_TOP	2	31	32.90	BRL	2026-03-27 21:31:52.96414+00
6	HAVAIANAS_TOP	2	233	18.99	USD	2026-03-27 21:31:52.96414+00
7	HAVAIANAS_TOP	2	68	21.09	EUR	2026-03-27 21:31:52.96414+00
8	HAVAIANAS_TOP	2	114	73.78	JPY	2026-03-27 21:31:52.96414+00
9	HAVAIANAS_TOP	2	105	4206.00	INR	2026-03-27 21:31:52.96414+00
10	LEGO_CLASSIC_10698	2	233	39.49	USD	2026-03-27 21:31:52.96414+00
11	LEGO_CLASSIC_10698	2	68	42.49	EUR	2026-03-27 21:31:52.96414+00
12	LEGO_CLASSIC_10698	2	114	29.60	JPY	2026-03-27 21:31:52.96414+00
13	LEGO_CLASSIC_10698	2	105	6179.00	INR	2026-03-27 21:31:52.96414+00
14	AIRPODS_PRO_3	2	31	2179.00	BRL	2026-03-27 21:31:52.96414+00
15	AIRPODS_PRO_3	2	233	199.99	USD	2026-03-27 21:31:52.96414+00
16	AIRPODS_PRO_3	2	68	219.00	EUR	2026-03-27 21:31:52.96414+00
17	AIRPODS_PRO_3	2	114	37166.00	JPY	2026-03-27 21:31:52.96414+00
\.


--
-- Data for Name: product_asins; Type: TABLE DATA; Schema: public; Owner: pc_app_admin
--

COPY public.product_asins (sku, id_country, search_code) FROM stdin;
COCA_ZERO_12P	31	B0CKWDGDXJ
COCA_ZERO_12P	233	B000OV0S84
COCA_ZERO_12P	68	B004MIB4OW
COCA_ZERO_24P	114	B001SES0DQ
COCA_ZERO_24P	105	B0839JSQ62
HAVAIANAS_TOP	31	B000YKO2LE
HAVAIANAS_TOP	233	B000YKO2LE
HAVAIANAS_TOP	68	B09XJH7V2Y
HAVAIANAS_TOP	114	B076B5W92X
HAVAIANAS_TOP	105	B003AOP0V2
LEGO_CLASSIC_10698	233	B00NHQF6MG
LEGO_CLASSIC_10698	31	B07MMHRVX6
LEGO_CLASSIC_10698	68	B00PY3EYQO
LEGO_CLASSIC_10698	114	B00PY3EYQO
LEGO_CLASSIC_10698	105	B00PY3EYQO
AIRPODS_PRO_3	31	B0FQGMGVCT
AIRPODS_PRO_3	233	B0FQFB8FMG
AIRPODS_PRO_3	68	B0FQF32239
AIRPODS_PRO_3	114	B0FQFQDN6K
AIRPODS_PRO_3	105	B0FQFJBBVY
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: pc_app_admin
--

COPY public.products (sku, product_name, search_term, description, id_category) FROM stdin;
COCA_ZERO_12P	Coca-Cola Zero Sugar (12 Pack)	Coca-Cola Zero Sugar 12 Pack	\N	2
COCA_ZERO_24P	Coca-Cola Zero Sugar (24 Pack)	Coca-Cola Zero Sugar 24 Pack	\N	2
HAVAIANAS_TOP	Havaianas Top	Havaianas Top	\N	5
LEGO_CLASSIC_10698	LEGO Classic 10698	LEGO Classic 10698	\N	7
AIRPODS_PRO_3	Apple AirPods Pro 3	Apple AirPods Pro 3	\N	1
\.


--
-- Data for Name: sources; Type: TABLE DATA; Schema: public; Owner: pc_app_admin
--

COPY public.sources (id_source, source_name) FROM stdin;
1	ILOSTAT API
2	Canopy
\.


--
-- Data for Name: staging_labor_indicators; Type: TABLE DATA; Schema: public; Owner: pc_app_admin
--

COPY public.staging_labor_indicators (iso_3_code, indicator_code, indicator_value, reference_year, unit_label) FROM stdin;
AFG	HOW_2EMP_SEX_NB	35.58	2027	HRS
VUT	HOW_2EMP_SEX_NB	28.31	2027	HRS
X05	HOW_2EMP_SEX_NB	34.74	2027	HRS
X04	HOW_2EMP_SEX_NB	42.27	2027	HRS
X03	HOW_2EMP_SEX_NB	43.9	2027	HRS
X02	HOW_2EMP_SEX_NB	36.4	2027	HRS
X01	HOW_2EMP_SEX_NB	40.95	2027	HRS
WSM	HOW_2EMP_SEX_NB	45.09	2027	HRS
VNM	HOW_2EMP_SEX_NB	41.73	2027	HRS
PRK	HOW_2EMP_SEX_NB	41.84	2027	HRS
VIR	HOW_2EMP_SEX_NB	35.76	2027	HRS
VEN	HOW_2EMP_SEX_NB	38.21	2027	HRS
VCT	HOW_2EMP_SEX_NB	40.08	2027	HRS
UZB	HOW_2EMP_SEX_NB	40.94	2027	HRS
USA	HOW_2EMP_SEX_NB	36.26	2027	HRS
URY	HOW_2EMP_SEX_NB	33.68	2027	HRS
X06	HOW_2EMP_SEX_NB	39.15	2027	HRS
X07	HOW_2EMP_SEX_NB	36.66	2027	HRS
X08	HOW_2EMP_SEX_NB	40.76	2027	HRS
X09	HOW_2EMP_SEX_NB	42.03	2027	HRS
X10	HOW_2EMP_SEX_NB	44.78	2027	HRS
X11	HOW_2EMP_SEX_NB	44.12	2027	HRS
X12	HOW_2EMP_SEX_NB	43.14	2027	HRS
X13	HOW_2EMP_SEX_NB	38.34	2027	HRS
X14	HOW_2EMP_SEX_NB	36.04	2027	HRS
X15	HOW_2EMP_SEX_NB	40.14	2027	HRS
X16	HOW_2EMP_SEX_NB	41.3	2027	HRS
X17	HOW_2EMP_SEX_NB	38.3	2027	HRS
X18	HOW_2EMP_SEX_NB	36.22	2027	HRS
X19	HOW_2EMP_SEX_NB	41.53	2027	HRS
X20	HOW_2EMP_SEX_NB	40.29	2027	HRS
X21	HOW_2EMP_SEX_NB	37.83	2027	HRS
X23	HOW_2EMP_SEX_NB	39.81	2027	HRS
UGA	HOW_2EMP_SEX_NB	41.67	2027	HRS
TZA	HOW_2EMP_SEX_NB	40.03	2027	HRS
TWN	HOW_2EMP_SEX_NB	38.9	2027	HRS
STP	HOW_2EMP_SEX_NB	48.99	2027	HRS
AGO	HOW_2EMP_SEX_NB	42.88	2027	HRS
PYF	HOW_2EMP_SEX_NB	35.33	2027	HRS
QAT	HOW_2EMP_SEX_NB	45.17	2027	HRS
ROU	HOW_2EMP_SEX_NB	38.47	2027	HRS
RUS	HOW_2EMP_SEX_NB	38.19	2027	HRS
RWA	HOW_2EMP_SEX_NB	29.28	2027	HRS
SAU	HOW_2EMP_SEX_NB	40.77	2027	HRS
SEN	HOW_2EMP_SEX_NB	45.64	2027	HRS
SGP	HOW_2EMP_SEX_NB	44.63	2027	HRS
SLB	HOW_2EMP_SEX_NB	34.94	2027	HRS
SLE	HOW_2EMP_SEX_NB	42.93	2027	HRS
SLV	HOW_2EMP_SEX_NB	42.9	2027	HRS
SOM	HOW_2EMP_SEX_NB	30.5	2027	HRS
SRB	HOW_2EMP_SEX_NB	37.27	2027	HRS
SUR	HOW_2EMP_SEX_NB	40.17	2027	HRS
TUR	HOW_2EMP_SEX_NB	42.81	2027	HRS
SVK	HOW_2EMP_SEX_NB	33.88	2027	HRS
SVN	HOW_2EMP_SEX_NB	33.3	2027	HRS
SWE	HOW_2EMP_SEX_NB	29.2	2027	HRS
SWZ	HOW_2EMP_SEX_NB	41.2	2027	HRS
SYR	HOW_2EMP_SEX_NB	27.28	2027	HRS
TCD	HOW_2EMP_SEX_NB	30.55	2027	HRS
TGO	HOW_2EMP_SEX_NB	37.86	2027	HRS
THA	HOW_2EMP_SEX_NB	42.18	2027	HRS
TJK	HOW_2EMP_SEX_NB	40.99	2027	HRS
TKM	HOW_2EMP_SEX_NB	41.5	2027	HRS
TLS	HOW_2EMP_SEX_NB	33.58	2027	HRS
TON	HOW_2EMP_SEX_NB	30.79	2027	HRS
TTO	HOW_2EMP_SEX_NB	38.28	2027	HRS
TUN	HOW_2EMP_SEX_NB	44.13	2027	HRS
X24	HOW_2EMP_SEX_NB	39.16	2027	HRS
X25	HOW_2EMP_SEX_NB	35.9	2027	HRS
X26	HOW_2EMP_SEX_NB	39.08	2027	HRS
X84	HOW_2EMP_SEX_NB	40.18	2027	HRS
X67	HOW_2EMP_SEX_NB	30.64	2027	HRS
X68	HOW_2EMP_SEX_NB	34.0	2027	HRS
X69	HOW_2EMP_SEX_NB	30.03	2027	HRS
X70	HOW_2EMP_SEX_NB	37.41	2027	HRS
X72	HOW_2EMP_SEX_NB	37.08	2027	HRS
X73	HOW_2EMP_SEX_NB	37.47	2027	HRS
X74	HOW_2EMP_SEX_NB	39.84	2027	HRS
X75	HOW_2EMP_SEX_NB	40.58	2027	HRS
X76	HOW_2EMP_SEX_NB	40.89	2027	HRS
X77	HOW_2EMP_SEX_NB	35.02	2027	HRS
X78	HOW_2EMP_SEX_NB	40.42	2027	HRS
X79	HOW_2EMP_SEX_NB	40.81	2027	HRS
X82	HOW_2EMP_SEX_NB	32.01	2027	HRS
X83	HOW_2EMP_SEX_NB	40.76	2027	HRS
X85	HOW_2EMP_SEX_NB	43.33	2027	HRS
X65	HOW_2EMP_SEX_NB	38.96	2027	HRS
X87	HOW_2EMP_SEX_NB	38.59	2027	HRS
X88	HOW_2EMP_SEX_NB	33.43	2027	HRS
X89	HOW_2EMP_SEX_NB	42.21	2027	HRS
X90	HOW_2EMP_SEX_NB	41.2	2027	HRS
X91	HOW_2EMP_SEX_NB	41.3	2027	HRS
X92	HOW_2EMP_SEX_NB	32.15	2027	HRS
X94	HOW_2EMP_SEX_NB	25.2	2027	HRS
X97	HOW_2EMP_SEX_NB	41.03	2027	HRS
X98	HOW_2EMP_SEX_NB	38.55	2027	HRS
X99	HOW_2EMP_SEX_NB	42.35	2027	HRS
XA1	HOW_2EMP_SEX_NB	39.55	2027	HRS
YEM	HOW_2EMP_SEX_NB	23.37	2027	HRS
ZAF	HOW_2EMP_SEX_NB	41.07	2027	HRS
ZMB	HOW_2EMP_SEX_NB	42.47	2027	HRS
X66	HOW_2EMP_SEX_NB	31.13	2027	HRS
X64	HOW_2EMP_SEX_NB	31.37	2027	HRS
X28	HOW_2EMP_SEX_NB	39.81	2027	HRS
X44	HOW_2EMP_SEX_NB	33.95	2027	HRS
X29	HOW_2EMP_SEX_NB	39.16	2027	HRS
X30	HOW_2EMP_SEX_NB	37.09	2027	HRS
X31	HOW_2EMP_SEX_NB	40.37	2027	HRS
X32	HOW_2EMP_SEX_NB	41.03	2027	HRS
X33	HOW_2EMP_SEX_NB	38.18	2027	HRS
X34	HOW_2EMP_SEX_NB	35.79	2027	HRS
X35	HOW_2EMP_SEX_NB	35.79	2027	HRS
X36	HOW_2EMP_SEX_NB	37.56	2027	HRS
X37	HOW_2EMP_SEX_NB	45.35	2027	HRS
X39	HOW_2EMP_SEX_NB	43.45	2027	HRS
X40	HOW_2EMP_SEX_NB	43.59	2027	HRS
X41	HOW_2EMP_SEX_NB	39.73	2027	HRS
X42	HOW_2EMP_SEX_NB	45.13	2027	HRS
X43	HOW_2EMP_SEX_NB	43.53	2027	HRS
X45	HOW_2EMP_SEX_NB	43.21	2027	HRS
X63	HOW_2EMP_SEX_NB	33.38	2027	HRS
X47	HOW_2EMP_SEX_NB	44.65	2027	HRS
X48	HOW_2EMP_SEX_NB	33.94	2027	HRS
X49	HOW_2EMP_SEX_NB	39.77	2027	HRS
X51	HOW_2EMP_SEX_NB	41.38	2027	HRS
X52	HOW_2EMP_SEX_NB	39.17	2027	HRS
X53	HOW_2EMP_SEX_NB	34.02	2027	HRS
X54	HOW_2EMP_SEX_NB	40.16	2027	HRS
X55	HOW_2EMP_SEX_NB	33.45	2027	HRS
X56	HOW_2EMP_SEX_NB	45.75	2027	HRS
X58	HOW_2EMP_SEX_NB	45.86	2027	HRS
X59	HOW_2EMP_SEX_NB	45.99	2027	HRS
X60	HOW_2EMP_SEX_NB	34.96	2027	HRS
X61	HOW_2EMP_SEX_NB	40.58	2027	HRS
X62	HOW_2EMP_SEX_NB	39.7	2027	HRS
PRT	HOW_2EMP_SEX_NB	33.46	2027	HRS
PRY	HOW_2EMP_SEX_NB	41.34	2027	HRS
PRI	HOW_2EMP_SEX_NB	38.3	2027	HRS
DJI	HOW_2EMP_SEX_NB	30.74	2027	HRS
ERI	HOW_2EMP_SEX_NB	39.81	2027	HRS
EGY	HOW_2EMP_SEX_NB	44.1	2027	HRS
ECU	HOW_2EMP_SEX_NB	37.16	2027	HRS
DZA	HOW_2EMP_SEX_NB	43.27	2027	HRS
DOM	HOW_2EMP_SEX_NB	39.17	2027	HRS
DNK	HOW_2EMP_SEX_NB	28.91	2027	HRS
DEU	HOW_2EMP_SEX_NB	29.66	2027	HRS
COG	HOW_2EMP_SEX_NB	48.85	2027	HRS
CZE	HOW_2EMP_SEX_NB	34.48	2027	HRS
CYP	HOW_2EMP_SEX_NB	35.41	2027	HRS
CUB	HOW_2EMP_SEX_NB	40.83	2027	HRS
CRI	HOW_2EMP_SEX_NB	42.02	2027	HRS
CPV	HOW_2EMP_SEX_NB	46.19	2027	HRS
COM	HOW_2EMP_SEX_NB	37.41	2027	HRS
ESH	HOW_2EMP_SEX_NB	42.31	2027	HRS
ESP	HOW_2EMP_SEX_NB	31.94	2027	HRS
EST	HOW_2EMP_SEX_NB	31.6	2027	HRS
ETH	HOW_2EMP_SEX_NB	31.07	2027	HRS
FIN	HOW_2EMP_SEX_NB	29.1	2027	HRS
FJI	HOW_2EMP_SEX_NB	37.17	2027	HRS
FRA	HOW_2EMP_SEX_NB	30.87	2027	HRS
GAB	HOW_2EMP_SEX_NB	42.3	2027	HRS
GBR	HOW_2EMP_SEX_NB	31.17	2027	HRS
GEO	HOW_2EMP_SEX_NB	37.58	2027	HRS
GHA	HOW_2EMP_SEX_NB	32.68	2027	HRS
GIN	HOW_2EMP_SEX_NB	40.73	2027	HRS
GMB	HOW_2EMP_SEX_NB	37.83	2027	HRS
GNB	HOW_2EMP_SEX_NB	42.92	2027	HRS
GNQ	HOW_2EMP_SEX_NB	44.8	2027	HRS
GRC	HOW_2EMP_SEX_NB	38.26	2027	HRS
GTM	HOW_2EMP_SEX_NB	41.4	2027	HRS
COL	HOW_2EMP_SEX_NB	42.37	2027	HRS
COD	HOW_2EMP_SEX_NB	35.91	2027	HRS
GUY	HOW_2EMP_SEX_NB	43.27	2027	HRS
BDI	HOW_2EMP_SEX_NB	40.96	2027	HRS
BHR	HOW_2EMP_SEX_NB	40.17	2027	HRS
BGR	HOW_2EMP_SEX_NB	37.59	2027	HRS
BGD	HOW_2EMP_SEX_NB	46.53	2027	HRS
BFA	HOW_2EMP_SEX_NB	48.18	2027	HRS
BEN	HOW_2EMP_SEX_NB	42.03	2027	HRS
BEL	HOW_2EMP_SEX_NB	31.42	2027	HRS
AZE	HOW_2EMP_SEX_NB	34.5	2027	HRS
CMR	HOW_2EMP_SEX_NB	42.29	2027	HRS
AUT	HOW_2EMP_SEX_NB	29.15	2027	HRS
AUS	HOW_2EMP_SEX_NB	31.28	2027	HRS
ARM	HOW_2EMP_SEX_NB	38.34	2027	HRS
ARG	HOW_2EMP_SEX_NB	34.99	2027	HRS
ARE	HOW_2EMP_SEX_NB	48.28	2027	HRS
ALB	HOW_2EMP_SEX_NB	41.41	2027	HRS
BHS	HOW_2EMP_SEX_NB	36.64	2027	HRS
BIH	HOW_2EMP_SEX_NB	40.81	2027	HRS
BLR	HOW_2EMP_SEX_NB	36.05	2027	HRS
BLZ	HOW_2EMP_SEX_NB	40.03	2027	HRS
BOL	HOW_2EMP_SEX_NB	37.89	2027	HRS
BRA	HOW_2EMP_SEX_NB	38.08	2027	HRS
BRB	HOW_2EMP_SEX_NB	34.47	2027	HRS
BRN	HOW_2EMP_SEX_NB	44.75	2027	HRS
BTN	HOW_2EMP_SEX_NB	54.67	2027	HRS
BWA	HOW_2EMP_SEX_NB	43.32	2027	HRS
CAF	HOW_2EMP_SEX_NB	39.94	2027	HRS
CAN	HOW_2EMP_SEX_NB	31.86	2027	HRS
CHA	HOW_2EMP_SEX_NB	34.22	2027	HRS
CHE	HOW_2EMP_SEX_NB	34.61	2027	HRS
CHL	HOW_2EMP_SEX_NB	36.38	2027	HRS
CHN	HOW_2EMP_SEX_NB	44.65	2027	HRS
CIV	HOW_2EMP_SEX_NB	41.45	2027	HRS
GUM	HOW_2EMP_SEX_NB	37.93	2027	HRS
HKG	HOW_2EMP_SEX_NB	42.99	2027	HRS
POL	HOW_2EMP_SEX_NB	36.31	2027	HRS
MYS	HOW_2EMP_SEX_NB	44.55	2027	HRS
MDA	HOW_2EMP_SEX_NB	37.4	2027	HRS
MDG	HOW_2EMP_SEX_NB	34.74	2027	HRS
MDV	HOW_2EMP_SEX_NB	45.86	2027	HRS
MEX	HOW_2EMP_SEX_NB	41.09	2027	HRS
MKD	HOW_2EMP_SEX_NB	37.23	2027	HRS
MLI	HOW_2EMP_SEX_NB	43.73	2027	HRS
MLT	HOW_2EMP_SEX_NB	33.74	2027	HRS
MMR	HOW_2EMP_SEX_NB	42.53	2027	HRS
MNE	HOW_2EMP_SEX_NB	43.51	2027	HRS
MNG	HOW_2EMP_SEX_NB	46.62	2027	HRS
MOZ	HOW_2EMP_SEX_NB	32.49	2027	HRS
MRT	HOW_2EMP_SEX_NB	39.52	2027	HRS
MUS	HOW_2EMP_SEX_NB	38.32	2027	HRS
MWI	HOW_2EMP_SEX_NB	30.75	2027	HRS
NAM	HOW_2EMP_SEX_NB	42.08	2027	HRS
MAC	HOW_2EMP_SEX_NB	45.56	2027	HRS
NCL	HOW_2EMP_SEX_NB	35.33	2027	HRS
NER	HOW_2EMP_SEX_NB	39.96	2027	HRS
NGA	HOW_2EMP_SEX_NB	39.52	2027	HRS
NIC	HOW_2EMP_SEX_NB	35.91	2027	HRS
NLD	HOW_2EMP_SEX_NB	26.57	2027	HRS
NOR	HOW_2EMP_SEX_NB	26.58	2027	HRS
NPL	HOW_2EMP_SEX_NB	41.11	2027	HRS
NZL	HOW_2EMP_SEX_NB	33.48	2027	HRS
OMN	HOW_2EMP_SEX_NB	44.05	2027	HRS
PAK	HOW_2EMP_SEX_NB	47.62	2027	HRS
PAN	HOW_2EMP_SEX_NB	36.0	2027	HRS
PER	HOW_2EMP_SEX_NB	37.94	2027	HRS
PHL	HOW_2EMP_SEX_NB	39.74	2027	HRS
PNG	HOW_2EMP_SEX_NB	40.83	2027	HRS
HND	HOW_2EMP_SEX_NB	44.2	2027	HRS
MAR	HOW_2EMP_SEX_NB	44.19	2027	HRS
LVA	HOW_2EMP_SEX_NB	34.99	2027	HRS
KAZ	HOW_2EMP_SEX_NB	37.99	2027	HRS
HRV	HOW_2EMP_SEX_NB	33.86	2027	HRS
HTI	HOW_2EMP_SEX_NB	41.46	2027	HRS
HUN	HOW_2EMP_SEX_NB	34.83	2027	HRS
IDN	HOW_2EMP_SEX_NB	37.67	2027	HRS
IND	HOW_2EMP_SEX_NB	45.68	2027	HRS
IRL	HOW_2EMP_SEX_NB	30.44	2027	HRS
IRN	HOW_2EMP_SEX_NB	45.99	2027	HRS
IRQ	HOW_2EMP_SEX_NB	30.35	2027	HRS
ISL	HOW_2EMP_SEX_NB	32.37	2027	HRS
ISR	HOW_2EMP_SEX_NB	34.96	2027	HRS
ITA	HOW_2EMP_SEX_NB	33.9	2027	HRS
JAM	HOW_2EMP_SEX_NB	43.47	2027	HRS
JOR	HOW_2EMP_SEX_NB	48.49	2027	HRS
JPN	HOW_2EMP_SEX_NB	31.1	2027	HRS
KEN	HOW_2EMP_SEX_NB	38.87	2027	HRS
LBY	HOW_2EMP_SEX_NB	42.44	2027	HRS
LUX	HOW_2EMP_SEX_NB	32.14	2027	HRS
LTU	HOW_2EMP_SEX_NB	35.35	2027	HRS
LSO	HOW_2EMP_SEX_NB	49.98	2027	HRS
LKA	HOW_2EMP_SEX_NB	39.45	2027	HRS
LCA	HOW_2EMP_SEX_NB	40.31	2027	HRS
LBR	HOW_2EMP_SEX_NB	48.11	2027	HRS
LAO	HOW_2EMP_SEX_NB	41.51	2027	HRS
KWT	HOW_2EMP_SEX_NB	45.74	2027	HRS
KOR	HOW_2EMP_SEX_NB	37.29	2027	HRS
KHM	HOW_2EMP_SEX_NB	46.17	2027	HRS
KGZ	HOW_2EMP_SEX_NB	38.43	2027	HRS
ZWE	HOW_2EMP_SEX_NB	44.42	2027	HRS
LBN	HOW_2EMP_SEX_NB	46.77	2023	HRS
SSD	HOW_2EMP_SEX_NB	37.6	2023	HRS
SDN	HOW_2EMP_SEX_NB	50.76	2022	HRS
PSE	HOW_2EMP_SEX_NB	39.68	2022	HRS
UKR	HOW_2EMP_SEX_NB	39.11	2021	HRS
\.


--
-- Name: categories_id_category_seq; Type: SEQUENCE SET; Schema: public; Owner: pc_app_admin
--

SELECT pg_catalog.setval('public.categories_id_category_seq', 1, false);


--
-- Name: countries_id_country_seq; Type: SEQUENCE SET; Schema: public; Owner: pc_app_admin
--

SELECT pg_catalog.setval('public.countries_id_country_seq', 250, true);


--
-- Name: country_translations_id_translation_seq; Type: SEQUENCE SET; Schema: public; Owner: pc_app_admin
--

SELECT pg_catalog.setval('public.country_translations_id_translation_seq', 179, true);


--
-- Name: labor_indicators_history_id_salary_seq; Type: SEQUENCE SET; Schema: public; Owner: pc_app_admin
--

SELECT pg_catalog.setval('public.labor_indicators_history_id_salary_seq', 622, true);


--
-- Name: labor_indicators_id_indicator_seq; Type: SEQUENCE SET; Schema: public; Owner: pc_app_admin
--

SELECT pg_catalog.setval('public.labor_indicators_id_indicator_seq', 1, false);


--
-- Name: price_history_id_history_seq; Type: SEQUENCE SET; Schema: public; Owner: pc_app_admin
--

SELECT pg_catalog.setval('public.price_history_id_history_seq', 17, true);


--
-- Name: sources_id_source_seq; Type: SEQUENCE SET; Schema: public; Owner: pc_app_admin
--

SELECT pg_catalog.setval('public.sources_id_source_seq', 1, false);


--
-- Name: categories categories_category_name_key; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_category_name_key UNIQUE (category_name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id_category);


--
-- Name: countries countries_common_name_key; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_common_name_key UNIQUE (common_name);


--
-- Name: countries countries_iso_2_code_key; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_iso_2_code_key UNIQUE (iso_2_code);


--
-- Name: countries countries_iso_3_code_key; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_iso_3_code_key UNIQUE (iso_3_code);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id_country);


--
-- Name: country_translations country_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.country_translations
    ADD CONSTRAINT country_translations_pkey PRIMARY KEY (id_translation);


--
-- Name: labor_indicators_history labor_indicators_history_pkey; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.labor_indicators_history
    ADD CONSTRAINT labor_indicators_history_pkey PRIMARY KEY (id_salary);


--
-- Name: labor_indicators labor_indicators_indicator_code_key; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.labor_indicators
    ADD CONSTRAINT labor_indicators_indicator_code_key UNIQUE (indicator_code);


--
-- Name: labor_indicators labor_indicators_pkey; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.labor_indicators
    ADD CONSTRAINT labor_indicators_pkey PRIMARY KEY (id_indicator);


--
-- Name: price_history price_history_pkey; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.price_history
    ADD CONSTRAINT price_history_pkey PRIMARY KEY (id_history);


--
-- Name: product_asins product_asins_pkey; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.product_asins
    ADD CONSTRAINT product_asins_pkey PRIMARY KEY (sku, id_country);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (sku);


--
-- Name: sources sources_pkey; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.sources
    ADD CONSTRAINT sources_pkey PRIMARY KEY (id_source);


--
-- Name: sources sources_source_name_key; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.sources
    ADD CONSTRAINT sources_source_name_key UNIQUE (source_name);


--
-- Name: country_translations unique_country_language; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.country_translations
    ADD CONSTRAINT unique_country_language UNIQUE (id_country, language_code);


--
-- Name: labor_indicators_history uq_labor_entry; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.labor_indicators_history
    ADD CONSTRAINT uq_labor_entry UNIQUE (id_country, id_indicator, reference_year);


--
-- Name: price_history uq_product_price_unique; Type: CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.price_history
    ADD CONSTRAINT uq_product_price_unique UNIQUE (sku, id_country, id_source, collection_timestamp);


--
-- Name: price_history fk_history_country; Type: FK CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.price_history
    ADD CONSTRAINT fk_history_country FOREIGN KEY (id_country) REFERENCES public.countries(id_country);


--
-- Name: price_history fk_history_product; Type: FK CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.price_history
    ADD CONSTRAINT fk_history_product FOREIGN KEY (sku) REFERENCES public.products(sku);


--
-- Name: price_history fk_history_source; Type: FK CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.price_history
    ADD CONSTRAINT fk_history_source FOREIGN KEY (id_source) REFERENCES public.sources(id_source);


--
-- Name: labor_indicators_history fk_labor_country; Type: FK CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.labor_indicators_history
    ADD CONSTRAINT fk_labor_country FOREIGN KEY (id_country) REFERENCES public.countries(id_country);


--
-- Name: labor_indicators_history fk_labor_indicator; Type: FK CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.labor_indicators_history
    ADD CONSTRAINT fk_labor_indicator FOREIGN KEY (id_indicator) REFERENCES public.labor_indicators(id_indicator);


--
-- Name: labor_indicators_history fk_labor_source; Type: FK CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.labor_indicators_history
    ADD CONSTRAINT fk_labor_source FOREIGN KEY (id_source) REFERENCES public.sources(id_source);


--
-- Name: products fk_product_category; Type: FK CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_product_category FOREIGN KEY (id_category) REFERENCES public.categories(id_category);


--
-- Name: country_translations fk_translation_country; Type: FK CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.country_translations
    ADD CONSTRAINT fk_translation_country FOREIGN KEY (id_country) REFERENCES public.countries(id_country) ON DELETE CASCADE;


--
-- Name: labor_indicators labor_indicators_id_source_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.labor_indicators
    ADD CONSTRAINT labor_indicators_id_source_fkey FOREIGN KEY (id_source) REFERENCES public.sources(id_source);


--
-- Name: product_asins product_asins_id_country_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.product_asins
    ADD CONSTRAINT product_asins_id_country_fkey FOREIGN KEY (id_country) REFERENCES public.countries(id_country);


--
-- Name: product_asins product_asins_sku_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pc_app_admin
--

ALTER TABLE ONLY public.product_asins
    ADD CONSTRAINT product_asins_sku_fkey FOREIGN KEY (sku) REFERENCES public.products(sku);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO pc_api_reader;
GRANT USAGE ON SCHEMA public TO pc_data_writer;


--
-- Name: TABLE categories; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT SELECT ON TABLE public.categories TO pc_api_reader;
GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.categories TO pc_data_writer;


--
-- Name: SEQUENCE categories_id_category_seq; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT ALL ON SEQUENCE public.categories_id_category_seq TO pc_data_writer;


--
-- Name: TABLE countries; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT SELECT ON TABLE public.countries TO pc_api_reader;
GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.countries TO pc_data_writer;


--
-- Name: SEQUENCE countries_id_country_seq; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT ALL ON SEQUENCE public.countries_id_country_seq TO pc_data_writer;


--
-- Name: TABLE country_translations; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT SELECT ON TABLE public.country_translations TO pc_api_reader;
GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.country_translations TO pc_data_writer;


--
-- Name: SEQUENCE country_translations_id_translation_seq; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT ALL ON SEQUENCE public.country_translations_id_translation_seq TO pc_data_writer;


--
-- Name: TABLE labor_indicators; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT SELECT ON TABLE public.labor_indicators TO pc_api_reader;
GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.labor_indicators TO pc_data_writer;


--
-- Name: TABLE labor_indicators_history; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT SELECT ON TABLE public.labor_indicators_history TO pc_api_reader;
GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.labor_indicators_history TO pc_data_writer;


--
-- Name: SEQUENCE labor_indicators_history_id_salary_seq; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT ALL ON SEQUENCE public.labor_indicators_history_id_salary_seq TO pc_data_writer;


--
-- Name: SEQUENCE labor_indicators_id_indicator_seq; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT ALL ON SEQUENCE public.labor_indicators_id_indicator_seq TO pc_data_writer;


--
-- Name: TABLE price_history; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT SELECT ON TABLE public.price_history TO pc_api_reader;
GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.price_history TO pc_data_writer;


--
-- Name: SEQUENCE price_history_id_history_seq; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT ALL ON SEQUENCE public.price_history_id_history_seq TO pc_data_writer;


--
-- Name: TABLE product_asins; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT SELECT ON TABLE public.product_asins TO pc_api_reader;
GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.product_asins TO pc_data_writer;


--
-- Name: TABLE products; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT SELECT ON TABLE public.products TO pc_api_reader;
GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.products TO pc_data_writer;


--
-- Name: TABLE sources; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT SELECT ON TABLE public.sources TO pc_api_reader;
GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.sources TO pc_data_writer;


--
-- Name: SEQUENCE sources_id_source_seq; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT ALL ON SEQUENCE public.sources_id_source_seq TO pc_data_writer;


--
-- Name: TABLE staging_labor_indicators; Type: ACL; Schema: public; Owner: pc_app_admin
--

GRANT SELECT ON TABLE public.staging_labor_indicators TO pc_api_reader;
GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.staging_labor_indicators TO pc_data_writer;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: pc_app_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE pc_app_admin IN SCHEMA public GRANT SELECT ON TABLES TO pc_api_reader;


--
-- PostgreSQL database dump complete
--

\unrestrict 8ZYGswvE51o5EcyzJ5lW22CfPurSiGhKEZkqZYhrXQL6rdsXMFezfJZFrSqLU8q

