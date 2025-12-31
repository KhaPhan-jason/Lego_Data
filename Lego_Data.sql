-- Create view data
create view lego_set_data as
select i.id as inventory_id,s.year as set_year,s.name as set_name,t.name as theme_name,s.set_num as set_num,s.num_parts as num_part,iss.quantity as quantity
from inventory_sets as iss join inventories as i on iss.inventory_id=i.id
join sets as s on i.set_num=s.set_num
join themes as t on s.theme_id=t.id;

create view lego_part_data as
select i.id as inventory_id, p.name as part_name,c.name as color_name,p.part_num as part_num, pc.name as cat_name,ip.quantity as quantity
from inventory_parts as ip join inventories as i on ip.inventory_id=i.id
join colors as c on ip.color_id=c.id
join parts as p on ip.part_num=p.part_num
join part_categories as pc on p.part_cat_id=pc.id;

create view lego_data as
select s.set_num as set_num,s.name as set_name, s.year as set_year, t.name as theme_name, p.part_num as part_num, p.name as part_name, c.name as color_name, ip.quantity as part_quantity
from sets as s join inventories as i on s.set_num = i.set_num
join inventory_parts as ip on i.id = ip.inventory_id
join parts as p on ip.part_num = p.part_num
join colors as c on ip.color_id = c.id
left join themes as t on s.theme_id = t.id;



-- Lego Sets
-- List all unique sets with their theme and year, ordered by year descending
select distinct set_name,theme_name,set_year
from lego_set_data
order by set_year desc;

-- Find the top 10 years with the most sets
select set_year,count(distinct set_name) as total_set
from lego_set_data
group by set_year
order by total_set desc
limit 10;

-- Find the top 10 themes with the most sets
select theme_name,count(distinct set_name) as total_set
from lego_set_data
group by theme_name
order by total_set desc
limit 10;

-- List all unique sets with the number of parts, ordered by number of parts descending
select distinct set_name,theme_name,num_part
from lego_set_data
order by num_part desc;

-- Analyze trends by year: total sets and average number of parts per set
select set_year, count(distinct set_name) as total_set,avg(num_part) as avg_parts_per_set
from lego_set_data
group by set_year
order by set_year;

-- Number of sets per theme each year
select set_year, theme_name, count(distinct set_name) as total_set
from lego_set_data
group by set_year, theme_name
order by set_year, total_set desc;

-- Find the top 10 themes with the highest total number of parts
select theme_name, sum(num_part) as total_parts
from lego_set_data
group by theme_name
order by total_parts desc
limit 10;

-- Find the largest set (most parts) per year
with rank_set as
(
select distinct set_name,theme_name,set_year,num_part,row_number() over(partition by set_year order by num_part desc) as rnk
from lego_set_data
)
select set_name,theme_name,set_year,num_part
from rank_set
where rnk=1
order by set_year desc;

-- Calculate % of sets per theme across all years
select theme_name, count(distinct set_name) * 100.0 / (select count(distinct set_name) from lego_set_data) as pct_of_total
from lego_set_data
group by theme_name
order by pct_of_total desc;

-- Calculate % of sets per theme for each year
select set_year,theme_name,count(distinct set_name) * 100.0 / sum(count(distinct set_name)) over (partition by set_year) as pct_of_total
from lego_set_data
group by set_year, theme_name
order by set_year desc, pct_of_total desc;

----------------------------------------------------------------------------------------------------------------------------------------------------

-- Lego Parts
-- Find the top 10 most used LEGO parts by total quantity
select part_name,sum(quantity) as total_quantity
from lego_part_data
group by part_name
order by total_quantity desc
limit 10;

-- Find the top 10 most used LEGO colors by total quantity
select color_name,sum(quantity) as total_quantity
from lego_part_data
group by color_name
order by total_quantity desc
limit 10;

-- Find the top 10 part categories by total quantity
select cat_name,sum(quantity) as total_quantity
from lego_part_data
group by cat_name
order by total_quantity desc
limit 10;

-- Find the top 10 most common part–color combinations by total quantity
select part_name, color_name, sum(quantity) as total_quantity
from lego_part_data
group by part_name, color_name
order by total_quantity desc
limit 10;

-- Find the top 10 parts that appear in the most LEGO sets
select part_name, count(distinct inventory_id) as num_sets
from lego_part_data
group by part_name
order by num_sets desc
limit 10;

-- Find the top 10 colors that appear in the most LEGO sets
select color_name, count(distinct inventory_id) as num_sets
from lego_part_data
group by color_name
order by num_sets desc
limit 10;

-- Analyze part diversity: number of unique parts per category
select cat_name, count(distinct part_name) as unique_parts
from lego_part_data
group by cat_name
order by unique_parts desc;

-- Calculate the average quantity of parts per category
select cat_name, avg(quantity) as avg_quantity
from lego_part_data
group by cat_name
order by avg_quantity desc;

-- Find the top 10 parts with the highest number of color variations
select part_name, count(distinct color_name) as color_count
from lego_part_data
group by part_name
order by color_count desc
limit 10;

-- Find the top 10 colors that are used for the most different parts
select color_name, count(distinct part_name) as part_count
from lego_part_data
group by color_name
order by part_count desc
limit 10;

-- Calculate the percentage contribution of each part to total part quantity
select part_name,sum(quantity) * 100.0 / sum(sum(quantity)) over () as pct_of_total
from lego_part_data
group by part_name
order by pct_of_total desc
limit 10;

-- Calculate the percentage contribution of each part category to total quantity
select cat_name,sum(quantity) * 100.0 / sum(sum(quantity)) over () as pct_of_total
from lego_part_data
group by cat_name
order by pct_of_total desc;

-- Find the top 10 most widespread part–color combinations by number of sets
select part_name, color_name, count(distinct inventory_id) as num_sets
from lego_part_data
group by part_name, color_name
order by num_sets desc
limit 10;

-- Find the most common color usage within each part category
select cat_name, color_name, sum(quantity) as total_quantity
from lego_part_data
group by cat_name, color_name
order by total_quantity desc
limit 10;

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Lego data
-- Find the top 10 sets with the highest total number of parts (by quantity)
select set_name,theme_name,set_year,count(part_quantity) as total_quantity
from lego_data
group by set_name,theme_name,set_year
order by total_quantity desc
limit 10;

-- Find the top 10 themes with the highest total number of parts
select theme_name, sum(part_quantity) as total_parts
from lego_data
group by theme_name
order by total_parts desc
limit 10;

-- Number of part, unique parts per set and number of color
select set_name,set_year,count(part_num) as total_parts,count(distinct part_num) as unique_parts, count(distinct color_name) as num_colors
from lego_data
group by set_name, set_year
order by total_parts desc
limit 10;

-- Average number of colors per set by theme
with color_per_set as 
(
select set_name,theme_name,count(distinct color_name) as num_colors
from lego_data
group by set_name, theme_name
)
select theme_name, avg(num_colors) as avg_colors_per_set
from color_per_set
group by theme_name
order by avg_colors_per_set desc;

-- Dominant color per theme
select theme_name, color_name,sum(part_quantity) as total_quantity
from lego_data
group by theme_name, color_name
order by theme_name, total_quantity desc;

-- Parts reused across many themes
select part_name, count(distinct theme_name) as num_themes
from lego_data
group by part_name
order by num_themes desc
limit 10;


