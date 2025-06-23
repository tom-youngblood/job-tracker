# 🔍 Job Tracker Pipeline

A fully containerized data engineering pipeline that scrapes LinkedIn job listings, loads them into Snowflake, transforms the data with DBT, and visualizes job insights in Apache Superset.

## 📦 Tech Stack

- **Airflow (Docker)** – orchestrates scraping, ingestion, and transformations
- **Apify** – scrapes LinkedIn job data via public actors
- **Snowflake** – cloud data warehouse for storing raw + enriched job data
- **DBT** – transforms and deduplicates job data
- **Superset** – dashboards for visualizing job matches and application progress

## ✍🏻 Pipeline Architecture

### 🏗️ Overall Architecture

```mermaid
graph TB
    subgraph "External Sources"
        A[LinkedIn Job Scraper<br/>Apify API]
        B[Manual Job Applications]
    end
    
    subgraph "Data Pipeline"
        C[Airflow DAG<br/>job_scraper_dag.py]
        D[Raw Data Storage<br/>Snowflake Tables]
        E[DBT Transformations]
        F[Analytics Layer<br/>Snowflake Tables]
    end
    
    subgraph "Visualization"
        G[Apache Superset<br/>Dashboards]
    end
    
    A --> C
    B --> C
    C --> D
    D --> E
    E --> F
    F --> G
```

### 📊 Database Schema & Table Relationships

```mermaid
erDiagram
    SCRAPES {
        string scrape_id PK
        timestamp run_at
        string search_keyword
        string location_id
        integer jobs_found
        timestamp created_at
        timestamp updated_at
    }
    
    COMPANIES {
        string company_id PK
        string name
        string company_url
        text description
        integer staff_count
        array industries
        string logo_url
        timestamp created_at
        timestamp updated_at
    }
    
    JOBS {
        string job_id PK
        string job_title
        string job_url
        string location
        string remote_status
        timestamp posted_at
        string job_type
        boolean is_easy_apply
        text description
        string employment_status
        string experience_level
        boolean is_remote_allowed
        string company_id FK
        string scrape_id FK
        timestamp created_at
        timestamp updated_at
    }
    
    SALARIES {
        string job_id PK,FK
        float min_salary
        float max_salary
        string currency_code
        timestamp created_at
        timestamp updated_at
    }
    
    APPLICATION_STATUS {
        string job_id PK,FK
        string status
        text notes
        timestamp last_updated
        timestamp created_at
        timestamp updated_at
    }
    
    SCRAPES ||--o{ JOBS : "contains"
    COMPANIES ||--o{ JOBS : "posts"
    JOBS ||--o| SALARIES : "has"
    JOBS ||--o| APPLICATION_STATUS : "tracks"
```

### 🔄 DBT Model Dependencies

```mermaid
graph TD
    subgraph "Raw Sources"
        R1[raw.scrapes]
        R2[raw.companies]
        R3[raw.jobs]
        R4[raw.salaries]
        R5[raw.application_status]
    end
    
    subgraph "Staging Layer"
        S1[stg_scrapes]
        S2[stg_companies]
        S3[stg_jobs]
        S4[stg_salaries]
        S5[stg_application_status]
    end
    
    subgraph "Marts Layer"
        M1[dim_companies]
        M2[fact_jobs]
    end
    
    R1 --> S1
    R2 --> S2
    R3 --> S3
    R4 --> S4
    R5 --> S5
    
    S2 --> M1
    S1 --> M2
    S3 --> M2
    S4 --> M2
    S5 --> M2
    M1 --> M2
```

### 🚀 Airflow DAG Flow

```mermaid
graph LR
    subgraph "Job Scraper DAG"
        A[scrape_jobs<br/>LinkedIn Scraper]
        B[load_raw_data<br/>Load to Snowflake]
        C[enrich_job_descriptions<br/>Enrich Data]
        D[load_enriched_data<br/>Update Snowflake]
        E[run_dbt<br/>Transform Data]
    end
    
    A --> B
    B --> C
    C --> D
    D --> E
```

### 🐳 Docker Services Architecture

```mermaid
graph TB
    subgraph "Docker Compose Services"
        subgraph "Database"
            DB[(PostgreSQL<br/>Airflow Metadata)]
        end
        
        subgraph "Data Processing"
            AF[Apache Airflow<br/>Port 8080]
            DBT[DBT Core<br/>Transformations]
        end
        
        subgraph "Visualization"
            SS[Apache Superset<br/>Port 8088]
        end
        
        subgraph "External"
            SF[(Snowflake<br/>Data Warehouse)]
        end
    end
    
    AF --> DB
    AF --> SF
    DBT --> SF
    SS --> SF
```

### 📈 Data Flow Timeline

```mermaid
sequenceDiagram
    participant A as Apify Scraper
    participant AF as Airflow
    participant SF as Snowflake
    participant DBT as DBT
    participant SS as Superset
    
    Note over A,SS: Daily Job Scraping Process
    
    A->>AF: Trigger scraping task
    AF->>A: Execute LinkedIn scraper
    A->>AF: Return job data
    AF->>SF: Load raw data to Snowflake
    AF->>AF: Enrich job descriptions
    AF->>SF: Update enriched data
    AF->>DBT: Trigger DBT transformations
    DBT->>SF: Run staging models
    DBT->>SF: Run marts models
    DBT->>SS: Refresh dashboards
    SS->>SF: Query analytics tables
    SS->>SS: Update visualizations
```

### 🎯 Key Metrics & KPIs

```mermaid
graph LR
    subgraph "Job Tracking Metrics"
        M1[Jobs Scraped<br/>Daily Count]
        M2[Companies<br/>Unique Count]
        M3[Salary Ranges<br/>Average/Min/Max]
        M4[Remote Jobs<br/>Percentage]
        M5[Application Status<br/>Applied/Interviewing/Rejected]
    end
    
    subgraph "Pipeline Health"
        H1[Scraping Success Rate]
        H2[Data Quality Score]
        H3[Processing Time]
        H4[Error Rate]
    end
```

### 🔧 Technology Stack

```mermaid
graph TB
    subgraph "Data Sources"
        T1[LinkedIn Jobs API]
        T2[Apify Scraper]
    end
    
    subgraph "Orchestration"
        T3[Apache Airflow]
        T4[Python Scripts]
    end
    
    subgraph "Storage"
        T5[Snowflake Data Warehouse]
        T6[PostgreSQL Metadata]
    end
    
    subgraph "Transformation"
        T7[DBT Core]
        T8[SQL Models]
    end
    
    subgraph "Visualization"
        T9[Apache Superset]
        T10[Dashboards & Charts]
    end
    
    subgraph "Infrastructure"
        T11[Docker Compose]
        T12[Container Orchestration]
    end
    
    T1 --> T3
    T2 --> T3
    T3 --> T5
    T3 --> T6
    T5 --> T7
    T7 --> T8
    T8 --> T5
    T5 --> T9
    T9 --> T10
    T11 --> T12
``` 