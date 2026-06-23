-- ============================================
-- E-COMMERCE PRACTICE DATABASE
-- Tables: customers, products, orders, order_items
-- ============================================

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id   INTEGER PRIMARY KEY,
    name          TEXT,
    signup_date   DATE,
    country       TEXT
);

CREATE TABLE products (
    product_id    INTEGER PRIMARY KEY,
    product_name  TEXT,
    category      TEXT,
    unit_price    DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id      INTEGER PRIMARY KEY,
    customer_id   INTEGER,
    order_date    DATE,
    status        TEXT  -- 'completed', 'cancelled', 'refunded'
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id      INTEGER,
    product_id    INTEGER,
    quantity      INTEGER,
    unit_price    DECIMAL(10,2)  -- price at time of order (can differ from current product price)
);

-- CUSTOMERS (15 rows, mixed countries and signup dates)
INSERT INTO customers VALUES
(1,  'Ana Torres',      '2023-01-15', 'MX'),
(2,  'Brian Walsh',     '2023-02-02', 'US'),
(3,  'Carla Mendes',    '2023-02-20', 'BR'),
(4,  'David Kim',       '2023-03-10', 'KR'),
(5,  'Elena Petrova',   '2023-03-22', 'RU'),
(6,  'Farah Al-Sayed',  '2023-04-05', 'EG'),
(7,  'Gabriel Souza',   '2023-04-18', 'BR'),
(8,  'Hana Suzuki',     '2023-05-01', 'JP'),
(9,  'Ivan Petrov',     '2023-05-14', 'RU'),
(10, 'Julia Romero',    '2023-06-02', 'MX'),
(11, 'Kevin Lee',       '2023-06-19', 'US'),
(12, 'Laura Schmidt',   '2023-07-03', 'DE'),
(13, 'Marco Rossi',     '2023-07-21', 'IT'),
(14, 'Nina Haddad',     '2023-08-09', 'EG'),
(15, 'Omar Farouk',     '2023-08-30', 'EG');

-- PRODUCTS (10 rows, 3 categories)
INSERT INTO products VALUES
(101, 'Wireless Mouse',      'Electronics', 19.99),
(102, 'Mechanical Keyboard', 'Electronics', 59.99),
(103, 'USB-C Hub',           'Electronics', 24.99),
(104, 'Office Chair',        'Furniture',   149.99),
(105, 'Standing Desk',       'Furniture',   299.99),
(106, 'Desk Lamp',           'Furniture',   34.99),
(107, 'Notebook Set',        'Stationery',  9.99),
(108, 'Pen Pack',            'Stationery',  6.99),
(109, 'Monitor 24in',        'Electronics', 179.99),
(110, 'Webcam HD',           'Electronics', 39.99);

-- ORDERS (30 rows, spanning several months, some cancelled/refunded)
INSERT INTO orders VALUES
(1001, 1,  '2023-09-01', 'completed'),
(1002, 2,  '2023-09-02', 'completed'),
(1003, 3,  '2023-09-03', 'cancelled'),
(1004, 1,  '2023-09-15', 'completed'),
(1005, 4,  '2023-09-20', 'completed'),
(1006, 5,  '2023-09-25', 'completed'),
(1007, 2,  '2023-10-01', 'completed'),
(1008, 6,  '2023-10-02', 'refunded'),
(1009, 7,  '2023-10-05', 'completed'),
(1010, 1,  '2023-10-10', 'completed'),
(1011, 8,  '2023-10-12', 'completed'),
(1012, 9,  '2023-10-15', 'completed'),
(1013, 3,  '2023-10-18', 'completed'),
(1014, 10, '2023-10-20', 'completed'),
(1015, 2,  '2023-10-25', 'cancelled'),
(1016, 11, '2023-11-01', 'completed'),
(1017, 1,  '2023-11-03', 'completed'),
(1018, 12, '2023-11-05', 'completed'),
(1019, 4,  '2023-11-08', 'completed'),
(1020, 13, '2023-11-10', 'completed'),
(1021, 5,  '2023-11-12', 'refunded'),
(1022, 14, '2023-11-15', 'completed'),
(1023, 7,  '2023-11-18', 'completed'),
(1024, 2,  '2023-11-20', 'completed'),
(1025, 15, '2023-11-22', 'completed'),
(1026, 9,  '2023-11-25', 'completed'),
(1027, 1,  '2023-12-01', 'completed'),
(1028, 8,  '2023-12-03', 'completed'),
(1029, 3,  '2023-12-05', 'completed'),
(1030, 11, '2023-12-10', 'completed');

-- ORDER_ITEMS (line items, 1-3 per order)
INSERT INTO order_items VALUES
(1,  1001, 101, 2, 19.99),
(2,  1001, 107, 1, 9.99),
(3,  1002, 104, 1, 149.99),
(4,  1003, 102, 1, 59.99),
(5,  1004, 109, 1, 179.99),
(6,  1004, 110, 1, 39.99),
(7,  1005, 105, 1, 299.99),
(8,  1006, 101, 3, 19.99),
(9,  1007, 104, 2, 149.99),
(10, 1008, 106, 1, 34.99),
(11, 1009, 102, 1, 59.99),
(12, 1009, 103, 1, 24.99),
(13, 1010, 107, 5, 9.99),
(14, 1011, 109, 1, 179.99),
(15, 1012, 101, 1, 19.99),
(16, 1013, 108, 4, 6.99),
(17, 1014, 105, 1, 299.99),
(18, 1014, 106, 2, 34.99),
(19, 1015, 102, 1, 59.99),
(20, 1016, 104, 1, 149.99),
(21, 1017, 101, 2, 19.99),
(22, 1017, 103, 1, 24.99),
(23, 1018, 109, 1, 179.99),
(24, 1019, 107, 3, 9.99),
(25, 1020, 110, 1, 39.99),
(26, 1021, 105, 1, 299.99),
(27, 1022, 101, 1, 19.99),
(28, 1023, 104, 1, 149.99),
(29, 1024, 102, 2, 59.99),
(30, 1025, 106, 1, 34.99),
(31, 1026, 109, 1, 179.99),
(32, 1027, 101, 4, 19.99),
(33, 1028, 107, 2, 9.99),
(34, 1029, 103, 1, 24.99),
(35, 1030, 105, 1, 299.99);
