with q1 as
(
select cust, prod, month, round(avg(quant),0) AVG
from sales
	group by cust, prod, month
),

q2 as
(
select q1a.cust, q1a.prod, q1a.month, q1a.AVG c_avg, q1b.AVG prev_avg 
from q1 q1a left join q1 q1b
	on q1a.cust = q1b.cust and q1a.prod = q1b.prod and q1a.month-1 = q1b.month
),


q3 as
(
select q2.cust CUSTOMER, q2.prod PRODUCT, q2.month, q2.prev_avg BEFORE_AVG, q2.c_avg DURING_AVG , q1.avg AFTER_AVG
	from q2 left join q1
	on q2.cust = q1.cust and q2.prod = q1.prod and q2.month+1 = q1.month
)

select * from q3 order by CUSTOMER, PRODUCT, month



