class CreateIdTrigger < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION unique_short_id()
      RETURNS TRIGGER AS $$
      DECLARE
        key TEXT;
        qry TEXT;
        found TEXT;
      BEGIN
        qry := 'SELECT id FROM ' || quote_ident(TG_TABLE_NAME) || ' WHERE id=';
        LOOP
          key := encode(gen_random_bytes(6), 'base64');
          key := replace(key, '/', '_');
          key := replace(key, '+', '-');
          EXECUTE qry || quote_literal(key) INTO found;
          IF found IS NULL THEN
            EXIT;
          END IF;
        END LOOP;
        NEW.id = key;
        RETURN NEW;
      END;
      $$ language 'plpgsql';
    SQL
  end

  def down
    execute "DROP FUNCTION unique_short_id()"
  end
end
