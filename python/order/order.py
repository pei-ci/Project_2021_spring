import order_person as op
import order_team as ot
import time

WAIT_SEC = 600 # update each 10 min

if __name__ == "__main__":
    while(True):
        print("-------------------------------")
        op.order_person()
        print("*******************************")
        ot.order_team()
        print("-------------------------------")
        now_time = time.localtime(time.time())
        print("Now Time : " + str(now_time.tm_mon)+"/"+str(now_time.tm_mday)+" "+str(now_time.tm_hour)+":"+str(now_time.tm_min))
        next_time = time.localtime(time.time()+WAIT_SEC)
        print("Next Update : " + str(WAIT_SEC) + " Sec!")
        print("Next Time : " + str(next_time.tm_mon)+"/"+str(next_time.tm_mday)+" "+str(next_time.tm_hour)+":"+str(next_time.tm_min))
        time.sleep(WAIT_SEC) 
