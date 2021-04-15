<?php
$GLOBALS['SERVER_VERSION'] = '0415_1b'; 

$GLOBALS['LOGIN_TIME_LIMIT'] = 10800; //3600*3 = 3hr
$GLOBALS['EMERGENCY_EXIST_TIME'] = 43200; //3600*12 = 12hr
$GLOBALS['BASIC_EMERGENCY_DOWN_TIME'] = 43200; //3600*12 = 12hr

//$GLOBALS['UNUSED_PUZZLE_POINT'] = 25;
//$GLOBALS['UNUSED_CORRECT_PUZZLE_POINT'] = 50;
$GLOBALS['USED_PUZZLE_POINT'] = 10;
$GLOBALS['SPECIAL_PUZZLE_POINT'] = 300;

$GLOBALS['EMERGENCY_DEFAULT_VALUE'] = '000000000000000000000000000000';
$GLOBALS['TITLE_DEFAULT_VALUE'] = '00000000000000000000000000000000';

session_start();
$postdata = file_get_contents("php://input",'r'); 
$data = json_decode($postdata,true);

$type = $data['type'];
if ($type == NULL){ 
    error_and_logout('No command provided!');
    die('Dealing Unknown Request!');
}

//Open a new connection to the MySQL server
$mysqli = new mysqli('localhost', 'root', '', 'school_games_3nd');
//Output any connection error
if ($mysqli->connect_error) {
    error_and_logout('SQL Not Respond!');
    die('Error : (' . $mysqli->connect_errno . ') ' . $mysqli->connect_error);
}

$login_certification = '0000000000000000000';
if(array_key_exists('validation',$data)){
    $login_certification = $data['validation'];
    if(!verify_login_validation($mysqli,$login_certification)){
        return;
    }
}else{
    switch($type){
        // the following request are acceptable without validation-info
        case 'register':
            break;
        case 'login':
            break;
        case 'rank':
            break;
        case 'team_member':
            break;
        case 'news':
            break;
        default:
            error_and_logout('No validation provided!');
            return;
    }
}

switch($type){
    case 'login':   //work
        $email = $data['number'];
        $password = $data['password'];
        dealing_login_request($mysqli,$email,$password);
        break;
    case 'register': //work
        $email = $data['number'];
        $password = $data['password'];
        $department = $data['department'];
        $name = $data['name'];
        $nickname = $data['nickname'];
        dealing_register_request($mysqli,$email,$password,$name,$department,$nickname);
        break;
    case 'log': //work
        $type = $data['log_type'];
        $value = $data['value'];
        dealing_log_request($mysqli,$login_certification,$type,$value);
        break;
    case 'info':    //work
        dealing_info_request($mysqli,$login_certification);
        break;
    case 'title_oper':    //work
        $oper = $data['oper'];
        $number = $data['number'];
        dealing_title_oper_request($mysqli,$login_certification,$oper,$number);
        break;
    case 'activity':    //work
        dealing_activity_request($mysqli,$login_certification);
        break;
    case 'map':     //work
        dealing_map_request($mysqli,$login_certification);
        break;
    case 'map_oper':    //work,map operation
        $oper = $data['oper'];
        $block_type = $data['block_type'];
        $pos = $data['pos'];
        dealing_map_oper_request($mysqli,$login_certification,$oper,$block_type,$pos);
        break;
    case 'special':
        $value = $data['value'];
        $set = $data['set'];
        dealing_special_request($mysqli,$login_certification,$value,$set);
        break;
    case 'place_click':
        dealing_place_click_request($mysqli,$login_certification);
        break;
    case 'team':    //work
        dealing_team_request($mysqli,$login_certification);
        break;
    case 'create_team':    //work
        $team_name = $data["team_name"];
        dealing_create_team_request($mysqli,$login_certification,$team_name);
        break;
    case 'join_team': //work
        $team_id = $data['teamid'];
        dealing_join_team_request($mysqli,$login_certification,$team_id);
        break;
    case 'team_member': //work
        $team_id = $data['teamid'];        
        dealing_team_member_request($mysqli,$team_id);
        break;
    case 'emergency': //work
        $map_type = $data['map_type'];
        $map_amount = $data['amount'];
        $correct = $data['correct'];
        $event_id = $data['event_id'];
        $command_type = $data['command_type'];
        $point = $data['point'];
        dealing_emergency_request($mysqli,$login_certification,$map_type,$map_amount,$correct,$event_id,$command_type,$point);
        break;    
    case 'emergency_info': //work
        dealing_emergency_info_request($mysqli,$login_certification);
        break;
    case 'emergency_time': //work
        $command_type = $data['command_type'];
        $time = $data['time'];
        dealing_emergency_time_request($mysqli,$login_certification,$time,$command_type);
        break;
    case 'rank': //work
        $rank_type = $data['rank_type'];
        dealing_rank_request($mysqli,$rank_type);
        break;
    case 'news':
        dealing_news_request($mysqli);
        break;
    default: //work
        error_and_logout('Not support command!');
        break;
}


