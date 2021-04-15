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
        command = "SELECT log.userid,log.login_count FROM log"
        cursor.execute(command)
        result = cursor.fetchall()
        return result

def get_reward_list(conn,data):
    reward_list = []
    for i in range(len(data)):
        if data[i][1]>0:
            reward_list.append(data[i][0])
    return reward_list

def get_reward_point(conn,reward_id):
    reward_point = []
    with conn.cursor() as cursor:
        for uid in reward_id:
            command = "SELECT map.point,user.teamid FROM map,user WHERE user.userid='"+str(uid)+"' AND user.userid=map.userid"
            cursor.execute(command)
            result = cursor.fetchall()
            if(result[0][1]!=None):
                command2 = "SELECT team.point FROM team,user WHERE user.userid='"+str(uid)+"' AND user.teamid=team.teamid"
                cursor.execute(command2)
                result2 = cursor.fetchall()
                reward_point.append((result[0],result2[0]))
            else:
                reward_point.append((result[0],None))
    return reward_point
    
def send_order_to_server(conn,reward_id,reward_point):
    print(reward_id)
    with conn.cursor() as cursor:
        for i in reward_id[0]:
            command = "UPDATE map SET point = "+ str(reward_point[i][0]) +" WHERE userid = "+ str(reward_id[i])
            print(command)
            cursor.execute(command)
            conn.commit()
            if(reward_point[i][1]!=None):
                command2 = "UPDATE team SET point = "+ str(reward_point[i][1]) +" WHERE user.userid = '"+ str(reward_id[i])+"' AND user.teamid=team.teamid"
                cursor.execute(command2)
                conn.commit()
            

def send_reward():
    print('connect to sql!')
    conn = connect_to_sql()
    data = fetch_data(conn)
    print('get personal data!')
    reward_id = get_reward_list(conn,data)
    print(reward_id)
    print('get reward point!')
    reward_point = get_reward_point(conn,reward_id)
    print('sending to sql!')
    send_order_to_server(conn,reward_id,reward_point)
    print('update finish!')


if __name__ == "__main__": #main function
    send_reward()