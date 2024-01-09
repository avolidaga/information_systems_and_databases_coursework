
import random
import string
from datetime import datetime, timedelta


# Function to generate random strings
def generate_random_string(length=10):
    characters = string.ascii_letters + string.digits
    return ''.join(random.choice(characters) for _ in range(length))

def random_hair_color():
    hair_colors = ['black', 'brown', 'blonde', 'red', 'gray', 'white']
    return random.choice(hair_colors)

def generate_random_date():
    start_date = datetime(1960, 1, 1)
    end_date = datetime(2005, 1, 1)
    random_days = random.randint(0, (end_date - start_date).days)
    random_date = start_date + timedelta(days=random_days)
    return random_date.strftime('%Y-%m-%d')

# Function to generate random values for the columns
def generate_insert_statements(table, num_rows):
    insert_statements = []

    for _ in range(num_rows):
        if table == 'user_spacesuit_data':
            insert_statements.append(f"INSERT INTO user_spacesuit_data (head, chest, waist, hips, foot_size, height, fabric_texture_id) VALUES "
                                    f"({random.randint(30, 80)}, {random.randint(30, 100)}, {random.randint(30, 100)}, "
                                    f"{random.randint(30, 100)}, {random.randint(30, 50)}, {random.randint(150, 200)}, {random.randint(1, 5)});")

        elif table == 'user_data':
            insert_statements.append(f"INSERT INTO user_data (birth_date, sex, weight, height, hair_color, location) VALUES "
                                    f"('{generate_random_date()}', '{random.choice(['MEN', 'WOMEN'])}', {random.randint(40, 150)}, "
                                    f"{random.randint(100, 210)}, '{random_hair_color()}', '{random.choice(['EARTH', 'MARS'])}');")

        elif table == 'user_request':
            insert_statements.append(f"INSERT INTO user_request (user_spacesuit_data_id) VALUES ({random.randint(1, 10000)});")

        elif table == 'users':
            insert_statements.append(f"INSERT INTO users (user_spacesuit_data_id, user_data_id, name) VALUES "
                                    f"({random.randint(1, 30000)}, {random.randint(1, 30000)}, '{generate_random_string()}');")

        elif table == 'lab_request':
            insert_statements.append(f"INSERT INTO lab_request (science_lab_id) VALUES ({random.randint(1, 6)});")

        elif table == 'company_request':
            insert_statements.append(f"INSERT INTO company_request (status) VALUES ('{random.choice(['DECLINED', 'ON_CHECKING', 'IN_PROGRESS', 'ACCEPTED'])}');")


        elif table == 'staff_request':
            insert_statements.append(f"INSERT INTO staff_request (status, name, user_request_id) VALUES "
                                    f"('{random.choice(['DECLINED', 'ON_CHECKING', 'IN_PROGRESS', 'ACCEPTED'])}', '{generate_random_string()}', {random.randint(1, 10000)});")


        elif table == 'additional_char':
            insert_statements.append(f"INSERT INTO additional_char (user_id, user_data_id, value_name, value) VALUES "
                                    f"({random.randint(1, 100)}, {random.randint(1, 100)}, '{generate_random_string()}', '{generate_random_string()}');")


    return insert_statements

# Example usage
tables = ['user_spacesuit_data',  'user_request', 'users']
tables_2 = [
    'lab_request', 'company_request', 'staff_request',
    'additional_char'
]
tables_data = ['user_data']
for table in tables_data:
    insert_statements = generate_insert_statements(table, 10000)


    # Write SQL statements to a file
    with open(f"{table}_data.sql", "w") as file:
        file.write("\n".join(insert_statements))