function verify_login_validation($mysqli,$login_certification){
    $validation_time = (int)substr($login_certification,0,10);
    if(abs(time()-$validation_time) > $GLOBALS['LOGIN_TIME_LIMIT']){ 
        error_and_logout('Reach login time limit!');
        return false;
    }
    return true;
}

function error_and_logout($message){
    $respond = array();
    $respond['type'] = 'logout';
    $respond['sucess'] = 'false';
    $respond['error'] = $message;
    $respond['version'] = $GLOBALS['SERVER_VERSION'];
    echo json_encode($respond);
    exit();
}

function dealing_login_request($mysqli,$email,$password){    
    $query = "SELECT user.userid, password, log.login_time FROM user,log WHERE user.number='$email' AND user.userid=log.userid";
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $row = mysqli_fetch_array($result);

    $respond = array();
    $respond["type"] = "login";
    $respond["sucess"] = 'false';
    $respond["error"] = 'unknown';
    if ($num_row == 1) {
        if (password_verify($password, $row['password'])){
            $userid = $row['userid'];
            $check_num = time().rand(111111111,999999999);
            $query = "UPDATE user SET validation='$check_num' WHERE userid='$userid'";
            $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));

            if($result){
                $respond["validation"] = $check_num; 
                $respond['login_time'] = $row['login_time'];               
                $respond["sucess"] = 'true';
            }
        }else{
            $respond['error'] = 'error_user_or_password';
        }
    }else{
        $respond['error'] = 'error_user_or_password';
    }
    echo json_encode($respond);
}

function dealing_register_request($mysqli,$email,$password,$name,$department,$nickname){
    $respond = array();
    $respond['type'] = 'register';
    $respond['sucess'] = 'false';

    //check if user exist
    $query_check_username = "SELECT userid FROM user WHERE number='$email'";
    $result_check_username = mysqli_query($mysqli, $query_check_username) or die(mysqli_error($mysqli));
    $num_row_check_username = mysqli_num_rows($result_check_username);
    if ($num_row_check_username>0){
        $respond['error'] = 'user_exist';
        $respond['count'] = $num_row_check_username;
        echo json_encode($respond);
        return;
    }
    //register to user table
    $password = password_hash($password,PASSWORD_DEFAULT);
    $title = $GLOBALS['TITLE_DEFAULT_VALUE'];
    $query_register_user = "INSERT INTO user (name, department, number, password ,nickname ,title) 
            VALUE ('$name','$department','$email','$password','$nickname','$title')";
    $result_register_user = mysqli_query($mysqli, $query_register_user) or die(mysqli_error($mysqli));
    //get userid from user table
    $query_id = "SELECT userid FROM user WHERE number='$email' AND password='$password'";
    $result_id = mysqli_query($mysqli, $query_id) or die(mysqli_error($mysqli));
    $row = mysqli_fetch_array($result_id);
    $id = $row['userid'];
    //register to map table
    $emergency = $GLOBALS['EMERGENCY_DEFAULT_VALUE'];
    $query_register_map = "INSERT INTO map (userid,emergency_list) VALUE ('$id','$emergency')";
    $result_register_map = mysqli_query($mysqli, $query_register_map) or die(mysqli_error($mysqli));
    
    $query_register_log = "INSERT INTO log (userid) VALUE ('$id')";
    $result_register_log = mysqli_query($mysqli, $query_register_log) or die(mysqli_error($mysqli));

    if(($result_register_user && $result_register_map) && $result_register_log){
        $respond['sucess'] = 'true';
    }
    echo json_encode($respond);
}

function dealing_log_request($mysqli,$login_certification,$log_type,$value){
    $query_id = "SELECT userid FROM user WHERE validation='$login_certification'";
    $result_id = mysqli_query($mysqli, $query_id) or die(mysqli_error($mysqli));
    $num_row_id = mysqli_num_rows($result_id);
    $row_id = mysqli_fetch_array($result_id);
    

    $respond = array();
    $respond['type'] = 'log';
    $respond['sucess'] = 'false';
    $respond['log_type'] = $log_type;

    if($num_row_id==0){
        echo json_encode($respond);
    }
    $userid = $row_id['userid'];

    if($log_type=='login'){        
        $current_time = time();
        $query = "UPDATE log SET login_time='$current_time' WHERE userid='$userid'";
        $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
        if($value=="1"){
            $query_count = "SELECT login_count FROM log WHERE userid='$userid'";
            $result_count = mysqli_query($mysqli, $query_count) or die(mysqli_error($mysqli));
            $row_count = mysqli_fetch_array($result_count);

            $new_login_count = $row_count['login_count']+1;
            $query_login_update = "UPDATE log SET login_count='$new_login_count' WHERE userid='$userid'";
            $result_login_update = mysqli_query($mysqli, $query_login_update) or die(mysqli_error($mysqli));
            if(!$result_login_update){
                echo json_encode($respond);
            }
        }
        if($result){
            $respond['sucess'] = 'true';
        }
    }
    
    echo json_encode($respond);
}

