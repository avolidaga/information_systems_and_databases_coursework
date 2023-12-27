-- Создание функции для регистрации пользователя и создания профиля
CREATE OR REPLACE FUNCTION register_user(
    p_name VARCHAR(100),
    p_age INT,
    p_sex sex_enum,
    p_weight INT,
    p_height INT,
    p_hair_color VARCHAR(255),
    p_location location_enum,
    p_head INT,
    p_chest INT,
    p_waist INT,
    p_hips INT,
    p_foot_size INT,
    p_fabric_texture_id INT
)
RETURNS INT AS
$$
DECLARE
    v_user_data_id INT;
    v_user_spacesuit_data_id INT;
BEGIN
    -- Вставка основной информации о пользователе
    INSERT INTO user_data (age, sex, weight, height, hair_color, location)
    VALUES (p_age, p_sex, p_weight, p_height, p_hair_color, p_location)
    RETURNING user_data_id INTO v_user_data_id;

    -- Проверка на NULL перед вставкой данных о космическом костюме пользователя
    IF p_head IS NOT NULL AND p_chest IS NOT NULL AND p_waist IS NOT NULL AND p_hips IS NOT NULL AND p_foot_size IS NOT NULL AND p_fabric_texture_id IS NOT NULL THEN
        INSERT INTO user_spacesuit_data (head, chest, waist, hips, foot_size, fabric_texture_id)
        VALUES (p_head, p_chest, p_waist, p_hips, p_foot_size, p_fabric_texture_id)
        RETURNING user_spacesuit_data_id INTO v_user_spacesuit_data_id;
    ELSE
        v_user_spacesuit_data_id := NULL;
    END IF;

    -- Вставка пользователя с возможным NULL в поле spacesuit
    INSERT INTO users (name, user_data_id, user_spacesuit_data_id)
    VALUES (p_name, v_user_data_id, v_user_spacesuit_data_id);

    -- Возвращаем идентификатор пользователя
    RETURN v_user_data_id;
END;
$$ LANGUAGE plpgsql;

-- Создание функции для добавления данных о космическом костюме пользователю
CREATE OR REPLACE FUNCTION add_spacesuit_to_user(
    p_user_id INT,
    p_head INT,
    p_chest INT,
    p_waist INT,
    p_hips INT,
    p_foot_size INT,
    p_fabric_texture_id INT
)
RETURNS VOID AS
$$
BEGIN
    -- Проверка, существует ли пользователь с указанным ID
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        RAISE EXCEPTION 'User with ID % does not exist.', p_user_id;
    END IF;

    -- Вставка данных о космическом костюме пользователя
    INSERT INTO user_spacesuit_data (head, chest, waist, hips, foot_size, fabric_texture_id)
    VALUES (p_head, p_chest, p_waist, p_hips, p_foot_size, p_fabric_texture_id);

    -- Получение последнего ID вставленного космического костюма
    DECLARE v_user_spacesuit_data_id INT;
    SELECT currval(pg_get_serial_sequence('user_spacesuit_data', 'user_spacesuit_data_id')) INTO v_user_spacesuit_data_id;

    -- Обновление профиля пользователя с новыми данными о космическом костюме
    UPDATE users
    SET user_spacesuit_data_id = v_user_spacesuit_data_id
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;


-- Создание функции для оформления заказа на скафандр
CREATE OR REPLACE FUNCTION place_spacesuit_order(
    p_user_id INT,
    p_company_specialisation_id INT
)
RETURNS VOID AS
$$
DECLARE
    v_user_location location_enum;
    v_user_data_height INT;
    v_company_id INT;
    v_company_request_id INT;
    v_staff_request_id INT;
BEGIN
    -- Получение информации о местоположении пользователя
    SELECT u.location, ud.height
    INTO v_user_location, v_user_data_height
    FROM users u
    JOIN user_data ud ON u.user_data_id = ud.user_data_id
    WHERE u.user_id = p_user_id;

    -- Определение компании для заказа в зависимости от географического местоположения пользователя и специализации
    SELECT company_id INTO v_company_id
    FROM company
    WHERE company_specialisation_id = p_company_specialisation_id
    ORDER BY RANDOM()
    LIMIT 1;

    -- Вставка заказа в таблицу company_request
    INSERT INTO company_request (status)
    VALUES ('ON_CHECKING') -- Предполагается, что заказ по умолчанию находится на проверке
    RETURNING company_request_id INTO v_company_request_id;

    -- Вставка записи в таблицу staff_request
    INSERT INTO staff_request (status, user_request_id, company_id, company_request_id)
    VALUES ('ON_CHECKING', (SELECT user_request_id FROM user_request WHERE user_id = p_user_id), v_company_id, v_company_request_id)
    RETURNING staff_request_id INTO v_staff_request_id;
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION create_user(
    var_customer_id int,
    distance float,
    var_vehicle_id int,
    v_weight float,
    v_width float,
    v_height float,
    v_length float,
    v_cargo_type cargo_type
) RETURNS int AS
'
    DECLARE
        calculated_price float;
        ord_id           int;
    BEGIN
        calculated_price = distance * 20;
        INSERT INTO orders (customer_id, distance, price, order_date, vehicle_id)
        VALUES (var_customer_id, distance, calculated_price, NOW(), var_vehicle_id)
        RETURNING id INTO ord_id;

        INSERT INTO order_statuses (order_id, date_time, status)
        VALUES (ord_id, NOW(), ''ACCEPTED'');

        INSERT INTO cargo (weight, width, height, length, order_id, cargo_type)
        VALUES (v_weight, v_width, v_height, v_length, ord_id, v_cargo_type);
        RETURN ord_id;
    END
' LANGUAGE plpgsql;




CREATE OR REPLACE PROCEDURE create_spacesuit_request(
    IN p_user_id INT,
    IN p_user_name VARCHAR(100)
)
AS $$
DECLARE
    v_spacesuit_id INT;
BEGIN
    -- Шаг 1: Предварительное исследование и опрос
    -- (ваш код здесь, например, вызов функции для исследования среды)

    -- Шаг 2: Снятие мерок от пользователя
    PERFORM measure_spacesuit(p_user_id);

    -- Шаг 3: Отправление данных в архив
    PERFORM archive_measurements(p_user_id);

    -- Шаг 4: Создание заказа на скафандр
    v_spacesuit_id := order_spacesuit(p_user_id);

    -- Шаг 5: Оформление заказа на шлем
    PERFORM order_helmet(v_spacesuit_id);

    -- Шаг 6: Разработка белья на заводе
    PERFORM develop_underwear(p_user_id);

    -- Шаг 7: Тестирование белья
    PERFORM test_underwear(v_spacesuit_id);

    -- Шаг 8: Отправка белья на доработку или завершение
    PERFORM finalize_underwear(v_spacesuit_id);

    -- Шаг 9: Упаковка и отправка белья
    PERFORM pack_and_ship_underwear(v_spacesuit_id, p_user_name);

    -- Шаг 10: Сборка уникального костюма
    PERFORM assemble_custom_costume(v_spacesuit_id);

    -- Шаг 11: Оформление заказа в МКС
    PERFORM order_to_ISS(v_spacesuit_id);

    -- Шаг 12: Доставка костюма в МКС
    PERFORM deliver_to_ISS(v_spacesuit_id);
END;
$$ LANGUAGE plpgsql;



