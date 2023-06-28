import sqlite3
import csv

conn = sqlite3.connect('cfgames.db')
conn.text_factory = str

crsr = conn.cursor()

crsr.execute("""CREATE TABLE old_cfgames (
			id integer,
			media_type text,
			name text,
			short_name text,
			long_description text,
			short_description text,
			created_at text,
			updated_at text,
			review_url text,
			review_score real,
			slug text,
			genres text,
			created_by text,
			published_by text,
			franchises text,
			regions text,
			PRIMARY KEY(name) 
			)	
			""")


#dont forget to get rid of regions

file = open('codefoobackend_cfgames.csv')

contents = csv.reader(file)

insert_records = "INSERT INTO old_cfgames (id, media_type, name, short_name, long_description, short_description, created_at, updated_at, review_url, review_score, slug, genres, created_by, published_by, franchises, regions) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )"

crsr.executemany(insert_records, contents)


crsr.execute("""CREATE TABLE new_cfgames (
			id integer,
			media_type text,
			name text,
			short_name text,
			long_description text,
			short_description text,
			created_at text,
			updated_at text,
			review_url text,
			review_score real,
			slug text,
			genres text,
			created_by text,
			published_by text,
			franchises text,
			PRIMARY KEY(name) 
			)	
			""")


crsr.execute("INSERT INTO new_cfgames SELECT id, media_type, name, short_name, long_description, short_description, created_at, updated_at, review_url, review_score, slug, genres, created_by, published_by, franchises FROM old_cfgames")


crsr.execute("DROP TABLE IF EXISTS old_cfgames")
crsr.execute("ALTER TABLE new_cfgames RENAME TO cfgames")







crsr.execute("CREATE INDEX media_type_idx on cfgames (media_type);")

crsr.execute("CREATE INDEX review_score_idx on cfgames (review_score);")

crsr.execute("CREATE INDEX genres_idx on cfgames (genres);")

crsr.execute("CREATE INDEX published_by_idx on cfgames (published_by);")



conn.commit()

conn.close()
#print('Records Transferred', no_records)




