--
-- PostgreSQL database dump
--

-- Dumped from database version 16.7 (Ubuntu 16.7-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.7 (Ubuntu 16.7-1.pgdg22.04+1)

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
-- Name: claim_reason_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.claim_reason_enum AS ENUM (
    'missing_item',
    'wrong_item',
    'production_failure',
    'other'
);


ALTER TYPE public.claim_reason_enum OWNER TO postgres;

--
-- Name: order_claim_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_claim_type_enum AS ENUM (
    'refund',
    'replace'
);


ALTER TYPE public.order_claim_type_enum OWNER TO postgres;

--
-- Name: order_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_status_enum AS ENUM (
    'pending',
    'completed',
    'draft',
    'archived',
    'canceled',
    'requires_action'
);


ALTER TYPE public.order_status_enum OWNER TO postgres;

--
-- Name: return_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.return_status_enum AS ENUM (
    'open',
    'requested',
    'received',
    'partially_received',
    'canceled'
);


ALTER TYPE public.return_status_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_holder; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account_holder (
    id text NOT NULL,
    provider_id text NOT NULL,
    external_id text NOT NULL,
    email text,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.account_holder OWNER TO postgres;

--
-- Name: api_key; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.api_key (
    id text NOT NULL,
    token text NOT NULL,
    salt text NOT NULL,
    redacted text NOT NULL,
    title text NOT NULL,
    type text NOT NULL,
    last_used_at timestamp with time zone,
    created_by text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_by text,
    revoked_at timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT api_key_type_check CHECK ((type = ANY (ARRAY['publishable'::text, 'secret'::text])))
);


ALTER TABLE public.api_key OWNER TO postgres;

--
-- Name: application_method_buy_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_method_buy_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_buy_rules OWNER TO postgres;

--
-- Name: application_method_target_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_method_target_rules (
    application_method_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.application_method_target_rules OWNER TO postgres;

--
-- Name: auth_identity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_identity (
    id text NOT NULL,
    app_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.auth_identity OWNER TO postgres;

--
-- Name: capture; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.capture (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb
);


ALTER TABLE public.capture OWNER TO postgres;

--
-- Name: cart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart (
    id text NOT NULL,
    region_id text,
    customer_id text,
    sales_channel_id text,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone
);


ALTER TABLE public.cart OWNER TO postgres;

--
-- Name: cart_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_address OWNER TO postgres;

--
-- Name: cart_line_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_line_item (
    id text NOT NULL,
    cart_id text NOT NULL,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    quantity integer NOT NULL,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    product_type_id text,
    is_custom_price boolean DEFAULT false NOT NULL,
    is_giftcard boolean DEFAULT false NOT NULL,
    CONSTRAINT cart_line_item_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


ALTER TABLE public.cart_line_item OWNER TO postgres;

--
-- Name: cart_line_item_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text,
    CONSTRAINT cart_line_item_adjustment_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_line_item_adjustment OWNER TO postgres;

--
-- Name: cart_line_item_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    item_id text
);


ALTER TABLE public.cart_line_item_tax_line OWNER TO postgres;

--
-- Name: cart_payment_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_payment_collection (
    cart_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_payment_collection OWNER TO postgres;

--
-- Name: cart_promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_promotion (
    cart_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.cart_promotion OWNER TO postgres;

--
-- Name: cart_shipping_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_shipping_method (
    id text NOT NULL,
    cart_id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT cart_shipping_method_check CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.cart_shipping_method OWNER TO postgres;

--
-- Name: cart_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_adjustment OWNER TO postgres;

--
-- Name: cart_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate real NOT NULL,
    provider_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    shipping_method_id text
);


ALTER TABLE public.cart_shipping_method_tax_line OWNER TO postgres;

--
-- Name: credit_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credit_line (
    id text NOT NULL,
    cart_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.credit_line OWNER TO postgres;

--
-- Name: currency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.currency (
    code text NOT NULL,
    symbol text NOT NULL,
    symbol_native text NOT NULL,
    decimal_digits integer DEFAULT 0 NOT NULL,
    rounding numeric DEFAULT 0 NOT NULL,
    raw_rounding jsonb NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.currency OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    id text NOT NULL,
    company_name text,
    first_name text,
    last_name text,
    email text,
    phone text,
    has_account boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customer_account_holder; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_account_holder (
    customer_id character varying(255) NOT NULL,
    account_holder_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_account_holder OWNER TO postgres;

--
-- Name: customer_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_address (
    id text NOT NULL,
    customer_id text NOT NULL,
    address_name text,
    is_default_shipping boolean DEFAULT false NOT NULL,
    is_default_billing boolean DEFAULT false NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_address OWNER TO postgres;

--
-- Name: customer_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_group (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    created_by text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group OWNER TO postgres;

--
-- Name: customer_group_customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_group_customer (
    id text NOT NULL,
    customer_id text NOT NULL,
    customer_group_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.customer_group_customer OWNER TO postgres;

--
-- Name: fulfillment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment (
    id text NOT NULL,
    location_id text NOT NULL,
    packed_at timestamp with time zone,
    shipped_at timestamp with time zone,
    delivered_at timestamp with time zone,
    canceled_at timestamp with time zone,
    data jsonb,
    provider_id text,
    shipping_option_id text,
    metadata jsonb,
    delivery_address_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    marked_shipped_by text,
    created_by text,
    requires_shipping boolean DEFAULT true NOT NULL
);


ALTER TABLE public.fulfillment OWNER TO postgres;

--
-- Name: fulfillment_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_address (
    id text NOT NULL,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_address OWNER TO postgres;

--
-- Name: fulfillment_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_item (
    id text NOT NULL,
    title text NOT NULL,
    sku text NOT NULL,
    barcode text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    line_item_id text,
    inventory_item_id text,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_item OWNER TO postgres;

--
-- Name: fulfillment_label; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_label (
    id text NOT NULL,
    tracking_number text NOT NULL,
    tracking_url text NOT NULL,
    label_url text NOT NULL,
    fulfillment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_label OWNER TO postgres;

--
-- Name: fulfillment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_provider OWNER TO postgres;

--
-- Name: fulfillment_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fulfillment_set (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.fulfillment_set OWNER TO postgres;

--
-- Name: geo_zone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.geo_zone (
    id text NOT NULL,
    type text DEFAULT 'country'::text NOT NULL,
    country_code text NOT NULL,
    province_code text,
    city text,
    service_zone_id text NOT NULL,
    postal_expression jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT geo_zone_type_check CHECK ((type = ANY (ARRAY['country'::text, 'province'::text, 'city'::text, 'zip'::text])))
);


ALTER TABLE public.geo_zone OWNER TO postgres;

--
-- Name: image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image (
    id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    rank integer DEFAULT 0 NOT NULL,
    product_id text NOT NULL
);


ALTER TABLE public.image OWNER TO postgres;

--
-- Name: inventory_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    sku text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    requires_shipping boolean DEFAULT true NOT NULL,
    description text,
    title text,
    thumbnail text,
    metadata jsonb
);


ALTER TABLE public.inventory_item OWNER TO postgres;

--
-- Name: inventory_level; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_level (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    inventory_item_id text NOT NULL,
    location_id text NOT NULL,
    stocked_quantity numeric DEFAULT 0 NOT NULL,
    reserved_quantity numeric DEFAULT 0 NOT NULL,
    incoming_quantity numeric DEFAULT 0 NOT NULL,
    metadata jsonb,
    raw_stocked_quantity jsonb,
    raw_reserved_quantity jsonb,
    raw_incoming_quantity jsonb
);


ALTER TABLE public.inventory_level OWNER TO postgres;

--
-- Name: invite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invite (
    id text NOT NULL,
    email text NOT NULL,
    accepted boolean DEFAULT false NOT NULL,
    token text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.invite OWNER TO postgres;

--
-- Name: link_module_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.link_module_migrations (
    id integer NOT NULL,
    table_name character varying(255) NOT NULL,
    link_descriptor jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.link_module_migrations OWNER TO postgres;

--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.link_module_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.link_module_migrations_id_seq OWNER TO postgres;

--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.link_module_migrations_id_seq OWNED BY public.link_module_migrations.id;


--
-- Name: location_fulfillment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_fulfillment_provider (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.location_fulfillment_provider OWNER TO postgres;

--
-- Name: location_fulfillment_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_fulfillment_set (
    stock_location_id character varying(255) NOT NULL,
    fulfillment_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.location_fulfillment_set OWNER TO postgres;

--
-- Name: mikro_orm_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mikro_orm_migrations (
    id integer NOT NULL,
    name character varying(255),
    executed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mikro_orm_migrations OWNER TO postgres;

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mikro_orm_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNER TO postgres;

--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mikro_orm_migrations_id_seq OWNED BY public.mikro_orm_migrations.id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification (
    id text NOT NULL,
    "to" text NOT NULL,
    channel text NOT NULL,
    template text NOT NULL,
    data jsonb,
    trigger_type text,
    resource_id text,
    resource_type text,
    receiver_id text,
    original_notification_id text,
    idempotency_key text,
    external_id text,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'pending'::text NOT NULL,
    CONSTRAINT notification_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'success'::text, 'failure'::text])))
);


ALTER TABLE public.notification OWNER TO postgres;

--
-- Name: notification_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_provider (
    id text NOT NULL,
    handle text NOT NULL,
    name text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    channels text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.notification_provider OWNER TO postgres;

--
-- Name: order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."order" (
    id text NOT NULL,
    region_id text,
    display_id integer,
    customer_id text,
    version integer DEFAULT 1 NOT NULL,
    sales_channel_id text,
    status public.order_status_enum DEFAULT 'pending'::public.order_status_enum NOT NULL,
    is_draft_order boolean DEFAULT false NOT NULL,
    email text,
    currency_code text NOT NULL,
    shipping_address_id text,
    billing_address_id text,
    no_notification boolean,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone
);


ALTER TABLE public."order" OWNER TO postgres;

--
-- Name: order_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_address (
    id text NOT NULL,
    customer_id text,
    company text,
    first_name text,
    last_name text,
    address_1 text,
    address_2 text,
    city text,
    country_code text,
    province text,
    postal_code text,
    phone text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_address OWNER TO postgres;

--
-- Name: order_cart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_cart (
    order_id character varying(255) NOT NULL,
    cart_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_cart OWNER TO postgres;

--
-- Name: order_change; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_change (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    description text,
    status text DEFAULT 'pending'::text NOT NULL,
    internal_note text,
    created_by text,
    requested_by text,
    requested_at timestamp with time zone,
    confirmed_by text,
    confirmed_at timestamp with time zone,
    declined_by text,
    declined_reason text,
    metadata jsonb,
    declined_at timestamp with time zone,
    canceled_by text,
    canceled_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    change_type text,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text,
    CONSTRAINT order_change_status_check CHECK ((status = ANY (ARRAY['confirmed'::text, 'declined'::text, 'requested'::text, 'pending'::text, 'canceled'::text])))
);


ALTER TABLE public.order_change OWNER TO postgres;

--
-- Name: order_change_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_change_action (
    id text NOT NULL,
    order_id text,
    version integer,
    ordering bigint NOT NULL,
    order_change_id text,
    reference text,
    reference_id text,
    action text NOT NULL,
    details jsonb,
    amount numeric,
    raw_amount jsonb,
    internal_note text,
    applied boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_change_action OWNER TO postgres;

--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_change_action_ordering_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_change_action_ordering_seq OWNER TO postgres;

--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_change_action_ordering_seq OWNED BY public.order_change_action.ordering;


--
-- Name: order_claim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_claim (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    type public.order_claim_type_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_claim OWNER TO postgres;

--
-- Name: order_claim_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_claim_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_claim_display_id_seq OWNER TO postgres;

--
-- Name: order_claim_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_claim_display_id_seq OWNED BY public.order_claim.display_id;


--
-- Name: order_claim_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_claim_item (
    id text NOT NULL,
    claim_id text NOT NULL,
    item_id text NOT NULL,
    is_additional_item boolean DEFAULT false NOT NULL,
    reason public.claim_reason_enum,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item OWNER TO postgres;

--
-- Name: order_claim_item_image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_claim_item_image (
    id text NOT NULL,
    claim_item_id text NOT NULL,
    url text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_claim_item_image OWNER TO postgres;

--
-- Name: order_credit_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_credit_line (
    id text NOT NULL,
    order_id text NOT NULL,
    reference text,
    reference_id text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_credit_line OWNER TO postgres;

--
-- Name: order_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_display_id_seq OWNER TO postgres;

--
-- Name: order_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_display_id_seq OWNED BY public."order".display_id;


--
-- Name: order_exchange; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_exchange (
    id text NOT NULL,
    order_id text NOT NULL,
    return_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    no_notification boolean,
    allow_backorder boolean DEFAULT false NOT NULL,
    difference_due numeric,
    raw_difference_due jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    canceled_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.order_exchange OWNER TO postgres;

--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_exchange_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_exchange_display_id_seq OWNER TO postgres;

--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_exchange_display_id_seq OWNED BY public.order_exchange.display_id;


--
-- Name: order_exchange_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_exchange_item (
    id text NOT NULL,
    exchange_id text NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_exchange_item OWNER TO postgres;

--
-- Name: order_fulfillment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_fulfillment (
    order_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_fulfillment OWNER TO postgres;

--
-- Name: order_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_item (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    fulfilled_quantity numeric NOT NULL,
    raw_fulfilled_quantity jsonb NOT NULL,
    shipped_quantity numeric NOT NULL,
    raw_shipped_quantity jsonb NOT NULL,
    return_requested_quantity numeric NOT NULL,
    raw_return_requested_quantity jsonb NOT NULL,
    return_received_quantity numeric NOT NULL,
    raw_return_received_quantity jsonb NOT NULL,
    return_dismissed_quantity numeric NOT NULL,
    raw_return_dismissed_quantity jsonb NOT NULL,
    written_off_quantity numeric NOT NULL,
    raw_written_off_quantity jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    delivered_quantity numeric DEFAULT 0 NOT NULL,
    raw_delivered_quantity jsonb NOT NULL,
    unit_price numeric,
    raw_unit_price jsonb,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb
);


ALTER TABLE public.order_item OWNER TO postgres;

--
-- Name: order_line_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_item (
    id text NOT NULL,
    totals_id text,
    title text NOT NULL,
    subtitle text,
    thumbnail text,
    variant_id text,
    product_id text,
    product_title text,
    product_description text,
    product_subtitle text,
    product_type text,
    product_collection text,
    product_handle text,
    variant_sku text,
    variant_barcode text,
    variant_title text,
    variant_option_values jsonb,
    requires_shipping boolean DEFAULT true NOT NULL,
    is_discountable boolean DEFAULT true NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    compare_at_unit_price numeric,
    raw_compare_at_unit_price jsonb,
    unit_price numeric NOT NULL,
    raw_unit_price jsonb NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_price boolean DEFAULT false NOT NULL,
    product_type_id text,
    is_giftcard boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_line_item OWNER TO postgres;

--
-- Name: order_line_item_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_item_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_line_item_adjustment OWNER TO postgres;

--
-- Name: order_line_item_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line_item_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    item_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_line_item_tax_line OWNER TO postgres;

--
-- Name: order_payment_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_payment_collection (
    order_id character varying(255) NOT NULL,
    payment_collection_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_payment_collection OWNER TO postgres;

--
-- Name: order_promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_promotion (
    order_id character varying(255) NOT NULL,
    promotion_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_promotion OWNER TO postgres;

--
-- Name: order_shipping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer NOT NULL,
    shipping_method_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_shipping OWNER TO postgres;

--
-- Name: order_shipping_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping_method (
    id text NOT NULL,
    name text NOT NULL,
    description jsonb,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    shipping_option_id text,
    data jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_custom_amount boolean DEFAULT false NOT NULL
);


ALTER TABLE public.order_shipping_method OWNER TO postgres;

--
-- Name: order_shipping_method_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping_method_adjustment (
    id text NOT NULL,
    description text,
    promotion_id text,
    code text,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_shipping_method_adjustment OWNER TO postgres;

--
-- Name: order_shipping_method_tax_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping_method_tax_line (
    id text NOT NULL,
    description text,
    tax_rate_id text,
    code text NOT NULL,
    rate numeric NOT NULL,
    raw_rate jsonb NOT NULL,
    provider_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    shipping_method_id text NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.order_shipping_method_tax_line OWNER TO postgres;

--
-- Name: order_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_transaction (
    id text NOT NULL,
    order_id text NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    reference text,
    reference_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    return_id text,
    claim_id text,
    exchange_id text
);


ALTER TABLE public.order_transaction OWNER TO postgres;

--
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    currency_code text NOT NULL,
    provider_id text NOT NULL,
    data jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    captured_at timestamp with time zone,
    canceled_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    payment_session_id text NOT NULL,
    metadata jsonb
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- Name: payment_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_collection (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    authorized_amount numeric,
    raw_authorized_amount jsonb,
    captured_amount numeric,
    raw_captured_amount jsonb,
    refunded_amount numeric,
    raw_refunded_amount jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    completed_at timestamp with time zone,
    status text DEFAULT 'not_paid'::text NOT NULL,
    metadata jsonb,
    CONSTRAINT payment_collection_status_check CHECK ((status = ANY (ARRAY['not_paid'::text, 'awaiting'::text, 'authorized'::text, 'partially_authorized'::text, 'canceled'::text, 'failed'::text, 'completed'::text])))
);


ALTER TABLE public.payment_collection OWNER TO postgres;

--
-- Name: payment_collection_payment_providers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_collection_payment_providers (
    payment_collection_id text NOT NULL,
    payment_provider_id text NOT NULL
);


ALTER TABLE public.payment_collection_payment_providers OWNER TO postgres;

--
-- Name: payment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.payment_provider OWNER TO postgres;

--
-- Name: payment_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_session (
    id text NOT NULL,
    currency_code text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    provider_id text NOT NULL,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    context jsonb,
    status text DEFAULT 'pending'::text NOT NULL,
    authorized_at timestamp with time zone,
    payment_collection_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT payment_session_status_check CHECK ((status = ANY (ARRAY['authorized'::text, 'captured'::text, 'pending'::text, 'requires_more'::text, 'error'::text, 'canceled'::text])))
);


ALTER TABLE public.payment_session OWNER TO postgres;

--
-- Name: price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price (
    id text NOT NULL,
    title text,
    price_set_id text NOT NULL,
    currency_code text NOT NULL,
    raw_amount jsonb NOT NULL,
    rules_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    price_list_id text,
    amount numeric NOT NULL,
    min_quantity integer,
    max_quantity integer
);


ALTER TABLE public.price OWNER TO postgres;

--
-- Name: price_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_list (
    id text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    rules_count integer DEFAULT 0,
    title text NOT NULL,
    description text NOT NULL,
    type text DEFAULT 'sale'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT price_list_status_check CHECK ((status = ANY (ARRAY['active'::text, 'draft'::text]))),
    CONSTRAINT price_list_type_check CHECK ((type = ANY (ARRAY['sale'::text, 'override'::text])))
);


ALTER TABLE public.price_list OWNER TO postgres;

--
-- Name: price_list_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_list_rule (
    id text NOT NULL,
    price_list_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    value jsonb,
    attribute text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.price_list_rule OWNER TO postgres;

--
-- Name: price_preference; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_preference (
    id text NOT NULL,
    attribute text NOT NULL,
    value text,
    is_tax_inclusive boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_preference OWNER TO postgres;

--
-- Name: price_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_rule (
    id text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    price_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    attribute text DEFAULT ''::text NOT NULL,
    operator text DEFAULT 'eq'::text NOT NULL,
    CONSTRAINT price_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text])))
);


ALTER TABLE public.price_rule OWNER TO postgres;

--
-- Name: price_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_set (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.price_set OWNER TO postgres;

--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    subtitle text,
    description text,
    is_giftcard boolean DEFAULT false NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    thumbnail text,
    weight text,
    length text,
    height text,
    width text,
    origin_country text,
    hs_code text,
    mid_code text,
    material text,
    collection_id text,
    type_id text,
    discountable boolean DEFAULT true NOT NULL,
    external_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb,
    CONSTRAINT product_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'proposed'::text, 'published'::text, 'rejected'::text])))
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: product_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_category (
    id text NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    handle text NOT NULL,
    mpath text NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    is_internal boolean DEFAULT false NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    parent_category_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    metadata jsonb
);


ALTER TABLE public.product_category OWNER TO postgres;

--
-- Name: product_category_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_category_product (
    product_id text NOT NULL,
    product_category_id text NOT NULL
);


ALTER TABLE public.product_category_product OWNER TO postgres;

--
-- Name: product_collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_collection (
    id text NOT NULL,
    title text NOT NULL,
    handle text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_collection OWNER TO postgres;

--
-- Name: product_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_option (
    id text NOT NULL,
    title text NOT NULL,
    product_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_option OWNER TO postgres;

--
-- Name: product_option_value; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_option_value (
    id text NOT NULL,
    value text NOT NULL,
    option_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_option_value OWNER TO postgres;

--
-- Name: product_sales_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_sales_channel (
    product_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_sales_channel OWNER TO postgres;

--
-- Name: product_shipping_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_shipping_profile (
    product_id character varying(255) NOT NULL,
    shipping_profile_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_shipping_profile OWNER TO postgres;

--
-- Name: product_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_tag (
    id text NOT NULL,
    value text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_tag OWNER TO postgres;

--
-- Name: product_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_tags (
    product_id text NOT NULL,
    product_tag_id text NOT NULL
);


ALTER TABLE public.product_tags OWNER TO postgres;

--
-- Name: product_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_type (
    id text NOT NULL,
    value text NOT NULL,
    metadata json,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_type OWNER TO postgres;

--
-- Name: product_variant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant (
    id text NOT NULL,
    title text NOT NULL,
    sku text,
    barcode text,
    ean text,
    upc text,
    allow_backorder boolean DEFAULT false NOT NULL,
    manage_inventory boolean DEFAULT true NOT NULL,
    hs_code text,
    origin_country text,
    mid_code text,
    material text,
    weight integer,
    length integer,
    height integer,
    width integer,
    metadata jsonb,
    variant_rank integer DEFAULT 0,
    product_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant OWNER TO postgres;

--
-- Name: product_variant_inventory_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_inventory_item (
    variant_id character varying(255) NOT NULL,
    inventory_item_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    required_quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_inventory_item OWNER TO postgres;

--
-- Name: product_variant_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_option (
    variant_id text NOT NULL,
    option_value_id text NOT NULL
);


ALTER TABLE public.product_variant_option OWNER TO postgres;

--
-- Name: product_variant_price_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_variant_price_set (
    variant_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_variant_price_set OWNER TO postgres;

--
-- Name: promotion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion (
    id text NOT NULL,
    code text NOT NULL,
    campaign_id text,
    is_automatic boolean DEFAULT false NOT NULL,
    type text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status text DEFAULT 'draft'::text NOT NULL,
    CONSTRAINT promotion_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'active'::text, 'inactive'::text]))),
    CONSTRAINT promotion_type_check CHECK ((type = ANY (ARRAY['standard'::text, 'buyget'::text])))
);


ALTER TABLE public.promotion OWNER TO postgres;

--
-- Name: promotion_application_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_application_method (
    id text NOT NULL,
    value numeric,
    raw_value jsonb,
    max_quantity integer,
    apply_to_quantity integer,
    buy_rules_min_quantity integer,
    type text NOT NULL,
    target_type text NOT NULL,
    allocation text,
    promotion_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    CONSTRAINT promotion_application_method_allocation_check CHECK ((allocation = ANY (ARRAY['each'::text, 'across'::text]))),
    CONSTRAINT promotion_application_method_target_type_check CHECK ((target_type = ANY (ARRAY['order'::text, 'shipping_methods'::text, 'items'::text]))),
    CONSTRAINT promotion_application_method_type_check CHECK ((type = ANY (ARRAY['fixed'::text, 'percentage'::text])))
);


ALTER TABLE public.promotion_application_method OWNER TO postgres;

--
-- Name: promotion_campaign; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_campaign (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    campaign_identifier text NOT NULL,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_campaign OWNER TO postgres;

--
-- Name: promotion_campaign_budget; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_campaign_budget (
    id text NOT NULL,
    type text NOT NULL,
    campaign_id text NOT NULL,
    "limit" numeric,
    raw_limit jsonb,
    used numeric DEFAULT 0 NOT NULL,
    raw_used jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    currency_code text,
    CONSTRAINT promotion_campaign_budget_type_check CHECK ((type = ANY (ARRAY['spend'::text, 'usage'::text])))
);


ALTER TABLE public.promotion_campaign_budget OWNER TO postgres;

--
-- Name: promotion_promotion_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_promotion_rule (
    promotion_id text NOT NULL,
    promotion_rule_id text NOT NULL
);


ALTER TABLE public.promotion_promotion_rule OWNER TO postgres;

--
-- Name: promotion_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_rule (
    id text NOT NULL,
    description text,
    attribute text NOT NULL,
    operator text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT promotion_rule_operator_check CHECK ((operator = ANY (ARRAY['gte'::text, 'lte'::text, 'gt'::text, 'lt'::text, 'eq'::text, 'ne'::text, 'in'::text])))
);


ALTER TABLE public.promotion_rule OWNER TO postgres;

--
-- Name: promotion_rule_value; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotion_rule_value (
    id text NOT NULL,
    promotion_rule_id text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.promotion_rule_value OWNER TO postgres;

--
-- Name: provider_identity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.provider_identity (
    id text NOT NULL,
    entity_id text NOT NULL,
    provider text NOT NULL,
    auth_identity_id text NOT NULL,
    user_metadata jsonb,
    provider_metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.provider_identity OWNER TO postgres;

--
-- Name: publishable_api_key_sales_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.publishable_api_key_sales_channel (
    publishable_key_id character varying(255) NOT NULL,
    sales_channel_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.publishable_api_key_sales_channel OWNER TO postgres;

--
-- Name: refund; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refund (
    id text NOT NULL,
    amount numeric NOT NULL,
    raw_amount jsonb NOT NULL,
    payment_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    created_by text,
    metadata jsonb,
    refund_reason_id text,
    note text
);


ALTER TABLE public.refund OWNER TO postgres;

--
-- Name: refund_reason; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refund_reason (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.refund_reason OWNER TO postgres;

--
-- Name: region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region (
    id text NOT NULL,
    name text NOT NULL,
    currency_code text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    automatic_taxes boolean DEFAULT true NOT NULL
);


ALTER TABLE public.region OWNER TO postgres;

--
-- Name: region_country; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region_country (
    iso_2 text NOT NULL,
    iso_3 text NOT NULL,
    num_code text NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    region_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_country OWNER TO postgres;

--
-- Name: region_payment_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region_payment_provider (
    region_id character varying(255) NOT NULL,
    payment_provider_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.region_payment_provider OWNER TO postgres;

--
-- Name: reservation_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservation_item (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    line_item_id text,
    location_id text NOT NULL,
    quantity numeric NOT NULL,
    external_id text,
    description text,
    created_by text,
    metadata jsonb,
    inventory_item_id text NOT NULL,
    allow_backorder boolean DEFAULT false,
    raw_quantity jsonb
);


ALTER TABLE public.reservation_item OWNER TO postgres;

--
-- Name: return; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return (
    id text NOT NULL,
    order_id text NOT NULL,
    claim_id text,
    exchange_id text,
    order_version integer NOT NULL,
    display_id integer NOT NULL,
    status public.return_status_enum DEFAULT 'open'::public.return_status_enum NOT NULL,
    no_notification boolean,
    refund_amount numeric,
    raw_refund_amount jsonb,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    received_at timestamp with time zone,
    canceled_at timestamp with time zone,
    location_id text,
    requested_at timestamp with time zone,
    created_by text
);


ALTER TABLE public.return OWNER TO postgres;

--
-- Name: return_display_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.return_display_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.return_display_id_seq OWNER TO postgres;

--
-- Name: return_display_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.return_display_id_seq OWNED BY public.return.display_id;


--
-- Name: return_fulfillment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_fulfillment (
    return_id character varying(255) NOT NULL,
    fulfillment_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.return_fulfillment OWNER TO postgres;

--
-- Name: return_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_item (
    id text NOT NULL,
    return_id text NOT NULL,
    reason_id text,
    item_id text NOT NULL,
    quantity numeric NOT NULL,
    raw_quantity jsonb NOT NULL,
    received_quantity numeric DEFAULT 0 NOT NULL,
    raw_received_quantity jsonb NOT NULL,
    note text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    damaged_quantity numeric DEFAULT 0 NOT NULL,
    raw_damaged_quantity jsonb NOT NULL
);


ALTER TABLE public.return_item OWNER TO postgres;

--
-- Name: sales_channel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_channel (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    is_disabled boolean DEFAULT false NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel OWNER TO postgres;

--
-- Name: sales_channel_stock_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_channel_stock_location (
    sales_channel_id character varying(255) NOT NULL,
    stock_location_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.sales_channel_stock_location OWNER TO postgres;

--
-- Name: script_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.script_migrations (
    id integer NOT NULL,
    script_name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    finished_at timestamp with time zone
);


ALTER TABLE public.script_migrations OWNER TO postgres;

--
-- Name: script_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.script_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.script_migrations_id_seq OWNER TO postgres;

--
-- Name: script_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.script_migrations_id_seq OWNED BY public.script_migrations.id;


--
-- Name: service_zone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_zone (
    id text NOT NULL,
    name text NOT NULL,
    metadata jsonb,
    fulfillment_set_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.service_zone OWNER TO postgres;

--
-- Name: shipping_option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option (
    id text NOT NULL,
    name text NOT NULL,
    price_type text DEFAULT 'flat'::text NOT NULL,
    service_zone_id text NOT NULL,
    shipping_profile_id text,
    provider_id text,
    data jsonb,
    metadata jsonb,
    shipping_option_type_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_price_type_check CHECK ((price_type = ANY (ARRAY['calculated'::text, 'flat'::text])))
);


ALTER TABLE public.shipping_option OWNER TO postgres;

--
-- Name: shipping_option_price_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option_price_set (
    shipping_option_id character varying(255) NOT NULL,
    price_set_id character varying(255) NOT NULL,
    id character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_price_set OWNER TO postgres;

--
-- Name: shipping_option_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option_rule (
    id text NOT NULL,
    attribute text NOT NULL,
    operator text NOT NULL,
    value jsonb,
    shipping_option_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT shipping_option_rule_operator_check CHECK ((operator = ANY (ARRAY['in'::text, 'eq'::text, 'ne'::text, 'gt'::text, 'gte'::text, 'lt'::text, 'lte'::text, 'nin'::text])))
);


ALTER TABLE public.shipping_option_rule OWNER TO postgres;

--
-- Name: shipping_option_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_option_type (
    id text NOT NULL,
    label text NOT NULL,
    description text,
    code text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_option_type OWNER TO postgres;

--
-- Name: shipping_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_profile (
    id text NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.shipping_profile OWNER TO postgres;

--
-- Name: stock_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_location (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    name text NOT NULL,
    address_id text,
    metadata jsonb
);


ALTER TABLE public.stock_location OWNER TO postgres;

--
-- Name: stock_location_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_location_address (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    address_1 text NOT NULL,
    address_2 text,
    company text,
    city text,
    country_code text NOT NULL,
    phone text,
    province text,
    postal_code text,
    metadata jsonb
);


ALTER TABLE public.stock_location_address OWNER TO postgres;

--
-- Name: store; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store (
    id text NOT NULL,
    name text DEFAULT 'Medusa Store'::text NOT NULL,
    default_sales_channel_id text,
    default_region_id text,
    default_location_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store OWNER TO postgres;

--
-- Name: store_currency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_currency (
    id text NOT NULL,
    currency_code text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    store_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.store_currency OWNER TO postgres;

--
-- Name: tax_provider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_provider (
    id text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_provider OWNER TO postgres;

--
-- Name: tax_rate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_rate (
    id text NOT NULL,
    rate real,
    code text NOT NULL,
    name text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    is_combinable boolean DEFAULT false NOT NULL,
    tax_region_id text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate OWNER TO postgres;

--
-- Name: tax_rate_rule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_rate_rule (
    id text NOT NULL,
    tax_rate_id text NOT NULL,
    reference_id text NOT NULL,
    reference text NOT NULL,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone
);


ALTER TABLE public.tax_rate_rule OWNER TO postgres;

--
-- Name: tax_region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tax_region (
    id text NOT NULL,
    provider_id text,
    country_code text NOT NULL,
    province_code text,
    parent_id text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    deleted_at timestamp with time zone,
    CONSTRAINT "CK_tax_region_country_top_level" CHECK (((parent_id IS NULL) OR (province_code IS NOT NULL))),
    CONSTRAINT "CK_tax_region_provider_top_level" CHECK (((parent_id IS NULL) OR (provider_id IS NULL)))
);


ALTER TABLE public.tax_region OWNER TO postgres;

--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id text NOT NULL,
    first_name text,
    last_name text,
    email text NOT NULL,
    avatar_url text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: workflow_execution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workflow_execution (
    id character varying NOT NULL,
    workflow_id character varying NOT NULL,
    transaction_id character varying NOT NULL,
    execution jsonb,
    context jsonb,
    state character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    retention_time integer
);


ALTER TABLE public.workflow_execution OWNER TO postgres;

--
-- Name: link_module_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_module_migrations ALTER COLUMN id SET DEFAULT nextval('public.link_module_migrations_id_seq'::regclass);


--
-- Name: mikro_orm_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mikro_orm_migrations ALTER COLUMN id SET DEFAULT nextval('public.mikro_orm_migrations_id_seq'::regclass);


--
-- Name: order display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order" ALTER COLUMN display_id SET DEFAULT nextval('public.order_display_id_seq'::regclass);


--
-- Name: order_change_action ordering; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_action ALTER COLUMN ordering SET DEFAULT nextval('public.order_change_action_ordering_seq'::regclass);


--
-- Name: order_claim display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim ALTER COLUMN display_id SET DEFAULT nextval('public.order_claim_display_id_seq'::regclass);


--
-- Name: order_exchange display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_exchange ALTER COLUMN display_id SET DEFAULT nextval('public.order_exchange_display_id_seq'::regclass);


--
-- Name: return display_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return ALTER COLUMN display_id SET DEFAULT nextval('public.return_display_id_seq'::regclass);


--
-- Name: script_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.script_migrations ALTER COLUMN id SET DEFAULT nextval('public.script_migrations_id_seq'::regclass);


--
-- Data for Name: account_holder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account_holder (id, provider_id, external_id, email, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: api_key; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_key (id, token, salt, redacted, title, type, last_used_at, created_by, created_at, revoked_by, revoked_at, updated_at, deleted_at) FROM stdin;
apk_01K20FXD7GQTHS62DAY44H84M1	pk_356b2fcd9ebd38d327ec5f4c6083089a1ee38c2d7b9e87fe8179a814e5ce2f49		pk_356***f49	frontend	publishable	\N	user_01JTFTW5BVVJP6RM2H2Z178YEK	2025-08-07 01:07:12.88+05	\N	\N	2025-08-07 01:07:12.881+05	\N
\.


--
-- Data for Name: application_method_buy_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_method_buy_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: application_method_target_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_method_target_rules (application_method_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: auth_identity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_identity (id, app_metadata, created_at, updated_at, deleted_at) FROM stdin;
authid_01JTFTSK2TGTYJNFP6BH5VR91B	{"customer_id": "cus_01JTFTSK46D6GRFHSFZ3NB8NKD"}	2025-05-05 14:00:24.027+05	2025-05-05 14:00:24.087+05	\N
authid_01JTFTW5G2EX6WKY9MGZK547R2	{"user_id": "user_01JTFTW5BVVJP6RM2H2Z178YEK"}	2025-05-05 14:01:48.419+05	2025-05-05 14:01:48.428+05	\N
authid_01JTFTZYAK34DAAF2QNN0BE9S0	{"user_id": "user_01JTFTZY75CN5H4ZCF43TTQB8D"}	2025-05-05 14:03:52.147+05	2025-05-05 14:03:52.157+05	\N
authid_01JTFV0E22JZYW96MK4A4M9JK6	{"user_id": "user_01JTFV0DXTY9MTM0JYMH0YSBAX"}	2025-05-05 14:04:08.259+05	2025-05-05 14:04:08.27+05	\N
authid_01JTGV2SV3NEZHNSCCGHQGE1MQ	{"user_id": null}	2025-05-05 23:24:40.292+05	2025-05-14 17:17:22.274+05	\N
authid_01JZ5JHJ4V1EVMQ0BF1B42QJDX	{"customer_id": "cus_01JZ5JHJ7ZNV33PC9K27NM8GV0"}	2025-07-02 17:42:17.116+05	2025-07-02 17:42:17.24+05	\N
authid_01JZSV63GA6E7QBQSKBKF1JNVP	{"customer_id": "cus_01JZSV63PFJ2KEQ88WAKMD5D8B"}	2025-07-10 14:38:07.502+05	2025-07-10 14:38:07.732+05	\N
\.


--
-- Data for Name: capture; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.capture (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata) FROM stdin;
\.


--
-- Data for Name: cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart (id, region_id, customer_id, sales_channel_id, email, currency_code, shipping_address_id, billing_address_id, metadata, created_at, updated_at, deleted_at, completed_at) FROM stdin;
\.


--
-- Data for Name: cart_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_line_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_line_item (id, cart_id, title, subtitle, thumbnail, quantity, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, product_type_id, is_custom_price, is_giftcard) FROM stdin;
\.


--
-- Data for Name: cart_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, item_id) FROM stdin;
\.


--
-- Data for Name: cart_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_line_item_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, item_id) FROM stdin;
\.


--
-- Data for Name: cart_payment_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_payment_collection (cart_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
cart_01JTGGFK44DC2CR24ZS6A98RRV	pay_col_01JTGGH5H23SAD7EXTM6Q1YFBG	capaycol_01JTGGH5HFGS7C7TWJH9PJEBKD	2025-05-05 20:20:16.68704+05	2025-05-05 20:20:16.68704+05	\N
\.


--
-- Data for Name: cart_promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_promotion (cart_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_shipping_method (id, cart_id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: cart_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_shipping_method_tax_line (id, description, tax_rate_id, code, rate, provider_id, metadata, created_at, updated_at, deleted_at, shipping_method_id) FROM stdin;
\.


--
-- Data for Name: credit_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.credit_line (id, cart_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.currency (code, symbol, symbol_native, decimal_digits, rounding, raw_rounding, name, created_at, updated_at, deleted_at) FROM stdin;
usd	$	$	2	0	{"value": "0", "precision": 20}	US Dollar	2025-08-07 00:53:39.654+05	2025-08-07 00:53:39.654+05	\N
cad	CA$	$	2	0	{"value": "0", "precision": 20}	Canadian Dollar	2025-08-07 00:53:39.655+05	2025-08-07 00:53:39.655+05	\N
eur	€	€	2	0	{"value": "0", "precision": 20}	Euro	2025-08-07 00:53:39.655+05	2025-08-07 00:53:39.655+05	\N
aed	AED	د.إ.‏	2	0	{"value": "0", "precision": 20}	United Arab Emirates Dirham	2025-08-07 00:53:39.655+05	2025-08-07 00:53:39.655+05	\N
afn	Af	؋	0	0	{"value": "0", "precision": 20}	Afghan Afghani	2025-08-07 00:53:39.655+05	2025-08-07 00:53:39.655+05	\N
all	ALL	Lek	0	0	{"value": "0", "precision": 20}	Albanian Lek	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.656+05	\N
amd	AMD	դր.	0	0	{"value": "0", "precision": 20}	Armenian Dram	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.656+05	\N
ars	AR$	$	2	0	{"value": "0", "precision": 20}	Argentine Peso	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.656+05	\N
aud	AU$	$	2	0	{"value": "0", "precision": 20}	Australian Dollar	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.656+05	\N
azn	man.	ман.	2	0	{"value": "0", "precision": 20}	Azerbaijani Manat	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.656+05	\N
bam	KM	KM	2	0	{"value": "0", "precision": 20}	Bosnia-Herzegovina Convertible Mark	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.656+05	\N
bdt	Tk	৳	2	0	{"value": "0", "precision": 20}	Bangladeshi Taka	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.656+05	\N
bgn	BGN	лв.	2	0	{"value": "0", "precision": 20}	Bulgarian Lev	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.656+05	\N
bhd	BD	د.ب.‏	3	0	{"value": "0", "precision": 20}	Bahraini Dinar	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.656+05	\N
bif	FBu	FBu	0	0	{"value": "0", "precision": 20}	Burundian Franc	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.656+05	\N
bnd	BN$	$	2	0	{"value": "0", "precision": 20}	Brunei Dollar	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.656+05	\N
bob	Bs	Bs	2	0	{"value": "0", "precision": 20}	Bolivian Boliviano	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.656+05	\N
brl	R$	R$	2	0	{"value": "0", "precision": 20}	Brazilian Real	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.656+05	\N
bwp	BWP	P	2	0	{"value": "0", "precision": 20}	Botswanan Pula	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.656+05	\N
byn	Br	руб.	2	0	{"value": "0", "precision": 20}	Belarusian Ruble	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.656+05	\N
bzd	BZ$	$	2	0	{"value": "0", "precision": 20}	Belize Dollar	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.656+05	\N
cdf	CDF	FrCD	2	0	{"value": "0", "precision": 20}	Congolese Franc	2025-08-07 00:53:39.656+05	2025-08-07 00:53:39.657+05	\N
chf	CHF	CHF	2	0.05	{"value": "0.05", "precision": 20}	Swiss Franc	2025-08-07 00:53:39.657+05	2025-08-07 00:53:39.657+05	\N
clp	CL$	$	0	0	{"value": "0", "precision": 20}	Chilean Peso	2025-08-07 00:53:39.657+05	2025-08-07 00:53:39.657+05	\N
cny	CN¥	CN¥	2	0	{"value": "0", "precision": 20}	Chinese Yuan	2025-08-07 00:53:39.657+05	2025-08-07 00:53:39.657+05	\N
cop	CO$	$	0	0	{"value": "0", "precision": 20}	Colombian Peso	2025-08-07 00:53:39.657+05	2025-08-07 00:53:39.657+05	\N
crc	₡	₡	0	0	{"value": "0", "precision": 20}	Costa Rican Colón	2025-08-07 00:53:39.657+05	2025-08-07 00:53:39.657+05	\N
cve	CV$	CV$	2	0	{"value": "0", "precision": 20}	Cape Verdean Escudo	2025-08-07 00:53:39.657+05	2025-08-07 00:53:39.657+05	\N
czk	Kč	Kč	2	0	{"value": "0", "precision": 20}	Czech Republic Koruna	2025-08-07 00:53:39.657+05	2025-08-07 00:53:39.657+05	\N
djf	Fdj	Fdj	0	0	{"value": "0", "precision": 20}	Djiboutian Franc	2025-08-07 00:53:39.657+05	2025-08-07 00:53:39.657+05	\N
dkk	Dkr	kr	2	0	{"value": "0", "precision": 20}	Danish Krone	2025-08-07 00:53:39.657+05	2025-08-07 00:53:39.657+05	\N
dop	RD$	RD$	2	0	{"value": "0", "precision": 20}	Dominican Peso	2025-08-07 00:53:39.657+05	2025-08-07 00:53:39.657+05	\N
dzd	DA	د.ج.‏	2	0	{"value": "0", "precision": 20}	Algerian Dinar	2025-08-07 00:53:39.658+05	2025-08-07 00:53:39.658+05	\N
eek	Ekr	kr	2	0	{"value": "0", "precision": 20}	Estonian Kroon	2025-08-07 00:53:39.658+05	2025-08-07 00:53:39.658+05	\N
egp	EGP	ج.م.‏	2	0	{"value": "0", "precision": 20}	Egyptian Pound	2025-08-07 00:53:39.658+05	2025-08-07 00:53:39.658+05	\N
ern	Nfk	Nfk	2	0	{"value": "0", "precision": 20}	Eritrean Nakfa	2025-08-07 00:53:39.658+05	2025-08-07 00:53:39.658+05	\N
etb	Br	Br	2	0	{"value": "0", "precision": 20}	Ethiopian Birr	2025-08-07 00:53:39.658+05	2025-08-07 00:53:39.658+05	\N
gbp	£	£	2	0	{"value": "0", "precision": 20}	British Pound Sterling	2025-08-07 00:53:39.658+05	2025-08-07 00:53:39.658+05	\N
gel	GEL	GEL	2	0	{"value": "0", "precision": 20}	Georgian Lari	2025-08-07 00:53:39.658+05	2025-08-07 00:53:39.658+05	\N
ghs	GH₵	GH₵	2	0	{"value": "0", "precision": 20}	Ghanaian Cedi	2025-08-07 00:53:39.658+05	2025-08-07 00:53:39.658+05	\N
gnf	FG	FG	0	0	{"value": "0", "precision": 20}	Guinean Franc	2025-08-07 00:53:39.658+05	2025-08-07 00:53:39.658+05	\N
gtq	GTQ	Q	2	0	{"value": "0", "precision": 20}	Guatemalan Quetzal	2025-08-07 00:53:39.658+05	2025-08-07 00:53:39.658+05	\N
hkd	HK$	$	2	0	{"value": "0", "precision": 20}	Hong Kong Dollar	2025-08-07 00:53:39.658+05	2025-08-07 00:53:39.658+05	\N
hnl	HNL	L	2	0	{"value": "0", "precision": 20}	Honduran Lempira	2025-08-07 00:53:39.658+05	2025-08-07 00:53:39.658+05	\N
hrk	kn	kn	2	0	{"value": "0", "precision": 20}	Croatian Kuna	2025-08-07 00:53:39.658+05	2025-08-07 00:53:39.658+05	\N
huf	Ft	Ft	0	0	{"value": "0", "precision": 20}	Hungarian Forint	2025-08-07 00:53:39.658+05	2025-08-07 00:53:39.658+05	\N
idr	Rp	Rp	0	0	{"value": "0", "precision": 20}	Indonesian Rupiah	2025-08-07 00:53:39.658+05	2025-08-07 00:53:39.658+05	\N
ils	₪	₪	2	0	{"value": "0", "precision": 20}	Israeli New Sheqel	2025-08-07 00:53:39.662+05	2025-08-07 00:53:39.662+05	\N
inr	Rs	₹	2	0	{"value": "0", "precision": 20}	Indian Rupee	2025-08-07 00:53:39.662+05	2025-08-07 00:53:39.662+05	\N
iqd	IQD	د.ع.‏	0	0	{"value": "0", "precision": 20}	Iraqi Dinar	2025-08-07 00:53:39.662+05	2025-08-07 00:53:39.662+05	\N
irr	IRR	﷼	0	0	{"value": "0", "precision": 20}	Iranian Rial	2025-08-07 00:53:39.662+05	2025-08-07 00:53:39.662+05	\N
isk	Ikr	kr	0	0	{"value": "0", "precision": 20}	Icelandic Króna	2025-08-07 00:53:39.662+05	2025-08-07 00:53:39.662+05	\N
jmd	J$	$	2	0	{"value": "0", "precision": 20}	Jamaican Dollar	2025-08-07 00:53:39.662+05	2025-08-07 00:53:39.662+05	\N
jod	JD	د.أ.‏	3	0	{"value": "0", "precision": 20}	Jordanian Dinar	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
jpy	¥	￥	0	0	{"value": "0", "precision": 20}	Japanese Yen	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
kes	Ksh	Ksh	2	0	{"value": "0", "precision": 20}	Kenyan Shilling	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
khr	KHR	៛	2	0	{"value": "0", "precision": 20}	Cambodian Riel	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
kmf	CF	FC	0	0	{"value": "0", "precision": 20}	Comorian Franc	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
krw	₩	₩	0	0	{"value": "0", "precision": 20}	South Korean Won	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
kwd	KD	د.ك.‏	3	0	{"value": "0", "precision": 20}	Kuwaiti Dinar	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
kzt	KZT	тңг.	2	0	{"value": "0", "precision": 20}	Kazakhstani Tenge	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
lbp	LB£	ل.ل.‏	0	0	{"value": "0", "precision": 20}	Lebanese Pound	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
lkr	SLRs	SL Re	2	0	{"value": "0", "precision": 20}	Sri Lankan Rupee	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
ltl	Lt	Lt	2	0	{"value": "0", "precision": 20}	Lithuanian Litas	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
lvl	Ls	Ls	2	0	{"value": "0", "precision": 20}	Latvian Lats	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
lyd	LD	د.ل.‏	3	0	{"value": "0", "precision": 20}	Libyan Dinar	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
mad	MAD	د.م.‏	2	0	{"value": "0", "precision": 20}	Moroccan Dirham	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
mdl	MDL	MDL	2	0	{"value": "0", "precision": 20}	Moldovan Leu	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
mga	MGA	MGA	0	0	{"value": "0", "precision": 20}	Malagasy Ariary	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
mkd	MKD	MKD	2	0	{"value": "0", "precision": 20}	Macedonian Denar	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
mmk	MMK	K	0	0	{"value": "0", "precision": 20}	Myanma Kyat	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
mnt	MNT	₮	0	0	{"value": "0", "precision": 20}	Mongolian Tugrig	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
mop	MOP$	MOP$	2	0	{"value": "0", "precision": 20}	Macanese Pataca	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
mur	MURs	MURs	0	0	{"value": "0", "precision": 20}	Mauritian Rupee	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
mxn	MX$	$	2	0	{"value": "0", "precision": 20}	Mexican Peso	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
myr	RM	RM	2	0	{"value": "0", "precision": 20}	Malaysian Ringgit	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
mzn	MTn	MTn	2	0	{"value": "0", "precision": 20}	Mozambican Metical	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
nad	N$	N$	2	0	{"value": "0", "precision": 20}	Namibian Dollar	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
ngn	₦	₦	2	0	{"value": "0", "precision": 20}	Nigerian Naira	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
nio	C$	C$	2	0	{"value": "0", "precision": 20}	Nicaraguan Córdoba	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
nok	Nkr	kr	2	0	{"value": "0", "precision": 20}	Norwegian Krone	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
npr	NPRs	नेरू	2	0	{"value": "0", "precision": 20}	Nepalese Rupee	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
nzd	NZ$	$	2	0	{"value": "0", "precision": 20}	New Zealand Dollar	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
omr	OMR	ر.ع.‏	3	0	{"value": "0", "precision": 20}	Omani Rial	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
pab	B/.	B/.	2	0	{"value": "0", "precision": 20}	Panamanian Balboa	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
pen	S/.	S/.	2	0	{"value": "0", "precision": 20}	Peruvian Nuevo Sol	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
php	₱	₱	2	0	{"value": "0", "precision": 20}	Philippine Peso	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
pkr	PKRs	₨	0	0	{"value": "0", "precision": 20}	Pakistani Rupee	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
pln	zł	zł	2	0	{"value": "0", "precision": 20}	Polish Zloty	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
pyg	₲	₲	0	0	{"value": "0", "precision": 20}	Paraguayan Guarani	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
qar	QR	ر.ق.‏	2	0	{"value": "0", "precision": 20}	Qatari Rial	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
ron	RON	RON	2	0	{"value": "0", "precision": 20}	Romanian Leu	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
rsd	din.	дин.	0	0	{"value": "0", "precision": 20}	Serbian Dinar	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
rub	RUB	₽.	2	0	{"value": "0", "precision": 20}	Russian Ruble	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
rwf	RWF	FR	0	0	{"value": "0", "precision": 20}	Rwandan Franc	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
sar	SR	ر.س.‏	2	0	{"value": "0", "precision": 20}	Saudi Riyal	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
sdg	SDG	SDG	2	0	{"value": "0", "precision": 20}	Sudanese Pound	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
sek	Skr	kr	2	0	{"value": "0", "precision": 20}	Swedish Krona	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
sgd	S$	$	2	0	{"value": "0", "precision": 20}	Singapore Dollar	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
sos	Ssh	Ssh	0	0	{"value": "0", "precision": 20}	Somali Shilling	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
syp	SY£	ل.س.‏	0	0	{"value": "0", "precision": 20}	Syrian Pound	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
thb	฿	฿	2	0	{"value": "0", "precision": 20}	Thai Baht	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
tnd	DT	د.ت.‏	3	0	{"value": "0", "precision": 20}	Tunisian Dinar	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
top	T$	T$	2	0	{"value": "0", "precision": 20}	Tongan Paʻanga	2025-08-07 00:53:39.663+05	2025-08-07 00:53:39.663+05	\N
try	₺	₺	2	0	{"value": "0", "precision": 20}	Turkish Lira	2025-08-07 00:53:39.664+05	2025-08-07 00:53:39.664+05	\N
ttd	TT$	$	2	0	{"value": "0", "precision": 20}	Trinidad and Tobago Dollar	2025-08-07 00:53:39.664+05	2025-08-07 00:53:39.664+05	\N
twd	NT$	NT$	2	0	{"value": "0", "precision": 20}	New Taiwan Dollar	2025-08-07 00:53:39.664+05	2025-08-07 00:53:39.664+05	\N
tzs	TSh	TSh	0	0	{"value": "0", "precision": 20}	Tanzanian Shilling	2025-08-07 00:53:39.664+05	2025-08-07 00:53:39.664+05	\N
uah	₴	₴	2	0	{"value": "0", "precision": 20}	Ukrainian Hryvnia	2025-08-07 00:53:39.664+05	2025-08-07 00:53:39.664+05	\N
ugx	USh	USh	0	0	{"value": "0", "precision": 20}	Ugandan Shilling	2025-08-07 00:53:39.664+05	2025-08-07 00:53:39.664+05	\N
uyu	$U	$	2	0	{"value": "0", "precision": 20}	Uruguayan Peso	2025-08-07 00:53:39.664+05	2025-08-07 00:53:39.664+05	\N
uzs	UZS	UZS	0	0	{"value": "0", "precision": 20}	Uzbekistan Som	2025-08-07 00:53:39.664+05	2025-08-07 00:53:39.664+05	\N
vef	Bs.F.	Bs.F.	2	0	{"value": "0", "precision": 20}	Venezuelan Bolívar	2025-08-07 00:53:39.664+05	2025-08-07 00:53:39.664+05	\N
vnd	₫	₫	0	0	{"value": "0", "precision": 20}	Vietnamese Dong	2025-08-07 00:53:39.664+05	2025-08-07 00:53:39.664+05	\N
xaf	FCFA	FCFA	0	0	{"value": "0", "precision": 20}	CFA Franc BEAC	2025-08-07 00:53:39.664+05	2025-08-07 00:53:39.664+05	\N
xof	CFA	CFA	0	0	{"value": "0", "precision": 20}	CFA Franc BCEAO	2025-08-07 00:53:39.664+05	2025-08-07 00:53:39.664+05	\N
yer	YR	ر.ي.‏	0	0	{"value": "0", "precision": 20}	Yemeni Rial	2025-08-07 00:53:39.664+05	2025-08-07 00:53:39.664+05	\N
zar	R	R	2	0	{"value": "0", "precision": 20}	South African Rand	2025-08-07 00:53:39.664+05	2025-08-07 00:53:39.664+05	\N
zmk	ZK	ZK	0	0	{"value": "0", "precision": 20}	Zambian Kwacha	2025-08-07 00:53:39.664+05	2025-08-07 00:53:39.664+05	\N
zwl	ZWL$	ZWL$	0	0	{"value": "0", "precision": 20}	Zimbabwean Dollar	2025-08-07 00:53:39.664+05	2025-08-07 00:53:39.664+05	\N
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (id, company_name, first_name, last_name, email, phone, has_account, metadata, created_at, updated_at, deleted_at, created_by) FROM stdin;
\.


--
-- Data for Name: customer_account_holder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_account_holder (customer_id, account_holder_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_address (id, customer_id, address_name, is_default_shipping, is_default_billing, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_group (id, name, metadata, created_by, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: customer_group_customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_group_customer (id, customer_id, customer_group_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment (id, location_id, packed_at, shipped_at, delivered_at, canceled_at, data, provider_id, shipping_option_id, metadata, delivery_address_id, created_at, updated_at, deleted_at, marked_shipped_by, created_by, requires_shipping) FROM stdin;
\.


--
-- Data for Name: fulfillment_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_address (id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_item (id, title, sku, barcode, quantity, raw_quantity, line_item_id, inventory_item_id, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_label; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_label (id, tracking_number, tracking_url, label_url, fulfillment_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
manual_manual	t	2025-05-05 13:29:37.114+05	2025-05-05 13:29:37.114+05	\N
\.


--
-- Data for Name: fulfillment_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fulfillment_set (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
fuset_01JW34R0WG4WWEPQ4ZXH6KEE4K	Karachi WareHouse shipping	shipping	\N	2025-05-25 12:15:34.416+05	2025-05-25 12:15:34.416+05	\N
fuset_01JTFS1F2VSR7137S5W7WB71E5	European Warehouse delivery	shipping	\N	2025-05-05 13:29:44.923+05	2025-05-25 12:18:13.039+05	2025-05-25 12:18:13.039+05
fuset_01K20KCK0QMEX802Q20YAF6Q7S	KHI Warehouse shipping	shipping	\N	2025-08-07 02:07:56.056+05	2025-08-07 02:07:56.056+05	\N
\.


--
-- Data for Name: geo_zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.geo_zone (id, type, country_code, province_code, city, service_zone_id, postal_expression, metadata, created_at, updated_at, deleted_at) FROM stdin;
fgz_01JW34S3K14B72Y2A349ZR8GP6	country	pk	\N	\N	serzo_01JW34S3K1Q2774J8HY78R3XVY	\N	\N	2025-05-25 12:16:09.954+05	2025-05-25 12:16:09.954+05	\N
fgz_01JTFS1F2T8J9CXBNYZWBEYF6T	country	gb	\N	\N	serzo_01JTFS1F2TSSG5Z3VZSNMDEDHE	\N	\N	2025-05-05 13:29:44.923+05	2025-05-25 12:18:13.052+05	2025-05-25 12:18:13.039+05
fgz_01JTFS1F2TKVQ5HWSGHDN11H3M	country	de	\N	\N	serzo_01JTFS1F2TSSG5Z3VZSNMDEDHE	\N	\N	2025-05-05 13:29:44.924+05	2025-05-25 12:18:13.052+05	2025-05-25 12:18:13.039+05
fgz_01JTFS1F2TVVWKGM4Z9Z0REHAA	country	dk	\N	\N	serzo_01JTFS1F2TSSG5Z3VZSNMDEDHE	\N	\N	2025-05-05 13:29:44.924+05	2025-05-25 12:18:13.052+05	2025-05-25 12:18:13.039+05
fgz_01JTFS1F2TYQT3WRKEWPF1PZKG	country	se	\N	\N	serzo_01JTFS1F2TSSG5Z3VZSNMDEDHE	\N	\N	2025-05-05 13:29:44.924+05	2025-05-25 12:18:13.052+05	2025-05-25 12:18:13.039+05
fgz_01JTFS1F2TJNTE3JPB5WDV81DK	country	fr	\N	\N	serzo_01JTFS1F2TSSG5Z3VZSNMDEDHE	\N	\N	2025-05-05 13:29:44.924+05	2025-05-25 12:18:13.052+05	2025-05-25 12:18:13.039+05
fgz_01JTFS1F2T87WPGCTNAHCFZX43	country	es	\N	\N	serzo_01JTFS1F2TSSG5Z3VZSNMDEDHE	\N	\N	2025-05-05 13:29:44.924+05	2025-05-25 12:18:13.052+05	2025-05-25 12:18:13.039+05
fgz_01JTFS1F2T5G4Z465VFHA8NKBC	country	it	\N	\N	serzo_01JTFS1F2TSSG5Z3VZSNMDEDHE	\N	\N	2025-05-05 13:29:44.924+05	2025-05-25 12:18:13.052+05	2025-05-25 12:18:13.039+05
fgz_01JW3507BFE075JBRV92DF2Z28	country	in	\N	\N	serzo_01JW34YDHXAX70QKDKTMMZ1XTR	\N	\N	2025-05-25 12:20:03.185+05	2025-05-25 12:20:03.185+05	\N
fgz_01JW3507BFSQYBT2Y0SVAMDAPR	country	af	\N	\N	serzo_01JW34YDHXAX70QKDKTMMZ1XTR	\N	\N	2025-05-25 12:20:03.185+05	2025-05-25 12:20:03.185+05	\N
fgz_01JW3507BGJBD79BW89SRD0WFC	country	sa	\N	\N	serzo_01JW34YDHXAX70QKDKTMMZ1XTR	\N	\N	2025-05-25 12:20:03.185+05	2025-05-25 12:20:03.185+05	\N
fgz_01JW3507BG7YXEQWG38D8N8GF9	country	bd	\N	\N	serzo_01JW34YDHXAX70QKDKTMMZ1XTR	\N	\N	2025-05-25 12:20:03.185+05	2025-05-25 12:20:03.185+05	\N
\.


--
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.image (id, url, metadata, created_at, updated_at, deleted_at, rank, product_id) FROM stdin;
img_01K20MERPHC9KS4KC20E6VR9YJ	http://localhost:9000/static/1754515595810-images%20(1).jpg	\N	2025-08-07 02:26:35.971535+05	2025-08-07 02:26:35.971535+05	\N	0	prod_01K20ME37KW189HXKM3RT1AJMX
img_01K20MSWN86PSQKEYZYVQTG9HP	http://localhost:9000/static/1754515960334-Frame%207.jpg	\N	2025-08-07 02:32:40.489+05	2025-08-07 02:32:40.489+05	\N	0	prod_01K20MSWN66FHN4MM7XV2VAEQF
img_01K20MXVNCWB8S6YEE8DCWKNDR	http://localhost:9000/static/1754516090371-Frame%206.jpg	\N	2025-08-07 02:34:50.541+05	2025-08-07 02:34:50.541+05	\N	0	prod_01K20MXVNB0960JMW591DED198
img_01K20MXVNCCK0KSP3E9DDZ5BY2	http://localhost:9000/static/1754516090376-images%20(3).jpg	\N	2025-08-07 02:34:50.541+05	2025-08-07 02:34:50.541+05	\N	1	prod_01K20MXVNB0960JMW591DED198
img_01K20N2J05AJGAMS2VJGWVB011	http://localhost:9000/static/1754516244341-images%20(4).jpg	\N	2025-08-07 02:37:24.486+05	2025-08-07 02:37:24.486+05	\N	0	prod_01K20N2J04FX4FP4MHZPKBNCCD
img_01K20N66YSB0GNZ102P9G6KGY6	http://localhost:9000/static/1754516364066-Frame%203.jpg	\N	2025-08-07 02:39:24.25+05	2025-08-07 02:39:24.25+05	\N	0	prod_01K20N66YRKN0059GVKSCA8PF1
img_01K20N9RRZPCE1YVQN9TD9RFXQ	http://localhost:9000/static/1754516480657-images%20(6).jpg	\N	2025-08-07 02:41:20.8+05	2025-08-07 02:41:20.8+05	\N	0	prod_01K20N9RRW6EF07NP6XE7ND9HH
img_01K20NEAT7TM3FK6KP163F15N3	http://localhost:9000/static/1754516630189-images%20(8).jpg	\N	2025-08-07 02:43:50.344+05	2025-08-07 02:43:50.344+05	\N	0	prod_01K20NEAT6RMY2NJZX21QKQJPE
img_01K20NJT3Z80CTXFW5CRCXHCTN	http://localhost:9000/static/1754516776919-Frame%201%20(2).jpg	\N	2025-08-07 02:46:17.088+05	2025-08-07 02:46:17.088+05	\N	0	prod_01K20NJT3YFNZC5G7JM6Y3W20F
img_01K20NJT3ZJAXQHN9YT55BMWA3	http://localhost:9000/static/1754516776924-Frame%201.jpg	\N	2025-08-07 02:46:17.088+05	2025-08-07 02:46:17.088+05	\N	1	prod_01K20NJT3YFNZC5G7JM6Y3W20F
img_01K20NJT3ZZGYQ9NQNRPWSQNVA	http://localhost:9000/static/1754516776929-images%20(9).jpg	\N	2025-08-07 02:46:17.088+05	2025-08-07 02:46:17.088+05	\N	2	prod_01K20NJT3YFNZC5G7JM6Y3W20F
img_01K20NP5E95MDAKVR3Q3YCE53W	http://localhost:9000/static/1754516886785-Frame%205.jpg	\N	2025-08-07 02:48:06.986+05	2025-08-07 02:48:06.986+05	\N	0	prod_01K20NP5E8YNZPH57HJ3Y36KJE
img_01K20NVK7KG4K0NFFQAT8W6E6X	http://localhost:9000/static/1754517064738-images%20(11).jpg	\N	2025-08-07 02:51:04.951+05	2025-08-07 02:51:04.951+05	\N	0	prod_01K20NVK7BHBSQCC3JQ2M0N0K4
img_01K20NZB8QDF0F43SHX3EG4MT9	http://localhost:9000/static/1754517187678-Frame%202.jpg	\N	2025-08-07 02:53:07.864+05	2025-08-07 02:53:07.864+05	\N	0	prod_01K20NZB8P8TM934QN5Y9K9T1V
img_01K20P214Y758PXTDZ9NB11AMH	http://localhost:9000/static/1754517275659-images%20(14).jpg	\N	2025-08-07 02:54:35.807+05	2025-08-07 02:54:35.807+05	\N	0	prod_01K20P214XX3SXQZZY1QSY4E9T
img_01K20P4KYPYF3B8EFP82J9SPJH	http://localhost:9000/static/1754517360449-images%20(16).jpg	\N	2025-08-07 02:56:00.599+05	2025-08-07 02:56:00.599+05	\N	0	prod_01K20P4KYNH6ETFQ6ZFK1Q992P
img_01K20P8MWPH0VECFXF7A728EPZ	http://localhost:9000/static/1754517492447-Frame%204.jpg	\N	2025-08-07 02:58:12.631+05	2025-08-07 02:58:12.631+05	\N	0	prod_01K20P8MWNR636YWMJ28PZ46DR
img_01K20PBC8YP78B21SEFQGXG87S	http://localhost:9000/static/1754517581965-images%20(18).jpg	\N	2025-08-07 02:59:42.111+05	2025-08-07 02:59:42.111+05	\N	0	prod_01K20PBC8XC5Y4C2GRSJXA97CN
\.


--
-- Data for Name: inventory_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_item (id, created_at, updated_at, deleted_at, sku, origin_country, hs_code, mid_code, material, weight, length, height, width, requires_shipping, description, title, thumbnail, metadata) FROM stdin;
\.


--
-- Data for Name: inventory_level; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_level (id, created_at, updated_at, deleted_at, inventory_item_id, location_id, stocked_quantity, reserved_quantity, incoming_quantity, metadata, raw_stocked_quantity, raw_reserved_quantity, raw_incoming_quantity) FROM stdin;
\.


--
-- Data for Name: invite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invite (id, email, accepted, token, expires_at, metadata, created_at, updated_at, deleted_at) FROM stdin;
invite_01JTFS1BXS2BEPQ8MAR93G8467	admin@medusa-test.com	f	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Imludml0ZV8wMUpURlMxQlhTMkJFUFE4TUFSOTNHODQ2NyIsImVtYWlsIjoiYWRtaW5AbWVkdXNhLXRlc3QuY29tIiwiaWF0IjoxNzQ2NDMzNzgxLCJleHAiOjE3NDY1MjAxODEsImp0aSI6IjZlMGE5OGJiLTEwMjctNGRlNi1hNmMzLTQwNGZkNGYxMThjZiJ9.SttzbgufS_MwJIjAstyYI18kVJi1E2euulhA_2MoiLo	2025-05-06 13:29:41.689+05	\N	2025-05-05 13:29:41.693+05	2025-05-05 13:29:41.693+05	\N
\.


--
-- Data for Name: link_module_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.link_module_migrations (id, table_name, link_descriptor, created_at) FROM stdin;
1	cart_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "cart", "fromModule": "cart"}	2025-05-05 13:29:35.060979
3	location_fulfillment_provider	{"toModel": "fulfillment_provider", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2025-05-05 13:29:35.07351
2	cart_promotion	{"toModel": "promotions", "toModule": "promotion", "fromModel": "cart", "fromModule": "cart"}	2025-05-05 13:29:35.07206
4	location_fulfillment_set	{"toModel": "fulfillment_set", "toModule": "fulfillment", "fromModel": "location", "fromModule": "stock_location"}	2025-05-05 13:29:35.080666
5	order_cart	{"toModel": "cart", "toModule": "cart", "fromModel": "order", "fromModule": "order"}	2025-05-05 13:29:35.083366
6	order_promotion	{"toModel": "promotion", "toModule": "promotion", "fromModel": "order", "fromModule": "order"}	2025-05-05 13:29:35.083829
7	order_payment_collection	{"toModel": "payment_collection", "toModule": "payment", "fromModel": "order", "fromModule": "order"}	2025-05-05 13:29:35.083659
8	return_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "return", "fromModule": "order"}	2025-05-05 13:29:35.085165
9	order_fulfillment	{"toModel": "fulfillments", "toModule": "fulfillment", "fromModel": "order", "fromModule": "order"}	2025-05-05 13:29:35.08346
10	product_variant_inventory_item	{"toModel": "inventory", "toModule": "inventory", "fromModel": "variant", "fromModule": "product"}	2025-05-05 13:29:35.08821
11	product_variant_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "variant", "fromModule": "product"}	2025-05-05 13:29:35.089419
12	product_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "product", "fromModule": "product"}	2025-05-05 13:29:35.086946
13	publishable_api_key_sales_channel	{"toModel": "sales_channel", "toModule": "sales_channel", "fromModel": "api_key", "fromModule": "api_key"}	2025-05-05 13:29:35.090328
14	region_payment_provider	{"toModel": "payment_provider", "toModule": "payment", "fromModel": "region", "fromModule": "region"}	2025-05-05 13:29:35.093025
15	sales_channel_stock_location	{"toModel": "location", "toModule": "stock_location", "fromModel": "sales_channel", "fromModule": "sales_channel"}	2025-05-05 13:29:35.109063
16	shipping_option_price_set	{"toModel": "price_set", "toModule": "pricing", "fromModel": "shipping_option", "fromModule": "fulfillment"}	2025-05-05 13:29:35.109244
17	product_shipping_profile	{"toModel": "shipping_profile", "toModule": "fulfillment", "fromModel": "product", "fromModule": "product"}	2025-05-05 13:29:35.11019
18	customer_account_holder	{"toModel": "account_holder", "toModule": "payment", "fromModel": "customer", "fromModule": "customer"}	2025-05-05 13:29:35.110408
\.


--
-- Data for Name: location_fulfillment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_fulfillment_provider (stock_location_id, fulfillment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01JW34QSBSGXSNHGC4SF6NS6RD	manual_manual	locfp_01JW34TY8J1B1S1K7NQB8HKC56	2025-05-25 12:17:10.034624+05	2025-05-25 12:17:10.034624+05	\N
sloc_01JTFS1F22ETR16GFAB60SB0VK	manual_manual	locfp_01JTFS1F2DB7WH4TQ0MPJZC0X4	2025-05-05 13:29:44.90877+05	2025-05-25 12:18:13.03+05	2025-05-25 12:18:13.03+05
\.


--
-- Data for Name: location_fulfillment_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_fulfillment_set (stock_location_id, fulfillment_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
sloc_01JW34QSBSGXSNHGC4SF6NS6RD	fuset_01JW34R0WG4WWEPQ4ZXH6KEE4K	locfs_01JW34R0WW5AN2RRCW9GPK2B13	2025-05-25 12:15:34.428147+05	2025-05-25 12:15:34.428147+05	\N
sloc_01JTFS1F22ETR16GFAB60SB0VK	fuset_01JTFS1F2VSR7137S5W7WB71E5	locfs_01JTFS1F38B8CHFS8AWR73T2AX	2025-05-05 13:29:44.936156+05	2025-05-25 12:18:13.031+05	2025-05-25 12:18:13.031+05
sloc_01K20KC8VD27GKGVST85KQVJCS	fuset_01K20KCK0QMEX802Q20YAF6Q7S	locfs_01K20KCK1947TEM1KBR0GQ4HYA	2025-08-07 02:07:56.072291+05	2025-08-07 02:07:56.072291+05	\N
\.


--
-- Data for Name: mikro_orm_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mikro_orm_migrations (id, name, executed_at) FROM stdin;
1	Migration20240307161216	2025-08-07 00:53:31.208855+05
2	Migration20241210073813	2025-08-07 00:53:31.208855+05
3	Migration20250106142624	2025-08-07 00:53:31.208855+05
4	Migration20250120110820	2025-08-07 00:53:31.208855+05
5	Migration20240307132720	2025-08-07 00:53:31.412329+05
6	Migration20240719123015	2025-08-07 00:53:31.412329+05
7	Migration20241213063611	2025-08-07 00:53:31.412329+05
8	InitialSetup20240401153642	2025-08-07 00:53:31.71448+05
9	Migration20240601111544	2025-08-07 00:53:31.71448+05
10	Migration202408271511	2025-08-07 00:53:31.71448+05
11	Migration20241122120331	2025-08-07 00:53:31.71448+05
12	Migration20241125090957	2025-08-07 00:53:31.71448+05
13	Migration20250411073236	2025-08-07 00:53:31.71448+05
14	Migration20230929122253	2025-08-07 00:53:32.367921+05
15	Migration20240322094407	2025-08-07 00:53:32.367921+05
16	Migration20240322113359	2025-08-07 00:53:32.367921+05
17	Migration20240322120125	2025-08-07 00:53:32.367921+05
18	Migration20240626133555	2025-08-07 00:53:32.367921+05
19	Migration20240704094505	2025-08-07 00:53:32.367921+05
20	Migration20241127114534	2025-08-07 00:53:32.367921+05
21	Migration20241127223829	2025-08-07 00:53:32.367921+05
22	Migration20241128055359	2025-08-07 00:53:32.367921+05
23	Migration20241212190401	2025-08-07 00:53:32.367921+05
24	Migration20250408145122	2025-08-07 00:53:32.367921+05
25	Migration20250409122219	2025-08-07 00:53:32.367921+05
26	Migration20240227120221	2025-08-07 00:53:32.745119+05
27	Migration20240617102917	2025-08-07 00:53:32.745119+05
28	Migration20240624153824	2025-08-07 00:53:32.745119+05
29	Migration20241211061114	2025-08-07 00:53:32.745119+05
30	Migration20250113094144	2025-08-07 00:53:32.745119+05
31	Migration20250120110700	2025-08-07 00:53:32.745119+05
32	Migration20250226130616	2025-08-07 00:53:32.745119+05
33	Migration20240124154000	2025-08-07 00:53:33.110816+05
34	Migration20240524123112	2025-08-07 00:53:33.110816+05
35	Migration20240602110946	2025-08-07 00:53:33.110816+05
36	Migration20241211074630	2025-08-07 00:53:33.110816+05
37	Migration20240115152146	2025-08-07 00:53:33.269674+05
38	Migration20240222170223	2025-08-07 00:53:33.350556+05
39	Migration20240831125857	2025-08-07 00:53:33.350556+05
40	Migration20241106085918	2025-08-07 00:53:33.350556+05
41	Migration20241205095237	2025-08-07 00:53:33.350556+05
42	Migration20241216183049	2025-08-07 00:53:33.350556+05
43	Migration20241218091938	2025-08-07 00:53:33.350556+05
44	Migration20250120115059	2025-08-07 00:53:33.350556+05
45	Migration20250212131240	2025-08-07 00:53:33.350556+05
46	Migration20250326151602	2025-08-07 00:53:33.350556+05
47	Migration20240205173216	2025-08-07 00:53:33.641622+05
48	Migration20240624200006	2025-08-07 00:53:33.641622+05
49	Migration20250120110744	2025-08-07 00:53:33.641622+05
50	InitialSetup20240221144943	2025-08-07 00:53:33.776614+05
51	Migration20240604080145	2025-08-07 00:53:33.776614+05
52	Migration20241205122700	2025-08-07 00:53:33.776614+05
53	InitialSetup20240227075933	2025-08-07 00:53:33.855882+05
54	Migration20240621145944	2025-08-07 00:53:33.855882+05
55	Migration20241206083313	2025-08-07 00:53:33.855882+05
56	Migration20240227090331	2025-08-07 00:53:33.960286+05
57	Migration20240710135844	2025-08-07 00:53:33.960286+05
58	Migration20240924114005	2025-08-07 00:53:33.960286+05
59	Migration20241212052837	2025-08-07 00:53:33.960286+05
60	InitialSetup20240228133303	2025-08-07 00:53:34.154843+05
61	Migration20240624082354	2025-08-07 00:53:34.154843+05
62	Migration20240225134525	2025-08-07 00:53:34.240891+05
63	Migration20240806072619	2025-08-07 00:53:34.240891+05
64	Migration20241211151053	2025-08-07 00:53:34.240891+05
65	Migration20250115160517	2025-08-07 00:53:34.240891+05
66	Migration20250120110552	2025-08-07 00:53:34.240891+05
67	Migration20250123122334	2025-08-07 00:53:34.240891+05
68	Migration20250206105639	2025-08-07 00:53:34.240891+05
69	Migration20250207132723	2025-08-07 00:53:34.240891+05
70	Migration20240214033943	2025-08-07 00:53:34.802308+05
71	Migration20240703095850	2025-08-07 00:53:34.802308+05
72	Migration20241202103352	2025-08-07 00:53:34.802308+05
73	Migration20240509083918_InitialSetupMigration	2025-08-07 00:53:35.058553+05
74	Migration20240628075401	2025-08-07 00:53:35.058553+05
75	Migration20240830094712	2025-08-07 00:53:35.058553+05
76	Migration20250120110514	2025-08-07 00:53:35.058553+05
77	Migration20231228143900	2025-08-07 00:53:35.301295+05
78	Migration20241206101446	2025-08-07 00:53:35.301295+05
79	Migration20250128174331	2025-08-07 00:53:35.301295+05
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification (id, "to", channel, template, data, trigger_type, resource_id, resource_type, receiver_id, original_notification_id, idempotency_key, external_id, provider_id, created_at, updated_at, deleted_at, status) FROM stdin;
\.


--
-- Data for Name: notification_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_provider (id, handle, name, is_enabled, channels, created_at, updated_at, deleted_at) FROM stdin;
local	local	local	t	{feed}	2025-08-07 00:53:40.266+05	2025-08-07 00:53:40.266+05	\N
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."order" (id, region_id, display_id, customer_id, version, sales_channel_id, status, is_draft_order, email, currency_code, shipping_address_id, billing_address_id, no_notification, metadata, created_at, updated_at, deleted_at, canceled_at) FROM stdin;
order_01JTGGH9ECFTFTGPCTNV2D570W	reg_01JTFS1F03GKA26MVQDAGJD052	1	cus_01JTFTSK46D6GRFHSFZ3NB8NKD	2	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	canceled	f	ibrahimkhurram404@gmail.com	eur	caaddr_01JTGGGVBFV6Q47JEHZRFZGHDB	caaddr_01JTGGGVBF7T3VKSN4KHV20C5N	f	\N	2025-05-05 20:20:20.688+05	2025-05-25 11:41:49.026+05	\N	2025-05-25 11:41:49.024+05
\.


--
-- Data for Name: order_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_address (id, customer_id, company, first_name, last_name, address_1, address_2, city, country_code, province, postal_code, phone, metadata, created_at, updated_at, deleted_at) FROM stdin;
caaddr_01JTGGGVBF7T3VKSN4KHV20C5N	\N	IPL	Ibo	K	#403		Karachi	es	NYCX	75230		\N	2025-05-05 20:20:06.256+05	2025-05-05 20:20:06.256+05	\N
caaddr_01JTGGGVBFV6Q47JEHZRFZGHDB	\N	IPL	Ibo	K	#403		Karachi	es	NYCX	75230		\N	2025-05-05 20:20:06.256+05	2025-05-05 20:20:06.256+05	\N
\.


--
-- Data for Name: order_cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_cart (order_id, cart_id, id, created_at, updated_at, deleted_at) FROM stdin;
order_01JTGGH9ECFTFTGPCTNV2D570W	cart_01JTGGFK44DC2CR24ZS6A98RRV	ordercart_01JTGGH9JZ049D04Z1KDNB22JB	2025-05-05 20:20:20.820367+05	2025-05-05 20:20:20.820367+05	\N
\.


--
-- Data for Name: order_change; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_change (id, order_id, version, description, status, internal_note, created_by, requested_by, requested_at, confirmed_by, confirmed_at, declined_by, declined_reason, metadata, declined_at, canceled_by, canceled_at, created_at, updated_at, change_type, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
ordch_01JW32T6TZVGG5YBN2JMVQVH1J	order_01JTGGH9ECFTFTGPCTNV2D570W	2	\N	confirmed	\N	\N	\N	\N	\N	2025-05-25 11:41:48.94+05	\N	\N	\N	\N	\N	\N	2025-05-25 11:41:48.896+05	2025-05-25 11:41:48.946+05	credit_line	\N	\N	\N	\N
\.


--
-- Data for Name: order_change_action; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_change_action (id, order_id, version, ordering, order_change_id, reference, reference_id, action, details, amount, raw_amount, internal_note, applied, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
ordchact_01JW32T6VPR0JQE3BRQ11FY6FX	order_01JTGGH9ECFTFTGPCTNV2D570W	2	1	ordch_01JW32T6TZVGG5YBN2JMVQVH1J	payment_collection	pay_col_01JTGGH5H23SAD7EXTM6Q1YFBG	CREDIT_LINE_ADD	{}	20	{"value": "20", "precision": 20}	\N	t	2025-05-25 11:41:48.918+05	2025-05-25 11:41:48.997+05	\N	\N	\N	\N
\.


--
-- Data for Name: order_claim; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_claim (id, order_id, return_id, order_version, display_id, type, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_claim_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_claim_item (id, claim_id, item_id, is_additional_item, reason, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_claim_item_image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_claim_item_image (id, claim_item_id, url, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_credit_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_credit_line (id, order_id, reference, reference_id, amount, raw_amount, metadata, created_at, updated_at, deleted_at) FROM stdin;
ordcl_01JW32T6Y794KW99A3ABD5RV2F	order_01JTGGH9ECFTFTGPCTNV2D570W	payment_collection	pay_col_01JTGGH5H23SAD7EXTM6Q1YFBG	20	{"value": "20", "precision": 20}	\N	2025-05-25 11:41:48.999+05	2025-05-25 11:41:48.999+05	\N
\.


--
-- Data for Name: order_exchange; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_exchange (id, order_id, return_id, order_version, display_id, no_notification, allow_backorder, difference_due, raw_difference_due, metadata, created_at, updated_at, deleted_at, canceled_at, created_by) FROM stdin;
\.


--
-- Data for Name: order_exchange_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_exchange_item (id, exchange_id, item_id, quantity, raw_quantity, note, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_fulfillment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_fulfillment (order_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_item (id, order_id, version, item_id, quantity, raw_quantity, fulfilled_quantity, raw_fulfilled_quantity, shipped_quantity, raw_shipped_quantity, return_requested_quantity, raw_return_requested_quantity, return_received_quantity, raw_return_received_quantity, return_dismissed_quantity, raw_return_dismissed_quantity, written_off_quantity, raw_written_off_quantity, metadata, created_at, updated_at, deleted_at, delivered_quantity, raw_delivered_quantity, unit_price, raw_unit_price, compare_at_unit_price, raw_compare_at_unit_price) FROM stdin;
orditem_01JTGGH9EF2HCNNRF6MTS8ZSTV	order_01JTGGH9ECFTFTGPCTNV2D570W	1	ordli_01JTGGH9EDN3SNMY5V9NQVCDNP	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-05-05 20:20:20.689+05	2025-05-05 20:20:20.689+05	\N	0	{"value": "0", "precision": 20}	\N	\N	\N	\N
orditem_01JW32T6XV9P81928C01W702VR	order_01JTGGH9ECFTFTGPCTNV2D570W	2	ordli_01JTGGH9EDN3SNMY5V9NQVCDNP	1	{"value": "1", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	0	{"value": "0", "precision": 20}	\N	2025-05-25 11:41:48.988+05	2025-05-25 11:41:48.988+05	\N	0	{"value": "0", "precision": 20}	10	{"value": "10", "precision": 20}	\N	\N
\.


--
-- Data for Name: order_line_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_item (id, totals_id, title, subtitle, thumbnail, variant_id, product_id, product_title, product_description, product_subtitle, product_type, product_collection, product_handle, variant_sku, variant_barcode, variant_title, variant_option_values, requires_shipping, is_discountable, is_tax_inclusive, compare_at_unit_price, raw_compare_at_unit_price, unit_price, raw_unit_price, metadata, created_at, updated_at, deleted_at, is_custom_price, product_type_id, is_giftcard) FROM stdin;
ordli_01JTGGH9EDN3SNMY5V9NQVCDNP	\N	L	Medusa Sweatshirt	https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png	variant_01JTFS1FA4JRNGR7N6ZN06Z2YF	prod_01JTFS1F7NVX10M8WD2NH9AR9E	Medusa Sweatshirt	Reimagine the feeling of a classic sweatshirt. With our cotton sweatshirt, everyday essentials no longer have to be ordinary.	\N	\N	\N	sweatshirt	SWEATSHIRT-L	\N	L	\N	t	t	f	\N	\N	10	{"value": "10", "precision": 20}	{}	2025-05-05 20:20:20.688+05	2025-05-05 20:20:20.688+05	\N	f	\N	f
\.


--
-- Data for Name: order_line_item_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_item_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, item_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_line_item_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line_item_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, item_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_payment_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_payment_collection (order_id, payment_collection_id, id, created_at, updated_at, deleted_at) FROM stdin;
order_01JTGGH9ECFTFTGPCTNV2D570W	pay_col_01JTGGH5H23SAD7EXTM6Q1YFBG	ordpay_01JTGGH9JXHQAR3X3TGZPP5V30	2025-05-05 20:20:20.823548+05	2025-05-05 20:20:20.823548+05	\N
\.


--
-- Data for Name: order_promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_promotion (order_id, promotion_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping (id, order_id, version, shipping_method_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
ordspmv_01JTGGH9EBBZKSBZQNQEB6DKCP	order_01JTGGH9ECFTFTGPCTNV2D570W	1	ordsm_01JTGGH9EB83R25E0MGDX72577	2025-05-05 20:20:20.689+05	2025-05-05 20:20:20.689+05	\N	\N	\N	\N
ordspmv_01JW32T6XZ0VA0XDRRCEMJMCXZ	order_01JTGGH9ECFTFTGPCTNV2D570W	2	ordsm_01JTGGH9EB83R25E0MGDX72577	2025-05-05 20:20:20.689+05	2025-05-05 20:20:20.689+05	\N	\N	\N	\N
\.


--
-- Data for Name: order_shipping_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping_method (id, name, description, amount, raw_amount, is_tax_inclusive, shipping_option_id, data, metadata, created_at, updated_at, deleted_at, is_custom_amount) FROM stdin;
ordsm_01JTGGH9EB83R25E0MGDX72577	Standard Shipping	\N	10	{"value": "10", "precision": 20}	f	so_01JTFS1F4CBJ5W78WGFNKCSBHV	{}	\N	2025-05-05 20:20:20.689+05	2025-05-05 20:20:20.689+05	\N	f
\.


--
-- Data for Name: order_shipping_method_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping_method_adjustment (id, description, promotion_id, code, amount, raw_amount, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_shipping_method_tax_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping_method_tax_line (id, description, tax_rate_id, code, rate, raw_rate, provider_id, created_at, updated_at, shipping_method_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: order_transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_transaction (id, order_id, version, amount, raw_amount, currency_code, reference, reference_id, created_at, updated_at, deleted_at, return_id, claim_id, exchange_id) FROM stdin;
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (id, amount, raw_amount, currency_code, provider_id, data, created_at, updated_at, deleted_at, captured_at, canceled_at, payment_collection_id, payment_session_id, metadata) FROM stdin;
\.


--
-- Data for Name: payment_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_collection (id, currency_code, amount, raw_amount, authorized_amount, raw_authorized_amount, captured_amount, raw_captured_amount, refunded_amount, raw_refunded_amount, created_at, updated_at, deleted_at, completed_at, status, metadata) FROM stdin;
\.


--
-- Data for Name: payment_collection_payment_providers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_collection_payment_providers (payment_collection_id, payment_provider_id) FROM stdin;
\.


--
-- Data for Name: payment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
pp_system_default	t	2025-08-07 00:53:39.767+05	2025-08-07 00:53:39.767+05	\N
\.


--
-- Data for Name: payment_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_session (id, currency_code, amount, raw_amount, provider_id, data, context, status, authorized_at, payment_collection_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: price; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price (id, title, price_set_id, currency_code, raw_amount, rules_count, created_at, updated_at, deleted_at, price_list_id, amount, min_quantity, max_quantity) FROM stdin;
price_01K20ME3B25HEFFZAX5RRSY698	\N	pset_01K20ME3B2HC04AEJF3P9NE3JQ	inr	{"value": "3899", "precision": 20}	0	2025-08-07 02:26:14.115+05	2025-08-07 02:26:14.115+05	\N	\N	3899	\N	\N
price_01K20ME3B2Y7N4GAZ5Z24XB0PJ	\N	pset_01K20ME3B2HC04AEJF3P9NE3JQ	pkr	{"value": "12999", "precision": 20}	0	2025-08-07 02:26:14.115+05	2025-08-07 02:26:14.115+05	\N	\N	12999	\N	\N
price_01K20MSWQF2N5FX6Y5C4N4SMM8	\N	pset_01K20MSWQFFPWCSGXW7HKQM56W	inr	{"value": "3590", "precision": 20}	0	2025-08-07 02:32:40.559+05	2025-08-07 02:32:40.559+05	\N	\N	3590	\N	\N
price_01K20MSWQFS7P3TAF7S5EVPBBV	\N	pset_01K20MSWQFFPWCSGXW7HKQM56W	pkr	{"value": "12000", "precision": 20}	0	2025-08-07 02:32:40.559+05	2025-08-07 02:32:40.559+05	\N	\N	12000	\N	\N
price_01K20MXVQWHJTS6MJR1AB77PZW	\N	pset_01K20MXVQWN0TV6F500JT2SBGZ	inr	{"value": "4490", "precision": 20}	0	2025-08-07 02:34:50.621+05	2025-08-07 02:34:50.621+05	\N	\N	4490	\N	\N
price_01K20MXVQWKE78E51BBDSVYVM1	\N	pset_01K20MXVQWN0TV6F500JT2SBGZ	pkr	{"value": "15000", "precision": 20}	0	2025-08-07 02:34:50.621+05	2025-08-07 02:34:50.621+05	\N	\N	15000	\N	\N
price_01K20N2J2PNPE3WH63W13HGA1H	\N	pset_01K20N2J2QSKNCTXDFXZMNG82H	inr	{"value": "2990", "precision": 20}	0	2025-08-07 02:37:24.567+05	2025-08-07 02:37:24.567+05	\N	\N	2990	\N	\N
price_01K20N2J2QZM0T9PDWXJ6EVGH4	\N	pset_01K20N2J2QSKNCTXDFXZMNG82H	pkr	{"value": "10000", "precision": 20}	0	2025-08-07 02:37:24.567+05	2025-08-07 02:37:24.567+05	\N	\N	10000	\N	\N
price_01K20N670YDJAE3R7T1DEFGZK1	\N	pset_01K20N670YKSM51Q4MZBQMA979	inr	{"value": "4499", "precision": 20}	0	2025-08-07 02:39:24.319+05	2025-08-07 02:39:24.319+05	\N	\N	4499	\N	\N
price_01K20N670Y8CBF1X8AFXVQHZT1	\N	pset_01K20N670YKSM51Q4MZBQMA979	pkr	{"value": "15000", "precision": 20}	0	2025-08-07 02:39:24.319+05	2025-08-07 02:39:24.319+05	\N	\N	15000	\N	\N
price_01K20N9RTX3EQY76JG0SG3NTD0	\N	pset_01K20N9RTXRRPZDYV8ZFG4DH1A	inr	{"value": "4490", "precision": 20}	0	2025-08-07 02:41:20.862+05	2025-08-07 02:41:20.862+05	\N	\N	4490	\N	\N
price_01K20N9RTXFJKH25FNX48JJ5PC	\N	pset_01K20N9RTXRRPZDYV8ZFG4DH1A	pkr	{"value": "15000", "precision": 20}	0	2025-08-07 02:41:20.862+05	2025-08-07 02:41:20.862+05	\N	\N	15000	\N	\N
price_01K20NEAWEMMT09YM23TE7S30A	\N	pset_01K20NEAWFY12Z92QSMZ04Z6YZ	inr	{"value": "4790", "precision": 20}	0	2025-08-07 02:43:50.415+05	2025-08-07 02:43:50.415+05	\N	\N	4790	\N	\N
price_01K20NEAWE62E2RKJS0GW4X6FA	\N	pset_01K20NEAWFY12Z92QSMZ04Z6YZ	pkr	{"value": "16000", "precision": 20}	0	2025-08-07 02:43:50.415+05	2025-08-07 02:43:50.415+05	\N	\N	16000	\N	\N
price_01K20NJT5VV4N0W68870XVPEZH	\N	pset_01K20NJT5VBF2WX1KNM1TA9TBQ	inr	{"value": "4190", "precision": 20}	0	2025-08-07 02:46:17.148+05	2025-08-07 02:46:17.148+05	\N	\N	4190	\N	\N
price_01K20NJT5VKABA5QW0CSN625AN	\N	pset_01K20NJT5VBF2WX1KNM1TA9TBQ	pkr	{"value": "14000", "precision": 20}	0	2025-08-07 02:46:17.148+05	2025-08-07 02:46:17.148+05	\N	\N	14000	\N	\N
price_01K20NP5G5FSQSYG2MM0CS5DNQ	\N	pset_01K20NP5G5S2RGD029TKNWSPV1	inr	{"value": "4790", "precision": 20}	0	2025-08-07 02:48:07.045+05	2025-08-07 02:48:07.045+05	\N	\N	4790	\N	\N
price_01K20NP5G50E782HTEQJNPAE6H	\N	pset_01K20NP5G5S2RGD029TKNWSPV1	pkr	{"value": "16000", "precision": 20}	0	2025-08-07 02:48:07.046+05	2025-08-07 02:48:07.046+05	\N	\N	16000	\N	\N
price_01K20NVKDSQXGEGQQZHHH55P0M	\N	pset_01K20NVKDSE6W1XBKVZ2TTPSRT	inr	{"value": "5390", "precision": 20}	0	2025-08-07 02:51:05.146+05	2025-08-07 02:51:05.146+05	\N	\N	5390	\N	\N
price_01K20NVKDSEYPQMRZN8QWA4JFK	\N	pset_01K20NVKDSE6W1XBKVZ2TTPSRT	pkr	{"value": "18000", "precision": 20}	0	2025-08-07 02:51:05.146+05	2025-08-07 02:51:05.146+05	\N	\N	18000	\N	\N
price_01K20NZBBH42TDD605Q1G31VDV	\N	pset_01K20NZBBHG5D1M3167QSFZEZV	inr	{"value": "4790", "precision": 20}	0	2025-08-07 02:53:07.954+05	2025-08-07 02:53:07.954+05	\N	\N	4790	\N	\N
price_01K20NZBBH9P5TWK9REQ0PHD2Z	\N	pset_01K20NZBBHG5D1M3167QSFZEZV	pkr	{"value": "16000", "precision": 20}	0	2025-08-07 02:53:07.954+05	2025-08-07 02:53:07.954+05	\N	\N	16000	\N	\N
price_01K20P217JDZF2ZHZ9FFADFEXR	\N	pset_01K20P217M98G790SZKH8X2PMK	inr	{"value": "4200", "precision": 20}	0	2025-08-07 02:54:35.892+05	2025-08-07 02:54:35.892+05	\N	\N	4200	\N	\N
price_01K20P217KEN8FY01AJ7BVGY0G	\N	pset_01K20P217M98G790SZKH8X2PMK	pkr	{"value": "14000", "precision": 20}	0	2025-08-07 02:54:35.892+05	2025-08-07 02:54:35.892+05	\N	\N	14000	\N	\N
price_01K20P4M22VSQACR07H1QBTY2V	\N	pset_01K20P4M223P6CVB0F0BPCD9HS	inr	{"value": "3900", "precision": 20}	0	2025-08-07 02:56:00.707+05	2025-08-07 02:56:00.707+05	\N	\N	3900	\N	\N
price_01K20P4M2217FE3W19K8ATGW4M	\N	pset_01K20P4M223P6CVB0F0BPCD9HS	pkr	{"value": "13000", "precision": 20}	0	2025-08-07 02:56:00.707+05	2025-08-07 02:56:00.707+05	\N	\N	13000	\N	\N
price_01K20P8MZ4DRW2HE6WVTAC4XDC	\N	pset_01K20P8MZ4YB3EDTTT4SC2NCTS	inr	{"value": "4500", "precision": 20}	0	2025-08-07 02:58:12.709+05	2025-08-07 02:58:12.709+05	\N	\N	4500	\N	\N
price_01K20P8MZ4MB4G5YNXWSD1MZFN	\N	pset_01K20P8MZ4YB3EDTTT4SC2NCTS	pkr	{"value": "15000", "precision": 20}	0	2025-08-07 02:58:12.709+05	2025-08-07 02:58:12.709+05	\N	\N	15000	\N	\N
price_01K20PBCB1MK0MEQSJXHF9QR7Y	\N	pset_01K20PBCB1PFS7ZZAQNNW9PS3N	inr	{"value": "3300", "precision": 20}	0	2025-08-07 02:59:42.178+05	2025-08-07 02:59:42.178+05	\N	\N	3300	\N	\N
price_01K20PBCB1GJ51HFQFXY2HDFY4	\N	pset_01K20PBCB1PFS7ZZAQNNW9PS3N	pkr	{"value": "11000", "precision": 20}	0	2025-08-07 02:59:42.178+05	2025-08-07 02:59:42.178+05	\N	\N	11000	\N	\N
\.


--
-- Data for Name: price_list; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_list (id, status, starts_at, ends_at, rules_count, title, description, type, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: price_list_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_list_rule (id, price_list_id, created_at, updated_at, deleted_at, value, attribute) FROM stdin;
\.


--
-- Data for Name: price_preference; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_preference (id, attribute, value, is_tax_inclusive, created_at, updated_at, deleted_at) FROM stdin;
prpref_01K20F4ZMHBS0HJZXJ4Z484KYV	currency_code	eur	f	2025-08-07 00:53:52.529+05	2025-08-07 00:53:52.529+05	\N
prpref_01K20KE9QR5H3WXP4AG3TWXC4P	region_id	reg_01K20KE9PH6XVMM3SQKCMNR5EE	f	2025-08-07 02:08:52.089+05	2025-08-07 02:08:52.089+05	\N
prpref_01K20KG6E7E1M5FJG1RPMGTRQY	currency_code	inr	f	2025-08-07 02:09:54.248+05	2025-08-07 02:10:02.168+05	\N
prpref_01K20KG6E844V83SKFCQKFM40M	currency_code	pkr	t	2025-08-07 02:09:54.248+05	2025-08-07 02:10:07.875+05	\N
\.


--
-- Data for Name: price_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_rule (id, value, priority, price_id, created_at, updated_at, deleted_at, attribute, operator) FROM stdin;
\.


--
-- Data for Name: price_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_set (id, created_at, updated_at, deleted_at) FROM stdin;
pset_01K20ME3B2HC04AEJF3P9NE3JQ	2025-08-07 02:26:14.115+05	2025-08-07 02:26:14.115+05	\N
pset_01K20MSWQFFPWCSGXW7HKQM56W	2025-08-07 02:32:40.559+05	2025-08-07 02:32:40.559+05	\N
pset_01K20MXVQWN0TV6F500JT2SBGZ	2025-08-07 02:34:50.621+05	2025-08-07 02:34:50.621+05	\N
pset_01K20N2J2QSKNCTXDFXZMNG82H	2025-08-07 02:37:24.567+05	2025-08-07 02:37:24.567+05	\N
pset_01K20N670YKSM51Q4MZBQMA979	2025-08-07 02:39:24.319+05	2025-08-07 02:39:24.319+05	\N
pset_01K20N9RTXRRPZDYV8ZFG4DH1A	2025-08-07 02:41:20.862+05	2025-08-07 02:41:20.862+05	\N
pset_01K20NEAWFY12Z92QSMZ04Z6YZ	2025-08-07 02:43:50.415+05	2025-08-07 02:43:50.415+05	\N
pset_01K20NJT5VBF2WX1KNM1TA9TBQ	2025-08-07 02:46:17.148+05	2025-08-07 02:46:17.148+05	\N
pset_01K20NP5G5S2RGD029TKNWSPV1	2025-08-07 02:48:07.045+05	2025-08-07 02:48:07.045+05	\N
pset_01K20NVKDSE6W1XBKVZ2TTPSRT	2025-08-07 02:51:05.146+05	2025-08-07 02:51:05.146+05	\N
pset_01K20NZBBHG5D1M3167QSFZEZV	2025-08-07 02:53:07.954+05	2025-08-07 02:53:07.954+05	\N
pset_01K20P217M98G790SZKH8X2PMK	2025-08-07 02:54:35.892+05	2025-08-07 02:54:35.892+05	\N
pset_01K20P4M223P6CVB0F0BPCD9HS	2025-08-07 02:56:00.707+05	2025-08-07 02:56:00.707+05	\N
pset_01K20P8MZ4YB3EDTTT4SC2NCTS	2025-08-07 02:58:12.709+05	2025-08-07 02:58:12.709+05	\N
pset_01K20PBCB1PFS7ZZAQNNW9PS3N	2025-08-07 02:59:42.178+05	2025-08-07 02:59:42.178+05	\N
\.


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product (id, title, handle, subtitle, description, is_giftcard, status, thumbnail, weight, length, height, width, origin_country, hs_code, mid_code, material, collection_id, type_id, discountable, external_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
prod_01K20ME37KW189HXKM3RT1AJMX	Circle of Divine Names | Islamic Calligraphy Art	allah-name-round-calligraphy	Sacred words woven in symmetry — a timeless tribute to Allah’s grandeur.	This captivating piece of Islamic calligraphy features the name of Allah elegantly placed above a circular formation of intricate script in deep maroon and black. The core of the circle highlights one of Allah’s powerful attributes, radiating spirituality and reverence. Framed with delicate corner motifs and a silver border, it’s a perfect blend of sacred symbolism and ornamental grace. Ideal for prayer areas, living rooms, or offices seeking a divine touch.	f	published	\N	\N	1	20	18	pk			\N	pcol_01K20QJP2W99M1SCX97RN2CR45	\N	t	\N	2025-08-07 02:26:14.008+05	2025-08-07 03:21:30.607+05	\N	{"meta": "Allah wall art, Islamic circular calligraphy, Arabic calligraphy frame, Islamic decor, divine name artwork, Surah calligraphy, Islamic spiritual frame, Allahu wall hanging, calligraphy art India"}
prod_01K20MXVNB0960JMW591DED198	Minimalist Kalima in Kufic Script | Geometric Islamic Art	kufic-kalima-geometric-islamic-art	A bold statement of faith — structured in divine geometry.	This striking artwork presents the Kalima (Islamic declaration of faith) in Kufic script, known for its geometric, block-like design. Rendered in high contrast black and white tones with precise symmetry, this piece fuses ancient script with modern minimalism. Set against a warm-textured golden background and framed with a classic border, it’s a powerful centerpiece for any contemporary or traditional interior.	f	published	http://localhost:9000/static/1754516090371-Frame%206.jpg	\N	2	24	26	pk			\N	pcol_01K20R62AR9QZM8R9AQKJ2RCH5	\N	t	\N	2025-08-07 02:34:50.541+05	2025-08-07 03:32:48.295+05	\N	{"meta": "Kufic calligraphy art, Kalima Islamic wall frame, geometric Arabic script, Islamic minimalist decor, declaration of faith artwork, Islamic square calligraphy, modern Islamic art India, black and white Kufic art"}
prod_01K20MSWN66FHN4MM7XV2VAEQF	Divine Lines of Tawheed | Islamic Calligraphy Frame	divine-lines-of-tawheed-frame	Elegant expression of faith — the name of Allah with the essence of Tawheed in graceful script.	This stunning horizontal calligraphy piece features the name of Allah in large, golden Arabic script, accompanied by beautifully penned Quranic verses emphasizing the oneness of God (Tawheed). Framed in a polished gold border, this minimalist composition brings calm, clarity, and sacred energy to any space. Ideal for living rooms, prayer corners, or offices that reflect spiritual identity.	f	published	http://localhost:9000/static/1754515960334-Frame%207.jpg	\N	2	15	30	pk			\N	pcol_01K20R62AR9QZM8R9AQKJ2RCH5	\N	t	\N	2025-08-07 02:32:40.488+05	2025-08-07 03:32:48.295+05	\N	{"meta": "Allah calligraphy frame, Islamic horizontal wall art, Arabic calligraphy decor, Quran verse artwork, gold frame Islamic art, Tawheed calligraphy, spiritual home decor, Islamic art India"}
prod_01K20N9RRW6EF07NP6XE7ND9HH	Bowl of Blessings | Islamic Calligraphy in Flow	bowl-of-blessings-islamic-calligraphy	Where words pour like sustenance — a vessel of divine verses.	This unique Islamic artwork is composed of flowing Arabic calligraphy shaped like a bowl, resting above structured lines of text. The top calligraphy element symbolizes a vessel filled with spiritual wisdom, while the stacked verses represent continuous divine sustenance. Accented with floral corner motifs and enclosed in a rich black frame, this piece makes a serene yet powerful statement. Perfect for homes, libraries, or meditation rooms seeking inspiration and tranquility.	f	published	http://localhost:9000/static/1754516480657-images%20(6).jpg	\N	2	22	30	pk			\N	pcol_01K20M4VF5CYF38YD9XMFMSK3P	\N	t	\N	2025-08-07 02:41:20.799+05	2025-08-07 02:41:20.799+05	\N	{"meta": "Islamic bowl calligraphy, Arabic calligraphy wall art, flowing script Islamic decor, Quranic calligraphy artwork, divine sustenance wall frame, Islamic blessings art, modern Islamic wall piece, black frame Islamic art India"}
prod_01K20NEAT6RMY2NJZX21QKQJPE	Then Which of Your Lord’s Favors? | Monochrome Ayah Art	surah-arrahman-calligraphy-monochrome	A timeless verse, boldly inked — a reminder wrapped in reverence.	This powerful calligraphy artwork features the repeated verse from Surah Ar-Rahman (55:13) — “فَبِأَيِّ آلَاءِ رَبِّكُمَا تُكَذِّبَانِ” — masterfully designed in a dramatic black-and-white flow. Set against a smoky grayscale background and enclosed in a detailed silver frame, it captures attention while evoking humility. This piece is ideal for spiritual interiors, Quran corners, or spaces meant to reflect divine gratitude and remembrance.	f	published	http://localhost:9000/static/1754516630189-images%20(8).jpg	\N	2	22	30	pk			\N	pcol_01K20Q2632ETFG0AVAXCRAFGQW	\N	t	\N	2025-08-07 02:43:50.344+05	2025-08-07 03:12:56.299+05	\N	{"meta": "Surah Rahman calligraphy, monochrome Islamic art, Quran verse wall frame, Islamic black and white calligraphy, Fabiaayi ala calligraphy, Islamic art India, Arabic reminder wall decor, divine verse artwork"}
prod_01K20P214XX3SXQZZY1QSY4E9T	Qul | Surah Ikhlas Border Calligraphy Frame	qul-surah-ikhlas-calligraphy-frame	A timeless echo of divine unity — minimal yet deeply spiritual.	This elegant artwork features the opening word "Qul" (قُلْ) from Surah Ikhlas, set boldly on the right side in large calligraphy, surrounded by the full Surah written in a rectangular border format in intricate script. The balance between simplicity and detail gives this piece a meditative quality, perfect for adding spiritual depth to a modern or traditional room. Encased in a golden frame, it's ideal for living rooms, offices, and prayer corners.	f	published	http://localhost:9000/static/1754517275659-images%20(14).jpg	\N	2	24	36	pk			\N	pcol_01K20QJP2W99M1SCX97RN2CR45	\N	t	\N	2025-08-07 02:54:35.806+05	2025-08-07 03:21:30.607+05	\N	{"meta": "Surah Ikhlas wall art, Qul calligraphy painting, Quranic verse frame, Islamic calligraphy decor India, golden frame Islamic art, Arabic script artwork, Islamic minimalist frame, spiritual wall decor"}
prod_01K20N66YRKN0059GVKSCA8PF1	Golden Kalima Maze | Kufic Calligraphy Wall Art	golden-kalima-kufic-maze-art	Faith meets form — a geometric expression of divine oneness.	This modern Islamic wall art features the Kalima in striking Kufic script, composed like a maze in radiant gold over a bold black and maroon background. The central black block of text contrasts sharply with the matte-gold Kufic layout, offering a high-impact visual that embodies precision, spirituality, and minimalism. Perfect for living spaces, offices, or artistic prayer areas where tradition meets contemporary design.	f	published	http://localhost:9000/static/1754516364066-Frame%203.jpg	\N	2	26	26	pk			\N	pcol_01K20R62AR9QZM8R9AQKJ2RCH5	\N	t	\N	2025-08-07 02:39:24.249+05	2025-08-07 03:32:48.296+05	\N	{"meta": "Kalima Kufic calligraphy, golden Arabic calligraphy art, Islamic maze wall decor, modern Islamic art India, geometric Islamic painting, minimalist religious frame, gold kufic frame, square Islamic calligraphy"}
prod_01K20N2J04FX4FP4MHZPKBNCCD	Calligraphy in Sujood | Devotion in Form	sujood-calligraphy-prayer-art	Sacred verses shaped by submission — a visual prayer in ink.	This heartfelt artwork captures the act of sujood (prostration in prayer) through an intricate calligraphic figure. The body of the worshipper is composed entirely of Arabic script, flowing to form limbs and posture in a powerful visual metaphor of devotion and surrender. With traditional lanterns and warm earthy tones, it’s a soulful addition to prayer rooms or spaces seeking tranquility and spiritual reflection.	f	published	http://localhost:9000/static/1754516244341-images%20(4).jpg	\N	\N	18	26	pk			\N	pcol_01K20Q2632ETFG0AVAXCRAFGQW	\N	t	\N	2025-08-07 02:37:24.485+05	2025-08-07 03:12:56.299+05	\N	{"meta": "Sujood calligraphy art, Islamic prayer artwork, prostration figure calligraphy, spiritual wall art, Arabic devotional frame, Muslim prayer decor, worship calligraphy India, Islamic submission art"}
prod_01K20P4KYNH6ETFQ6ZFK1Q992P	Qul | Circular Surah Ikhlas Calligraphy Frame	circular-qul-surah-ikhlas-golden-frame	Unity in every direction — Surah Ikhlas in timeless circular beauty.	This striking artwork features the word "Qul" (قُلْ) boldly centered, surrounded by the full Surah Ikhlas arranged in concentric circular bands of elegant Arabic calligraphy. The contrast of deep black and blue script on a golden background adds regal charm to any space. A perfect symbol of monotheism and divine power, this frame makes a serene and spiritual statement in your living room, hallway, or prayer corner.	f	published	http://localhost:9000/static/1754517360449-images%20(16).jpg	\N	2	22	22	pk			\N	pcol_01K20PZ7EBTYDFJHV1AP9XGAEE	\N	t	\N	2025-08-07 02:56:00.598+05	2025-08-07 03:11:01.088+05	\N	{"meta": "Surah Ikhlas circular calligraphy, Qul Islamic wall art, Arabic Quran verse round frame, golden background Islamic decor, concentric script calligraphy, handmade Quranic artwork, spiritual home decor India"}
prod_01K20NVK7BHBSQCC3JQ2M0N0K4	Golden Kalima in Kufic Script | Royal Statement of Faith	golden-kufic-kalima-wall-art	Structured in geometry, elevated in meaning — the essence of Tawheed.	This premium Islamic art piece features the Kalima (Islamic declaration of faith) in a bold Kufic script, rendered in radiant gold on a deep black background. Its precise symmetry and minimal form make it both a powerful religious statement and a piece of modern decor. Encased in a gold frame, the contrast evokes elegance and reverence, ideal for feature walls in living rooms, offices, or Islamic art galleries.	f	published	http://localhost:9000/static/1754517064738-images%20(11).jpg	\N	2	28	40	pk			\N	pcol_01K20QJP2W99M1SCX97RN2CR45	\N	t	\N	2025-08-07 02:51:04.95+05	2025-08-07 03:21:30.607+05	\N	{"meta": "gold Kalima wall art, Kufic calligraphy Islamic frame, luxury Arabic calligraphy, Islamic golden wall decor, declaration of faith artwork, bold Kufic script painting, Islamic modern art India, tawheed statement decor"}
prod_01K20NJT3YFNZC5G7JM6Y3W20F	Name of Allah & Ali | Layered Calligraphy in Devotion	allah-ali-layered-calligraphy-art	Faith and love united — a visual harmony of divine remembrance.	This striking piece brings together the name of Allah and Ali (عليه السلام) in graceful green calligraphy, centered above and below flowing layers of Arabic script. The tiered structure symbolizes depth in both devotion and reverence, creating a visual ascent from reflection to elevation. The artwork is framed in a classic golden border and bathed in warm tones, making it a perfect fit for prayer spaces, majlis walls, or spiritually inspired interiors.	f	published	http://localhost:9000/static/1754516776919-Frame%201%20(2).jpg	\N	2	30	22	pk			\N	pcol_01K20R62AR9QZM8R9AQKJ2RCH5	\N	t	\N	2025-08-07 02:46:17.088+05	2025-08-07 03:32:48.296+05	\N	{"meta": "Allah and Ali calligraphy, Islamic vertical wall art, Arabic layered script, Shia Islamic decor, spiritual calligraphy frame, Ali name artwork, divine Islamic names art, Islamic art India"}
prod_01K20NZB8P8TM934QN5Y9K9T1V	Favors of Your Lord | Contemporary Thuluth Calligraphy	fabi-ayyi-rabbikuma-modern-calligraphy	A divine echo in bold form — reminding hearts with every glance.	Featuring the powerful verse “فَبِأَيِّ آلَاءِ رَبِّكُمَا تُكَذِّبَانِ” from Surah Ar-Rahman, this artwork makes a dramatic statement with its modern Thuluth-style calligraphy in bold black ink against a moody grayscale background. The white border around the flowing Arabic script gives the text a carved, elevated effect. Completed with a silver ornamental frame, this piece is perfect for spaces that blend modern aesthetics with spiritual meaning — ideal for foyers, lounges, or spiritual corners.	f	published	http://localhost:9000/static/1754517187678-Frame%202.jpg	\N	2	24	34	pk			\N	pcol_01K20R62AR9QZM8R9AQKJ2RCH5	\N	t	\N	2025-08-07 02:53:07.864+05	2025-08-07 03:32:48.3+05	\N	{"meta": "Surah Rahman verse art, modern Arabic calligraphy, Islamic wall decor India, Fabiaayi ala calligraphy, bold thuluth script art, contemporary Islamic frame, black and white calligraphy, divine verse wall painting"}
prod_01K20NP5E8YNZPH57HJ3Y36KJE	Core of Faith | Abstract Circular Calligraphy	core-of-faith-abstract-calligraphy	Divine expression in motion — where every circle returns to the center of belief.	This eye-catching Islamic calligraphy piece blends traditional script with modern design in a circular, layered formation. At the heart lies deep red calligraphy, surrounded by precise black script and intersected by diagonal red streaks — symbolizing strength, depth, and connection. Framed with textured black and red borderwork, this piece is a bold visual of balance between tradition and modern spiritual identity. A perfect fit for artistic living rooms, office walls, or gallery-style interiors.	f	published	http://localhost:9000/static/1754516886785-Frame%205.jpg	\N	\N	28	36	pk			\N	pcol_01K20R62AR9QZM8R9AQKJ2RCH5	\N	t	\N	2025-08-07 02:48:06.986+05	2025-08-07 03:32:48.296+05	\N	{"meta": "abstract Islamic calligraphy, circular Arabic wall art, red and black calligraphy, Quranic abstract artwork, modern Islamic wall frame, spiritual art decor, circular divine name art, Islamic art India"}
prod_01K20PBC8XC5Y4C2GRSJXA97CN	Bismillah Bird | Minimalist Islamic Calligraphy Art	bismillah-bird-calligraphy-islamic-wall-art	A graceful flight of faith — in the name of Allah.	This unique piece features the phrase "Bismillah" (In the name of Allah) artistically shaped into a bird, symbolizing peace, divine guidance, and purity. Its minimalist black-on-white design gives it a modern, airy presence—perfect for serene spaces, meditation corners, or contemporary homes. Hand-drawn details and the natural fluidity of the form reflect both precision and spirituality.	f	published	http://localhost:9000/static/1754517581965-images%20(18).jpg	\N	2	22	18	pk			\N	pcol_01K20M4VF5CYF38YD9XMFMSK3P	\N	t	\N	2025-08-07 02:59:42.111+05	2025-08-07 02:59:42.111+05	\N	{"meta": "bismillah bird calligraphy, minimalist islamic wall art, black and white arabic calligraphy, peace dove quran art, modern muslim decor india, bismillah artwork for home"}
prod_01K20P8MWNR636YWMJ28PZ46DR	Bowl of Barakah | Islamic Calligraphy in Harmony	bowl-of-barakah-islamic-calligraphy-frame	Overflowing with divine verses and graceful symmetry.	This elegant artwork features a bowl-shaped calligraphic form, symbolizing abundance, blessings (barakah), and divine grace. The intricate Arabic script curves upward like a vessel being filled, while structured verses below provide grounding balance. With ornate corner details and a refined black frame, it’s ideal for modern or traditional interiors seeking spiritual depth and artistic elegance.	f	published	http://localhost:9000/static/1754517492447-Frame%204.jpg	\N	2	24	30	pk			\N	pcol_01K20QJP2W99M1SCX97RN2CR45	\N	t	\N	2025-08-07 02:58:12.631+05	2025-08-07 03:21:30.607+05	\N	{"meta": "bowl shaped Islamic calligraphy, Arabic barakah wall art, Quran verse calligraphy frame, Islamic decor India, black and white spiritual frame, handcrafted Muslim artwork"}
\.


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_category (id, name, description, handle, mpath, is_active, is_internal, rank, parent_category_id, created_at, updated_at, deleted_at, metadata) FROM stdin;
pcat_01K20Q6JVBQCFH1NDK8AEY0JS7	Kalima & Tawheed		kalima-&-tawheed	pcat_01K20Q6JVBQCFH1NDK8AEY0JS7	t	f	0	\N	2025-08-07 03:14:33.58+05	2025-08-07 03:14:33.58+05	\N	\N
pcat_01K20Q994XQ9RX4PWYWWVW91M9	Symbolic Forms		symbolic-forms	pcat_01K20Q994XQ9RX4PWYWWVW91M9	t	f	2	\N	2025-08-07 03:16:01.949+05	2025-08-07 03:16:01.949+05	\N	\N
pcat_01K20QBVS0N8SY35QN33AC1420	Rectangular Calligraphy		rectangular-calligraphy	pcat_01K20QBVS0N8SY35QN33AC1420	t	f	4	\N	2025-08-07 03:17:26.561+05	2025-08-07 03:17:26.561+05	\N	\N
pcat_01K20QD9HDG63SNEEDG2FTY85D	Kufic Calligraphy		kufic-calligraphy	pcat_01K20QD9HDG63SNEEDG2FTY85D	t	f	5	\N	2025-08-07 03:18:13.422+05	2025-08-07 03:18:13.422+05	\N	\N
pcat_01K20QE2NJXA13NXREQYT99KT2	Thuluth Calligraphy		thuluth-calligraphy	pcat_01K20QE2NJXA13NXREQYT99KT2	t	f	6	\N	2025-08-07 03:18:39.154+05	2025-08-07 03:18:39.154+05	\N	\N
pcat_01K20Q7PN6EVZ61BNNJ3J00T7A	 Surah & Ayat		surah-ayat	pcat_01K20Q7PN6EVZ61BNNJ3J00T7A	t	f	1	\N	2025-08-07 03:15:10.246+05	2025-08-07 03:22:14.47+05	\N	\N
pcat_01K20QASAY9S12Q0EJQEC7CE37	Circular Calligraphy		circular-calligraphy	pcat_01K20QASAY9S12Q0EJQEC7CE37	t	f	3	\N	2025-08-07 03:16:51.294+05	2025-08-07 03:22:25.031+05	\N	\N
\.


--
-- Data for Name: product_category_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_category_product (product_id, product_category_id) FROM stdin;
prod_01K20MSWN66FHN4MM7XV2VAEQF	pcat_01K20Q6JVBQCFH1NDK8AEY0JS7
prod_01K20MXVNB0960JMW591DED198	pcat_01K20Q6JVBQCFH1NDK8AEY0JS7
prod_01K20N66YRKN0059GVKSCA8PF1	pcat_01K20Q6JVBQCFH1NDK8AEY0JS7
prod_01K20NVK7BHBSQCC3JQ2M0N0K4	pcat_01K20Q6JVBQCFH1NDK8AEY0JS7
prod_01K20NEAT6RMY2NJZX21QKQJPE	pcat_01K20Q7PN6EVZ61BNNJ3J00T7A
prod_01K20NZB8P8TM934QN5Y9K9T1V	pcat_01K20Q7PN6EVZ61BNNJ3J00T7A
prod_01K20P214XX3SXQZZY1QSY4E9T	pcat_01K20Q7PN6EVZ61BNNJ3J00T7A
prod_01K20P4KYNH6ETFQ6ZFK1Q992P	pcat_01K20Q7PN6EVZ61BNNJ3J00T7A
prod_01K20N2J04FX4FP4MHZPKBNCCD	pcat_01K20Q994XQ9RX4PWYWWVW91M9
prod_01K20N9RRW6EF07NP6XE7ND9HH	pcat_01K20Q994XQ9RX4PWYWWVW91M9
prod_01K20P8MWNR636YWMJ28PZ46DR	pcat_01K20Q994XQ9RX4PWYWWVW91M9
prod_01K20PBC8XC5Y4C2GRSJXA97CN	pcat_01K20Q994XQ9RX4PWYWWVW91M9
prod_01K20ME37KW189HXKM3RT1AJMX	pcat_01K20QASAY9S12Q0EJQEC7CE37
prod_01K20NP5E8YNZPH57HJ3Y36KJE	pcat_01K20QASAY9S12Q0EJQEC7CE37
prod_01K20NVK7BHBSQCC3JQ2M0N0K4	pcat_01K20QASAY9S12Q0EJQEC7CE37
prod_01K20P4KYNH6ETFQ6ZFK1Q992P	pcat_01K20QASAY9S12Q0EJQEC7CE37
prod_01K20MSWN66FHN4MM7XV2VAEQF	pcat_01K20QBVS0N8SY35QN33AC1420
prod_01K20MXVNB0960JMW591DED198	pcat_01K20QBVS0N8SY35QN33AC1420
prod_01K20N2J04FX4FP4MHZPKBNCCD	pcat_01K20QBVS0N8SY35QN33AC1420
prod_01K20N66YRKN0059GVKSCA8PF1	pcat_01K20QBVS0N8SY35QN33AC1420
prod_01K20NEAT6RMY2NJZX21QKQJPE	pcat_01K20QBVS0N8SY35QN33AC1420
prod_01K20NZB8P8TM934QN5Y9K9T1V	pcat_01K20QBVS0N8SY35QN33AC1420
prod_01K20P214XX3SXQZZY1QSY4E9T	pcat_01K20QBVS0N8SY35QN33AC1420
prod_01K20MXVNB0960JMW591DED198	pcat_01K20QD9HDG63SNEEDG2FTY85D
prod_01K20N66YRKN0059GVKSCA8PF1	pcat_01K20QD9HDG63SNEEDG2FTY85D
prod_01K20NVK7BHBSQCC3JQ2M0N0K4	pcat_01K20QD9HDG63SNEEDG2FTY85D
prod_01K20ME37KW189HXKM3RT1AJMX	pcat_01K20QE2NJXA13NXREQYT99KT2
prod_01K20MSWN66FHN4MM7XV2VAEQF	pcat_01K20QE2NJXA13NXREQYT99KT2
prod_01K20N2J04FX4FP4MHZPKBNCCD	pcat_01K20QE2NJXA13NXREQYT99KT2
prod_01K20N9RRW6EF07NP6XE7ND9HH	pcat_01K20QE2NJXA13NXREQYT99KT2
prod_01K20NEAT6RMY2NJZX21QKQJPE	pcat_01K20QE2NJXA13NXREQYT99KT2
prod_01K20NJT3YFNZC5G7JM6Y3W20F	pcat_01K20QE2NJXA13NXREQYT99KT2
prod_01K20NP5E8YNZPH57HJ3Y36KJE	pcat_01K20QE2NJXA13NXREQYT99KT2
prod_01K20NZB8P8TM934QN5Y9K9T1V	pcat_01K20QE2NJXA13NXREQYT99KT2
prod_01K20P214XX3SXQZZY1QSY4E9T	pcat_01K20QE2NJXA13NXREQYT99KT2
prod_01K20P4KYNH6ETFQ6ZFK1Q992P	pcat_01K20QE2NJXA13NXREQYT99KT2
prod_01K20P8MWNR636YWMJ28PZ46DR	pcat_01K20QE2NJXA13NXREQYT99KT2
prod_01K20PBC8XC5Y4C2GRSJXA97CN	pcat_01K20QE2NJXA13NXREQYT99KT2
\.


--
-- Data for Name: product_collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_collection (id, title, handle, metadata, created_at, updated_at, deleted_at) FROM stdin;
pcol_01K20M4HR18V0R2R5NFX4QBAHC	Kufic Style	kufic-style	\N	2025-08-07 02:21:01.183737+05	2025-08-07 03:19:33.493+05	2025-08-07 03:19:33.492+05
pcol_01K20M4VF5CYF38YD9XMFMSK3P	Thuluth Style	thuluth-style	\N	2025-08-07 02:21:11.1404+05	2025-08-07 03:19:39.043+05	2025-08-07 03:19:39.043+05
pcol_01K20PZ7EBTYDFJHV1AP9XGAEE	 Circular Calligraphy	-circular-calligraphy	\N	2025-08-07 03:10:32.516601+05	2025-08-07 03:20:00.1+05	2025-08-07 03:20:00.1+05
pcol_01K20Q2632ETFG0AVAXCRAFGQW	Rectangular Calligraphy	Rectangular Calligraphy	\N	2025-08-07 03:12:09.440894+05	2025-08-07 03:20:06.334+05	2025-08-07 03:20:06.334+05
pcol_01K20QJP2W99M1SCX97RN2CR45	Sacred Geometry: The Divine in Design	sacred-geometry	\N	2025-08-07 03:21:10.105124+05	2025-08-07 03:21:10.105124+05	\N
pcol_01K20R62AR9QZM8R9AQKJ2RCH5	popular	popular	\N	2025-08-07 03:31:45.238719+05	2025-08-07 03:31:45.238719+05	\N
\.


--
-- Data for Name: product_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_option (id, title, product_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
opt_01K20ME37QVTY3VNKXSV7T83Z2	Default option	prod_01K20ME37KW189HXKM3RT1AJMX	\N	2025-08-07 02:26:14.009+05	2025-08-07 02:26:14.009+05	\N
opt_01K20MSWN7WGNPEX3TEA5B8PCP	Default option	prod_01K20MSWN66FHN4MM7XV2VAEQF	\N	2025-08-07 02:32:40.489+05	2025-08-07 02:32:40.489+05	\N
opt_01K20MXVNC0BADDRP13T6XA7ZV	Default option	prod_01K20MXVNB0960JMW591DED198	\N	2025-08-07 02:34:50.541+05	2025-08-07 02:34:50.541+05	\N
opt_01K20N2J05KYE6DFG13RNQQM8C	Default option	prod_01K20N2J04FX4FP4MHZPKBNCCD	\N	2025-08-07 02:37:24.486+05	2025-08-07 02:37:24.486+05	\N
opt_01K20N66YSCMT9DC398MWBYACH	Default option	prod_01K20N66YRKN0059GVKSCA8PF1	\N	2025-08-07 02:39:24.25+05	2025-08-07 02:39:24.25+05	\N
opt_01K20N9RRWWXC4SQ0R1PHPZZQ2	Default option	prod_01K20N9RRW6EF07NP6XE7ND9HH	\N	2025-08-07 02:41:20.8+05	2025-08-07 02:41:20.8+05	\N
opt_01K20NEAT76GW8DYEZ7PK5XZRY	Default option	prod_01K20NEAT6RMY2NJZX21QKQJPE	\N	2025-08-07 02:43:50.344+05	2025-08-07 02:43:50.344+05	\N
opt_01K20NJT3Z9RFD28D4Q89XZ23R	Default option	prod_01K20NJT3YFNZC5G7JM6Y3W20F	\N	2025-08-07 02:46:17.088+05	2025-08-07 02:46:17.088+05	\N
opt_01K20NP5E9A1RVRYC2TDWZVX2B	Default option	prod_01K20NP5E8YNZPH57HJ3Y36KJE	\N	2025-08-07 02:48:06.986+05	2025-08-07 02:48:06.986+05	\N
opt_01K20NVK7KRZTXSKGF71JZFM6T	Default option	prod_01K20NVK7BHBSQCC3JQ2M0N0K4	\N	2025-08-07 02:51:04.951+05	2025-08-07 02:51:04.951+05	\N
opt_01K20NZB8Q9J7YJR6H32TW6ZXF	Default option	prod_01K20NZB8P8TM934QN5Y9K9T1V	\N	2025-08-07 02:53:07.864+05	2025-08-07 02:53:07.864+05	\N
opt_01K20P214YZ197H3C4PM6J2E32	Default option	prod_01K20P214XX3SXQZZY1QSY4E9T	\N	2025-08-07 02:54:35.807+05	2025-08-07 02:54:35.807+05	\N
opt_01K20P4KYPF140BQC7JS0Z7HW3	Default option	prod_01K20P4KYNH6ETFQ6ZFK1Q992P	\N	2025-08-07 02:56:00.599+05	2025-08-07 02:56:00.599+05	\N
opt_01K20P8MWP3R4E6GBTTKT2NTH4	Default option	prod_01K20P8MWNR636YWMJ28PZ46DR	\N	2025-08-07 02:58:12.631+05	2025-08-07 02:58:12.631+05	\N
opt_01K20PBC8YMH3SYV4AHB9SV0NM	Default option	prod_01K20PBC8XC5Y4C2GRSJXA97CN	\N	2025-08-07 02:59:42.111+05	2025-08-07 02:59:42.111+05	\N
\.


--
-- Data for Name: product_option_value; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_option_value (id, value, option_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
optval_01K20ME37QW7FFWY65AN02HGHG	Default option value	opt_01K20ME37QVTY3VNKXSV7T83Z2	\N	2025-08-07 02:26:14.009+05	2025-08-07 02:26:14.009+05	\N
optval_01K20MSWN7YFPY2AT9G8BQ221H	Default option value	opt_01K20MSWN7WGNPEX3TEA5B8PCP	\N	2025-08-07 02:32:40.489+05	2025-08-07 02:32:40.489+05	\N
optval_01K20MXVNCYSSE6921E40PTV2B	Default option value	opt_01K20MXVNC0BADDRP13T6XA7ZV	\N	2025-08-07 02:34:50.541+05	2025-08-07 02:34:50.541+05	\N
optval_01K20N2J05T94SPVVHFRNG2RQD	Default option value	opt_01K20N2J05KYE6DFG13RNQQM8C	\N	2025-08-07 02:37:24.486+05	2025-08-07 02:37:24.486+05	\N
optval_01K20N66YS75DMB520Z6MW191M	Default option value	opt_01K20N66YSCMT9DC398MWBYACH	\N	2025-08-07 02:39:24.25+05	2025-08-07 02:39:24.25+05	\N
optval_01K20N9RRWYTR3F53ZKTTCZ15P	Default option value	opt_01K20N9RRWWXC4SQ0R1PHPZZQ2	\N	2025-08-07 02:41:20.8+05	2025-08-07 02:41:20.8+05	\N
optval_01K20NEAT7Z4HKYQ9B4BG066BC	Default option value	opt_01K20NEAT76GW8DYEZ7PK5XZRY	\N	2025-08-07 02:43:50.344+05	2025-08-07 02:43:50.344+05	\N
optval_01K20NJT3Z46CATDPTNXD86MMX	Default option value	opt_01K20NJT3Z9RFD28D4Q89XZ23R	\N	2025-08-07 02:46:17.088+05	2025-08-07 02:46:17.088+05	\N
optval_01K20NP5E8W9WV3C188V2YHPT5	Default option value	opt_01K20NP5E9A1RVRYC2TDWZVX2B	\N	2025-08-07 02:48:06.986+05	2025-08-07 02:48:06.986+05	\N
optval_01K20NVK7J8SVP42VSYAT07R6Z	Default option value	opt_01K20NVK7KRZTXSKGF71JZFM6T	\N	2025-08-07 02:51:04.951+05	2025-08-07 02:51:04.951+05	\N
optval_01K20NZB8Q0TB5TRC1T6VBSWVK	Default option value	opt_01K20NZB8Q9J7YJR6H32TW6ZXF	\N	2025-08-07 02:53:07.864+05	2025-08-07 02:53:07.864+05	\N
optval_01K20P214YRW9HVDYQEB4DE179	Default option value	opt_01K20P214YZ197H3C4PM6J2E32	\N	2025-08-07 02:54:35.807+05	2025-08-07 02:54:35.807+05	\N
optval_01K20P4KYPC7YWHZDT03FTW5ZB	Default option value	opt_01K20P4KYPF140BQC7JS0Z7HW3	\N	2025-08-07 02:56:00.599+05	2025-08-07 02:56:00.599+05	\N
optval_01K20P8MWP70RE1F92MQX2RFWW	Default option value	opt_01K20P8MWP3R4E6GBTTKT2NTH4	\N	2025-08-07 02:58:12.631+05	2025-08-07 02:58:12.631+05	\N
optval_01K20PBC8YF2QCYSX60RT4A5CJ	Default option value	opt_01K20PBC8YMH3SYV4AHB9SV0NM	\N	2025-08-07 02:59:42.111+05	2025-08-07 02:59:42.111+05	\N
\.


--
-- Data for Name: product_sales_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_sales_channel (product_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01JTFS1F7N92JC1FB7RXVBDGAX	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JTFS1F8MM7X40TTWBPQSV6KM	2025-05-05 13:29:45.107575+05	2025-05-25 11:41:57.637+05	2025-05-25 11:41:57.637+05
prod_01JTFS1F7NVX10M8WD2NH9AR9E	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JTFS1F8MGTKJRAF4457S214F	2025-05-05 13:29:45.107575+05	2025-05-25 11:42:00.554+05	2025-05-25 11:42:00.553+05
prod_01JTFS1F7ND353H91JWTB63D2A	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JTFS1F8MZFNNNQVJD6H3FT6P	2025-05-05 13:29:45.107575+05	2025-05-25 11:42:03.667+05	2025-05-25 11:42:03.667+05
prod_01JTFS1F7NKTYE1WZ25QQRYGR7	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JTFS1F8M2Q6QSYRWD4VA91YJ	2025-05-05 13:29:45.107575+05	2025-05-25 11:42:06.47+05	2025-05-25 11:42:06.47+05
prod_01JW33AG1MV23X5B3K8818N3G6	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JW33AG2B8GB4WBAC8793YVF6	2025-05-25 11:50:42.632953+05	2025-05-25 11:50:42.632953+05	\N
prod_01JW357CM44DN7S3KVDAW63ATK	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JW357CMH4ZE1TE4WHPZCD14K	2025-05-25 12:23:57.969047+05	2025-05-25 12:23:57.969047+05	\N
prod_01JW35AS4R62RYYDMXPY4MBC1R	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JW35AS53G448EAN243Z9RH1Z	2025-05-25 12:25:49.090778+05	2025-05-25 12:25:49.090778+05	\N
prod_01JW35DRF20M31YQ5P3BZYKT04	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JW35DRFDB43FK7W1XGGX7PPX	2025-05-25 12:27:26.700802+05	2025-05-25 12:27:26.700802+05	\N
prod_01JW35PNDAW1SQ440T45CWAM9M	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JW35PNDQ47XVB6SXAKQPTCN6	2025-05-25 12:32:18.486762+05	2025-05-25 12:32:18.486762+05	\N
prod_01JW35SNNW5E0GWER4RTA7JPG6	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JW35SNP9RB60ZB5RPACP0Z2V	2025-05-25 12:33:57.064191+05	2025-05-25 12:33:57.064191+05	\N
prod_01JW35WXR4G74T1DX9TDH4R1SX	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JW35WXRHD656GPX4PP0EMY60	2025-05-25 12:35:43.633194+05	2025-05-25 12:35:43.633194+05	\N
prod_01JW35ZJCT8GSQFYQQ3DP52RWM	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JW35ZJD6RT1MQNEVMM9P2GJG	2025-05-25 12:37:10.310429+05	2025-05-25 12:37:10.310429+05	\N
prod_01JW3622A4WESVYM9WF09G35BK	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JW3622AETJ7AZVY486DYC7GJ	2025-05-25 12:38:32.142223+05	2025-05-25 12:38:32.142223+05	\N
prod_01JW36473JBNKTZ1R9PTV947GZ	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JW36473XW34KKJ00BE2D01NR	2025-05-25 12:39:42.589125+05	2025-05-25 12:39:42.589125+05	\N
prod_01JW3671VZ6G1WYRY9MN1WPDRE	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JW3671WBSCXDSAPRJB8DVCM8	2025-05-25 12:41:15.530038+05	2025-05-25 12:41:15.530038+05	\N
prod_01JW369FX8JKG23NN4PJPCNPFS	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JW369FXVBD0FPKF7V84MYBKK	2025-05-25 12:42:35.450693+05	2025-05-25 12:42:35.450693+05	\N
prod_01JW36C8QXPR2BV527EAJXA894	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JW36C8RCHG13J530BYQ53QEX	2025-05-25 12:44:06.411686+05	2025-05-25 12:44:06.411686+05	\N
prod_01JZN7TMEYFEKV0X5D2FN5HTQY	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JZN7TMFSEV0S65NWPV9XETKR	2025-07-08 19:42:51.00078+05	2025-07-08 19:46:25.208+05	2025-07-08 19:46:25.208+05
prod_01JZN8RRE3PE9EWEHQ5WG6ARRP	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	prodsc_01JZN8RREP060ADFPTW5B4CGKR	2025-07-08 19:59:18.102153+05	2025-07-08 19:59:18.102153+05	\N
prod_01K20ME37KW189HXKM3RT1AJMX	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	prodsc_01K20ME38QCPGRT7DXQJKXCRJ1	2025-08-07 02:26:14.039061+05	2025-08-07 02:26:14.039061+05	\N
prod_01K20MSWN66FHN4MM7XV2VAEQF	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	prodsc_01K20MSWNTN2VEJG97AXMG5DC1	2025-08-07 02:32:40.505876+05	2025-08-07 02:32:40.505876+05	\N
prod_01K20MXVNB0960JMW591DED198	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	prodsc_01K20MXVNTG49TQGA82CYDDQGW	2025-08-07 02:34:50.554298+05	2025-08-07 02:34:50.554298+05	\N
prod_01K20N2J04FX4FP4MHZPKBNCCD	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	prodsc_01K20N2J0MTFJR1N0VHPF8ZFC9	2025-08-07 02:37:24.500459+05	2025-08-07 02:37:24.500459+05	\N
prod_01K20N66YRKN0059GVKSCA8PF1	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	prodsc_01K20N66Z45Y21RTJEYCV8DV5R	2025-08-07 02:39:24.260243+05	2025-08-07 02:39:24.260243+05	\N
prod_01K20N9RRW6EF07NP6XE7ND9HH	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	prodsc_01K20N9RSFNJHQ72WV6BFAC9Y8	2025-08-07 02:41:20.814912+05	2025-08-07 02:41:20.814912+05	\N
prod_01K20NEAT6RMY2NJZX21QKQJPE	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	prodsc_01K20NEATNKPPZQ0HQ5E8ZVG2K	2025-08-07 02:43:50.356613+05	2025-08-07 02:43:50.356613+05	\N
prod_01K20NJT3YFNZC5G7JM6Y3W20F	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	prodsc_01K20NJT4E7KKEFXDBA2CYMN7P	2025-08-07 02:46:17.101608+05	2025-08-07 02:46:17.101608+05	\N
prod_01K20NP5E8YNZPH57HJ3Y36KJE	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	prodsc_01K20NP5ENDJXF08M24GG64CC9	2025-08-07 02:48:06.996956+05	2025-08-07 02:48:06.996956+05	\N
prod_01K20NVK7BHBSQCC3JQ2M0N0K4	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	prodsc_01K20NVKAF4H71PHSTDDMPJXG4	2025-08-07 02:51:05.038019+05	2025-08-07 02:51:05.038019+05	\N
prod_01K20NZB8P8TM934QN5Y9K9T1V	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	prodsc_01K20NZB9C4JHZQ6AFFP92B4PD	2025-08-07 02:53:07.883424+05	2025-08-07 02:53:07.883424+05	\N
prod_01K20P214XX3SXQZZY1QSY4E9T	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	prodsc_01K20P215GXW0S9D53B1V97P49	2025-08-07 02:54:35.823916+05	2025-08-07 02:54:35.823916+05	\N
prod_01K20P4KYNH6ETFQ6ZFK1Q992P	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	prodsc_01K20P4KZ71GAAARV7WGXD50NP	2025-08-07 02:56:00.615087+05	2025-08-07 02:56:00.615087+05	\N
prod_01K20P8MWNR636YWMJ28PZ46DR	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	prodsc_01K20P8MX4GKH7RJ9TE90P2AS5	2025-08-07 02:58:12.642772+05	2025-08-07 02:58:12.642772+05	\N
prod_01K20PBC8XC5Y4C2GRSJXA97CN	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	prodsc_01K20PBC9J44MJYT6C45T7X6YN	2025-08-07 02:59:42.129652+05	2025-08-07 02:59:42.129652+05	\N
\.


--
-- Data for Name: product_shipping_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_shipping_profile (product_id, shipping_profile_id, id, created_at, updated_at, deleted_at) FROM stdin;
prod_01JTFS1F7N92JC1FB7RXVBDGAX	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01JTFS1F90W6X4FBKZ8Y4M610B	2025-05-05 13:29:45.119484+05	2025-05-25 11:41:57.64+05	2025-05-25 11:41:57.639+05
prod_01JTFS1F7NVX10M8WD2NH9AR9E	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01JTFS1F907PX45115KX6W3FEY	2025-05-05 13:29:45.119484+05	2025-05-25 11:42:00.562+05	2025-05-25 11:42:00.562+05
prod_01JTFS1F7ND353H91JWTB63D2A	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01JTFS1F8ZZJ20KDSGRMTQGWE6	2025-05-05 13:29:45.119484+05	2025-05-25 11:42:03.666+05	2025-05-25 11:42:03.666+05
prod_01JTFS1F7NKTYE1WZ25QQRYGR7	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01JTFS1F90QQNE8NN19M308B1T	2025-05-05 13:29:45.119484+05	2025-05-25 11:42:06.474+05	2025-05-25 11:42:06.474+05
prod_01JW33AG1MV23X5B3K8818N3G6	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01JW33AG2WN15JS9KMH3K634Z0	2025-05-25 11:50:42.650981+05	2025-05-25 11:50:42.650981+05	\N
prod_01JW357CM44DN7S3KVDAW63ATK	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01JW357CMSPS46ZGJCZ9ZVNBMY	2025-05-25 12:23:57.977668+05	2025-05-25 12:23:57.977668+05	\N
prod_01JW35AS4R62RYYDMXPY4MBC1R	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01JW35AS5AGA7QHKA8SSZ1W3BD	2025-05-25 12:25:49.097113+05	2025-05-25 12:25:49.097113+05	\N
prod_01JW35DRF20M31YQ5P3BZYKT04	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01JW35DRFMCQ8MTEP25VQCJ0MZ	2025-05-25 12:27:26.708227+05	2025-05-25 12:27:26.708227+05	\N
prod_01JW35SNNW5E0GWER4RTA7JPG6	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01JW35SNPGQJX5KHC9CCR00KSE	2025-05-25 12:33:57.07197+05	2025-05-25 12:33:57.07197+05	\N
prod_01JW35WXR4G74T1DX9TDH4R1SX	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01JW35WXRRQ76VBNTHTCYWMV4H	2025-05-25 12:35:43.640113+05	2025-05-25 12:35:43.640113+05	\N
prod_01JW35ZJCT8GSQFYQQ3DP52RWM	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01JW35ZJDDK3EFWZMD75DSMDM3	2025-05-25 12:37:10.317505+05	2025-05-25 12:37:10.317505+05	\N
prod_01JW3622A4WESVYM9WF09G35BK	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01JW3622AMAH8DKKZP1XG4ZHDW	2025-05-25 12:38:32.147733+05	2025-05-25 12:38:32.147733+05	\N
prod_01JW36473JBNKTZ1R9PTV947GZ	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01JW364744KTEH1YF90GX6AT2S	2025-05-25 12:39:42.596396+05	2025-05-25 12:39:42.596396+05	\N
prod_01JW3671VZ6G1WYRY9MN1WPDRE	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01JW3671WHZET29M251H29GXVS	2025-05-25 12:41:15.537019+05	2025-05-25 12:41:15.537019+05	\N
prod_01JW369FX8JKG23NN4PJPCNPFS	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01JW369FY5V5RPGPSBHMC0SVV0	2025-05-25 12:42:35.461301+05	2025-05-25 12:42:35.461301+05	\N
prod_01JW36C8QXPR2BV527EAJXA894	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01JW36C8RNTTNF3BZRFX5VW7Q7	2025-05-25 12:44:06.421348+05	2025-05-25 12:44:06.421348+05	\N
prod_01K20ME37KW189HXKM3RT1AJMX	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01K20ME39BXNKM990ZFPBP0S4C	2025-08-07 02:26:14.05823+05	2025-08-07 02:26:14.05823+05	\N
prod_01K20MSWN66FHN4MM7XV2VAEQF	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01K20MSWP5GSX2BJFQWGMT4KXH	2025-08-07 02:32:40.516904+05	2025-08-07 02:32:40.516904+05	\N
prod_01K20MXVNB0960JMW591DED198	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01K20MXVP5199RCPF707RJMBBG	2025-08-07 02:34:50.565196+05	2025-08-07 02:34:50.565196+05	\N
prod_01K20N2J04FX4FP4MHZPKBNCCD	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01K20N2J0ZTQWVEDBZ11JBB0H7	2025-08-07 02:37:24.510038+05	2025-08-07 02:37:24.510038+05	\N
prod_01K20N66YRKN0059GVKSCA8PF1	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01K20N66ZFXHSWA2FSCYHD2HDM	2025-08-07 02:39:24.270797+05	2025-08-07 02:39:24.270797+05	\N
prod_01K20NEAT6RMY2NJZX21QKQJPE	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01K20NEATY1ZYRF5RCNNV124H0	2025-08-07 02:43:50.366357+05	2025-08-07 02:43:50.366357+05	\N
prod_01K20NJT3YFNZC5G7JM6Y3W20F	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01K20NJT4PPCQZGW8HHPPRXH42	2025-08-07 02:46:17.110596+05	2025-08-07 02:46:17.110596+05	\N
prod_01K20NZB8P8TM934QN5Y9K9T1V	sp_01JTFS18D1GR241A7E99ZD6RJA	prodsp_01K20NZB9PPN0G4J363RKKJ2DW	2025-08-07 02:53:07.894634+05	2025-08-07 02:53:07.894634+05	\N
\.


--
-- Data for Name: product_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_tag (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
ptag_01K20M1JFGC8YP6QBGTZKH6M1R	Shape-based Art	\N	2025-08-07 02:19:23.633+05	2025-08-07 02:19:23.633+05	\N
ptag_01K20M1YZX41YG6AV62710PKK0	Allah & Islamic Names 	\N	2025-08-07 02:19:36.446+05	2025-08-07 02:19:36.446+05	\N
ptag_01K20M28M70NE8W3Q5C5XSXB1P	Verses from Quran	\N	2025-08-07 02:19:46.311+05	2025-08-07 02:19:46.311+05	\N
ptag_01K20M2T9QX46R86ETNVJJ3DH5	Modern/Abstract Calligraphy	\N	2025-08-07 02:20:04.408+05	2025-08-07 02:20:04.408+05	\N
\.


--
-- Data for Name: product_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_tags (product_id, product_tag_id) FROM stdin;
prod_01K20ME37KW189HXKM3RT1AJMX	ptag_01K20M1JFGC8YP6QBGTZKH6M1R
prod_01K20ME37KW189HXKM3RT1AJMX	ptag_01K20M1YZX41YG6AV62710PKK0
prod_01K20MSWN66FHN4MM7XV2VAEQF	ptag_01K20M1YZX41YG6AV62710PKK0
prod_01K20MSWN66FHN4MM7XV2VAEQF	ptag_01K20M28M70NE8W3Q5C5XSXB1P
prod_01K20MXVNB0960JMW591DED198	ptag_01K20M28M70NE8W3Q5C5XSXB1P
prod_01K20N2J04FX4FP4MHZPKBNCCD	ptag_01K20M1JFGC8YP6QBGTZKH6M1R
prod_01K20N66YRKN0059GVKSCA8PF1	ptag_01K20M28M70NE8W3Q5C5XSXB1P
prod_01K20N9RRW6EF07NP6XE7ND9HH	ptag_01K20M1JFGC8YP6QBGTZKH6M1R
prod_01K20NEAT6RMY2NJZX21QKQJPE	ptag_01K20M28M70NE8W3Q5C5XSXB1P
prod_01K20NJT3YFNZC5G7JM6Y3W20F	ptag_01K20M1YZX41YG6AV62710PKK0
prod_01K20NP5E8YNZPH57HJ3Y36KJE	ptag_01K20M1JFGC8YP6QBGTZKH6M1R
prod_01K20NVK7BHBSQCC3JQ2M0N0K4	ptag_01K20M28M70NE8W3Q5C5XSXB1P
prod_01K20NVK7BHBSQCC3JQ2M0N0K4	ptag_01K20M1JFGC8YP6QBGTZKH6M1R
prod_01K20NZB8P8TM934QN5Y9K9T1V	ptag_01K20M2T9QX46R86ETNVJJ3DH5
prod_01K20NZB8P8TM934QN5Y9K9T1V	ptag_01K20M1YZX41YG6AV62710PKK0
prod_01K20P214XX3SXQZZY1QSY4E9T	ptag_01K20M28M70NE8W3Q5C5XSXB1P
prod_01K20P4KYNH6ETFQ6ZFK1Q992P	ptag_01K20M28M70NE8W3Q5C5XSXB1P
prod_01K20P8MWNR636YWMJ28PZ46DR	ptag_01K20M1YZX41YG6AV62710PKK0
prod_01K20P8MWNR636YWMJ28PZ46DR	ptag_01K20M1JFGC8YP6QBGTZKH6M1R
prod_01K20PBC8XC5Y4C2GRSJXA97CN	ptag_01K20M1JFGC8YP6QBGTZKH6M1R
prod_01K20PBC8XC5Y4C2GRSJXA97CN	ptag_01K20M1YZX41YG6AV62710PKK0
prod_01K20PBC8XC5Y4C2GRSJXA97CN	ptag_01K20M28M70NE8W3Q5C5XSXB1P
prod_01K20PBC8XC5Y4C2GRSJXA97CN	ptag_01K20M2T9QX46R86ETNVJJ3DH5
\.


--
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_type (id, value, metadata, created_at, updated_at, deleted_at) FROM stdin;
ptyp_01K20KZNY1J95M83RHVJC8WXZK	Kufic Style 	\N	2025-08-07 02:18:21.633+05	2025-08-07 02:20:42.442+05	2025-08-07 02:20:42.442+05
ptyp_01K20M0R67HJDKAP179SHGCN44	Thuluth Style	\N	2025-08-07 02:18:56.711+05	2025-08-07 02:20:45.377+05	2025-08-07 02:20:45.377+05
\.


--
-- Data for Name: product_variant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant (id, title, sku, barcode, ean, upc, allow_backorder, manage_inventory, hs_code, origin_country, mid_code, material, weight, length, height, width, metadata, variant_rank, product_id, created_at, updated_at, deleted_at) FROM stdin;
variant_01K20ME3A5NMC35YQNZH47V552	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K20ME37KW189HXKM3RT1AJMX	2025-08-07 02:26:14.086+05	2025-08-07 02:26:14.086+05	\N
variant_01K20MSWPMTMGHCP0Q4YBVK3MY	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K20MSWN66FHN4MM7XV2VAEQF	2025-08-07 02:32:40.532+05	2025-08-07 02:32:40.532+05	\N
variant_01K20MXVPXZ4HKCGFVK55Y7KWW	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K20MXVNB0960JMW591DED198	2025-08-07 02:34:50.589+05	2025-08-07 02:34:50.589+05	\N
variant_01K20N2J1PWVZ6NMXZ9JKV8BR5	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K20N2J04FX4FP4MHZPKBNCCD	2025-08-07 02:37:24.535+05	2025-08-07 02:37:24.535+05	\N
variant_01K20N66ZZHFP9XNX4G1K30W0N	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K20N66YRKN0059GVKSCA8PF1	2025-08-07 02:39:24.287+05	2025-08-07 02:39:24.287+05	\N
variant_01K20N9RT3977Q5V8YCX0F3A80	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K20N9RRW6EF07NP6XE7ND9HH	2025-08-07 02:41:20.836+05	2025-08-07 02:41:20.836+05	\N
variant_01K20NEAVGD8GAC8Z5MHNDACG8	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K20NEAT6RMY2NJZX21QKQJPE	2025-08-07 02:43:50.384+05	2025-08-07 02:43:50.384+05	\N
variant_01K20NJT56GFDGQSX5S8R42HMK	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K20NJT3YFNZC5G7JM6Y3W20F	2025-08-07 02:46:17.126+05	2025-08-07 02:46:17.126+05	\N
variant_01K20NP5FF7W4YQ73G24W7AG8S	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K20NP5E8YNZPH57HJ3Y36KJE	2025-08-07 02:48:07.024+05	2025-08-07 02:48:07.024+05	\N
variant_01K20NVKBY55AD28PKVWB9QS27	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K20NVK7BHBSQCC3JQ2M0N0K4	2025-08-07 02:51:05.087+05	2025-08-07 02:51:05.087+05	\N
variant_01K20NZBAFDW1781D1VP208JSR	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K20NZB8P8TM934QN5Y9K9T1V	2025-08-07 02:53:07.919+05	2025-08-07 02:53:07.919+05	\N
variant_01K20P216G19YS09MV53NRNT5T	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K20P214XX3SXQZZY1QSY4E9T	2025-08-07 02:54:35.856+05	2025-08-07 02:54:35.856+05	\N
variant_01K20P4M07FT1E4ZR6201NTCES	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K20P4KYNH6ETFQ6ZFK1Q992P	2025-08-07 02:56:00.648+05	2025-08-07 02:56:00.648+05	\N
variant_01K20P8MXNEDN5M0WWHN89K01V	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K20P8MWNR636YWMJ28PZ46DR	2025-08-07 02:58:12.662+05	2025-08-07 02:58:12.662+05	\N
variant_01K20PBCAA947A72MFW37KNJAF	Default variant	\N	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	prod_01K20PBC8XC5Y4C2GRSJXA97CN	2025-08-07 02:59:42.154+05	2025-08-07 02:59:42.154+05	\N
\.


--
-- Data for Name: product_variant_inventory_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_inventory_item (variant_id, inventory_item_id, id, required_quantity, created_at, updated_at, deleted_at) FROM stdin;
variant_01JTFS1FA495ZH3XN5KMC4DRK0	iitem_01JTFS1FBAFA269V4S51PRNYHS	pvitem_01JTFS1FCA69SW62400BVMB0HF	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:41:57.619+05	2025-05-25 11:41:57.618+05
variant_01JTFS1FA5HV85PGM1XMHXTS8M	iitem_01JTFS1FBBXACDY2W4SMCA4ZVG	pvitem_01JTFS1FCAR9CG3XGE3HGPTNPY	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:41:57.619+05	2025-05-25 11:41:57.618+05
variant_01JTFS1FA5X2B5YD243NCJY3QA	iitem_01JTFS1FBBS966EYCEFTB86YN3	pvitem_01JTFS1FCAZYKYRKYT2Q8N41ZS	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:41:57.619+05	2025-05-25 11:41:57.618+05
variant_01JTFS1FA5G5BTTNTSV5MECGM0	iitem_01JTFS1FBB4B25SXB0K3DW625E	pvitem_01JTFS1FCA0PXWGENS2SA8TNP7	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:41:57.619+05	2025-05-25 11:41:57.618+05
variant_01JTFS1FA4NAF1WJMPYKHQFX3R	iitem_01JTFS1FBADT17ZNS94TB4PZ64	pvitem_01JTFS1FC9CR0N9090VF7A15GS	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:42:00.533+05	2025-05-25 11:42:00.532+05
variant_01JTFS1FA4KAFNEWQ66D4R0JBR	iitem_01JTFS1FBAHX4BNFVSQMSY11RX	pvitem_01JTFS1FC93ZXZ43PZCEVZ3CM2	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:42:00.533+05	2025-05-25 11:42:00.532+05
variant_01JTFS1FA4JRNGR7N6ZN06Z2YF	iitem_01JTFS1FBA7HMR7S4BEVWBN7CB	pvitem_01JTFS1FC9Y8F1QXWHX2ECQHKG	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:42:00.533+05	2025-05-25 11:42:00.532+05
variant_01JTFS1FA45ESS47VD35Q4B7CR	iitem_01JTFS1FBA608HBR1B0E7BXAD2	pvitem_01JTFS1FCAJCEWP651JY2KNDVS	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:42:00.533+05	2025-05-25 11:42:00.532+05
variant_01JTFS1FA1SEJCAC4Y5N8H303A	iitem_01JTFS1FB97MC6C7KZMJCT3561	pvitem_01JTFS1FC8BC7Q95EJQRWNG0PH	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:42:03.647+05	2025-05-25 11:42:03.646+05
variant_01JTFS1FA2E5J0828C2D63PC5Q	iitem_01JTFS1FB975BSSDEZR7KC0AW7	pvitem_01JTFS1FC80Y80QB5W8A0T4C1E	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:42:03.647+05	2025-05-25 11:42:03.646+05
variant_01JTFS1FA248QVZEBENB3BB9EM	iitem_01JTFS1FB9FFBSMB6HJF0XPMNW	pvitem_01JTFS1FC88CBCYJAQ5ZCCZ0RQ	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:42:03.647+05	2025-05-25 11:42:03.646+05
variant_01JTFS1FA3R0KFG1Z4XT73DKYW	iitem_01JTFS1FBAQKS9X5XZHEHBVYE8	pvitem_01JTFS1FC9D7RKVA0018X1RB6B	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:42:03.647+05	2025-05-25 11:42:03.646+05
variant_01JTFS1FA3E4NXMYHQB3SZPC84	iitem_01JTFS1FBAB8XJ7BR6FNFC8M5N	pvitem_01JTFS1FC9V2QXPBPHK0VAKC5N	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:42:03.647+05	2025-05-25 11:42:03.646+05
variant_01JTFS1FA3QJX4MNXT28ZNA8AN	iitem_01JTFS1FBA6CME276H42FPBTAK	pvitem_01JTFS1FC9B99T33Q6ZRPDWQQ2	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:42:03.647+05	2025-05-25 11:42:03.646+05
variant_01JTFS1FA3PXM18ZW40TTQ99W6	iitem_01JTFS1FBANW8JBB68VM43SA7K	pvitem_01JTFS1FC989KTKXJ2H4RSYDB9	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:42:03.647+05	2025-05-25 11:42:03.646+05
variant_01JTFS1FA4E5W0JNKF6326F1DH	iitem_01JTFS1FBA8MJXDK453XT4ZEF6	pvitem_01JTFS1FC91B2Y92CT6840TMA2	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:42:03.647+05	2025-05-25 11:42:03.646+05
variant_01JTFS1FA5PG52SHMW7859S886	iitem_01JTFS1FBB6FC739WAPR6FX7AZ	pvitem_01JTFS1FCADVJX1ZVA91GEN2NM	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:42:06.457+05	2025-05-25 11:42:06.457+05
variant_01JTFS1FA5838NKMV5YFNXTXER	iitem_01JTFS1FBB41EH8FH619XKGRMM	pvitem_01JTFS1FCAGBCKH7N070NQ2EGZ	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:42:06.457+05	2025-05-25 11:42:06.457+05
variant_01JTFS1FA5BFKA0KE2NBG8GABE	iitem_01JTFS1FBBJBK0QHC8QHK17ZGQ	pvitem_01JTFS1FCA9T847KTHDE2W42CP	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:42:06.457+05	2025-05-25 11:42:06.457+05
variant_01JTFS1FA6ESJKMD5WT5FKXS3Q	iitem_01JTFS1FBB7F521DGAYP7JESJM	pvitem_01JTFS1FCA4F4PGCWMMS6VXFXW	1	2025-05-05 13:29:45.223513+05	2025-05-25 11:42:06.457+05	2025-05-25 11:42:06.457+05
\.


--
-- Data for Name: product_variant_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_option (variant_id, option_value_id) FROM stdin;
variant_01K20ME3A5NMC35YQNZH47V552	optval_01K20ME37QW7FFWY65AN02HGHG
variant_01K20MSWPMTMGHCP0Q4YBVK3MY	optval_01K20MSWN7YFPY2AT9G8BQ221H
variant_01K20MXVPXZ4HKCGFVK55Y7KWW	optval_01K20MXVNCYSSE6921E40PTV2B
variant_01K20N2J1PWVZ6NMXZ9JKV8BR5	optval_01K20N2J05T94SPVVHFRNG2RQD
variant_01K20N66ZZHFP9XNX4G1K30W0N	optval_01K20N66YS75DMB520Z6MW191M
variant_01K20N9RT3977Q5V8YCX0F3A80	optval_01K20N9RRWYTR3F53ZKTTCZ15P
variant_01K20NEAVGD8GAC8Z5MHNDACG8	optval_01K20NEAT7Z4HKYQ9B4BG066BC
variant_01K20NJT56GFDGQSX5S8R42HMK	optval_01K20NJT3Z46CATDPTNXD86MMX
variant_01K20NP5FF7W4YQ73G24W7AG8S	optval_01K20NP5E8W9WV3C188V2YHPT5
variant_01K20NVKBY55AD28PKVWB9QS27	optval_01K20NVK7J8SVP42VSYAT07R6Z
variant_01K20NZBAFDW1781D1VP208JSR	optval_01K20NZB8Q0TB5TRC1T6VBSWVK
variant_01K20P216G19YS09MV53NRNT5T	optval_01K20P214YRW9HVDYQEB4DE179
variant_01K20P4M07FT1E4ZR6201NTCES	optval_01K20P4KYPC7YWHZDT03FTW5ZB
variant_01K20P8MXNEDN5M0WWHN89K01V	optval_01K20P8MWP70RE1F92MQX2RFWW
variant_01K20PBCAA947A72MFW37KNJAF	optval_01K20PBC8YF2QCYSX60RT4A5CJ
\.


--
-- Data for Name: product_variant_price_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_variant_price_set (variant_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
variant_01JTFS1FA495ZH3XN5KMC4DRK0	pset_01JTFS1FCTATFF2Z4WSXT2TZAJ	pvps_01JTFS1FE1KNKHE820DK68GAKM	2025-05-05 13:29:45.279477+05	2025-05-25 11:41:57.636+05	2025-05-25 11:41:57.635+05
variant_01JTFS1FA5HV85PGM1XMHXTS8M	pset_01JTFS1FCV7E6FDRHSCJNH55CR	pvps_01JTFS1FE160SV2P27P9SAP2D7	2025-05-05 13:29:45.279477+05	2025-05-25 11:41:57.636+05	2025-05-25 11:41:57.635+05
variant_01JTFS1FA5X2B5YD243NCJY3QA	pset_01JTFS1FCVK6Z6R6MEAKQV2FFJ	pvps_01JTFS1FE1ZMPW4VVC04AN0Y71	2025-05-05 13:29:45.279477+05	2025-05-25 11:41:57.636+05	2025-05-25 11:41:57.635+05
variant_01JTFS1FA5G5BTTNTSV5MECGM0	pset_01JTFS1FCVZ3PEQN3FEQ4E1FKR	pvps_01JTFS1FE1Q6FKNR2CC1A7X185	2025-05-05 13:29:45.279477+05	2025-05-25 11:41:57.636+05	2025-05-25 11:41:57.635+05
variant_01JTFS1FA4NAF1WJMPYKHQFX3R	pset_01JTFS1FCSNPEMDF4XQ4Z6ZY9G	pvps_01JTFS1FE14W2WR3X24D70C72K	2025-05-05 13:29:45.279477+05	2025-05-25 11:42:00.556+05	2025-05-25 11:42:00.556+05
variant_01JTFS1FA4KAFNEWQ66D4R0JBR	pset_01JTFS1FCSDDFW82ZGBGTTTD5H	pvps_01JTFS1FE1MM21JVX7EQ5A6AX6	2025-05-05 13:29:45.279477+05	2025-05-25 11:42:00.556+05	2025-05-25 11:42:00.556+05
variant_01JTFS1FA4JRNGR7N6ZN06Z2YF	pset_01JTFS1FCTHNC01RBGDK1D6WP3	pvps_01JTFS1FE1QR5A5VB3PK2GCF94	2025-05-05 13:29:45.279477+05	2025-05-25 11:42:00.556+05	2025-05-25 11:42:00.556+05
variant_01JTFS1FA45ESS47VD35Q4B7CR	pset_01JTFS1FCT4SZ0F9KY5GSKB2AK	pvps_01JTFS1FE198MGTRZ64WBREC0E	2025-05-05 13:29:45.279477+05	2025-05-25 11:42:00.556+05	2025-05-25 11:42:00.556+05
variant_01JTFS1FA1SEJCAC4Y5N8H303A	pset_01JTFS1FCP0HA8DNR9FDJR19CB	pvps_01JTFS1FDZBQFRZFRJ1XXJ61WX	2025-05-05 13:29:45.279477+05	2025-05-25 11:42:03.661+05	2025-05-25 11:42:03.659+05
variant_01JTFS1FA2E5J0828C2D63PC5Q	pset_01JTFS1FCQA963QW0GDE5THJF4	pvps_01JTFS1FE0JDWK55SGKK6ZE5VQ	2025-05-05 13:29:45.279477+05	2025-05-25 11:42:03.661+05	2025-05-25 11:42:03.659+05
variant_01JTFS1FA248QVZEBENB3BB9EM	pset_01JTFS1FCQSVT6PXQE5HBCZ4Z9	pvps_01JTFS1FE0PEEW58VE86XQHEJ7	2025-05-05 13:29:45.279477+05	2025-05-25 11:42:03.661+05	2025-05-25 11:42:03.659+05
variant_01JTFS1FA3R0KFG1Z4XT73DKYW	pset_01JTFS1FCQ1SHVWHQVGBRVE5QA	pvps_01JTFS1FE03S58ZBFDF4EEBEAY	2025-05-05 13:29:45.279477+05	2025-05-25 11:42:03.661+05	2025-05-25 11:42:03.659+05
variant_01JTFS1FA3E4NXMYHQB3SZPC84	pset_01JTFS1FCQN82M7A7SA4M6FR4S	pvps_01JTFS1FE074YQ9MVP1CSQY0NQ	2025-05-05 13:29:45.279477+05	2025-05-25 11:42:03.661+05	2025-05-25 11:42:03.659+05
variant_01JTFS1FA3QJX4MNXT28ZNA8AN	pset_01JTFS1FCR10DGEQH4YV3Q6QA1	pvps_01JTFS1FE0P15NWA6S2G6RE0VE	2025-05-05 13:29:45.279477+05	2025-05-25 11:42:03.661+05	2025-05-25 11:42:03.659+05
variant_01JTFS1FA3PXM18ZW40TTQ99W6	pset_01JTFS1FCR84DXK5S4YZWXN2ZH	pvps_01JTFS1FE1WYJY67GPGR65VF1G	2025-05-05 13:29:45.279477+05	2025-05-25 11:42:03.661+05	2025-05-25 11:42:03.659+05
variant_01JTFS1FA4E5W0JNKF6326F1DH	pset_01JTFS1FCRDKQYJ752PP7V51HD	pvps_01JTFS1FE14HZZQF67Q25BXPGK	2025-05-05 13:29:45.279477+05	2025-05-25 11:42:03.661+05	2025-05-25 11:42:03.659+05
variant_01JTFS1FA5PG52SHMW7859S886	pset_01JTFS1FCWP485XDTNP7EGE998	pvps_01JTFS1FE13854V0KEMYX9YYPW	2025-05-05 13:29:45.279477+05	2025-05-25 11:42:06.47+05	2025-05-25 11:42:06.47+05
variant_01JTFS1FA5838NKMV5YFNXTXER	pset_01JTFS1FCWSS1MPYN1MMEF6X7B	pvps_01JTFS1FE2Q7DMYF9PQAMCJ7FB	2025-05-05 13:29:45.279477+05	2025-05-25 11:42:06.47+05	2025-05-25 11:42:06.47+05
variant_01JTFS1FA5BFKA0KE2NBG8GABE	pset_01JTFS1FCWFXRCZG5FMKZGDBEG	pvps_01JTFS1FE2K80F72ESAJRQT9BB	2025-05-05 13:29:45.279477+05	2025-05-25 11:42:06.47+05	2025-05-25 11:42:06.47+05
variant_01JTFS1FA6ESJKMD5WT5FKXS3Q	pset_01JTFS1FCWQ305FYMNNTE8H818	pvps_01JTFS1FE2MZ143H2RDXRPKPBQ	2025-05-05 13:29:45.279477+05	2025-05-25 11:42:06.47+05	2025-05-25 11:42:06.47+05
variant_01JW33AG3D8T5GJA0KHKTZ3T1A	pset_01JW33AG49BBC7FXTQSF4FE9XD	pvps_01JW33AG4Y0SJCEAHTAEHN5GMK	2025-05-25 11:50:42.717868+05	2025-05-25 11:50:42.717868+05	\N
variant_01JW357CN6V2Y2134K8HG9BJZY	pset_01JW357CNQWFQMF3BBBXK3KSGW	pvps_01JW357CPG7SP77C3BQKDKPM08	2025-05-25 12:23:58.031882+05	2025-05-25 12:23:58.031882+05	\N
variant_01JW35AS5PN4Y71CS0F7VPJ6M7	pset_01JW35AS6BXTZT9BTG53NKXA44	pvps_01JW35AS6TGV35JXQGYMSWE2HW	2025-05-25 12:25:49.145907+05	2025-05-25 12:25:49.145907+05	\N
variant_01JW35DRG2R1RQSKPMH10TEVQF	pset_01JW35DRGP7Y1M2CFP1GETGN8N	pvps_01JW35DRH7B0P06PC1FXA1M6AX	2025-05-25 12:27:26.759404+05	2025-05-25 12:27:26.759404+05	\N
variant_01JW35PNE70GCCDXZM881K74GN	pset_01JW35PNEYVAGDH47A6FBA8EWB	pvps_01JW35PNFKXZ14Q4JGYN7YA4KA	2025-05-25 12:32:18.547236+05	2025-05-25 12:32:18.547236+05	\N
variant_01JW35SNQ1P5NKACZ5YGZ9XEV0	pset_01JW35SNQK2H16KT9NT8A12HVY	pvps_01JW35SNR5PZBY4V2RN4NV1QCQ	2025-05-25 12:33:57.124978+05	2025-05-25 12:33:57.124978+05	\N
variant_01JW35WXS60F0FXQ6F8B9F451C	pset_01JW35WXSK2KF7AWJZ2HS2W248	pvps_01JW35WXT2MEV6NT8WTVN1T3AG	2025-05-25 12:35:43.682043+05	2025-05-25 12:35:43.682043+05	\N
variant_01JW35ZJDXBVFPYCNF9HT1GNPB	pset_01JW35ZJEKHTPVEEQH7PAEF579	pvps_01JW35ZJF7ABBP7CY7NF02TTKG	2025-05-25 12:37:10.375108+05	2025-05-25 12:37:10.375108+05	\N
variant_01JW3622AZXQF7RBGK85A0SH16	pset_01JW3622BFD95BF62A4D6SZ1KG	pvps_01JW3622BY951GER9MK3EXF977	2025-05-25 12:38:32.190396+05	2025-05-25 12:38:32.190396+05	\N
variant_01JW36474KEKSMJNDWKN1Y39QR	pset_01JW364753KJDSB7PAWXYBPBC5	pvps_01JW36475JSR7B3BDD025S9645	2025-05-25 12:39:42.641801+05	2025-05-25 12:39:42.641801+05	\N
variant_01JW3671WWZA716DAVFBEEXVCX	pset_01JW3671XGZ014CYG6VDSC3KBD	pvps_01JW3671YPDV1QMCJGJTD1XA1S	2025-05-25 12:41:15.606271+05	2025-05-25 12:41:15.606271+05	\N
variant_01JW369FYN6MHBB3935K5W3XEF	pset_01JW369FZ8M9V1Q833XFDCC45W	pvps_01JW369FZRAV68RQA6CKBT2YSV	2025-05-25 12:42:35.512142+05	2025-05-25 12:42:35.512142+05	\N
variant_01JW36C8S6A5420PYC89DNA9H0	pset_01JW36C8SWNE1PGTQEHQ8VBK6H	pvps_01JW36C8TM99M1G9WDQ0V2FXH7	2025-05-25 12:44:06.48457+05	2025-05-25 12:44:06.48457+05	\N
variant_01JZN7TMGRAQZ1NW23DBFBCEV7	pset_01JZN7TMHNE8Z61HZSXQ4N6PZN	pvps_01JZN7TMJBHFCW9NH8NFZA38EZ	2025-07-08 19:42:51.082751+05	2025-07-08 19:46:25.202+05	2025-07-08 19:46:25.202+05
variant_01JZN8RRF9KWY85E674FMFCK4E	pset_01JZN8RRFX6Y7ZQPF938BT6QFS	pvps_01JZN8RRGJ9BJ6NEVMA9D5FSRD	2025-07-08 19:59:18.158607+05	2025-07-08 19:59:18.158607+05	\N
variant_01K20ME3A5NMC35YQNZH47V552	pset_01K20ME3B2HC04AEJF3P9NE3JQ	pvps_01K20ME3C3JS8G5JAVK8NYKBVT	2025-08-07 02:26:14.147416+05	2025-08-07 02:26:14.147416+05	\N
variant_01K20MSWPMTMGHCP0Q4YBVK3MY	pset_01K20MSWQFFPWCSGXW7HKQM56W	pvps_01K20MSWQYCFEPVDFPSJD06JSF	2025-08-07 02:32:40.573829+05	2025-08-07 02:32:40.573829+05	\N
variant_01K20MXVPXZ4HKCGFVK55Y7KWW	pset_01K20MXVQWN0TV6F500JT2SBGZ	pvps_01K20MXVRKZVJMD1DQNJXP7EEC	2025-08-07 02:34:50.64363+05	2025-08-07 02:34:50.64363+05	\N
variant_01K20N2J1PWVZ6NMXZ9JKV8BR5	pset_01K20N2J2QSKNCTXDFXZMNG82H	pvps_01K20N2J3KTW2RTPY589Y0MCEB	2025-08-07 02:37:24.594735+05	2025-08-07 02:37:24.594735+05	\N
variant_01K20N66ZZHFP9XNX4G1K30W0N	pset_01K20N670YKSM51Q4MZBQMA979	pvps_01K20N671KPW5DBMX83YBYBT2S	2025-08-07 02:39:24.338231+05	2025-08-07 02:39:24.338231+05	\N
variant_01K20N9RT3977Q5V8YCX0F3A80	pset_01K20N9RTXRRPZDYV8ZFG4DH1A	pvps_01K20N9RVF1534J12DNZ1VXK7F	2025-08-07 02:41:20.879221+05	2025-08-07 02:41:20.879221+05	\N
variant_01K20NEAVGD8GAC8Z5MHNDACG8	pset_01K20NEAWFY12Z92QSMZ04Z6YZ	pvps_01K20NEAX1CMD2A50487FVRH4M	2025-08-07 02:43:50.432728+05	2025-08-07 02:43:50.432728+05	\N
variant_01K20NJT56GFDGQSX5S8R42HMK	pset_01K20NJT5VBF2WX1KNM1TA9TBQ	pvps_01K20NJT6CZ1JA3BT5AK2CQRCC	2025-08-07 02:46:17.163802+05	2025-08-07 02:46:17.163802+05	\N
variant_01K20NP5FF7W4YQ73G24W7AG8S	pset_01K20NP5G5S2RGD029TKNWSPV1	pvps_01K20NP5GMW1MDN07PSNQZ9G2S	2025-08-07 02:48:07.060076+05	2025-08-07 02:48:07.060076+05	\N
variant_01K20NVKBY55AD28PKVWB9QS27	pset_01K20NVKDSE6W1XBKVZ2TTPSRT	pvps_01K20NVKEJ0NZNYA11P8B5P3C3	2025-08-07 02:51:05.169896+05	2025-08-07 02:51:05.169896+05	\N
variant_01K20NZBAFDW1781D1VP208JSR	pset_01K20NZBBHG5D1M3167QSFZEZV	pvps_01K20NZBDFJHT90AVKMXNQGZ4P	2025-08-07 02:53:08.010341+05	2025-08-07 02:53:08.010341+05	\N
variant_01K20P216G19YS09MV53NRNT5T	pset_01K20P217M98G790SZKH8X2PMK	pvps_01K20P218D9ENKKW0ZG9V5P3F3	2025-08-07 02:54:35.916778+05	2025-08-07 02:54:35.916778+05	\N
variant_01K20P4M07FT1E4ZR6201NTCES	pset_01K20P4M223P6CVB0F0BPCD9HS	pvps_01K20P4M33R051EK3K3TN8XVEG	2025-08-07 02:56:00.738352+05	2025-08-07 02:56:00.738352+05	\N
variant_01K20P8MXNEDN5M0WWHN89K01V	pset_01K20P8MZ4YB3EDTTT4SC2NCTS	pvps_01K20P8MZZCTP6YMCG2BEAZFQX	2025-08-07 02:58:12.734674+05	2025-08-07 02:58:12.734674+05	\N
variant_01K20PBCAA947A72MFW37KNJAF	pset_01K20PBCB1PFS7ZZAQNNW9PS3N	pvps_01K20PBCC2W17V43NSEK2MXKFT	2025-08-07 02:59:42.209258+05	2025-08-07 02:59:42.209258+05	\N
\.


--
-- Data for Name: promotion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion (id, code, campaign_id, is_automatic, type, created_at, updated_at, deleted_at, status) FROM stdin;
\.


--
-- Data for Name: promotion_application_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_application_method (id, value, raw_value, max_quantity, apply_to_quantity, buy_rules_min_quantity, type, target_type, allocation, promotion_id, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- Data for Name: promotion_campaign; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_campaign (id, name, description, campaign_identifier, starts_at, ends_at, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_campaign_budget; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_campaign_budget (id, type, campaign_id, "limit", raw_limit, used, raw_used, created_at, updated_at, deleted_at, currency_code) FROM stdin;
\.


--
-- Data for Name: promotion_promotion_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_promotion_rule (promotion_id, promotion_rule_id) FROM stdin;
\.


--
-- Data for Name: promotion_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_rule (id, description, attribute, operator, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: promotion_rule_value; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotion_rule_value (id, promotion_rule_id, value, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: provider_identity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provider_identity (id, entity_id, provider, auth_identity_id, user_metadata, provider_metadata, created_at, updated_at, deleted_at) FROM stdin;
01JTFTSK2TY99P461JRDB1RSGJ	ibrahimkhurram404@gmail.com	emailpass	authid_01JTFTSK2TGTYJNFP6BH5VR91B	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAUw6xifQ9Z501TXY3MhV2Vv4OgK4N5fTXbj+q2vNBl8wJUg+rRaC95WLN3UUCfSioOXLvyhbEr4Reei/tyF4Hish6Lb8IYwzM6281pxGD1H/"}	2025-05-05 14:00:24.027+05	2025-05-05 14:00:24.027+05	\N
01JTFTW5G28X63BKRWGT16VEY7	ibrahimkhurram407@gmail.com	emailpass	authid_01JTFTW5G2EX6WKY9MGZK547R2	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAdv0wJ6ZquAWqGxhXMhntJq0BQjrZzRG054hOj5Znonwkv1ll6SoHL4nrjZg7goE1NsrYbfAPj04yNxEFgtvMBNZZ/NKWrn/jyRxzT8h7Xyu"}	2025-05-05 14:01:48.419+05	2025-05-05 14:01:48.419+05	\N
01JTFTZYAJSAZA3RJ5QABKHJD9	abdulhadi@gmail.com	emailpass	authid_01JTFTZYAK34DAAF2QNN0BE9S0	\N	{"password": "c2NyeXB0AA8AAAAIAAAAASOMoW/vEWBEkDI2+hW9aS5h2Ji+IPz8mcJ70/y5HG5eyoInFgIEruHpkUXRArda3Yk16n900xQm41/w7P5FMuJkCPHZl+ePXbP0CYQYQX/J"}	2025-05-05 14:03:52.147+05	2025-05-05 14:03:52.147+05	\N
01JTFV0E215P05QDVP5AB3W4VE	hassannaveed@gmail.com	emailpass	authid_01JTFV0E22JZYW96MK4A4M9JK6	\N	{"password": "c2NyeXB0AA8AAAAIAAAAASf27qbRH4riv7oS4ABOAL7+VYimW0FjWS//4G3Fn6roXz/q+298trtyzrzwGhMdG6+Wnob2U17euwo0mSv5dAnSQ7AjFyhGm8tpmMDtjqN9"}	2025-05-05 14:04:08.259+05	2025-05-05 14:04:08.259+05	\N
01JTGV2SV32KCBNN4VK0HF2V6B	ibrahimkhurram401@gmail.com	emailpass	authid_01JTGV2SV3NEZHNSCCGHQGE1MQ	\N	{"password": "c2NyeXB0AA8AAAAIAAAAARmnrjGoyQkcLpoLhIO9qrDoFnW/gSZFvVHw6t+21kzXb2BtdVqMz8uwEhfkfFvqBjLecCjiMnuSF+EWi9OihzHbNuZD5+n5ecoci05eO175"}	2025-05-05 23:24:40.292+05	2025-05-05 23:24:40.292+05	\N
01JZ5JHJ4VTHHJXW0YJE2YK8AP	ebadahmed774@gmail.com	emailpass	authid_01JZ5JHJ4V1EVMQ0BF1B42QJDX	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAYBjAg1gY6+kOsP4rdO/rKQRzmGoyhc//pHdzC0HqAIsn6pt6kcP5WrqgQ5/b0G2siauyX5qeUDkWPTN3mGMhbmkRbxOB1uQ8r3EIudG7VWF"}	2025-07-02 17:42:17.117+05	2025-07-02 17:42:17.117+05	\N
01JZSV63GA0MQDNA3VZ58Z5N1Z	huzaifakhurram523@gmail.com	emailpass	authid_01JZSV63GA6E7QBQSKBKF1JNVP	\N	{"password": "c2NyeXB0AA8AAAAIAAAAAUS4Ird4sKbC6EPiPStBkV3dsvNlOKfO3MT2Xj1BPEpyBcypSGhu21TSECe4TgjJp1Skybn9m8FeLupg8fmyMsjfeQLcVLoZRjeiJGp2AdDY"}	2025-07-10 14:38:07.505+05	2025-07-10 14:38:07.505+05	\N
\.


--
-- Data for Name: publishable_api_key_sales_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.publishable_api_key_sales_channel (publishable_key_id, sales_channel_id, id, created_at, updated_at, deleted_at) FROM stdin;
apk_01JTFS1F6CHJT7DB4RKPSGDCQ1	sc_01JTFS1BVSG3Z3KGXH5162ZD2B	pksc_01JTFS1F6MD4AN69EPBBC1GBDF	2025-05-05 13:29:45.044096+05	2025-05-05 13:29:45.044096+05	\N
apk_01K20FXD7GQTHS62DAY44H84M1	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	pksc_01K20PTGGD72PWYY4D1JDGVZ3B	2025-08-07 03:07:57.964334+05	2025-08-07 03:07:57.964334+05	\N
\.


--
-- Data for Name: refund; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refund (id, amount, raw_amount, payment_id, created_at, updated_at, deleted_at, created_by, metadata, refund_reason_id, note) FROM stdin;
\.


--
-- Data for Name: refund_reason; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refund_reason (id, label, description, metadata, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region (id, name, currency_code, metadata, created_at, updated_at, deleted_at, automatic_taxes) FROM stdin;
reg_01K20KE9PH6XVMM3SQKCMNR5EE	Coverage	pkr	\N	2025-08-07 02:08:52.063+05	2025-08-07 02:10:54.192+05	\N	t
\.


--
-- Data for Name: region_country; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region_country (iso_2, iso_3, num_code, name, display_name, region_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
af	afg	004	AFGHANISTAN	Afghanistan	\N	\N	2025-08-07 00:53:39.459+05	2025-08-07 00:53:39.459+05	\N
al	alb	008	ALBANIA	Albania	\N	\N	2025-08-07 00:53:39.46+05	2025-08-07 00:53:39.46+05	\N
dz	dza	012	ALGERIA	Algeria	\N	\N	2025-08-07 00:53:39.46+05	2025-08-07 00:53:39.46+05	\N
as	asm	016	AMERICAN SAMOA	American Samoa	\N	\N	2025-08-07 00:53:39.46+05	2025-08-07 00:53:39.46+05	\N
ad	and	020	ANDORRA	Andorra	\N	\N	2025-08-07 00:53:39.46+05	2025-08-07 00:53:39.46+05	\N
ao	ago	024	ANGOLA	Angola	\N	\N	2025-08-07 00:53:39.46+05	2025-08-07 00:53:39.46+05	\N
ai	aia	660	ANGUILLA	Anguilla	\N	\N	2025-08-07 00:53:39.46+05	2025-08-07 00:53:39.46+05	\N
aq	ata	010	ANTARCTICA	Antarctica	\N	\N	2025-08-07 00:53:39.46+05	2025-08-07 00:53:39.46+05	\N
ag	atg	028	ANTIGUA AND BARBUDA	Antigua and Barbuda	\N	\N	2025-08-07 00:53:39.46+05	2025-08-07 00:53:39.46+05	\N
ar	arg	032	ARGENTINA	Argentina	\N	\N	2025-08-07 00:53:39.46+05	2025-08-07 00:53:39.46+05	\N
am	arm	051	ARMENIA	Armenia	\N	\N	2025-08-07 00:53:39.46+05	2025-08-07 00:53:39.46+05	\N
aw	abw	533	ARUBA	Aruba	\N	\N	2025-08-07 00:53:39.46+05	2025-08-07 00:53:39.46+05	\N
au	aus	036	AUSTRALIA	Australia	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
at	aut	040	AUSTRIA	Austria	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
az	aze	031	AZERBAIJAN	Azerbaijan	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
bs	bhs	044	BAHAMAS	Bahamas	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
bh	bhr	048	BAHRAIN	Bahrain	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
bb	brb	052	BARBADOS	Barbados	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
by	blr	112	BELARUS	Belarus	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
be	bel	056	BELGIUM	Belgium	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
bz	blz	084	BELIZE	Belize	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
bj	ben	204	BENIN	Benin	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
bm	bmu	060	BERMUDA	Bermuda	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
bt	btn	064	BHUTAN	Bhutan	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
bo	bol	068	BOLIVIA	Bolivia	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
bq	bes	535	BONAIRE, SINT EUSTATIUS AND SABA	Bonaire, Sint Eustatius and Saba	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
ba	bih	070	BOSNIA AND HERZEGOVINA	Bosnia and Herzegovina	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
bw	bwa	072	BOTSWANA	Botswana	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
bv	bvd	074	BOUVET ISLAND	Bouvet Island	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
br	bra	076	BRAZIL	Brazil	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
io	iot	086	BRITISH INDIAN OCEAN TERRITORY	British Indian Ocean Territory	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
bn	brn	096	BRUNEI DARUSSALAM	Brunei Darussalam	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
bg	bgr	100	BULGARIA	Bulgaria	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
bf	bfa	854	BURKINA FASO	Burkina Faso	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
bi	bdi	108	BURUNDI	Burundi	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
kh	khm	116	CAMBODIA	Cambodia	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
cm	cmr	120	CAMEROON	Cameroon	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
ca	can	124	CANADA	Canada	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
cv	cpv	132	CAPE VERDE	Cape Verde	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
ky	cym	136	CAYMAN ISLANDS	Cayman Islands	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
cf	caf	140	CENTRAL AFRICAN REPUBLIC	Central African Republic	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
td	tcd	148	CHAD	Chad	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
cl	chl	152	CHILE	Chile	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
cn	chn	156	CHINA	China	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
cx	cxr	162	CHRISTMAS ISLAND	Christmas Island	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
cc	cck	166	COCOS (KEELING) ISLANDS	Cocos (Keeling) Islands	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
co	col	170	COLOMBIA	Colombia	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
km	com	174	COMOROS	Comoros	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
cg	cog	178	CONGO	Congo	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
cd	cod	180	CONGO, THE DEMOCRATIC REPUBLIC OF THE	Congo, the Democratic Republic of the	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
ck	cok	184	COOK ISLANDS	Cook Islands	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
cr	cri	188	COSTA RICA	Costa Rica	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
ci	civ	384	COTE D'IVOIRE	Cote D'Ivoire	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
hr	hrv	191	CROATIA	Croatia	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
cu	cub	192	CUBA	Cuba	\N	\N	2025-08-07 00:53:39.461+05	2025-08-07 00:53:39.461+05	\N
cw	cuw	531	CURAÇAO	Curaçao	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
cy	cyp	196	CYPRUS	Cyprus	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
cz	cze	203	CZECH REPUBLIC	Czech Republic	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
dk	dnk	208	DENMARK	Denmark	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
dj	dji	262	DJIBOUTI	Djibouti	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
dm	dma	212	DOMINICA	Dominica	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
do	dom	214	DOMINICAN REPUBLIC	Dominican Republic	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
ec	ecu	218	ECUADOR	Ecuador	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
eg	egy	818	EGYPT	Egypt	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
sv	slv	222	EL SALVADOR	El Salvador	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
gq	gnq	226	EQUATORIAL GUINEA	Equatorial Guinea	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
er	eri	232	ERITREA	Eritrea	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
ee	est	233	ESTONIA	Estonia	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
et	eth	231	ETHIOPIA	Ethiopia	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
fk	flk	238	FALKLAND ISLANDS (MALVINAS)	Falkland Islands (Malvinas)	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
fo	fro	234	FAROE ISLANDS	Faroe Islands	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
fj	fji	242	FIJI	Fiji	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
fi	fin	246	FINLAND	Finland	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
fr	fra	250	FRANCE	France	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
gf	guf	254	FRENCH GUIANA	French Guiana	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
pf	pyf	258	FRENCH POLYNESIA	French Polynesia	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
tf	atf	260	FRENCH SOUTHERN TERRITORIES	French Southern Territories	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
ga	gab	266	GABON	Gabon	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
gm	gmb	270	GAMBIA	Gambia	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
ge	geo	268	GEORGIA	Georgia	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
de	deu	276	GERMANY	Germany	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
gh	gha	288	GHANA	Ghana	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
gi	gib	292	GIBRALTAR	Gibraltar	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
gr	grc	300	GREECE	Greece	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
gl	grl	304	GREENLAND	Greenland	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
gd	grd	308	GRENADA	Grenada	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
gp	glp	312	GUADELOUPE	Guadeloupe	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
gu	gum	316	GUAM	Guam	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
gt	gtm	320	GUATEMALA	Guatemala	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
gg	ggy	831	GUERNSEY	Guernsey	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
gn	gin	324	GUINEA	Guinea	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
gw	gnb	624	GUINEA-BISSAU	Guinea-Bissau	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
gy	guy	328	GUYANA	Guyana	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
ht	hti	332	HAITI	Haiti	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
hm	hmd	334	HEARD ISLAND AND MCDONALD ISLANDS	Heard Island And Mcdonald Islands	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
va	vat	336	HOLY SEE (VATICAN CITY STATE)	Holy See (Vatican City State)	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
hn	hnd	340	HONDURAS	Honduras	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
hk	hkg	344	HONG KONG	Hong Kong	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
hu	hun	348	HUNGARY	Hungary	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
is	isl	352	ICELAND	Iceland	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
id	idn	360	INDONESIA	Indonesia	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
ir	irn	364	IRAN, ISLAMIC REPUBLIC OF	Iran, Islamic Republic of	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
iq	irq	368	IRAQ	Iraq	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
ie	irl	372	IRELAND	Ireland	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
im	imn	833	ISLE OF MAN	Isle Of Man	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
il	isr	376	ISRAEL	Israel	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
it	ita	380	ITALY	Italy	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
jm	jam	388	JAMAICA	Jamaica	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
jp	jpn	392	JAPAN	Japan	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
je	jey	832	JERSEY	Jersey	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
jo	jor	400	JORDAN	Jordan	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
kz	kaz	398	KAZAKHSTAN	Kazakhstan	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
ke	ken	404	KENYA	Kenya	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
ki	kir	296	KIRIBATI	Kiribati	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
kp	prk	408	KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF	Korea, Democratic People's Republic of	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
kr	kor	410	KOREA, REPUBLIC OF	Korea, Republic of	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
xk	xkx	900	KOSOVO	Kosovo	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
kw	kwt	414	KUWAIT	Kuwait	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
kg	kgz	417	KYRGYZSTAN	Kyrgyzstan	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
la	lao	418	LAO PEOPLE'S DEMOCRATIC REPUBLIC	Lao People's Democratic Republic	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
lv	lva	428	LATVIA	Latvia	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
lb	lbn	422	LEBANON	Lebanon	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
ls	lso	426	LESOTHO	Lesotho	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
lr	lbr	430	LIBERIA	Liberia	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
ly	lby	434	LIBYA	Libya	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
li	lie	438	LIECHTENSTEIN	Liechtenstein	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
lt	ltu	440	LITHUANIA	Lithuania	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
lu	lux	442	LUXEMBOURG	Luxembourg	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
mo	mac	446	MACAO	Macao	\N	\N	2025-08-07 00:53:39.462+05	2025-08-07 00:53:39.462+05	\N
mk	mkd	807	MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF	Macedonia, the Former Yugoslav Republic of	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
mg	mdg	450	MADAGASCAR	Madagascar	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
mw	mwi	454	MALAWI	Malawi	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
my	mys	458	MALAYSIA	Malaysia	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
mv	mdv	462	MALDIVES	Maldives	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
ml	mli	466	MALI	Mali	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
mt	mlt	470	MALTA	Malta	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
mh	mhl	584	MARSHALL ISLANDS	Marshall Islands	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
mq	mtq	474	MARTINIQUE	Martinique	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
mr	mrt	478	MAURITANIA	Mauritania	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
mu	mus	480	MAURITIUS	Mauritius	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
yt	myt	175	MAYOTTE	Mayotte	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
mx	mex	484	MEXICO	Mexico	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
fm	fsm	583	MICRONESIA, FEDERATED STATES OF	Micronesia, Federated States of	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
md	mda	498	MOLDOVA, REPUBLIC OF	Moldova, Republic of	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
mc	mco	492	MONACO	Monaco	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
mn	mng	496	MONGOLIA	Mongolia	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
me	mne	499	MONTENEGRO	Montenegro	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
ms	msr	500	MONTSERRAT	Montserrat	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
ma	mar	504	MOROCCO	Morocco	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
mz	moz	508	MOZAMBIQUE	Mozambique	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
mm	mmr	104	MYANMAR	Myanmar	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
na	nam	516	NAMIBIA	Namibia	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
nr	nru	520	NAURU	Nauru	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
nl	nld	528	NETHERLANDS	Netherlands	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
nc	ncl	540	NEW CALEDONIA	New Caledonia	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
nz	nzl	554	NEW ZEALAND	New Zealand	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
ni	nic	558	NICARAGUA	Nicaragua	\N	\N	2025-08-07 00:53:39.463+05	2025-08-07 00:53:39.463+05	\N
ne	ner	562	NIGER	Niger	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
ng	nga	566	NIGERIA	Nigeria	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
nu	niu	570	NIUE	Niue	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
nf	nfk	574	NORFOLK ISLAND	Norfolk Island	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
mp	mnp	580	NORTHERN MARIANA ISLANDS	Northern Mariana Islands	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
no	nor	578	NORWAY	Norway	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
om	omn	512	OMAN	Oman	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
pw	plw	585	PALAU	Palau	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
ps	pse	275	PALESTINIAN TERRITORY, OCCUPIED	Palestinian Territory, Occupied	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
pa	pan	591	PANAMA	Panama	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
pg	png	598	PAPUA NEW GUINEA	Papua New Guinea	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
py	pry	600	PARAGUAY	Paraguay	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
pe	per	604	PERU	Peru	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
ph	phl	608	PHILIPPINES	Philippines	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
pn	pcn	612	PITCAIRN	Pitcairn	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
pl	pol	616	POLAND	Poland	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
pt	prt	620	PORTUGAL	Portugal	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
pr	pri	630	PUERTO RICO	Puerto Rico	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
qa	qat	634	QATAR	Qatar	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
re	reu	638	REUNION	Reunion	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
ro	rom	642	ROMANIA	Romania	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
ru	rus	643	RUSSIAN FEDERATION	Russian Federation	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
rw	rwa	646	RWANDA	Rwanda	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
bl	blm	652	SAINT BARTHÉLEMY	Saint Barthélemy	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
sh	shn	654	SAINT HELENA	Saint Helena	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
kn	kna	659	SAINT KITTS AND NEVIS	Saint Kitts and Nevis	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
lc	lca	662	SAINT LUCIA	Saint Lucia	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
mf	maf	663	SAINT MARTIN (FRENCH PART)	Saint Martin (French part)	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
pm	spm	666	SAINT PIERRE AND MIQUELON	Saint Pierre and Miquelon	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
vc	vct	670	SAINT VINCENT AND THE GRENADINES	Saint Vincent and the Grenadines	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
ws	wsm	882	SAMOA	Samoa	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
sm	smr	674	SAN MARINO	San Marino	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
st	stp	678	SAO TOME AND PRINCIPE	Sao Tome and Principe	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
sa	sau	682	SAUDI ARABIA	Saudi Arabia	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
sn	sen	686	SENEGAL	Senegal	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
rs	srb	688	SERBIA	Serbia	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
sc	syc	690	SEYCHELLES	Seychelles	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
sl	sle	694	SIERRA LEONE	Sierra Leone	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
sg	sgp	702	SINGAPORE	Singapore	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
sx	sxm	534	SINT MAARTEN	Sint Maarten	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
sk	svk	703	SLOVAKIA	Slovakia	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
si	svn	705	SLOVENIA	Slovenia	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
sb	slb	090	SOLOMON ISLANDS	Solomon Islands	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
so	som	706	SOMALIA	Somalia	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
za	zaf	710	SOUTH AFRICA	South Africa	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
gs	sgs	239	SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS	South Georgia and the South Sandwich Islands	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
ss	ssd	728	SOUTH SUDAN	South Sudan	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
es	esp	724	SPAIN	Spain	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
lk	lka	144	SRI LANKA	Sri Lanka	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
sd	sdn	729	SUDAN	Sudan	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
sr	sur	740	SURINAME	Suriname	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
sj	sjm	744	SVALBARD AND JAN MAYEN	Svalbard and Jan Mayen	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
sz	swz	748	SWAZILAND	Swaziland	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
se	swe	752	SWEDEN	Sweden	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
ch	che	756	SWITZERLAND	Switzerland	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
sy	syr	760	SYRIAN ARAB REPUBLIC	Syrian Arab Republic	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
tw	twn	158	TAIWAN, PROVINCE OF CHINA	Taiwan, Province of China	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
tj	tjk	762	TAJIKISTAN	Tajikistan	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
tz	tza	834	TANZANIA, UNITED REPUBLIC OF	Tanzania, United Republic of	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
th	tha	764	THAILAND	Thailand	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
tl	tls	626	TIMOR LESTE	Timor Leste	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
tg	tgo	768	TOGO	Togo	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
tk	tkl	772	TOKELAU	Tokelau	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
to	ton	776	TONGA	Tonga	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
tt	tto	780	TRINIDAD AND TOBAGO	Trinidad and Tobago	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
tn	tun	788	TUNISIA	Tunisia	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
tr	tur	792	TURKEY	Turkey	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
tm	tkm	795	TURKMENISTAN	Turkmenistan	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
tc	tca	796	TURKS AND CAICOS ISLANDS	Turks and Caicos Islands	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
tv	tuv	798	TUVALU	Tuvalu	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
ug	uga	800	UGANDA	Uganda	\N	\N	2025-08-07 00:53:39.464+05	2025-08-07 00:53:39.464+05	\N
ua	ukr	804	UKRAINE	Ukraine	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
ae	are	784	UNITED ARAB EMIRATES	United Arab Emirates	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
gb	gbr	826	UNITED KINGDOM	United Kingdom	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
us	usa	840	UNITED STATES	United States	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
um	umi	581	UNITED STATES MINOR OUTLYING ISLANDS	United States Minor Outlying Islands	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
uy	ury	858	URUGUAY	Uruguay	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
uz	uzb	860	UZBEKISTAN	Uzbekistan	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
vu	vut	548	VANUATU	Vanuatu	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
ve	ven	862	VENEZUELA	Venezuela	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
vn	vnm	704	VIET NAM	Viet Nam	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
vg	vgb	092	VIRGIN ISLANDS, BRITISH	Virgin Islands, British	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
vi	vir	850	VIRGIN ISLANDS, U.S.	Virgin Islands, U.S.	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
wf	wlf	876	WALLIS AND FUTUNA	Wallis and Futuna	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
eh	esh	732	WESTERN SAHARA	Western Sahara	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
ye	yem	887	YEMEN	Yemen	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
zm	zmb	894	ZAMBIA	Zambia	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
zw	zwe	716	ZIMBABWE	Zimbabwe	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
ax	ala	248	ÅLAND ISLANDS	Åland Islands	\N	\N	2025-08-07 00:53:39.465+05	2025-08-07 00:53:39.465+05	\N
bd	bgd	050	BANGLADESH	Bangladesh	reg_01K20KE9PH6XVMM3SQKCMNR5EE	\N	2025-08-07 00:53:39.461+05	2025-08-07 02:08:52.063+05	\N
in	ind	356	INDIA	India	reg_01K20KE9PH6XVMM3SQKCMNR5EE	\N	2025-08-07 00:53:39.462+05	2025-08-07 02:08:52.063+05	\N
np	npl	524	NEPAL	Nepal	reg_01K20KE9PH6XVMM3SQKCMNR5EE	\N	2025-08-07 00:53:39.463+05	2025-08-07 02:08:52.064+05	\N
pk	pak	586	PAKISTAN	Pakistan	reg_01K20KE9PH6XVMM3SQKCMNR5EE	\N	2025-08-07 00:53:39.464+05	2025-08-07 02:08:52.064+05	\N
\.


--
-- Data for Name: region_payment_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region_payment_provider (region_id, payment_provider_id, id, created_at, updated_at, deleted_at) FROM stdin;
reg_01JTFS1F03GKA26MVQDAGJD052	pp_system_default	regpp_01JTFS1F11W5F5612FY5DAV4A5	2025-05-05 13:29:44.865262+05	2025-05-05 13:29:44.865262+05	\N
reg_01JTFV8PGDDBMMXSFAGQ2TV0HM	pp_system_default	regpp_01JTFV8PH5CWA12YQBCR3V0MRX	2025-05-05 14:08:39.075962+05	2025-05-05 14:08:39.075962+05	\N
reg_01K20KE9PH6XVMM3SQKCMNR5EE	pp_system_default	regpp_01K20KE9QWE2PKH1K8THW3MZDX	2025-08-07 02:08:52.092252+05	2025-08-07 02:08:52.092252+05	\N
\.


--
-- Data for Name: reservation_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservation_item (id, created_at, updated_at, deleted_at, line_item_id, location_id, quantity, external_id, description, created_by, metadata, inventory_item_id, allow_backorder, raw_quantity) FROM stdin;
\.


--
-- Data for Name: return; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return (id, order_id, claim_id, exchange_id, order_version, display_id, status, no_notification, refund_amount, raw_refund_amount, metadata, created_at, updated_at, deleted_at, received_at, canceled_at, location_id, requested_at, created_by) FROM stdin;
\.


--
-- Data for Name: return_fulfillment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return_fulfillment (return_id, fulfillment_id, id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: return_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.return_item (id, return_id, reason_id, item_id, quantity, raw_quantity, received_quantity, raw_received_quantity, note, metadata, created_at, updated_at, deleted_at, damaged_quantity, raw_damaged_quantity) FROM stdin;
\.


--
-- Data for Name: sales_channel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_channel (id, name, description, is_disabled, metadata, created_at, updated_at, deleted_at) FROM stdin;
sc_01K20F4ZKA5B6EPMVVZRNSBFAW	Default Sales Channel	Created by Medusa	f	\N	2025-08-07 00:53:52.491+05	2025-08-07 00:53:52.491+05	\N
\.


--
-- Data for Name: sales_channel_stock_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales_channel_stock_location (sales_channel_id, stock_location_id, id, created_at, updated_at, deleted_at) FROM stdin;
sc_01JTFS1BVSG3Z3KGXH5162ZD2B	sloc_01JTFS1F22ETR16GFAB60SB0VK	scloc_01JTFS1F652J6G32W45WCBF9KC	2025-05-05 13:29:45.02907+05	2025-05-25 12:18:13.036+05	2025-05-25 12:18:13.036+05
\.


--
-- Data for Name: script_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.script_migrations (id, script_name, created_at, finished_at) FROM stdin;
1	migrate-product-shipping-profile.js	2025-05-05 13:29:38.06123+05	2025-05-05 13:29:38.088584+05
\.


--
-- Data for Name: service_zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_zone (id, name, metadata, fulfillment_set_id, created_at, updated_at, deleted_at) FROM stdin;
serzo_01JW34S3K1Q2774J8HY78R3XVY	Pakistan	\N	fuset_01JW34R0WG4WWEPQ4ZXH6KEE4K	2025-05-25 12:16:09.953+05	2025-05-25 12:16:09.953+05	\N
serzo_01JTFS1F2TSSG5Z3VZSNMDEDHE	Europe	\N	fuset_01JTFS1F2VSR7137S5W7WB71E5	2025-05-05 13:29:44.923+05	2025-05-25 12:18:13.043+05	2025-05-25 12:18:13.039+05
serzo_01JW34YDHXAX70QKDKTMMZ1XTR	Other Countries	\N	fuset_01JW34R0WG4WWEPQ4ZXH6KEE4K	2025-05-25 12:19:03.997+05	2025-05-25 12:19:16.396+05	\N
\.


--
-- Data for Name: shipping_option; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option (id, name, price_type, service_zone_id, shipping_profile_id, provider_id, data, metadata, shipping_option_type_id, created_at, updated_at, deleted_at) FROM stdin;
so_01JW34W1JQZP8GTTK225DNJHW8	Standard Delivery	flat	serzo_01JW34S3K1Q2774J8HY78R3XVY	sp_01JTFS18D1GR241A7E99ZD6RJA	manual_manual	{"id": "manual-fulfillment"}	\N	sotype_01JW34W1JQBV9GWT0M8RVEA8T1	2025-05-25 12:17:46.201+05	2025-05-25 12:17:46.201+05	\N
so_01JTFS1F4CBJ5W78WGFNKCSBHV	Standard Shipping	flat	serzo_01JTFS1F2TSSG5Z3VZSNMDEDHE	sp_01JTFS18D1GR241A7E99ZD6RJA	manual_manual	\N	\N	sotype_01JTFS1F4C8WVT38YH1J8ZMDBB	2025-05-05 13:29:44.974+05	2025-05-25 12:18:13.052+05	2025-05-25 12:18:13.039+05
so_01JTFS1F4DAS0M8D81PBYW9HZK	Express Shipping	flat	serzo_01JTFS1F2TSSG5Z3VZSNMDEDHE	sp_01JTFS18D1GR241A7E99ZD6RJA	manual_manual	\N	\N	sotype_01JTFS1F4DG2MMA8MZHQ64MK4E	2025-05-05 13:29:44.974+05	2025-05-25 12:18:13.052+05	2025-05-25 12:18:13.039+05
so_01JW351SJHBQ5E2A4S2WA8CVDG	Courier	flat	serzo_01JW34YDHXAX70QKDKTMMZ1XTR	sp_01JTFS18D1GR241A7E99ZD6RJA	manual_manual	{"id": "manual-fulfillment"}	\N	sotype_01JW351SJGNPBQX7VHQJKN3G7J	2025-05-25 12:20:54.609+05	2025-05-25 12:20:54.609+05	\N
\.


--
-- Data for Name: shipping_option_price_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option_price_set (shipping_option_id, price_set_id, id, created_at, updated_at, deleted_at) FROM stdin;
so_01JW34W1JQZP8GTTK225DNJHW8	pset_01JW34W1K7G3DY80VBZ5QBZ1T4	sops_01JW34W1KVDZ5WZP2GFC1HYWSW	2025-05-25 12:17:46.234774+05	2025-05-25 12:17:46.234774+05	\N
so_01JTFS1F4CBJ5W78WGFNKCSBHV	pset_01JTFS1F4ZCGJXNE3VVMWN666R	sops_01JTFS1F5XTGSK5CKYXK9QW2N1	2025-05-05 13:29:45.020907+05	2025-05-25 12:18:13.072+05	2025-05-25 12:18:13.071+05
so_01JTFS1F4DAS0M8D81PBYW9HZK	pset_01JTFS1F4Z3DBCS23FA8BQNDVF	sops_01JTFS1F5XP60QZZ1WEGH61AM6	2025-05-05 13:29:45.020907+05	2025-05-25 12:18:13.072+05	2025-05-25 12:18:13.071+05
so_01JW351SJHBQ5E2A4S2WA8CVDG	pset_01JW351SJV9R0MZ5YQ997YQ1CF	sops_01JW351SKCXMS3X8K1P3QXY1R4	2025-05-25 12:20:54.635835+05	2025-05-25 12:20:54.635835+05	\N
\.


--
-- Data for Name: shipping_option_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option_rule (id, attribute, operator, value, shipping_option_id, created_at, updated_at, deleted_at) FROM stdin;
sorul_01JW34W1JQMFB750X5FRF0V5KC	is_return	eq	"false"	so_01JW34W1JQZP8GTTK225DNJHW8	2025-05-25 12:17:46.201+05	2025-05-25 12:17:46.201+05	\N
sorul_01JW34W1JQ5BWRP1AGZB4F1VW6	enabled_in_store	eq	"true"	so_01JW34W1JQZP8GTTK225DNJHW8	2025-05-25 12:17:46.201+05	2025-05-25 12:17:46.201+05	\N
sorul_01JTFS1F4C3G0GMDMXQDVX8NX6	enabled_in_store	eq	"true"	so_01JTFS1F4CBJ5W78WGFNKCSBHV	2025-05-05 13:29:44.974+05	2025-05-25 12:18:13.063+05	2025-05-25 12:18:13.039+05
sorul_01JTFS1F4C1MRH98XSWF52Z9F7	is_return	eq	"false"	so_01JTFS1F4CBJ5W78WGFNKCSBHV	2025-05-05 13:29:44.974+05	2025-05-25 12:18:13.063+05	2025-05-25 12:18:13.039+05
sorul_01JTFS1F4DRDKGVN51RASWC4VX	enabled_in_store	eq	"true"	so_01JTFS1F4DAS0M8D81PBYW9HZK	2025-05-05 13:29:44.975+05	2025-05-25 12:18:13.063+05	2025-05-25 12:18:13.039+05
sorul_01JTFS1F4D8TKFZRGV13E18GMJ	is_return	eq	"false"	so_01JTFS1F4DAS0M8D81PBYW9HZK	2025-05-05 13:29:44.975+05	2025-05-25 12:18:13.063+05	2025-05-25 12:18:13.039+05
sorul_01JW351SJGDMEEHB3K8FVP1RH8	is_return	eq	"false"	so_01JW351SJHBQ5E2A4S2WA8CVDG	2025-05-25 12:20:54.609+05	2025-05-25 12:20:54.609+05	\N
sorul_01JW351SJGJ7RTFW63PQ56F6G4	enabled_in_store	eq	"true"	so_01JW351SJHBQ5E2A4S2WA8CVDG	2025-05-25 12:20:54.609+05	2025-05-25 12:20:54.609+05	\N
\.


--
-- Data for Name: shipping_option_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_option_type (id, label, description, code, created_at, updated_at, deleted_at) FROM stdin;
sotype_01JW34W1JQBV9GWT0M8RVEA8T1	Type label	Type description	type-code	2025-05-25 12:17:46.2+05	2025-05-25 12:17:46.2+05	\N
sotype_01JTFS1F4C8WVT38YH1J8ZMDBB	Standard	Ship in 2-3 days.	standard	2025-05-05 13:29:44.974+05	2025-05-25 12:18:13.063+05	2025-05-25 12:18:13.039+05
sotype_01JTFS1F4DG2MMA8MZHQ64MK4E	Express	Ship in 24 hours.	express	2025-05-05 13:29:44.974+05	2025-05-25 12:18:13.063+05	2025-05-25 12:18:13.039+05
sotype_01JW351SJGNPBQX7VHQJKN3G7J	Type label	Type description	type-code	2025-05-25 12:20:54.609+05	2025-05-25 12:20:54.609+05	\N
\.


--
-- Data for Name: shipping_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_profile (id, name, type, metadata, created_at, updated_at, deleted_at) FROM stdin;
sp_01JTFS18D1GR241A7E99ZD6RJA	Default Shipping Profile	default	\N	2025-05-05 13:29:38.083+05	2025-05-05 13:29:38.083+05	\N
\.


--
-- Data for Name: stock_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_location (id, created_at, updated_at, deleted_at, name, address_id, metadata) FROM stdin;
sloc_01K20KC8VD27GKGVST85KQVJCS	2025-08-07 02:07:45.646+05	2025-08-07 02:07:45.646+05	\N	KHI Warehouse	laddr_01K20KC8VDJJAPW3WMC2QXHRAE	\N
\.


--
-- Data for Name: stock_location_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock_location_address (id, created_at, updated_at, deleted_at, address_1, address_2, company, city, country_code, phone, province, postal_code, metadata) FROM stdin;
laddr_01K20KC8VDJJAPW3WMC2QXHRAE	2025-08-07 02:07:45.645+05	2025-08-07 02:07:45.645+05	\N	Teen Talwar	Saima Spring Field Apartments		Karachi	pk		Sindh		\N
\.


--
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store (id, name, default_sales_channel_id, default_region_id, default_location_id, metadata, created_at, updated_at, deleted_at) FROM stdin;
store_01K20F4ZKSC28C49X8XDEJ0MCP	Tahreer Store	sc_01K20F4ZKA5B6EPMVVZRNSBFAW	reg_01K20KE9PH6XVMM3SQKCMNR5EE	sloc_01K20KC8VD27GKGVST85KQVJCS	\N	2025-08-07 00:53:52.503927+05	2025-08-07 00:53:52.503927+05	\N
\.


--
-- Data for Name: store_currency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_currency (id, currency_code, is_default, store_id, created_at, updated_at, deleted_at) FROM stdin;
stocur_01K20PCKFQEH4DYTWF3NP0QTGX	inr	f	store_01K20F4ZKSC28C49X8XDEJ0MCP	2025-08-07 03:00:22.256714+05	2025-08-07 03:00:22.256714+05	\N
stocur_01K20PCKFQD55NZ4NVKMMG59N0	pkr	t	store_01K20F4ZKSC28C49X8XDEJ0MCP	2025-08-07 03:00:22.256714+05	2025-08-07 03:00:22.256714+05	\N
\.


--
-- Data for Name: tax_provider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_provider (id, is_enabled, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_rate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_rate (id, rate, code, name, is_default, is_combinable, tax_region_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_rate_rule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_rate_rule (id, tax_rate_id, reference_id, reference, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: tax_region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tax_region (id, provider_id, country_code, province_code, parent_id, metadata, created_at, updated_at, created_by, deleted_at) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, first_name, last_name, email, avatar_url, metadata, created_at, updated_at, deleted_at) FROM stdin;
user_01JTFTW5BVVJP6RM2H2Z178YEK	Ibrahim	Khurram	ibrahimkhurram407@gmail.com	\N	\N	2025-05-05 14:01:48.283+05	2025-05-05 14:03:34.986+05	\N
user_01JTFTZY75CN5H4ZCF43TTQB8D	\N	\N	abdulhadi@gmail.com	\N	\N	2025-05-05 14:03:52.038+05	2025-05-05 14:03:52.038+05	\N
user_01JTGV2SHFFBJ0Z6YRKZTF1A6M	\N	\N	ibrahimkhurram401@gmail.com	\N	\N	2025-05-05 23:24:39.984+05	2025-05-14 17:17:22.245+05	2025-05-14 17:17:22.242+05
user_01JTFV0DXTY9MTM0JYMH0YSBAX	\N	\N	hassannaveed@gmail.com	\N	\N	2025-05-05 14:04:08.122+05	2025-05-05 14:04:08.122+05	2025-05-14 17:17:22.242+05
\.


--
-- Data for Name: workflow_execution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workflow_execution (id, workflow_id, transaction_id, execution, context, state, created_at, updated_at, deleted_at, retention_time) FROM stdin;
\.


--
-- Name: link_module_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.link_module_migrations_id_seq', 54, true);


--
-- Name: mikro_orm_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mikro_orm_migrations_id_seq', 79, true);


--
-- Name: order_change_action_ordering_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_change_action_ordering_seq', 1, true);


--
-- Name: order_claim_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_claim_display_id_seq', 1, false);


--
-- Name: order_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_display_id_seq', 1, true);


--
-- Name: order_exchange_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_exchange_display_id_seq', 1, false);


--
-- Name: return_display_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.return_display_id_seq', 1, false);


--
-- Name: script_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.script_migrations_id_seq', 1, true);


--
-- Name: workflow_execution PK_workflow_execution_workflow_id_transaction_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workflow_execution
    ADD CONSTRAINT "PK_workflow_execution_workflow_id_transaction_id" PRIMARY KEY (workflow_id, transaction_id);


--
-- Name: account_holder account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account_holder
    ADD CONSTRAINT account_holder_pkey PRIMARY KEY (id);


--
-- Name: api_key api_key_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_key
    ADD CONSTRAINT api_key_pkey PRIMARY KEY (id);


--
-- Name: application_method_buy_rules application_method_buy_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: application_method_target_rules application_method_target_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_pkey PRIMARY KEY (application_method_id, promotion_rule_id);


--
-- Name: auth_identity auth_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_identity
    ADD CONSTRAINT auth_identity_pkey PRIMARY KEY (id);


--
-- Name: capture capture_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_pkey PRIMARY KEY (id);


--
-- Name: cart_address cart_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_address
    ADD CONSTRAINT cart_address_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item cart_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_pkey PRIMARY KEY (id);


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: cart_payment_collection cart_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_payment_collection
    ADD CONSTRAINT cart_payment_collection_pkey PRIMARY KEY (cart_id, payment_collection_id);


--
-- Name: cart cart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);


--
-- Name: cart_promotion cart_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_promotion
    ADD CONSTRAINT cart_promotion_pkey PRIMARY KEY (cart_id, promotion_id);


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method cart_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: credit_line credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_pkey PRIMARY KEY (id);


--
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (code);


--
-- Name: customer_account_holder customer_account_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_account_holder
    ADD CONSTRAINT customer_account_holder_pkey PRIMARY KEY (customer_id, account_holder_id);


--
-- Name: customer_address customer_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_pkey PRIMARY KEY (id);


--
-- Name: customer_group_customer customer_group_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_pkey PRIMARY KEY (id);


--
-- Name: customer_group customer_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group
    ADD CONSTRAINT customer_group_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_address fulfillment_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_address
    ADD CONSTRAINT fulfillment_address_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_item fulfillment_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_label fulfillment_label_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_pkey PRIMARY KEY (id);


--
-- Name: fulfillment fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_provider fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_provider
    ADD CONSTRAINT fulfillment_provider_pkey PRIMARY KEY (id);


--
-- Name: fulfillment_set fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_set
    ADD CONSTRAINT fulfillment_set_pkey PRIMARY KEY (id);


--
-- Name: geo_zone geo_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_pkey PRIMARY KEY (id);


--
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (id);


--
-- Name: inventory_item inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_item
    ADD CONSTRAINT inventory_item_pkey PRIMARY KEY (id);


--
-- Name: inventory_level inventory_level_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_pkey PRIMARY KEY (id);


--
-- Name: invite invite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invite
    ADD CONSTRAINT invite_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_pkey PRIMARY KEY (id);


--
-- Name: link_module_migrations link_module_migrations_table_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_module_migrations
    ADD CONSTRAINT link_module_migrations_table_name_key UNIQUE (table_name);


--
-- Name: location_fulfillment_provider location_fulfillment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_fulfillment_provider
    ADD CONSTRAINT location_fulfillment_provider_pkey PRIMARY KEY (stock_location_id, fulfillment_provider_id);


--
-- Name: location_fulfillment_set location_fulfillment_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location_fulfillment_set
    ADD CONSTRAINT location_fulfillment_set_pkey PRIMARY KEY (stock_location_id, fulfillment_set_id);


--
-- Name: mikro_orm_migrations mikro_orm_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mikro_orm_migrations
    ADD CONSTRAINT mikro_orm_migrations_pkey PRIMARY KEY (id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_provider notification_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_provider
    ADD CONSTRAINT notification_provider_pkey PRIMARY KEY (id);


--
-- Name: order_address order_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_address
    ADD CONSTRAINT order_address_pkey PRIMARY KEY (id);


--
-- Name: order_cart order_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_cart
    ADD CONSTRAINT order_cart_pkey PRIMARY KEY (order_id, cart_id);


--
-- Name: order_change_action order_change_action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_pkey PRIMARY KEY (id);


--
-- Name: order_change order_change_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item_image order_claim_item_image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim_item_image
    ADD CONSTRAINT order_claim_item_image_pkey PRIMARY KEY (id);


--
-- Name: order_claim_item order_claim_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim_item
    ADD CONSTRAINT order_claim_item_pkey PRIMARY KEY (id);


--
-- Name: order_claim order_claim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_claim
    ADD CONSTRAINT order_claim_pkey PRIMARY KEY (id);


--
-- Name: order_credit_line order_credit_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_pkey PRIMARY KEY (id);


--
-- Name: order_exchange_item order_exchange_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_exchange_item
    ADD CONSTRAINT order_exchange_item_pkey PRIMARY KEY (id);


--
-- Name: order_exchange order_exchange_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_exchange
    ADD CONSTRAINT order_exchange_pkey PRIMARY KEY (id);


--
-- Name: order_fulfillment order_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_fulfillment
    ADD CONSTRAINT order_fulfillment_pkey PRIMARY KEY (order_id, fulfillment_id);


--
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_adjustment order_line_item_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_line_item order_line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_pkey PRIMARY KEY (id);


--
-- Name: order_line_item_tax_line order_line_item_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_payment_collection order_payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_payment_collection
    ADD CONSTRAINT order_payment_collection_pkey PRIMARY KEY (order_id, payment_collection_id);


--
-- Name: order order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_pkey PRIMARY KEY (id);


--
-- Name: order_promotion order_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_promotion
    ADD CONSTRAINT order_promotion_pkey PRIMARY KEY (order_id, promotion_id);


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method order_shipping_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method
    ADD CONSTRAINT order_shipping_method_pkey PRIMARY KEY (id);


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_pkey PRIMARY KEY (id);


--
-- Name: order_shipping order_shipping_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_pkey PRIMARY KEY (id);


--
-- Name: order_transaction order_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_pkey PRIMARY KEY (id);


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_pkey PRIMARY KEY (payment_collection_id, payment_provider_id);


--
-- Name: payment_collection payment_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection
    ADD CONSTRAINT payment_collection_pkey PRIMARY KEY (id);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (id);


--
-- Name: payment_provider payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_provider
    ADD CONSTRAINT payment_provider_pkey PRIMARY KEY (id);


--
-- Name: payment_session payment_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_pkey PRIMARY KEY (id);


--
-- Name: price_list price_list_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_list
    ADD CONSTRAINT price_list_pkey PRIMARY KEY (id);


--
-- Name: price_list_rule price_list_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_pkey PRIMARY KEY (id);


--
-- Name: price price_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_pkey PRIMARY KEY (id);


--
-- Name: price_preference price_preference_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_preference
    ADD CONSTRAINT price_preference_pkey PRIMARY KEY (id);


--
-- Name: price_rule price_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_pkey PRIMARY KEY (id);


--
-- Name: price_set price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_set
    ADD CONSTRAINT price_set_pkey PRIMARY KEY (id);


--
-- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_pkey PRIMARY KEY (id);


--
-- Name: product_category_product product_category_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_pkey PRIMARY KEY (product_id, product_category_id);


--
-- Name: product_collection product_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_collection
    ADD CONSTRAINT product_collection_pkey PRIMARY KEY (id);


--
-- Name: product_option product_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_pkey PRIMARY KEY (id);


--
-- Name: product_option_value product_option_value_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_pkey PRIMARY KEY (id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: product_sales_channel product_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sales_channel
    ADD CONSTRAINT product_sales_channel_pkey PRIMARY KEY (product_id, sales_channel_id);


--
-- Name: product_shipping_profile product_shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_shipping_profile
    ADD CONSTRAINT product_shipping_profile_pkey PRIMARY KEY (product_id, shipping_profile_id);


--
-- Name: product_tag product_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tag
    ADD CONSTRAINT product_tag_pkey PRIMARY KEY (id);


--
-- Name: product_tags product_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_pkey PRIMARY KEY (product_id, product_tag_id);


--
-- Name: product_type product_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pkey PRIMARY KEY (id);


--
-- Name: product_variant_inventory_item product_variant_inventory_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_inventory_item
    ADD CONSTRAINT product_variant_inventory_item_pkey PRIMARY KEY (variant_id, inventory_item_id);


--
-- Name: product_variant_option product_variant_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_pkey PRIMARY KEY (variant_id, option_value_id);


--
-- Name: product_variant product_variant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_pkey PRIMARY KEY (id);


--
-- Name: product_variant_price_set product_variant_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_price_set
    ADD CONSTRAINT product_variant_price_set_pkey PRIMARY KEY (variant_id, price_set_id);


--
-- Name: promotion_application_method promotion_application_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign_budget promotion_campaign_budget_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_pkey PRIMARY KEY (id);


--
-- Name: promotion_campaign promotion_campaign_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign
    ADD CONSTRAINT promotion_campaign_pkey PRIMARY KEY (id);


--
-- Name: promotion promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_pkey PRIMARY KEY (id);


--
-- Name: promotion_promotion_rule promotion_promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_pkey PRIMARY KEY (promotion_id, promotion_rule_id);


--
-- Name: promotion_rule promotion_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_rule
    ADD CONSTRAINT promotion_rule_pkey PRIMARY KEY (id);


--
-- Name: promotion_rule_value promotion_rule_value_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_pkey PRIMARY KEY (id);


--
-- Name: provider_identity provider_identity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_pkey PRIMARY KEY (id);


--
-- Name: publishable_api_key_sales_channel publishable_api_key_sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.publishable_api_key_sales_channel
    ADD CONSTRAINT publishable_api_key_sales_channel_pkey PRIMARY KEY (publishable_key_id, sales_channel_id);


--
-- Name: refund refund_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_pkey PRIMARY KEY (id);


--
-- Name: refund_reason refund_reason_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund_reason
    ADD CONSTRAINT refund_reason_pkey PRIMARY KEY (id);


--
-- Name: region_country region_country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_pkey PRIMARY KEY (iso_2);


--
-- Name: region_payment_provider region_payment_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region_payment_provider
    ADD CONSTRAINT region_payment_provider_pkey PRIMARY KEY (region_id, payment_provider_id);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: reservation_item reservation_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_pkey PRIMARY KEY (id);


--
-- Name: return_fulfillment return_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_fulfillment
    ADD CONSTRAINT return_fulfillment_pkey PRIMARY KEY (return_id, fulfillment_id);


--
-- Name: return_item return_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_item
    ADD CONSTRAINT return_item_pkey PRIMARY KEY (id);


--
-- Name: return return_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return
    ADD CONSTRAINT return_pkey PRIMARY KEY (id);


--
-- Name: sales_channel sales_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_channel
    ADD CONSTRAINT sales_channel_pkey PRIMARY KEY (id);


--
-- Name: sales_channel_stock_location sales_channel_stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_channel_stock_location
    ADD CONSTRAINT sales_channel_stock_location_pkey PRIMARY KEY (sales_channel_id, stock_location_id);


--
-- Name: script_migrations script_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.script_migrations
    ADD CONSTRAINT script_migrations_pkey PRIMARY KEY (id);


--
-- Name: service_zone service_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_pkey PRIMARY KEY (id);


--
-- Name: shipping_option shipping_option_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_price_set shipping_option_price_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_price_set
    ADD CONSTRAINT shipping_option_price_set_pkey PRIMARY KEY (shipping_option_id, price_set_id);


--
-- Name: shipping_option_rule shipping_option_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_pkey PRIMARY KEY (id);


--
-- Name: shipping_option_type shipping_option_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_type
    ADD CONSTRAINT shipping_option_type_pkey PRIMARY KEY (id);


--
-- Name: shipping_profile shipping_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_profile
    ADD CONSTRAINT shipping_profile_pkey PRIMARY KEY (id);


--
-- Name: stock_location_address stock_location_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_location_address
    ADD CONSTRAINT stock_location_address_pkey PRIMARY KEY (id);


--
-- Name: stock_location stock_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_pkey PRIMARY KEY (id);


--
-- Name: store_currency store_currency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_pkey PRIMARY KEY (id);


--
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_pkey PRIMARY KEY (id);


--
-- Name: tax_provider tax_provider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_provider
    ADD CONSTRAINT tax_provider_pkey PRIMARY KEY (id);


--
-- Name: tax_rate tax_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT tax_rate_pkey PRIMARY KEY (id);


--
-- Name: tax_rate_rule tax_rate_rule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT tax_rate_rule_pkey PRIMARY KEY (id);


--
-- Name: tax_region tax_region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT tax_region_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: IDX_account_holder_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_account_holder_deleted_at" ON public.account_holder USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_account_holder_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_account_holder_id_5cb3a0c0" ON public.customer_account_holder USING btree (account_holder_id);


--
-- Name: IDX_account_holder_provider_id_external_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_account_holder_provider_id_external_id_unique" ON public.account_holder USING btree (provider_id, external_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_adjustment_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_api_key_deleted_at" ON public.api_key USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_api_key_token_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_api_key_token_unique" ON public.api_key USING btree (token);


--
-- Name: IDX_api_key_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_api_key_type" ON public.api_key USING btree (type);


--
-- Name: IDX_application_method_allocation; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_application_method_allocation" ON public.promotion_application_method USING btree (allocation);


--
-- Name: IDX_application_method_target_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_application_method_target_type" ON public.promotion_application_method USING btree (target_type);


--
-- Name: IDX_application_method_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_application_method_type" ON public.promotion_application_method USING btree (type);


--
-- Name: IDX_auth_identity_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_auth_identity_deleted_at" ON public.auth_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_campaign_budget_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_campaign_budget_type" ON public.promotion_campaign_budget USING btree (type);


--
-- Name: IDX_capture_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_capture_deleted_at" ON public.capture USING btree (deleted_at);


--
-- Name: IDX_capture_payment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_capture_payment_id" ON public.capture USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_address_deleted_at" ON public.cart_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_billing_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_billing_address_id" ON public.cart USING btree (billing_address_id) WHERE ((deleted_at IS NULL) AND (billing_address_id IS NOT NULL));


--
-- Name: IDX_cart_credit_line_reference_reference_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_credit_line_reference_reference_id" ON public.credit_line USING btree (reference, reference_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_currency_code" ON public.cart USING btree (currency_code);


--
-- Name: IDX_cart_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_customer_id" ON public.cart USING btree (customer_id) WHERE ((deleted_at IS NULL) AND (customer_id IS NOT NULL));


--
-- Name: IDX_cart_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_deleted_at" ON public.cart USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_id_-4a39f6c9" ON public.cart_payment_collection USING btree (cart_id);


--
-- Name: IDX_cart_id_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_id_-71069c16" ON public.order_cart USING btree (cart_id);


--
-- Name: IDX_cart_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_id_-a9d4a70b" ON public.cart_promotion USING btree (cart_id);


--
-- Name: IDX_cart_line_item_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_adjustment_deleted_at" ON public.cart_line_item_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_adjustment_item_id" ON public.cart_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_line_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_deleted_at" ON public.cart_line_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_tax_line_deleted_at" ON public.cart_line_item_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_line_item_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_region_id" ON public.cart USING btree (region_id) WHERE ((deleted_at IS NULL) AND (region_id IS NOT NULL));


--
-- Name: IDX_cart_sales_channel_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_sales_channel_id" ON public.cart USING btree (sales_channel_id) WHERE ((deleted_at IS NULL) AND (sales_channel_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_address_id" ON public.cart USING btree (shipping_address_id) WHERE ((deleted_at IS NULL) AND (shipping_address_id IS NOT NULL));


--
-- Name: IDX_cart_shipping_method_adjustment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_deleted_at" ON public.cart_shipping_method_adjustment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_adjustment_shipping_method_id" ON public.cart_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_cart_shipping_method_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_deleted_at" ON public.cart_shipping_method USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_deleted_at" ON public.cart_shipping_method_tax_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_cart_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_cart_shipping_method_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_category_handle_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_category_handle_unique" ON public.product_category USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_collection_handle_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_collection_handle_unique" ON public.product_collection USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_credit_line_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_credit_line_cart_id" ON public.credit_line USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_credit_line_deleted_at" ON public.credit_line USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_address_customer_id" ON public.customer_address USING btree (customer_id);


--
-- Name: IDX_customer_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_address_deleted_at" ON public.customer_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_address_unique_customer_billing; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_billing" ON public.customer_address USING btree (customer_id) WHERE (is_default_billing = true);


--
-- Name: IDX_customer_address_unique_customer_shipping; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_address_unique_customer_shipping" ON public.customer_address USING btree (customer_id) WHERE (is_default_shipping = true);


--
-- Name: IDX_customer_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_deleted_at" ON public.customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_email_has_account_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_email_has_account_unique" ON public.customer USING btree (email, has_account) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_group_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_customer_customer_group_id" ON public.customer_group_customer USING btree (customer_group_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_customer_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_customer_customer_id" ON public.customer_group_customer USING btree (customer_id);


--
-- Name: IDX_customer_group_customer_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_customer_deleted_at" ON public.customer_group_customer USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_group_deleted_at" ON public.customer_group USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_group_name" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_group_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_customer_group_name_unique" ON public.customer_group USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_customer_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_customer_id_5cb3a0c0" ON public.customer_account_holder USING btree (customer_id);


--
-- Name: IDX_deleted_at_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-1e5992737" ON public.location_fulfillment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-31ea43a" ON public.return_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-4a39f6c9" ON public.cart_payment_collection USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-71069c16" ON public.order_cart USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-71518339" ON public.order_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-a9d4a70b" ON public.cart_promotion USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-e88adb96" ON public.location_fulfillment_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_-e8d2543e" ON public.order_fulfillment USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17a262437; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_17a262437" ON public.product_shipping_profile USING btree (deleted_at);


--
-- Name: IDX_deleted_at_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_17b4c4e35" ON public.product_variant_inventory_item USING btree (deleted_at);


--
-- Name: IDX_deleted_at_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_1c934dab0" ON public.region_payment_provider USING btree (deleted_at);


--
-- Name: IDX_deleted_at_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_20b454295" ON public.product_sales_channel USING btree (deleted_at);


--
-- Name: IDX_deleted_at_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_26d06f470" ON public.sales_channel_stock_location USING btree (deleted_at);


--
-- Name: IDX_deleted_at_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_52b23597" ON public.product_variant_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_5cb3a0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_5cb3a0c0" ON public.customer_account_holder USING btree (deleted_at);


--
-- Name: IDX_deleted_at_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_ba32fa9c" ON public.shipping_option_price_set USING btree (deleted_at);


--
-- Name: IDX_deleted_at_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_deleted_at_f42b9949" ON public.order_payment_collection USING btree (deleted_at);


--
-- Name: IDX_fulfillment_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_address_deleted_at" ON public.fulfillment_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_deleted_at" ON public.fulfillment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_id_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_id_-31ea43a" ON public.return_fulfillment USING btree (fulfillment_id);


--
-- Name: IDX_fulfillment_id_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_id_-e8d2543e" ON public.order_fulfillment USING btree (fulfillment_id);


--
-- Name: IDX_fulfillment_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_deleted_at" ON public.fulfillment_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_item_fulfillment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_fulfillment_id" ON public.fulfillment_item USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_inventory_item_id" ON public.fulfillment_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_item_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_item_line_item_id" ON public.fulfillment_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_label_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_label_deleted_at" ON public.fulfillment_label USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_label_fulfillment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_label_fulfillment_id" ON public.fulfillment_label USING btree (fulfillment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_location_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_location_id" ON public.fulfillment USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_provider_deleted_at" ON public.fulfillment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_provider_id_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_provider_id_-1e5992737" ON public.location_fulfillment_provider USING btree (fulfillment_provider_id);


--
-- Name: IDX_fulfillment_set_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_set_deleted_at" ON public.fulfillment_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_fulfillment_set_id_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_set_id_-e88adb96" ON public.location_fulfillment_set USING btree (fulfillment_set_id);


--
-- Name: IDX_fulfillment_set_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_fulfillment_set_name_unique" ON public.fulfillment_set USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_fulfillment_shipping_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_fulfillment_shipping_option_id" ON public.fulfillment USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_city; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_city" ON public.geo_zone USING btree (city) WHERE ((deleted_at IS NULL) AND (city IS NOT NULL));


--
-- Name: IDX_geo_zone_country_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_country_code" ON public.geo_zone USING btree (country_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_geo_zone_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_deleted_at" ON public.geo_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_geo_zone_province_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_province_code" ON public.geo_zone USING btree (province_code) WHERE ((deleted_at IS NULL) AND (province_code IS NOT NULL));


--
-- Name: IDX_geo_zone_service_zone_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_geo_zone_service_zone_id" ON public.geo_zone USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_id_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (id);


--
-- Name: IDX_id_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-1e5992737" ON public.location_fulfillment_provider USING btree (id);


--
-- Name: IDX_id_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-31ea43a" ON public.return_fulfillment USING btree (id);


--
-- Name: IDX_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-4a39f6c9" ON public.cart_payment_collection USING btree (id);


--
-- Name: IDX_id_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-71069c16" ON public.order_cart USING btree (id);


--
-- Name: IDX_id_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-71518339" ON public.order_promotion USING btree (id);


--
-- Name: IDX_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-a9d4a70b" ON public.cart_promotion USING btree (id);


--
-- Name: IDX_id_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-e88adb96" ON public.location_fulfillment_set USING btree (id);


--
-- Name: IDX_id_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_-e8d2543e" ON public.order_fulfillment USING btree (id);


--
-- Name: IDX_id_17a262437; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_17a262437" ON public.product_shipping_profile USING btree (id);


--
-- Name: IDX_id_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (id);


--
-- Name: IDX_id_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_1c934dab0" ON public.region_payment_provider USING btree (id);


--
-- Name: IDX_id_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_20b454295" ON public.product_sales_channel USING btree (id);


--
-- Name: IDX_id_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_26d06f470" ON public.sales_channel_stock_location USING btree (id);


--
-- Name: IDX_id_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_52b23597" ON public.product_variant_price_set USING btree (id);


--
-- Name: IDX_id_5cb3a0c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_5cb3a0c0" ON public.customer_account_holder USING btree (id);


--
-- Name: IDX_id_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_ba32fa9c" ON public.shipping_option_price_set USING btree (id);


--
-- Name: IDX_id_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_id_f42b9949" ON public.order_payment_collection USING btree (id);


--
-- Name: IDX_image_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_image_deleted_at" ON public.image USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_image_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_image_product_id" ON public.image USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_item_deleted_at" ON public.inventory_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_item_id_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_item_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (inventory_item_id);


--
-- Name: IDX_inventory_item_sku; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_inventory_item_sku" ON public.inventory_item USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_level_deleted_at" ON public.inventory_level USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_inventory_level_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_level_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_item_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_inventory_level_item_location" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_inventory_level_location_id" ON public.inventory_level USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_inventory_level_location_id_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_inventory_level_location_id_inventory_item_id" ON public.inventory_level USING btree (inventory_item_id, location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_invite_deleted_at" ON public.invite USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_invite_email_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_invite_email_unique" ON public.invite USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_invite_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_invite_token" ON public.invite USING btree (token) WHERE (deleted_at IS NULL);


--
-- Name: IDX_line_item_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_adjustment_promotion_id" ON public.cart_line_item_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_line_item_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_cart_id" ON public.cart_line_item USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_line_item_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_product_id" ON public.cart_line_item USING btree (product_id) WHERE ((deleted_at IS NULL) AND (product_id IS NOT NULL));


--
-- Name: IDX_line_item_product_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_product_type_id" ON public.cart_line_item USING btree (product_type_id) WHERE ((deleted_at IS NULL) AND (product_type_id IS NOT NULL));


--
-- Name: IDX_line_item_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_tax_line_tax_rate_id" ON public.cart_line_item_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_line_item_variant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_line_item_variant_id" ON public.cart_line_item USING btree (variant_id) WHERE ((deleted_at IS NULL) AND (variant_id IS NOT NULL));


--
-- Name: IDX_notification_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_deleted_at" ON public.notification USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_idempotency_key_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_notification_idempotency_key_unique" ON public.notification USING btree (idempotency_key) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_provider_deleted_at" ON public.notification_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_notification_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_provider_id" ON public.notification USING btree (provider_id);


--
-- Name: IDX_notification_receiver_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_notification_receiver_id" ON public.notification USING btree (receiver_id);


--
-- Name: IDX_option_product_id_title_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_option_product_id_title_unique" ON public.product_option USING btree (product_id, title) WHERE (deleted_at IS NULL);


--
-- Name: IDX_option_value_option_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_option_value_option_id_unique" ON public.product_option_value USING btree (option_id, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_address_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_address_customer_id" ON public.order_address USING btree (customer_id);


--
-- Name: IDX_order_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_address_deleted_at" ON public.order_address USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_billing_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_billing_address_id" ON public."order" USING btree (billing_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_change_action_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_claim_id" ON public.order_change_action USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_deleted_at" ON public.order_change_action USING btree (deleted_at);


--
-- Name: IDX_order_change_action_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_exchange_id" ON public.order_change_action USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_action_order_change_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_order_change_id" ON public.order_change_action USING btree (order_change_id);


--
-- Name: IDX_order_change_action_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_order_id" ON public.order_change_action USING btree (order_id);


--
-- Name: IDX_order_change_action_ordering; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_ordering" ON public.order_change_action USING btree (ordering);


--
-- Name: IDX_order_change_action_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_action_return_id" ON public.order_change_action USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_change_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_change_type" ON public.order_change USING btree (change_type);


--
-- Name: IDX_order_change_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_claim_id" ON public.order_change USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_deleted_at" ON public.order_change USING btree (deleted_at);


--
-- Name: IDX_order_change_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_exchange_id" ON public.order_change USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_order_id" ON public.order_change USING btree (order_id);


--
-- Name: IDX_order_change_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_order_id_version" ON public.order_change USING btree (order_id, version);


--
-- Name: IDX_order_change_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_return_id" ON public.order_change USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_change_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_change_status" ON public.order_change USING btree (status);


--
-- Name: IDX_order_claim_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_deleted_at" ON public.order_claim USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_display_id" ON public.order_claim USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_claim_id" ON public.order_claim_item USING btree (claim_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_deleted_at" ON public.order_claim_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_item_image_claim_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_image_claim_item_id" ON public.order_claim_item_image USING btree (claim_item_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_claim_item_image_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_image_deleted_at" ON public.order_claim_item_image USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_claim_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_item_item_id" ON public.order_claim_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_order_id" ON public.order_claim USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_claim_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_claim_return_id" ON public.order_claim USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_credit_line_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_credit_line_deleted_at" ON public.order_credit_line USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_credit_line_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_credit_line_order_id" ON public.order_credit_line USING btree (order_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_currency_code" ON public."order" USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_customer_id" ON public."order" USING btree (customer_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_deleted_at" ON public."order" USING btree (deleted_at);


--
-- Name: IDX_order_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_display_id" ON public."order" USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_deleted_at" ON public.order_exchange USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_display_id" ON public.order_exchange USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_item_deleted_at" ON public.order_exchange_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_item_exchange_id" ON public.order_exchange_item USING btree (exchange_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_item_item_id" ON public.order_exchange_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_order_id" ON public.order_exchange USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_exchange_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_exchange_return_id" ON public.order_exchange USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_id_-71069c16; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_-71069c16" ON public.order_cart USING btree (order_id);


--
-- Name: IDX_order_id_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_-71518339" ON public.order_promotion USING btree (order_id);


--
-- Name: IDX_order_id_-e8d2543e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_-e8d2543e" ON public.order_fulfillment USING btree (order_id);


--
-- Name: IDX_order_id_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_id_f42b9949" ON public.order_payment_collection USING btree (order_id);


--
-- Name: IDX_order_is_draft_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_is_draft_order" ON public."order" USING btree (is_draft_order) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_deleted_at" ON public.order_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_item_id" ON public.order_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_order_id" ON public.order_item USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_item_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_item_order_id_version" ON public.order_item USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_adjustment_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_adjustment_item_id" ON public.order_line_item_adjustment USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_product_id" ON public.order_line_item USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_tax_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_tax_line_item_id" ON public.order_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_line_item_variant_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_line_item_variant_id" ON public.order_line_item USING btree (variant_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_region_id" ON public."order" USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_address_id" ON public."order" USING btree (shipping_address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_claim_id" ON public.order_shipping USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_deleted_at" ON public.order_shipping USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_order_shipping_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_exchange_id" ON public.order_shipping USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_shipping_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_item_id" ON public.order_shipping USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_adjustment_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_method_adjustment_shipping_method_id" ON public.order_shipping_method_adjustment USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_shipping_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_method_shipping_option_id" ON public.order_shipping_method USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_method_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_method_tax_line_shipping_method_id" ON public.order_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_order_id" ON public.order_shipping USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_order_id_version" ON public.order_shipping USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_shipping_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_shipping_return_id" ON public.order_shipping USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_claim_id" ON public.order_transaction USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_currency_code" ON public.order_transaction USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_exchange_id" ON public.order_transaction USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_order_transaction_order_id_version; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_order_id_version" ON public.order_transaction USING btree (order_id, version) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_reference_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_reference_id" ON public.order_transaction USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_order_transaction_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_order_transaction_return_id" ON public.order_transaction USING btree (return_id) WHERE ((return_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_payment_collection_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_collection_deleted_at" ON public.payment_collection USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_collection_id_-4a39f6c9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_collection_id_-4a39f6c9" ON public.cart_payment_collection USING btree (payment_collection_id);


--
-- Name: IDX_payment_collection_id_f42b9949; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_collection_id_f42b9949" ON public.order_payment_collection USING btree (payment_collection_id);


--
-- Name: IDX_payment_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_deleted_at" ON public.payment USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_payment_payment_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_payment_collection_id" ON public.payment USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_payment_session_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_payment_session_id" ON public.payment USING btree (payment_session_id);


--
-- Name: IDX_payment_payment_session_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_payment_payment_session_id_unique" ON public.payment USING btree (payment_session_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_provider_deleted_at" ON public.payment_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_provider_id" ON public.payment USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_payment_provider_id_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_provider_id_1c934dab0" ON public.region_payment_provider USING btree (payment_provider_id);


--
-- Name: IDX_payment_session_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_session_deleted_at" ON public.payment_session USING btree (deleted_at);


--
-- Name: IDX_payment_session_payment_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_payment_session_payment_collection_id" ON public.payment_session USING btree (payment_collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_currency_code" ON public.price USING btree (currency_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_deleted_at" ON public.price USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_deleted_at" ON public.price_list USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_rule_attribute" ON public.price_list_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_list_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_rule_deleted_at" ON public.price_list_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_list_rule_price_list_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_list_rule_price_list_id" ON public.price_list_rule USING btree (price_list_id) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_preference_attribute_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_price_preference_attribute_value" ON public.price_preference USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_preference_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_preference_deleted_at" ON public.price_preference USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_price_list_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_price_list_id" ON public.price USING btree (price_list_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_price_set_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_price_set_id" ON public.price USING btree (price_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_attribute" ON public.price_rule USING btree (attribute) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_attribute_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_attribute_value" ON public.price_rule USING btree (attribute, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_deleted_at" ON public.price_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_rule_operator; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_operator" ON public.price_rule USING btree (operator);


--
-- Name: IDX_price_rule_operator_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_operator_value" ON public.price_rule USING btree (operator, value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_price_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_rule_price_id" ON public.price_rule USING btree (price_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_rule_price_id_attribute_operator_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_price_rule_price_id_attribute_operator_unique" ON public.price_rule USING btree (price_id, attribute, operator) WHERE (deleted_at IS NULL);


--
-- Name: IDX_price_set_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_set_deleted_at" ON public.price_set USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_price_set_id_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_set_id_52b23597" ON public.product_variant_price_set USING btree (price_set_id);


--
-- Name: IDX_price_set_id_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_price_set_id_ba32fa9c" ON public.shipping_option_price_set USING btree (price_set_id);


--
-- Name: IDX_product_category_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_category_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- Name: IDX_product_category_parent_category_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_category_parent_category_id" ON public.product_category USING btree (parent_category_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_category_path; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_category_path" ON public.product_category USING btree (mpath) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_collection_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_collection_deleted_at" ON public.product_collection USING btree (deleted_at);


--
-- Name: IDX_product_collection_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_collection_id" ON public.product USING btree (collection_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_deleted_at" ON public.product USING btree (deleted_at);


--
-- Name: IDX_product_handle_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_handle_unique" ON public.product USING btree (handle) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_id_17a262437; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_id_17a262437" ON public.product_shipping_profile USING btree (product_id);


--
-- Name: IDX_product_id_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_id_20b454295" ON public.product_sales_channel USING btree (product_id);


--
-- Name: IDX_product_image_url; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_image_url" ON public.image USING btree (url) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_option_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_deleted_at" ON public.product_option USING btree (deleted_at);


--
-- Name: IDX_product_option_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_product_id" ON public.product_option USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_option_value_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_value_deleted_at" ON public.product_option_value USING btree (deleted_at);


--
-- Name: IDX_product_option_value_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_option_value_option_id" ON public.product_option_value USING btree (option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_tag_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_tag_deleted_at" ON public.product_tag USING btree (deleted_at);


--
-- Name: IDX_product_type_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_type_deleted_at" ON public.product_type USING btree (deleted_at);


--
-- Name: IDX_product_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_type_id" ON public.product USING btree (type_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_barcode_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_barcode_unique" ON public.product_variant USING btree (barcode) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_variant_deleted_at" ON public.product_variant USING btree (deleted_at);


--
-- Name: IDX_product_variant_ean_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_ean_unique" ON public.product_variant USING btree (ean) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_product_variant_product_id" ON public.product_variant USING btree (product_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_sku_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_sku_unique" ON public.product_variant USING btree (sku) WHERE (deleted_at IS NULL);


--
-- Name: IDX_product_variant_upc_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_product_variant_upc_unique" ON public.product_variant USING btree (upc) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_currency_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_application_method_currency_code" ON public.promotion_application_method USING btree (currency_code) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_promotion_application_method_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_application_method_deleted_at" ON public.promotion_application_method USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_application_method_promotion_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_promotion_application_method_promotion_id_unique" ON public.promotion_application_method USING btree (promotion_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_campaign_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_budget_campaign_id_unique" ON public.promotion_campaign_budget USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_budget_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_campaign_budget_deleted_at" ON public.promotion_campaign_budget USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_campaign_identifier_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_promotion_campaign_campaign_identifier_unique" ON public.promotion_campaign USING btree (campaign_identifier) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_campaign_deleted_at" ON public.promotion_campaign USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_campaign_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_campaign_id" ON public.promotion USING btree (campaign_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_deleted_at" ON public.promotion USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_id_-71518339; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_id_-71518339" ON public.order_promotion USING btree (promotion_id);


--
-- Name: IDX_promotion_id_-a9d4a70b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_id_-a9d4a70b" ON public.cart_promotion USING btree (promotion_id);


--
-- Name: IDX_promotion_rule_attribute; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_attribute" ON public.promotion_rule USING btree (attribute);


--
-- Name: IDX_promotion_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_deleted_at" ON public.promotion_rule USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_operator; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_operator" ON public.promotion_rule USING btree (operator);


--
-- Name: IDX_promotion_rule_value_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_value_deleted_at" ON public.promotion_rule_value USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_rule_value_promotion_rule_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_rule_value_promotion_rule_id" ON public.promotion_rule_value USING btree (promotion_rule_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_status" ON public.promotion USING btree (status) WHERE (deleted_at IS NULL);


--
-- Name: IDX_promotion_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_promotion_type" ON public.promotion USING btree (type);


--
-- Name: IDX_provider_identity_auth_identity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_provider_identity_auth_identity_id" ON public.provider_identity USING btree (auth_identity_id);


--
-- Name: IDX_provider_identity_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_provider_identity_deleted_at" ON public.provider_identity USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_provider_identity_provider_entity_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_provider_identity_provider_entity_id" ON public.provider_identity USING btree (entity_id, provider);


--
-- Name: IDX_publishable_key_id_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_publishable_key_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (publishable_key_id);


--
-- Name: IDX_refund_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_deleted_at" ON public.refund USING btree (deleted_at);


--
-- Name: IDX_refund_payment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_payment_id" ON public.refund USING btree (payment_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_reason_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_reason_deleted_at" ON public.refund_reason USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_refund_refund_reason_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_refund_refund_reason_id" ON public.refund USING btree (refund_reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_country_deleted_at" ON public.region_country USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_country_region_id" ON public.region_country USING btree (region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_region_country_region_id_iso_2_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_region_country_region_id_iso_2_unique" ON public.region_country USING btree (region_id, iso_2);


--
-- Name: IDX_region_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_deleted_at" ON public.region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_region_id_1c934dab0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_region_id_1c934dab0" ON public.region_payment_provider USING btree (region_id);


--
-- Name: IDX_reservation_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_deleted_at" ON public.reservation_item USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_reservation_item_inventory_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_inventory_item_id" ON public.reservation_item USING btree (inventory_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_line_item_id" ON public.reservation_item USING btree (line_item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_reservation_item_location_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_reservation_item_location_id" ON public.reservation_item USING btree (location_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_claim_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_claim_id" ON public.return USING btree (claim_id) WHERE ((claim_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_display_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_display_id" ON public.return USING btree (display_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_exchange_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_exchange_id" ON public.return USING btree (exchange_id) WHERE ((exchange_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_return_id_-31ea43a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_id_-31ea43a" ON public.return_fulfillment USING btree (return_id);


--
-- Name: IDX_return_item_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_deleted_at" ON public.return_item USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_item_id" ON public.return_item USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_reason_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_reason_id" ON public.return_item USING btree (reason_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_item_return_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_item_return_id" ON public.return_item USING btree (return_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_return_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_return_order_id" ON public.return USING btree (order_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_sales_channel_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_deleted_at" ON public.sales_channel USING btree (deleted_at);


--
-- Name: IDX_sales_channel_id_-1d67bae40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_id_-1d67bae40" ON public.publishable_api_key_sales_channel USING btree (sales_channel_id);


--
-- Name: IDX_sales_channel_id_20b454295; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_id_20b454295" ON public.product_sales_channel USING btree (sales_channel_id);


--
-- Name: IDX_sales_channel_id_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_sales_channel_id_26d06f470" ON public.sales_channel_stock_location USING btree (sales_channel_id);


--
-- Name: IDX_service_zone_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_service_zone_deleted_at" ON public.service_zone USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_service_zone_fulfillment_set_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_service_zone_fulfillment_set_id" ON public.service_zone USING btree (fulfillment_set_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_service_zone_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_service_zone_name_unique" ON public.service_zone USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_method_adjustment_promotion_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_adjustment_promotion_id" ON public.cart_shipping_method_adjustment USING btree (promotion_id) WHERE ((deleted_at IS NULL) AND (promotion_id IS NOT NULL));


--
-- Name: IDX_shipping_method_cart_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_cart_id" ON public.cart_shipping_method USING btree (cart_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_method_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_option_id" ON public.cart_shipping_method USING btree (shipping_option_id) WHERE ((deleted_at IS NULL) AND (shipping_option_id IS NOT NULL));


--
-- Name: IDX_shipping_method_tax_line_tax_rate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_method_tax_line_tax_rate_id" ON public.cart_shipping_method_tax_line USING btree (tax_rate_id) WHERE ((deleted_at IS NULL) AND (tax_rate_id IS NOT NULL));


--
-- Name: IDX_shipping_option_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_deleted_at" ON public.shipping_option USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_id_ba32fa9c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_id_ba32fa9c" ON public.shipping_option_price_set USING btree (shipping_option_id);


--
-- Name: IDX_shipping_option_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_provider_id" ON public.shipping_option USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_rule_deleted_at" ON public.shipping_option_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_option_rule_shipping_option_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_rule_shipping_option_id" ON public.shipping_option_rule USING btree (shipping_option_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_service_zone_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_service_zone_id" ON public.shipping_option USING btree (service_zone_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_shipping_profile_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_shipping_profile_id" ON public.shipping_option USING btree (shipping_profile_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_shipping_option_type_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_option_type_deleted_at" ON public.shipping_option_type USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_profile_deleted_at" ON public.shipping_profile USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_shipping_profile_id_17a262437; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_shipping_profile_id_17a262437" ON public.product_shipping_profile USING btree (shipping_profile_id);


--
-- Name: IDX_shipping_profile_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_shipping_profile_name_unique" ON public.shipping_profile USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: IDX_single_default_region; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_single_default_region" ON public.tax_rate USING btree (tax_region_id) WHERE ((is_default = true) AND (deleted_at IS NULL));


--
-- Name: IDX_stock_location_address_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_address_deleted_at" ON public.stock_location_address USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_address_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_stock_location_address_id_unique" ON public.stock_location USING btree (address_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_stock_location_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_deleted_at" ON public.stock_location USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_stock_location_id_-1e5992737; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_id_-1e5992737" ON public.location_fulfillment_provider USING btree (stock_location_id);


--
-- Name: IDX_stock_location_id_-e88adb96; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_id_-e88adb96" ON public.location_fulfillment_set USING btree (stock_location_id);


--
-- Name: IDX_stock_location_id_26d06f470; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_stock_location_id_26d06f470" ON public.sales_channel_stock_location USING btree (stock_location_id);


--
-- Name: IDX_store_currency_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_store_currency_deleted_at" ON public.store_currency USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_store_currency_store_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_store_currency_store_id" ON public.store_currency USING btree (store_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_store_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_store_deleted_at" ON public.store USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tag_value_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tag_value_unique" ON public.product_tag USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_line_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_line_item_id" ON public.cart_line_item_tax_line USING btree (item_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_line_shipping_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_line_shipping_method_id" ON public.cart_shipping_method_tax_line USING btree (shipping_method_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_provider_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_provider_deleted_at" ON public.tax_provider USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_deleted_at" ON public.tax_rate USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_rule_deleted_at" ON public.tax_rate_rule USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_rate_rule_reference_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_rule_reference_id" ON public.tax_rate_rule USING btree (reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_tax_rate_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_rule_tax_rate_id" ON public.tax_rate_rule USING btree (tax_rate_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_rule_unique_rate_reference; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tax_rate_rule_unique_rate_reference" ON public.tax_rate_rule USING btree (tax_rate_id, reference_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_rate_tax_region_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_rate_tax_region_id" ON public.tax_rate USING btree (tax_region_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_region_deleted_at" ON public.tax_region USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_tax_region_parent_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_region_parent_id" ON public.tax_region USING btree (parent_id);


--
-- Name: IDX_tax_region_provider_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_tax_region_provider_id" ON public.tax_region USING btree (provider_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_tax_region_unique_country_nullable_province; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_nullable_province" ON public.tax_region USING btree (country_code) WHERE ((province_code IS NULL) AND (deleted_at IS NULL));


--
-- Name: IDX_tax_region_unique_country_province; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_tax_region_unique_country_province" ON public.tax_region USING btree (country_code, province_code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_type_value_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_type_value_unique" ON public.product_type USING btree (value) WHERE (deleted_at IS NULL);


--
-- Name: IDX_unique_promotion_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_unique_promotion_code" ON public.promotion USING btree (code) WHERE (deleted_at IS NULL);


--
-- Name: IDX_user_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_user_deleted_at" ON public."user" USING btree (deleted_at) WHERE (deleted_at IS NOT NULL);


--
-- Name: IDX_user_email_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "IDX_user_email_unique" ON public."user" USING btree (email) WHERE (deleted_at IS NULL);


--
-- Name: IDX_variant_id_17b4c4e35; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_variant_id_17b4c4e35" ON public.product_variant_inventory_item USING btree (variant_id);


--
-- Name: IDX_variant_id_52b23597; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_variant_id_52b23597" ON public.product_variant_price_set USING btree (variant_id);


--
-- Name: IDX_workflow_execution_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_deleted_at" ON public.workflow_execution USING btree (deleted_at) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_id" ON public.workflow_execution USING btree (id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_state" ON public.workflow_execution USING btree (state) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_transaction_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_transaction_id" ON public.workflow_execution USING btree (transaction_id) WHERE (deleted_at IS NULL);


--
-- Name: IDX_workflow_execution_workflow_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_workflow_execution_workflow_id" ON public.workflow_execution USING btree (workflow_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_script_name_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_script_name_unique ON public.script_migrations USING btree (script_name);


--
-- Name: tax_rate_rule FK_tax_rate_rule_tax_rate_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate_rule
    ADD CONSTRAINT "FK_tax_rate_rule_tax_rate_id" FOREIGN KEY (tax_rate_id) REFERENCES public.tax_rate(id) ON DELETE CASCADE;


--
-- Name: tax_rate FK_tax_rate_tax_region_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_rate
    ADD CONSTRAINT "FK_tax_rate_tax_region_id" FOREIGN KEY (tax_region_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_parent_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_parent_id" FOREIGN KEY (parent_id) REFERENCES public.tax_region(id) ON DELETE CASCADE;


--
-- Name: tax_region FK_tax_region_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tax_region
    ADD CONSTRAINT "FK_tax_region_provider_id" FOREIGN KEY (provider_id) REFERENCES public.tax_provider(id) ON DELETE SET NULL;


--
-- Name: application_method_buy_rules application_method_buy_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_buy_rules application_method_buy_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_buy_rules
    ADD CONSTRAINT application_method_buy_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_application_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_application_method_id_foreign FOREIGN KEY (application_method_id) REFERENCES public.promotion_application_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: application_method_target_rules application_method_target_rules_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_method_target_rules
    ADD CONSTRAINT application_method_target_rules_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: capture capture_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capture
    ADD CONSTRAINT capture_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_line_item_adjustment cart_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_adjustment
    ADD CONSTRAINT cart_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item cart_line_item_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item
    ADD CONSTRAINT cart_line_item_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_line_item_tax_line cart_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_line_item_tax_line
    ADD CONSTRAINT cart_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.cart_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart cart_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.cart_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cart_shipping_method_adjustment cart_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_adjustment
    ADD CONSTRAINT cart_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method cart_shipping_method_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method
    ADD CONSTRAINT cart_shipping_method_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_shipping_method_tax_line cart_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_shipping_method_tax_line
    ADD CONSTRAINT cart_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.cart_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: credit_line credit_line_cart_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_line
    ADD CONSTRAINT credit_line_cart_id_foreign FOREIGN KEY (cart_id) REFERENCES public.cart(id) ON UPDATE CASCADE;


--
-- Name: customer_address customer_address_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_group_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_group_id_foreign FOREIGN KEY (customer_group_id) REFERENCES public.customer_group(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: customer_group_customer customer_group_customer_customer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_group_customer
    ADD CONSTRAINT customer_group_customer_customer_id_foreign FOREIGN KEY (customer_id) REFERENCES public.customer(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_delivery_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_delivery_address_id_foreign FOREIGN KEY (delivery_address_id) REFERENCES public.fulfillment_address(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment_item fulfillment_item_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_item
    ADD CONSTRAINT fulfillment_item_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment_label fulfillment_label_fulfillment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment_label
    ADD CONSTRAINT fulfillment_label_fulfillment_id_foreign FOREIGN KEY (fulfillment_id) REFERENCES public.fulfillment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fulfillment fulfillment_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fulfillment fulfillment_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fulfillment
    ADD CONSTRAINT fulfillment_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: geo_zone geo_zone_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo_zone
    ADD CONSTRAINT geo_zone_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: image image_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inventory_level inventory_level_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_level
    ADD CONSTRAINT inventory_level_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: notification notification_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.notification_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: order order_billing_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_billing_address_id_foreign FOREIGN KEY (billing_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change_action order_change_action_order_change_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change_action
    ADD CONSTRAINT order_change_action_order_change_id_foreign FOREIGN KEY (order_change_id) REFERENCES public.order_change(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_change order_change_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_change
    ADD CONSTRAINT order_change_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_credit_line order_credit_line_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_credit_line
    ADD CONSTRAINT order_credit_line_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE;


--
-- Name: order_item order_item_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_item order_item_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_adjustment order_line_item_adjustment_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_adjustment
    ADD CONSTRAINT order_line_item_adjustment_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item_tax_line order_line_item_tax_line_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item_tax_line
    ADD CONSTRAINT order_line_item_tax_line_item_id_foreign FOREIGN KEY (item_id) REFERENCES public.order_line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_line_item order_line_item_totals_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line_item
    ADD CONSTRAINT order_line_item_totals_id_foreign FOREIGN KEY (totals_id) REFERENCES public.order_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order order_shipping_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order"
    ADD CONSTRAINT order_shipping_address_id_foreign FOREIGN KEY (shipping_address_id) REFERENCES public.order_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_adjustment order_shipping_method_adjustment_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_adjustment
    ADD CONSTRAINT order_shipping_method_adjustment_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping_method_tax_line order_shipping_method_tax_line_shipping_method_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping_method_tax_line
    ADD CONSTRAINT order_shipping_method_tax_line_shipping_method_id_foreign FOREIGN KEY (shipping_method_id) REFERENCES public.order_shipping_method(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_shipping order_shipping_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: order_transaction order_transaction_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_transaction
    ADD CONSTRAINT order_transaction_order_id_foreign FOREIGN KEY (order_id) REFERENCES public."order"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_col_aa276_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_col_aa276_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_collection_payment_providers payment_collection_payment_providers_payment_pro_2d555_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_collection_payment_providers
    ADD CONSTRAINT payment_collection_payment_providers_payment_pro_2d555_foreign FOREIGN KEY (payment_provider_id) REFERENCES public.payment_provider(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment payment_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_session payment_session_payment_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_session
    ADD CONSTRAINT payment_session_payment_collection_id_foreign FOREIGN KEY (payment_collection_id) REFERENCES public.payment_collection(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_list_rule price_list_rule_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_list_rule
    ADD CONSTRAINT price_list_rule_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_list_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_list_id_foreign FOREIGN KEY (price_list_id) REFERENCES public.price_list(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price price_price_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price
    ADD CONSTRAINT price_price_set_id_foreign FOREIGN KEY (price_set_id) REFERENCES public.price_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: price_rule price_rule_price_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_rule
    ADD CONSTRAINT price_rule_price_id_foreign FOREIGN KEY (price_id) REFERENCES public.price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category product_category_parent_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category
    ADD CONSTRAINT product_category_parent_category_id_foreign FOREIGN KEY (parent_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_category_id_foreign FOREIGN KEY (product_category_id) REFERENCES public.product_category(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_category_product product_category_product_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category_product
    ADD CONSTRAINT product_category_product_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_collection_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_collection_id_foreign FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_option product_option_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option
    ADD CONSTRAINT product_option_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_option_value product_option_value_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_option_value
    ADD CONSTRAINT product_option_value_option_id_foreign FOREIGN KEY (option_id) REFERENCES public.product_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_tags product_tags_product_tag_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_product_tag_id_foreign FOREIGN KEY (product_tag_id) REFERENCES public.product_tag(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product product_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_type_id_foreign FOREIGN KEY (type_id) REFERENCES public.product_type(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: product_variant_option product_variant_option_option_value_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_option_value_id_foreign FOREIGN KEY (option_value_id) REFERENCES public.product_option_value(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant_option product_variant_option_variant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant_option
    ADD CONSTRAINT product_variant_option_variant_id_foreign FOREIGN KEY (variant_id) REFERENCES public.product_variant(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: product_variant product_variant_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_variant
    ADD CONSTRAINT product_variant_product_id_foreign FOREIGN KEY (product_id) REFERENCES public.product(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_application_method promotion_application_method_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_application_method
    ADD CONSTRAINT promotion_application_method_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_campaign_budget promotion_campaign_budget_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_campaign_budget
    ADD CONSTRAINT promotion_campaign_budget_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion promotion_campaign_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion
    ADD CONSTRAINT promotion_campaign_id_foreign FOREIGN KEY (campaign_id) REFERENCES public.promotion_campaign(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_id_foreign FOREIGN KEY (promotion_id) REFERENCES public.promotion(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_promotion_rule promotion_promotion_rule_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_promotion_rule
    ADD CONSTRAINT promotion_promotion_rule_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: promotion_rule_value promotion_rule_value_promotion_rule_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotion_rule_value
    ADD CONSTRAINT promotion_rule_value_promotion_rule_id_foreign FOREIGN KEY (promotion_rule_id) REFERENCES public.promotion_rule(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: provider_identity provider_identity_auth_identity_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provider_identity
    ADD CONSTRAINT provider_identity_auth_identity_id_foreign FOREIGN KEY (auth_identity_id) REFERENCES public.auth_identity(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refund refund_payment_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_payment_id_foreign FOREIGN KEY (payment_id) REFERENCES public.payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: region_country region_country_region_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region_country
    ADD CONSTRAINT region_country_region_id_foreign FOREIGN KEY (region_id) REFERENCES public.region(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: reservation_item reservation_item_inventory_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_item
    ADD CONSTRAINT reservation_item_inventory_item_id_foreign FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: service_zone service_zone_fulfillment_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_zone
    ADD CONSTRAINT service_zone_fulfillment_set_id_foreign FOREIGN KEY (fulfillment_set_id) REFERENCES public.fulfillment_set(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_provider_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_provider_id_foreign FOREIGN KEY (provider_id) REFERENCES public.fulfillment_provider(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: shipping_option_rule shipping_option_rule_shipping_option_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option_rule
    ADD CONSTRAINT shipping_option_rule_shipping_option_id_foreign FOREIGN KEY (shipping_option_id) REFERENCES public.shipping_option(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_service_zone_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_service_zone_id_foreign FOREIGN KEY (service_zone_id) REFERENCES public.service_zone(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_option_type_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_option_type_id_foreign FOREIGN KEY (shipping_option_type_id) REFERENCES public.shipping_option_type(id) ON UPDATE CASCADE;


--
-- Name: shipping_option shipping_option_shipping_profile_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_option
    ADD CONSTRAINT shipping_option_shipping_profile_id_foreign FOREIGN KEY (shipping_profile_id) REFERENCES public.shipping_profile(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: stock_location stock_location_address_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_location
    ADD CONSTRAINT stock_location_address_id_foreign FOREIGN KEY (address_id) REFERENCES public.stock_location_address(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: store_currency store_currency_store_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_currency
    ADD CONSTRAINT store_currency_store_id_foreign FOREIGN KEY (store_id) REFERENCES public.store(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

