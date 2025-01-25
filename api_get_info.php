<?php
$host = "localhost";
$username = "root";
$password = "";
$dbname = "flutter_app";

$conn = new mysqli($host, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]));
}

$user_id = $_GET['user_id'];

$sql = "SELECT info FROM user_info WHERE user_id = '$user_id'";
$result = $conn->query($sql);

$data = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
    echo json_encode(["success" => true, "data" => $data]);
} else {
    echo json_encode(["success" => false, "message" => "No data found."]);
}

$conn->close();
?>
