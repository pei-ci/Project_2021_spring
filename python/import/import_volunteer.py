import csv
import pymysql
import random

activity_table = {}
skip = 0

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
	with open('import_volunteer_data.csv', newline='',encoding="utf-8") as csvfile:
		rows = csv.reader(csvfile)
		data = list(rows)
	return data

def update_to_server(conn,data):
	data = data[1:] #remove text description in first row
	with conn.cursor() as cursor:
		for activity in data:
			student_id = activity[0]

			reward_puzzle_type = random_puzzle()
			reward_puzzle_count = int(activity[1])
			
			reward_point = int(activity[2])
			
			#reward_puzzle_record = str(reward_puzzle_type)+str(reward_puzzle_count)

			fetch_data = get_map_data(conn,student_id,reward_puzzle_type)

			if fetch_data == None:
				continue

			team_point = fetch_data[1]
			fetch_data_0 = fetch_data[0]

			user_id = fetch_data_0[0]
			team_id = fetch_data_0[1]

			new_user_point = fetch_data_0[3] + reward_point
			new_team_point = team_point + reward_point
			
			new_unused = int(fetch_data_0[2]) + int(reward_puzzle_count)

			command_map = "UPDATE map SET unused"+str(reward_puzzle_type)+"='"+ str(new_unused) +"',point='"+str(new_user_point)+"' WHERE userid = '"+ str(user_id)+"'"
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

		if(len(result_map)!=1):
			#print('Pass userid '+str(uid) + " !")
			global skip
			skip += 1
			return None

		team_point = -1
		if(result_map[0][1]!=None):
			command_team = "SELECT team.point FROM team,user WHERE team.teamid=user.teamid AND user.number='"+str(uid)+"'"
			cursor.execute(command_team)
			result_team = cursor.fetchall()		
			team_point = result_team[0][0]

		return (result_map[0],team_point)

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
	print('connect to sql!')
	conn = connect_to_sql()
	print('reading csv data!')
	data = read_csv()
	print('uploading to server!')
	update_to_server(conn,data)
	print('finish uploading to server!')

	print('-----------------------------------')
	print('Total user : '+str(len(data)-1))
	print('Total upload : '+str(len(data)-skip-1))
