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
    case 'login':        
        $email = $data['number'];
        $password = $data['password'];
        dealing_login_request($mysqli,$email,$password);
        break;
    case 'info':
        $login_certification = $data['validation'];
        dealing_info_request($mysqli,$login_certification);
        break;
    case 'activity':
        $login_certification = $data['validation'];
        dealing_activity_request($mysqli,$login_certification);
        break;
    case 'map':
        $login_certification = $data['validation'];
        dealing_map_request($mysqli,$login_certification);
        break;
    case 'team':
        $login_certification = $data['validation'];
        dealing_team_request($mysqli,$login_certification);
        break;
}

function dealing_login_request($mysqli,$email,$password){    
    $query = "SELECT userid, password FROM user WHERE number='$email'";
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $row = mysqli_fetch_array($result);

    if ($num_row >= 1) {
        if (password_verify($password, $row['password'])) {
            #$_SESSION['login'] = $row['id'];
            #$_SESSION['fname'] = $row['fname'];
            #$_SESSION['lname'] = $row['lname'];
            echo 'true';

            $userid = $row['userid'];
            $check_num = time().rand(111111111,999999999);
            $query = "UPDATE user SET validation='$check_num' WHERE userid='$userid'";
            $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
            if($result){
                echo $check_num;
            }else{
                echo '0000000000000000000';
            }
        }
        else {
            echo 'false';
        }
    } else {
    echo 'false';
    }
}

function dealing_info_request($mysqli,$login_certification){
    $query = "SELECT * FROM user WHERE validation='$login_certification'";
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $row = mysqli_fetch_array($result);

    if ($num_row >= 1){
        echo $row['number'],' ',$row['name'],' ',$row['nickname'],' ',$row['department'],' ',$row['teamid'];
    }
}

function dealing_activity_request($mysqli,$login_certification){
    $query = "SELECT actibity.type, activity.number, activity.point, activity.time
     FROM user, activity WHERE user.validation='$login_certification', user.userid = activity.userid";
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $row = mysqli_fetch_array($result);

    if ($num_row >= 1){
        echo $row['type'],$row['number'],$row['point'],$row['time'];
    }
}

function dealing_map_request($mysqli,$login_certification){
    $query = "SELECT map.unused1, map.unused2, map.unused3, map.unused4, map.unused5, map.unused6, used, pos, val
     FROM user, map WHERE user.validation='$login_certification', user.userid = map.userid";
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $row = mysqli_fetch_array($result);

    if ($num_row >= 1){
        echo $row['unused1'],$row['unused2'],$row['unused3'],$row['unused4'],$row['unused5'],$row['unused6'],$row['used'],$row['pos'],$row['val'];
    }
}

function dealing_team_request($mysqli,$login_certification){
    $query = "SELECT team.mem1, team.mem2, team.mem3, team.mem4, team.mem5, team.mem6
    team.mem7, team.mem8, team.mem9, team.mem10, team.point, team.rank
     FROM user, team WHERE user.validation='$login_certification', user.teamid = team.teamid";
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $row = mysqli_fetch_array($result);

    if ($num_row >= 1){
        echo $row['mem1'],$row['mem2'],$row['mem3'],$row['mem4'],$row['mem5'],$row['mem6']
        ,$row['mem7'],$row['mem8'],$row['mem9'],$row['mem10'],$row['point'],$row['rank'];
    }
}

?>