import csv
import pymysql
import random

activity_table = {}

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
	with open('import_activity_data.csv', newline='',encoding="utf-8") as csvfile:
		rows = csv.reader(csvfile)
		data = list(rows)
	return data

def load_point_table():
	with open('activity.csv', newline='',encoding="utf-8") as csvfile:
		rows = csv.reader(csvfile)
		data = list(rows)[1:]
		for event in data:
			activity_table[event[0]+event[1]+event[2]] = (int(event[3]),int(event[4]))

def update_to_server(conn,data):
	data = data[1:] #remove text description in first row
	with conn.cursor() as cursor:
		for activity in data:
			student_id = activity[0]
			if len(activity[5])==1:
				number = activity[3]+activity[4]+'0'+activity[5]
			else:
				number = activity[3]+activity[4]+activity[5]
			get_point = 100

			reward_puzzle_type,reward_puzzle_count,reward_point = get_activity_point(number)
			reward_puzzle_record = str(reward_puzzle_type)+str(reward_puzzle_count)

			fetch_data = get_map_data(conn,student_id,reward_puzzle_type)

			if fetch_data != None:
				team_point = fetch_data[1]
				fetch_data_0 = fetch_data[0]

				user_id = fetch_data_0[0]
				team_id = fetch_data_0[1]

				new_user_point = fetch_data_0[2] + reward_point
				new_team_point = team_point + reward_point
				new_unused = int(fetch_data_0[2]) + int(reward_puzzle_count)

				command_map = "UPDATE map SET unused"+str(reward_puzzle_type)+"='"+ str(new_unused) +"',point='"+str(new_user_point)+"' WHERE userid = '"+ str(user_id)+"'"
				cursor.execute(command_map)   
				conn.commit()

				if team_id != None:
					command_team = "UPDATE team SET point='"+ str(new_team_point) +"' WHERE teamid = '"+ str(team_id)+"'"
					cursor.execute(command_team)   
					conn.commit()

				command_activity = "INSERT INTO activity (userid,stu_id,number,point,add_point) VALUE ('" +str(user_id)+"','"+str(student_id)+"','"+str(number)+"','"+str(reward_puzzle_record)+"','"+str(reward_point)+"')"
				cursor.execute(command_activity)   
				conn.commit()
			else:
				command_activity = "INSERT INTO activity (userid,stu_id,number,point,add_point) VALUE (" +"NULL"+",'"+str(student_id)+"','"+str(number)+"','"+str(reward_puzzle_record)+"','"+str(reward_point)+"')"
				cursor.execute(command_activity)   
				conn.commit()

def get_map_data(conn,uid,num):
	with conn.cursor() as cursor:
		command_map = "SELECT map.userid,user.teamid,map.unused"+str(num)+",map.point FROM map,user WHERE map.userid=user.userid AND user.number='"+str(uid)+"'"
		cursor.execute(command_map)
		result_map = cursor.fetchall()

		if(len(result_map)!=1):
			#print('Pass userid '+str(uid) + " !")
			return None

		team_point = -1
		if(result_map[0][1]!=None):
			command_team = "SELECT team.point FROM team,user WHERE team.teamid=user.teamid AND user.number='"+str(uid)+"'"
			cursor.execute(command_team)
			result_team = cursor.fetchall()		
			team_point = result_team[0][0]

		return (result_map[0],team_point)

def get_activity_point(number):
	if number[0]=='A':
		reward_puzzle_type = 1
	elif number[0]=='B':
		reward_puzzle_type = 2
	elif number[0]=='C':
		reward_puzzle_type = 3
	elif number[0]=='D':
		reward_puzzle_type = 4
	elif number[0]=='E':
		reward_puzzle_type = 5
	elif number[0]=='F':
		reward_puzzle_type = 6
	elif number[0]=='G' or number[0]=='H':
		reward_puzzle_type = random_puzzle()

	return (reward_puzzle_type,activity_table[number][0],activity_table[number][1])

def random_puzzle():
    rand_int = random.randint(1,10)
    if rand_int == 1:
        return 1
    elif rand_int == 2:
        return 2
    elif rand_int == 3:
        return 3
    elif rand_int >= 4 and rand_int <= 5:
        return 4
    elif rand_int >= 6 and rand_int <= 8:
        return 5
    elif rand_int >= 9 and rand_int <= 10:
        return 6

if __name__ == '__main__':
	print('load point csv!')
	load_point_table()
	#print(activity_table)
	print('connect to sql!')
	conn = connect_to_sql()
	print('reading csv data!')
	data = read_csv()
	print('uploading to server!')
	update_to_server(conn,data)
	print('finish uploading to server!')

	print('-----------------------------------')
	print('Total user : '+str(len(data)-1))