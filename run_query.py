"""
Quick SQL practice runner.

Usage:
    python run_query.py

Edit the QUERY variable below with whatever you're testing,
then run the script. No setup needed beyond Python's built-in
sqlite3 module (already included with Python).

First run will build practice.db from schema_and_data.sql
automatically if it doesn't exist yet.
"""

import sqlite3
import os

DB_PATH = "practice.db"
SCHEMA_PATH = "schema_and_data.sql"

def ensure_db():
    if not os.path.exists(DB_PATH):
        conn = sqlite3.connect(DB_PATH)
        with open(SCHEMA_PATH) as f:
            conn.executescript(f.read())
        conn.commit()
        conn.close()
        print(f"Built {DB_PATH} from schema.\n")

def run(query):
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute(query)
    cols = [d[0] for d in cur.description]
    rows = cur.fetchall()
    conn.close()

    # simple pretty print
    widths = [max(len(str(c)), *(len(str(r[i])) for r in rows)) if rows else len(str(c))
              for i, c in enumerate(cols)]
    header = " | ".join(str(c).ljust(widths[i]) for i, c in enumerate(cols))
    print(header)
    print("-" * len(header))
    for r in rows:
        print(" | ".join(str(v).ljust(widths[i]) for i, v in enumerate(r)))
    print(f"\n({len(rows)} rows)")


# ---- EDIT THIS QUERY AND RUN THE SCRIPT ----
QUERY = """
SELECT o.order_id, c.name, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
ORDER BY o.order_date ASC;
"""

if __name__ == "__main__":
    ensure_db()
    run(QUERY)
