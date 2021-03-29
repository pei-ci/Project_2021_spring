<?php
session_start();
#$email = $_POST['email'];
#echo "e"+ $email;
#$password = $_POST['password'];

$postdata = file_get_contents("php://input",'r'); 
$data = json_decode($postdata,true);
#echo $data['email'];
$type = $data['type'];

if ($type == NULL){   
    die('Dealing Unknown Request!');
}

//Open a new connection to the MySQL server
$mysqli = new mysqli('localhost', 'root', '', 'school_games');
//Output any connection error
if ($mysqli->connect_error) {
    die('Error : (' . $mysqli->connect_errno . ') ' . $mysqli->connect_error);
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
        dealing_register_request($mysqli,$email,$password,$name,$department);
        break;
    case 'info':    //work
        $login_certification = $data['validation'];
        dealing_info_request($mysqli,$login_certification);
        break;
    case 'activity':
        $login_certification = $data['validation'];
        dealing_activity_request($mysqli,$login_certification);
        break;
    case 'map':     //work
        $login_certification = $data['validation'];
        dealing_map_request($mysqli,$login_certification);
        break;
    case 'map_oper':    //work,map operation
        $login_certification = $data['validation'];
        $oper = $data['oper'];
        $block_type = $data['block_type'];
        $pos = $data['pos'];
        dealing_map_oper_request($mysqli,$login_certification,$oper,$block_type,$pos);
        break;
    case 'team':    //work
        $login_certification = $data['validation'];
        dealing_team_request($mysqli,$login_certification);
        break;
    case 'create_team':    //work
        $team_name = $data["team_name"];
        $login_certification = $data['validation'];
        dealing_create_team_request($mysqli,$login_certification,$team_name);
        break;
}

function dealing_login_request($mysqli,$email,$password){    
    $query = "SELECT userid, password FROM user WHERE number='$email'";
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $row = mysqli_fetch_array($result);

    $respond = array();
    $respond["type"] = "login";
    if ($num_row >= 1) {
        if (password_verify($password, $row['password'])) {
            #$_SESSION['login'] = $row['id'];
            #$_SESSION['fname'] = $row['fname'];
            #$_SESSION['lname'] = $row['lname'];            
            $respond["sucess"] = 'true';
            #echo 'true';

            $userid = $row['userid'];
            $check_num = time().rand(111111111,999999999);
            $query = "UPDATE user SET validation='$check_num' WHERE userid='$userid'";
            $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
            if($result){
                $respond["validation"] = $check_num;
                #echo $check_num;
            }else{
                $respond["validation"] = '0000000000000000000';
                #echo '0000000000000000000';
            }
        }
        else {
            $respond["sucess"] = 'false';
            #echo 'false';
        }
    } else {
        $respond["sucess"] = 'false';
        #echo 'false';
    }
    echo json_encode($respond);
}

function dealing_register_request($mysqli,$email,$password,$name,$department){
    //register to user table
    $password = password_hash($password,PASSWORD_DEFAULT);
    $query_register_user = "INSERT INTO user (name, department, number, password) 
            VALUE ('$name','$department','$email','$password')";
    $result_register_user = mysqli_query($mysqli, $query_register_user) or die(mysqli_error($mysqli));
    //get userid from user table
    $query_id = "SELECT userid FROM user WHERE number='$email' AND password='$password'";
    $result_id = mysqli_query($mysqli, $query_id) or die(mysqli_error($mysqli));
    $row = mysqli_fetch_array($result_id);
    $id = $row['userid'];
    //register to map table
    $query_register_map = "INSERT INTO map (userid) VALUE ('$id')";
    $result_register_map = mysqli_query($mysqli, $query_register_map) or die(mysqli_error($mysqli));
    
    $respond = array();
    $respond['type'] = 'register';
    $respond['sucess'] = 'false';
    if($result_register_user && $result_register_map){
        $respond['sucess'] = 'true';
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
    }else{
        $respond["sucess"] = "false";
    }
    echo json_encode($respond);
}

