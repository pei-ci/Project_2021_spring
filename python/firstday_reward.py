import pymysql
import random
import time

REWARD_POINT = 450
REWARD_PUZZLE_COUNT = 15

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

def get_reward_point(conn,uid,puzzle_type):
    with conn.cursor() as cursor:
        command = "SELECT map.point,user.teamid,map.unused"+str(puzzle_type)+" FROM map,user WHERE user.userid='"+str(uid)+"' AND user.userid=map.userid"
        cursor.execute(command)
        result = cursor.fetchall()
        if(result[0][1]!=None):
            command2 = "SELECT team.point FROM team,user WHERE user.userid='"+str(uid)+"' AND user.teamid=team.teamid"
            cursor.execute(command2)
            result2 = cursor.fetchall()
            return(result[0][0],result2[0],result[0][2])
        else:
            return(result[0][0],None,result[0][2]) #point,teamid,unusedNs
    
def send_order_to_server(conn,reward_id):
    with conn.cursor() as cursor:
        for i in range(len(reward_id)):
            puzzle_type = random_puzzle()
            reward_point = get_reward_point(conn,reward_id[i],puzzle_type)
            command = "UPDATE map SET point = '"+ str(reward_point[0]+REWARD_POINT) +"',unused"+str(puzzle_type)+" = '"+str(reward_point[2]+REWARD_PUZZLE_COUNT)+"' WHERE userid = "+ str(reward_id[i])
            cursor.execute(command)
            conn.commit()
            if(reward_point[1]!=None):
                command2 = "UPDATE user,team SET point = "+ str(reward_point[1][0]+REWARD_POINT) +" WHERE user.userid = '"+ str(reward_id[i])+"' AND user.teamid=team.teamid"
                cursor.execute(command2)
                conn.commit()

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

def send_reward():
    random.seed(time.time())
    print('connect to sql!')
    conn = connect_to_sql()
    data = fetch_data(conn)
    print('get personal data!')
    reward_id = get_reward_list(conn,data)
    print(reward_id)
    print('sending to sql!')
    send_order_to_server(conn,reward_id)
    print('update finish!')


if __name__ == "__main__": #main function
    send_reward()