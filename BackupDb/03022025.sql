PGDMP      .                }            unit_manage_service    17.2    17.2 *    d           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
       public               postgres    false            �            1259    16427    units    TABLE     .  CREATE TABLE public.units (
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
    blood_group_id text
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
    public               postgres    false    218   �2       W          0    16397    history 
   TABLE DATA           u   COPY public.history (history_id, mission_id, history_type, old_unit_id, new_unit_id, remark, created_at) FROM stdin;
    public               postgres    false    220   �3       Y          0    16405    mission 
   TABLE DATA           �   COPY public.mission (mission_id, mission_name, mission_start, mission_end, mission_detail, mission_status, is_active, created_at, mission_type) FROM stdin;
    public               postgres    false    222   �3       [          0    16414    mission_unit 
   TABLE DATA           X   COPY public.mission_unit (mission_unit_id, unit_id, mission_id, created_at) FROM stdin;
    public               postgres    false    224   +4       ]          0    16420    position 
   TABLE DATA           c   COPY public."position" (position_id, position_name, position_name_short, position_seq) FROM stdin;
    public               postgres    false    226   �4       _          0    16427    units 
   TABLE DATA           �   COPY public.units (units_id, first_name, last_name, position_id, dept_id, province_id, district_id, parish_id, post_code, address_detail, identify_id, status, is_active, img_path, identify_soldier_id, tel, blood_group_id) FROM stdin;
    public               postgres    false    228   �5       `          0    16434    users 
   TABLE DATA           `   COPY public.users (user_id, username, hashed_password, is_active, role, created_at) FROM stdin;
    public               postgres    false    229   �[       i           0    0    dept_dept_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.dept_dept_id_seq', 7, true);
          public               postgres    false    217            j           0    0    history_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.history_id_seq', 1, false);
          public               postgres    false    219            k           0    0    mission_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.mission_id_seq', 6, true);
          public               postgres    false    221            l           0    0    mission_unit_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.mission_unit_id_seq', 97, true);
          public               postgres    false    223            m           0    0    posotion_position_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.posotion_position_id_seq', 13, true);
          public               postgres    false    225            n           0    0    units_units_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.units_units_id_seq', 1299, true);
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
߷��ln�����lCI4���~�ō��j���<�梭��,d����aa      W      x������ � �      Y   i   x�3�|�����Mv,z�����)v��4202�54�501Mu,u��),�L��0�P04�26�21�337361Ƣ�ˌB�J��35�21�3�4����f_� Χd      [   �   x�u��� D�3��Rdcc���:v�3s~?+���m6��q̟�u����k�f�1��.$Ǧ mT�;�QȖ�t�����E�������
��wD!� �BB�U���+��.���L�D!�����m� 
	�w�B��|����s�      ]   �   x�}�M� �5sݐN��]<���0�.X؍�t��fz�9�Ђ��q9������1���L��.I3I�y�g�]XK�
