create database Drivo;
use Drivo;

-- 1. Riders Table
CREATE TABLE Riders (
    rider_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    phone BIGINT UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Drivers Table
CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    phone BIGINT UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    license_number VARCHAR(50) UNIQUE NOT NULL,
    rating DECIMAL(3,2) DEFAULT 5.00 CHECK (rating BETWEEN 0 AND 5),
    status ENUM('Active', 'Inactive', 'Suspended') DEFAULT 'Active'
);

-- 3. Cars Table (Removed color column)
CREATE TABLE Cars (
    car_id INT PRIMARY KEY AUTO_INCREMENT,
    driver_id INT UNIQUE,
    car_model VARCHAR(50) NOT NULL,
    car_number VARCHAR(15) UNIQUE NOT NULL,
    car_type ENUM('Sedan', 'SUV', 'Mini', 'Luxury') NOT NULL,
    capacity INT CHECK (capacity BETWEEN 1 AND 7),
    status ENUM('Available', 'Booked', 'Under Maintenance') DEFAULT 'Available',
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id) ON DELETE SET NULL
);

-- 4. Rides Table
CREATE TABLE Rides (
    ride_id INT PRIMARY KEY AUTO_INCREMENT,
    rider_id INT,
    driver_id INT,
    car_id INT,
    ride_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    source VARCHAR(100),
    destination VARCHAR(100),
    distance_km DECIMAL(5,2),
    fare_amount DECIMAL(8,2),
    payment_mode ENUM('Cash', 'Card', 'UPI', 'Wallet'),
    status ENUM('Completed', 'Cancelled', 'Ongoing') DEFAULT 'Completed',
    FOREIGN KEY (rider_id) REFERENCES Riders(rider_id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id) ON DELETE CASCADE,
    FOREIGN KEY (car_id) REFERENCES Cars(car_id) ON DELETE SET NULL
);

-- 5. Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    ride_id INT,
    amount DECIMAL(8,2),
    payment_mode ENUM('Cash', 'Card', 'UPI', 'Wallet'),
    payment_status ENUM('Success', 'Failed', 'Pending') DEFAULT 'Success',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ride_id) REFERENCES Rides(ride_id) ON DELETE CASCADE
);

-- 6. Ratings Table
CREATE TABLE Ratings (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    ride_id INT,
    rider_id INT,
    driver_id INT,
    rating DECIMAL(3,2) CHECK (rating BETWEEN 1 AND 5),
    feedback TEXT,
    rating_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ride_id) REFERENCES Rides(ride_id) ON DELETE CASCADE,
    FOREIGN KEY (rider_id) REFERENCES Riders(rider_id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id) ON DELETE CASCADE
);

-- 7. Ride_Cancellations Table
CREATE TABLE Ride_Cancellations (
    cancel_id INT PRIMARY KEY AUTO_INCREMENT,
    ride_id INT,
    rider_id INT,
    driver_id INT,
    cancel_reason TEXT,
    cancel_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ride_id) REFERENCES Rides(ride_id) ON DELETE CASCADE,
    FOREIGN KEY (rider_id) REFERENCES Riders(rider_id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id) ON DELETE CASCADE
);

-- 8. Surge_Pricing Table
CREATE TABLE Surge_Pricing (
    surge_id INT PRIMARY KEY AUTO_INCREMENT,
    ride_id INT,
    surge_multiplier DECIMAL(3,2) CHECK (surge_multiplier BETWEEN 1.0 AND 3.0),
    surge_reason ENUM('Peak Hours', 'Weather', 'High Demand'),
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ride_id) REFERENCES Rides(ride_id) ON DELETE CASCADE
);

-- 9. Complaints Table
CREATE TABLE Complaints (
    complaint_id INT PRIMARY KEY AUTO_INCREMENT,
    rider_id INT,
    ride_id INT,
    driver_id INT,
    issue TEXT,
    status ENUM('Resolved', 'Pending', 'Under Review') DEFAULT 'Pending',
    complaint_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rider_id) REFERENCES Riders(rider_id) ON DELETE CASCADE,
    FOREIGN KEY (ride_id) REFERENCES Rides(ride_id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id) ON DELETE CASCADE
);

