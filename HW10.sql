USE sakila;

# 1a
SELECT first_name, last_name 
FROM actor;

# 1b
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name' 
FROM actor;

# 2a
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = 'Joe';

# 2b
SELECT * 
FROM actor
WHERE last_name LIKE '%GEN%';

# 2c
SELECT last_name, first_name 
FROM actor
WHERE last_name LIKE '%LI%';

# 2d
SELECT country_id, country 
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

# 3a
ALTER TABLE actor
ADD COLUMN `middle_name` VARCHAR(50) NOT NULL AFTER first_name;

SELECT * 
FROM actor;

# 3b
ALTER TABLE actor MODIFY middle_name blob;

# 3c
ALTER TABLE actor DROP COLUMN middle_name;

SELECT * 
FROM actor;

# 4a
SELECT last_name, COUNT(last_name) AS 'actor_count' 
FROM actor GROUP BY last_name;

# 4b
SELECT last_name, COUNT(last_name) AS 'actor_count' 
FROM actor
GROUP BY last_name
HAVING actor_count >= 2;

# 4c
SET SQL_SAFE_UPDATES = 0;
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
SET SQL_SAFE_UPDATES = 1;

SELECT first_name, last_name 
FROM actor
WHERE last_name = 'WILLIAMS';

# 4d
SET SQL_SAFE_UPDATES = 0;
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';
SET SQL_SAFE_UPDATES = 1;

SELECT first_name, last_name 
FROM actor
WHERE last_name = 'WILLIAMS';

# 5a?
SELECT * 
FROM address;

# 6a
SELECT staff.first_name, staff.last_name, address.address 
FROM staff
INNER JOIN address ON staff.address_id = address.address_id;

# 6b
SELECT staff.first_name, staff.last_name, payment.amount
FROM payment 
INNER JOIN staff ON staff.staff_id = payment.staff_id
WHERE payment_date >= 2005-08-01 AND payment_date <= 2005-08-31;

# 6c
SELECT film.title, COUNT(actor_id) AS 'actor_count'
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.title;

SELECT * FROM film_actor;

# 6d
SELECT * FROM inventory;

SELECT film.title, COUNT(film.film_id) AS 'inventory_count'
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
WHERE film.title = 'Hunchback Impossible';

# 6e
SELECT customer.last_name, customer.customer_id, COUNT(payment.amount) AS 'total_paid'
FROM customer
INNER JOIN payment ON customer.customer_id = payment.customer_id 
GROUP BY customer.customer_id, customer.last_name
ORDER BY customer.last_name;

# 7a
SELECT title
FROM film
WHERE language_id IN
	(
		SELECT language_id
        FROM language
        WHERE name = 'English'
	)
AND title LIKE 'K%' OR title LIKE 'Q%';

#7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
	SELECT actor_id
	FROM film_actor
	WHERE film_id IN
	(
		SELECT film_id
		FROM film
		WHERE title = 'Alone Trip'
	)
);
    
#7c
SELECT customer.first_name, customer.last_name, customer.email, country.country
FROM customer
INNER JOIN country
WHERE country.country = 'Canada' 
GROUP BY customer.first_name, customer.last_name, customer.email;

#7d
SELECT title
FROM film
WHERE film_id IN
(
	SELECT film_id
    FROM film_category
    WHERE category_id IN
    (
		SELECT category_id
        FROM category
        WHERE name = 'Family'
	)
);

#7e
SELECT film.title, COUNT(rental.rental_id) AS '# of times rented'
FROM inventory 
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
GROUP BY film.title 
ORDER BY COUNT(rental.rental_id) DESC;

#7f
SELECT staff.store_id, COUNT(payment.amount) AS 'store_total'
FROM staff 
INNER JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY staff.store_id;

#7g
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address ON address.address_id = store.address_id
INNER JOIN city ON address.city_id = city.city_id 
INNER JOIN country ON city.country_id = country.country_id
GROUP BY store.store_id; 

#7h
SELECT category.name, COUNT(payment.amount) AS 'total_amount'
FROM inventory
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY COUNT(payment.amount) DESC;

#8a
CREATE VIEW Top_5_genre AS
	SELECT category.name, COUNT(payment.amount) AS 'total_amount'
	FROM inventory
	INNER JOIN film_category ON inventory.film_id = film_category.film_id
	INNER JOIN category ON film_category.category_id = category.category_id
	INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
	INNER JOIN payment ON rental.rental_id = payment.rental_id
	GROUP BY category.name
	ORDER BY COUNT(payment.amount) DESC LIMIT 5;

#8b
SELECT * FROM Top_5_genre;

#8c
DROP VIEW Top_5_genre;
