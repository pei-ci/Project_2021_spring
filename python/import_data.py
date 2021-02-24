import csv
import pymysql

def connect_to_sql():
	db_settings = {
	"host": "127.0.0.1",
	"port": 3306,
	"user": "root",
	"db": "school_games",
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
	with open('import_data.csv', newline='') as csvfile:
		rows = csv.reader(csvfile)
		data = list(rows)
	return data

def update_to_server(conn,data):
	data = data[1:] #remove text description in first row
	with conn.cursor() as cursor:
		for activity in data:
			uid = activity[0]
			title = activity[1]
			number = activity[2]
			point = activity[3]
			time = activity[4]
			fetch_data = get_map_data(conn,uid,point[0:1])
			user_id = fetch_data[0]
			unused = int(fetch_data[1])+int(point[1:])

			command_activity = "INSERT INTO activity (userid,title,number,point,time) VALUE ('" +str(user_id)+"','"+str(title)+"','"+str(number)+"','"+str(point)+"','"+str(time)+ "')";
			cursor.execute(command_activity)   
			conn.commit()

			command_map = "UPDATE map SET unused"+str(point[0:1])+"='"+ str(unused) +"' WHERE userid = '"+ str(user_id)+"'"
			cursor.execute(command_map)   
			conn.commit()

def get_map_data(conn,uid,num):
	with conn.cursor() as cursor:
		command = "SELECT map.userid,map.unused"+str(num)+" FROM map,user WHERE map.userid=user.userid AND user.number='"+str(uid)+"'"
		cursor.execute(command)
		result = cursor.fetchall()
		if(len(result)!=1):
			print('Error happened during serarch userid '+str(uid) + " !")
			return (-1,0)
		else:
			return result[0]

if __name__ == '__main__':
	print('connect to sql!')
	conn = connect_to_sql()
	print('reading csv data!')
	data = read_csv()
	#print(data)
	print('uploading to server!')
	update_to_server(conn,data)
	print('finish uploading to server!')