-- 10. Support_Tickets Table
CREATE TABLE Support_Tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    rider_id INT,
    ride_id INT,
    issue TEXT,
    ticket_status ENUM('Open', 'In Progress', 'Closed') DEFAULT 'Open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rider_id) REFERENCES Riders(rider_id) ON DELETE CASCADE,
    FOREIGN KEY (ride_id) REFERENCES Rides(ride_id) ON DELETE CASCADE
);

show tables;

-- Insert data into Riders table
INSERT INTO Riders (name, phone, email) VALUES
('Amit Sharma', 9876543210, 'amit.sharma@example.com'),
('Neha Verma', 8765432109, 'neha.verma@example.com'),
('Rahul Gupta', 7654321098, 'rahul.gupta@example.com'),
('Priya Mehta', 6543210987, 'priya.mehta@example.com'),
('Sanjay Singh', 9432108765, 'sanjay.singh@example.com'),
('Kiran Rao', 8123456789, 'kiran.rao@example.com'),
('Ravi Kumar', 7321654987, 'ravi.kumar@example.com'),
('Meena Joshi', 6251348762, 'meena.joshi@example.com'),
('Vikas Tiwari', 5457893214, 'vikas.tiwari@example.com'),
('Anjali Desai', 4657891234, 'anjali.desai@example.com');

-- Insert data into Drivers table
INSERT INTO Drivers (name, phone, email, license_number, rating, status) VALUES
('Rajesh Khanna', 9823456789, 'rajesh.khanna@example.com', 'DL12345', 4.8, 'Active'),
('Sumit Malhotra', 9123456780, 'sumit.malhotra@example.com', 'DL67890', 4.5, 'Active'),
('Deepak Sharma', 8234567890, 'deepak.sharma@example.com', 'DL45678', 4.7, 'Active'),
('Alok Verma', 7896543210, 'alok.verma@example.com', 'DL78901', 4.6, 'Active'),
('Sunil Patil', 6789054321, 'sunil.patil@example.com', 'DL32165', 4.9, 'Active'),
('Pooja Jain', 5687341256, 'pooja.jain@example.com', 'DL85274', 4.2, 'Inactive'),
('Kunal Roy', 4782315645, 'kunal.roy@example.com', 'DL65432', 4.0, 'Active'),
('Sneha Das', 3875462135, 'sneha.das@example.com', 'DL14785', 3.9, 'Active'),
('Nitin Saxena', 2987456123, 'nitin.saxena@example.com', 'DL36987', 4.4, 'Suspended'),
('Anand Pillai', 1875364928, 'anand.pillai@example.com', 'DL98765', 4.1, 'Active');

-- Insert data into Cars table
INSERT INTO Cars (driver_id, car_model, car_number, car_type, capacity, status) VALUES
(1, 'Honda City', 'MH12AB1234', 'Sedan', 4, 'Available'),
(2, 'Toyota Innova', 'MH14CD5678', 'SUV', 6, 'Available'),
(3, 'Hyundai i10', 'MH01EF9101', 'Mini', 4, 'Booked'),
(4, 'Maruti Swift', 'MH02GH2345', 'Mini', 4, 'Available'),
(5, 'Hyundai Verna', 'MH03IJ6789', 'Sedan', 4, 'Available'),
(6, 'Mercedes Benz', 'MH04KL1122', 'Luxury', 4, 'Booked'),
(7, 'Mahindra XUV500', 'MH05MN3344', 'SUV', 7, 'Available'),
(8, 'Tata Nexon', 'MH06OP5566', 'SUV', 5, 'Available'),
(9, 'Ford EcoSport', 'MH07QR7788', 'SUV', 5, 'Under Maintenance'),
(10, 'BMW X5', 'MH08ST9900', 'Luxury', 4, 'Booked');

