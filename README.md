# LEGO Data Analysis (SQL)

## 📌 Overview
This project uses SQL to analyze LEGO data, focusing on LEGO sets, themes, parts, colors, and part reuse.  
Multiple LEGO tables are combined into a single analytical view for efficient analysis.

## 🗂️ Data
Tables used in this project:
- sets
- themes
- inventories
- inventory_parts
- parts
- colors

## 🔍 Analysis
This project analyzes LEGO data to uncover patterns in set design, theme composition, and part usage.  
Key analyses include:
- Identifying the largest LEGO sets by total number of parts
- Comparing themes by total and average part counts
- Measuring color diversity per set and per theme
- Finding dominant colors within each theme
- Detecting parts reused across multiple themes
- Analyzing set complexity using part count and color count

## 🛠️ Tools & Skills
The analysis is performed using SQL with a focus on analytical querying and data modeling.  
Main tools and techniques:
- SQL (MySQL)
- Views for data modeling
- Common Table Expressions (CTEs)
- Window functions
- Aggregations and ranking
- Exploratory Data Analysis (EDA)

## 📈 Key Takeaways
The analysis reveals several important insights:
- A small number of themes dominate total part usage
- Larger LEGO sets tend to have significantly higher color diversity
- Many core parts are reused across multiple themes, indicating modular design
- Theme-level analysis highlights clear differences in set complexity and design style
