extends Label
#突發事件專用 文字label
onready var Data = get_node("/root/Global") #global.gd用來存放共用的變數

var event_id #題號

var FILE_NUM = 28 #突發事件的數量

var event_01 = {"text":"如果今天約好要聚餐，卻剛好錯過到院區的接駁車，\n你會怎麼做?\nA.沒辦法，只好等下一班公車囉\nB.UBIKE騎起來!\nC.找乾爹乾媽蹭一下車~",
				"A":"","B":"真是勤勞樸實的人wwwww","C":"","answer":"C","number":1}	
var event_02 = {"text":"請從下列選項中選出在星期五傍晚6點時前往院區最\n快的方式\nA.接駁車或公車\nB.UBIKE騎起來!\nC.坐上乾爹乾媽的車車~",
				"A":"結果：塞車塞到崩潰","B":"","C":"結果：塞車塞到崩潰","answer":"B","number":2}	
var event_03 = {"text":"長庚是間______(請選填以下選項)\nA.高中\nB.大學\nC.哎呀！我不知道",
				"A":"這是一個公開的秘密","B":"官方說法…..","C":"你這樣還算是個長庚人嗎？","answer":"A","number":3}
var event_04 = {"text":"快要遲到了！教室在管院，你卻還在明德樓，該怎麼辦？\nA.爬木棧道\nB.放棄這堂課，努力這件事交給明天的我\nC.這種事不可能發生，我彷彿就住在教室裡",
				"A":"勤勞樸實的選擇","B":"希望這堂課不點名哈哈哈","C":"真的是大學生嗎？","answer":"B","number":4}	
var event_05 = {"text":"今天長庚天氣為何？\nA.always陰天\nB.晴天\nC.晴時多雲偶陣雨",
				"A":"","B":"太稀有了吧","C":"囊括所有選項，最安全的答案","answer":"C","number":5}	
var event_06 = {"text":"最適合描寫長庚大學建校的歌曲是？\nA.兒歌《王老先生有塊地》\nB.長庚大學現在的校歌\nC.以上皆是",
				"A":"","B":"","C":"小孩才做選擇，大人當然是全部都要","answer":"A","number":6}
var event_07 = {"text":"請問：全家－7-11=________\nA.1\nB.2\nC.3",
				"A":"","B":"全家有三家，7-11孤軍奮戰","C":"","answer":"B","number":7}	
var event_08 = {"text":"請問學生最多可以在圖書館自習室待多久？\nA.一整天\nB.直到考試結束以前\nC.以上皆是",
				"A":"","B":"","C":"","answer":"C","number":8}	
var event_09 = {"text":"疫情期間，學餐座位一桌最多坐幾人?\nA.保持防疫距離，一個人!\nB.坐好坐滿，四個人\nC.三個人",
				"A":"","B":"","C":"一個位置放包包","answer":"C","number":9}
var event_10 = {"text":"永慶爺爺的銅像翹的是___腳\nA.左\nB.右\nC.雙",
				"A":"","B":"","C":"他是翹腳，不是盤腿!","answer":"A","number":10}	
var event_11 = {"text":"文物館的外型就像\nA.建築物\nB.鳳梨\nC.長得像鳳梨的建築物",
				"A":"想像力是你的超能力!要多多鍛鍊喔)","B":"","C":"","answer":"B","number":11}	
var event_12 = {"text":"長庚大學內便利商店的即期食品會有幾折優惠?\nA.7折\nB.85折\nC.5折",
				"A":"","B":"","C":"","answer":"A","number":12}
var event_13 = {"text":"長庚大學內的便利商店會有學生優惠，請問是打幾折？\nA.9折\nB.85折\nC.8折",
				"A":"","B":"","C":"","answer":"A","number":13}	
var event_14 = {"text":"請問109學年度上學期長庚大學校內總共有幾家\n店結束營業?\nA.4\nB.3\nC.2",
				"A":"","B":"","C":"","answer":"A","number":14}	
var event_15 = {"text":"請問長庚大學的無線網路在下列哪些位置接收不到？\nA.好漢坡、木棧道\nB.操場\nC.以上皆是",
				"A":"","B":"","C":"","answer":"C","number":15}
var event_16 = {"text":"請問長庚大學的校安電話為？\nA.03-3186447\nB.03-2118800\nC.03-2118855",
				"A":"迴龍警察局","B":"長庚大學電話","C":"長庚大學校安專線","answer":"C","number":16}	
var event_17 = {"text":"關於成立新社團，以下哪一敘述為真？\nA.申請書遞交到學務處課外組\nB.須至少10位發起人連署簽名\nC.以上皆是",
				"A":"","B":"","C":"","answer":"C","number":17}	
