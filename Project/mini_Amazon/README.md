# Mini Amazon Marketplace: PostgreSQL Schema

A very small Amazon-style marketplace database. Sellers list products in a category tree, customers save shipping addresses and place orders, orders have line items and payments, and customers review products they bought.

- **9 tables:** customers, addresses, sellers, categories, products, orders, order_items, payments, reviews
- **Constraints:** primary keys, foreign keys (including one composite FK), NOT NULL, UNIQUE, CHECK
- **Indexes:** every foreign key, plus composite, partial and expression indexes for the main queries
- **Sample data:** 50 orders / 91 order lines in one flat CSV, normalized into the tables on load

## Files

```
.
├── schema.sql          # CREATE TABLE + constraints + indexes + optional CSV load
├── solution.dbml       # same model for dbdiagram.io
├── solution.pdf        # written explanation (tables, FKs, tradeoff, indexing, normalization)
└── data/
    └── records.csv     # flat order-line export (sample data)
```

## Run it

Requires PostgreSQL 13 or newer (tested on 16). Run from the Project/mini_Amazon folder (cd Project/mini_Amazon), because the data load reads data/records.csv from there

```bash
createdb mini_amazon

# create the tables only
psql -v ON_ERROR_STOP=1 -d mini_amazon -f schema.sql

# create the tables AND load data/records.csv
psql -v ON_ERROR_STOP=1 -v load_data=1 -d mini_amazon -f schema.sql
```

`schema.sql` drops and recreates every table, so it is safe to run again. **To update the data**, edit or add rows in `data/records.csv` and run the second command again.

Expected row counts after loading:

| table | rows |
|---|---|
| customers | 18 |
| addresses | 24 |
| sellers | 6 |
| categories | 13 |
| products | 23 |
| orders | 50 |
| order_items | 91 |
| payments | 50 |
| reviews | 30 |

## View the ER diagram

Open [dbdiagram.io](https://dbdiagram.io/d), clear the editor, and paste in the contents of `solution.dbml`.

## Design notes 



- **Price snapshot:** `order_items.unit_price` stores the price actually charged, so later price changes never rewrite past orders.
- **Totals are derived:** order totals are computed by the `order_totals` view, not stored on `orders`.
- **Composite FK:** `orders (shipping_address_id, customer_id) → addresses (address_id, customer_id)` makes sure an order can only ship to the ordering customer's own address.
- **Keys:** identity integer surrogate keys, with real-world identifiers kept as `UNIQUE` columns.
- **Indexes:** Postgres does not index foreign keys automatically, so each FK has one, either its own or as the leading column of a composite index.