function dealing_info_request($mysqli,$login_certification){
    $query = "SELECT * FROM user WHERE validation='$login_certification'";
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $row = mysqli_fetch_array($result);
    $respond = array();
    $respond['type'] = 'info';
    if ($num_row >= 1){
        $respond["sucess"] = "true";
        $respond["number"] = $row['number'];
        $respond["name"] = $row['name'];
        $respond["nickname"] = $row['nickname'];
        $respond["department"] = $row['department'];
        $respond["teamid"] = $row['teamid'];
        $respond["title"] = $row['title'];
        $respond["title_use"] = $row['title_use'];
        $respond["rank"] = $row['rank'];
    }else{
        $respond["sucess"] = "false";
    }
    echo json_encode($respond);
}

function dealing_title_oper_request($mysqli,$login_certification,$oper,$number){
    $query_fetch = "SELECT title,title_use FROM user WHERE validation='$login_certification'";
    $result_fetch = mysqli_query($mysqli, $query_fetch) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result_fetch);
    $row = mysqli_fetch_array($result_fetch);
    $old_title = $row['title'];

    $respond = array();
    $respond['type']='title_oper';
    $respond['sucess']='false';
    $respond['error'] = 'unknown';

    if($oper == 'add'){
        if($old_title[$number]=='1'){
            $respond['error'] = 'already_have';
            echo json_encode($respond);
            return;
        }
        $new_title = substr($old_title,0,$number).'1'.substr($old_title,$number+1);
        $query_set = "UPDATE user SET title='$new_title' WHERE validation='$login_certification'";
        $result_set = mysqli_query($mysqli, $query_set) or die(mysqli_error($mysqli));
        if($result_set){
            $respond['sucess']='true';
        }
    }else if($oper == 'use'){
        if(substr($old_title,$number,1)=='1'){ //check if have that title
            $new_title_use = $number;
            $query_set = "UPDATE user SET title_use='$new_title_use' WHERE validation='$login_certification'";
            $result_set = mysqli_query($mysqli, $query_set) or die(mysqli_error($mysqli));
            if($result_set){
                $respond['sucess']='true';
            }
        }
    }
    echo json_encode($respond);
}

function dealing_activity_request($mysqli,$login_certification){
    $query = "SELECT activity.number, activity.point
     FROM user, activity WHERE user.validation='$login_certification' AND user.userid = activity.userid";
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);

    $respond = array();
    $respond['type'] = 'activity';
    $respond['sucess'] = 'true';
    $respond['count'] = $num_row;
    for($x = 0; $x < $num_row; $x++) {
        $row = mysqli_fetch_array($result);
        $respond['number'.$x] = $row['number'];
        $respond['point'.$x] = $row['point'];
    }    
    echo json_encode($respond);    
}

function dealing_map_request($mysqli,$login_certification){
    $query = "SELECT map.unused1, map.unused2, map.unused3, map.unused4, map.unused5, map.unused6, used ,special , pos, val ,place_click 
     FROM user, map WHERE user.validation='$login_certification' AND user.userid = map.userid";
    // ,map.emergency_time
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $row = mysqli_fetch_array($result);

    $respond = array();
    $respond['type'] = 'map';
    if ($num_row >= 1){
        $respond['sucess'] = 'true';
    }else{
        $respond['sucess'] = 'false';        
        echo json_encode($respond);
    }
    $respond['unused1'] = $row['unused1'];
    $respond['unused2'] = $row['unused2'];
    $respond['unused3'] = $row['unused3'];
    $respond['unused4'] = $row['unused4'];
    $respond['unused5'] = $row['unused5'];
    $respond['unused6'] = $row['unused6'];
    $respond['used'] = $row['used'];
    $respond['point'] = get_personal_point($mysqli,$login_certification,NULL);
    $respond['special'] = $row['special'];
    $respond['pos'] = $row['pos'];
    $respond['val'] = $row['val'];
    $respond['place_click'] = $row['place_click'];
    //$respond['emergency_time'] = $row['emergency_time'];

    echo json_encode($respond);
}

