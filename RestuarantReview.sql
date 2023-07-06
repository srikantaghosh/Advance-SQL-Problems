# Question: Write a query to find the top 5 restaurants with the highest average ratings among the top 3 most popular cuisines based on the number of orders placed for each cuisine.

# Schema:
CREATE TABLE restaurant_reviews (
  review_id INT,
  restaurant_id INT,
  customer_id INT,
  rating DECIMAL(2, 1),
  review_date DATE
);

CREATE TABLE orders (
  order_id INT,
  customer_id INT,
  order_date DATE
);

CREATE TABLE order_items (
  order_id INT,
  item_id INT,
  cuisine VARCHAR(50)
);


# Sample Date
-- restaurant_reviews
INSERT INTO restaurant_reviews (review_id, restaurant_id, customer_id, rating, review_date)
VALUES
  (1, 1, 101, 4.5, '2023-01-01'),
  (2, 1, 102, 4.0, '2023-01-02'),
  (3, 2, 103, 4.8, '2023-01-03'),
  (4, 2, 104, 4.2, '2023-01-04'),
  (5, 3, 105, 4.7, '2023-01-05'),
  (6, 3, 106, 3.9, '2023-01-06');

-- orders
INSERT INTO orders (order_id, customer_id, order_date)
VALUES
  (1, 101, '2023-01-01'),
  (2, 102, '2023-01-02'),
  (3, 103, '2023-01-03'),
  (4, 104, '2023-01-04'),
  (5, 105, '2023-01-05'),
  (6, 106, '2023-01-06');

-- order_items
INSERT INTO order_items (order_id, item_id, cuisine)
VALUES
  (1, 1, 'Italian'),
  (2, 2, 'Indian'),
  (3, 3, 'Chinese'),
  (4, 4, 'Italian'),
  (5, 5, 'Indian'),
  (6, 6, 'Chinese'),
  (6, 7, 'Chinese');


# Solution:

WITH top_cuisine AS (
  SELECT cuisine,
  COUNT(order_id) AS orders
  FROM order_items 
  GROUP BY cuisine
  ORDER BY orders DESC
  LIMIT 3
),
ratings AS (
  SELECT restaurant_id,
  AVG(rating) AS rating,
  RANK() OVER (ORDER BY AVG(rating) DESC) AS rank
  FROM restaurant_reviews r
  JOIN orders o ON r.customer_id = o.customer_id
  JOIN order_items i ON o.order_id = i.order_id
  WHERE cuisine IN (SELECT DISTINCT cuisine FROM top_cuisine)
  GROUP BY restaurant_id
)
SELECT restaurant_id, rating
FROM ratings
WHERE rank <= 5;


# It identifies the top 3 cuisines based on the number of orders and then calculates the average rating for each restaurant within those cuisines.
# The final query retrieves the top 5 restaurants based on their ratings.
  
  
