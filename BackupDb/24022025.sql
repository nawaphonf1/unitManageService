PGDMP  *    ,                }            unit_manage_service    17.2    17.2 *    d           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
    public               postgres    false    224   :       ]          0    16420    position 
   TABLE DATA           c   COPY public."position" (position_id, position_name, position_name_short, position_seq) FROM stdin;
    public               postgres    false    226   [E       _          0    16427    units 
   TABLE DATA           �   COPY public.units (units_id, first_name, last_name, position_id, dept_id, province_id, district_id, parish_id, post_code, address_detail, identify_id, status, is_active, img_path, identify_soldier_id, tel, blood_group_id, position_detail) FROM stdin;
    public               postgres    false    228   5F       `          0    16434    users 
   TABLE DATA           `   COPY public.users (user_id, username, hashed_password, is_active, role, created_at) FROM stdin;
    public               postgres    false    229   Jm       i           0    0    dept_dept_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.dept_dept_id_seq', 7, true);
          public               postgres    false    217            j           0    0    history_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.history_id_seq', 1, false);
          public               postgres    false    219            k           0    0    mission_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.mission_id_seq', 51, true);
          public               postgres    false    221            l           0    0    mission_unit_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.mission_unit_id_seq', 3882, true);
          public               postgres    false    223            m           0    0    posotion_position_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.posotion_position_id_seq', 13, true);
          public               postgres    false    225            n           0    0    units_units_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.units_units_id_seq', 1300, true);
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
߷��ln�����lCI4���~�ō��j���<�梭��,d����aa      W      x������ � �      Y     x��Z�n7>�O�c{0���w�%�}0�Z��-F�M�F[��v�6�(�Z�����R

��|$���u8iꟛ�]Sh�M}˃�<�J�SP�
�О�x�j����w���2����:�Q�+&@�4���eSn�?6��z����M���/���-Z ��0�^}78���T� ���EP6a����y�����`�����^��Z��V�/+¡������R9�ؐ*�������B'G =<i�4E�E�s+�TF�I}�I?M}E�\�061��Pwv���)Met�V*.�b\aYAl�f�d�_�c����nW@3���X�C������6��[���p�R��7�*�+$F�!�d�'G��rĉsF2�����@;[?a/{�.�K��5�KN&���?�Ӥ�g�n�����fMO������5c5{���XQ�$?3ѓ4[�O/�2�vB�RAj��7�Hq�L�i��^I��+VВUF��Z��^��V��u��͑M{�B�a�Е2���o!�bX�c�?9�A��e�1�0��H�LZ.#��D��܋N���1��PFRҫ�< ty����P�ce�T�I��P��*d�/*PY�@�b"��X<��Y?<ɝ���h#MP��EgT�׫VA�,x|;��t��(��"g#S�R$��Ld��
�<.�t�\l۝�I�qF�d �X'Y03�(���D[�b7����"����lvwnr�w�7��y/�{>&��9+Z���}p�/�*{	� �t�ʫ�8aA�O�p��Qm��8�.Fs@q�X����y-mK���4أ���Wɠ!ƃ7-tF'�������0o��$����9PB����>��<�RyU2��t�ë�;��܇$7�*���B�j�5H��K� �S�+���lUY#�e�.�Lc���<m�ä)�#�-=����1G�
q/��H��m�n�ӎʷ��|t�8�$�L]�?l���i�k�.���B�/�A�ۖ+�!̗�v��
�)�|��c>�0m�M�v;��������v憄I�r�	���Ԛ��D{�d����%��.1pg�g�?-�.�R�f�o7L~/��^��l2�����$?'�S�V�h���Owԣ�_Y�����`$V��=��	�� F]��
 (Գ������%}sa�6H|�I ��&�dԤ��-���kH/�P��v�0�:v��{�/��V�j�'���M�6���ŷ��/Mf�<:����"�T���8d�ߝ��֝S{2C��k����ɦ����m.{}�����ťu��WV���b��j�����
]�$r4�Ȇ/��j6\X51s��_�Q����XO��o)������)�q�"�d�;,�����D�וMfy�F5pN��l�h�Hu9�8=�@�"�sT9ʁ���凶�D`]eȥB�{����ϼ��«�!�����d�?
�V�u��]��}fG\q�t�V�ר�z�1u��RT�1:]�BH�G�[
w̎�9�b\��"�GR��      [   C  x�}�K���E�y��"�g,5�q<��y�S��A��)��t����T~���r��z���ǿRr����ׯ�_ZW��X��2���-1�)�¼��٘w��|��o_7�%���[��W$�������/E��W����B~9��<������|����g���S.����I?F�>I{����J��J�4�Xz���=z�0��@-�V�Y�F�A�N#uKl��)%M��!������26_R�ڙKI�b�K>>��%�y��O����.�J���Ze�Zm,'��Lq�&��K4I���K�`Ҡo/ٖ���A~y^5�BZ�:����P!��T�U��4��k�:Fً*�JҚ�K	p�+���i��]���q�P��$S����ۨg���M�-KcG���2/>
]g][�S�Q4o�4�Zރt�J�i���m5��e�'�`�����-5:�*��̓����6�e�%���픶m'��iE���q$R�_�?��VnmSiZD��=^iM� 7n�^���Q	�����������5�������%M��r逥䋖v��ԇ���?����`�̵�ֈ[�RG?�3�7�o'���u��c�LcF?����:��1^�[Q�ٷ��Wj���%��p0W���Ȑ�|G0��������jݵ��H���Bl{cY��J�e�@,��<�D/�}��iF,��ZeIn�U��X���X�v��s�u���������zQ�V�/�y<��Q{�ݡ��r~6C+���}���~M�'�"�� n;7!,k�xi���4�
*��<��6���h���@�ۉA+6�����H�w��~��;��
�6�Nx�B��7��� {���O��ٞ��ZU�?R+�M9L�>u������H�#5��� ?R�H�#5��� ?R{��I�������=�ۓ���7�d<�c�I74욬GH�̞�f������iD��_��~fב*�C.y&?\����e��v\3���f��u�;l[M�a�J��V�w8���õ���<%�y�!$���Q�m'��OƆ��Gc>w��\[�Pݛ�1�X:󼥃\JT>��7?�?�r>&s/�OI9�"���<W��p�Ը��eT#e&>,���u���U�eo��]�E.��_�yS!����S�jq�*�S��&yc��lNءrA,�k���՚��\q�
S�n`��Γ��v�������q�v�7�|�<�Ǎ~�8`�n<���q��x�a�RT&�ɹ��6�Ĳ���$ U�~�}��c7��Jt�����<���q���T���qpχ��}��|�ţ�������W�U#�9���	��3�.�0VF�h�DZEؒi�up&/���*P����K�Ug^��i?�!��U�x9�ğ�?�v^��Sm">N���<�.��T���īZE<�j�|�E�˩��ZE��j�~�e�ǩ��Q�שf��8����\�
�l�*����sߑ�~7g �J��5wm��H���WZ��.�����E�K`7�k�ְm�|���~p�ol�ԓ������We���c~{^������o��\��h�e�Ĕ��#HW��t��=7�⇼�z"r���c�����	�8�hw6�Q�c� �c� �c� �c:?��c� ?v�c��qy��t��|l�+�*�*j�#�����C�e24^oN��D��|�����"n�`��^�\��Z�e�S��U���g�k�d�*k�4����~O�̝)��}����ug��~sC�J�`>��r)��؟�7�ָ��x~�9=m#������`[�J����_0>����x?���]���-?^�+5�������~�F^v���?�3O�}'��Ǯ�"�;GC�v!���wv
��\��{����X�ޏ�i'�8��-�[#��|���y��3�S�s����]"��s_��ﻵk���m���s�_���^!ϱs�8?�*q���~��e=��P4�/3�KY�F�}����<q����f�˫W�����z�aލ#�H���`����]��@�_�n��0&m��5\�!.�s!�2�`ޏ�$.᧏�s�5"_�!����O�� x�>݊�W�XI����G�6#v��G�6�	�,�q���u �ބ�%l��}��(�&,�ɼ4WAQ,�RC�7�܈�4��I�F�º�W.S�ܞ��.���$�ю�P���,(wj�tƓ�{	�a9Cup�&��r��{&Yj���F	����|��S&|:�	�^�w��R��h��LZ�[zT&�
)�[z��D؏׌rс�םNbٯ;��{��4\��*�u'�s����ع��SL���V��^^��N�rk[�zӼ��(b�v^u�O$4�i���ӕ4<>��Tv�Њ^�{�<�7'�v���.!w�
by=���~F\�s(���D��_r�� �u�Ţ��/ v�%�OXN��p��'$���$�-5<����[�	�'wO���E���F��]�H<�~��@=��>x�tI���[j����u��9��JFō�S�%,�U���Vp��+��Y���;� �k�\RKxb�޿#������� �� ��c�~xr��P����F��<���v��@��*��_��ڋ���������6;�e�z/͑./ͿIBE޿0�u-�}����ܿ3����͞�̷��[E����K.��;?@eZ��(�Ӯ>F®���H=pc���她#��m]���5ژ�U�%���L��U�%�>Ѿ�ܪ�?§#�p�%_�~]��s$	�]��Nᴫ��O;2�k���.Un�XE��B)�S�&<w���5Qj��B�7��"�eW%r�eW�	�Fj�m���]�#�NC^��4$|jӀ�3>
u�⃶�w������5�?      ]   �   x�}�M�0�ם��a(�w�0�
`�.��5a��d���B)C\>��}o�����2]��L����VI�~wd�G��"�{���0��
+*�*��*��)�t-�>i�)d�ə��vC��q�ipoS�qe%�?�\c\F������t	�����gh��0��G�T��~nygz,n��5[�C��$�i��v ���#e      _      x��]�o�q>��
_������[�� �-7F�	#6琛����J$Zz��,I�(��R����OIWUWO�L�,�8���.�Q�����W_}��M����v}t�~w{�����������<��v��v��v���y��|w�~օ�w?���W���{��1��~�������_�K����~��_��믵��T���IRJ}�Ͽ��/�����?�ӿ����џ��/���F�H?2���+��ܣ����v�[��_���~ڏ��}�O��������v��v�4/ ���-~�~�� ~�>�O��e��2����l��n����D}����Y���*������5]֨M�o/ƺF�ڛ����ϓ7�n׫��:�W�W�'�H7�G���B�*t�����SQ�w���E[�	?|�v���uv{����ۛo�';�+�K�)F��3��ؼ�&����Xz6z���O�������!�Uޕ4�sX��=}~=Qe���ni^�����;�ޙ���t��'~��.ٚ�ŷ~s�'��8�W~�zjM��+!��aM�L$�>��aE=��l���k��]ɿɎ��|�o��ҷ��u���_���)�-��u��?��� ��O��j�o�5��;��8�v~�_�SةI8x�Vpp�{��^�)o7fk�oT,������3p���c|�+�M��z�>4hX���v�}���VtT'��}�6�&|��%���|A&sP"��)l�ܫƈ^�M��3`S٥`�T+/��tl������x��l�p�&{O���|NU~/>[O}���/����?�]�硨��f��5n@+&8�ڸd�rNlO��������19B<��֓��ְL��[pC`Ly�G���u�8*���e�t��^�r�׼�d�R|�3|ҧ��N�ܼ��T��Ҵ��x]��`Y!�ɓ�ŶR1.�|~Zm)�ݮ�_���<�܏���9H�bM�ȅ=����]��/#�����X����7�	r\WEޤ�ҞoȘj��>�k�F����S��v~�ܓ���y}fǹ��kN7��L�ĨJ����M��A�2�FD�/'y�.���A���Ρ=�!� �Ç=��R	:#�|F�P��S�waY����8��|j�b)�u]㩦t���r�q�9lH�mH6NA�d��K���pz؏��u쭎q3.��v�o��#���	���wq�71'��-��
�(�ۉ'�:���Τ��_��S����|�Ԓ�a\�zB`�j[�{O�R�1cJ�*��8*b�@G{�{p6
�4���]�Q�5��?�DM꜌���w^�.l�α�mx�ͳ�,�ae���G�&�h����N���9z�H�eC����c+B�!�b7R"�[�~�7��_�!T���U����<�8�-�
�,PY|`QW�$��goi^s�����9��՞��(����� Z�(�ɇn�X�@��c�;Í9@��h��@���qK��}"�^$8�}? 4*@�>C�����c��S�����\|���@�xv>��p�uNmDE) �4a��ൿ���L^��) �:�|vmT�8��+�#���Qp��RX��ȝ�7��B�W�D�-t��� +x�^$��<�9��-m��Z!/>'���*n�ٜ��u���~Ba�1�����	��9
,U��u���j�D�c�߬8�R���d���M�q�Re{=���w�x�R.O�Ǉ�2�S��o�W��XQ2ñ�W*m��Ǌ���8O5U�C`���n�Y5X��0��%A�]?�mE����~	���<X��$�2q�^�˺���o������1x��FAo��Q�T^m	?'x6?�m�_��O�79��m��]Iٟ��`6#����do�n�U�E�ܗ\�����rk���7�9W�
��V�D�u�d�,׬�6�.�ܾ�p4;;���5�Σ+c�� X*2�>Q����T���G���0��aR������i�$3U��o,:��kAjj�	j|�f�bT�#�r�=�b3��6nM��J��z�D�M�>9=s#ס�rJ}�&z���g����f�Wp�
J�f��F��w�g���=50`�E�j�R�E;w�sq��J�"w��~y-/+�{���YӾ<��>����2e;�F4�zG����lX���i�7C��_�c�DWı;���vT�x�����!Z8^����m�!)X҂��gG8Z�J#={�Cd��N�JY��u9A�9Wpa/]N��Qa���Ck��̐�.��8'cO[ �Y`@N�U�_,���8�*Q�[�	��̎���E���"�F@X(���P%	o:3�)W�Cl�].v���O힬�2ޥ�s�ұ�j2��Pl0(˥���x5�*9_t��Xb����%�Xб�B8?���!_�Q��/M��"���=MŖ��^e�~��?ɲ"��	X�0�H�� ����X0��E!��SJ�gE�_`jC	O��Q��ek�Ϩ+�	ڧ`T��LTW����҃��N�0}���r�v��Z��ځ9�<��:ȿ�ãI�1m����yc,U�}��X���)"����C�V���s���i ok�b��x��{(<5�}&<�m_�8`ƕ�zH{�B���'|����3s�GT�����K�õ���`xU�W���}YY*�j|��y��ī�n��yX�r�2�ӧhg�q��%_�J�{:jo`�2;���I '�ix��[��ԯ�����-�>z���9��\x��uLs���N-��0z�S!H������x��ㄳ���q��L� 3@���)i������\`�"��V���`f)Vg��5$�C-m:��nul����3�˦́A�Ժ���~��srhDE�Rmz���$���ii"��9D��f/G�r����]��'�+2�
�Ru}U�J#��b�����C�8կ�&-]$�L��o9m�n�`��؝u۶�	DF
����d����@e-{��x9���ҽ�W]��a
gs2����r��-d��"��u��u��9�ѡ�o��w"e�ž!l��"q�dm�����D�p�5W͔L?��M⺴�>����p��4��O_��!���
G��ur�`�rc�qWe��4��i�� _�1ǘ��`���cZ�3Z)=ª^���o"�u��Uv= ���QGr����=��K���]��9���	.�{�0�	���a����P��]��=�Ė�N@N/�sQM���Ӧ��:��-5m����}���������8��r�~�i㗆���u@Խ[j���ױ�Ǎ�cg��Y�ɑ����	~��r�UV���wA��E`�:��ﺔ�Q�f^�u

o�$�>��z���m�z�� ����5:�����H�	{i\�M���`��8��_�Ƥ��uw�JIs2�oY ܳ�aw���Ճ)�/�M���ӻ����Ȳ&{���p�0>�Vɍ	���+1�[��l)��m� RЄ��0�\c�u"���wΡ��>�C�,�*��3���rg���ǭ��'�#J��^�a�ֳ�2�#g��{f~h4@X��lM�g:]���Ȓ��6:N ��kvZ�o�И�������x(����<1���b}�O��sKdg-F���:'�qhy�K�X�����7�irZ�=�{����=��r���%,�"�fЮ��w��"l1��������C�\�~ӤH�2t�e���И�uq�����	��$姜:̧���S�����Qs@�`�:��nn�~�6=mSs��b>�y?D������2��_9��DB�k� k\�I�yW�?���O��X��juì�s�.�J- ��w�3M+���J�D=sN�%.u{��Ǣώd�J~Y	2+�<�ე4�Y�c&�T�fE�P�?<nIU+�j� ����@t�M�!�'�Kn�,:gx"����Y���2}8_4�mX��L_���4@�����Hڨ����=�7m�ǣ@�3��%?{h.Ϣ�A�56v#�5 |���m�4����Tm���M��y4I<�+,����i4v=�m4%88� �oj�Q���d��    `35�7pAKrq��.]S*+/*��z��_��c"���f�Q�vN`�B��Rt�_�H��8%,�Q^���q�탁�qy�O� �"B|�te�����9��1N�������Z�#�-DXpON����������M��5�pE��jߐ�Yũ��FU[
ũpC��� x�X-��Ƒ��=��+�cd�j��Ja��~� �2�7�@1���jc�e�Y�&���Nw����CP�w5��(�'6��g�)����d-AR�ж����Ϝ��:�11���,t�Ȳ����"yEl�� v���0m�Qq"zwJ]Pr�W�\P��kxZ����@d�yI�:d�m����н�]�5���F��Y����v�v�*V�Fa#�m��zdD���|̟I�Θ�u���
&��X~RiY�0�*� %v�gdw�������@O�S�4��n�[v'�ց�H%�+�5ό|)��ӻ��3 L��/��ɯ��G�H��	U��2ë�BQ���`�[���>g(b="��n�"{ؘ�7
Yzʛv�����UZeˋ��	�S�C��<���o"�x^��v/�G�ؔ��Y�0���/ 5}
l���=*.b/c<<����(���y�M���Ab� ���eQZl� �C���5�#ګ���&�X�p�٪���]#�!~���}�45'�%i�f���*��:������>�Ҽ�CK��|ئ�����أ��3.Y����y�6���Dh�I�{"�J$rFj��ҙ�n�8����9`9-F%I��o;�7'������z'�+]I��O^�8�b#+)|���W���M��o)?���9Ǫ���歰�UРU2�v)筰���*��C�=~�/�6o�Ł@��^}(0Ρ[v>��M�,��Ω���n;ʶSa��cY-������� '�-9���⼠S���t��&���e;�.�4A��g<(pQ����R���Wճ�2�z��rg�x�G��7��H(��!����گ�W^�d�#O�j��wZ�N妼�U˶7T<Cv7q$�b�oP��EC�E-�8>&�T��y4�Ǯ�h<!�җv�I'�4����[s�� ���nW�p�A2�2��Լ��fX��'v�u�;m�n��@UHR� t�8=�1T��E�`��n���j���̞�ܒ����R�S��1�P �g7DK���~[<��8T?��E��P��u��D��6��
uw�z��(ņPWvA���(M��6H��
o���h5:��w��<8���$.����ħ����+Saΰ�^�<t#F�J@�Ǡ>7�B��,���u��^7%���6JZnfr0.����,MW��
�sUc���<��1-�T`-$�6��'�����X��,�~N�І�iRR��̕y�q�2V5}��ԑ���g�k����Y�;~p4F���H>��*��z�AS���$C���� j��ݝL��2�Ztf�)Ӻ��Lm,��2��d;��~���6\�vC�[�'m�'Ya�F��]�_��f�,��ҫ)bI'�hV�f��#R��W3�*��M�ǾK����u͢�Ü��4��GYK�8�Z*��Hb�#d�G�Ĉ{��:L� #��8`�h`@�{�@x@��r�h� M8�)Ź9�F����
��Ij���Bu4r�s���b�i��A�n#�s��S3b�=�2�^�!�ђ4������Hڈ!��GL��n��9f?j2!�(���9�{r6ݓf�(`P��6ˊ�`�B��O�4�	0�}Y!
�Ǫ�.ixk��_�ں���L���Q�>5:���۪��Q��w��7�)�m}d��k9pv�b����|��MA�66�*�*��X��UX�ŞK!��Kߥ^����Eʕ���|��oM�A$�(1�3�S��h�x,�l�.�Aڮ��`}��s�_��c�+&�V�����wZqY�GS�µ�}ñ K'�^��� F#u��b~))�T����mL�"Dl�[J��1�L$�ѕgE�MJ^I��CEn8%y��3��k��&�y�m�oH�]�
��%y���H�;�Q�N�
����q��v�g $�z%%��8ϸos@&}(��Ξ�t��k].�;��`���pc>B�p��T��M�x?���~���[�ir>U��'�|8ؓ[u����i1��T#��Ɣ�ja��z	 1Q�x��!zԫ��E��ۮ���2}=yd1���5������[�`��F@�023ȢB��
�?_�i�v_#~�.�jR���"�?�5��?7�|yC��N�ϓa��?��w�.$����wA�ST�*3�FمĢ�/�N̬�}�t"��e�`�<�&��
�L&�|0J��\ֶ<$!6��rܾ���l�g���W�����vE��es���E��c���Q���������FA_�G5r����q-ܾ�K\�4ߠ�ә먝�ՙV��΍`҃�3�c;��`�7<�38��A		0Υ�:ۅE'�;62�J��r�c�f��!���Y�����Xs�v\NGwnp���F4BN=���l��e5�#v�@)V�=�5\S�p$������xY��f���,Ҵ��e_sZ���P��EN�cY����lJ�)+:�?�L�˨�
������k߁�����(�<�1?k�P)���>޻,%�ó+���n#q�R�k<zϩ97�Mv̈��S��!_d'�UgJZI���Zxۍ�J���������ri�(���<��&g�����;Su?Ɣ�[�Q�"L�߽Lst��8^x{sC��,}v֒	-���l�O�'ɢ�����Q���x�����R��i�*�^�.�RD&)�8=�1�Lm�</��?��*���O�,���:{�C7������i�=-~�`�Np���� O�#��K�e�.�����+��"=��?Q��hOTx�#�D{�f��k̻��֖�2�ے��L2�R� !y��g��G|�r�i��c'ڦ�I�s�a��V��ꤻ�}�XƼf��#fG_o�<-��/����/�ڎnƘq�xY��,.�S�Ya���n{��܅Й4>"/��+�;%�@��t�����'N8 �m��6�:��tJ��:Iq-��̏���F���c��s�&�k�QmF^����w<=r1�ʸeѸJ�t�-&��X�	!8+�Z�肗�	V�ʇ�m�s�YF%�����yQ"��&6e�qc\W�5�^:"����a�ac��KO`�����5W�#^�3!Y>�-1�Y0B���}J�iz������"?��^���#�^q!�W#F˔����������E4G�L����U��h<��s�)�9�$b��"D���BGj��^ 'p��<!Ү�j҂�9oL
����8D/N<��5�7O�^1\c���"�И
�Y��jh�R�38V�T~l�Ⱥoy���/�~�b��0��[s\u�g��4	�5��߳��% �����F0�Ԏ,z`+��4H�L��m�|�IS����ޓ�FuL5~�u׳����5F"���n�>N"�|5x����T@^�������}�M��P���K���H��E�`�	���]MHr��}���U�(m^�M	Ò���N�i_Qx�8ޜ}ae��-q	-�Y����U���
�Yu�p�ު�?D���5��=�6V6�t��v%:-ogW�O�x5A����K�E��w!��m��Ls�՞�[�"�m�|d�i��t�bs��U͓j�rt� ���5�(F*[�"0LQ�J�3��o�fT��e���<-e��u�Sl!J:{W�K�Ě�"���BBkC�W ������BT-�(-R���6��w����`cr�}o��8g��x�䩄r��{�(��be_�ׂ�d��%��\fLKa�M�����&p�K����!�&;�:=�1kQV���K�j� ���i�4��,x���T�Z�D؈~[%�{f�#9-����̵ȜGs8|�ڦFf�JC��$h�������j�1�G��)h3T�f�bw5d;�G�,԰��	��˵�u�=;k�� � �  谩��}_UT�Ο����lwɗ��MB�q~�di
�e)`<��� �Cx)[�B�*�ҧF�/5t��
�q�T�f*�p���$2�KBn&��3v&�I��n�Z��9iO~��Wr��+��T�i�Љ�x��"��h�6ާפ���Nũc�#g��.1���S'�(�f��O�D3W!�j�3ޏ���m���A�/�7���Dcerܹ~?�K,��-AH�D -����f�$N��X0�g��ړ��k`r:a�S<y�ˬ��6f�����t4�$JlQkC��Kq�T������^����/��n��T���F���H���_�d^O�[3ݨ9�PR�fX�4����+l"����WB(�#�Anzmޒh�SiC�[۾&�(�)��=Wu����_�'�
�ڥ&���V�R�j`���P#��?�� Ma0_����=�kFl<d�Q*G��#R��ܞ7�6��S_C�����lz����ڶ`�������gՌ�E��P~�i�Ǣ�ns^o;�qRW�1���L�|MJwa$x#KWxI�{��>k�m&�ӄ9h�H��aԁ�8���Kw0��b�C�!4�OI#,T�:߃2SI�/`#8���<i��r�G��1���*�3��A���_Q+�{E�QKa�*,�{�o;q��iH`@�K����f�g�h�
HRW6����`�rQ<�^1��>N�8?_�hB]jt ˹�#	��@�p+���j��\o�����ߠ@��'V���y�v*�\;�ޣC�ׂC��ڸ�����и*ħ�%�Di�9k�&0���9 �{X�Q{�����\�&��.bQ�]G�:�Am��`���I���t~R����4�������kU��PjV��,�b��9�]�<C��B���)H�����Y<����'�C~Yuz���t�(\@���ok�&���X� (�v.(,�f�=i��%�\J�]��:�q�]ˋUS�TFx�F^!�r$4yV���6�î3%3�19b�a������6�|�_5V`�Am��ۨ
�ou8rU���U��B�-�a���) ٳM7�~K*C���T��C�yc�����j.]����y#*�ʄ.|����(8Cɦ`�s�d��&ͤ��hHgk�Z������Q�����Q�/�h?�؀3V��C���yQ7�Å����{�:~!��|c&���$s�!�Ē�-Հk��m�%>oW�"�Wu�aՎ�ҥU��ɀ$S��h���E5<��Ǒ��XϠJ�|	�O�k�@"�O��9�o>�����qesO5Կ���Y륌 <�P��hQ�_6���5�QK�Vܘ��^(�C�9Ƕ4�1t����fl�L��W^"�E�����xXE P�Uŀa��{�0~����!�Q.��Ө�)w ��>ޒ��T)�O�;1��n&:;�~۫9��z�@�Rl�gE�+O�^�^��
���F(�����^��꽁Fz�l� �{"{Ps�R�oާBh�w~��5;��������עzx��*�����]�VҘ� c�[+n>2v���%��پ�0����ob1��z�/0H$�el�/Y�����������laۛ����{�~IQb_��1�ԓ������O��_�GQg�Q>MuA>?3�9d���/����V,]j�S�~/]���R�����Z�M;�-�;*D�$�~��^ACH��$2�	(��W�p��&9��r��U2�ٴ
m��@�݊�u,s�G���+����3�_1�9�?��Ui���e�`uݗ�=�я~����      `   t   x�3�LL����T1JR14RI�M�HK��(s���,�H/75.O��q�Ћp�3���r�5)�(��p2
O),	�,�,-N-�4202�50�54P04�24�20�370145����� �X�     