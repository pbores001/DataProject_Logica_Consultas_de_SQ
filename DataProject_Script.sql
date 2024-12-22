-- 1. El esquema o diagrama de la BBDD se llama DataProject_diagram.erd en la carpeta de Diagrams --


-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R'. -- 
select title as film_name, rating as rating_classification
from film
where rating = 'R';


-- 3. Encuentra los nombres de los actores que tengan un “actor_id entre 30 y 40. --
select 	actor_id,
		concat(first_name,' ', last_name) as actor_name
from actor 
where actor_id between 30 and 40;


-- 4. Obtén las películas cuyo idioma coincide con el idioma original. --
select *
from film
WHERE original_language_id IS NOT NULL AND language_id = original_language_id;


-- 5. Ordena las películas por duración de forma ascendente. --
select *
from film 
order by length;


-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen en su apellido --
select concat(first_name,' ',last_name) as actor_name 
from actor
where last_name in ('Allen');


-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film y muestra la clasificación junto con el recuento. --
select rating as rating_classification, count(*) as film_number 
from film
group by rating
order by film_number;


-- 8. Encuentra el título de todas las películas que son ‘PG13 o tienen una duración mayor a 3 horas en la tabla film. --
select title as film_title,
		rating as rating_classification,
		length as film_duration
from film
where rating = 'PG-13' or length > 180;


-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas. --
select round(stddev(replacement_cost),2) as replacement_cost_variability 
from film;


-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD. --
select max(length) as max_duration_film,
		min(length) as min_duration_film
from film;


-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día. --
select title as film_title, rental_rate, last_update as rental_date
from film
order by last_update DESC
limit 1 offset 2;


-- 12. Encuentra el título de las películas en la tabla “film que no sean ni ‘NC 17 ni ‘G en cuanto a su clasificación. --
select title as film_title, rating as rating_classification
from film
where rating not in ('NC-17','G');


-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración. --
select rating as rating_classification,
		round(avg(length)) as film_duration_average
from film
group by rating;


-- 14.Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos. --
select title as film_title, length as film_duration
from film
where length > '180';



-- 15. ¿Cuánto dinero ha generado en total la empresa? --
select sum(rental_duration * rental_rate) as total_revenue
from film;



-- 16. Muestra los 10 clientes con mayor valor de id. --
select *
from customer
order by customer_id desc
limit 10;


-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby. --
select first_name as actor_first_name,
       last_name as actor_last_name
from actor as a
inner join film_actor as fa
    on a.actor_id = fa.actor_id
inner join film as f
    on fa.film_id = f.film_id
where f.title = 'EGG IGBY';



-- 18. Selecciona todos los nombres de las películas únicos. --
select title
from Film
group by title
having COUNT(*) = 1;



-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ. --
select f.title as film_title,
		c.name as category_name,
		f.length as film_duration
from film as f
inner join film_category as fc
    on f.film_id = fc.film_id
inner join category as c
    on fc.category_id = c.category_id
where c.name = 'Comedy' and f.length > 180;


-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración. --
select c.name as category_name,
		round(avg(f.length)) as film_length_average
from category as c
inner join film_category as fc
	on c.category_id = fc.category_id
inner join film as f
	on fc.film_id = f.film_id
group by c.name
having AVG(f.length) > 110; 



-- 21. ¿Cuál es la media de duración del alquiler de las películas? --
select round(avg(rental_duration)) as rental_duration_average
from film;



-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices. --
select concat(first_name,' ', last_name) as actor_name 
from actor;



-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente --
select
    date(last_update) as rental_date, 
    count(*) as rental_count_per_day
from film
group by date(last_update)
order by rental_count_per_day desc;



-- 24. Encuentra las películas con una duración superior al promedio. --
select f.title as film_name,
       f.length as film_duration
from film AS f
where f.length > (select AVG(f2.length) from film as f2);



-- 25. Averigua el número de alquileres registrados por mes. --
select
    extract(year from last_update) as rental_year,
    extract(month from last_update) as rental_month,
    COUNT(*) as rental_count_per_month
from film
group by rental_year, rental_month
order by rental_year desc, rental_month desc;



