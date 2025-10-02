

USE magist123; 

# -- SELECT COUNT(order_id) AS amount_of_orders, 
--         YEAR(order_purchase_timestamp) AS year_ordered,
--         MONTH(order_purchase_timestamp) As month_ordered
-- 	FROM orders
--     GROUP BY year_ordered, month_ordered
--     ORDER BY year_ordered DESC;alter


    SELECT  DISTINCT product_category_name_english  AS category_name,
			COUNT(product_id) AS count_of_product
		FROM products
        INNER JOIN product_category_name_translation
        on products.product_category_name = product_category_name_translation.product_category_name
		-- WHERE product_category_name_english in ('computers_accessories', 'telephony', 'electronics','computers')
        GROUP BY 
			category_name
		ORDER BY count_of_product DESC;
    

-- 2.2. In relation to the sellers:
-- 1. How many months of data are included in the magist database?

SELECT 
		YEAR(order_purchase_timestamp) AS year,
    COUNT(DISTINCT MONTH(order_purchase_timestamp)) AS month_of_purchase
FROM orders
GROUP BY year
ORDER BY year DESC;

-- Answer. We have 25 months of data


-- 2.  How many sellers are there? 
-- ANSWER: '3095'
SELECT 
	COUNT(DISTINCT seller_id) 
    FROM sellers;



-- 2.1 How many Tech sellers are there?
-- ANSWER - Only Electronics = 'electronics', '149'
	-- ('computers_accessories', 'telephony', 'electronics') = 585 
       -- telephony sellers are 149, and computer accessoroeis 287


SELECT 
    SUM(DISTINCT sellers.seller_id) AS amount_of_sellers
    FROM sellers
    LEFT JOIN order_items
		ON sellers.seller_id = order_items.seller_id
    INNER JOIN products 
		ON order_items.product_id = products.product_id
	INNEr JOIN product_category_name_translation
    ON products.product_category_name = product_category_name_translation.product_category_name
    WHERE product_category_name_english in ('computers' , 'computers_accessories',
                'pc_gamer',
                'electronics',
                'consoles_games',
                'tablets_printing_image',
                'telephony',
                'fixed_telephony',
                'cine_photo')
;

    
-- 2.2 What percentage of overall sellers are Tech sellers?
-- Only Electronics '149'/3095 = 5%
	-- ('computers_accessories', 'telephony', 'electronics') = 585 / 3095 = 19%
       -- telephony sellers are 149 /3095 = 5%
       -- and computer accessoroeis 287/3095 = 10%


-- 3. What is the total amount earned by all sellers? 
SELECT
	product_id, 
    price, 
    freight_value,
    seller_id 
FROM order_items
ORDER BY product_id DESC; 

SELECT SUM(price - freight_value) AS total_earned_by_all_sellers -- seller_id 
FROM order_items;
-- GROUP BY seller_id; 


-- What is the total amount earned by all Tech sellers?

SELECT 
    SUM(price-freight_value),COUNT(DISTINCT order_items.seller_id) AS amount_of_sellers,
CASE 
	WHEN product_category_name_english in ('computers' , 'computers_accessories',
                'pc_gamer',
                'electronics',
                'consoles_games',
                'tablets_printing_image',
                'telephony',
                'fixed_telephony',
                'cine_photo') THEN 'tech'
        ELSE 'not_tech' 
	END AS "tech_or_not"
    FROM sellers
    LEFT JOIN order_items
		ON sellers.seller_id = order_items.seller_id
    INNER JOIN products 
		ON order_items.product_id = products.product_id
	INNER JOIN product_category_name_translation
    ON products.product_category_name = product_category_name_translation.product_category_name
    GROUP BY tech_or_not
    HAVING tech_or_not = ('tech'); 
    
    -- total earned by tech products ''1549857.4657451808', 'sellers -484',


    

-- 4. Can you work out the average monthly income of all sellers? 

-- SELECT    seller_id,
--     ROUND(AVG(monthly_income), 2) AS avg_monthly_income
-- FROM (

-- 	SELECT 
-- 		seller_id,
--         YEAR(order_purchase_timestamp) AS yr,
--         MONTH(order_purchase_timestamp) AS mnth,
--         SUM(price-freight_value) AS monthly_income
-- 	FROM order_items
-- 	INNER JOIN orders
-- 		ON order_items.order_id = orders.order_id
-- 	GROUP BY seller_id,yr,mnth) 
--     AS monthly_data
-- GROUP BY monthly_data;


SELECT 
    seller_id,
    ROUND(AVG(monthly_income), 2) AS avg_monthly_income
FROM (
    SELECT 
        seller_id,
        YEAR(order_purchase_timestamp) AS yr,
        MONTH(order_purchase_timestamp) AS mnth,
        SUM(price - freight_value) AS monthly_income
    FROM order_items
    INNER JOIN orders
        ON order_items.order_id = orders.order_id
    GROUP BY seller_id, YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp)
) AS monthly_data
GROUP BY seller_id
ORDER BY avg_monthly_income DESC;

-- ROUND((AVG(price-freight_value))/COUNT(DISTINCT MONTH(order_purchase_timestamp)),2) AS avg_monthly_income, 
-- seller_id








 -- the average monthly income of Tech sellers?


 
 
 SELECT 
    seller_id,
    ROUND(AVG(monthly_income), 2) AS avg_monthly_income,
    MAX(category) AS category, 
   

FROM (
    SELECT 
        DISTINCT seller_id,
        YEAR(order_purchase_timestamp) AS yr,
        MONTH(order_purchase_timestamp) AS mnth,
        SUM(price - freight_value) AS monthly_income,
        CASE 
            WHEN product_category_name_english IN (
                'computers', 'computers_accessories',
                'pc_gamer', 'electronics',
                'consoles_games', 'tablets_printing_image',
                'telephony', 'fixed_telephony',
                'cine_photo'
            ) THEN 'tech'
            ELSE 'not_tech'
        END AS category
    FROM order_items
    INNER JOIN orders
        ON order_items.order_id = orders.order_id
    INNER JOIN products
        ON order_items.product_id = products.product_id
    INNER JOIN product_category_name_translation
        ON products.product_category_name = product_category_name_translation.product_category_name
    GROUP BY seller_id, YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp), category
) AS monthly_data
GROUP BY seller_id
ORDER BY avg_monthly_income;



SELECT * FROM customers
LEFT JOIN geo USING sell
ORDER BY customer_zip_code_prefix;









