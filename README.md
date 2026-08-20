# Olist E-Commerce Business Analysis (SQL / BigQuery)

A SQL-driven analysis of ~100K orders from Olist, a Brazilian e-commerce marketplace, exploring revenue trends, product performance, delivery operations, payment behavior, and seller quality — built as a portfolio project to demonstrate real-world data analyst SQL skills.

## Business Context

Olist connects small/medium sellers across Brazil to major online marketplaces, handling the logistics in between. This analysis treats Olist as a client asking: *"How's the business doing, what's driving it, and where should we focus operationally?"*

## Tools Used

- **Google BigQuery** (free sandbox tier) — data warehouse and SQL engine
- **Kaggle** — source dataset ("Brazilian E-Commerce Public Dataset by Olist")
- **Google Sheets** — initial data scouting
- **SQL** (Standard SQL / BigQuery dialect) — all analysis

## Dataset

9 relational tables (~100K orders, 2016–2018): `orders`, `order_items`, `order_payments`, `order_reviews`, `customers`, `sellers`, `products`, `geolocation`, `category_translation`. `orders` is the central table connecting customers, items, payments, and reviews.

**Data quirks identified during exploration:**
- `customer_id` is order-specific, not person-specific. The true unique customer count uses `customer_unique_id` — of 99,441 order-level customer IDs, only 96,096 are unique people (~3,345 repeat customers, a ~3.4% repeat purchase rate).
- Data is **right-censored** in the final 2 months (Sep–Oct 2018): orders placed then hadn't completed delivery status by the time the dataset was extracted, so revenue analysis for that window is excluded/incomplete.
- `order_reviews.csv` contained free-text reviews with embedded line breaks that initially broke standard CSV parsing — resolved by enabling "quoted newlines" on ingestion, with zero data loss (99,224 reviews loaded, matching the known full dataset size).

## Data Cleaning Performed

- Verified no duplicate order records (row count = distinct `order_id` count)
- Flagged that NULL delivery dates are expected/correct for non-delivered orders (canceled, still shipping) — not treated as missing data to "fix"
- Built a reusable SQL view (`orders_clean`) joining orders, order items, products, and translated category names, to avoid repeating 4-table joins across every query

## Key Findings

### 1. Revenue Trend
Monthly revenue grew steadily through 2017, peaking sharply in **November 2017 (~$988K)** — consistent with Black Friday seasonality. 2018 plateaued around $800K–$980K/month before the right-censoring cutoff.

### 2. Category Performance
`health_beauty` leads total revenue (~$1.23M), but category strategy differs sharply: `watches_gifts` earns nearly as much (~$1.17M) from **half the order volume** of `bed_bath_table`, driven by a much higher average item price (~$199 vs ~$93) — a "value vs. volume" contrast worth different inventory/marketing approaches.

### 3. Delivery Performance vs. Satisfaction
Late deliveries (~8% of all orders) average a **2.57-star review**, vs. **4.29 stars** for on-time/early orders — a 1.7-star gap. Delivery reliability is one of the strongest single levers on customer satisfaction in this dataset.

### 4. Payment Behavior
Credit card dominates (73.9% of payments), with an average of **3.5 installments per purchase** — reflecting Brazil's common buy-now-pay-later retail culture. Boleto (pay-in-full bank slip) is the #2 method at 19%.

### 5. Geographic Delivery Risk
Late-delivery rates vary sharply by state: **Alagoas (AL) has the highest rate at 23.9%**, nearly 3x the national average. **Rio de Janeiro (RJ)**, despite a lower rate (13.5%), produces the most late orders in absolute terms (1,664) due to its high order volume — the highest-impact state to prioritize for logistics investment.

### 6. Seller Performance
Among top-10 sellers by revenue (mostly based in São Paulo), one high-volume seller (967 orders, ~$186K revenue) stands out with a notably low average review score of 3.35 vs. 3.8–4.4 for peers — a candidate for a fulfillment/quality audit despite strong sales.

## Recommendations

- Prioritize delivery-time improvements in Rio de Janeiro for the largest absolute reduction in late orders, and in Alagoas for the largest proportional improvement.
- Audit high-revenue, low-review sellers individually — revenue alone is a misleading quality signal.
- Treat `watches_gifts`-style categories (premium, low-volume) and `bed_bath_table`-style categories (high-volume, lower price) as separate strategies rather than one blended approach.

## Limitations

- Analysis excludes Sep–Oct 2018 due to right-censoring of delivery status.
- Dataset reflects a single marketplace's operations in Brazil; findings may not generalize to other markets.

## How to Reproduce

1. Download the dataset from [Kaggle: Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
2. Load each CSV into a BigQuery dataset (free sandbox tier, no billing required)
3. Run the SQL scripts in `/queries` in order
4. Queries reference `orders_clean`, a view built from `orders`, `order_items`, `products`, and `category_translation` (see `/queries/00_setup_view.sql`)

## Repo Structure

```
├── README.md
├── queries/
│   ├── 00_setup_view.sql
│   ├── 01_revenue_trend.sql
│   ├── 02_category_performance.sql
│   ├── 03_delivery_vs_satisfaction.sql
│   ├── 04_payment_methods.sql
│   ├── 05_late_delivery_by_state.sql
│   └── 06_seller_performance.sql
```