function dealing_map_oper_request($mysqli,$login_certification,$oper,$block_type,$pos){
    $respond = array();
    $respond['type'] = 'map_oper';
    $respond['sucess'] = 'false';

    //check block amount in map table
    $target_block = "map.unused".$block_type;
    $query_check = "SELECT ".$target_block." ,used, pos, val, map.userid ,user.teamid 
    FROM user, map WHERE user.validation='$login_certification' AND user.userid = map.userid";
    $result_check = mysqli_query($mysqli, $query_check) or die(mysqli_error($mysqli));
    $num_row_check = mysqli_num_rows($result_check);
    $row_check = mysqli_fetch_array($result_check);
    if($num_row_check!=1 || $row_check['unused'.$block_type]<1){
        echo json_encode($respond);
        return;
    }    

    $unused = (int)$row_check['unused'.$block_type]-1;
    $userid = $row_check['userid'];
    $teamid = $row_check['teamid'];
    $used = (int)$row_check['used']+1;

    if(!update_point($mysqli,$teamid!=NULL,$login_certification,$GLOBALS['USED_PUZZLE_POINT'])){
        $respond['error'] = 'unable_update_point';
        echo json_encode($respond);
        return;
    }
    /*
    if(!update_person_point($mysqli,$login_certification,$GLOBALS['USED_PUZZLE_POINT'])){
        $respond['error'] = 'unable_update_person_point';
        echo json_encode($respond);
        return;
    }

    $respond['write_to_team'] = 'false';
    if(!$teamid==NULL){
        if(update_team_point($mysqli,$login_certification,$GLOBALS['USED_PUZZLE_POINT'])){
            $respond['write_to_team'] = 'true';
        }else{
            echo json_encode($respond);
            return;
        }
    }   
    */
    if($oper == 'upgrade1'){
        $index = strpos($row_check['pos'],$pos);
        $index /= 4;
        $new_pos = $row_check['pos'];
        $new_val = substr($row_check['val'],0,$index*2).$block_type.'2'.substr($row_check['val'],($index+1)*2);
    }else if($oper == 'upgrade2'){
        $index = strpos($row_check['pos'],$pos);
        $index /= 4;
        $new_pos = $row_check['pos'];
        $new_val = substr($row_check['val'],0,$index*2).$block_type.'3'.substr($row_check['val'],($index+1)*2);
        $respond['val'] = $new_val;
    }else if($oper == 'put'){
        $new_pos = $row_check['pos'].$pos;
        $new_val = $row_check['val'].$block_type.'1';                        
    }
    $query_put = "UPDATE map SET used='$used',pos='$new_pos',val='$new_val',$target_block='$unused'
                    WHERE userid='$userid'";
    $result_put = mysqli_query($mysqli, $query_put) or die(mysqli_error($mysqli));
    
    if($result_put){
        $respond['pos'] = $new_pos;
        $respond['val'] = $new_val;
        $respond['block_type'] = $block_type;
        $respond['sucess'] = 'true';
    }
    echo json_encode($respond);
}

function dealing_special_request($mysqli,$login_certification,$value,$set){
    $respond = array();
    $respond['type'] = 'special';
    $respond['sucess'] = 'false';
    $respond['set'] = $set;

    $query_put = "UPDATE map,user SET special='$value' WHERE user.validation='$login_certification' AND user.userid = map.userid";
    $result_put = mysqli_query($mysqli, $query_put) or die(mysqli_error($mysqli));
    
    if($set=='1'){
        $respond['write_to_team'] = 'false';
        if(update_point($mysqli,true,$login_certification,$GLOBALS['SPECIAL_PUZZLE_POINT'])){
            $respond['write_to_team'] = 'true';
        }
    }
    

    if($result_put){
        $respond['sucess'] = 'true';
        $respond['value'] = $value;
    }
    echo json_encode($respond);
}

function dealing_place_click_request($mysqli,$login_certification){
    $query = "SELECT user.userid ,map.place_click FROM user, map WHERE user.validation='$login_certification' AND user.userid = map.userid";
    // ,map.emergency_time
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $row = mysqli_fetch_array($result);

    $respond = array();
    $respond['type'] = 'place_click';
    $respond['sucess'] = 'false';
    if ($num_row >= 1){
        $userid = $row['userid'];
        $place_click = $row['place_click']+1;
        $query_put = "UPDATE map SET place_click='$place_click' WHERE userid='$userid'";
        $result_put = mysqli_query($mysqli, $query_put) or die(mysqli_error($mysqli));
        if($result_put){
            $respond['sucess'] = 'true';
        }
    }
    echo json_encode($respond);
}

function dealing_team_request($mysqli,$login_certification){
    //$query = "SELECT team.name, team.mem1, team.mem2, team.mem3, team.mem4, team.mem5, team.mem6, 
    //team.mem7, team.mem8, team.mem9, team.mem10, team.point, team.rank ,team.teamid 
    // FROM user, team WHERE user.validation='$login_certification' AND user.teamid = team.teamid";
    $query = "SELECT team.name, team.point, team.rank ,team.teamid 
     FROM user, team WHERE user.validation='$login_certification' AND user.teamid = team.teamid";
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $row = mysqli_fetch_array($result);

    $respond = array();
    $respond['type'] = 'team';
    if ($num_row >= 1){
        $respond['sucess'] = 'true';
    }else{
        $respond['sucess'] = 'false';
    }
    $respond['name'] = $row['name'];
    /*
    $respond['mem1'] = $row['mem1'];
    $respond['mem2'] = $row['mem2'];
    $respond['mem3'] = $row['mem3'];
    $respond['mem4'] = $row['mem4'];
    $respond['mem5'] = $row['mem5'];
    $respond['mem6'] = $row['mem6'];
    $respond['mem7'] = $row['mem7'];
    $respond['mem8'] = $row['mem8'];
    $respond['mem9'] = $row['mem9'];
    $respond['mem10'] = $row['mem10'];
    */
    $respond['point'] = $row['point'];
    $respond['rank'] = $row['rank'];
    $respond['teamid'] = $row['teamid'];

    echo json_encode($respond);
}

