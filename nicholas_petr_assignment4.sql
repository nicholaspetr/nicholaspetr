########################## ASSIGNMENT 4a SQL ##############################

# Name: Nicholas Petr 
# Date: 10/27/2021

####### INSTRUCTIONS #######

# Read through the whole template and read each question carefully.  Make sure to follow all instructions.

# Each question should be answered with only one SQL query per question, unless otherwise stated.
# All queries must be written below the corresponding question number.
# Make sure to include the schema name in all table references (i.e. sakila.customer, not just customer)
# DO NOT modify the comment text for each question unless asked.
# Any additional comments you may wish to add to organize your code MUST be on their own lines and each comment line must begin with a # character
# If a question asks for specific columns and/or column aliases, they MUST be followed.
# Pay attention to the requested column aliases for aggregations and calculations. Otherwise, do not re-alias columns from the original column names in the tables unless asked to do so.
# Return columns in the order requested in the question.
# Do not concatenate columns together unless asked.

# Refer to the Sakila documentation for further information about the tables, views, and columns: https://dev.mysql.com/doc/sakila/en/

##########################################################################

## Desc: Joining Data, Nested Queries, Views and Indexes, Transforming Data

############################ PREREQUESITES ###############################

# These queries make use of the Sakila schema.  If you have issues with the Sakila schema, try dropping the schema and re-loading it from the scripts provided with Assignment 2.

# Run the following two SQL statements before beginning the questions:
SET SQL_SAFE_UPDATES=0;
UPDATE sakila.film SET language_id=6 WHERE title LIKE "%ACADEMY%";

############################### QUESTION 1 ###############################

# 1a) List the actors (first_name, last_name, actor_id) who acted in more then 25 movies.  Also return the count of movies they acted in, aliased as movie_count. Order by first and last name alphabetically.
SELECT 
	a.first_name, a.last_name, b.actor_id, COUNT(b.actor_id) as movie_count
FROM 
	sakila.actor a 
INNER JOIN 
	sakila.film_actor b ON a.actor_id = b.actor_id
GROUP BY
	b.actor_id
HAVING 
	COUNT(b.actor_id) > 25
ORDER BY a.first_name ASC, a.last_name ASC;


# 1b) List the actors (first_name, last_name, actor_id) who have worked in German language movies. Order by first and last name alphabetically.
SELECT 
	a.first_name, a.last_name, b.actor_id
FROM 
	sakila.actor as a
INNER JOIN 
	sakila.film_actor b ON a.actor_id = b.actor_id
INNER JOIN 
	sakila.film c ON b.film_id = c.film_id
WHERE 
	c.language_id=6
ORDER BY a.first_name ASC, a.last_name ASC;


# 1c) List the actors (first_name, last_name, actor_id) who acted in horror movies and the count of horror movies by each actor.  Alias the count column as horror_movie_count. Order by first and last name alphabetically.
SELECT 
	a.first_name, a.last_name, b.actor_id, COUNT(b.actor_id) as horror_movie_count
FROM 
	sakila.actor as a
INNER JOIN 
	sakila.film_actor b ON a.actor_id = b.actor_id
INNER JOIN 
	sakila.film_category c ON b.film_id = c.film_id
WHERE 
	c.category_id=11
GROUP BY
	b.actor_id
ORDER BY a.first_name ASC, a.last_name ASC;


# 1d) List the customers who rented more than 3 horror movies.  Return the customer first and last names, customer IDs, and the horror movie rental count (aliased as horror_movie_count). Order by first and last name alphabetically.
SELECT 
	a.first_name, a.last_name, b.customer_id, COUNT(b.customer_id) as horror_movie_count
FROM 
	sakila.customer a 
INNER JOIN sakila.rental b ON a.customer_id=b.customer_id
INNER JOIN sakila.inventory c ON b.inventory_id=c.inventory_id
INNER JOIN sakila.film_category d ON c.film_id=d.film_id
WHERE 
	d.category_id=11 
GROUP BY 
	b.customer_id
HAVING 
	COUNT(b.customer_id)>3
ORDER BY 
	a.first_name ASC, a.last_name ASC;

# 1e) List the customers who rented a movie which starred Scarlett Bening.  Return the customer first and last names and customer IDs. Order by first and last name alphabetically.
SELECT DISTINCT 
	a.first_name, a.last_name, a.customer_ID 
FROM 
	sakila.customer a
INNER JOIN sakila.rental b ON a.customer_id=b.customer_id
INNER JOIN sakila.inventory c ON b.inventory_id=c.inventory_id
INNER JOIN sakila.film_actor d ON c.film_id=d.film_id
INNER JOIN sakila.actor e ON d.actor_id=e.actor_id
WHERE 
	e.first_name='Scarlett' AND e.last_name='Bening'
ORDER BY a.first_name ASC, a.last_name ASC;


# 1f) Which customers residing at postal code 62703 rented movies that were Documentaries?  Return their first and last names and customer IDs.  Order by first and last name alphabetically.
SELECT DISTINCT 
	a.first_name, a.last_name, a.customer_ID 
FROM 
	sakila.customer a
