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

def check_title_amount(title_dict): #00001100 -> 2
	for key in title_dict.keys():
		num = 0
		for i in range(len(title_dict[key])):
			if title_dict[key][i]=='1':
				num+=1
		title_dict[key] = num
	return title_dict

def fetch_data(conn):
	with conn.cursor() as cursor:
		command = "SELECT map.userid,map.used FROM map ORDER BY used DESC"
		cursor.execute(command)
		result = cursor.fetchall()
		return result

def fetch_title_data(conn,ids):
	with conn.cursor() as cursor:
		command = "SELECT title FROM user where "
		first = True
		#Ex. condiction = (userid=1 OR userid=2)
		condiction = '('
		for user_id in ids:
			if first:
				condiction = condiction+'userid='+str(user_id)
				first = False
			else:
				condiction = condiction+' OR '+'userid='+str(user_id)
		condiction = condiction+')'
		#print(condiction)
		command = command+condiction

		cursor.execute(command)
		result = cursor.fetchall()
		title_dict = {}
		for i in range(len(result)):
			title_dict[ids[i]] = result[i][0]
		title_dict = check_title_amount(title_dict)
		title_sort = sorted(title_dict.items(), key=lambda x:x[1],reverse=True)
		return title_sort

def get_order(conn,data):
	order_list = {} #id:rank
	#now_order = 1
	for i in range(len(data)-1):
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
			order_list = get_second_order(conn,data,i,repeat+1,order_list) #goint to order by title amount
			i += repeat
		else:
			order_list[data[i][0]] = i+1
			if(i==len(data)-2):
				order_list[data[i+1][0]] = i+2
	return order_list

def send_order_to_server(conn,order_list):
    with conn.cursor() as cursor:
    	for key in order_list.keys():
        	command = "UPDATE user SET rank = "+ str(order_list[key]) +" WHERE userid = "+ str(key)
        	cursor.execute(command)   
        	conn.commit()

def get_second_order(conn,data,start_index,length,order_list): #order by title amount
	ids = []
	for i in range(length):
		ids.append(data[start_index+i][0])
	title_sort = fetch_title_data(conn,ids)
	for i in range(len(title_sort)):
		order_list[title_sort[i][0]] = start_index+i+1
	return order_list
if __name__ == "__main__": #main function
	print('connect to sql!')
	conn = connect_to_sql()
	data = fetch_data(conn)
	print('ordering!')
	order_list = get_order(conn,data)
	print(order_list)
	print('sending to sql!')
	send_order_to_server(conn,order_list)
	print('order finish!')