-- Insert data into Rides table
INSERT INTO Rides (rider_id, driver_id, car_id, source, destination, distance_km, fare_amount, payment_mode, status) VALUES
(1, 2, 2, 'Mumbai', 'Pune', 150.00, 2500.00, 'Card', 'Completed'),
(2, 3, 3, 'Bandra', 'Andheri', 12.50, 250.00, 'UPI', 'Completed'),
(3, 4, 4, 'Thane', 'Vashi', 20.00, 400.00, 'Wallet', 'Completed'),
(4, 5, 5, 'Navi Mumbai', 'Dadar', 30.00, 600.00, 'Cash', 'Completed'),
(5, 6, 6, 'Mumbai Central', 'Colaba', 8.00, 180.00, 'Card', 'Cancelled'),
(6, 7, 7, 'Vile Parle', 'Bandra', 10.00, 220.00, 'UPI', 'Completed'),
(7, 8, 8, 'Jogeshwari', 'Goregaon', 6.00, 150.00, 'Wallet', 'Completed'),
(8, 9, 9, 'Kandivali', 'Borivali', 5.50, 120.00, 'Cash', 'Ongoing'),
(9, 10, 10, 'Mulund', 'Powai', 15.00, 350.00, 'Card', 'Completed'),
(10, 1, 1, 'Worli', 'Lower Parel', 4.00, 100.00, 'UPI', 'Completed');

-- Insert data into Payments table
INSERT INTO Payments (ride_id, amount, payment_mode, payment_status) VALUES
(1, 2500.00, 'Card', 'Success'),
(2, 250.00, 'UPI', 'Success'),
(3, 400.00, 'Wallet', 'Success'),
(4, 600.00, 'Cash', 'Success'),
(6, 220.00, 'UPI', 'Success'),
(7, 150.00, 'Wallet', 'Success'),
(8, 120.00, 'Cash', 'Pending'),
(9, 350.00, 'Card', 'Success'),
(10, 100.00, 'UPI', 'Success');

-- Insert data into Ratings table
INSERT INTO Ratings (ride_id, rider_id, driver_id, rating, feedback) VALUES
(1, 1, 2, 5.0, 'Excellent service!'),
(2, 2, 3, 4.5, 'Good experience.'),
(3, 3, 4, 4.8, 'Smooth ride.'),
(4, 4, 5, 4.7, 'Driver was friendly.'),
(6, 6, 7, 3.9, 'Could be better.'),
(7, 7, 8, 4.2, 'Nice car and polite driver.'),
(9, 9, 10, 4.6, 'Comfortable journey.'),
(10, 10, 1, 5.0, 'Highly recommended.');

-- Insert data into Ride_Cancellations table
INSERT INTO Ride_Cancellations (ride_id, rider_id, driver_id, cancel_reason) VALUES
(5, 5, 6, 'Driver unavailable'),
(8, 8, 9, 'Changed plans');

-- Insert data into Surge_Pricing table
INSERT INTO Surge_Pricing (ride_id, surge_multiplier, surge_reason) VALUES
(1, 1.5, 'Peak Hours'),
(4, 2.0, 'Weather');

-- Insert data into Complaints table
INSERT INTO Complaints (rider_id, ride_id, driver_id, issue, status) VALUES
(5, 5, 6, 'Driver did not show up', 'Resolved'),
(8, 8, 9, 'Car was not clean', 'Pending');

-- Insert data into Support_Tickets table
INSERT INTO Support_Tickets (rider_id, ride_id, issue, ticket_status) VALUES
(5, 5, 'Refund not processed', 'Open'),
(8, 8, 'Need invoice for ride', 'Closed');


#Retrieve all riders' names and their phone numbers.
SELECT name, phone FROM Riders;

#Get the total number of rides completed.
SELECT COUNT(*) AS total_completed_rides 
FROM Rides 
WHERE status = 'Completed';

#Find the total fare amount collected for all rides.
SELECT SUM(fare_amount) AS total_fare 
FROM Rides;

#Retrieve the top 3 highest-rated drivers along with their names and ratings.
SELECT name, rating 
FROM Drivers 
ORDER BY rating DESC 
LIMIT 3;

#Find the average fare amount for rides where payment mode was 'UPI'.
SELECT AVG(fare_amount) AS avg_fare_UPI 
FROM Rides 
WHERE payment_mode = 'UPI';

#Get the most frequently booked car type.
SELECT car_type, COUNT(*) AS total_rides 
FROM Cars 
JOIN Rides ON Cars.car_id = Rides.car_id 
GROUP BY car_type 
ORDER BY total_rides DESC 
LIMIT 1;

#Find all drivers who have received complaints, along with the complaint issue and status.
SELECT Drivers.name, Complaints.issue, Complaints.status 
FROM Complaints 
JOIN Drivers ON Complaints.driver_id = Drivers.driver_id;