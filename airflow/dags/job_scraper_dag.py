from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
from apify_client import ApifyClient
from dotenv import getenv
import requests
import json

DEFAULT_ARGS = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2024, 1, 1),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

def run_linkedin_job_scraper():
    # Initialize the ApifyClient with your API token
    client = ApifyClient("<YOUR_API_TOKEN>")

    # Prepare the Actor input
    run_input = {
        "keywords": "engineer",
        "location": "United States",
        "page_number": 1,
        "limit": 100,
    }

    # Run the Actor and wait for it to finish
    run = client.actor("KE649tixwpoRnZtJJ").call(run_input=run_input)

    # Fetch and print Actor results from the run's dataset (if there are any)
    for item in client.dataset(run["defaultDatasetId"]).iterate_items():
        print(item)

def run_linkedin_job_description_scraper():
    pass

def load_to_snowflake():
    pass

def enrich_with_job_details():
    pass

def update_snowflake_enriched():
    pass

def run_dbt_models():
    import subprocess
    subprocess.run(['dbt', 'run'], cwd='/opt/dbt')

with DAG('job_scraper_dag', default_args=DEFAULT_ARGS, schedule_interval='@daily', catchup=False) as dag:
    scrape = PythonOperator(task_id='scrape_jobs', python_callable=run_apify_scraper)
    load_raw = PythonOperator(task_id='load_raw_data', python_callable=load_to_snowflake)
    enrich = PythonOperator(task_id='enrich_job_descriptions', python_callable=enrich_with_job_details)
    load_enriched = PythonOperator(task_id='load_enriched_data', python_callable=update_snowflake_enriched)
    transform = PythonOperator(task_id='run_dbt', python_callable=run_dbt_models)

    scrape >> load_raw >> enrich >> load_enriched >> transform 