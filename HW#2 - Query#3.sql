
with q1 as
(
select cust, prod, state, round(avg(quant),0) CURRENT_AVG
	from sales 
	group by cust, prod, state
),

q2 as
(
select q1.cust, q1.prod, q1.state, round(avg(s.quant),0) OTHER_CUST_AVG
	from q1, sales s
	where q1.prod = s.prod and q1.state = s.state and q1.cust != s.cust
	group by q1.cust, q1.prod, q1.state
),

q3 as
(
select q1.cust, q1.prod, q1.state, round(avg(s.quant),0) OTHER_PROD_AVG
	from q1, sales s
	where q1.cust = s.cust and q1.state = s.state and q1.prod != s.prod
	group by q1.cust, q1.prod, q1.state
),

q4 as
(
select q1.cust, q1.prod, q1.state, round(avg(s.quant),0) OTHER_STATE_AVG
	from q1, sales s
	where q1.cust = s.cust and q1.prod = s.prod and q1.state != s.state
	group by q1.cust, q1.prod, q1.state
),

q5 as
(
select q1.cust CUSTOMER, q1.prod PRODUCT, q1.state, q1.CURRENT_AVG PROD_AVG, q2.OTHER_CUST_AVG, q3.OTHER_PROD_AVG, q4.OTHER_STATE_AVG
	from q1, q2, q3, q4
	where q1.cust = q2.cust and q2.cust = q3.cust and q3.cust= q4.cust
	and q1.prod = q2.prod and q2.prod = q3.prod and q3.prod=q4.prod
	and q1.state = q2.state and q2.state = q3.state and q3.state = q4.state
)

select * from q5 order by CUSTOMER, PRODUCT, state