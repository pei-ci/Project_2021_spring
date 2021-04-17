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

def fetch_data(conn):
	with conn.cursor() as cursor:
		command = "SELECT team.teamid,team.point FROM team ORDER BY point DESC"
		cursor.execute(command)
		result = cursor.fetchall()
		return result

def get_order(conn,data):
	order_list = {} #id:rank
	#now_order = 1
	current_order = 1
	i = 0
	while(i<(len(data)-1)): #i = index
		#print("i"+str(i))
		repeat = 0
		index = i
		while(True): #if former and latter have same picture amount
			if data[index][1] == data[index+1][1]:
				repeat += 1
				if(index+1 < len(data)-1):
					index += 1
				else:
					break
			else:
				break
		if repeat != 0:
			#print(repeat)
			for j in range(repeat+1):
				order_list[data[i+j][0]] = current_order
			i += repeat
			current_order += 1
		else:
			order_list[data[i][0]] = current_order
			current_order += 1
			
		if(i==len(data)-2):
			order_list[data[i+1][0]] = current_order
		i+=1
	return order_list

def send_order_to_server(conn,order_list):
    with conn.cursor() as cursor:
    	for key in order_list.keys():
        	command = "UPDATE team SET rank = "+ str(order_list[key]) +" WHERE teamid = "+ str(key)
        	cursor.execute(command)   
        	conn.commit()

def order_team():
	print('connect to sql!')
	conn = connect_to_sql()
	data = fetch_data(conn)
	print('ordering team data!')
	order_list = get_order(conn,data)
	print(order_list)
	print('sending to sql!')
	send_order_to_server(conn,order_list)
	print('order finish!')

if __name__ == "__main__": #main function
	order_team()