-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado --
select round(avg(rental_duration * rental_rate),2) as total_revenue_average,
    round(stddev(rental_duration * rental_rate),2) as total_revenue_variability,
    round(variance(rental_duration * rental_rate),2) as total_revenue_variance
from film;



-- 27. ¿Qué películas se alquilan por encima del precio medio? --
select *
from film
where rental_rate > (select avg(f.rental_rate) from film as f);



-- 28. Muestra el id de los actores que hayan participado en más de 40 películas --
select actor_id, count(film_id) as film_number
from film_actor as fa
group by fa.actor_id
having count(fa.actor_id) > 40;


-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible. --
select f.title  as film_title,
	 count(i.inventory_id) as available_quantity
from film as f
left join inventory as i
	on f.film_id = i.film_id
group by f.film_id, f.title
order by available_quantity desc;



-- 30. Obtener los actores y el número de películas en las que ha actuado. --
select a.actor_id,
		concat(a.first_name,' ',a.last_name) as actor_name,
		count(fa.film_id) as film_number
from film_actor as fa
inner join actor as a
	on fa.actor_id = a.actor_id
group by a.actor_id, a.first_name, last_name
order by a.actor_id;



-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados. --
select f.film_id, f.title as film_title,
		 concat(a.first_name,' ', a.last_name) AS actor_name
from film as f
left join film_actor as fa
	on f.film_id = fa.film_id
left join actor as a
	on fa.actor_id = a.actor_id
order by f.title, concat(a.first_name,' ',a.last_name);




-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película. --
select a.actor_id,
		concat(a.first_name,' ',a.last_name) as actor_name,
		f.title as film_title
from actor as a
left join film_actor as fa
	on a.actor_id = fa.actor_id
left join film as f
	on fa.film_id = f.film_id
order by a.actor_id, film_title;



-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler. --
select f.film_id,
		f.title as film_name,
		f.rental_rate,
		f.rental_duration,
		r.inventory_id,
		r.rental_date,
		r.return_date
from film as f
left join inventory as i
	on f.film_id = i.inventory_id
left join rental as r
	on i.inventory_id = r.rental_id
order by f.film_id;



-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros. --
select c.customer_id, concat(c.first_name,' ',c.last_name) as customer_name,
	sum(p.amount) as total_spent 
from customer as c
inner join payment as p
	on c.customer_id = p.payment_id
group by c.customer_id
order by total_spent desc
limit 5;



-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'. --
select *
from actor
where first_name = 'Johnny';



-- 36. Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido. --
select first_name as Nombre, last_name as Apellido
from actor;




-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor. --
select min(actor_id) as lowest_id_actor,
		max(actor_id) as highest_id_actor 
from actor;


-- 38. Cuenta cuántos actores hay en la tabla “actorˮ. --
select count(actor_id) as actor_count
from actor;


-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente. --
select *
from actor
order by last_name;


-- 40. Selecciona las primeras 5 películas de la tabla “filmˮ. --
select *
from film
order by film_id
limit 5;


-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido? --
select first_name,
		count(*) as count_actors
from actor
group by first_name
order by count_actors desc
limit 1; 
    /*Si le quito el Limit 1, los nombres mas repetidos son Julia, Kenneth y Penelope */



-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron. --
select p.rental_id, concat(c.first_name,' ',last_name) as customer_name 
from payment as p
inner join customer as c
	on p.payment_id = c.customer_id
order by p.rental_id;



 -- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres. --
select c.customer_id,
		concat(c.first_name,' ',last_name),
		p.rental_id as rental_id
from customer as c
left join payment as p
	on c.customer_id  = p.payment_id;



-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación. --
select *
from film as f
cross join category as c;

	/*En este caso al hacer cross join estamos gerenado un resultado cartesiano o escenario hipotético. La consulta muestra todas las combinaciones posibles de
	 títulos de películas con categorías, independientemente de si realmente pertenecen a esa categoría. En la tabla film hay 1000 filas film_id,
	 sin embargo, al hacer el cross el film_id pasa a ser de 16.000 filas. En este contexto no tiene un sentido real, salvo que quisieramos simular
	 combinaciones de películas y cliente para hipotéticamente evaluar estrategias de marketing o promociones.*/


 -- 45. Encuentra los actores que han participado en películas de la categoría 'Action'. --
