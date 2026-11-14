USE clothing_store;

SELECT product_name, price
FROM products
WHERE price >= 1750
ORDER BY price DESC;

SELECT orders.order_id, customers.full_name, products.product_name, order_items.quantity
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
JOIN order_items ON orders.order_id = order_items.order_id
JOIN products ON order_items.product_id = products.product_id;

SELECT COUNT(*) AS kolichestvo,
       SUM(stock_quantity) AS ostatok,
       AVG(price) AS srednyaya_cena,
       MAX(price) AS max_cena,
       MIN(price) AS min_cena
FROM products;

SELECT products.product_name,
       SUM(order_items.quantity) AS prodano,
       SUM(order_items.quantity * order_items.unit_price) AS vyruchka
FROM products
JOIN order_items ON products.product_id = order_items.product_id
JOIN orders ON order_items.order_id = orders.order_id
WHERE orders.status = 'completed'
GROUP BY products.product_id, products.product_name
HAVING SUM(order_items.quantity) >= 1;

-- покупатели, у которых есть завершенные заказы (IN)
SELECT full_name FROM customers
WHERE customer_id IN (
    SELECT customer_id FROM orders WHERE status = 'completed'
);

-- товары, цена которых не меньше цен всех футболок (ALL)
SELECT product_name, price FROM products
WHERE price >= ALL (
    SELECT price FROM products WHERE category_id = 1
);

-- проверка количества на складе и цены
SELECT product_name, stock_quantity,
    CASE
        WHEN stock_quantity < 10 THEN 'Мало'
        WHEN stock_quantity < 20 THEN 'Средне'
        ELSE 'Достаточно'
    END AS ostatki,
    IF(price >= 3000, 'Дорогой', 'Недорогой') AS cena
FROM products;

-- представление для отчета о продажах
CREATE VIEW sales_report AS
SELECT products.product_name,
       SUM(order_items.quantity) AS prodano,
       SUM(order_items.quantity * order_items.unit_price) AS vyruchka
FROM products
JOIN order_items ON products.product_id = order_items.product_id
JOIN orders ON order_items.order_id = orders.order_id
WHERE orders.status = 'completed'
GROUP BY products.product_id, products.product_name;
SELECT * FROM sales_report;

-- смотрим план запроса до и после индекса
EXPLAIN SELECT * FROM orders WHERE order_date = '2026-10-01';
CREATE INDEX idx_date ON orders(order_date);
EXPLAIN SELECT * FROM orders WHERE order_date = '2026-10-01';

-- транзакция. пробуем оформить заказ и уменьшить остаток
START TRANSACTION;
UPDATE orders SET status = 'completed' WHERE order_id = 3;
UPDATE products SET stock_quantity = stock_quantity - 2
WHERE product_id = 4 AND stock_quantity >= 2;
SELECT * FROM orders WHERE order_id = 3;
SELECT * FROM products WHERE product_id = 4;
ROLLBACK;


-- подготовленный запрос с параметром цены
SET @cena = 1800;
PREPARE zapros FROM 'SELECT product_name, price FROM products WHERE price >= ?';
EXECUTE zapros USING @cena;
DEALLOCATE PREPARE zapros;
