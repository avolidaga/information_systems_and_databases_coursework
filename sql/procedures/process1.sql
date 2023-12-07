CREATE OR REPLACE PROCEDURE create_spacesuit(
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



