USE saklia;

# Exercise 1
DELIMITER //

CREATE PROCEDURE GetCustomersRentingActionMovies()
BEGIN
  SELECT first_name, last_name, email
  FROM customer
  JOIN rental ON customer.customer_id = rental.customer_id
  JOIN inventory ON rental.inventory_id = inventory.inventory_id
  JOIN film ON film.film_id = inventory.film_id
  JOIN film_category ON film_category.film_id = film.film_id
  JOIN category ON category.category_id = film_category.category_id
  WHERE category.name = 'Action'
  GROUP BY first_name, last_name, email;
END //

DELIMITER ;

CALL GetCustomersRentingActionMovies();

# Exercise 2

DELIMITER //

CREATE PROCEDURE GetCustomersRentingMoviesByCategory(IN categoryName VARCHAR(255))
BEGIN
  SET @categoryName := categoryName;

  PREPARE stmt FROM '
    SELECT first_name, last_name, email
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON film.film_id = inventory.film_id
    JOIN film_category ON film_category.film_id = film.film_id
    JOIN category ON category.category_id = film_category.category_id
    WHERE category.name = ?
    GROUP BY first_name, last_name, email;
  ';

  EXECUTE stmt USING @categoryName;

  DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

CALL GetCustomersRentingMoviesByCategory('Action');

# Exercise 3 

SELECT category.name AS category_name, COUNT(*) AS movie_count
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film.film_id = film_category.film_id
GROUP BY category.name;

DELIMITER //

CREATE PROCEDURE GetCategoriesWithMovieCountGreaterThan(IN movieCountThreshold INT)
BEGIN
  SELECT category.name AS category_name, COUNT(*) AS movie_count
  FROM category
  JOIN film_category ON category.category_id = film_category.category_id
  JOIN film ON film.film_id = film_category.film_id
  GROUP BY category.name
  HAVING movie_count > movieCountThreshold;
END //

DELIMITER ;

CALL GetCategoriesWithMovieCountGreaterThan(50);
