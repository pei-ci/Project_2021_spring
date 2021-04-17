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
		command = "SELECT map.userid,map.point FROM map ORDER BY point DESC"
		cursor.execute(command)
		result = cursor.fetchall()
		print(result)
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

def get_title_data(conn,uid):
	with conn.cursor() as cursor:
		command = "SELECT user.title FROM user WHERE userid='"+uid+"'"
		cursor.execute(command)
		result = cursor.fetchall()
		return result[0][0]

def set_title_data(conn,uid,order):
	user_title = get_title_data(conn,uid)
	new_user_title = user_title
	if order==1:
		new_user_title = user_title[0:24]+'1'+user_title[25:]
	elif order==2:
		new_user_title = user_title[0:25]+'1'+user_title[26:]
	elif order==3:
		new_user_title = user_title[0:26]+'1'+user_title[27:]
	elif order<=50:
		new_user_title = user_title[0:27]+'1'+user_title[28:]
	return new_user_title

def send_order_to_server(conn,order_list):
	with conn.cursor() as cursor:
		for key in order_list.keys():
			new_user_title = set_title_data(conn,str(key),order_list[key])
			command = "UPDATE user SET rank = '"+ str(order_list[key]) +"',title='"+str(new_user_title)+"' WHERE userid = "+ str(key)
			cursor.execute(command)   
			conn.commit()

def order_person():
	print('connect to sql!')
	conn = connect_to_sql()
	data = fetch_data(conn)
	print('ordering personal data!')
	order_list = get_order(conn,data)
	print(order_list)
	print('sending to sql!')
	send_order_to_server(conn,order_list)
	print('order finish!')


if __name__ == "__main__": #main function
	order_person()