INNER JOIN sakila.address b ON a.address_id=b.address_id
INNER JOIN sakila.rental c ON a.customer_id=c.customer_id
INNER join sakila.inventory d ON c.inventory_id=d.inventory_id
INNER JOIN sakila.film_category e ON d.film_id=e.film_id
WHERE 
	b.postal_code=62703 AND e.category_id=6
ORDER BY a.first_name ASC, a.last_name ASC;


# 1g) Find all the addresses (if any) where the second address line is not empty and is not NULL (i.e., contains some text).  Return the address_id and address_2, sorted by address_2 in ascending order.
SELECT 
	address_id, address2 
FROM 
	sakila.address 
WHERE 
	address2 IS NOT NULL AND CHAR_LENGTH(address2)>0
ORDER BY address2 ASC;


# 1h) List the actors (first_name, last_name, actor_id)  who played in a film involving a “Crocodile” and a “Shark” (in the same movie).  Also include the title and release year of the movie.  Sort the results by the actors’ last name then first name, in ascending order.
SELECT  
	a.first_name, a.last_name, a.actor_id, c.title, c.release_year
FROM 
	sakila.actor as a
INNER JOIN 
	sakila.film_actor b ON a.actor_id = b.actor_id
INNER JOIN 
	sakila.film c ON b.film_id = c.film_id
WHERE 
	c.description LIKE '%Crocodile%' AND c.description LIKE '%Shark%'
ORDER BY a.last_name ASC, a.first_name ASC;


# 1i) Find all the film categories in which there are between 55 and 65 films. Return the category names and the count of films per category, sorted from highest to lowest by the number of films.  Alias the count column as count_movies. Order the results alphabetically by category.
SELECT 
	b.name, COUNT(a.film_id) as count_movies
FROM 
	sakila.film_category a 
INNER JOIN
	sakila.category b ON a.category_id=b.category_id
GROUP BY 
	b.name
HAVING 
	COUNT(a.film_id)>54 AND COUNT(a.film_id)<66
ORDER BY 
	b.name ASC;


# 1j) In which of the film categories is the average difference between the film replacement cost and the rental rate larger than $17?  Return the film categories and the average cost difference, aliased as mean_diff_replace_rental.  Order the results alphabetically by category.
SELECT 
	b.name, AVG(c.replacement_cost-c.rental_rate) as mean_diff_replace_rental
FROM 
	sakila.film_category as a
INNER JOIN 
	sakila.category b ON a.category_id = b.category_id
INNER JOIN 
	sakila.film c ON a.film_id = c.film_id
GROUP BY 
	b.name
HAVING 
	AVG(c.replacement_cost-c.rental_rate)>17
ORDER BY b.name ASC;


# 1k) Create a list of overdue rentals so that customers can be contacted and asked to return their overdue DVDs. Return the title of the  film, the customer first name and last name, customer phone number, and the number of days overdue, aliased as days_overdue.  Order the results by first and last name alphabetically.
## NOTE: To identify if a rental is overdue, find rentals that have not been returned and have a rental date rental date further in the past than the film's rental duration (rental duration is in days)
SELECT 
	title, customer.first_name, customer.last_name, address.phone, DATEDIFF(rental.return_date, rental_date + INTERVAL film.rental_duration DAY) AS days_overdue
FROM 
	sakila.customer
INNER JOIN sakila.rental ON customer.customer_id = rental.customer_id
INNER JOIN sakila.address ON address.address_id = customer.address_id
INNER JOIN sakila.inventory ON inventory.inventory_id = rental.inventory_id
INNER JOIN sakila.film ON inventory.film_id = film.film_id
WHERE 
	DATEDIFF(return_date, rental_date) > film.rental_duration
ORDER BY title;


# 1l) Find the list of all customers and staff for store_id 1.  Return the first and last names, as well as a column indicating if the name is "staff" or "customer", aliased as person_type.  Order results by first name and last name alphabetically.
## Note : use a set operator and do not remove duplicates
SELECT 
	first_name, last_name, 'customer' AS person_type 
FROM 
	sakila.customer
WHERE 
	store_id=1
UNION SELECT 
first_name, last_name, 'staff' AS person_type 
FROM 
	sakila.staff
WHERE 
	store_id=1
ORDER BY first_name ASC, last_name ASC;


############################### QUESTION 2 ###############################

# 2a) List the first and last names of both actors and customers whose first names are the same as the first name of the actor with actor_id 8.  Order in alphabetical order by last name.
## NOTE: Do not remove duplicates and do not hard-code the first name in your query.
SELECT 
	a.first_name, a.last_name
FROM 
	sakila.customer a
INNER JOIN sakila.rental b ON a.customer_id=b.customer_id
INNER JOIN sakila.inventory c ON b.inventory_id=c.inventory_id
INNER JOIN sakila.film_actor d ON c.film_id=d.film_id
INNER JOIN sakila.actor e ON d.actor_id=e.actor_id
WHERE 
	a.first_name=e.first_name AND e.actor_id=8
UNION SELECT 
	first_name, last_name
FROM 
	sakila.actor
WHERE 
	first_name in
		(SELECT first_name FROM sakila.actor where actor_id=8)
