-- 1. Get all customers and their addresses.
SELECT * FROM "customers"
JOIN "addresses" ON "addresses".customer_id = "customers".id;

-- 2. Get all orders and their line items (orders, quantity and product).
SELECT “orders”.id AS “order_id”, “line_items”.quantity, “products”.description AS “products_description” FROM “orders”
JOIN “line_items” ON “orders”.id = “line_items”.order_id
JOIN “products” ON “line_items”.product_id = “products”.id;

-- 3. Which warehouses have cheetos?
SELECT "warehouse".warehouse FROM "warehouse"
JOIN "warehouse_product" ON "warehouse_product".warehouse_id = "warehouse".id
JOIN "products" ON "products".id = "warehouse_product".product_id
WHERE "products".description ILIKE 'cheetos';

-- 4. Which warehouses have diet pepsi?
SELECT "warehouse".warehouse FROM "warehouse"
JOIN "warehouse_product" ON "warehouse_product".warehouse_id = "warehouse".id
JOIN "products" ON "products".id = "warehouse_product".product_id
WHERE "products".description ILIKE 'diet pepsi';

-- 5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT “customers”.first_name, “customers”.last_name, count(“orders”) AS “number_of_orders” FROM “customers”
JOIN “addresses” ON “addresses”.customer_id = “customers”.id
JOIN “orders” ON “orders”.address_id = “addresses”.id
GROUP BY “customers”.id;

-- 6. How many customers do we have?
SELECT count(*) AS "number_of_customers" FROM "customers";

-- 7. How many products do we carry?
SELECT count(*) AS “number_of_products” FROM “products”;

-- 8. What is the total available on-hand quantity of diet pepsi?
SELECT sum("warehouse_product".on_hand) AS "diet_pepsi_available" FROM "warehouse_product"
JOIN "products" ON "products".id = "warehouse_product".product_id
WHERE "products".description ILIKE 'diet pepsi';

-- 9. How much was the total cost for each order?
SELECT “orders”.id, sum(“line_items”.quantity*“products”.unit_price) AS “order_total” FROM “orders”
JOIN “line_items” ON “line_items”.order_id = “orders”.id
JOIN “products” ON “line_items”.product_id = “products”.id
GROUP BY “orders”.id;

-- 10. How much has each customer spent in total?
SELECT "customers".first_name, "customers".last_name, sum("line_items".quantity*"products".unit_price) AS "total_spent" FROM "customers"
JOIN "addresses" ON "customers".id = "addresses".customer_id
JOIN "orders" ON "addresses".id = "orders".address_id
JOIN "line_items" ON "line_items".order_id = "orders".id
JOIN "products" ON "line_items".product_id = "products".id
GROUP BY "customers".id;

-- 11. How much has each customer spent in total? Customers who have spent $0 should still show up in the            table. It should say 0, not NULL (research coalesce).
SELECT “customers”.first_name, “customers”.last_name, COALESCE(sum(“line_items”.quantity*“products”.unit_price), 0) AS “total_spent” FROM “customers”
FULL OUTER JOIN “addresses” ON “customers”.id = “addresses”.customer_id
FULL OUTER JOIN “orders” ON “addresses”.id = “orders”.address_id
FULL OUTER JOIN “line_items” ON “line_items”.order_id = “orders”.id
FULL OUTER JOIN “products” ON “line_items”.product_id = “products”.id
GROUP BY “customers”.id;