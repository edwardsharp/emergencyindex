# EmergencyINDEX

## db init

`rake db:schema:load`

_or_

`rake db:drop db:create db:migrate`

## start

`rails s`

_or_

`bundle exec puma -C config/puma.rb`

## migration notes

there's a trigger function that generates short, unique __string__ IDs. new migrations will need a couple extra thingz (note the trigger references the table name "...`INSERT ON mytable`..."). since ordering by ID is useless for random stringz, add an index on created_at and use scopes.

```ruby
class CreateMyTable < ActiveRecord::Migration[5.1]
  def up
    create_table :mytable, id: :string do |t|
      ...
    end

    execute <<-SQL
      CREATE TRIGGER trigger_test_genid BEFORE INSERT ON mytable FOR EACH ROW EXECUTE PROCEDURE unique_short_id();
    SQL

    add_index :mytable, :created_at
  end

  def down
    drop_table :mytable
  end
end
```

## misc

`mailcatcher --http-ip 0.0.0.0`

### local postgresql server setup: 

NOTE: requires postgres 9.4 or greator (jsonb columns, yuhyeah!)

install postgres.app (mac) or however on whatever os. then:

`create role sked with createdb login;`

superuser might be nice:

`ALTER USER sked WITH SUPERUSER;`

init test DB (or omit RAILS_ENV for devel)

```
RAILS_ENV=test rake db:create
RAILS_ENV=test rake db:schema:load
```

### upgrading Postgres.app

while the old version is still running run: 

`pg_dumpall > db.out`

stop & delete the old Postgres.app from /Application. copy in the new binary, start, and then:

`psql -f db.out postgres`

:metal:
