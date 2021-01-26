<?php
session_start();
#$email = $_POST['email'];
#echo "e"+ $email;
#$password = $_POST['password'];

$postdata = file_get_contents("php://input",'r'); 
$data = json_decode($postdata,true);
#echo $data['email'];
$type = $data['type'];
$email = $data['email'];
$password = $data['password'];

if ($type == NIL){
    echo 'Unknown Request!';
    die('Dealing Unknown Request!');
}

//Open a new connection to the MySQL server
$mysqli = new mysqli('localhost', 'root', '', 'perfectcup');
//Output any connection error
if ($mysqli->connect_error) {
    die('Error : (' . $mysqli->connect_errno . ') ' . $mysqli->connect_error);
}

switch($type){
    case 'login':
        dealing_login_request($mysqli,$type,$email,$password);
        break;
}

function dealing_login_request($mysqli,$type,$email,$password){
    $query = "SELECT * FROM members WHERE email='$email'";
    $result = mysqli_query($mysqli, $query) or die(mysqli_error($mysqli));
    $num_row = mysqli_num_rows($result);
    $row = mysqli_fetch_array($result);

    if ($num_row >= 1) {
        if (password_verify($password, $row['password'])) {
            #$_SESSION['login'] = $row['id'];
            #$_SESSION['fname'] = $row['fname'];
            #$_SESSION['lname'] = $row['lname'];
            echo 'true';
        }
        else {
            echo 'false';
        }
    } else {
    echo 'false';
    }
}



?>