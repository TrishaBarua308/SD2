
<?php
$host = "localhost";
$username = "root";
$password = "";
$dbname = "flutter_app";

$conn = new mysqli($host, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]));
}

$user_id = $_POST['user_id'];
$info = $_POST['info'];

$sql = "INSERT INTO user_info (user_id, info) VALUES ('$user_id', '$info')";
if ($conn->query($sql) === TRUE) {
    echo json_encode(["success" => true, "message" => "Info added successfully!"]);
} else {
    echo json_encode(["success" => false, "message" => "Error: " . $conn->error]);
}

$conn->close();
?>