function dealing_create_team_request($mysqli,$login_certification,$team_name){
    $query = "SELECT teamid FROM user WHERE validation='$login_certification'";
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $row = mysqli_fetch_array($result);

    $respond = array();
    $respond["type"] = "create_team";
    $respond["sucess"] = "false";
    if($num_row >= 1){
        if($row["teamid"]==NULL){ //create team
            do{
            $team_num = rand(111111,999999);
            $query_id_verify = "SELECT name FROM team WHERE teamid='$team_num'";
            $result_id_verify = mysqli_query($mysqli, $query_id_verify) or die(mysqli_error($mysqli));
            $num_row_verify = mysqli_num_rows($result_id_verify);
            }while($num_row_verify>0);
            //get how many in team table            
            $query_count = "SELECT COUNT(*) FROM team";
            $result_count = mysqli_query($mysqli, $query_count) or die(mysqli_error($mysqli));
            $row_count = mysqli_fetch_array($result_count);
            $count = $row_count[0]+1; //get rank position
            $respond['count'] = $count;
            //get personal id
            $query_id = "SELECT userid FROM user WHERE validation='$login_certification'";
            $result_id = mysqli_query($mysqli, $query_id) or die(mysqli_error($mysqli));
            $row_id = mysqli_fetch_array($result_id);
            $id = $row_id[0];
            $respond['id'] = $id;
            //get personal map count
            $query_map = "SELECT map.used FROM user, map WHERE user.validation='$login_certification' AND user.userid = map.userid";
            $result_map = mysqli_query($mysqli, $query_map) or die(mysqli_error($mysqli));
            $row_map = mysqli_fetch_array($result_map);
            $map_count = $row_map[0];
            $respond['map_count'] = $map_count;
            //set team id to team table
            $query_2 = "INSERT INTO team (teamid, name, mem1, point, rank) 
            VALUE ('$team_num','$team_name','$id','$map_count','$count')";
            $result_2 = mysqli_query($mysqli, $query_2) or die(mysqli_error($mysqli));
            //set team id to user table
            $query_1 = "UPDATE user SET teamid='$team_num' WHERE validation='$login_certification'";
            $result_1 = mysqli_query($mysqli, $query_1) or die(mysqli_error($mysqli));
            
            if(!$result_1){
                $respond['error'] = "unable_set_user_table";
                echo json_encode($respond);
            }
            if(!$result_2){
                $respond['error'] = "unable_set_team_table";
                echo json_encode($respond);
            }
            $respond['sucess'] = 'true';
            $respond['teamid'] = $team_num;

        }else{
            $respond['error'] = "already_have_team";
            echo json_encode($respond);
        }
    }
    echo json_encode($respond);
}

function dealing_join_team_request($mysqli,$login_certification,$team_id){
    
    $respond = array();
    $respond['type'] = 'join_team';
    $respond['sucess'] = 'false';
    $respond['error'] = 'unknown';
    //get used in map table
    $query_check_user = "SELECT user.userid,used FROM map,user WHERE user.validation='$login_certification' AND user.userid = map.userid";
    $result_check_user = mysqli_query($mysqli, $query_check_user) or die(mysqli_error($mysqli));
    $row_check_user = mysqli_fetch_array($result_check_user);
    //check if team exist, and get the current point in team table
    $query_check_team = "SELECT members,point FROM team WHERE teamid='$team_id'";
    $result_check_team = mysqli_query($mysqli, $query_check_team) or die(mysqli_error($mysqli));
    $num_row_check_team = mysqli_num_rows($result_check_team);
    $row_check_team = mysqli_fetch_array($result_check_team);
    if($num_row_check_team!=1){
        $respond['error'] = 'team_not_exist';
        echo json_encode($respond);
        return;
    }
    if((int)$row_check_team['members']==10){
        $respond['error'] = 'team_full';
        echo json_encode($respond);
        return;
    }

    $new_team_point = (int)$row_check_team['point'] + get_personal_point($mysqli,$login_certification,NULL);
    $new_team_members = (int)$row_check_team['members']+1;
    $user_id = $row_check_user['userid'];
    
    $query_set_team = "UPDATE team SET point='$new_team_point', members = '$new_team_members', 
    mem".$new_team_members." = '$user_id' WHERE teamid='$team_id'";
    $result_set_team = mysqli_query($mysqli, $query_set_team) or die(mysqli_error($mysqli));
    $query_set_user = "UPDATE user SET teamid='$team_id' WHERE user.validation='$login_certification'";
    $result_set_user = mysqli_query($mysqli, $query_set_user) or die(mysqli_error($mysqli));
    if($result_check_user&&$result_check_user&&$result_set_team && $result_set_user){
        $respond['sucess'] = 'true';
    }
    echo json_encode($respond);
}

