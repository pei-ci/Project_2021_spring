extends Label
#突發事件專用 文字label

<<<<<<< HEAD
var FILE_NUM = 20 #突發事件的數量

var event_01 = {"text":"如果今天約好要聚餐，卻剛好錯過到院區的接駁車，\n你會怎麼做?\nA.沒辦法，只好等下一班公車囉\nB.UBIKE騎起來!\nC.找乾爹乾媽蹭一下車~",
				"A":"","B":"真是勤勞樸實的人wwwww","C":"","answer":"C"}	
var event_02 = {"text":"請從下列選項中選出在星期五傍晚6點時前往院區最\n快的方式\nA.接駁車或公車\nB.UBIKE騎起來!\nC.坐上乾爹乾媽的車車~",
				"A":"結果：塞車塞到崩潰","B":"","C":"結果：塞車塞到崩潰","answer":"B"}	
var event_03 = {"text":"長庚是間______(請選填以下選項)\nA.高中\nB.大學\nC.哎呀！我不知道",
				"A":"這是一個公開的秘密","B":"官方說法…..","C":"你這樣還算是個長庚人嗎？","answer":"A"}
var event_04 = {"text":"快要遲到了！教室在管院，你卻還在明德樓，該怎麼辦？\nA.爬木棧道\nB.放棄這堂課，努力這件事交給明天的我\nC.這種事不可能發生，我彷彿就住在教室裡",
				"A":"勤勞樸實的選擇","B":"希望這堂課不點名哈哈哈","C":"真的是大學生嗎？","answer":"B"}	
var event_05 = {"text":"今天長庚天氣為何？\nA.always陰天\nB.晴天\nC.晴時多雲偶陣雨",
				"A":"","B":"太稀有了吧","C":"囊括所有選項，最安全的答案","answer":"C"}	
var event_06 = {"text":"最適合描寫長庚大學建校的歌曲是？\nA.兒歌《王老先生有塊地》\nB.長庚大學現在的校歌\nC.以上皆是",
				"A":"","B":"","C":"小孩才做選擇，大人當然是全部都要","answer":"A"}
var event_07 = {"text":"請問：全家－7-11=________\nA.1\nB.2\nC.3",
				"A":"","B":"全家有三家，7-11孤軍奮戰","C":"","answer":"B"}	
var event_08 = {"text":"請問學生最多可以在圖書館自習室待多久？\nA.一整天\nB.直到考試結束以前\nC.以上皆是",
				"A":"","B":"","C":"","answer":"C"}	
var event_09 = {"text":"疫情期間，學餐座位一桌最多坐幾人?\nA.保持防疫距離，一個人!\nB.坐好坐滿，四個人\nC.三個人",
				"A":"","B":"","C":"一個位置放包包","answer":"C"}
var event_10 = {"text":"永慶爺爺的銅像翹的是___腳\nA.左\nB.右\nC.雙",
				"A":"","B":"","C":"他是翹腳，不是盤腿!","answer":"A"}	
var event_11 = {"text":"文物館的外型就像\nA.建築物\nB.鳳梨\nC.長得像鳳梨的建築物",
				"A":"想像力是你的超能力!要多多鍛鍊喔)","B":"","C":"","answer":"B"}	
var event_12 = {"text":"長庚大學內便利商店的即期食品會有幾折優惠?\nA.7折\nB.85折\nC.5折",
				"A":"","B":"","C":"","answer":"A"}
var event_13 = {"text":"長庚大學內的便利商店會有學生優惠，請問是打幾折？\nA.9折\nB.85折\nC.8折",
				"A":"","B":"","C":"","answer":"A"}	
var event_14 = {"text":"請問109學年度上學期長庚大學校內總共有幾家\n店結束營業?\nA.4\nB.3\nC.2",
				"A":"","B":"","C":"","answer":"A"}	
var event_15 = {"text":"請問長庚大學的無線網路在下列哪些位置接收不到？\nA.好漢坡、木棧道\nB.操場\nC.以上皆是",
				"A":"","B":"","C":"","answer":"C"}
var event_16 = {"text":"請問長庚大學的校安電話為？\nA.03-3186447\nB.03-2118800\nC.03-2118855",
				"A":"迴龍警察局","B":"長庚大學電話","C":"長庚大學校安專線","answer":"C"}	
var event_17 = {"text":"關於成立新社團，以下哪一敘述為真？\nA.申請書遞交到學務處課外組\nB.須至少10位發起人連署簽名\nC.以上皆是",
				"A":"","B":"","C":"","answer":"C"}	
var event_18 = {"text":"請選出前後兩項課程皆由同一位陳麗如老師教學的選項\nA.特殊教育導論/醫療與社會\nB.現代公民的社會學想像/生涯發展與規劃\nC.特殊需求兒童學習評估/特殊需求兒童教保育",
				"A":"","B":"","C":"","answer":"C"}	
var event_19 = {"text":"長庚大學校內最高的建築物為何？\nA.一醫\nB.工院\nC.管院",
				"A":"","B":"","C":"","answer":"C"}	
var event_20 = {"text":"如果一位同學有特殊的走路方式，每一秒會爬三階，\n但下一秒就會退後一階，請問他總共會花多少時間在爬好漢坡？\nA.251秒\nB.126秒\nC.125秒",
				"A":"","B":"","C":"","answer":"A"}
var events = [event_01,event_02,event_03,event_04,event_05,event_06,event_07,event_08,event_09,event_10,
				event_11,event_12,event_13,event_14,event_15,event_16,event_17,event_18,event_19,event_20]

func _ready():
	_set_event()

	
#隨機選擇突發事件並讀取對應題目
func _set_event():
	var num=_random(1,FILE_NUM)
	text=events[num-1]["text"]
	return events[num-1]#告知此題是哪題 用在選項選擇的判斷上
=======
var FILE_NUM = 2 #突發事件的數量
var file = 'res://default.txt'
#隨機事件的檔案
var file_default = file
var file1 = 'res://emergency_01.txt'
var file2 = 'res://emergency_02.txt'
# Called when the node enters the scene tree for the first time.

func _ready():
	text =_load_file(file)

#讀取檔案
func _load_file(file_output): 
	var f = File.new()
	f.open(file_output,File.READ)
	var line=""
	while not f.eof_reached():
		line = line + "\n" + f.get_line()
	f.close()
	return line
	
#隨機選擇突發事件並讀取對應題目
func _set_file():
	var num=_random(1,FILE_NUM)
	if num==1:
		file=file1
	elif num==2:
		file=file2
	else:
		file=file_default
	text = _load_file(file)
	return num     #告知此題是哪題 用在選項選擇的判斷上
>>>>>>> 574e264f1187e781006541a6eef8a36eb0cf9022

#取亂數
var rand=RandomNumberGenerator.new()
func _random(begin,end):
	rand.randomize()
	var random_num=rand.randi_range(begin,end)
	return random_num
<<<<<<< HEAD

=======
>>>>>>> 574e264f1187e781006541a6eef8a36eb0cf9022
