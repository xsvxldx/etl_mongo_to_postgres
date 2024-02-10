# Overview of the Project

This project encompasses an end-to-end analytics pipeline deployed mostly on AWS. It involves the design and setup of the data warehouse, the ETL pipelines, and generation of reports. In short, the solution implemented ingests data from a MongoDB database, does some processing in a Python program running on an EC2 instance, and loads the data in a PostgreSQL database. The data collected comes from a crop environment monitoring network.

The goal for the first stage is to generate reports on Looker Data Studio to keep track of the performance of the monitoring stations that constitute the network. Each station has a solar panel and a battery, and a set of sensors that monitor humidity, temperature, ground temperature, and/or atmospheric pressure. Besides the sensors readings, stations send "metadata" reflecting their overall state; solar panel voltage, battery voltage and wifi.

For the first stage, we worked on the infrastructure in AWS setting up an account (free tier), a PostgreSQL database (RDS) as the data warehouse, and an EC2 instance which runs a Python program that does the ETL process.

## Business Logic


## Infrastructure

## Architecture


## Ingestion


## Transformation


## Load