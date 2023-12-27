CREATE INDEX ON user_data USING hash (location) ;
EXPLAIN ANALYSE
SELECT users.name, user_data.age, user_data.location
FROM users
JOIN user_data ON users.user_data_id = user_data.user_data_id
WHERE user_data.age BETWEEN 25 AND 40;




CREATE INDEX ON "user_spacesuit_data" USING btree (head);
CREATE INDEX ON "user_spacesuit_data" USING btree (waist);
EXPLAIN ANALYSE
SELECT users.name, user_spacesuit_data.head, user_spacesuit_data.waist
FROM users
JOIN user_spacesuit_data ON users.user_spacesuit_data_id = user_spacesuit_data.user_spacesuit_data_id
WHERE user_spacesuit_data.head > 50
AND user_spacesuit_data.waist < 100;