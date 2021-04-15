import csv
import pymysql

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
	with open('import_data.csv', newline='') as csvfile:
		rows = csv.reader(csvfile)
		data = list(rows)
	return data

def update_to_server(conn,data):
	data = data[1:] #remove text description in first row
	with conn.cursor() as cursor:
		for activity in data:
			student_id = activity[0]
			number = activity[1]
			point = activity[2]
			get_point = 100

			fetch_data = get_map_data(conn,student_id,point[0:1])
			team_point = fetch_data[1]
			fetch_data_0 = fetch_data[0]

			user_id = fetch_data_0[0]
			team_id = fetch_data_0[1]
			new_user_point = fetch_data_0[2] + get_activity_point(number)
			new_team_point = team_point + get_activity_point(number)
			unused = int(fetch_data_0[2]) + int(point[1:])

			command_activity = "INSERT INTO activity (userid,number,point) VALUE ('" +str(user_id)+"','"+str(number)+"','"+str(point)+"')";
			cursor.execute(command_activity)   
			conn.commit()

			command_map = "UPDATE map SET unused"+str(point[0:1])+"='"+ str(unused) +"',point='"+str(new_user_point)+"' WHERE userid = '"+ str(user_id)+"'"
			cursor.execute(command_map)   
			conn.commit()

			if team_id != None:
				command_team = "UPDATE team SET point='"+ str(new_team_point) +"' WHERE teamid = '"+ str(team_id)+"'"
				cursor.execute(command_team)   
				conn.commit()

def get_map_data(conn,uid,num):
	with conn.cursor() as cursor:
		command_map = "SELECT map.userid,user.teamid,map.unused"+str(num)+",map.point FROM map,user WHERE map.userid=user.userid AND user.number='"+str(uid)+"'"
		cursor.execute(command_map)
		result_map = cursor.fetchall()

		team_point = -1
		if(result_map[0][1]!=None):
			command_team = "SELECT team.point FROM team,user WHERE team.userid=user.userid AND user.number='"+str(uid)+"'"
			cursor.execute(command_team)
			result_team = cursor.fetchall()		
			team_point = result_team[0][0]

		if(len(result_map)!=1):
			print('Error happened during serarch userid '+str(uid) + " !")
			exit()
		else:
			return (result_map[0],team_point)

def get_activity_point(number):
	return 100

if __name__ == '__main__':
	print('connect to sql!')
	conn = connect_to_sql()
	print('reading csv data!')
	data = read_csv()
	#print(data)
	print('uploading to server!')
	update_to_server(conn,data)
	print('finish uploading to server!')