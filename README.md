# SYOS (Synex Outlet Store) Billing and Inventory System

## Introduction

**SYOS** is a web-based, multi-tier, multi-user client-server application designed for **Synex Outlet Store** in Colombo. The system enables efficient customer transaction handling, billing, and inventory management in a concurrent environment. By minimizing manual errors, improving transaction speed during peak hours, and maintaining up-to-date inventory, the system significantly enhances overall store operations.

The application adheres to **SOLID principles** and **clean coding practices**, ensuring a robust, maintainable, and scalable codebase. It leverages **13 design patterns** to provide flexibility and maintainability.

As a concurrent web application, **SYOS** allows multiple users to interact with the system simultaneously. Each user session is managed using **token-based session isolation**, ensuring independent operations without interference between users. This concurrent model is made possible through the use of **Java Servlets** running on **Apache Tomcat**, which manages multi-threading for each incoming request.

## Prerequisites

Ensure the following **JAR** files are included in the `lib` folder of your project:

- **servlet-api**: For creating and managing Java servlets.
- **MySQL Connector**: For connecting the application to a MySQL database.
- **Tomcat Server**: Apache Tomcat is required to deploy and run this web-based application.

You can download these libraries and add them to the `lib` folder in your project directory.

## Running the Application

1. Ensure that all necessary **JAR** files, including the servlet-api and database connectors, are in the `lib` folder.
2. Set up **Apache Tomcat** as your local server. Configure Tomcat to point to the web application directory and deploy the application using the **Tomcat manager**.
3. Configure the **database connection**, and ensure that a **MySQL database** is running.
4. Compile the application using your preferred **IDE** or **build tool**.
5. Once compiled, start the **Tomcat server**, and access the application via the web browser using the appropriate URL for the deployed web application.

**SYOS** allows multiple clients to interact with the system concurrently, managing billing, transactions, and inventory without conflicts across user sessions.

---

Thank you for using the **SYOS Billing and Inventory System**!
