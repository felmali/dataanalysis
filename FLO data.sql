SELECT * FROM flo

--2
SELECT COUNT(master_id) as müşteri_sayisi FROM flo 

--3
SELECT
SUM(customer_value_total_ever_offline) + SUM(customer_value_total_ever_online) satislar,
SUM(order_num_total_ever_offline) + SUM(order_num_total_ever_online) cirolar
FROM flo

--4
SELECT
(SUM(customer_value_total_ever_online) + SUM(customer_value_total_ever_offline)) / 
(SUM(order_num_total_ever_offline) + SUM(order_num_total_ever_online))
FROM flo

--5
SELECT last_order_channel,
SUM(customer_value_total_ever_online) + SUM(customer_value_total_ever_offline) satislar,
SUM(order_num_total_ever_offline) + SUM(order_num_total_ever_online) cirolar
FROM flo 
GROUP BY last_order_channel

--6
SELECT YEAR(first_order_date) yil,
SUM(customer_value_total_ever_online) + SUM(customer_value_total_ever_offline) satis
 FROM flo
 GROUP BY YEAR(first_order_date)

 --7
 SELECT 
 last_order_channel,
 (SUM(customer_value_total_ever_online) + SUM(customer_value_total_ever_offline)) / 
(SUM(order_num_total_ever_offline) + SUM(order_num_total_ever_online)) ciro
  FROM flo
  GROUP BY last_order_channel;

--8
SELECT master_id, customer_value_total_ever_offline, customer_value_total_ever_online 
FROM flo

--9
SELECT master_id, order_channel
FROM flo

--10
SELECT * FROM flo
WHERE NOT last_order_channel = 'Offline'

--11
SELECT * FROM flo
WHERE NOT last_order_channel = 'Offline'
AND customer_value_total_ever_online > 1000

--12
SELECT 
SUM(customer_value_total_ever_offline) offline_ciro,
SUM(customer_value_total_ever_online) online_ciro
FROM flo
WHERE order_channel = 'Mobile'

--13
SELECT * FROM flo
WHERE interested_in_categories_12 LIKE '%SPOR%'

--14
SELECT * FROM flo
WHERE customer_value_total_ever_offline BETWEEN 0  AND 10000

--15
SELECT interested_in_categories_12, order_channel, SUM(order_num_total_ever_online) online_sipariş
FROM flo
GROUP BY interested_in_categories_12, order_channel

--16
SELECT last_order_channel, interested_in_categories_12, 
SUM(order_num_total_ever_offline) + SUM(order_num_total_ever_online) satis_adeti
FROM FLO
GROUP BY last_order_channel, interested_in_categories_12
ORDER BY satis_adeti DESC

--17
SELECT TOP 50
master_id, order_num_total_ever_offline+order_num_total_ever_online satis_adeti
 FROM flo
 ORDER BY satis_adeti DESC

--18
SELECT YEAR(first_order_date) yil,
COUNT(master_id)
FROM FLO
GROUP BY first_order_date

--19
SELECT COUNT(master_id) musteri_sayisi
FROM FLO
WHERE YEAR(last_order_date) = '2020'

--20
SELECT
master_id, interested_in_categories_12, order_channel
FROM FLO
WHERE interested_in_categories_12 = '[AKTIFSPOR]'

--21
SELECT
master_id, interested_in_categories_12, order_channel
FROM FLO
WHERE interested_in_categories_12 LIKE '%AKTIFSPOR%'

--22
SELECT YEAR(first_order_date) yil, MONTH(first_order_date) ay, COUNT(DISTINCT(master_id)) müsteri_sayisi
FROM FLO 
WHERE YEAR(first_order_date) BETWEEN '2018' AND '2019'
GROUP BY YEAR(first_order_date), MONTH(first_order_date)
ORDER BY yil, ay

--23
SELECT *
FROM FLO
WHERE order_channel IN ('Mobile', 'Desktop')
AND interested_in_categories_12 NOT LIKE '%AKTIFSPOR%'

--24
SELECT * FROM flo
WHERE order_channel IN ('Mobile', 'Desktop')

--25
SELECT  TOP 1 YEAR(first_order_date) yil, MONTH(first_order_date) ay, SUM(customer_value_total_ever_online) online_ciro
FROM flo
GROUP BY YEAR(first_order_date), MONTH(first_order_date)
ORDER BY online_ciro DESC


 