function dealing_team_member_request($mysqli,$team_id){
    $query_mem = "SELECT mem1,mem2,mem3,mem4,mem5,mem6,mem7,mem8,mem9,mem10
     FROM team WHERE teamid='$team_id'";
    $result_mem = mysqli_query($mysqli, $query_mem) or die(mysqli_error($mysqli));
    $num_row_mem = mysqli_num_rows($result_mem);
    $row_mem = mysqli_fetch_array($result_mem);
    $respond = array();
    $respond['type'] = 'team_member';
    $respond['sucess'] = 'true';
    for ($x = 0; $x < 10; $x++) {
        $u_id = $row_mem['mem'.($x+1)];
        if(!$u_id==NULL){
            $query_user = "SELECT number,name,map.used FROM user,map WHERE map.userid='$u_id' AND user.userid='$u_id'";
            $result_user = mysqli_query($mysqli, $query_user) or die(mysqli_error($mysqli));
            $row_user = mysqli_fetch_array($result_user);
            if(!$result_user){
                $respond['sucess'] = 'false';
                return;
            }
            $respond['mem'.($x+1).'number'] = $row_user['number'];
            $respond['mem'.($x+1).'name'] = $row_user['name'];
            $respond['mem'.($x+1).'used'] = $row_user['used'];
        }else{
            $respond['mem'.($x+1).'number'] = '-1';
            $respond['mem'.($x+1).'name'] = '-1';
            $respond['mem'.($x+1).'used'] = '-1';
        }       
        
    } 
    echo json_encode($respond); 
}

function dealing_emergency_request($mysqli,$login_certification,$map_type,$map_amount,$correct,$event_id,$command_type,$point){
    $event_id = (int)$event_id;
    $respond = array();
    $respond['type'] = 'emergency';
    $respond['command_type'] = $command_type;
    $respond['get_type'] = $map_type;
    $respond['sucess'] = 'false';
    $respond['write_to_team'] = 'false';

    if($command_type=='add_map'){
    $request_type = 'unused'.$map_type;
    $query_amount = "SELECT $request_type,teamid FROM user, map WHERE user.validation='$login_certification' AND user.userid = map.userid";
    $result_amount = mysqli_query($mysqli, $query_amount) or die(mysqli_error($mysqli));
    $num_row_amount = mysqli_num_rows($result_amount);
    $row_amount = mysqli_fetch_array($result_amount);
    $teamid = $row_amount['teamid'];    

    if ($num_row_amount >= 1){
        $new_amount = $row_amount[$request_type] + $map_amount;
        $query_update = "UPDATE map,user SET $request_type='$new_amount' WHERE user.validation='$login_certification' AND user.userid = map.userid";
        $result_update = mysqli_query($mysqli, $query_update) or die(mysqli_error($mysqli));
        /*
        if($correct=='1'){
            $add_point = $GLOBALS['UNUSED_PUZZLE_POINT'];
        }else{
            $add_point = $GLOBALS['UNUSED_CORRECT_PUZZLE_POINT'];
        }
            
        if(update_point($mysqli,$teamid!=NULL,$login_certification,$add_point)){
            if($teamid!=NULL){   
                $respond['write_to_team'] = 'true';
            }
        }else{
            echo json_encode($respond);
            return;
        }
          */

        if($result_update){
            $respond['sucess'] = 'true';
        }
    }
    echo json_encode($respond);


    }else if($command_type=='record'){  
        $query_emergency = "SELECT emergency_finish, emergency_best , emergency_list 
        FROM user, map WHERE user.validation='$login_certification' AND user.userid = map.userid";
        $result_emergency = mysqli_query($mysqli, $query_emergency) or die(mysqli_error($mysqli));
        $num_row_emergency = mysqli_num_rows($result_emergency);
        if ($num_row_emergency >= 1){
            $row_emergency = mysqli_fetch_array($result_emergency);

            $new_emergency_finish = (int)$row_emergency['emergency_finish'] + 1;
            $new_emergency_best = (int)$row_emergency['emergency_best'] + (int)$correct;
            
            $query_update = "UPDATE map,user SET emergency_finish='$new_emergency_finish', emergency_best='$new_emergency_best'  
             WHERE user.validation='$login_certification' AND user.userid = map.userid";
            $result_update = mysqli_query($mysqli, $query_update) or die(mysqli_error($mysqli));
            
            $old_emergency_list = $row_emergency['emergency_list'];
            if($old_emergency_list[$event_id]=='1'){
                //already have no change need
                $result_set = true;
            }else{
                $new_emergency_list = substr($old_emergency_list,0,$event_id).'1'.substr($old_emergency_list,$event_id+1);
                $query_set = "UPDATE map,user SET emergency_list='$new_emergency_list' 
                            WHERE user.validation='$login_certification' AND user.userid = map.userid";
                $result_set = mysqli_query($mysqli, $query_set) or die(mysqli_error($mysqli));
            }

            if(update_point($mysqli,true,$login_certification,$point)){
                    $respond['write_to_team'] = 'true';
                
            }else{
                echo json_encode($respond);
                return;
            }

            if($result_set && $result_update){
                $respond['sucess']='true';
            }
        }

        echo json_encode($respond);
    }
}

