<?php
$host = "localhost";
$username = "root";
$password = "";
$dbname = "flutter_app";

$conn = new mysqli($host, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]));
}

$email = $_POST['email'];
$user_password = $_POST['password'];

$sql = "SELECT id FROM users WHERE email = '$email' AND password = '$user_password'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    echo json_encode(["success" => true, "message" => "Login successful!", "user_id" => $user['id']]);
} else {
    echo json_encode(["success" => false, "message" => "Invalid email or password."]);
}

$conn->close();
?>
