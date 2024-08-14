/* create all distinct combinations of (prod, quant) */
with q0 as
(
select distinct prod, quant
	from sales
	order by 1, 2 
),


/* compute the relative position for each combo of (prod, quant) */
pos as
(
select q0.prod, q0.quant, count(s.quant) pos
	from q0, sales s
	where q0.prod = s.prod and s.quant <= q0.quant
	group by q0.prod, q0.quant
),


/* Find the “median position" for each prod */
med_pos as
(
select prod, ceil(count(quant)/2.0) median_pos
	from sales
	group by prod
),


/* in case there are multiple median (prod, quant)’s, first collect
ALL (prod, quant) pairs whose ‘quant’ values are >= median quant */
T1 as
(
select p.prod, p.quant, p.pos
	from pos p, med_pos mp
	where p.prod = mp.prod and p.pos >= mp.median_pos
),


/* find the min(quant) which is the median quant */
T2 as
(
select prod product, min(quant) median_quant
	from T1
	group by prod
)

select * from T2 order by product