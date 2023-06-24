CREATE TABLE `Dim_Brand` (
  `Brand_id` int PRIMARY KEY,
  `Brand_name` string
);

CREATE TABLE `Dim_Category` (
  `Category_id` int PRIMARY KEY,
  `breadcrumb_category_id` string,
  `breadcrumb_name` string
);

CREATE TABLE `Dim_Product` (
  `Product_id` int PRIMARY KEY,
  `Sku` string,
  `Product_name` string,
  `Description_short` string,
  `Day_ago_created` float,
  `Fulfillment_type` string,
  `Inventory_status` string
);

CREATE TABLE `Fact_Sales` (
  `Sales_id` int PRIMARY KEY,
  `All_time_quantity_sold` float,
  `Quantity_sold` float,
  `Original_price` float,
  `Price` float,
  `Discount` float,
  `Discount_rate` float,
  `List_price` float,
  `Price_usd` float,
  `Order_count` int,
  `Product_id` int,
  `Brand_id` int,
  `Category_id` int
);

ALTER TABLE `Fact_Sales` ADD FOREIGN KEY (`Product_id`) REFERENCES `Dim_Product` (`Product_id`);

ALTER TABLE `Fact_Sales` ADD FOREIGN KEY (`Brand_id`) REFERENCES `Dim_Brand` (`Brand_id`);

ALTER TABLE `Fact_Sales` ADD FOREIGN KEY (`Category_id`) REFERENCES `Dim_Category` (`Category_id`);
