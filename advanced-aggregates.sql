-- We’ll start by looking at SpeedySpoon’s data.
SELECT *
FROM orders
ORDER BY id
LIMIT 100;

-- Select all columns in the order_items table.
SELECT * 
FROM order_items
ORDER BY id
LIMIT 100;

-- Let’s get a Daily Count of orders from the orders table.
SELECT DATE(ordered_at)
FROM orders
ORDER BY 1
LIMIT 100;

-- Use the date and count functions and group by clause to count and roup the orders by the dates they were ordered_at.
SELECT DATE(ordered_at), 
  COUNT(1)
FROM orders
GROUP BY 1
ORDER BY 1;

-- We can make a few changes to our Daily Count query to get the revenue.
SELECT DATE(orders.ordered_at),
  ROUND(SUM(order_items.amount_paid), 2)
FROM orders
JOIN order_items
  ON orders.id = order_items.order_id
GROUP BY 1
ORDER BY 1;

-- What’s the daily revenue from customers ordering kale smoothies?
SELECT DATE(orders.ordered_at),
  ROUND(SUM(order_items.amount_paid), 2)
FROM orders
JOIN order_items
  ON orders.id = order_items.order_id
WHERE name = 'kale-smoothie'
GROUP BY 1
ORDER BY 1;

-- Get the sum paid for each item.
SELECT name, 
  ROUND(SUM(amount_paid), 2)
FROM order_items
GROUP BY 1
ORDER BY 2 DESC;

-- Great! We have the sum of the products by revenue, but we still need the percent. For that, we’ll need to get the total using a subquery. 
SELECT name, 
  ROUND(SUM(amount_paid) / (SELECT(SUM(amount_paid)) FROM order_items) 100.0, 2) as pct
FROM order_items
GROUP BY 1
ORDER BY 2 DESC;

-- To see if our smoothie suspicion has merit, let’s look at purchases by category.
SELECT 
  CASE name
    WHEN 'kale-smoothie'    THEN 'smoothie'
    WHEN 'banana-smoothie'  THEN 'smoothie'
    WHEN 'orange-juice'     THEN 'drink'
    WHEN 'soda'             THEN 'drink'
    WHEN 'blt'              THEN 'sandwich'
    WHEN 'grilled-cheese'   THEN 'sandwich'
    WHEN 'tikka-masala'     THEN 'dinner'
    WHEN 'chicken-parm'     THEN 'dinner'
     ELSE 'other' 
  END AS category
FROM order_items
ORDER BY id
LIMIT 100;

-- Complete the query by using the category column created by the case statement in our previous revenue percent calculation. Add the denominator that will sum the amount_paid.
SELECT 
  CASE name
    WHEN 'kale-smoothie'    THEN 'smoothie'
    WHEN 'banana-smoothie'  THEN 'smoothie'
    WHEN 'orange-juice'     THEN 'drink'
    WHEN 'soda'             THEN 'drink'
    WHEN 'blt'              THEN 'sandwich'
    WHEN 'grilled-cheese'   THEN 'sandwich'
    WHEN 'tikka-masala'     THEN 'dinner'
    WHEN 'chicken-parm'     THEN 'dinner'
     ELSE 'other' 
  END AS category,
  ROUND(1.0 * SUM(amount_paid) / (SELECT SUM(amount_paid) FROM order_items) * 100.0, 2) as pct
FROM order_items
GROUP BY 1
ORDER BY 2 DESC
LIMIT 100;

-- Let’s calculate the reorder ratio for all of SpeedySpoon’s products and take a look at the results.
SELECT name,
  COUNT(DISTINCT(order_id))
FROM order_items
GROUP BY 1
ORDER BY 1;

-- Now we need the number of people making these orders.
SELECT name,
  ROUND(1.0 * COUNT(DISTINCT(order_items.order_id)) / COUNT(DISTINCT(orders.delivered_to)), 2) as reorder_rate
FROM order_items
JOIN orders 
  ON order_items.order_id = orders.id
GROUP BY 1
ORDER BY 2 DESC;
