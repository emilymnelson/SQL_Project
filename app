from flask import Flask, jsonify, request
import json
import sqlite3
from flask_sqlalchemy import SQLAlchemy
from collections import defaultdict
import numpy as np



connection = sqlite3.connect('cfgames.db')
cursor = connection.cursor()

game_connection = sqlite3.connect('cfgames.db')
game_cursor = game_connection.cursor()

movie_connection = sqlite3.connect('cfgames.db')
movie_cursor = movie_connection.cursor()

show_connection = sqlite3.connect('cfgames.db')
show_cursor = show_connection.cursor()



query = "SELECT * FROM cfgames"
result = cursor.execute(query)

items = []
game_items = []
movie_items = []
show_items = []

games_sorted = []
movies_sorted = []
shows_sorted = []


next(result)

for row in result:
	items.append({'ID' : row[0], 'media_type': row[1], 'name': row[2], 'short_name': row[3], 'long_description': row[4], 'short_description': row[5], 'created_at': row[6], 'updated_at': row[7], 'review_url': row[8], 'review_score': row[9], 'slug': row[10], 'genres': row[11],'created_by': row[12], 'published_by': row[13], 'franchises': row[14]})
	items.append('<br>')


game_query = "SELECT * FROM cfgames WHERE media_type = 'Game'"
game_result = game_cursor.execute(game_query)

for row in game_result:
	game_items.append({'ID' : row[0], 'media_type': row[1], 'name': row[2], 'short_name': row[3], 'short_description': row[5], 'created_at': row[6], 'updated_at': row[7], 'review_url': row[8], 'review_score': row[9], 'slug': row[10], 'genres': row[11],'created_by': row[12], 'published_by': row[13], 'franchises': row[14]})
	game_items.append('<br>')

movie_query = "SELECT * FROM cfgames WHERE media_type = 'Movie'"
movie_result = game_cursor.execute(movie_query)

for row in movie_result:
	movie_items.append({'ID' : row[0], 'media_type': row[1], 'name': row[2], 'short_name': row[3], 'short_description': row[5], 'created_at': row[6], 'updated_at': row[7], 'review_url': row[8], 'review_score': row[9], 'slug': row[10], 'genres': row[11],'created_by': row[12], 'published_by': row[13], 'franchises': row[14]})
	movie_items.append('<br>')

show_query = "SELECT * FROM cfgames WHERE media_type = 'Show'"
show_result = game_cursor.execute(show_query)

for row in show_result:
	show_items.append({'ID' : row[0], 'media_type': row[1], 'name': row[2], 'short_name': row[3], 'short_description': row[5], 'created_at': row[6], 'updated_at': row[7], 'review_url': row[8], 'review_score': row[9], 'slug': row[10], 'genres': row[11],'created_by': row[12], 'published_by': row[13], 'franchises': row[14]})
	show_items.append('<br>')



movie_items_rank = movie_items

del movie_items_rank[1::2]

all_movie_ratings = []
for i in movie_items_rank:
  rating = i.get('review_score')
  all_movie_ratings.append(rating)

ascending = np.argsort(all_movie_ratings)
descending = ascending[::-1]

movie_items_rank = [movie_items_rank[i] for i in descending]

for i in range(1, len(movie_items_rank), 2):
  movie_items_rank.insert(i, "<br>")




show_items_rank = show_items

del show_items_rank[1::2]

all_show_ratings = []
for i in show_items_rank:
  rating = i.get('review_score')
  all_show_ratings.append(rating)

ascending = np.argsort(all_show_ratings)
descending = ascending[::-1]

show_items_rank = [show_items_rank[i] for i in descending]

for i in range(1, len(show_items_rank), 2):
  show_items_rank.insert(i, "<br>")




game_items_rank = game_items

del game_items_rank[1::2]

all_game_ratings = []
for i in game_items_rank:
  rating = i.get('review_score')
  all_game_ratings.append(rating)

ascending = np.argsort(all_game_ratings)
descending = ascending[::-1]

game_items_rank = [game_items_rank[i] for i in descending]

for i in range(1, len(game_items_rank), 2):
  game_items_rank.insert(i, "<br>")








connection.close()














#init app
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///cfgames.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

cfgames = db.Table("cfgames", db.metadata, autoload=True, autoload_with = db.engine)

@app.route('/')
def index():
	return "Hello IGN! <br> Use http://127.0.0.1:5000/api/v1/cfgames to see the full database. <br> Use http://127.0.0.1:5000/api/v1/cfgames/Games to see all Game entries. <br> Use http://127.0.0.1:5000/api/v1/cfgames/Movies to see all Movie entries. <br> Use http://127.0.0.1:5000/api/v1/cfgames/Shows to see all Show entries. <br> Use http://127.0.0.1:5000/api/v1/cfgames/MoviesSorted to see all movies in order of their ratings. <br> Use http://127.0.0.1:5000/api/v1/cfgames/GamesSorted to see all games in order of their ratings. <br> Use http://127.0.0.1:5000/api/v1/cfgames/ShowsSorted to see all shows in order of their ratings. <br> "

@app.route('/api/v1/cfgames', methods = ["GET"])
def get_cfgames():
	return json.dumps(items, skipkeys = True)


@app.route('/api/v1/cfgames/Games', methods = ["GET"])
def get_cfgames_by_game():
	return json.dumps(game_items, skipkeys = True)


@app.route('/api/v1/cfgames/Movies', methods = ["GET"])
def get_cfgames_by_movie():
	return json.dumps(movie_items, skipkeys = True)


@app.route('/api/v1/cfgames/Shows', methods = ["GET"])
def get_cfgames_by_shows():
	return json.dumps(show_items, skipkeys = True)

@app.route('/api/v1/cfgames/MoviesSorted', methods = ["GET"])
def get_cfgames_by_moviessorted():
	return json.dumps(movie_items_rank, skipkeys = True)


@app.route('/api/v1/cfgames/ShowsSorted', methods = ["GET"])
def get_cfgames_by_showsssorted():
	return json.dumps(show_items_rank, skipkeys = True)


@app.route('/api/v1/cfgames/GamesSorted', methods = ["GET"])
def get_cfgames_by_gamessorted():
	return json.dumps(game_items_rank, skipkeys = True)




if __name__ == '__main__':
	app.run(debug = True)