ORDER BY last_name ASC;


# 2b) List customers (first name, last name, customer ID) and payment amounts of customer payments that were greater than average the payment amount.  Sort in descending order by payment amount.
## HINT: Use a subquery to help
SELECT DISTINCT 
    first_name, last_name, c.customer_id, amount
FROM
    sakila.customer c 
INNER JOIN
    sakila.payment p ON c.customer_id=p.customer_id
WHERE
    amount > (SELECT 
            AVG(amount)
        FROM
            sakila.payment p)
ORDER BY amount DESC;


# 2c) List customers (first name, last name, customer ID) who have rented movies at least once.  Order results by first name, lastname alphabetically.
## Note: use an IN clause with a subquery to filter customers
SELECT 
	first_name, last_name, customer_ID 
FROM 
	sakila.customer
WHERE 
	customer_id IN (SELECT
				customer_id
            FROM
				sakila.rental)
                ORDER BY first_name ASC, last_name ASC;



# 2d) Find the floor of the maximum, minimum and average payment amount.  Alias the result columns as max_payment, min_payment, avg_payment.
SELECT 
    MAX(amount) AS max_payment, 
    MIN(amount) AS min_payment, 
    AVG(amount) AS avg_payment
FROM
    sakila.payment;


############################### QUESTION 3 ###############################

# 3a) Create a view called actors_portfolio which contains the following columns of information about actors and their films: actor_id, first_name, last_name, film_id, title, category_id, category_name
CREATE VIEW sakila.actors_portfolio AS
    SELECT  
        a.actor_id, a.first_name, a.last_name, c.film_id, c.title, d.category_id, e.name 
    FROM
        sakila.actor a
	INNER JOIN
		sakila.film_actor b ON a.actor_id=b.actor_id
	INNER JOIN
		sakila.film c ON b.film_id=c.film_id
	INNER JOIN 
		sakila.film_category d ON c.film_id=d.film_id
	INNER JOIN 
		sakila.category e ON d.category_id=e.category_id;


# 3b) Describe (using a SQL command) the structure of the view.
DESCRIBE sakila.actors_portfolio;


# 3c) Query the view to get information (all columns) on the actor ADAM GRANT
select 
	* 
FROM 
	sakila.actors_portfolio
WHERE 
	first_name='ADAM' AND last_name='GRANT';


# 3d) Insert a new movie titled Data Hero in Sci-Fi Category starring ADAM GRANT
## NOTE: If you need to use multiple statements for this question, you may do so.
## WARNING: Do not hard-code any id numbers in your where criteria.
## !! Think about how you might do this before reading the hints below !!
## HINT 1: Given what you know about a view, can you insert directly into the view? Or do you need to insert the data elsewhere?
## HINT 2: Consider using SET and LAST_INSERT_ID() to set a variable to aid in your process.
INSERT INTO sakila.film (title) VALUES ('Data Hero'); 
SET @last_id_in_table1 = LAST_INSERT_ID();
INSERT INTO sakila.film_category (film_id,category_id) VALUES (@last_id_in_table1,14); 
INSERT INTO sakila.film_actor(film_id,actor_id) VALUES (@last_id_in_table1,71);


############################### QUESTION 4 ###############################

# 4a) Extract the street number (numbers at the beginning of the address) from the customer address in the customer_list view.  Return the original address column, and the street number column (aliased as street_number).  Order the results in ascending order by street number.
## NOTE: Use Regex to parse the street number
SELECT  
	address,
    regexp_replace(address, '[^0-9]', '') AS street_number
FROM 
	sakila.address
ORDER BY regexp_replace(address, '[^0-9]', '') ASC;


# 4b) List actors (first name, last name, actor id) whose last name starts with characters A, B or C.  Order by first_name, last_name in ascending order.
## NOTE: Use either a LEFT() or RIGHT() operator
SELECT  
    first_name, last_name, actor_id
FROM
    sakila.actor
WHERE
    last_name REGEXP '^(A|B|C)'
ORDER BY first_name ASC, last_name ASC;


# 4c) List film titles that contain exactly 10 characters.  Order titles in ascending alphabetical order.
SELECT 
    title
FROM
    sakila.film
WHERE
    title REGEXP '^.{10}$'
ORDER BY title ASC;    


# 4d) Return a list of distinct payment dates formatted in the date pattern that matches "22/01/2016" (2 digit day, 2 digit month, 4 digit year).  Alias the formatted column as payment_date.  Retrn the formatted dates in ascending order.
SELECT DISTINCT 
	DATE_FORMAT(payment_date, '%d-%m-%Y') AS payment_date
FROM 
	sakila.payment
ORDER BY DATE_FORMAT(payment_date, '%d-%m-%Y') ASC;


# 4e) Find the number of days each rental was out (days between rental_date & return_date), for all returned rentals.  Return the rental_id, rental_date, return_date, and alias the days between column as days_out.  Order with the longest number of days_out first.
SELECT 
    rental_id, rental_date, return_date,
    DATEDIFF(return_date, rental_date) AS days_out
FROM
    sakila.rental
ORDER BY DATEDIFF(return_date, rental_date) DESC;