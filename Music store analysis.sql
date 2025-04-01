/* Q1: Who is the senior most employee based on the job title? */

Method 1:

select first_name, last_name, title, levels
from employee
where levels = 'L7'
group by title, first_name, last_name, levels;

Method 2:

select * from employee
order by levels desc
limit 1

/* Q2: Which country has the most invoice? */

select count(*) as count_of_invoice, billing_country
from invoice
group by billing_country
order by count_of_invoice desc


/* Q3: What are top three of total invoice? */

select * from invoice
order by total desc
limit 3

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals? */

select billing_city, SUM(cast(total as decimal)) as total_invoice
from invoice
group by billing_city
order by total_invoice desc
limit 1;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money?*/

select customer.customer_id, first_name, last_name, max(total) as max_invoice
from customer
join invoice ON customer.customer_id = invoice.customer_id
group by customer.customer_id, first_name, last_name
order by max_invoice desc
limit 1;

/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

select distinct customer.email, customer.first_name, customer.last_name, genre.name 
from customer
join invoice on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on track.track_id = invoice_line.track_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
order by email asc;



/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10;

/* Q8: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount.  */

with Customter_with_country as (
		select customer.customer_id,first_name,last_name,billing_country, sum(cast(total as decimal)) as total_spending,
	    row_number() over(partition by billing_country order by sum(cast(total as decimal)) desc) as Row_No 
		from invoice
		join customer on customer.customer_id = invoice.customer_id
		group by 1,2,3,4
		order by 4 asc,5 desc)
select * from Customter_with_country where RowNo <= 1