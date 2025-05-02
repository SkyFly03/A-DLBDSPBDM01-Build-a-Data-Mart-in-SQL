# DLBDSPBDM01 – Build a Data Mart in SQL 


## Task: Develop a Relational Database for an Airbnb-style Booking System  

## Project Overview

- This project delivers a structured SQL database for an Airbnb-style booking system.
- Developed in **MySQL 8.x** and visualized with an **ERD in MySQL Workbench**, the system supports all core functions like: bookings, rentals, reviews, and transactions.
- It includes test data and validated queries for real-world use cases.

## 1. Objectives

- Design a normalized schema with 22+ interrelated entities  
- Implement foreign key relationships and referential integrity  
- Populate test data (20+ rows per table)  
- Write and verify multi-table join queries  
- Document schema, metadata, and use case validation  

## 2. Entity Relationship Diagram (ERD) 

- Created in **MySQL Workbench** ![image](https://github.com/user-attachments/assets/91fc5c0c-04fa-4071-b920-8f1a5234a8a6)
- 25 entities including recursive and ternary relationships
- Uses Chen notation for cardinality and structure
 
![image](https://github.com/user-attachments/assets/f10d0650-6b30-4f6f-a975-023891e5f853)

## 3. Installation & Setup

1. **Install MySQL Tools**
   - [MySQL Community Server](https://dev.mysql.com/downloads/installer/)
   - [MySQL Workbench](https://dev.mysql.com/downloads/workbench/)

2. **Clone the Repository**
   ```bash
   git clone https://github.com/SkyFly03/DLBDSPBDM01-Build-a-Data-Mart-in-SQL.git

3. **Run SQL Script**

   - Open `SQL-Datafile_airbnb_datamart_sky_MySQL_code.sql` located in `Phase 2 - Development Phase`
   - Execute the script in **MySQL Workbench**:
      - This creates the full schema with all tables and relationships
      - Inserts test data into each table (20+ rows per table)
   - Ensure foreign key checks are enabled again at the end of the script


## 4. Technical Highlights

- Developed in **MySQL 8.x**, using **MySQL Workbench**
- 22+ normalized tables with referential integrity
- Realistic test data simulating bookings, payments, and reviews
- ERD designed with recursive and ternary relationships using Chen notation
- Includes customer service tracking, event management, notifications, and promotions
- Validated via multi-join SQL queries for data quality and relationship testing

## 5. Folder Structure

- `Phase 1 - Conception Phase` – ER diagrams, requirements summary, data dictionary  
- `Phase 2 - Development Phase` – SQL schema, insert scripts, validation queries  
- `Phase 3 - Finalisation Phase` – Abstract, metadata `.xlsx`, screenshots

## 6. Use Case

The database simulates a production-ready backend for a vacation rental platform and can be extended to support:

- BI dashboards and analytics
- Host performance metrics
- Reservation lifecycle tracking
- Customer loyalty and service evaluation
- Integration with applications or frontend systems

## 7. License

This project is intended solely for educational and academic use as part of the IU Bachelor of Data Science program.
