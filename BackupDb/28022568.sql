PGDMP      5    
            }            unit_manage_service    17.2    17.2 *    d           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            e           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            f           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            g           1262    16388    unit_manage_service    DATABASE     �   CREATE DATABASE unit_manage_service WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Thai_Thailand.874';
 #   DROP DATABASE unit_manage_service;
                     postgres    false            �            1259    16389    dept_dept_id_seq    SEQUENCE     y   CREATE SEQUENCE public.dept_dept_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.dept_dept_id_seq;
       public               postgres    false            �            1259    16390    dept    TABLE     �   CREATE TABLE public.dept (
    dept_id integer DEFAULT nextval('public.dept_dept_id_seq'::regclass) NOT NULL,
    dept_name character varying NOT NULL,
    dept_name_short character varying NOT NULL
);
    DROP TABLE public.dept;
       public         heap r       postgres    false    217            �            1259    16396    history_id_seq    SEQUENCE     w   CREATE SEQUENCE public.history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.history_id_seq;
       public               postgres    false            �            1259    16397    history    TABLE     @  CREATE TABLE public.history (
    history_id integer DEFAULT nextval('public.history_id_seq'::regclass) NOT NULL,
    mission_id integer NOT NULL,
    history_type character varying NOT NULL,
    old_unit_id integer,
    new_unit_id integer,
    remark text,
    created_at time with time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.history;
       public         heap r       postgres    false    219            �            1259    16404    mission_id_seq    SEQUENCE     w   CREATE SEQUENCE public.mission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.mission_id_seq;
       public               postgres    false            �            1259    16405    mission    TABLE     �  CREATE TABLE public.mission (
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
       public         heap r       postgres    false    221            �            1259    16413    mission_unit_id_seq    SEQUENCE     |   CREATE SEQUENCE public.mission_unit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.mission_unit_id_seq;
       public               postgres    false            �            1259    16414    mission_unit    TABLE     �   CREATE TABLE public.mission_unit (
    mission_unit_id integer DEFAULT nextval('public.mission_unit_id_seq'::regclass) NOT NULL,
    unit_id integer NOT NULL,
    mission_id integer NOT NULL,
    created_at time with time zone DEFAULT now() NOT NULL
);
     DROP TABLE public.mission_unit;
       public         heap r       postgres    false    223            �            1259    16419    posotion_position_id_seq    SEQUENCE     �   CREATE SEQUENCE public.posotion_position_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.posotion_position_id_seq;
       public               postgres    false            �            1259    16420    position    TABLE     �   CREATE TABLE public."position" (
    position_id integer DEFAULT nextval('public.posotion_position_id_seq'::regclass) NOT NULL,
    position_name character varying NOT NULL,
    position_name_short character varying NOT NULL,
    position_seq integer
);
    DROP TABLE public."position";
       public         heap r       postgres    false    225            �            1259    16426    units_units_id_seq    SEQUENCE     {   CREATE SEQUENCE public.units_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.units_units_id_seq;
       public               postgres    false            �            1259    16427    units    TABLE     H  CREATE TABLE public.units (
    units_id integer DEFAULT nextval('public.units_units_id_seq'::regclass) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    position_id integer NOT NULL,
    dept_id integer,
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
    blood_group_id text,
    position_detail text
);
    DROP TABLE public.units;
       public         heap r       postgres    false    227            �            1259    16434    users    TABLE     -  CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(100) NOT NULL,
    hashed_password text NOT NULL,
    is_active boolean DEFAULT true,
    role character varying(50) DEFAULT 'user'::character varying,
    created_at timestamp without time zone DEFAULT now()
);
    DROP TABLE public.users;
       public         heap r       postgres    false            �            1259    16442    users_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public               postgres    false    229            h           0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public               postgres    false    230            �           2604    16443    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public               postgres    false    230    229            U          0    16390    dept 
   TABLE DATA           C   COPY public.dept (dept_id, dept_name, dept_name_short) FROM stdin;
    public               postgres    false    218   3       W          0    16397    history 
   TABLE DATA           u   COPY public.history (history_id, mission_id, history_type, old_unit_id, new_unit_id, remark, created_at) FROM stdin;
    public               postgres    false    220   �3       Y          0    16405    mission 
   TABLE DATA           �   COPY public.mission (mission_id, mission_name, mission_start, mission_end, mission_detail, mission_status, is_active, created_at, mission_type) FROM stdin;
    public               postgres    false    222   �3       [          0    16414    mission_unit 
   TABLE DATA           X   COPY public.mission_unit (mission_unit_id, unit_id, mission_id, created_at) FROM stdin;
    public               postgres    false    224   �:       ]          0    16420    position 
   TABLE DATA           c   COPY public."position" (position_id, position_name, position_name_short, position_seq) FROM stdin;
    public               postgres    false    226   �H       _          0    16427    units 
   TABLE DATA           �   COPY public.units (units_id, first_name, last_name, position_id, dept_id, province_id, district_id, parish_id, post_code, address_detail, identify_id, status, is_active, img_path, identify_soldier_id, tel, blood_group_id, position_detail) FROM stdin;
    public               postgres    false    228   �I       `          0    16434    users 
   TABLE DATA           `   COPY public.users (user_id, username, hashed_password, is_active, role, created_at) FROM stdin;
    public               postgres    false    229   �x       i           0    0    dept_dept_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.dept_dept_id_seq', 7, true);
          public               postgres    false    217            j           0    0    history_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.history_id_seq', 1, false);
          public               postgres    false    219            k           0    0    mission_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.mission_id_seq', 57, true);
          public               postgres    false    221            l           0    0    mission_unit_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.mission_unit_id_seq', 5063, true);
          public               postgres    false    223            m           0    0    posotion_position_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.posotion_position_id_seq', 13, true);
          public               postgres    false    225            n           0    0    units_units_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.units_units_id_seq', 1301, true);
          public               postgres    false    227            o           0    0    users_user_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.users_user_id_seq', 1, true);
          public               postgres    false    230            �           2606    16445    dept dept_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.dept
    ADD CONSTRAINT dept_pkey PRIMARY KEY (dept_id);
 8   ALTER TABLE ONLY public.dept DROP CONSTRAINT dept_pkey;
       public                 postgres    false    218            �           2606    16447    history history_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_pkey PRIMARY KEY (history_id);
 >   ALTER TABLE ONLY public.history DROP CONSTRAINT history_pkey;
       public                 postgres    false    220            �           2606    16449    mission mission_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.mission
    ADD CONSTRAINT mission_pkey PRIMARY KEY (mission_id);
 >   ALTER TABLE ONLY public.mission DROP CONSTRAINT mission_pkey;
       public                 postgres    false    222            �           2606    16451    mission_unit mistion_unit_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.mission_unit
    ADD CONSTRAINT mistion_unit_pkey PRIMARY KEY (mission_unit_id);
 H   ALTER TABLE ONLY public.mission_unit DROP CONSTRAINT mistion_unit_pkey;
       public                 postgres    false    224            �           2606    16453    position position_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public."position"
    ADD CONSTRAINT position_pkey PRIMARY KEY (position_id);
 B   ALTER TABLE ONLY public."position" DROP CONSTRAINT position_pkey;
       public                 postgres    false    226            �           2606    16455    units units_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (units_id);
 :   ALTER TABLE ONLY public.units DROP CONSTRAINT units_pkey;
       public                 postgres    false    228            �           2606    16457    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public                 postgres    false    229            �           2606    16459    users users_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key;
       public                 postgres    false    229            U   �   x���M
�0�יSx�BR.�a,�^@���v!.,/�yG1L5��.
�0�y�ތ5DA܉=�15o5�ĕ qf�^+'��pXX3�gV�$7%9Y�%�SR.�_�Q94����)-
߷��ln�����lCI4���~�ō��j���<�梭��,d����aa      W      x������ � �      Y     x��Z�n7>�O�cs0���w�%�}0�Z��-F+�I�FRF��v�6�(�J����YQJ�|$��2:�T�/U��*?V�MU��`IO���ԩ�4��*���?����z�>Uf��XX'=j�{��j�cU^U�j�SU��o���3��eU~��9��Y@3f�٫�� >�=��D:��ʆ	VH
(_T��U��en��UyQ�kƣ;ɿ,�F��OOg��J��}C(�K�ڦ#�C����*/��g۟k��2M�K���kR�̅���T�|���vNi
��RapQg�
�
b�V����#u&�ow4cX�+���;�(�J�u��&/d�n��:��:~�B�|��Ĉ1�l\���d���G8g$3���h�����v�F��8��9�����6MJy�����{S���}*�~��f�f�֢�+����G�M�-�o�r�ڃP�-T��j����R\\��4��E�%W�+�UF��Z��ޤ�V������Ȧ>r&\�b�B�BS�}6�c�w�ySޠ�z�m�.L�"R:�ւ�q;p"d��V���5�+��3����WQ9�:���ծY�o��LY�1R]&�DMwT��Y�Y�@a�O���`�cp:��f8����h#MP�N���3*��u� if<�e_i�C:�X�~����R�BD&��e�N7�t�\l띍��'*⌴� ƱNF�QGI��%���H���D���`w�&y�~�/�w���)	��,h1����m}T.X�K�8�d �;�_5�	jʄ랏j;�It1�#�;�̰g����Ҷt3�M�j���:~�b<z�B��5�m��� �O�T����!���3�;�A~Ը57�
���Bj�5t��9��@��V).���(�����ٸB��k.�M�pho!�pMa"�P�r�@	����ܩ�yZ�A7j��[>0^���Ԏ9�T�{��Fr����-sb���-GjE��xa{�����m�I�f��.E�/��V�5W�!&B8^���3PRS�����@h������`twO�Ϧ�Ot��7$Lr������yM�@yC��M�u�=b�k^;4�qkm�a���2���=R蚔���K��D��?�zj�n��4�v�%3�Kv���2���6��>��)���T� ��I���w���ʱd�s�כ:��Q���E�1�y��[���d=��/s��)�����:�L��`7[��g;Z?��O��8��^}r_�y�+�A�l���5�lR�olD���'���Yߍ󸓧]�� (��	�YGٍ���
����� ��-aח/��-�nx"?�5�FN�T�H�Q{hZ3�q׻8�6��YLCz�D�C��񎶻��k�}im��{�a#JUkCrc��ij~�;��ـ�%:i����i�]*��]h��.4�"���ĬϿ�ĚV$�����ڤ���=";6����S���T�^Ya�RW�u��~��ĤB;���(X��V�l����7�����D���v����t|�z��޷�0#.�6E�ǨZ~�I��&3�qoN#��8'�5�r|��G��Ӄ	t,�<G%)X���Ѭ�eMdn6��|����E}���Z���/�����q��YJ��X��a�5���ۄ�3�u���
�o�����v̼`�2;���@K���[~aӊ�����.�*_8"l���Ec�Ưt7?�đ,�� ct6���Q�&/�-�;柁��?\��\o_Q���k�41U�=�4��qW�.�%:jb0\��"��R�>��      [   �  x�}�M��*F��N��(�C�R�Gٟ�j��{�Y�ۘ�V���o��=�~J�������_k�8�����3�S����˽}[̛�Q���ROc>��̧��|9��6~n��yE�n�<���;,?�����9g����c|&�jBFn��c|��|;g����o/���{qN��l�ŵו�ϧ���r����� j���n�x����:����uRK�%���v%5M��0!�c���e���W�>������7����7��̻s��v��?��O+Ͻ�Ӗ�U`WASq¾�e!6�;`M��,�á�`ʢo�-�7�߽�<u_��B9��ffuB��4��^}�mQ����k�T�-Ic�.�֯,�w>���5g��
��2Ͻ�:V��n�e�~�v��j80�̇�·�o[��[�x�eR�.y/ұ�/�d�o�AG�6|�
v�xYܹ�F��]�r�2�<�杰b)n
o�v)a�	�0���~�W[Wŧ�������5m,�>ks=~�^|��8i����D%��o<u^���F��ݚ_F׮�z�qI�{k?�����a9Sv�w���]������o�R�2�њ���!Q��}��G{7��1��xc�k�?���v�o�nd��^�4Bg���ؙ�>?�Ȑ�|�3V��s�rV�s���
zn��y��E
6��n�T"�Vp.Į��;wѻ���Ma�`j[U��ާ��;�w:���D����'n+�fRo�㽮�9��k��(>ۦ�8�W`�_qF_�<4�#b�n-
M6����`?y:m����K�Ųd'�|�L��WK������Z����e2�����G>�u͡��7b��� ��ΊX۠!�Q��+�&<<�1ק����o<^�~����Wj�_�~����Wj?�҉䝃����{1�oo��K��&��nڡf��z����il`����-V��[Q�ޟ����}I��C��,�~)meͫ�^��u�3S�ʆ��X��p����3��7\�����O��O��)ן_Є��ߜx��yFl�|�;�U�>�%�}c:�\�d^C:�]��w���3tC���f��K;�\9�{�^u�9gr�����Q������*s�>�+/ԙ�H�"E��k4�)��^����;������{����?�gڜ�\���n�{�5a�s�y��Z|g �=;�s߲�p?����=����<���8��,ӍKR�c�b �|�!#���IF|s��R۴bU���\ ��{����l���������DR����OL��1?x��;�O����K<�}��=��|���96)��Ӿ Vx�X)�Q�� �EcZEX��}�6t���V�y4_-.�W�������C^�V�x�[�o֟��[�3�M�Wf����v?��.��*�%�U�kf����">2[E|f����l�7E�d6�'���l�	I�,Sϱ���z�d���8�!v�?m����0�������8h��:f�a�m�}?���]?�w��A"Wz3�?_�+���_}��S��'�wx~:Na��yh�m�tRZ������ϹKryǃyf����"�������mI��g�-`^�lV�_z~����pO�x�i�Z6��a��5��Y���k� �4:�kڬ_�0�p�[զGm�E��J�k�%ߑa��M��8��~���\@���4�0���H�	x����\�i-�f�U�:�lv���n�����e���)�߂7^"O��F�y�ב�����d���x9F�-Z���/���,S"���-�|��(�A>����2���G�;2�ȵ�r�*�Ç�}s���(�B�"�C�#jD>�N�2I�_q�����x���	�2E7s���y�y�y�y���+m�_�c~.��g����w7�K;��B���b_A����}��}���[�U\B�7���?�|a���#/1>�5Ƈ������ ��@>�y�?��Ho#?��!�{��㛙9B^#7��Eb
y�\"��D�3���W�2���F.��֌L.��+r0�wd����s�[&Ot /y��aߑ�p���5����g,�<[�;2��Od��q�M���_��l?uSr��k����O��I�g�7��G�_�3���W�t"�a����o�W��Mו�H:ǽ`�y���o,�J�쿆�E��m�=�+�)d�3�7�����d�'�'qU���_�ՇַU@o�?�)�����¿�򓟶�b��rܽ��󛼮���u�{�����7���k~ӏ�N�溈-�ܰ�n;w�T��ק����zZ�5�G�W�m��͔��՗i���ԇ�g\�>7�O��mo�3�c-s+� ���6��w��o����%Wp7���p睸�i�9qW���^�c~�Ђ�����K�$ ��r�������$}�..B�z`S�
�[�o����0�AX^�B��v#���ݤz"��+M���"k�X�
io�z���i+�Bu[��&��jn��/�<^�pkŹ(T�i(�i(�� �;Wu4��Q��ꠗ �G���$z��Rӛޡ^��w����O��"�/��[��x�d7Q�o�J�����n�H�T2�5Մ�2�KI�#���#��;�G�\'�*�z�.�sU���X���C���������-�GLg�K�̗����ͷY5$�����+j��7��W�r���Ѽ�o��G��9��Ҁu�cr',?�!�41aV�=˭ g�4�)d�+"`¾���ka_ �K>��%a�8�x��C{_���pA��:a9�������� `%�+.�r�;Wʸpk��(TE�;���#�t��V��PS���R��Lgǉ��t&�<ۥ�p�r�;�EQ���^fV��;w�\�yG�p���p�BJ�o&`]N0Vn�;��*��~sAX/ڸu�^�V'\�ւ�����[�u�{�v�m��t�>��&O���7Ϩ��T�>K�;�\��y+>`���A�]������[B��tQj�2�|�J���L����[�N�d�9a�P�*~���5n-]��顖'�	+> ӣ�Z��&���4o=���������6aUwq�	W�'�рK�I.�&�ϝ���'<"YExF"�p��	�& �� (5U���[�P��$ȯ ���·Z�G�����^q{H8_2��;�(#D�F!hK���G�Z�IE>22A�5� ��?�����2��/�N���GΏ����+�q1!��c�*��[����WC�3.��c����\/�s9���|"_�"ϟA~��x��'B^A^�0�x��y�8�0��;��"����q=�<>�����N����G�m�g��W�u��V���c�u.,_���io����x�� �:�x��p��[8D|Ǒ��d�p=����q����������,|@��MD���g8���b�[x|��(%7�>������%�{�\�o~~�%�3t1n�o��U��s�b{���Ǚ�Hd�����-�������G@��ɓ�/O�����^����:ף~      ]   �   x�}�M�0�ם��a(�w�0�
`�.��5a��d���B)C\>��}o�����2]��L����VI�~wd�G��"�{���0��
+*�*��*��)�t-�>i�)d�ə��vC��q�ipoS�qe%�?�\c\F������t	�����gh��0��G�T��~nygz,n��5[�C��$�i��v ���#e      _      x��}�oɑ���Х���ߕ5����e�7�f�;�c�{3eT�֢g%���戤�)h�)7���Oٌ�����������a�M����**32�/��Ҙ�����������������������8��?���������������ʅ�����J:!��������?�������Ǘ_��o�s��=�'�և������տ��?������?|�w������|���{rO�ϕ�B~���J}a���o�{%M�txw�*�Sw�<ܽ�{�{�pw�pw�p��Q����~=|�������-^�>�w��ԓ�k/���co��M.�^�������W���+¿#xxτ�8��=�S�I��>p��	_����]����E��Ax��`?Y���u�������V�����?�;��4����O���K֕��k����KXǼᇃ='�g�źvw���U�ppS�>gh�{�C�h�ŗ��ov�fzV��i�0�4J�h5�VS�h��p����^w�W�im3Y��;|`�cXO��u�p���p��㻞�?~ް�aNKck���ʛV�h!��/6��
7��	}�Wc��>�߷κ[Q����1ڐ����;��#��S~�Y�G����דy5飁lpkR9�w�h��x)��������|��:AC|��ϋ��W~`��`�FyA%|���9k��_�x�k�c0�`[\�J�E��6��n�7 �ݚϖ�p-�����q��Ң�n7N��C��Ux��~?�W|��J�����Fxk�E����5���)�tA'ۣ������Yj�G"���QỆ��������4M=�q��щW͜��!���X���{�]����Z�@|�����\�f�e�	����s^����E���y�����c��єw+~3����NK�`O�3<Eo�@���F$�tC�G�x������t�0�lg����ι������\�]��˝y?/����ϒ�|��yS����p���\���c���������;��~�[\z�t9G1B�u�t߷�Y��>�3��t]�ot�r#�2�������7�o�[t8Op��ἐ��5��2x�p��|Fi���;$옽�&?����̷�V����8F����d���y^��éF6�Y"Қ� He3��3�AR����o1�y�K�|`������]e�f�$PjW�-���wq|�:�[�2�˪��Lߜ�V�zK�)�M�El��]�z��6Y�?E~�����3�Yo�zbע���hͼ�8(�#2���6>��Sߗ <y���-�ǅ��5��PH�8��j���s��=m�o*-��h3�;B������k��{\Ɣ�<ŧ�r�2>��@�W.���V,�0� �]8���C��yW��4I����7_��Lj���{"�g�c�n��R��ak!�Ү2Y�4W��Ůqf�tz�R�c�N)�{AV?��md��,���4ک^�L���4qk~d�������o�Ii;"� ����	T5�-�,b�p�W�Q��c��
��}�&��۫j_k���`��C�me�A����\�M/�� )��Ǹ���	2�0�i	�-$rJ�Cm�5�Lh"�����n�(UĬ��ܶ*Ʉ���.��+�5�B�	�S*@`���u�S\+ۭ��X���`��V�諕�Jot��^%��U�N���,Ԯ�׶�k�<����Pn��Nh��;����F/�:�)�p�n�s�9m�\�,��y�a�0�]�S=9�E�mjX0�Wt��)Ka���4:�7��7��ȠeaՄ@I˩�3U'4~G5�5�I��0����P	�|բ����Kpy!�~�D� \�
i���~ �� �]�Eʨ:�؈aK�+�΍�qTB��f��`vv&�8/~A��#��5�ȄC<��c8���,��Ae8����	���$�a�$��E��	/.J:/z,��*����2�ք��|p0RE������U���Tk��S2K����'�.�b�����z0�B�c�� �A��AG-�;���|D
�C�����z]4ު���6������\���F��a���Ҿu~�q�C� �p~��)F
8�c���[��:SRQ~�����{\��-Yg��"�2�-<��o����h������e+ܧ��k��i
!e�]�5QC`O�+��Y�R("y)%��"�l	�C0����~4��F�_;<�\�QrW	j�d���|���Q�D�����(U1�s��w����#�����F��pi�U�!��&��6��p:6률��L��=���>tJ%�"qF"B/��[27,pǢ�qXt������Z�C�17H������	1���[�����ZRaTX�9�5�ݻ<Z���Z[�C��mG�����������=h�+�M���I<$���-A�!�T)�*&a��>F�ݠ���>��Π���"��R&QT����<-2�B2�,C>��@��S�F�sc�Ҥ��9z�'��i��]�F��i��S�6��Q��J�!^6_K10�e��5R.���]	�Ǎ-�q!����j��E�֌�ә Z�U�Lq�cl��~����}XW�R�<�~$FS�~A�R!��3�;�嗩(܁����`�B��m��fnv��d��E��	Ȇ���#!2Wh\��ڋ�5b�1-+ލ�Jݬ��ψ�*	N����V�R�V�%�(H����a]�)s38� �i�e%�f���1z�[�!B���w�nR���ݤ_B�!��&���Պ�arՏ������H�@]cY$H8��noJLW�`lE�ǋ^�u��d�Z�E�غ�uL��ÔeW��lydN��\�)�6j�W�2۶km���p�8�oC G�e�z�#j���n���p���6X�zӍ��'����^�w8��t
�K���Pk�c>�.#�E�{	����qs!C-Q#�0��A�`<"�_��jC9j(:ZQ`%�Z�+:�����vu\ ��)8�Ȑ�U�UX &-_��p5>��gC�<�J���b�(q�T�@�����ҕ�'V�	B(�j5O�y�&��=C�H�K��2:���ΡE%�F �����̄�T!]���;՘'2�Z@5U��3-�B!�,W�0��S���-OO�ڧ���UN8h���"�Ri��]*�]��9)��!��L儃�l
�F=���,}�*�'��x��Ũ�c����R!�0mk?^�J��ݶ>-L�T�I�v�-���V�ue�ԱJ]�Ҕ7bV��;� ���7�L�Sg��ۊ�ۯ;���=��y�>��<BV%^j�UE@Nz��\�h����vG!R�`��ٚ*v��A^�5C�y����E\��s��O*_H����­����%�躘^nzIx2%�w�}��{ķ��Z�re�4�lI�6�q:i`Y��a����a�t�%��s�ԭX��=U��f�E�.ew�� ���!�6�^:��wR�x�Yv?��z��c���i{��/�*�D�5!�� ��MBX���*�O[� �p�<t1n�Ю�b���X����2[��aᄛjEZn�vH�n�|KQ��o(\�<�k��E��ӺZ�I�l;���i1��@aےW{���eL���Pmk@ɋ��hn�Jq��Kac���b��� RpQ1lz�򢞓
F+��xa�%u�(�2��@�T��9� �~}�:��͂leU*�bu�c4�!P�Pkߨ9��0������Kv�ZU����C�L��W��Bf;v����Qb���~B�8`�Z�0.���;w>�H��+���@m���$͆{����7��|���.����"��q�g�ƫ_��c��p��E�c:��@هC|L�:G[Ć�c:U	�A�9�>o����	k��z�ʝ����NŠ�VsY!\h)�I,B{�� ����AAF���Z�C�1��3%�e��U]��?8���P��xI|���K��Sy��?q��`4a��D
��Z���Y    �r���4zg$�[��Va ��%��%CCp�w�(��<�T9�*0e�W���S#��p!��*o���VT��R�ae㦪�W�X�WSƍ��hoF۬4$XsVbTT�}r!�Qe"o�Q��L�6����I�5>��ʰ�?S˨���"<˴��� ��:k��s�$�cVLE��Ց�o���]�ۑV���&Uِ���rr��Q���nS�%^�����p�B���R���	@��F��fm��X)���.� 
y�>����B����7�8�t0����\,�4�k3*�Hۂ�E�#�2��m�<f�c`C�*���5V�-�!�W幫�+���x�'���줚s�e�u�]�r\"�g��[tХ"�5X72����w��T4�I�5����j�E���1�K_&R�>_�-�_��)S��$���dWCZ��(�8�
�Pu����$҉�M'"���qs��j�l������z�3h�0� ~�%��?���e憎8�F�"Nu�)jd�aT~��&����P0��� _�x1?M=���WI�m+	��FQ<9'�F.�!s.?Y����)�{�D@�x����:�~<���%{J�N^��g�-�|�I2�D�zj!����cr6�Z��9	��:b4�P�.*gc��&��ш|�w��̔*��J0�l_f,ĴA�!_!sTd��~dbƋ^/QF.�%�o�fdAIA	dt	��]�cG�eG���u$(4|�g��k���|�Dp ��|�|��(���n_D���i��
�5��f����b��]�����6d�;,5WG_D������),����0�|8�������������Cv��2L�Ub'�q�4#�{��ً�1.�i�3E�I�wȻ��Y��F�T�Ƥc�E4�,� i����Jt�X�%���Ά�)=��«m˨C�F�.�V[���d0�*kz�<�=:�:H���b�R��]k��~Rí��o���!��P1��A�3�����=N3��z�{,;d�F�uA�2Ź��kc�j��"�8G*��+lO��������������T�D#�|��3u�sޜ�!oN����z2em�E�4R���t�Y�S��OP$1�
c���rN�Z-R�H�=K�q�sWh$����h��%wΞ��Ǯ/G��ҢN.���6��q4�q�)�:�2t����Z��x!�vjφwPd0�j����&�OĴ	A�4�/�@R�q��%gE�Ǹ���td� �fUvi�M6*;�f�v-'��c�J+[���Ym����Xf�@,��ʏF�E����"�'ɲD_Ϣ��zs��k�T�U۲BG�|��ܤ�{�j0����<6��bwb�K&F�oaU��b7[{5no���F���BK�I��&�{�ɽ!�� �f�O�:���Qm���]�#/��k�K7���@6VO��EH�����E7y����u�7���������a�ߕM��kD�� �!+�"zI�L�ϡk�'m�BH8]1����]���n]���ؤL�xlk����x;\����~T��)^�f�8�`����ւ�YL���1��Q��LH�p���{��<��Lf�Ym�E�&�I`�I�Y���,P��t�d�N� %����)#���$�ߝ��ns+#LI�E��B��$x����Y��>*����$�LS��#�]}a愼�F���)Tl�&E+ځ-��+]���yՔ<;*�8/'8T:ۅ*�vE�ue�SW��,�9�?��f$�Qދ)D�lb�@�d��O�F06߫+w0�Ԙx��FKV)@nơSr��FWm8� 9h<p.;���?�[�l-Q8�e'�����]a���0$u�7J�Ä��C#��S׿�Z1�&�m����#r]��z��$��X���H��z�SKY�mW�c��	Y:����B��R?��a�k*�.�j��ѵ�w� ��	�������60�ׯ�<mF!|�� ����f�c,6v:�g �N���� �j7
�Z��A#XU���I��9c�D�C�s��/:Td�ȭ}'��N
T��<Xh~��U��pMt�%��0k�����-V���L��>�3����T�VGa|�7�ܕ�(�:��y���i�$&7F��C'���T|l�cN�aj�y���O���9A�GȊ�5V��XOQ���|''�1�E�U���=[����QH϶i��N��W�UH�z�+��Ug�wd5^�D
k6�Z�&�E�u��Q`yl�i�s�i��}����݇��Q%�Oj�t���j��B��u\�I�u=y�H^+A�Ԏ% cת�f�o����r�{�Z@?���p�7�p��fY�B��j�T��60j�����P�E��mØ(���0�^G* m�bڄ��nR�� �>��w>3�,��'*ۯϥ4j"�1�Q�;�8Rn�n�B���	��*5kJ9�%&Eְ�F�Q[�&N9}YlȿƟ�p�������pTb��O�S�Nt�]�Z�{{Jb��~6��.ɭ<���;&N���-"��f{:��(5�m��8�6���2(�O\3��\���
j�ZM����D :o�^�����H�s��� M�M�w��OԲ��w�tu��4h�Az�W?		I,��l�V��f�gd̂f$�(�3S�1>M�AZ�K�NߥN^
O��~��6ҝbl[j�0���Ϛ�
�V���Y+`01�u��.H:��5�;^֭�)�y���F�u)%,1�0�3+��6*Y���v�~�7��]d��(yt�d|��]�s�tứ������DF.yA>v�^�cS�����b�X�5Z�+xBv�_F�,�v��H�g�1gh~6�A֠�c��]��/�>sM}��<�q���̮�:}���"���s?^X _��ʊ�e3*�B�,O��������:�LL���u�okg��x&x��ʶ��s8���R.�B�U�T��<6f*'Q^�$?El��U�Wv�Ʉ��ǮRa�c�2yI��+I��F��	(>,�K'_�\j����r�����Ì�O��p�ID�0Ԧ�ˌb�	x4@/��ҙ��I�巼�`�s�p��(J�ܬV��*֫�u&�iI+� ����ZS�9�a�`hu�l~*؟��ԞRCt��&3
˅�F��j�3�~�����HǭmH�a��)Ҳ��=3+9��v��I�o�;��@h�mg҆�I��v�Â��������6vƜ2�$� �R^�e��Bb�-�^�f +��.�A��������%,��xP�*�N��5t$d��|(�U�V�ל�?KRe�\&�<��Ѐ쨿��Y瑵K҃��4�p9��#��ϳ:
�������!��QIH��-�ܝ�����%��%���8;9���0Sb�R�KL[�C���k�!�B�OjP���K��m�$��+!��Fs�;'ɡ`��������t
ܩz�Q���k��?ʌn�˳�X���kgi�N2����l��<�i�!�G�<i��e�~�$&i�_g�������"�S5`��0>��wd�)�y�ӯ�ַ,7�߆ɠzo��� #E�W�]h�]+�)���Q+�/�R�F�m�*:I'�yIs��C|T�C��	�@�����u��N�Oo�y�R�`�AG�¿�Ou]f�9�:F���wZOZjۥF,=���	;�0�|�d#Bg�7�PȢf�F���mm�T���g���>�hև,���C�P�	+�xC�j��)�?�����E3����©�6�ŏ(~���(�eÞp�ጯ�"x6w��08�\E�yw���?�Ȝ\Bz"�*��XkT�Z}D�ې�~RylY�"2.��8}��tza�� ȄIH���C\�;��OI2�d9�Q1W�.��jz�j���D�=-��v�`��ʹ�`����{?�t&�TC�O���Le��-�F��	�R�/`�x�Ba�6���1�H����.@l�)���=g��|m`�%���	�ݺ��a��6� 0?~�=!���ͷ��XS��%�����x�:"�Im�<���O>�K}Vuh��G���#ܶ1����s�[5,��BM9gc����I�����,�,�d� �  ɌgI��`'�%r�������֓��If���a_�=.���1����A��7~Vq�A��Ө6��S�o���7�A��\9���-�0����zk�NIG�Ό�V&��+,�P�K�y�����[\�"h���o���O0ނ;�Y�L�(����i9̎��x��"g��5+��~[�UH�%�px�<xAAeȤ&�uz$��.v���0h�<o�3�f���^���6F�K�.�p�l�K?��	PJ��r�N*Wg�1�6U�۲�� S�ߒQS�:��y�;�<�g�i喙ޙRB.	H�R��-�Q&�+U���e�KNX?�xX�����	�lV���T�ױ�댫"���"����sǤ����mDd6[C�6_K�="k��{��b��;şt�P��G�gEUJ?�`�!x�5�p��1��M���T����� ��i���sn:�0�Z5N�f��8]��OH�i��qÂ�$�_n穃�1C h�.��Q�����=�ej���ؖ��G���O�]����d!j��F��*�MVJq���9>�9���&Q�(� �$$q?��1�*T@�2F�snźb�mmbu�\�덉��>����9TG<���Y}��ѝz)�Nu�9����8?龍s�&J����wE�5Ŏds��pMq[�7��=���g�X��	ϝıu4�i1�>|����֨5z�*:�c�1����pZ��~� �G��?����h���2	�	�M(���T��f��,�ii��Uv2X[������߿�Ʋ��4�]�QA�s������|��^a�Hk���\F"�@��=�������d!@��$TC�'e�3F��I�hk�.��T��R� ���z���b	�ܮ	���QMr�6B��\?٭{J�\�m�q�a�Ͻ����gIe��m������+���@�/wP�y-�&�)�g���"�l`��J��!kHgf�nI��O�N�z�W��+���Ktޅf�D�����l0Q�k|��:���L��fMA�M2Q��}J&�d����q�=/Z
m���=Y��jR�K)Z�HB��t�C�9=���q^V9�Hփ�Y[�&3�l�m��-�q҆9h�>�~ȈJ�1����⺴��q	mj�S>9��NKV(#��0��>o��5ms��l,(����wncE�T���x]����҉E��ð�����rLa�,�n����0{d�l��`��ȹ���s2ʀ����!wj��L�d����@��(�bp�t��? i���T�'�ug�LYkJ�e*����u�}^2�s[*sY�l���O��ѩ��q׏�k����0A�U��0q�)d,�bD��_����������c
y����B�L�!�Q(��c��C���0Q.5��]���v�#�|��Ļ�I�����4�
90&�W9g��Nhr�Z�E��7Q��/Y��^�pBr	I���䶌S���o�!̅Cl��r�ޘ�C��ѕO�f�d�\�boL��	�k����.j��`�O�����BVm��$�����j9Cs�QJ������j�0��R�B����N�6�ݧVy|��\�@
]���ٲ�aZ�2�Aaf��x0��-|�*��Y4���%Ǡ�I)]E�%�
�g(�vK�.(d�3����Q��1��nʝυ�B}a�=ոjC񊶆f�U4�:P��4ی����7�M(3�`��l&㝪�wh��){��G��t猹�~s7�[��a�UhW�!�B��z�c���!��v�v��]�<N�p��T�n�j'i���@b9��m��ړ����8�ӿ^���q'a6��K���Ё�N���*�>��]_jx�ݢ
�X�i]w��`4�2󔗭�xaj���m��6< 9���c,ZF�^'9���Y�?*�C��jB����z�r��Z6V�2��L_MEH�K�}|`]�4��MYZ4N���Dq�f��2��YG�F��{9tآ�E��pWCE��Y��0㘕FL#|B�Ǵ@�
��e���ɻ�d���9f�wL;x˨�s�IbA2�V � 4զ;%���}H�"�uJ����`ո��L>�[�k�X���le��D���e�;��
����G@�����䮞v��҉IqX���@6 �,±�vDEFݤ�)N;�wg��!jˡ�ܶܣ�y5��*�ԋ��$
�B��4rb�&�l��qyE1���kop �P�P`Gu��m�lf��X�V,��<���y�z�g�ǂuH�[7a�q����!ݳ�L��I���G~��_J����K[���eq<�����B�ք���z�S�����r�����zn��t�������	�񸔮�z�al�p�-�'2eV՟*�%X�2D��FbQ���z���s��Q��,�����b2�2�D���/�z��h��J�����e���AWW�����8�#�R\�b��y	g��O�q�tȍ��}Nc*m��W�3_�+��oHj`�8%U�iG|%��n?���;?�����^���^���[n��򁆇���X��T?gW8��,��<��1m'��Qޚ[Xt��,��z,�"��8�pt����7~̏xL�=䲦;oG۶�p%���Z2xA ʍ���an�G (�b�Ev�NK�/m�������7��@�eE�����N(3Ӭ<GS86c[��y{�r���K��4q�K�������4��1�Ÿ�xd!y���'�.�T�[�cӾc�ހ���n~���S��X#.)1c~�����e8_�Al�-��|��J,55V���}�����D���
h��+�r�괻(�����f�x򛬼Щ���v�k@��(kK �6U@�{aФF3���m��d"�Bmb_[5g#m;�'���[�XƱ+�k)o   p�vq��7�nv��L�-�������^���z I��-+.J�ĵ�����(��Z���k|x��ov�Hx��55t�8�I����U�:�t����yǱ�
��4��-5q(�߶gA�^�,�e$�2*qu.�:��:D;���eq�2;���Q>F��b)�Le���t���X���Z���9v�T�0��Q���ʉrK���bA�n��ycw�U3�W�Q�F
n�����S�x�5���ӭ���F&�e�0	J��1{���B}"6'v�)�i����ͬ�Z޸��B��*������l�gԧR7�S�g=^��>�n2�j{Nյ7��cdi9��Y�i�k��ȁO6vlCS���6�夘����>U"��i�*6���\�X�X(#"l1lp�ݠ0�O�jD��˦re��~T2Si�lYn���dj�jH�C���`I-�$�V����]��%]�p�+l� ް��~���U��U,@�~)��J-_g$��1�
 *D�1�',1�[lҜN����KZ��̱�7W�lH�ד4/'=�j�L�ꔛkUn""Ͼ�r���V�c�XB
$���͎�q�RSEi�ŢT �yȚӪ���>J��R3.r%��[�D���/�jjoY��6�yE��άR.e�͜:n�ZyXB�HXz���!��mo��Ţ�o�A ���?N���t5�G_{u�$���l;U��l��Z����P�7�g��4�v��W;?��Ily8�|�(OK�Tx�����|��G���8an{�A��;�>	�<���{�_�^<%|�6cwD]VK��';?�/5��1��i�/�>����Ys      `   t   x�3�LL����T1JR14RI�M�HK��(s���,�H/75.O��q�Ћp�3���r�5)�(��p2
O),	�,�,-N-�4202�50�54P04�24�20�370145����� �X�     