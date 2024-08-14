---create a reference table, first 計算每月平均購買數量
with q1 as
(
select cust, prod, month, avg(quant) AVG
from sales
	group by cust, prod, month
),

---in the reference table, compute the avg-quant for the previous month
q2 as
(
select q1a.cust, q1a.prod, q1a.month, q1a.AVG c_avg, q1b.AVG prev_avg 
from q1 q1a left join q1 q1b
	on q1a.cust = q1b.cust and q1a.prod = q1b.prod and q1a.month-1 = q1b.month
),

---in the reference table, compute the avg-quant for the next month
q3 as
(
select q2.cust, q2.prod, q2.month, q2.c_avg, q2.prev_avg, q1.avg next_avg
	from q2 left join q1
	on q2.cust = q1.cust and q2.prod = q1.prod and q2.month+1 = q1.month
),


---Join the “reference” table (q3 from above) with the “sales” table to compute the final result(COUNT(Quant)) 
---count(s.quant)=>計算符合where條件下的交易數量有多少，也就是計數（並非在計算“購買數量”）
q4 as
(
select s.cust CUSTOMER, s.prod PRODUCT, s.month, count(s.quant) SALES_COUNT_BETWEEN_AVGS
    from sales s, q3 r
	where s.month = r.month
	and s.cust = r.cust and s.prod = r.prod
	and ((s.quant between r.prev_avg and r.next_avg)
	or (s.quant between r.next_avg and r.prev_avg))
    group by s.cust, s.prod, s.month
)

select * from q4 order by CUSTOMER, PRODUCT, month