function dealing_emergency_info_request($mysqli,$login_certification){
    $query_emergency_info = "SELECT map.emergency_time, map.emergency_list, map.emergency_finish, map.emergency_best
     FROM map,user WHERE user.validation='$login_certification' AND user.userid = map.userid";
    $result_emergency_info = mysqli_query($mysqli, $query_emergency_info) or die(mysqli_error($mysqli));
    $num_row_emergency_info = mysqli_num_rows($result_emergency_info);

    $respond = array();
    $respond['type'] = 'emergency_info';
    $respond['sucess'] = 'false';
    if($num_row_emergency_info>0){
        $row_emergency_info = mysqli_fetch_array($result_emergency_info);
        $respond['emergency_time'] = $row_emergency_info['emergency_time'];
        $respond['emergency_list'] = $row_emergency_info['emergency_list'];
        $respond['emergency_finish'] = $row_emergency_info['emergency_finish'];
        $respond['emergency_best'] = $row_emergency_info['emergency_best'];
        $respond['sucess'] = 'true';
    }
    echo json_encode($respond);
}

function dealing_emergency_time_request($mysqli,$login_certification,$time,$command_type){
    $respond = array();
    $respond['type'] = 'emergency_time';
    $respond['sucess'] = 'false';
    $respond['command_type'] = $command_type;
    $respond['time'] = $time;

    if($command_type == 'set'){
        $query_emergency_time = "UPDATE map,user SET emergency_time='$time' 
            WHERE user.validation='$login_certification' AND user.userid = map.userid";
        $result_emergency_time = mysqli_query($mysqli, $query_emergency_time) or die(mysqli_error($mysqli));
        if($result_emergency_time){
            $respond['sucess'] = 'true';
            echo json_encode($respond);
        }
    }
    /*
    $query_emergency = "SELECT emergency_time FROM user, map WHERE user.validation='$login_certification' AND user.userid = map.userid";
    $result_emergency = mysqli_query($mysqli, $query_emergency) or die(mysqli_error($mysqli));
    $num_row_emergency = mysqli_num_rows($result_emergency);
    if ($num_row_emergency >= 1){
        $row_emergency = mysqli_fetch_array($result_emergency);            
        $post_time = $row_emergency['emergency_time'];
        $check_time = (int)substr($post_time,1);

        if($command_type=='down'){
            $respond = emergency_time_down($mysqli,$post_time,$check_time,$login_certification,$respond);
        }else if($command_type=='up'){ //up
            $respond = emergency_time_up($mysqli,$post_time,$check_time,$login_certification,$respond);
        }else if($command_type=='solve'){
            $respond = emergency_time_solve($mysqli,$post_time,$check_time,$login_certification,$respond);      
        }
    }
    */
    echo json_encode($respond);    
}
/*
function emergency_time_down($mysqli,$post_time,$check_time,$login_certification,$respond){
    if(($post_time[0]=='1'||$post_time[0]=='2')&&(time()>$check_time)){
        $new_post_time = time()+$GLOBALS['BASIC_EMERGENCY_DOWN_TIME']+(time()-$check_time);
        $new_post_time = '0'.(string)$new_post_time;
        $query_emergency_time = "UPDATE map,user SET emergency_time='$new_post_time' 
            WHERE user.validation='$login_certification' AND user.userid = map.userid";
        $result_emergency_time = mysqli_query($mysqli, $query_emergency_time) or die(mysqli_error($mysqli));
        if($result_emergency_time){
            $respond['sucess'] = 'true';
            echo json_encode($respond);
        }
    }
    return $respond;
}

function emergency_time_up($mysqli,$post_time,$check_time,$login_certification,$respond){
    if($post_time[0]=='0' && (time()>$check_time)){ //current time excess the CD
        $new_post_time='1'.(time()+$GLOBALS['EMERGENCY_EXIST_TIME']);
        $query_emergency_time = "UPDATE map,user SET emergency_time='$new_post_time' 
            WHERE user.validation='$login_certification' AND user.userid = map.userid";
        $result_emergency_time = mysqli_query($mysqli, $query_emergency_time) or die(mysqli_error($mysqli));
        if($result_emergency_time){
            $respond['sucess'] = 'true';
            echo json_encode($respond);
        }                    
    }else{
        $respond['error'] = 'Emergency_request_not_down';
    }
    return $respond;
}

function emergency_time_solve($mysqli,$post_time,$check_time,$login_certification,$respond){
    if($post_time[0]=='1' && ($check_time>time())){ //current time excess the CD
        $new_post_time='2'.$check_time;
        $query_emergency_time = "UPDATE map,user SET emergency_time='$new_post_time' 
            WHERE user.validation='$login_certification' AND user.userid = map.userid";
        $result_emergency_time = mysqli_query($mysqli, $query_emergency_time) or die(mysqli_error($mysqli));
        if($result_emergency_time){
            $respond['sucess'] = 'true';
            echo json_encode($respond);
        }                
    }else{
        $respond['error'] = 'Emergency_request_not_up';
    }
    return $respond;
}
*/
function dealing_rank_request($mysqli,$rank_type){
    $respond = array();
    $respond['type'] = 'rank';
    $respond['rank_type'] = $rank_type;
    $respond['sucess'] = 'false';

    if($rank_type == 'person'){
        for($x = 1; $x <= 10; $x++) {
            $query = "SELECT name , nickname, number ,department , title_use , map.used 
             FROM user, map WHERE user.rank='$x' AND user.userid=map.userid";
            $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
            $num_row = mysqli_num_rows($result);
            if($num_row > 0){
                $row = mysqli_fetch_array($result);
                $respond['rank'.$x.'number'] = $row['number'];
                $respond['rank'.$x.'name'] = $row['name'];
                $respond['rank'.$x.'nickname'] = $row['nickname'];
                $respond['rank'.$x.'department'] = $row['department'];
                $respond['rank'.$x.'title_use'] = $row['title_use'];
                //$respond['rank'.$x.'used'] = $row['used'];
                //used should be removed cause it didn't mean point now
                $respond['rank'.$x.'point'] = get_personal_point($mysqli,NULL,$row['number']);
            }else{
                $respond['rank'.$x.'name'] = '-1';
            }  
        }
        $respond['sucess'] = 'true';
    }else if($rank_type == 'team'){
        for($x = 1; $x <= 10; $x++) {
            $query = "SELECT name , point FROM team WHERE rank='$x'";
            $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
            $num_row = mysqli_num_rows($result);
            if($num_row > 0){
                $row = mysqli_fetch_array($result);
                $respond['rank'.$x.'name'] = $row['name'];
                $respond['rank'.$x.'point'] = $row['point'];
            }else{
                $respond['rank'.$x.'name'] = '-1';
            }         
        }
        $respond['sucess'] = 'true';
    }
    
    echo json_encode($respond);
}

