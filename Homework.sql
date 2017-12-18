SELECT last_name, first_name FROM sakila.actor;
SELECT CONCAT(first_name, ' ' ,last_name) AS 'Actor Name' FROM sakila.actor;
SELECT actor_id, first_name, last_name FROM sakila.actor where first_name = 'Joe' ;
SELECT * FROM sakila.actor WHERE last_name LIKE '%GEN%' ;
SELECT * FROM sakila.actor WHERE last_name LIKE '%LI%' ORDER BY last_name ASC, first_name ASC ;
SELECT country_id, country FROM sakila.country WHERE country IN ('Afghanistan','Bangladesh','China');
ALTER TABLE sakila.actor ADD middle_name  VARCHAR(45) AFTER first_name;
ALTER TABLE sakila.actor MODIFY COLUMN middle_name MEDIUMBLOB;
ALTER TABLE sakila.actor DROP middle_name;
SELECT DISTINCT(last_name) AS last_name, COUNT(last_name) AS count FROM sakila.actor GROUP BY last_name ;
SELECT DISTINCT(last_name) AS last_name, COUNT(
last_name) AS count FROM sakila.actor GROUP BY last_name HAVING count >= 2;
UPDATE sakila.actor SET first_name='HARPO' WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
UPDATE sakila.actor SET first_name='GROUCHO' WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';
#DROP SCHEMA IF EXISTS sakila;
#CREATE SCHEMA sakila;
#USE sakila;
#CREATE TABLE address (
#address_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
#  address VARCHAR(50) NOT NULL,
# address2 VARCHAR(50) DEFAULT NULL,
#  district VARCHAR(20) NOT NULL,
# city_id SMALLINT UNSIGNED NOT NULL,
#  postal_code VARCHAR(10) DEFAULT NULL,
#  phone VARCHAR(20) NOT NULL,
#  /*!50705 location GEOMETRY NOT NULL,*/
#  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
#  PRIMARY KEY  (address_id),
#  KEY idx_fk_city_id (city_id),
#  /*!50705 SPATIAL KEY `idx_location` (location),*/
#  CONSTRAINT `fk_address_city` FOREIGN KEY (city_id) REFERENCES city (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
#)ENGINE=InnoDB DEFAULT CHARSET=utf8;
SELECT s.first_name, s.last_name, a.address FROM sakila.staff s JOIN sakila.address a ON (s.address_id = a.address_id);
SELECT  s.first_name AS FirstName , s.last_name AS Last,  COALESCE(SUM(p.amount), 0)  AS Sale FROM sakila.staff s  JOIN sakila.payment p ON (s.staff_id = p.staff_id) WHERE p.payment_date >= '2005-08-01' AND  p.payment_date <= '2005-08-31'  GROUP BY s.first_name, s.last_name;
SELECT f.title AS Title , COUNT(a.actor_id) as ACTORS FROM sakila.film_actor a INNER JOIN sakila.film f ON (a.film_id = f.film_id) GROUP BY f.title;
SELECT  (SELECT f.title FROM sakila.film f WHERE f.film_id = i.film_id) AS Film, COUNT(i.film_id) AS Copies FROM sakila.inventory i GROUP BY i.film_id;
CREATE VIEW SAKILA.FILM_VIEW AS (SELECT  (SELECT f.title FROM sakila.film f WHERE f.film_id = i.film_id) AS Film, COUNT(i.film_id) AS Copies FROM sakila.inventory i GROUP BY i.film_id);
SELECT * FROM sakila.film_view WHERE Film = 'Hunchback Impossible';

SELECT  c.first_name AS FirstName , c.last_name AS LastName,  
COALESCE(SUM(p.amount), 0)  AS 'Total Amount Paid' FROM sakila.customer c JOIN sakila.payment p ON (c.customer_id = p.customer_id)  GROUP BY c.customer_id order by c.last_name;


CREATE VIEW SAKILA.LANG AS SELECT * from sakila.film WHERE TITLE LIKE 'Q%'   UNION SELECT * from sakila.film WHERE TITLE LIKE 'K%' ;
SELECT * from sakila.lang v INNER JOIN sakila.language l ON (v.language_id =  l.language_id) WHERE l.name = 'English';


SELECT * from sakila.actor where actor_id IN (SELECT actor_id from sakila.film_actor WHERE film_id IN (SELECT film_id from sakila.film where title = 'Alone Trip'));



SELECT first_name, last_name, email from sakila.customer where 
address_id IN (SELECT address_id from sakila.address WHERE city_id IN
 (SELECT city.city_id from sakila.CITY city JOIN sakila.country ctry ON (city.country_id = ctry.country_id) WHERE ctry.country = 'Canada'));



SELECT * from sakila.film WHERE film_id IN (SELECT film_id from sakila.film_category WHERE category_id IN 
(SELECT category_id from sakila.category  where name = 'Family'));


SELECT * from sakila.rental order by rental_date desc;
SELECT i.store_id, SUM(p.amount) AS SALES from sakila.payment p INNER JOIN sakila.rental r ON (p.rental_id = r.rental_id) INNER JOIN sakila.inventory i ON (r.inventory_id = i.inventory_id)
GROUP BY i.store_id;


SELECT store_id, city, country  from sakila.store s JOIN sakila.address a ON (s.address_id = a.address_id) JOIN sakila.city c ON (a.city_id = c.city_id) JOIN sakila.country ct ON (c.country_id = ct.country_id);



 CREATE VIEW sakila.REVENUES AS SELECT film_id, SUM(DISTINCT payment_id) as Payment from sakila.payment p INNER JOIN sakila.rental r ON (p.rental_id = r.rental_id) INNER JOIN sakila.inventory i ON (r.inventory_id = i.inventory_id) GROUP BY i.film_id;
 
 
SELECT DISTINCT(name), SUM(Payment) as Sale from sakila.revenue r JOIN sakila.film_category f ON (r.film_id = f.film_id) JOIN sakila.category c ON (f.category_id = c.category_id) group by name ORDER BY Sale DESC;


DROP VIEW sakila.REVENUES;