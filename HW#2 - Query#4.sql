with q1 as
(
select cust, max(quant) first_max
	from sales
	where state = 'NJ'
	group by cust
),

q2 as
(
select s.cust, max(s.quant) second_max
	from sales s, q1
	where s.cust = q1.cust and s.state = 'NJ' and s.quant < q1.first_max
	group by s.cust
),

q3 as
(
select s.cust, max(s.quant) third_max
	from sales s, q2
	where s.cust = q2.cust and s.state = 'NJ' and s.quant < q2.second_max
	group by s.cust
),

q4 as
(
select *
	from q1 
	 union all 
select * 
	from q2 
	 union all 
select * 
	from q3 
),

q5 as
(
select q4.cust CUSTOMER, q4.first_max QUANTITY, s.prod PRODUCT, s.date
	from q4, sales s
	where q4.cust = s.cust and q4.first_max = s.quant and s.state = 'NJ'
)

select * from q5 order by CUSTOMER, QUANTITY desc

