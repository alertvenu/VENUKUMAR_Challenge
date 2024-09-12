import re

# Function to validate credit card numbers
def validate_credit_card(card_number):
    # Check if the card starts with 4, 5, or 6, and has exactly 16 digits (or groups of 4 digits separated by hyphens)
    pattern = r"^[456]\d{3}-?\d{4}-?\d{4}-?\d{4}$"
    if not re.match(pattern, card_number):
        return "Invalid"
    
    # Remove hyphens if present to check for consecutive repeated digits
    card_number = card_number.replace("-", "")
    
    # Check if there are 4 or more consecutive repeated digits
    if re.search(r"(\d)\1{3,}", card_number):
        return "Invalid"
    
    return "Valid"

# Input
n = int(input())  # Number of credit card numbers to validate
for _ in range(n):
    card_number = input().strip()
    print(validate_credit_card(card_number))
