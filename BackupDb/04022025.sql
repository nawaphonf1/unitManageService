PGDMP  %    &    
            }            unit_manage_service    17.2    17.2 *    d           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
    public               postgres    false    224   Y5       ]          0    16420    position 
   TABLE DATA           c   COPY public."position" (position_id, position_name, position_name_short, position_seq) FROM stdin;
    public               postgres    false    226   �6       _          0    16427    units 
   TABLE DATA           �   COPY public.units (units_id, first_name, last_name, position_id, dept_id, province_id, district_id, parish_id, post_code, address_detail, identify_id, status, is_active, img_path, identify_soldier_id, tel, blood_group_id) FROM stdin;
    public               postgres    false    228   �7       `          0    16434    users 
   TABLE DATA           `   COPY public.users (user_id, username, hashed_password, is_active, role, created_at) FROM stdin;
    public               postgres    false    229   �]       i           0    0    dept_dept_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.dept_dept_id_seq', 7, true);
          public               postgres    false    217            j           0    0    history_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.history_id_seq', 1, false);
          public               postgres    false    219            k           0    0    mission_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.mission_id_seq', 13, true);
          public               postgres    false    221            l           0    0    mission_unit_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.mission_unit_id_seq', 124, true);
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
߷��ln�����lCI4���~�ō��j���<�梭��,d����aa      W      x������ � �      Y   �  x��SKN�0]ק�b��%��
��u%(,�TR7$�6>
�	�*M[�)�Ɠyo�=O� ���SxIq��,��@0�J�J�s�K�J��
/��*
.���Ҵ2�T�A�����4��Qḵ����d�I�5���l���Ha
��e�⁩N���.J�
f=3^X*�t֝�K���a(D��A=��B�y:c�NkA�1�V]��k��S��K��]j�v��09��9V���C�8�Aq�ɶ$SX�}�p���W�(V��<���>9�7�կ��ZkY�CG���o,dr5���C�݉��홥BaTg~�� �yH�3�)��-�9��93C���;� �[���ڈ7�a��;�EC���y!���i�C�ep�q�1^�Bz�����>��QB��-�      [   E  x�uӻ��0@�Xn��h��T��_�[�H69���e��Hk�@�b�e������'7���U�\6 ��ALi�
�IN�nR�y�Њ��
�@�YċU(o|�,ff!h'���[H�Z��B��d�|5w��6�B��w�B-V!�
�|SL!r\/�z�#B&Bn5�ĈW�f��Ο�1r��0�V|Z��;�L�j�J[t�q����(a2��b��اV1��JE�C#WƵ��J^�l]�X[���c�#��4�g�����i��~z�r}|F-�V�-����ědJ��:�O�+�Ir�u�ܐ��"�W���|B\QN����<�o�x      ]   �   x�}�M� �5sݐN��]<���0�.X؍�t��fz�9�Ђ��q9������1���L��.I3I�y�g�]XK�
�-S˴sy+�����sQ��WJ ]*{�7�B�؜|_6w� ��Cz��ۮ�rż��f�J(�IjF#�Ȍ���t
���G" o���0�ЎP��߻���0^�n�oX�c�"���'W#f      _      x��]Mo]Ǒ]_��l�����f�`� ���f0�A�3�bv�B����R���)�h2~�7�)�U�U���,��]#�-�_TW��:uZ+���W�����'��K���ޯ����)c���~ut�zs�zq�:�_�ݯ�W7�֝�~���Wg�QI)ׇu���~����_��w_t������g�i��?�����g��ݯ�����~������?��O���>7����1��t�W���w��i�VF[���Dk���=Ñ~y�:�_]�pԯ�W�8�<��������"�,e���A{�\�M^������ԧ?M����o�OS�_���y`y�F��6Ai#MP��3'8���a����~�w�z~�Z�/�i�)����{���^��2��<|���?OE_����w&/��V��q�����;�Jc�Q!�X��h��We�����)��u�5�9��	����?�������S1ۏwV���?�}�Jkχùy�V2=�g����=�8��1��L�d&�y�!�!G�S�>{q�8G�-��h:�w8�78����;\�}�U�Գ Sw��aiS7�Oj�be�c[1km�����G��-�c`κ�,o�e&���d,����'[9�_�7g�F��vaj���bR.-m��&��w�����(o�9��.��<F��i�ب8/�}��÷rb��p:�����|�k~�K>�����y{���������w9�-(�S��t��$�B�sK��C<�g��k��K؋�T����S-ud*�L%Xm���7�Sz�+��<��qK��y9\b�-�SȃL�gg��<
D
`��
DJ��9������E����؜�GC^�h�vM�-�e$��7,�P�N���W_��]�a�w��:�o��T� �B'���K���#C����y���U�����Q}2��o��:~�r+裂SXܔ�y�a�a��rųyJܲ�w;�.�R������[� ��q>np�Q�f����=;u�����lh�^��	+���6��7�K�)F��E5N\_#eغ+�f{�2N��^c���y�E�%&��	|q�zM�bA��r�q ��X��/�$�siy(#Fc"`I�8r�9��?!#��_0 ���r���}������P���o>mL�u~� f��wJp���[uB�|:�	(�������$��o�2��(�����0�����=���/�gg'�桒��@��	��Z"���:*��E��^�A>��h�0�$�A��c���r�	<��=0�p�M��l�Ƨ��w::pc��]���&x�G^_)p�X�2����>���M��Q/l�)$�^[`�k�$����I?d�xs�n7����lF�����6�Y�{���z���	"��QR �:�t�#�n�>���n�F��M��K�M�)f{׼�J6	�+������C69� 쪣_�P;/.�"^6V����m�G�C~{%�@�����&ҏ�k�pg��xU�������sJH�o��nC;��	M��s?!��!��8�glqS���� n���獀�<��ޯ�������IX�!y+R�w�������؎m���I�R��1z��La�T��[��RS0�姬\2yW_2%yޱ�;a�~[|>爐�ᵱ��ɭȹ	�.���Kߑ_c�����x���F��U#���ˡ]l��QNfYp��)v�u�o����+0�ٚ{4�m��_L#�`�|u�9�+�Ċ��c.&��bRc
|A�d6.�A�IX�E�c��d�p�J)钑�U{���^,�n�x[n��n{��<% ���y���� �������ۋ?M��U�d�TT�D�h��W\v|U2�sL�oGo�Aڡ��%�H1�rGI�I��ɉdY`����k-:�LpRx[Zt��A�gw�l�$�<��w���oi�m��0�*�.�g�U ��Ln��$Wy>)Ŝ
jd!{���WU�!Ő�	�,��:������7M�氦�w���|� ����V�qJϪ;�p�GKB}vca�˪ާ�9ʼQ�*q6Vpy�#Z)|���d��Ǌuv�棢)�J�"���g�����p/ �ɕ
ڃ>���ψ|�*��'��r�{GW���lZr�_�5��U�M�c�V����"_�,��$�q?�D�7INV�rIy���8ƣ=Y:��=�.���!B��|���>%G.�9��$Z�84 �>%ҼJ�.��}����)���e���S������OI���� �?rT.��R0�i. "E��l	ө�ōNч�t������C��Cj⨹z���q~�JW�A�%�1�LZ�9���M�@u3��8��#����e9D.`��׈��=,�#Fw��(��A3,�3��~��r�	�'���s����������3�"W�>~����F��1y��Z<�!�wp�FώȒ�e�zB(�<��d���v���I-G}036��pO���h��I2U5����|�μc�P��=�� '�#���C���2- �!������ ["����O|�YL�i�1�[��*7���i���~Η��[��0�֜�҈�Ѓ�?����	�)��� 1��CDk�z�#�)	@�F�J�m��0 ��ۛT`ZN�� ���)$V�ġ��?r"���R�z�W�F�(��¶X����僤)����^My1'e�x���h,D����L5�laLlTN|�S\�}b�G�3u:_`<$��z+a�/��0`-�����L��g�&��]�se�޶4��^�n>:�1������k��<��2t�օU��I����a�(%�yS��]1=���Y���@��ۆ!'�@�	1�r;�QZw��yc7�Ǵ�z�g{�˃Ӽ��\8�b#;%
�����c�Q��_�)��d������Ih�#�0�������������o�ˆ(2&�?|���IWtB��ƍG��>'(�	��ͳx)ذC�=�����9�C���ݫf�����!~Hi'Z��j�q�	Q�qa�1QS����6�%r/T�����F���Ćvk�W�_��]�A�M��kF��b��z��t%�K���%m�A+����7L�6N�)���ĩuo�rG�<��uq���"��,~qrF+(�'��1�\�Q�n3�{̥�7�ߖG���_��YG�*�~���N�` 'Yf (W21�#9�$�4"\<bO=�i�gr�ϱ�6j�\p�q}` ��\n���L�P+v���Aj��h��d��5��I�����!X��s��Ə꺂�Zt���9�U�����wv���A��rǅBj+�`A�5E�V���g�}��!f?�RnA.7/]�h?|ᱢ�3�?#͚o��(xu]p���ӡ�|8�=)�/�da��' 5�+�}�����
|u�v�k�[�gt��,��S�_��l�f��n�g�rtS�c��D����Բ�v��v ��q�T����E�-w^�Jt?;�����+�`�0-��<���0�m'.�#�r!'��F�X���)�U�]!�j<y�siH�������؛�;*�\��ˉ���<szL/撏J����8�H����>d��4D��!��7}*O_ௗU�v��B�*��C�m��� ��4U���[�`�2ۭ���`�*���� �h��L�C`��z:E�+��p���Q%lg mX����>f��C:{z������]��`��e����K����rȠ��70Ŵ�ʗ1�=��z�;8t[ץ���t���_��A�Tzd�9f��O�;O����tX����mV��W1j�GuX�ma�ת����䲽e�	dY�tw�u	!{����R!`��ڲ@�t��)��;�&�S��� ?�s)G�}�]$�dk� �d�r�ջ#B�A�7e*-�>,���>���9-k��$�P-^� ���1U$�$�^���(���yЇo�aEЂ2�<����|����qr����K5��o\4Y'����ô�:ଋۣNri�z    ��Kͥ=t��<@��`�/:&�W߱=.هF?��٨��;��r۵��'�:+W�#Җ�"N���ބ�9g�	D �H�L��z�%���/�C�%���=�e'�L��|��%������/d�w��}Ů�-�o<���3��J3��#�b� u��vVY��
��VX<���=(�뤙G��<"���L��w��&�����١m�b��̩ a�)Ô*H$����.����13qfF�'x��FT�UU&�Q���`uÅ�ٶ�Z�Ւl>��Hǳ ���͔x�]���.������f� '��	$N�K�E:&��;=��j��4��e���	��}1�0PP�KA��Gƴ��FB �{T��(�(e�s���\O�4�!�E�&f0�C�M��\�l?Hj�ʜ�ڈ��ߛÈgE��k�9�EЪ��䊟״��y!������S�B�}�~��
煽;���������QµW<NW�S�#����046²R_L�qV�>�
Xh�1+W�U�#f�~�f�=�s��QkCyc6����עD��j+Sj���|V�B�l���a>��:���S�[H�Ȣ�)�2���U7Z��;&4�	�8e�_9D@iM��z������ڔ��ూ�B���1)x���)E"�I��"�=�bt�N�:�J���]�]�1�Qb�aA��8�`��.��`
�so9��
[Ѿ!��	�̡�_�b�5De5��C~fXj�e���U_�e��'I�e koRR[q�7C�-h��Q��RN£>��_=�D˟���<�㗃�O��9�/��vu���9�g�hkΩ�:;n�	ݧ7�C�d�6�X�QQ�*)o�H�ML��kl��d6���r�i����(YU��O�}|ʈ�)��*&5���o��0��r��Fک��qN�:
�l�;������C�5�W��<��M��Fl�3�B*"Ͱ�(kl�����DW����7ow�\�Is�|t�ɿ/�-/�����X<U�pu�(T�8���o�6[������Y>U��So%[/y�᎕��#�(�h����玐 ՎA���Y�p$>C��á���H�z�SS�J�zQ�BST�o����S�V�65O�S�b�iO�Mxp���x�(�U��o�p��mIS��>[�h���m������g�$lI�K�i.l~"�@��JR�XO]�@�����(y.�2v�L+�i�"�N�?��Q���璨8*�10�w�LK9$Mf.À�p�ڰ���,�G�f�<-�߄��Y���t�ڋ�yߋ>?(��HE�/�,9Q�(K{������-n=R?&�5Qdj�&�h��v�6_��(S.��
)~T�F���	�q��wGR�OoY^d*Ѻ£u6n�������PƘ��P�"�U�v1tOq��⒎�*�,;B�Mk�����A���6�qM$v��f����T�!_͋�����eIxt5�\�U7v�ՙ��n&d�e�n{��$�'S7դ0]ߗ\�.z�M=v���>*36 w�a��$x�bܴ�mJ���l}E1�M|�_�7H+���ɮj��o8���N��� ��/��(�~)7|��W�l�U��5|�<�@\��b����B�pE
�����؀3h�͐X�3^����7H�}�:�5���Ab���<o6�Z	�WOFE!JSl���oƋ�қ)��A���0!�\��č�AүA�c�LS؆r��H�P�Hh8�| R�D�r�݈b����v�~� }ш��x�J�t4~ʰ1u������ĸD�ψ�lHNO)�y�ħ��	��S��b �#y�-�7u��^Ϸ�����г�#γ)
�:Ɏq�^�lO�3s#�2�_��#R�Ԯ'�����u�w̲�7�FS6`�V:��@-���
���CO��Cg}���K{�a��~&��Rxo�P��@i=_�"����-�h��G���pǬ0��p�~���z׵���j�����yx-Dl�Y��yc�<|� ��>�Ѡ���ѧ�~Тue�b������	8Z":m��9�롦��%������N�Z�6�ŋ��8&�n����wz?�FU�h������#S��������E����I���n��%��.�_|����ψ8MQ�x֤쐬9�'cZm�������H�lE*)Y�(�!.J�5����;���d�y��V�C4���rF\�D�iQmж�%=F՞�5����fCQ��m�Xd� ��a����|#��ڶ���r<.J]6�ᶤ�w7F�̘��v�o���Yl��~f4(�J�W\^�ۏ��ܯ�	m2�!n��ހV+�'b;4�.^������^�U�Oѷ�� i~�j�V�=�&G��-}�QH��#G�����"��N���A[7�R���bmHC>�1ZF+�s�u�Ҩ��_����,چ8u!39�~h�������^�� R]�OZ���g���\L�f�夂Sz����ӧ��#+u��q[n3x��j�y�-@b�>��=�f&��7�zV������>m�.��_�c�1!ۼ7�ش:.^�o��04ȼ�!��m�r�S*(�:�@h_DQk�S��[��P2�dS�ݪǩ��M�G�snВ����C.��<o��^q�g��_((��r�f2!CJ���ocZRm2Lk?�(e{�^#�g�pI]%��N������/���x�p�@1��9v�^��T�f2�QFw���'f}�)��#6S����-_�O>����W�Q]���:g7yXs�KLkGy/�9���
G{(>��w�t�F-�-�uw����\bol]"��K���]�=���m��t� 2�P�5j��wa��p���
����[8&C��ט�ӈ�����,9��"\�$�4���0����A�l i{e$�0��*I�J[��J�aުW����p�w�\cm�*��ᶢvv����Y��p.�LN���#�Q\*_�/E��Xx8g�y��߳4�z�Y����p�\��x�S��Ź��lH�^Q5�p���2����Pj��t�ZybE����R|�ނ��2��Oi;������|� y6�M���_αay��+��d.=��e���KE��hhYi�> �����Z��DZ�N�� �L՘g\h:�n(�
o¼Wk��d�%��eU�<1�W���W�n���C8�|�0����%�Ij���KW�*^�aN>���
�?o�p����>����r�纫��1��O��L�4O"RW�0B]��M˅'%OY�O�9�ƛ�%6Ln+�ԉ;h�����|�g��l���7�-���[�;�]Tzq�Y#��T)a�ӏ�+i��}�5�m`7�K��U�>�t_�V�����3�(��L��l!���2�v��	��,�RLy.Oo����p[���oB��&
1�h�o����!���~Tp��/߶mZ�B�v�W��L%N�ȕ��8m���<�������6��W�cb-�#�M�ؚ��]���,.��5��&Ũ&Ϝ���)h�t�����#,��}֢��B{gҳ�aI���W�YǏ��C&��w@hk�Vj��q<�;�q����F?�3�N
W��k�Aj�i��{�<�q���LQ��U0��>��x�k1���/�1h�2
�ȍR�#?��̓����N�!��a�c���<EF���U.���;�}֠z�Sh���I�*�}��NP�?�=�d�n�U%`�p]��:M	`�q�Q��I�K��:<G ��O��Sj���EjU9��
_[�/ �,���yZ��ʱd�v\��t9���r�P
j8y1�t3UV����a��u �q��8Sԣ����Fj8C�H�Fp���k	%�ש&瘟ctJ���q3�^��D	d�s9����{�����X�E´�F�
���|ё9ޘn%[P�Z�*�8���b��B�RyN�٭5�wkjbۂ4�Ff+��0��u�QʹL�1õ��%�ą�9~~��.�:��6�l��z���?g��A�:�t'��)�H�������!5���Ҿ����=-�r$�/r��'o& ��*-͗Q!K	���Ħ^� >  ��{�s�ޫj{գ���%V
����-Ez��\^�i���,�����M���yB^��)^�51��}�x���#�ғ��|��]W�`�;����\��t�|��'FI�Z3��câ)���(�����xY��U`�8#�3�z�Z��^7��d v/]��yD���tW����;L��������F���P+ᐓ���/�����h�}O����HW�ъ-��r��Xw'og_3/���k��ާzo�T�^�w��z��/��#4��d�荙p2B�3��3���7�.~�b������$��& �5�,�G���횏�m����ΙzNd��+��}�y(vRD��B�%�у��6�<�����摊tV�x�������J���:-��F=QO��%O&]U�+�;ċ�Þ��{yY�
��<�r$��Mf��P-:�u���k�9��(�1m�U̢	A��0���pP�<�dCχZ��P(Y�1Y=��g-:J `���6/P���N^ğ�8/:@e�J�;-u7WQ�=��I\5�+h�S��q����ڢ:D�R����ݨפaPTX�)Ǿ�{"K4G	�s%�nҏ���4�J��vIS8o���2Z|sX�6(D��ܻK�3-�/�U��S������E�����oؠnP�`92ގH��7Y��9�x~(�z�0�V��:�赢a[�"�b�1�_��Y��@>���r�8� �n!z0������rt*h"uM���BCr�FM#��!�L�ޜ�ǳE2����D�JUg��$�=��fgPE��`;�
3%��w��S�޲8�M�S4J���>�����Pr8��
wX!<���nc��n##,/ԡ�>�X�"[��S�T8��'�[K��%�}��W�:K�L�H���6�Ŝ�o>� ?T�n��
�+3�KU��c{�$��Gm��
�u|5�Ч8ea��;Z���0�l��[GI���:Gpu�?�v�P���"�d��T+����5�\~^돪�Yݒk� ��\�T��V	�%���ɤ@�����%H50օ�0}���PG]�P�{�x&���,*�x�{K�P�[=��GL�AJy�S�-�	mxt>NN�ń����ŋ�d�A��Y�t���M���!)�~rn4�%W"�yt�?/񤼳�<����j���S�/�:zƽ��V�R�u�3_LKrw9rk�sM�4�B�1�FLÉ��j���W����P��C����4��w#���n.�YĦz�[��y��$$+o�b,�1�	�KX5#�y��c"���	d�;��A[q^Zঢ়���A5>�����NS�&Ч{)�=_�Ԑ�U%S�h	]WM#�-9�&y*��m=@����o�i~�@�Myp�m�y�E���(��V���"�4"t�|�q7	~9$B��z��:ЛRih��gIA��o�I�h��>K# ���4�f<e�
��f�n�?��}Ċ����7&)=��[�% D��%s�R,t����\Bz�"Y�ӂʨ)�K_
����ŗ�;=�YH�C�.gv�е56
xH�J����~�ĭ�g68��P��^ɣ�h=t�6��
K?�|��'��?1��      `   t   x�3�LL����T1JR14RI�M�HK��(s���,�H/75.O��q�Ћp�3���r�5)�(��p2
O),	�,�,-N-�4202�50�54P04�24�20�370145����� �X�     