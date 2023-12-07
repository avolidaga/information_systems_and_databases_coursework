CREATE OR REPLACE FUNCTION check_company_specialisation_name()
RETURNS TRIGGER AS $$
BEGIN
    IF LENGTH(NEW.company_specialisation_name) < 3 THEN
        RAISE EXCEPTION 'Company specialisation name must be at least 3 characters.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_user_age_limit()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.age < 18 THEN
        RAISE EXCEPTION 'User must be at least 18 years old';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_user_age_limit_trigger
    BEFORE INSERT OR UPDATE
    ON user_data
    FOR EACH ROW
EXECUTE FUNCTION check_user_age_limit();

CREATE OR REPLACE FUNCTION check_science_lab_sector()
RETURNS TRIGGER AS $$
BEGIN
    IF LENGTH(NEW.sector) < 3 THEN
        RAISE EXCEPTION 'Science lab sector must be at least 3 characters.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_lab_request_science_lab()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.science_lab_id < 1 THEN
        RAISE EXCEPTION 'Invalid science lab ID in lab request.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 4. Function for check_company_request_status_trigger
CREATE OR REPLACE FUNCTION check_company_request_status()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status NOT IN ('DECLINED', 'ON_CHECKING', 'IN_PROGRESS', 'ACCEPTED') THEN
        RAISE EXCEPTION 'Invalid company request status.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_company_name()
RETURNS TRIGGER AS $$
BEGIN
    IF LENGTH(NEW.name) < 3 THEN
        RAISE EXCEPTION 'Company name must be at least 3 characters.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;






-- 1. Trigger for company_specialisation
DROP TRIGGER IF EXISTS check_company_specialisation_name_trigger ON company_specialisation;
CREATE TRIGGER check_company_specialisation_name_trigger
    BEFORE INSERT OR UPDATE
    ON company_specialisation
    FOR EACH ROW
EXECUTE FUNCTION check_company_specialisation_name();

-- 2. Trigger for science_lab
DROP TRIGGER IF EXISTS check_science_lab_sector_trigger ON science_lab;
CREATE TRIGGER check_science_lab_sector_trigger
    BEFORE INSERT OR UPDATE
    ON science_lab
    FOR EACH ROW
EXECUTE FUNCTION check_science_lab_sector();

-- 3. Trigger for lab_request
DROP TRIGGER IF EXISTS check_lab_request_science_lab_trigger ON lab_request;
CREATE TRIGGER check_lab_request_science_lab_trigger
    BEFORE INSERT
    ON lab_request
    FOR EACH ROW
EXECUTE FUNCTION check_lab_request_science_lab();

-- 4. Trigger for company_request
DROP TRIGGER IF EXISTS check_company_request_status_trigger ON company_request;
CREATE TRIGGER check_company_request_status_trigger
    BEFORE INSERT
    ON company_request
    FOR EACH ROW
EXECUTE FUNCTION check_company_request_status();

-- 5. Trigger for company
DROP TRIGGER IF EXISTS check_company_name_trigger ON company;
CREATE TRIGGER check_company_name_trigger
    BEFORE INSERT OR UPDATE
    ON company
    FOR EACH ROW
EXECUTE FUNCTION check_company_name();