select concat(a.first_name,' ',a.last_name) as actor_name,
		c."name" as category_name
from actor as a
inner join film_actor as fa
	on a.actor_id = fa.actor_id
inner join film as f
	on fa.film_id = f.film_id
inner join film_category as fc
	on f.film_id = fc.film_id
inner join category as c
	on fc.category_id = c.category_id
where c."name" = 'Action';



-- 46. Encuentra todos los actores que no han participado en películas. --
select a.actor_id,
		concat(a.first_name,' ',a.last_name) as actor_name
from actor as a
left join film_actor as fa
	on a.actor_id = fa.actor_id
where fa.film_id is null;



-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado. --
select concat(a.first_name,' ',a.last_name)  as actor_name,
		count(fa.film_id) as film_number
from actor as a
inner join film_actor as fa
	on a.actor_id = fa.actor_id
group by a.first_name, a.last_name
order by a.first_name;

	/* En esta pequeña consulta corroboro como una actriz efectivamente ha participado en 14 peliculas
	select *
	from actor as a
	left join film_actor as fa
		on a.actor_id = fa.actor_id
	where a.first_name = 'EMILY' and a.last_name = 'DEE';
	*/

-- 48. Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres de los actores y el número de películas en las que han participado. --
create view actor_num_peliculas as
	select concat(a.first_name,' ',a.last_name) as actor_name,
			count(fa.film_id) as film_number 
	from actor as a
	left join film_actor as fa
	on a.actor_id = fa.actor_id
	group by a.first_name, a.last_name 
	order by a.first_name;



-- 49. Calcula el número total de alquileres realizados por cada cliente. --
select 	c.customer_id,
		concat(c.first_name,' ',c.last_name) as customer_name,
		count(r.rental_id) as total_rentals
from customer as c
left join rental as r
	on  c.customer_id = r.customer_id
group by c.customer_id
order by total_rentals desc;




-- 50. Calcula la duración total de las películas en la categoría 'Action'. --
select sum(f.length) as action_films_total_duration
from film as f
left join film_category as fc
	on f.film_id = fc.film_id
left join category as c
	on fc.category_id = c.category_id
where c."name" = 'Action';



-- 51. Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente. --

create temporary table cliente_rentas_temporal as 
	select c.customer_id, concat(c.first_name,' ',c.last_name) as customer_name,
			count(r.rental_id) as total_rentals 
	from customer as c
	left join rental as r 	
		on c.customer_id = r.customer_id
	group by c.customer_id
	order by total_rentals desc;



-- 52. Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces. --

create temporary table peliculas_alquiladas as 
	select f.film_id,
			f.title as film_title,
			count(r.rental_id) as total_rentals
	from film as f
	left join inventory as i
		on f.film_id = i.film_id
	left join rental as r
		on i.inventory_id = r.inventory_id
	group by f.film_id
	having
	    count(r.rental_id) >= 10
	order by total_rentals, f.title;




/* 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. 
Ordena los resultados alfabéticamente por título de película. */
select f.film_id,
		f.title as film_title,
		concat(c.first_name,' ',c.last_name) as customer_name 
from rental as r
left join customer as c
	on r.customer_id = c.customer_id 
left join inventory as i
	on r.inventory_id  = i.inventory_id 
left join film as f
	on i.film_id = f.film_id
where c.first_name = 'TAMMY' and c.last_name = 'SANDERS' and r.return_date is null;



/* 54. Encuentra los nombres de- los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fiʼ.
 * Ordena los resultados alfabéticamente por apellido.*/

select a.actor_id, concat(a.first_name,' ',a.last_name) as actor_name,
		count(c.category_id) as Scifi_film_number,
		f.title as film_title
from actor as a
inner join film_actor as fa
	on a.actor_id = fa.actor_id
inner join film as f
	on fa.film_id = f.film_id
inner join film_category as fc
	on f.film_id = fc.film_id
inner join category as c
	on fc.category_id = c.category_id
where c.name = 'Sci-Fi'
group by a.actor_id
order by a.last_name;



/* 55.Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus 
Cheaperʼ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido. */
select distinct a.last_name, a.first_name 
from actor as a
left join film_actor as fa 
	on a.actor_id = fa.actor_id 
