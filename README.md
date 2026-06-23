# Data Analyst Interview Prep
 
Personal SQL practice repo — drills for getting interview-sharp on joins, window functions, and aggregation using a small sample e-commerce database.

<br>
 
## Contents
 
| File | What it is |
|---|---|
| `schema_and_data.sql` | Schema + sample data: `customers`, `products`, `orders`, `order_items`. Run this first. |
| `drill_problems.txt` | 10 timed practice problems, no solutions included. |
| `drill_solutions.sql` | Solutions with explanations, plus Postgres/MySQL syntax notes where they differ from SQLite. |
| `run_query.py` | Python script to build the database and run queries against it — no install required beyond Python. |

<br>
 
## Setup
 
No database server needed. Everything runs on SQLite through Python's built-in `sqlite3` module.
 
```bash
git clone <this-repo-url>
cd <repo-folder>
python3 run_query.py
```
 
The first run automatically builds `practice.db` from `schema_and_data.sql`.
 
> `practice.db` is git-ignored — it's generated locally, not committed.

<br>
 
## How to practice
 
1. Open `drill_problems.txt` and pick a problem.
2. Set a 3-minute timer.
3. Write the query cold — no docs, no autocomplete.
4. Edit the `QUERY` variable in `run_query.py` and run it to check your output.
5. Only after attempting it, check `drill_solutions.sql` for the intended approach and any gotchas.
6. Rate yourself: **Solid / Shaky / Stuck**. Redo anything marked Stuck within a day or two.

<br>

## Database schema
 
```
customers      (customer_id, name, signup_date, country)
products       (product_id, product_name, category, unit_price)
orders         (order_id, customer_id, order_date, status)
order_items    (order_item_id, order_id, product_id, quantity, unit_price)
```
 
`status` on `orders` is one of `completed`, `cancelled`, `refunded` — several drills depend on filtering for this correctly.

<br>
 
## Notes
 
- Queries are written for SQLite syntax by default; solution notes flag the equivalent for Postgres/MySQL where date functions differ.
- This is a personal study repo, not a tutorial — problems assume familiarity with SQL fundamentals (joins, GROUP BY) and focus on speed and recall under time pressure.