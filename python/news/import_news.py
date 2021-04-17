import csv
import pymysql
import random

def connect_to_sql():
	db_settings = {
	"host": "127.0.0.1",
	"port": 3306,
	"user": "root",
	"db": "school_games_3nd",
	"charset": "utf8"
	}
	#password

	try:
		conn = pymysql.connect(**db_settings)
		return conn
	except Exception as ex:
		print(ex)
		exit()

def read_csv():
	with open('import_news_data.csv', newline='',encoding="utf-8") as csvfile:
		rows = csv.reader(csvfile)
		data = list(rows)
	return data

def update_to_server(conn,data):
	data = data[1:] #remove text description in first row
	with conn.cursor() as cursor:
		for activity in data:
			news_item = activity[0]
			
			command_map = "INSERT INTO news (title) VALUE ('"+news_item+"')"
			cursor.execute(command_map)   
			conn.commit()


if __name__ == '__main__':
	print('connect to sql!')
	conn = connect_to_sql()
	print('reading csv data!')
	data = read_csv()
	print('uploading to server!')
	update_to_server(conn,data)
	print('finish uploading to server!')

	print('-----------------------------------')
	print('Total upload : '+str(len(data)-1))