function dealing_activity_request($mysqli,$login_certification){
    $query = "SELECT actibity.type, activity.number, activity.point, activity.time
     FROM user, activity WHERE user.validation='$login_certification', user.userid = activity.userid";
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $row = mysqli_fetch_array($result);

    $respond = array();
    $respond['type'] = 'activity';
    if ($num_row >= 1){
        $respond['sucess'] = true;
        $respond['type'] = $row['type'];
        $respond['number'] = $row['number'];
        $respond['point'] = $row['point'];
        $respond['time'] = $row['time'];
    }else{
        $respond['sucess'] = false;
    }
    echo json_encode($respond);
}

function dealing_map_request($mysqli,$login_certification){
    $query = "SELECT map.unused1, map.unused2, map.unused3, map.unused4, map.unused5, map.unused6, used, pos, val
     FROM user, map WHERE user.validation='$login_certification' AND user.userid = map.userid";
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $row = mysqli_fetch_array($result);

    $respond = array();
    $respond['type'] = 'map';
    if ($num_row >= 1){
        $respond['sucess'] = 'true';
    }else{
        $respond['sucess'] = 'false';
    }
    $respond['unused1'] = $row['unused1'];
    $respond['unused2'] = $row['unused2'];
    $respond['unused3'] = $row['unused3'];
    $respond['unused4'] = $row['unused4'];
    $respond['unused5'] = $row['unused5'];
    $respond['unused6'] = $row['unused6'];
    $respond['used'] = $row['used'];
    $respond['pos'] = $row['pos'];
    $respond['val'] = $row['val'];

    echo json_encode($respond);
}

function dealing_map_oper_request($mysqli,$login_certification,$oper,$block_type,$pos){
    $respond = array();
    $respond['type'] = 'map_oper';
    $respond['sucess'] = 'false';

    //check block amount
    $target_block = "map.unused".$block_type;
    $query_check = "SELECT ".$target_block." ,used, pos, val, map.userid FROM user, map WHERE user.validation='$login_certification' AND user.userid = map.userid";
    $result_check = mysqli_query($mysqli, $query_check) or die(mysqli_error($mysqli));
    $num_row_check = mysqli_num_rows($result_check);
    $row_check = mysqli_fetch_array($result_check);
    if($num_row_check==0 || $row_check['unused'.$block_type]<1){
        echo json_encode($respond);
        return;
    }
    $unused = (int)$row_check['unused'.$block_type]-1;
    $userid = $row_check['userid'];
    $used = (int)$row_check['used']+1;
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
            $respond['sucess'] = true;
        }
    echo json_encode($respond);
}

function dealing_team_request($mysqli,$login_certification){
    $query = "SELECT team.name, team.mem1, team.mem2, team.mem3, team.mem4, team.mem5, team.mem6, 
    team.mem7, team.mem8, team.mem9, team.mem10, team.point, team.rank
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
    $respond['point'] = $row['point'];
    $respond['rank'] = $row['rank'];

    echo json_encode($respond);
}

function dealing_create_team_request($mysqli,$login_certification,$team_name){
    $query = "SELECT teamid FROM user WHERE validation='$login_certification'";
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $row = mysqli_fetch_array($result);

    $respond = array();
    $respond["type"] = "create_team";
    if($num_row >= 1){
        if($row["teamid"] == -1){ //create team
            do{
            $team_num = rand(111111,999999);
            $query_id_verify = "SELECT * FROM team WHERE teamid='$team_num'";
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
            //set team id to user table
            $query_1 = "UPDATE user SET teamid='$team_num' WHERE validation='$login_certification'";
            $result_1 = mysqli_query($mysqli, $query_1) or die(mysqli_error($mysqli));
            //set team id to team table
            $query_2 = "INSERT INTO team (teamid, name, mem1, point, rank) 
            VALUE ('$team_num','$team_name','$id','$map_count','$count')";
            $result_2 = mysqli_query($mysqli, $query_2) or die(mysqli_error($mysqli));
            
            if($result_1 && $result_2){
                $respond["sucess"] = 'true';
                $respond["teamid"] = $team_num;
            }else{
                $respond["sucess"] = 'false';
            }            

        }else{
            $respond["sucess"] = 'false';
        }
    }
    echo json_encode($respond);
}

?>