-- Mini Amazon: schema.sql
-- Tables only:        psql -d <db> -f schema.sql
-- Tables + CSV data:  psql -d <db> -v load_data=1 -f schema.sql

SET client_min_messages = warning;

BEGIN;

DROP TABLE IF EXISTS order_items, orders, products, categories, customers CASCADE;

CREATE TABLE customers (
    customer_id  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email        TEXT        NOT NULL UNIQUE,
    full_name    TEXT        NOT NULL,
    city         TEXT        NOT NULL,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE categories (
    category_id  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name         TEXT NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    sku          TEXT          NOT NULL UNIQUE,
    category_id  BIGINT        NOT NULL REFERENCES categories (category_id),
    name         TEXT          NOT NULL,
    price        NUMERIC(10,2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE orders (
    order_id      BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_number  TEXT        NOT NULL UNIQUE,
    customer_id   BIGINT      NOT NULL REFERENCES customers (customer_id),
    status        TEXT        NOT NULL DEFAULT 'placed'
                  CHECK (status IN ('placed', 'shipped', 'delivered', 'cancelled')),
    ordered_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE order_items (
    order_id    BIGINT        NOT NULL REFERENCES orders (order_id) ON DELETE CASCADE,
    product_id  BIGINT        NOT NULL REFERENCES products (product_id),
    quantity    INTEGER       NOT NULL CHECK (quantity > 0),
    unit_price  NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),  -- price paid at purchase
    PRIMARY KEY (order_id, product_id)
);

-- Indexes on foreign keys and frequently queried columns.
-- (PRIMARY KEY and UNIQUE columns are indexed automatically;
--  order_items.order_id is covered by the primary key.)
CREATE INDEX products_category_id_idx   ON products (category_id);
CREATE INDEX orders_customer_id_idx     ON orders (customer_id);
CREATE INDEX orders_ordered_at_idx      ON orders (ordered_at);
CREATE INDEX order_items_product_id_idx ON order_items (product_id);

COMMIT;

-- ---------------------------------------------------------------
-- Optional: load data/records.csv (only with -v load_data=1).
-- Run from this folder. Re-running reloads everything.
-- ---------------------------------------------------------------
\if :{?load_data}
BEGIN;

CREATE TEMP TABLE staging (
    order_number text, ordered_at text, status text,
    customer_email text, customer_name text, city text,
    category text, sku text, product_name text, price text,
    quantity text, unit_price text
) ON COMMIT DROP;

\copy staging FROM 'data/records.csv' WITH (FORMAT csv, HEADER true)

INSERT INTO customers (email, full_name, city)
SELECT DISTINCT customer_email, customer_name, city FROM staging;

INSERT INTO categories (name)
SELECT DISTINCT category FROM staging;

INSERT INTO products (sku, category_id, name, price)
SELECT DISTINCT s.sku, c.category_id, s.product_name, s.price::numeric
FROM staging s JOIN categories c ON c.name = s.category;

INSERT INTO orders (order_number, customer_id, status, ordered_at)
SELECT DISTINCT s.order_number, c.customer_id, s.status, s.ordered_at::timestamptz
FROM staging s JOIN customers c ON c.email = s.customer_email;

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT o.order_id, p.product_id, s.quantity::int, s.unit_price::numeric
FROM staging s
JOIN orders   o ON o.order_number = s.order_number
JOIN products p ON p.sku = s.sku;

COMMIT;
\endif
