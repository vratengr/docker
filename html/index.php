<?php
/**
 * Sample PHP file with DB transactions
 *
 * @author Vanessa Richie Alia-Trapero <vrat.engr@gmail.com>
 */

echo "<pre>Hello VRATs!\n";

$host       = "db"; // service name of the database container
$user       = "user"; // MARIADB_USER
$password   = "user"; // MARIADB_PASSWORD
$db         = "mydb"; // MARIADB_DATABASE
$table      = "notes"; // table name from our data.sql dump
$conn       = new mysqli($host, $user, $password, $db);

if ($conn->connect_error) {
    die ("Database connection error: " . $conn->connect_error);
} else {
    $result = $conn->query("INSERT INTO $table (note) VALUES ('random note - " . rand() . "')");
    if ($result) {
        echo "Successfully inserted new notes.\n";
        $result = $conn->query("SELECT * FROM $table");
        $rows = $result->fetch_all(MYSQLI_ASSOC);
        foreach ($rows as $row) {
            echo "Note # " . $row['id'] . ": " . $row['note'] . "\n";
        }
    } else {
        die ("Database error occurred. :(");
    }
}