function dealing_news_request($mysqli){
    $respond = array();
    $respond['type'] = 'news';
    $respond['sucess'] = 'true';

    $query = "SELECT title FROM news";
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $respond['count'] = $num_row;
    if($num_row > 0){
        for($x = 0; $x < $num_row; $x++) {
            $row = mysqli_fetch_array($result);
            $respond['news'.$x.'title'] = $row['title'];
        }
    }
    
    echo json_encode($respond);
}

function update_team_point($mysqli,$login_certification,$point){
    $query_check_team = "SELECT team.teamid,point FROM user, team WHERE user.validation='$login_certification' AND user.teamid=team.teamid";
    $result_check_team = mysqli_query($mysqli, $query_check_team) or die(mysqli_error($mysqli));
    $num_row_check_team = mysqli_num_rows($result_check_team);
    $row_check_team = mysqli_fetch_array($result_check_team);
    if($num_row_check_team==0){
        return false;
    }
    $team_id = $row_check_team['teamid'];
    $team_used = (int)$row_check_team['point']+$point;
    $query_put_team = "UPDATE team SET point='$team_used' WHERE teamid='$team_id'";
    $result_put_team = mysqli_query($mysqli, $query_put_team) or die(mysqli_error($mysqli));
    if($result_put_team){
        return true;
    }
    return false;
}

function update_point($mysqli,$have_team,$login_certification,$point){
    $person_check = update_person_point($mysqli,$login_certification,$point);
    $team_check = update_team_point($mysqli,$login_certification,$point);
    return ($person_check);
}

function update_person_point($mysqli,$login_certification,$point){
    $query_check_person = "SELECT map.point,user.userid FROM user, map WHERE user.validation='$login_certification' AND user.userid=map.userid";
    $result_check_person = mysqli_query($mysqli, $query_check_person) or die(mysqli_error($mysqli));
    $num_row_check_person = mysqli_num_rows($result_check_person);
    $row_check_person = mysqli_fetch_array($result_check_person);
    if($num_row_check_person == 0){
        return false;
    }
    $user_id = $row_check_person['userid'];
    $person_point = $row_check_person['point']+$point;
    $query_put_person = "UPDATE map SET point='$person_point' WHERE userid='$user_id'";
    $result_put_person = mysqli_query($mysqli, $query_put_person) or die(mysqli_error($mysqli));
    if($result_put_person){
        return true;
    }
    return false;
}

function get_personal_point($mysqli,$login_certification,$number){
    if($login_certification==NULL){
        $selection = " WHERE user.number='$number' AND user.userid = map.userid";
    }else if($number==NULL){
        $selection = " WHERE user.validation='$login_certification' AND user.userid = map.userid";
    }
    
    $query_check = "SELECT point FROM user, map".$selection;
    $result_check = mysqli_query($mysqli, $query_check) or die(mysqli_error($mysqli));
    $num_row_check = mysqli_num_rows($result_check);
    $row_check = mysqli_fetch_array($result_check);
    if($num_row_check!=1){
        error_and_logout("Unable get user puzzle data!");
    }
    return $row_check['point'];
}

?>