�-S˴sy+�����sQ��WJ ]*{�7�B�؜|_6w� ��Cz��ۮ�rż��f�J(�IjF#�Ȍ���t
���G" o���0�ЎP��߻���0^�n�oX�c�"���'W#f      _      x��]Mo^�q^���x+���4�iv�0�hQI�:��B� )&�ZE)`E2i
$��_�����93��{�k��{���lټ�s�g���U�������~}�=,t�~}�޻_?�_��?�_���J�~����J'��R�G���?�����߫OW��駿���k���GI)���~�����_�������ɏ����O>����'�[�M�(e�'���1��'�+m�':<�����J{���Sѯ�~�������߯O�����7��K��q������L��M���
e�ƪ����U��-�L����@�q��q����/�������ʟ�����SQ)��~��~��G�����޹�OIY��������	��=���Ǚ�����$Lf�P��Az�Fe�#�Ș���D΋��h`�-���z����������.�>��sԵƣ�R�a�n��=l����Y1��	.}ن���'�짝�L�Y�������rbT����֟���*�9[�l��.L�|�8���KKy�oX	ͻ`����(o�8��.��<�uӻ�Q0^�{�����b$�4�b��8����뿃���?.��:�`�mY���ɱ|�b��HG�A^���Q�]�͹%7�����5��K؋�T���!�b?�RwA���T��V�x3\=J/q��Gx=n�@=�i^N��%e
e�)�b����Ӏ�\l!�T��N�/�CG4����W`��_���ڜ�L�W��)�c�K�&�'˙�y�5��P�n����_��؃����1��/��]�__���N
�%S)S���ڲ��;a���G��7�/�M���c<Ǹ��=��7���GY`�G��y�+W<��t�{g�n��XJX���y26����>*к?�Qϙ��wb ���|6�]�q��^��-#��R@j�Q?�Q��ŀ��(�֫�4��q��uָ\��+�-"/9"p������k�+���C����>`�����T>���PF���%u���Q"':��!��_W0 ~�eW��>��_<��l��~��icB�q��>d32�;h�oi?p�NȐO'#eS�����p��{�	�D@�/�nNЊÐχ�u��v�>;��4��}Ԝ�`9C�%�*�ފ�
�Gg�Hp�k��G��O���h?�>N��O`��<��­<�Wt&^0`|Jhq��р[l��w406A�y}u$"��1����}L�;��6�Q/l�)$)V[`�k�$���ё~�����n7����Ό�ł�b ��~������D!�#R ��4�#�n�^���n�#e1�ߥj&T���u}�Ae��p��ـ�(hk:dS���:���pΫɳ����|��j�����Cv{%�@��y���#�4���We�$?;�� ?�O�z�^��G�/V����=�����TM�+���$�~�|/��9���X���������D���i��-����Z<`a@�^�PU �q��.k�F"�2��ޯ���c�ĲY�N��$��▭:>D�.W�/�m�������\_�t`
3&�(C�s\j
f��D%&��bp�x���lņ�����㔛1��4����3r�	�D�ЊiŎ�Kڞ2�;��p9��r��D=������M�����[�S�2�5d��@��
GK��3����	ϵ�����Y��B ,�vD��q:A bPw�*}�bv�<��m^s�{��t0<��W����I��f�8f���Ag
]A�6.�i�$,�"í0��k�t+$z��t�X��?x�c�IKW���H�W&�E��R�°�'��9%�>�_�S9X�=F��T�bjl�4�%���b���4�(��o�Cb��d3�b��B�J
,��^0�
)�z��g&� ����}��\�"����s0;h���7�4������J�&&s\��ULY�إ��f��<�$���uxZ���)��㘴ҧ /Ľ:ԋu��� ����.�v�e.;Є\��-�� � �k9CS8}�Sz���ñ�)��;FҪ��6`u��*16V@Y�#ZIE�����GA1���=���5
�"|`r^��3���D�`�/9wD{P�P���1�#-�{��J�W�qv�Rog����f��2 �a��9�Oe�Nq^�sA���<��<��ބ���Xc6����"K����=�#�D�T��%^�;�}��e;��$~-@� ��i^U�ЦA	�?�kx����<�u�*?�J�S�W!�+��<�O��C\^S�7�D��-'a:����)�h���9nȈ�;��
�EG��CzȖ��$�A���'-p�P�u��:����i�Nّ�C.�^"��`7�@QK���ݩ"����zF~q����@^�h�}�1���~��2t�N��LҎu�����5N�(X#���Z�y=���gCd��zB(�,�̒�i��.Gj91���8sډș9k&�`,[j���V�m?�\�r�X��C��#0�`!h��`��t^�������hP��J�ȉ$vm�S���p�6M.��W��+�����J	X3�����������S���"QRBDk�z����� E#T�c{�6�a��&9�ކ�`)@8��q�&�՜8�)zN$��[�w{jt%�R�����h��2Ȓ1��d�s�,ሻ�i^c!Z]<+j���RS�Ħ=�5�'��Z�S����ӭ|�[	#|=�� k���-�ᖉ���fI;J�z�,���N�b�c�t������g�����#��B&-/8U�����̛�_ߵ�cH���R�3�r#�/�'j@�	1�+�vȢ�|��yc7�Ǵ���\T@�!6��8�q�)�
Fvj0���c�c�a��?BJ��d�V�	~����Ih�C�0��?��-F����V�Ͳ!���2 ]��n��k�HpTk��!8�O�6����
iq�=�a:���a�>¡{����!����C@J�h�%�Վ��� h|C������w$�R�f�9���Y�s�Q+&����78�٢�kg���YR��8ȹnMȺ��S��v�h�5l$�I���C�F�Ey�@���t���%�q�[x�C�g�|��K� �.��ƕ75\0 Ř��F�U�x^WObz!nb�fq�ʹZP �G�&����]2���'o�F��y��gf��5,���A���)W���fY�\����9b&
n�p����4���*�%��Fv����g3���������H�q#>�8H����[Y)���M�V��-����飬�@W���[̣ \A[m\��7��p�3����a�G���p��χ�&�K�^D�G���>à�x�:x��t���yՅǔN������-8!����2�!�Nق2����JB��j)N}��7k��6��&�ֽ�CLJ?lJs�^lC[�8��۬Z-T�e�و3�B���1�DQ��"�9-�f� 6���/%��Q�ӻI��**�0���P(�/�h�{8ZVz��)�ە�oi�3"Q�u��`�h濗)��j@�^6��˹�(�l;�s>c�z���D�Q��bXp"vʤ����Y1e�\�K�*��R��4%���9��4<���?^}ʏ_ௗ�	;qA�����%�6�x�����J�Y�:K�l���ڋ=J��\W5фťF"��$+!u���:��4L9�"��� �0��e�)�},v;C��2�1y��hU�#�&r�},�;��g�ɭ.��Ǩ������z3&�E�__��I��V�כ��b`��5/���Q�X �6�-F���u-�*�IHrە�W1j�G�`�ma�٪�������2�)2A�w�C���X&�@�6FERk���DZ�鴋"u�eɝؔRJ1��+���fZ=ӱ����,��D)��'�)Y&���v���'�V��1ހ�F���9�Z�r���dqrH}�%_۠\t�'��͇i�"Z�'�䔞�:�@�Szh��y��`�/V,>�z�v��    �^
Tyh��������x��P��E���c �3$4w�"��+��3áH�_iT	=�T�P� ~�1�z
Ɍ�	¥1*߶�BI�[U�R�2�|��b�w�'��*<v|(K]f���f%��Zq9�Y�\�J2�ssq֟	5H�뤙��a��M�K��e&���T�١�db�����Se)e��a�kD����<�R��HH|G�&������N(�F�\����5��k��%�r���sk�D+��s�T��
4�e��?�6���k�d��0�1�_i\g��J�H>�b�S,�K���ݣR�d�,}?*��Zz�,޺�D��'��}������2H6���!%��=����UrNK:B�Xy���/��\v	-��d���l)�G=�0Sv(��*�>F�HT�yU���)M�Cj)�a��̊��*���=u�j����J�9��ؑDyc��db�Bܓ�+SS~���{�4Ϩ����=-K>Ŭ�SM]Hi�!K�*[S�l��ۼb��x�S6��a@t�6�M�W��ݎ���/�3���]��Pw�w�)E	�I�1IR��bEm�N�6�I���]���F���AR�a����@�f��]��!U ?'�j� j�5E�q�E��k�xXE��w�p�����Dظ%#Ү�Ó��g�	��@d���V�Ĵ��
�#nlD,�h��&5Qϐ����:��t�J ���)��Z�� <�zr%�6tjj~*:߰�>&�����e� �\�"���埰�����S��z�3��L�?D�?��qq�F����v�< ����j�;�pak펇�mk��Z�0%��TU����Ǆ0��9gY�7I�qQ�W��Kc��r�.o#u�FA�!�O�O�~�	pB�B&TE�"�ڂp^C@ڀ������'�>���HpZ�Y��_q^p�$AOX���KZ�v�q��J��^�c�>�0b�ZH�a��N�-}w���x�?w�����g��Fd�����3<=;g]�TO8@a��~��ӎ�^C��E��tn������~�o�S��i��Mx1��ച���J����Ϊ ~�іؘuo4��C���Y.Q����~�t�����m����/��T��D*��T�`Շ�b�q�Zݛ���t���45�(�,�Qm6���g����ef2��[���b��j���Ӳ�MTL�U��p���&�>~+�64��p^GY�.i�Q���O����"B�����5Qۤ	��S���jgY�֓��*��A���\������Ğ�rώi'�5^��q�7���B1ci3C��MI�Űj�w���tT[�̨�Z��N��9j�p.�4��c����Y=��TU[(�y�dM���*�6���J&\��ƽ���ޢ	l���=�vjǴ�*)L��%+�k[�n�y��|D;���c�h�b�kZ>6��!`yM���u�ķ�:�|/lFx�����W�|�Q\��D���g���T)7|��UeҊ&/b�7|l$�A���0�N����E��j����j��A��¬�.hx����� �w��oh��J�� V�����6B���+P�-%��g��&GƋ�k�R{G�'�<re'B�)�֮�����a��b�X/w�؉<��)G�h]��/�ݟ�{�1m��n���Ƽ��!K`qK��J���s���j�f��
�������C'�;�i��3�2�I2����fn�b$�m�V�H�g*]����H��6>;榲7�ϝe�.��T�'���w�W�l�%�UZ������\�<{Յ�3)���{V���>�Ń�S ���m���#�(��Wf�*Ow����X&/�fTǭ�4���8��}[�ku�%��t?l����<|Z!H�+|������sO{����5��&���h	Ĵ����Ą�K���U}m�y��6��I��7:��Ao5��u�Uϟ���%��5�ē]J�|;C��>�i�:�����̓���K������6��'��F-��ų���Z\���|\���{�KL��g|H�y�$c1�������hYd�������Xd��{�
)���[�z8K�}�����Y���\F��[�#�����������b�`h��G�VY�h۳�ϙ��1����5I/on�H|�e��lW�G�m��.���I�+�|#r?�J�_�}�dC�{)2�^U��:s��
�ϓ���Xy�c��&:��Y�6����V�q�5%�{oV�[_��:r��]E��fV���ic:��P!�^
[�"f�q��b<ǜ�R��!�

��|�&��B=@��B�F�Ln�j���_R�k�$&"��y/�1��R����x��5R�)=H��������J��v\!�"u�4�x� �Bj*��c&��7�4T�����|j��hJl��>�1!�yoV#`ӫBx=�f�-`�\�ض�m#��R*�^:Nh_��F���"7!����Ɏ���&���97hI^����3��f��x�^192��}��@f)��L&dhBI�eE�g��m�93����P]���,[�	x|�A��N����;K(	����-�h{�Z#��0⬻J0.Y���m����x`E��s�qN����y�J\a��� X�]S77�HP�����QG,f��W��,�|ů�b�uӺR��}��s�eڸ>��y�v���8�C�׼�����B?�ŉy7��D[�`�,�e�U�g��u�v~6�m�i'OC��T��V�M�W��G��7�ڦ�x|`�8��s ��y@�^�'�S��)QjW�=��Y���jP���2�`���Z�R��J�!G��r�e�+˻HO�1Z7�N��>aW|�C�z��������QsOr5�-���q�\6v�E&-��쁃^n�1��3���i[��}�M���$j��N�"ؖ�л�F�6�B
�#��)6�;+G-y��Z3i
N�u(���Ъn���0���I<��s�n�-��������E�t𧴔{��Sm��}� e"6����C�'V�v�n��7�0~����:�S��.�췡��!Q?w�	�k�?S��'�N�~n�j6l�
ﾼ��0��T�����s<����8�(���~>vS@зk~�#��%5���eմN���9��	]4x����j����R4>dt�l���)�E�߈�j+QI���v�v(P��-y@�|�;lw^��1or[iA��Z�R6��(�z���V.����l*z/�:�>v�}rI�x� 1��#����q#�T�����n����4�W:�^&�(�`���7j��Lg���1�v�C���&�ܿ��y�wz���o5K�;�V��4a�G6�M2V	&DA�9��+�i�a�˾�(7���C�-�2��?�t?r����hh��B-s�H���x�jq���o"I�4}���D<r!���] 1)F5yʄ:ؘDh̬6����GX6QmD3�mE��z,T�[����p�KvMg+~��+��n#��l��J�3:.x�NC�{��/ҟυb'U��5j����g�d̈8sh\Ċ������Gk��~N&��}�kkZ0=�ܿQJ���ALβ}�<I���j�R�3�&;�N]� ^�)��(�/{��Cv;�
��;�Q�4����>�Nv(�Y7�jo
rz��#�-�?(o6��	ŭÓ�L¶�i�@J+�܀��)v	��"��(K[Q����#񘊇�v\,wHi �ѷ�p�)
�)p�N�Y���P�Z��[+lI�#�� ���TƆo^���4"u�jYڪ�kf3�/�%l�2S5y;-�S��ZԊk�^��|!]?v�7���e��|&�H$�8(5j$Hh��מ1��#�=b��C�S�Z'/�UZ*�*��Ƀ:�m���Vr�?Ac#�����&��:��fZ�&�X`��w�l�qak��_6CT��,� j�1X��Lm��ǝm�p?��H�R�7�Y�E%�>�)��w�唤z�}�.��gP�|��8z6�f�mmīZ�}�I P��;4k�iz%^�E���y�5��v��6�� (  ��{��Ԁ�09}SB��d�h�+X�i��-&ꟼ��/���E���*�?�DO����������9��hq��74��(�Zk�%X?i*�|%�~�G�/���	l:w�>i}ݶVL���rKb1��x�G����ni@�y�U�n��-�����҈���B%r2�_'�%�^v�!�پ��Z�=j#�h�֞�r����N�Ǿf�+g~7��ާ�E+`^�;��nh�E��z�6ߌ�1�`nFt��	�us�F���>l�Uu>����j� Xc#c�tMQ�n�t{������9Sˉ�bzi6�O[2�NjC�y��Jjdh��4��V��xA�(�:kDW�凢��C����s�F˗�QO�9d|I����I �����a������,�&�:w.�{�H��!��1>P����Te��n�O�ADA�i{ji��tH�l�a*�C�ʓ�E��P�k:
)�2&�'y���EG f܎�iv���碉�Q'��m�K_!�-�J�S(m�Z��{̥+;B\u��|s�p�Y
��-�%i9Z3��x7���(J,�Tb���@%�E	�3��jRg��t�\7�v�)��[Q+F->�9,�TQ�c.%&��L���.X��)R�	{F�o��9�5E�_���	3�Q�vD�r~�"|7���C:�s�R?`������/402&��5N+x ȧV�Po�pX������Is��'G��&Ҫ[zVhHCΞ��p1ؿe��3�pU�� �J�hsB��<I�E���l�l�`M���Q��1��x7��p�a�[nvw��������'���u�^�ew��"�>�Q�<���6ay ���Z�
�OY�Sѯ�~L���Q�؄���f152�V1-C�L3y�}�~���!o�Wfh%T�Qc�+o�'3����!z�W#p9ũ����hA�����y����l�Kג4�9�mC��+p����e��m������r��w�?(�?V��+4@�'\���@�q�:�O�L
��D�[ .A���M\��{hM�:�F��ݛ�+�}cf�a��a���@��Փ�y���&���1��C�Hh���qr�-�N�׫i�C��g���$���Tl`�Rʓ{�/�A���S��Ɠ�B��Z�^�	9��S!�U=�ޏ�O���m�3_LK��J����0��i���c�X��G�k"����"=�S�2�`��CR�9�MɈ�߾�w������o��<w�$$+����]���ֹMa����"�Dp�6�3Ǹv�š��<���'�7�)��|����NRÆT�(�%���HY��DKx1�u\u��h�7ᩬ���` �5Ɂ�i8����%�7�q��9,���?��'I�b�ʮg�$�H�U��%��$|��@��{���';�VA�6����^��&�ko�N��-�b�c��D���6�ϧ=6�&g��'������Ƅ�C;�]A����0��b�n�����KH�\$��tZ�5ս��߉/~߼���cC���YL!T��<��Q+�]p�j���384_���ʣmh=T�v��
S?�x������      `   t   x�3�LL����T1JR14RI�M�HK��(s���,�H/75.O��q�Ћp�3���r�5)�(��p2
O),	�,�,-N-�4202�50�54P04�24�20�370145����� �X�     