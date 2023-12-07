
import random
import string

# Function to generate random strings
def generate_random_string(length=10):
    characters = string.ascii_letters + string.digits
    return ''.join(random.choice(characters) for _ in range(length))

def random_hair_color():
    hair_colors = ['black', 'brown', 'blonde', 'red', 'gray', 'white']
    return random.choice(hair_colors)


# Function to generate random values for the columns
def generate_insert_statements(table, num_rows):
    insert_statements = []

    for _ in range(num_rows):
        if table == 'user_spacesuit_data':
            insert_statements.append(f"INSERT INTO user_spacesuit_data (head, chest, waist, hips, foot_size, height, fabric_texture_id) VALUES "
                                    f"({random.randint(30, 80)}, {random.randint(30, 100)}, {random.randint(30, 100)}, "
                                    f"{random.randint(30, 100)}, {random.randint(30, 50)}, {random.randint(150, 200)}, {random.randint(1, 5)});")

        elif table == 'user_data':
            insert_statements.append(f"INSERT INTO user_data (age, sex, weight, height, hair_color, location) VALUES "
                                    f"({random.randint(18, 80)}, '{random.choice(['MEN', 'WOMEN'])}', {random.randint(40, 150)}, "
                                    f"{random.randint(100, 210)}, '{random_hair_color()}', '{random.choice(['EARTH', 'MARS'])}');")

        elif table == 'user_request':
            insert_statements.append(f"INSERT INTO user_request (user_spacesuit_data_id) VALUES ({random.randint(1, 100)});")

        elif table == 'users':
            insert_statements.append(f"INSERT INTO users (user_spacesuit_data_id, user_data_id, name) VALUES "
                                    f"({random.randint(1, 100)}, {random.randint(1, 100)}, '{generate_random_string()}');")

        elif table == 'company_specialisation':
            insert_statements.append(f"INSERT INTO company_specialisation (company_specialisation_name) VALUES ('{generate_random_string()}');")

        elif table == 'science_lab':
            insert_statements.append(f"INSERT INTO science_lab (sector) VALUES ('{generate_random_string()}');")

        elif table == 'lab_request':
            insert_statements.append(f"INSERT INTO lab_request (science_lab_id) VALUES ({random.randint(1, 100)});")

        elif table == 'company_request':
            insert_statements.append(f"INSERT INTO company_request (status) VALUES ('{random.choice(['DECLINED', 'ON_CHECKING', 'IN_PROGRESS', 'ACCEPTED'])}');")

        elif table == 'company':
            insert_statements.append(f"INSERT INTO company (name, company_specialisation_id) VALUES ('{generate_random_string()}', {random.randint(1, 100)});")

        elif table == 'fabric_texture':
            insert_statements.append(f"INSERT INTO fabric_texture (fabric_texture_name) VALUES ('{generate_random_string()}');")



        elif table == 'staff_request':
            insert_statements.append(f"INSERT INTO staff_request (status, name, user_request_id) VALUES "
                                    f"('{random.choice(['DECLINED', 'ON_CHECKING', 'IN_PROGRESS', 'ACCEPTED'])}', '{generate_random_string()}', {random.randint(1, 100)});")

        elif table == 'staff':
            insert_statements.append(f"INSERT INTO staff (specialisation) VALUES ('{generate_random_string()}');")


        elif table == 'additional_char':
            insert_statements.append(f"INSERT INTO additional_char (user_id, user_data_id, value_name, value) VALUES "
                                    f"({random.randint(1, 100)}, {random.randint(1, 100)}, '{generate_random_string()}', '{generate_random_string()}');")


    return insert_statements

# Example usage
tables = ['user_spacesuit_data',  'user_request', 'users']
tables_2 = [
    'company_specialisation', 'lab_request', 'company_request',
    'company', 'staff_request', 'staff',
    'additional_char'
]

for table in tables_2:
    insert_statements = generate_insert_statements(table, 3000)


    # Write SQL statements to a file
    with open(f"{table}_data.sql", "w") as file:
        file.write("\n".join(insert_statements))



