# Mini Amazon: PostgreSQL Schema

A very small Amazon-style store: customers place orders for products, and products belong to categories.

**5 tables:** `customers`, `categories`, `products`, `orders`, `order_items`

## Files

| File | What it is |
|---|---|
| `schema.sql` | All CREATE TABLE statements, keys, constraints and indexes, plus an optional CSV load |
| `solution.dbml` | The same design for [dbdiagram.io](https://dbdiagram.io/d) |
| `solution.pdf` | Written explanation: tables, relationships, tradeoff, indexing, normalization |
| `data/records.csv` | Sample data: 25 orders, 44 order lines |

## Run it

Run from this folder (`cd Project/mini_Amazon`):

```bash
createdb mini_amazon
psql -d mini_amazon -f schema.sql                  # create tables only
psql -d mini_amazon -v load_data=1 -f schema.sql   # create tables + load the CSV
```

To update the data, edit `data/records.csv` and run the second command again.

Expected rows after loading: customers 9, categories 4, products 12, orders 25, order_items 44.

## Design in short

- `order_items` links orders and products (many-to-many) and stores `unit_price`, the price actually paid, so later price changes don't alter old orders.
- Every foreign key has an index, because PostgreSQL only indexes primary keys and UNIQUE columns automatically.
- The flat CSV is split into 5 tables to remove repeated data (normalized to 3NF).
