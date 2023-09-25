import requests
import json

# Define the API URL for the NVD CVE API
nvd_api_url = "https://services.nvd.nist.gov/rest/json/cves/2.0"

# Define the parameters for the keyword search
parameters = {
    "keywordSearch": "Microsoft",
}

try:
    # Send a GET request to the NVD API with the specified parameters
    response = requests.get(nvd_api_url, params=parameters)

    # Check if the request was successful
    if response.status_code == 200:
        # Parse the JSON response
        data = response.json()

        # Extract and print the CVE entries
        for cve_item in data.get("CVE_Items", []):
            cve_id = cve_item.get("cve", {}).get("CVE_data_meta", {}).get("ID", "")
            description = cve_item.get("cve", {}).get("description", {}).get("description_data", [])[0].get("value", "")
            print(f"CVE ID: {cve_id}")
            print(f"Description: {description}")
            print("-" * 50)

    else:
        print(f"Failed to retrieve data. Status code: {response.status_code}")

except Exception as e:
    print(f"An error occurred: {str(e)}")