var event_18 = {"text":"請選出前後兩項課程皆由同一位陳麗如老師教學的選項\nA.特殊教育導論/醫療與社會\nB.現代公民的社會學想像/生涯發展與規劃\nC.特殊需求兒童學習評估/特殊需求兒童教保育",
				"A":"","B":"","C":"","answer":"C","number":18}	
var event_19 = {"text":"長庚大學校內最高的建築物為何？\nA.一醫\nB.工院\nC.管院",
				"A":"","B":"","C":"","answer":"C","number":19}	
var event_20 = {"text":"如果一位同學有特殊的走路方式，每一秒會爬三階，\n但下一秒就會退後一階，請問他總共會花多少時間在爬好漢坡？\nA.251秒\nB.126秒\nC.125秒",
				"A":"","B":"","C":"","answer":"A","number":20}
var event_21 = {"text":"長庚大學「全人教育基本素養」總共有幾項指標？\n(答案就在網頁上，一起來尋找答案吧! https://reurl.cc/5oDjrz )\nA.4種\nB.6種\nC.8種",
				"A":"","B":"","C":"","answer":"B","number":21}
var event_22 = {"text":"全人素養APP各項指標都有一個代表的人物圖案，請問\n『人文藝術』指標的代表人物是誰呢？\n(答案就在網頁上，一起來尋找答案吧! https://reurl.cc/5oDjrz )\nA.小說家\nB.陰陽家\nC.名家",
				"A":"","B":"","C":"","answer":"A","number":22}
var event_23 = {"text":"請問全人素養六個指標人物，神秘的圖案設計者vixiQ\n的真實身分是？\n(答案就在網頁上，一起來尋找答案吧! https://reurl.cc/5oDjrz )\nA.生醫系學姊 (答案正確~會有部分拼圖)\nB.漫研社學姊 (答案正確~會有部分拼圖)\nC.以上皆是(1_最佳解答)",
				"A":"","B":"","C":"","answer":"C","number":23}
var event_24 = {"text":"4.參與各院『院月會』活動，可以納入全人素養軟實力的\n哪一項計分指標？\n(答案就在網頁上，一起來尋找答案吧! https://reurl.cc/5oDjrz )\nA.團隊合作\nB.守分自律\nC.創新進取",
				"A":"","B":"","C":"","answer":"C","number":24}
var event_25 = {"text":"參與『宿舍整潔比賽』活動成績及格者，可以納入全人素\n養軟實力的哪一項計分指標？\n(答案就在網頁上，一起來尋找答案吧! https://reurl.cc/5oDjrz )\nA.團隊合作\nB.自我省思\nC.守分自律",
				"A":"","B":"","C":"","answer":"C","number":25}
var event_26 = {"text":"參與深耕學園藝文活動，可以納入全人素養軟實力的哪一\n項計分指標？\n(答案就在網頁上，一起來尋找答案吧! https://reurl.cc/5oDjrz )\nA.關懷付出\nB.人文藝術\nC.創新進取",
				"A":"","B":"","C":"","answer":"B","number":26}
var event_27 = {"text":"參與長庚大學的傳統活動『好漢坡競賽』，可以納入全人\n素養軟實力的哪一項計分指標？\n(答案就在網頁上，一起來尋找答案吧! https://reurl.cc/5oDjrz )\nA.團隊合作\nB.守分自律\nC.自我省思",
				"A":"","B":"","C":"","answer":"A","number":27}
var event_28 = {"text":"你知道學校手機APP裡面的全人素養軟實力圖像，等級\nLv.49~60每升級一級需要獲得多少分數嗎？\n(答案就在網頁上，一起來尋找答案吧! https://reurl.cc/5oDjrz )\nA.4分\nB.5分\nC.6分",
				"A":"","B":"","C":"","answer":"C","number":28}
				
var events = [event_01,event_02,event_03,event_04,event_05,event_06,event_07,event_08,event_09,event_10,
				event_11,event_12,event_13,event_14,event_15,event_16,event_17,event_18,event_19,event_20,
				event_21,event_22,event_23,event_24,event_25,event_26,event_27,event_28]


func _ready():
	_set_event()

	
#隨機選擇突發事件並讀取對應題目
func _set_event():
	var event_list=Data._get_event_list()
	if len(event_list)==0:#如果沒題目了 就全部隨機
		Data.debug_msg(2,"All event solved!")
		event_id=_random(1,FILE_NUM)
	else:
		var index=_random(0,len(event_list)-1)
		event_id=event_list[index]
	text=events[event_id-1]["text"]
	return events[event_id-1]#回傳題號對應的資料

#取亂數
var rand=RandomNumberGenerator.new()
func _random(begin,end):
	rand.randomize()
	var random_num=rand.randi_range(begin,end)
	return random_num

