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
    VALUES (p_name, v_user_data_id, v_user_spacesuit_data_id)
    RETURNING user_id;
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
DECLARE
    v_user_spacesuit_data_id INT;
BEGIN
    -- Проверка, существует ли пользователь с указанным ID
    IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
        RAISE EXCEPTION 'User with ID % does not exist.', p_user_id;
    END IF;

    -- Вставка данных о космическом костюме пользователя
    INSERT INTO user_spacesuit_data (head, chest, waist, hips, foot_size, fabric_texture_id)
    VALUES (p_head, p_chest, p_waist, p_hips, p_foot_size, p_fabric_texture_id)
    RETURNING user_spacesuit_data_id INTO v_user_spacesuit_data_id;

    -- Обновление профиля пользователя с новыми данными о космическом костюме
    UPDATE users
    SET user_spacesuit_data_id = v_user_spacesuit_data_id
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;

-- Создание функции для оформления заказа на скафандр
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
    v_user_request_id INT;
BEGIN
    -- Получение информации о местоположении пользователя
    SELECT ud.location, ud.height
    INTO v_user_location, v_user_data_height, v_user_request_id
    FROM users u
    JOIN user_data ud ON u.user_data_id = ud.user_data_id
    WHERE u.user_id = p_user_id;

    -- Определение компании для заказа в зависимости от географического местоположения пользователя и специализации
    SELECT c.company_id INTO v_company_id
    FROM company c
    WHERE c.company_specialisation_id = p_company_specialisation_id
    ORDER BY RANDOM()
    LIMIT 1;

    -- Вставка заказа в таблицу company_request
    INSERT INTO company_request (status)
    VALUES ('ON_CHECKING') -- Предполагается, что заказ по умолчанию находится на проверке
    RETURNING company_request_id INTO v_company_request_id;

    -- Вставка записи в таблицу staff_request
    INSERT INTO staff_request (status, user_request_id)
    VALUES ('ON_CHECKING', v_user_request_id, v_company_id, v_company_request_id)
    RETURNING staff_request_id INTO v_staff_request_id;
END;
$$ LANGUAGE plpgsql;


-- Создание функции для одновременного оформления заказов на скафандр, шлем и белье
CREATE OR REPLACE FUNCTION place_orders(
    p_user_id INT
)
RETURNS VOID AS
$$
DECLARE
    v_user_location location_enum;
    v_user_data_height INT;
    v_spacesuit_company_id INT;
    v_helmet_company_id INT;
    v_underwear_company_id INT;
    v_company_request_id INT;
    v_staff_request_id INT;
BEGIN
    -- Получение информации о местоположении пользователя
    SELECT ud.location, ud.height
    INTO v_user_location, v_user_data_height
    FROM users u
    JOIN user_data ud ON u.user_data_id = ud.user_data_id
    WHERE u.user_id = p_user_id;

    -- Определение компаний для заказа в зависимости от географического местоположения пользователя
    SELECT company_id INTO v_spacesuit_company_id
    FROM company
    WHERE company_specialisation_id = 1 -- Предполагается, что 1 - это ID специализации для скафандров
    ORDER BY RANDOM()
    LIMIT 1;

    SELECT company_id INTO v_helmet_company_id
    FROM company
    WHERE company_specialisation_id = 2 -- Предполагается, что 2 - это ID специализации для шлемов
    ORDER BY RANDOM()
    LIMIT 1;

    SELECT company_id INTO v_underwear_company_id
    FROM company
    WHERE company_specialisation_id = 3 -- Предполагается, что 3 - это ID специализации для белья
    ORDER BY RANDOM()
    LIMIT 1;

    -- Вставка заказа на скафандр в таблицу company_request
    INSERT INTO company_request (status)
    VALUES ('ON_CHECKING')
    RETURNING company_request_id INTO v_company_request_id;

    -- Вставка записи на скафандр в таблицу staff_request
    INSERT INTO staff_request (status, user_request_id)
    VALUES ('ON_CHECKING', (SELECT user_request_id FROM user_request WHERE user_spacesuit_data_id = p_user_id), v_spacesuit_company_id, v_company_request_id)
    RETURNING staff_request_id INTO v_staff_request_id;

    -- Вставка заказа на шлем в таблицу company_request
    INSERT INTO company_request (status)
    VALUES ('ON_CHECKING')
    RETURNING company_request_id INTO v_company_request_id;


    -- Вставка заказа на белье в таблицу company_request
    INSERT INTO company_request (status)
    VALUES ('ON_CHECKING')
    RETURNING company_request_id INTO v_company_request_id;

END;
$$ LANGUAGE plpgsql;
