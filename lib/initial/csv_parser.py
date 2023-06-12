import csv
import json
import uuid


# Example usage
csv_file = './import.csv'
with open(csv_file, 'r') as file:
    json_payload = []
    reader = csv.reader(file)

    for row in reader:
        property_id = str(uuid.uuid4())

        address = row[0]
        price_state = "PriceState.sold"
        price_amount = float(row[14].replace("$", "").replace(",", ""))

        property_type = "PropertyType.house"

        property_assessment_map = {
            "3ab17d24-3c0c-4c6d-bbfe-b2b51a1f6475": {
                "criteriaId": "3ab17d24-3c0c-4c6d-bbfe-b2b51a1f6475",
                "notes": [
                    {
                        "noteId": str(uuid.uuid4()),
                        "expandedValue": row[2],
                        "headerValue": "Comment",
                        "isExpanded": False
                    }
                ],
                "criteriaName": "Condition",
                "weighting": 0.15,
                "score": int(row[1])
            },
            "b46a77a5-7375-469c-aa90-fd3bedf45fb5": {
                "criteriaId": "b46a77a5-7375-469c-aa90-fd3bedf45fb5",
                "notes": [
                    {
                        "noteId": str(uuid.uuid4()),
                        "expandedValue": row[4],
                        "headerValue": "Comment",
                        "isExpanded": False
                    }
                ],
                "criteriaName": "Layout",
                "weighting": 0.15,
                "score": int(row[3])
            },
            "e6a64aac-ca81-4527-98f0-f68f8c724d8c": {
                "criteriaId":  "e6a64aac-ca81-4527-98f0-f68f8c724d8c",
                "notes": [
                    {
                        "noteId": str(uuid.uuid4()),
                        "expandedValue": row[6],
                        "headerValue": "Comment",
                        "isExpanded": False
                    }
                ],
                "criteriaName": "School",
                "weighting": 0.2,
                "score": int(row[5])
            },
            "446f477a-30e2-4e7d-991f-16f1536901dd": {
                "criteriaId": "446f477a-30e2-4e7d-991f-16f1536901dd",
                "notes": [
                    {
                        "noteId": str(uuid.uuid4()),
                        "expandedValue": row[8],
                        "headerValue": "Comment",
                        "isExpanded": False
                    }
                ],
                "criteriaName": "Amenities",
                "weighting": 0.2,
                "score": int(row[7])
            },
            "4339eadd-1247-4221-81b3-fc90cc00ef55": {
                "criteriaId": "4339eadd-1247-4221-81b3-fc90cc00ef55",
                "notes": [
                    {
                        "noteId": str(uuid.uuid4()),
                        "expandedValue": row[10],
                        "headerValue": "Comment",
                        "isExpanded": False
                    }
                ],
                "criteriaName": "Land Value",
                "weighting": 0.2,
                "score": int(row[9])
            },
            "d2d3f510-39d8-44d3-89a7-4bcfb75d111e": {
                "criteriaId":  "d2d3f510-39d8-44d3-89a7-4bcfb75d111e",
                "notes": [
                    {
                        "noteId": str(uuid.uuid4()),
                        "expandedValue": row[12],
                        "headerValue": "Comment",
                        "isExpanded": False
                    }
                ],
                "criteriaName": "Transport",
                "weighting": 0.1,
                "score": int(row[11])
            }
        }

        record = {
            "propertyId": property_id,
            "address": address,
            "price": {
                "state": price_state,
                "amount": price_amount
            },
            "propertyType": property_type,
            "propertyAssessmentMap": property_assessment_map,
            "isSelected": False
        }

        json_payload.append(record)


output_file = './properties.json'

# Write JSON data to the output file
with open(output_file, 'w') as file:
    json.dump(json_payload, file, indent=4)
