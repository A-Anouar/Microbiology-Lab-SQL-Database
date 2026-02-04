# BioBank Manager & Microbiology Analysis System 🧫

## Project Overview
This project is a specialized relational database designed for **Microbial Biobanking** and **Antibiotic Resistance (AMR) Analysis**. Unlike standard clinical databases, this system focuses on the precise management of bacterial strains, culture media, and phenotypic characterization suitable for research laboratories.

## Key Features
- **Biobanking & Inventory:** Advanced logic to track physical storage locations (Fridge/Shelf/Box/Position) with unique constraints to prevent overlap.
- **AMR & MIC Analysis:** Dedicated structures for tracking Antibiograms, including Minimum Inhibitory Concentration (MIC) values and SIR status (Susceptible/Intermediate/Resistant).
- **Phenotypic Characterization:** Management of biochemical test results (Catalase, Oxidase, etc.) linked to specific culture media.
- **Data Integrity:** Cascading deletes and strict foreign keys ensuring traceability from strain isolation to test results.

## Technologies Used
- **Database Engine:** MySQL
- **Language:** SQL (Complex Joins, Aggregation, Indexing).

## Project Structure
- `souches`: Central table for bacterial strain metadata.
- `emplacements`: Physical inventory management (Freezer mapping).
- `antibiogrammes`: Detailed resistance profiles.
- `resultats_tests`: Biochemical identification data.
