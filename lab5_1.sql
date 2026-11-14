DROP DATABASE IF EXISTS clothing_store;
CREATE DATABASE clothing_store;
USE clothing_store;

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE products (
product_id INT AUTO_INCREMENT PRIMARY KEY,
product_name VARCHAR(150) NOT NULL,
category_id INT NOT NULL,
size VARCHAR(10),
price DECIMAL(10,2) NOT NULL,
stock_quantity INT NOT NULL,
FOREIGN KEY (category_id) REFERENCES categories(category_id),
CHECK (price >= 0),
CHECK (stock_quantity >= 0)
);

CREATE TABLE orders (
order_id INT AUTO_INCREMENT PRIMARY KEY,
customer_id INT NOT NULL,
order_date DATE NOT NULL,
status VARCHAR(30) NOT NULL,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
order_item_id INT AUTO_INCREMENT PRIMARY KEY,
order_id INT NOT NULL,
product_id INT NOT NULL,
quantity INT NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id),
UNIQUE (order_id, product_id),
CHECK (quantity > 0),
CHECK (unit_price >= 0)
);

ALTER TABLE customers ADD address VARCHAR(200);

INSERT INTO categories 
VALUES
(1, 'Футболки'), (2, 'Джинсы'), (3, 'Куртки');

INSERT INTO customers 
VALUES
(1, 'Анна Иванова', '89001112233', 'anna@mail.ru', 'Москва'),
(2, 'Мария Петрова', '89004445566', 'maria@mail.ru', 'Казань'),
(3, 'Иван Сидоров', '89007778899', 'ivan@mail.ru', 'Тула');

INSERT INTO products 
VALUES
(1, 'Белая футболка', 1, 'M', 1700, 20),
(2, 'Синие джинсы', 2, 'L', 3500, 15),
(3, 'Чёрная куртка', 3, 'M', 7000, 8),
(4, 'Чёрная футболка', 1, 'S', 1800, 12);

INSERT INTO orders 
VALUES
(1, 1, '2026-10-01', 'completed'),
(2, 2, '2026-10-03', 'completed'),
(3, 3, '2026-10-05', 'new');

INSERT INTO order_items 
VALUES
(1, 1, 1, 2, 1500),
(2, 1, 2, 1, 3500),
(3, 2, 3, 1, 7000),
(4, 3, 4, 2, 1800);

UPDATE products SET price = 1750 WHERE product_id = 1;

INSERT INTO categories VALUES (99, 'Тестовая');
DELETE FROM categories WHERE category_id = 99;

CREATE USER IF NOT EXISTS 'clothing_reader'@'localhost' IDENTIFIED BY 'ChangeMe_2026!';
GRANT SELECT ON clothing_store.* TO 'clothing_reader'@'localhost';

DESCRIBE categories;
DESCRIBE customers;
DESCRIBE products;
DESCRIBE orders;
DESCRIBE order_items;