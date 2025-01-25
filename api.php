
<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$conn = new mysqli("localhost", "username", "password", "flutter_app");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);

    if (isset($data['email']) && isset($data['password'])) {
        $email = $conn->real_escape_string($data['email']);
        $password = $conn->real_escape_string($data['password']);

        $sql = "SELECT * FROM users WHERE email='$email' AND password='$password'";
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            echo json_encode(["success" => true, "message" => "Login successful"]);
        } else {
            echo json_encode(["success" => false, "message" => "Invalid credentials"]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Missing email or password"]);
    }
}

$conn->close();
?>
