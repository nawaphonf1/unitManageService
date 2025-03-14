PGDMP                       }            unit_manage_service    17.2    17.1 *    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false                        0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false                       1262    16388    unit_manage_service    DATABASE     �   CREATE DATABASE unit_manage_service WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Thai_Thailand.874';
 #   DROP DATABASE unit_manage_service;
                     postgres    false            �            1259    24934    dept_dept_id_seq    SEQUENCE     y   CREATE SEQUENCE public.dept_dept_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.dept_dept_id_seq;
       public               postgres    false            �            1259    24935    dept    TABLE     �   CREATE TABLE public.dept (
    dept_id integer DEFAULT nextval('public.dept_dept_id_seq'::regclass) NOT NULL,
    dept_name character varying NOT NULL,
    dept_name_short character varying NOT NULL
);
    DROP TABLE public.dept;
       public         heap r       postgres    false    223            �            1259    24960    history_id_seq    SEQUENCE     w   CREATE SEQUENCE public.history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.history_id_seq;
       public               postgres    false            �            1259    24961    history    TABLE     @  CREATE TABLE public.history (
    history_id integer DEFAULT nextval('public.history_id_seq'::regclass) NOT NULL,
    mission_id integer NOT NULL,
    history_type character varying NOT NULL,
    old_unit_id integer,
    new_unit_id integer,
    remark text,
    created_at time with time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.history;
       public         heap r       postgres    false    229            �            1259    24942    mission_id_seq    SEQUENCE     w   CREATE SEQUENCE public.mission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.mission_id_seq;
       public               postgres    false            �            1259    24943    mission    TABLE     �  CREATE TABLE public.mission (
    mission_id integer DEFAULT nextval('public.mission_id_seq'::regclass) NOT NULL,
    mission_name text NOT NULL,
    mission_start date NOT NULL,
    mission_end date NOT NULL,
    mission_detail text,
    mission_status "char" NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    mission_type text
);
    DROP TABLE public.mission;
       public         heap r       postgres    false    225            �            1259    24952    mission_unit_id_seq    SEQUENCE     |   CREATE SEQUENCE public.mission_unit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.mission_unit_id_seq;
       public               postgres    false            �            1259    24953    mission_unit    TABLE     �   CREATE TABLE public.mission_unit (
    mission_unit_id integer DEFAULT nextval('public.mission_unit_id_seq'::regclass) NOT NULL,
    unit_id integer NOT NULL,
    mission_id integer NOT NULL,
    created_at time with time zone DEFAULT now() NOT NULL
);
     DROP TABLE public.mission_unit;
       public         heap r       postgres    false    227            �            1259    24922    posotion_position_id_seq    SEQUENCE     �   CREATE SEQUENCE public.posotion_position_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.posotion_position_id_seq;
       public               postgres    false            �            1259    24926    position    TABLE     �   CREATE TABLE public."position" (
    position_id integer DEFAULT nextval('public.posotion_position_id_seq'::regclass) NOT NULL,
    position_name character varying NOT NULL,
    position_name_short character varying NOT NULL
);
    DROP TABLE public."position";
       public         heap r       postgres    false    221            �            1259    16408    units_units_id_seq    SEQUENCE     {   CREATE SEQUENCE public.units_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.units_units_id_seq;
       public               postgres    false            �            1259    16403    units    TABLE     7  CREATE TABLE public.units (
    units_id integer DEFAULT nextval('public.units_units_id_seq'::regclass) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    position_id integer NOT NULL,
    dept_id integer NOT NULL,
    province_id integer,
    district_id integer,
    parish_id integer,
    post_code bigint,
    address_detail text,
    identify_id text,
    status text,
    is_active boolean DEFAULT true NOT NULL,
    img_path text,
    identify_soldier_id text,
    tel text,
    blood_group_id text
);
    DROP TABLE public.units;
       public         heap r       postgres    false    220            �            1259    16390    users    TABLE     -  CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(100) NOT NULL,
    hashed_password text NOT NULL,
    is_active boolean DEFAULT true,
    role character varying(50) DEFAULT 'user'::character varying,
    created_at timestamp without time zone DEFAULT now()
);
    DROP TABLE public.users;
       public         heap r       postgres    false            �            1259    16389    users_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public               postgres    false    218                       0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public               postgres    false    217            ?           2604    16393    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public               postgres    false    218    217    218            �          0    24935    dept 
   TABLE DATA           C   COPY public.dept (dept_id, dept_name, dept_name_short) FROM stdin;
    public               postgres    false    224   �2       �          0    24961    history 
   TABLE DATA           u   COPY public.history (history_id, mission_id, history_type, old_unit_id, new_unit_id, remark, created_at) FROM stdin;
    public               postgres    false    230   43       �          0    24943    mission 
   TABLE DATA           �   COPY public.mission (mission_id, mission_name, mission_start, mission_end, mission_detail, mission_status, is_active, created_at, mission_type) FROM stdin;
    public               postgres    false    226   Q3       �          0    24953    mission_unit 
   TABLE DATA           X   COPY public.mission_unit (mission_unit_id, unit_id, mission_id, created_at) FROM stdin;
    public               postgres    false    228   �4       �          0    24926    position 
   TABLE DATA           U   COPY public."position" (position_id, position_name, position_name_short) FROM stdin;
    public               postgres    false    222   �4       �          0    16403    units 
   TABLE DATA           �   COPY public.units (units_id, first_name, last_name, position_id, dept_id, province_id, district_id, parish_id, post_code, address_detail, identify_id, status, is_active, img_path, identify_soldier_id, tel, blood_group_id) FROM stdin;
    public               postgres    false    219   M5       �          0    16390    users 
   TABLE DATA           `   COPY public.users (user_id, username, hashed_password, is_active, role, created_at) FROM stdin;
    public               postgres    false    218   �6                  0    0    dept_dept_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.dept_dept_id_seq', 2, true);
          public               postgres    false    223                       0    0    history_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.history_id_seq', 1, false);
          public               postgres    false    229                       0    0    mission_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.mission_id_seq', 3, true);
          public               postgres    false    225                       0    0    mission_unit_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.mission_unit_id_seq', 42, true);
          public               postgres    false    227                       0    0    posotion_position_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.posotion_position_id_seq', 4, true);
          public               postgres    false    221            	           0    0    units_units_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.units_units_id_seq', 4, true);
          public               postgres    false    220            
           0    0    users_user_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.users_user_id_seq', 1, true);
          public               postgres    false    217            W           2606    24941    dept dept_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.dept
    ADD CONSTRAINT dept_pkey PRIMARY KEY (dept_id);
 8   ALTER TABLE ONLY public.dept DROP CONSTRAINT dept_pkey;
       public                 postgres    false    224            ]           2606    24969    history history_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_pkey PRIMARY KEY (history_id);
 >   ALTER TABLE ONLY public.history DROP CONSTRAINT history_pkey;
       public                 postgres    false    230            Y           2606    24950    mission mission_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.mission
    ADD CONSTRAINT mission_pkey PRIMARY KEY (mission_id);
 >   ALTER TABLE ONLY public.mission DROP CONSTRAINT mission_pkey;
       public                 postgres    false    226            [           2606    24959    mission_unit mistion_unit_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.mission_unit
    ADD CONSTRAINT mistion_unit_pkey PRIMARY KEY (mission_unit_id);
 H   ALTER TABLE ONLY public.mission_unit DROP CONSTRAINT mistion_unit_pkey;
       public                 postgres    false    228            U           2606    24932    position position_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."position"
    ADD CONSTRAINT position_pkey PRIMARY KEY (position_id);
 B   ALTER TABLE ONLY public."position" DROP CONSTRAINT position_pkey;
       public                 postgres    false    222            S           2606    16407    units units_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (units_id);
 :   ALTER TABLE ONLY public.units DROP CONSTRAINT units_pkey;
       public                 postgres    false    219            O           2606    16400    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public                 postgres    false    218            Q           2606    16402    users users_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key;
       public                 postgres    false    218            �   e   x�3�|������v�?ر���N0{���`��;v<�1��Ά;f�E�?ر���CNd��\F��n3Z��Y`�M 5��R39!�z
p�=... ~We=      �      x������ � �      �   #  x��P�J�@>o��/���MbL^��,��O���n۳7ū ��M�""��̣�i���a��o~�����3�K���0�a������=��s�sF'X�t����",���U�0�k�e��^�R�di��� |o��"�����*-�i�y�r���W����r��]'��&E/�E�b���2#X���(�z���6	vF��I1�\?M0�x�f9g3F[N[vVp�4�"�{��?`�Hi6'�Y�z�	򩲁d?e���-�ڲ)hCi=�̌��Y��GX2�{���>�=eE�e_���      �   R   x�u̱�0D�V��8�&f��?Gl+e������ZY���u����	I��ܫ��°e��'a��	�0ʚhl�=��/�       �   W   x�3�|�cՃ[��`��;?ر$���q!��lz�c:Tj��1�TÃk�h�ʮ��22;��x�cVezp�1z\\\ 8<Q      �   B  x����N�0�盧`	���ؕ*D���]B��T4�WH�lebda��m�(�nQE+����#Y�t���~o�/��[���y���0�܈*�)"&$��	���w�y #k�6ƔE���mE���>�M��3vU��7:Tj�t���߄���h\$��r�b�tr0��2`ff�(�r]��Hiιt�1RƅDE����Q�Λo뻩_�>]��w�.����_��v��-�Ӛ�Hȝ�*dG�6�4�'�����5�l�鹞�e�Z�<㲼�Ž���:��HM�?IN��E�f@�b�P*��f����[������
�����Z      �   t   x�3�LL����T1JR14RI�M�HK��(s���,�H/75.O��q�Ћp�3���r�5)�(��p2
O),	�,�,-N-�4202�50�54P04�24�20�370145����� �X�     