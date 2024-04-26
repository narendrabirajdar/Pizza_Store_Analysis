-- Advanced:
-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.category,
    ROUND((SUM(order_details.quantity * pizzas.price) / (SELECT 
                    SUM(order_details.quantity * pizzas.price)
                FROM
                    order_details
                        JOIN
                    pizzas ON order_details.pizza_id = pizzas.pizza_id)) * 100,
            2) AS rev_by_percentage
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.category;

-- Analyze the cumulative revenue generated over time.
select order_date, round(sum(revenue) over (order by order_date),2) as cumulative_revenue from
(select orders.order_date, round(sum(order_details.quantity * pizzas.price),2) as revenue
from order_details
join orders on orders.order_id = order_details.order_id
join pizzas on pizzas.pizza_id=order_details.pizza_id
group by orders.order_date) aS sales;


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
-- cte

select name, category, revenue from 
(select category, name, revenue, rank() over (partition by category order by revenue desc)
as top_3_pizza from
(select pizza_types.name, pizza_types.category, 
sum(order_details.quantity * pizzas.price) as revenue
from pizza_types
join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name, pizza_types.category) as rev_by_cat) as top_3 
where top_3_pizza <=3;