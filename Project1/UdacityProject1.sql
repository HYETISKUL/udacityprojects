-- Query #1

WITH t1 AS (SELECT * 
                 FROM category c
                 JOIN film_category fc ON c.category_id = fc.category_id
                 JOIN film f ON fc.film_id = f.film_id
                 JOIN inventory i ON i.film_id = f.film_id
                 JOIN rental r ON r.inventory_id = i.inventory_id)

  SELECT t1.title AS movie_title,
         t1.name AS category_name,
         COUNT (t1.title)
    FROM t1
GROUP BY 1, 2
  HAVING t1.name IN ('Animation',
                         'Children',
                         'Classics',
                         'Comedy',
                         'Family',
                         'Music')
ORDER BY 2, 1;


-- Query #2

WITH t2 AS (SELECT *
            FROM category c
                 JOIN film_category fc ON c.category_id = fc.category_id
                 JOIN film f ON fc.film_id = f.film_id
           WHERE c.name IN ('Animation',
                            'Children',
                            'Classics',
                            'Comedy',
                            'Family',
                            'Music'))

 SELECT t2.title AS movie,
         t2.name AS category,
         t2.rental_duration,
         NTILE (4) OVER (ORDER BY rental_duration) AS quartile
    FROM t2
ORDER BY 4;


--Query #3

WITH t3 AS (SELECT *
            FROM customer c JOIN payment p ON c.customer_id = p.customer_id
           WHERE p.payment_date BETWEEN '20070101' AND '20080101') 

  SELECT TO_CHAR(DATE_TRUNC ('month', payment_date),'MM/YYYY') AS payment_month,
         first_name || ' ' || last_name AS full_name,
         COUNT (amount) AS count_permonth,
         SUM (amount) AS payment_permonth
    FROM t3
GROUP BY 1, 2
ORDER BY 4 DESC
LIMIT 10;


--Query #4

WITH t4 AS (SELECT c.name AS category,
                 NTILE (4) OVER (ORDER BY f.rental_duration) AS quartile
            FROM category c
                 JOIN film_category fc ON c.category_id = fc.category_id
                 JOIN film f ON f.film_id = fc.film_id
           WHERE c.name IN ('Animation',
                            'Children',
                            'Classics',
                            'Comedy',
                            'Family',
                            'Music')) 

  SELECT category, quartile, COUNT (*)
    FROM t4
GROUP BY 1, 2
ORDER BY 1, 2;