left join film as f
	on fa.film_id = f.film_id
left join inventory as i 
	on f.film_id = i.film_id
left join rental as r
	on i.inventory_id = r.inventory_id
where r.rental_date > (
		select min(r2.rental_date)
		from rental as r2
		left join inventory as i2
			on r2.inventory_id = i2.inventory_id
		left join film as f2
			on i2.film_id = f2.film_id
		where f2.title = 'SPARTACUS CHEAPER'
	)
order by a.last_name, a.first_name;



-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Musicʼ. --

select concat(a.first_name,' ',a.last_name) as actor_name,
		c."name" as film_category
from actor as a
left join film_actor as fa
	on a.actor_id = fa.actor_id 
left join film as f
	on fa.film_id = f.film_id 
left join film_category as fc
	on f.film_id = fc.film_id
left join category as c
	on fc.category_id = c.category_id
		where a.actor_id not in (
			select distinct fa.actor_id
    		from film_actor as fa
    		inner join film as f
        		on fa.film_id = f.film_id
		    inner join film_category as fc
		        on f.film_id = fc.film_id
		    inner join category as c
		        on fc.category_id = c.category_id
		    where c."name" = 'Music');
		   
   
   
   
-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días. --
select f.title as film_title,
		f.rental_duration 
from film as f
where f.rental_duration > '8';

	/*No hay peliculas que fueorn alquiladas por más de 8 días.
	 Ya que el maximo de días alquilado spor película es de 7.
	 En esta consulta lo compruebo: 
		select f.title as film_title,
				f.rental_duration 
		from film as f
		where f.rental_duration >= '6'
		order by f.rental_duration ;
	*/

-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animationʼ. --
select f.title as film_title,
		c."name" 
from film as f
left join film_category as fc
	on f.film_id = fc.film_id
left join category as c
	on fc.category_id = c.category_id
where c."name" = 'Animation';



/* 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Feverʼ.
Ordena los resultados alfabéticamente por título de película. */
select f.title as film_title,
		f.length 
from film as f
where f.length = (
    select length
    from film
    where title = 'DANCING FEVER'
)
order by f.title;



-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido. --
select concat(c.first_name,' ',c.last_name) as customer_name,
		count(distinct i.film_id) as rented_films
from customer as c
left join rental as r
	on c.customer_id = r.customer_id
left join inventory as i
	on r.inventory_id = i.inventory_id
group by c.customer_id, c.first_name, c.last_name
having count(distinct i.film_id) >= 7
order by rented_films desc;


-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres. --

select c."name" as category_name,
		count(r.rental_id) as total_rental 
from category as c
left join film_category as fc
	on c.category_id = fc.category_id
left join film as f
	on f.film_id = fc.film_id
left join inventory as i 
	on f.film_id = i.film_id 
left join rental as r
	on i.inventory_id = r.inventory_id
group by category_name
order by category_name;

		/* Aquí compruebo el numero de peliculas de musica para comprobar que la consulta naterior es correcta, pues da 830 resultados 
			select c."name" as category_name,
					r.rental_id
			from category as c
			left join film_category as fc
				on c.category_id = fc.category_id
			left join film as f
				on f.film_id = fc.film_id
			left join inventory as i 
				on f.film_id = i.film_id 
			left join rental as r
				on i.inventory_id = r.inventory_id
			where c."name" = 'Music';

		*/


-- 62. Encuentra el número de películas por categoría estrenadas en 2006. --
select c."name" as category_name,
		count(r.rental_id) as total_rental,
		f.release_year 
from category as c
left join film_category as fc
	on c.category_id = fc.category_id
left join film as f
	on f.film_id = fc.film_id
left join inventory as i 
	on f.film_id = i.film_id 
left join rental as r
	on i.inventory_id = r.inventory_id
where f.release_year = '2006'
group by category_name, f.release_year 
order by category_name;




-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos. --
select *
from staff as s
cross join store as str;



/* 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de 
películas alquiladas. */
select c.customer_id,
		concat(c.first_name,' ',c.last_name) as customer_name,
		count(r.rental_id) as total_rented_films 
from customer as c
left join rental as r
	on c.customer_id = r.customer_id 
group by c.customer_id 
order by c.customer_id;



