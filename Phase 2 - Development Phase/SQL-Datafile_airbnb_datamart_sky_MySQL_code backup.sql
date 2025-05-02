--------------------------------------------------
-- Airbnb Datamart Database Setup
-- Disabling foreign key checks for smooth table creation
--------------------------------------------------
USE airbnb_datamart_sky;
SET FOREIGN_KEY_CHECKS = 0;

--------------------------------------------------
-- Dropping existing tables (if they exist) to ensure clean setup
--------------------------------------------------
-- Ordered to avoid foreign key constraint issues during drop
DROP TABLE IF EXISTS GuestSocialNetwork, SocialNetwork, Notification, Review, CustomerService, Reservation, 
    Transaction, Booking, Room, VacationRentalPolicy, CancellationPolicy, VacationRentalAmenity, Amenity, 
    VacationRental, Location, City, LoginHistory, TravelAdmin, Host, Guest, Event, Promotion;

-- Re-enable foreign key checks after dropping tables
SET FOREIGN_KEY_CHECKS = 1;

--------------------------------------------------
-- Guest-related tables
--------------------------------------------------
-- Guest table stores personal details of users who can book properties
CREATE TABLE Guest (
    GuestID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(20),
    ProfilePicture VARCHAR(255),
    Street VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255),
    GDPRAcknowledgement BOOLEAN,
    LanguageSettings VARCHAR(255)
);

-- Host table stores details about property owners. Guests can also be hosts.
CREATE TABLE Host (
    HostID INT AUTO_INCREMENT PRIMARY KEY,
    GuestID INT NOT NULL,
    Rating FLOAT,
    Verified BOOLEAN,
    HostSince DATE,
    Stars INT,
    ExternalReviews TEXT,
    ReferredByHostID INT NULL,
    FOREIGN KEY (GuestID) REFERENCES Guest(GuestID) ON DELETE CASCADE, -- Cascade deletes to remove related hosts
    FOREIGN KEY (ReferredByHostID) REFERENCES Host(HostID) ON DELETE SET NULL -- Prevent circular references. Self-referencing (recursive) relationship
);

-- TravelAdmin table stores system admins who can manage bookings and policies
CREATE TABLE TravelAdmin (
    AdminID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20),
    GuestID INT NOT NULL,
    FOREIGN KEY (GuestID) REFERENCES Guest(GuestID)
);

--------------------------------------------------
-- Social network and guest login activity
--------------------------------------------------
-- SocialNetwork table stores social media networks that guests can link to
CREATE TABLE SocialNetwork (
    NetworkID INT AUTO_INCREMENT PRIMARY KEY,
    NetworkName VARCHAR(100),
    URL VARCHAR(255)
);

-- GuestSocialNetwork table links guests to their social media profiles
CREATE TABLE GuestSocialNetwork (
    GuestSocialNetworkID INT AUTO_INCREMENT PRIMARY KEY,
    GuestID INT NOT NULL,
    NetworkID INT NOT NULL,
    ProfileURL VARCHAR(255),
    FOREIGN KEY (GuestID) REFERENCES Guest(GuestID),
    FOREIGN KEY (NetworkID) REFERENCES SocialNetwork(NetworkID)
);

-- LoginHistory logs guest login details for security purposes
CREATE TABLE LoginHistory (
    LoginID INT AUTO_INCREMENT PRIMARY KEY,
    GuestID INT NOT NULL,
    LoginTimestamp DATETIME,
    IPAddress VARCHAR(45),
    FOREIGN KEY (GuestID) REFERENCES Guest(GuestID)
);

-- Notification table for system alerts and messages to guests
CREATE TABLE Notification (
    NotificationID INT AUTO_INCREMENT PRIMARY KEY,
    GuestID INT NOT NULL,
    Content TEXT,
    Timestamp DATETIME,
    FOREIGN KEY (GuestID) REFERENCES Guest(GuestID)
);

--------------------------------------------------
-- Location and rental-related tables
--------------------------------------------------
-- City table stores city details, referenced by properties
CREATE TABLE City (
    CityID INT AUTO_INCREMENT PRIMARY KEY,
    CityName VARCHAR(100),
    Country VARCHAR(100)
);

-- Location table links specific addresses to cities
CREATE TABLE Location (
    LocationID INT AUTO_INCREMENT PRIMARY KEY,
    CityID INT,
    Country VARCHAR(100),
    PartOfCity VARCHAR(100),
    Address VARCHAR(255),
    PhoneNumber VARCHAR(20),
    Email VARCHAR(255),
    FOREIGN KEY (CityID) REFERENCES City(CityID)
);

-- VacationRental table stores rental property details
CREATE TABLE VacationRental (
    VacationRentalID INT AUTO_INCREMENT PRIMARY KEY,
    HostID INT NOT NULL,
    LocationID INT NOT NULL,
    PropertyType VARCHAR(100),
    Description TEXT,
    MaxGuests INT,
    RatePerPerson FLOAT,
    OwnBathroom BOOLEAN,
    DogFriendly BOOLEAN,
    FreeParking BOOLEAN,
    NumberOfBeds INT,
    CalendarAvailability TEXT,
    ProximityToBeach VARCHAR(255),
    ProximityToShops VARCHAR(255),
    ProximityToSightSeeing VARCHAR(255),
    FOREIGN KEY (HostID) REFERENCES Host(HostID) ON DELETE CASCADE, 
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID) ON DELETE CASCADE
);

--------------------------------------------------
-- Room, Amenity, and Policy-related tables
--------------------------------------------------
-- Room table links specific rooms to rentals with availability and pricing
CREATE TABLE Room (
    RoomID INT AUTO_INCREMENT PRIMARY KEY,
    VacationRentalID INT NOT NULL,
    RoomType VARCHAR(100),
    PricePerNight FLOAT,
    AvailableFrom DATE,
    AvailableTo DATE,
    FOREIGN KEY (VacationRentalID) REFERENCES VacationRental(VacationRentalID)
);

-- Amenity table stores general amenities like Wi-Fi, parking, etc.
CREATE TABLE Amenity (
    AmenityID INT AUTO_INCREMENT PRIMARY KEY,
    AmenityName VARCHAR(100),
    Description TEXT
);

-- Linking amenities to vacation rentals
CREATE TABLE VacationRentalAmenity (
    VacationRentalID INT NOT NULL,
    AmenityID INT NOT NULL,
    PRIMARY KEY (VacationRentalID, AmenityID),
    FOREIGN KEY (VacationRentalID) REFERENCES VacationRental(VacationRentalID),
    FOREIGN KEY (AmenityID) REFERENCES Amenity(AmenityID)
);

-- Cancellation policies for rentals
CREATE TABLE CancellationPolicy (
    PolicyID INT AUTO_INCREMENT PRIMARY KEY,
    PolicyName VARCHAR(100),
    Description TEXT
);

-- Linking cancellation policies to rentals
CREATE TABLE VacationRentalPolicy (
    VacationRentalID INT NOT NULL,
    PolicyID INT NOT NULL,
    PRIMARY KEY (VacationRentalID, PolicyID),
    FOREIGN KEY (VacationRentalID) REFERENCES VacationRental(VacationRentalID),
    FOREIGN KEY (PolicyID) REFERENCES CancellationPolicy(PolicyID)
);

--------------------------------------------------
-- Booking-related tables
--------------------------------------------------
-- Booking table stores details about guest bookings
CREATE TABLE Booking (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    GuestID INT NOT NULL,
    RoomID INT NOT NULL,
    BookingDate DATETIME NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    TotalPrice FLOAT NOT NULL,
    PaymentStatus ENUM('Paid', 'Pending', 'Cancelled') NOT NULL,
    LengthOfStay INT NOT NULL,
    CancellationDeadline DATE,
    CancellationRefund FLOAT,
    DateOfCancellation DATE,
    HostPayout FLOAT, 
    EventName VARCHAR(255),
    StartDate DATE,
    EndDate DATE,
    Description TEXT,
    FOREIGN KEY (GuestID) REFERENCES Guest(GuestID) ON DELETE CASCADE,
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID) ON DELETE CASCADE
);

--------------------------------------------------
-- Transaction, Reservation, and Review tables
--------------------------------------------------
-- Storing transactions for payments and refunds
CREATE TABLE Transaction (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    GuestID INT NOT NULL,
    BookingID INT NOT NULL,
    Amount FLOAT NOT NULL,
    TransactionDate DATETIME NOT NULL,
    PaymentMethod ENUM('CreditCard', 'BankTransfer', 'Cash', 'Voucher', 'PayPal', 'ApplePay', 'GPay', 'CreditCard_MasterCard', 'CreditCard_Visa', 
    'CreditCard_AMEX', 'CreditCard_FirstCard', 'CreditCard_DinersClub', 'Maestro', 'SOFORT_Payment', 'BNPL', 'Klarna') NOT NULL,
    TransactionType ENUM('Payment', 'Refund') NOT NULL,  
    RefundProcessedDate DATETIME NULL,  
    Description TEXT NOT NULL,  
    FOREIGN KEY (GuestID) REFERENCES Guest(GuestID),
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
);

-- Reservation table storing additional booking details and policies
CREATE TABLE Reservation (
    ReservationID INT AUTO_INCREMENT PRIMARY KEY,
    BookingID INT NOT NULL,
    AdminID INT NOT NULL,
    DateOfReservation DATE,
    PaymentStatus ENUM('Paid', 'Pending', 'Cancelled'),
    LengthOfStay INT,
    CancellationPolicy TEXT,
    RefundPolicy TEXT,
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID),
    FOREIGN KEY (AdminID) REFERENCES TravelAdmin(AdminID)
);

-- Review table for collecting feedback from guests or hosts
CREATE TABLE Review (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    BookingID INT NOT NULL,
    ReviewerID INT NOT NULL,  
    ReviewerType ENUM('Guest', 'Host') NOT NULL,  
    Rating INT,
    Comment TEXT,
    ReviewDate DATE,
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID) ON DELETE CASCADE,
    FOREIGN KEY (ReviewerID) REFERENCES Guest(GuestID) ON DELETE CASCADE
);

--------------------------------------------------
-- Customer service and event management
--------------------------------------------------
-- Customer service table for managing support tickets related to bookings
CREATE TABLE CustomerService (
    CustomerServiceID INT AUTO_INCREMENT PRIMARY KEY,
    BookingID INT NOT NULL,
    IssueDescription TEXT,
    Resolution TEXT,
    ContactMethod VARCHAR(255),
    ResolutionDate DATE,
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
);

-- Event table to link events to bookings, such as local activities
CREATE TABLE Event (
    EventID INT AUTO_INCREMENT PRIMARY KEY,
    BookingID INT NOT NULL,
    EventName VARCHAR(255),
    StartDate DATE,
    EndDate DATE,
    Description TEXT,
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
);

--------------------------------------------------
-- Promotion table for managing rental discounts
--------------------------------------------------
CREATE TABLE Promotion (
    PromotionID INT AUTO_INCREMENT PRIMARY KEY,
    VacationRentalID INT NOT NULL,
    DiscountPercentage FLOAT,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (VacationRentalID) REFERENCES VacationRental(VacationRentalID)
);

--------------------------------------------------
-- Insert test data into the Guest table
-- Guest data should cover various use cases such as international guests, language preferences, etc.
--------------------------------------------------
INSERT INTO Guest (Name, Email, Password, PhoneNumber, ProfilePicture, Street, City, State, Country, GDPRAcknowledgement, LanguageSettings)
VALUES 
    ('Hans Müller', 'hans.mueller@example.de', 'password111', '491523456789', 'hans_profile.jpg', '123 Main St', 'Berlin', '', 'Germany', TRUE, 'German'),
    ('Emma Karlsson', 'emma.karlsson@example.se', 'password112', '467021234567', 'emma_profile.jpg', '456 Elm St', 'Stockholm', '', 'Sweden', TRUE, 'Swedish'),
    ('Jean Dupont', 'jean.dupont@example.fr', 'password113', '33122334455', 'jean_profile.jpg', '789 Oak St', 'Paris', '', 'France', TRUE, 'French'),
    ('Giovanni Rossi', 'giovanni.rossi@example.it', 'password211', '390123456789', 'giovanni_profile.jpg', '101 Maple St', 'Rome', '', 'Italy', TRUE, 'Italian'),
    ('Seo-jun Lee', 'seo.jun.lee@example.kr', 'password212', '821012345678', 'seo_profile.jpg', '202 Pine St', 'Seoul', '', 'South Korea', TRUE, 'Korean'),
    ('Sakura Tanaka', 'sakura.tanaka@example.jp', 'password213', '819012345678', 'sakura_profile.jpg', '303 Birch St', 'Tokyo', '', 'Japan', TRUE, 'Japanese'),
    ('Anna Svensson', 'anna.svensson@example.se', 'password100', '46709876543', 'anna_profile.jpg', '404 Cedar St', 'Gothenburg', '', 'Sweden', TRUE, 'Swedish'),
    ('Friedrich Becker', 'friedrich.becker@example.de', 'password101', '4915123456789', 'friedrich_profile.jpg', '505 Pine St', 'Munich', '', 'Germany', TRUE, 'German'),
    ('Pierre Martin', 'pierre.martin@example.fr', 'password110', '33122334455', 'pierre_profile.jpg', '606 Maple St', 'Lyon', '', 'France', TRUE, 'French'),
    ('Alessandro Bianchi', 'alessandro.bianchi@example.it', 'password200', '390223344556', 'alessandro_profile.jpg', '707 Oak St', 'Milan', '', 'Italy', TRUE, 'Italian'),
    ('Ahmed El-Sayed', 'ahmed.el-sayed@example.eg', 'password202', '201234567890', 'ahmed_profile.jpg', '808 Pine St', 'Cairo', '', 'Egypt', TRUE, 'Arabic'),
    ('John Smith', 'john.smith@example.co.uk', 'password201', '441234567890', 'john_profile.jpg', '909 Birch St', 'London', '', 'United Kingdom', TRUE, 'English (UK)'),
    ('Olivia Brown', 'olivia.brown@example.au', 'password220', '611234567890', 'olivia_profile.jpg', '1010 Cedar St', 'Sydney', '', 'Australia', TRUE, 'English (Australia)'),
    ('Michael Johnson', 'michael.johnson@example.us', 'password203', '11234567890', 'michael_profile.jpg', '1111 Maple St', 'New York', 'NY', 'USA', TRUE, 'English (USA)'),
    ('Emma Williams', 'emma.williams@example.ca', 'password103', '11234567891', 'emma_profile.jpg', '1212 Oak St', 'Toronto', '', 'Canada', TRUE, 'English (Canada)'),
    ('Chloe Dubois', 'chloe.dubois@example.ch', 'password301', '33122334456', 'chloe_profile.jpg', '1313 Pine St', 'Geneva', '', 'Switzerland', TRUE, 'French (Switzerland)'),
    ('Mats Andersson', 'mats.andersson@example.se', 'password300', '46709876544', 'mats_profile.jpg', '1414 Cedar St', 'Malmö', '', 'Sweden', TRUE, 'Swedish'),
    ('Sophie Schmidt', 'sophie.schmidt@example.de', 'password302', '491523456789', 'sophie_profile.jpg', '1515 Maple St', 'Hamburg', '', 'Germany', TRUE, 'German'),
    ('Luca Bruni', 'luca.bruni@example.it', 'password311', '39034567890', 'luca_profile.jpg', '1616 Oak St', 'Florence', '', 'Italy', TRUE, 'Italian'),
    ('Isabelle Laurent', 'isabelle.laurent@example.fr', 'password321', '33122334455', 'isabelle_profile.jpg', '1717 Pine St', 'Nice', '', 'France', TRUE, 'French');


--------------------------------------------------
-- Insert test data into the Host table
-- This links Hosts to Guests, making some Guests also Hosts
--------------------------------------------------
INSERT INTO Host (GuestID, Rating, Verified, HostSince, Stars, ExternalReviews, ReferredByHostID)
VALUES 
    (1, 4.5, TRUE, '2020-01-01', 5, 'Great reviews from external sites.', NULL),   
    (2, 4.0, TRUE, '2021-03-15', 4, 'Positive feedback from external platforms.', NULL),   
    (3, 4.8, TRUE, '2019-11-20', 5, 'Outstanding reviews.', NULL),   
    (4, 4.2, TRUE, '2020-06-25', 4, 'Excellent ratings on various platforms.', NULL),   
    (5, 4.7, TRUE, '2021-07-10', 5, 'Highly recommended by guests.', NULL),   
    (6, 4.9, TRUE, '2021-05-22', 5, 'Top-rated host with many positive reviews.', NULL),   
    (7, 4.3, TRUE, '2019-12-05', 4, 'Good reviews overall.', NULL),   
    (8, 4.6, TRUE, '2020-02-15', 5, 'Consistent positive feedback from guests.', NULL),   
    (9, 4.1, TRUE, '2021-09-01', 4, 'Mixed reviews but generally positive.', NULL),   
    (10, 4.4, TRUE, '2021-08-18', 5, 'Great experience reported by guests.', NULL),  
    (11, 4.3, TRUE, '2020-10-10', 4, 'Strong feedback from external reviews.', NULL),  
    (12, 4.8, TRUE, '2021-01-01', 5, 'Highly recommended by several sources.', NULL),  
    (13, 4.7, TRUE, '2020-03-20', 5, 'Great host with excellent reviews.', NULL),  
    (14, 4.9, TRUE, '2019-07-07', 5, 'One of the top-rated hosts.', NULL),  
    (15, 4.5, TRUE, '2021-04-15', 5, 'Guests consistently leave positive feedback.', NULL),  
    (16, 4.6, TRUE, '2019-09-25', 5, 'Highly rated by multiple sources.', NULL),  
    (17, 4.2, TRUE, '2020-11-10', 4, 'Reviews indicate a good experience.', NULL),  
    (18, 4.5, TRUE, '2021-02-22', 5, 'Popular host with lots of positive reviews.', NULL),  
    (19, 4.7, TRUE, '2020-12-15', 5, 'Guests frequently recommend this host.', NULL),  
    (20, 4.4, TRUE, '2021-03-10', 4, 'Well-reviewed host with solid ratings.', NULL);  

--------------------------------------------------
-- Insert test data into the SocialNetwork table
-- Define different social media platforms
--------------------------------------------------
INSERT INTO SocialNetwork (NetworkName, URL)
VALUES 
    ('Facebook', 'https://www.facebook.com'),
    ('Twitter', 'https://www.twitter.com'),
    ('Instagram', 'https://www.instagram.com'),
    ('LinkedIn', 'https://www.linkedin.com'),
    ('WhatsApp', 'https://www.whatsapp.com'),
    ('WeChat', 'https://www.wechat.com'),
    ('VK', 'https://www.vk.com'),
    ('Snapchat', 'https://www.snapchat.com'),
    ('TikTok', 'https://www.tiktok.com'),
    ('Pinterest', 'https://www.pinterest.com'),
    ('Reddit', 'https://www.reddit.com'),
    ('Tumblr', 'https://www.tumblr.com'),
    ('Flickr', 'https://www.flickr.com'),
    ('YouTube', 'https://www.youtube.com'),
    ('Vimeo', 'https://www.vimeo.com'),
    ('Discord', 'https://www.discord.com'),
    ('Telegram', 'https://www.telegram.org'),
    ('Signal', 'https://www.signal.org'),
    ('Baidu Tieba', 'https://tieba.baidu.com'),
    ('Douban', 'https://www.douban.com');
    
--------------------------------------------------
-- Insert test data into the GuestSocialNetwork table
-- Social media profiles linked to guests
--------------------------------------------------
INSERT INTO GuestSocialNetwork (GuestID, NetworkID, ProfileURL)
VALUES 
    (1, 1, 'https://www.facebook.com/hans.mueller'),
    (2, 2, 'https://www.twitter.com/emma.karlsson'),
    (3, 3, 'https://www.instagram.com/jean.dupont'),
    (4, 4, 'https://www.linkedin.com/in/giovanni.rossi'),
    (5, 5, 'https://www.whatsapp.com/seo.jun.lee'),
    (6, 6, 'https://www.wechat.com/sakura.tanaka'),
    (7, 7, 'https://www.vk.com/anna.svensson'),
    (8, 8, 'https://www.snapchat.com/friedrich.becker'),
    (9, 9, 'https://www.tiktok.com/pierre.martin'),
    (10, 10, 'https://www.pinterest.com/alessandro.bianchi'),
    (11, 11, 'https://www.reddit.com/user/ahmed.elsayed'),
    (12, 12, 'https://www.tumblr.com/john.smith'),
    (13, 13, 'https://www.flickr.com/olivia.brown'),
    (14, 14, 'https://www.youtube.com/michael.johnson'),
    (15, 15, 'https://www.vimeo.com/emma.williams'),
    (16, 16, 'https://www.discord.com/chloe.dubois'),
    (17, 17, 'https://www.telegram.org/mats.andersson'),
    (18, 18, 'https://www.signal.org/sophie.schmidt'),
    (19, 19, 'https://tieba.baidu.com/luca.bruni'),
    (20, 20, 'https://www.douban.com/isabelle.laurent');

--------------------------------------------------
-- Insert test data into the Notification table
-- Notifications sent to guests
--------------------------------------------------
INSERT INTO Notification (GuestID, Content, Timestamp)
VALUES 
    (1, 'Welcome to our service!', '2024-09-01 08:10:00'),
    (2, 'Your booking has been confirmed.', '2024-09-01 09:15:00'),
    (3, 'Payment successful.', '2024-09-01 10:20:00'),
    (4, 'Your stay in Rome is coming up.', '2024-09-01 11:25:00'),
    (5, 'Check-in available for your booking.', '2024-09-01 12:30:00'),
    (6, 'Reminder: Leave a review for your recent stay.', '2024-09-01 13:35:00'),
    (7, 'New message from your host.', '2024-09-01 14:40:00'),
    (8, 'Special offer for your next stay.', '2024-09-01 15:45:00'),
    (9, 'Booking cancellation successful.', '2024-09-01 16:50:00'),
    (10, 'Your refund has been processed.', '2024-09-01 17:55:00'),
    (11, 'New property added in your favorite city.', '2024-09-01 18:00:00'),
    (12, 'Update your profile to get better recommendations.', '2024-09-01 19:05:00'),
    (13, 'New loyalty points added to your account.', '2024-09-01 20:10:00'),
    (14, 'Last chance to book your dream vacation.', '2024-09-01 21:15:00'),
    (15, 'Your stay in New York is coming up.', '2024-09-01 22:20:00'),
    (16, 'Your booking for Zurich has been confirmed.', '2024-09-01 23:25:00'),
    (17, 'Check-out reminder for your stay.', '2024-09-02 00:30:00'),
    (18, 'Thank you for staying with us!', '2024-09-02 01:35:00'),
    (19, 'Special promotion: 20% off your next booking.', '2024-09-02 02:40:00'),
    (20, 'Your profile has been updated successfully.', '2024-09-02 03:45:00');

--------------------------------------------------
-- Insert test data into the LoginHistory table
-- Track guest login activity with timestamps and IP addresses
--------------------------------------------------
INSERT INTO LoginHistory (GuestID, LoginTimestamp, IPAddress)
VALUES 
    (1, '2024-09-01 08:00:00', '192.168.1.1'),
    (2, '2024-09-01 09:00:00', '192.168.1.2'),
    (3, '2024-09-01 10:00:00', '192.168.1.3'),
    (4, '2024-09-01 11:00:00', '192.168.1.4'),
    (5, '2024-09-01 12:00:00', '192.168.1.5'),
    (6, '2024-09-01 13:00:00', '192.168.1.6'),
    (7, '2024-09-01 14:00:00', '192.168.1.7'),
    (8, '2024-09-01 15:00:00', '192.168.1.8'),
    (9, '2024-09-01 16:00:00', '192.168.1.9'),
    (10, '2024-09-01 17:00:00', '192.168.1.10'),
    (11, '2024-09-01 18:00:00', '192.168.1.11'),
    (12, '2024-09-01 19:00:00', '192.168.1.12'),
    (13, '2024-09-01 20:00:00', '192.168.1.13'),
    (14, '2024-09-01 21:00:00', '192.168.1.14'),
    (15, '2024-09-01 22:00:00', '192.168.1.15'),
    (16, '2024-09-01 23:00:00', '192.168.1.16'),
    (17, '2024-09-02 00:00:00', '192.168.1.17'),
    (18, '2024-09-02 01:00:00', '192.168.1.18'),
    (19, '2024-09-02 02:00:00', '192.168.1.19'),
    (20, '2024-09-02 03:00:00', '192.168.1.20');

--------------------------------------------------
-- Insert test data into the City table
-- Define cities and their corresponding countries
--------------------------------------------------
INSERT INTO City (CityName, Country)
VALUES 
    ('Berlin', 'Germany'),
    ('Stockholm', 'Sweden'),
    ('Paris', 'France'),
    ('Rome', 'Italy'),
    ('Seoul', 'South Korea'),
    ('Tokyo', 'Japan'),
    ('Gothenburg', 'Sweden'),
    ('Munich', 'Germany'),
    ('Lyon', 'France'),
    ('Milan', 'Italy'),
    ('Cairo', 'Egypt'),
    ('London', 'United Kingdom'),
    ('Sydney', 'Australia'),
    ('New York', 'USA'),
    ('Toronto', 'Canada'),
    ('Zurich', 'Switzerland'),
    ('Malmo', 'Sweden'),
    ('Hamburg', 'Germany'),
    ('Florence', 'Italy'),
    ('Nice', 'France');

--------------------------------------------------
-- Insert test data into the Location table
-- Specify addresses and locations for vacation rentals within cities
--------------------------------------------------
INSERT INTO Location (CityID, Country, PartOfCity, Address, PhoneNumber, Email)
VALUES 
    (1, 'Germany', 'Mitte', 'Alexanderplatz 1, 10178 Berlin', '49123456789', 'info@berlin.de'),
    (2, 'Sweden', 'Södermalm', 'Götgatan 100, 11862 Stockholm', '46701234567', 'info@stockholm.se'),
    (3, 'France', 'Montmartre', 'Rue Lepic 18, 75018 Paris', '33123456789', 'info@paris.fr'),
    (4, 'Italy', 'Trastevere', 'Via della Scala 12, 00153 Rome', '390123456789', 'info@rome.it'),
    (5, 'South Korea', 'Gangnam-gu', 'Teheran-ro 100, 06134 Seoul', '821012345678', 'info@seoul.kr'),
    (6, 'Japan', 'Shibuya', 'Harajuku 1-23-45, 150-0001 Tokyo', '819012345678', 'info@tokyo.jp'),
    (7, 'Sweden', 'Vasastan', 'Sveavägen 50, 11359 Gothenburg', '46709876543', 'info@gothenburg.se'),
    (8, 'Germany', 'Altstadt-Lehel', 'Marienplatz 1, 80331 Munich', '4915123456789', 'info@munich.de'),
    (9, 'France', 'La Croix-Rousse', 'Rue de la République 50, 69001 Lyon', '33112233445', 'info@lyon.fr'),
    (10, 'Italy', 'Brera', 'Via Fiori Chiari 20, 20121 Milan', '390223344556', 'info@milan.it'),
    (11, 'Egypt', 'Zamalek', '26th of July St, Cairo', '201234567890', 'info@cairo.eg'),
    (12, 'United Kingdom', 'Westminster', '10 Downing St, London SW1A 2AA', '441234567890', 'info@london.co.uk'),
    (13, 'Australia', 'The Rocks', 'George St 140, 2000 Sydney', '611234567890', 'info@sydney.au'),
    (14, 'USA', 'Manhattan', '5th Avenue 350, New York, NY 10001', '11234567890', 'info@newyork.us'),
    (15, 'Canada', 'Downtown', 'Bay St 200, Toronto, ON M5J 2R8', '11234567891', 'info@toronto.ca'),
    (16, 'Switzerland', 'Altstadt', 'Bahnhofstrasse 1, 8001 Zurich', '41234567890', 'info@zurich.ch'),
    (17, 'Sweden', 'Gamla Staden', 'Södra Förstadsgatan 15, 21143 Malmo', '46709876544', 'info@malmo.se'),
    (18, 'Germany', 'HafenCity', 'Sandtorkai 30, 20457 Hamburg', '4915223456789', 'info@hamburg.de'),
    (19, 'Italy', 'Santa Maria Novella', 'Piazza di Santa Maria Novella, 50123 Florence', '390334455667', 'info@florence.it'),
    (20, 'France', 'Promenade des Anglais', 'Quai des États-Unis 50, 06300 Nice', '33122334455', 'info@nice.fr');

--------------------------------------------------
-- Insert test data into the VacationRental table
-- Define vacation rentals with relevant details like host, location, and property features
--------------------------------------------------
INSERT INTO VacationRental (
    HostID, LocationID, PropertyType, Description, MaxGuests, RatePerPerson, OwnBathroom, 
    DogFriendly, FreeParking, NumberOfBeds, CalendarAvailability, ProximityToBeach, 
    ProximityToShops, ProximityToSightSeeing)
VALUES
(1, 1, 'Apartment', 'Beautiful luxury apartment in the city center.', 4, 120.00, 1, 1, 1, 2, 'Available', '500m', '200m', '300m'),
(2, 2, 'House', 'Spacious family house with a garden.', 6, 150.00, 1, 1, 1, 3, 'Available', '1km', '500m', '700m'),
(3, 3, 'Apartment', 'Cozy apartment near the river.', 2, 80.00, 1, 0, 1, 1, 'Available', '300m', '100m', '200m'),
(4, 4, 'Villa', 'Luxury villa with ocean views.', 8, 250.00, 1, 1, 1, 4, 'Available', '50m', '1km', '500m'),
(5, 5, 'Condo', 'Modern condo in a high-rise building.', 3, 90.00, 1, 0, 1, 1, 'Available', '800m', '200m', '400m'),
(6, 6, 'Cottage', 'Charming cottage in the countryside.', 5, 130.00, 1, 1, 1, 2, 'Available', '10km', '5km', '6km'),
(7, 7, 'Townhouse', 'Stylish townhouse in a vibrant neighborhood.', 4, 140.00, 1, 1, 1, 2, 'Available', '1km', '500m', '800m'),
(8, 8, 'Penthouse', 'Top-floor penthouse with panoramic city views.', 4, 300.00, 1, 1, 1, 2, 'Available', '200m', '100m', '300m'),
(9, 9, 'Villa', 'Exclusive villa with private pool.', 10, 400.00, 1, 1, 1, 5, 'Available', '50m', '300m', '400m'),
(10, 10, 'Apartment', 'Affordable apartment close to the city center.', 3, 70.00, 1, 0, 1, 1, 'Available', '600m', '400m', '500m'),
(11, 11, 'Loft', 'Stylish loft in the heart of the city.', 2, 150.00, 1, 0, 1, 1, 'Available', '400m', '150m', '300m'),
(12, 12, 'Chalet', 'Cozy mountain chalet with fireplace.', 6, 180.00, 1, 1, 1, 3, 'Available', '1km', '600m', '800m'),
(13, 13, 'Bungalow', 'Beachfront bungalow in a tropical setting.', 4, 200.00, 1, 1, 1, 2, 'Available', '50m', '100m', '200m'),
(14, 14, 'Cabin', 'Secluded cabin in the woods.', 5, 120.00, 1, 1, 1, 2, 'Available', '5km', '3km', '4km'),
(15, 15, 'Studio', 'Compact studio in a quiet area.', 2, 60.00, 1, 0, 1, 1, 'Available', '500m', '300m', '400m'),
(16, 16, 'Mansion', 'Luxurious mansion with sprawling gardens.', 12, 500.00, 1, 1, 1, 6, 'Available', '1km', '500m', '700m'),
(17, 17, 'Townhouse', 'Spacious townhouse perfect for families.', 6, 160.00, 1, 1, 1, 3, 'Available', '700m', '200m', '300m'),
(18, 18, 'Villa', 'Exclusive villa with private beach access.', 8, 350.00, 1, 1, 1, 4, 'Available', '0m', '100m', '200m'),
(19, 19, 'Apartment', 'Cozy apartment for budget travelers.', 2, 50.00, 1, 0, 1, 1, 'Available', '800m', '400m', '600m'),
(20, 20, 'Cottage', 'Charming cottage with garden.', 5, 140.00, 1, 1, 1, 2, 'Available', '2km', '500m', '700m');

--------------------------------------------------
-- Insert test data into the Room table
-- Room availability and pricing for specific rentals
--------------------------------------------------
INSERT INTO Room (VacationRentalID, RoomType, PricePerNight, AvailableFrom, AvailableTo)
VALUES 
    (1, 'Deluxe', 150.00, '2024-01-01', '2024-03-31'),
    (2, 'Standard', 120.00, '2024-04-01', '2024-06-30'),
    (3, 'Deluxe', 180.00, '2024-07-01', '2024-09-30'),
    (4, 'Suite', 250.00, '2024-10-01', '2024-12-31'),
    (5, 'Standard', 90.00, '2024-02-01', '2024-05-31'),
    (6, 'Deluxe', 140.00, '2024-06-01', '2024-09-30'),
    (7, 'Cottage', 130.00, '2024-04-01', '2024-08-31'),
    (8, 'Standard', 100.00, '2024-05-01', '2024-10-31'),
    (9, 'Deluxe', 160.00, '2024-03-01', '2024-06-30'),
    (10, 'Standard', 120.00, '2024-07-01', '2024-12-31'),
    (11, 'Economy', 85.00, '2024-01-15', '2024-04-15'),
    (12, 'Standard', 200.00, '2024-05-01', '2024-08-31'),
    (13, 'Penthouse', 300.00, '2024-06-01', '2024-11-30'),
    (14, 'Loft', 160.00, '2024-03-01', '2024-07-31'),
    (15, 'Economy', 100.00, '2024-02-01', '2024-05-31'),
    (16, 'Chalet', 220.00, '2024-06-01', '2024-09-30'),
    (17, 'Townhouse', 130.00, '2024-04-01', '2024-07-31'),
    (18, 'Studio', 70.00, '2024-03-01', '2024-10-31'),
    (19, 'Suite', 240.00, '2024-05-01', '2024-09-30'),
    (20, 'Standard', 105.00, '2024-07-01', '2024-12-31');

--------------------------------------------------
-- Insert test data into the Amenity table
-- Defining various amenities available at vacation rentals
--------------------------------------------------
INSERT INTO Amenity (AmenityName, Description)
VALUES 
    ('WiFi', 'High-speed internet access'),
    ('Air Conditioning', 'Room equipped with air conditioning'),
    ('Heating', 'Central heating system'),
    ('Parking', 'Free parking space available'),
    ('Swimming Pool', 'Access to a swimming pool'),
    ('Kitchen', 'Fully equipped kitchen'),
    ('Laundry', 'Laundry facilities available'),
    ('Gym', 'Access to a gym'),
    ('Pet Friendly', 'Pets are allowed'),
    ('Breakfast', 'Breakfast included in the stay'),
    ('Balcony', 'Room with a balcony'),
    ('Terrace', 'Access to a terrace'),
    ('Sea View', 'Room with a view of the sea'),
    ('Fireplace', 'Room equipped with a fireplace'),
    ('TV', 'Television available in the room'),
    ('Garden', 'Access to a garden'),
    ('Hot Tub', 'Hot tub available'),
    ('Sauna', 'Access to a sauna'),
    ('Barbecue', 'Barbecue facilities available'),
    ('Bicycle Rental', 'Bicycles available for rent');

--------------------------------------------------
-- Insert test data into the VacationRentalAmenity table
-- Associating amenities with vacation rentals
--------------------------------------------------
INSERT INTO VacationRentalAmenity (VacationRentalID, AmenityID)
VALUES 
    (1, 1),  -- WiFi for VacationRentalID 1
    (2, 2),  -- Air Conditioning for VacationRentalID 2
    (3, 3),  -- Heating for VacationRentalID 3
    (4, 4),  -- Parking for VacationRentalID 4
    (5, 5),  -- Swimming Pool for VacationRentalID 5
    (6, 6),  -- Kitchen for VacationRentalID 6
    (7, 7),  -- Laundry for VacationRentalID 7
    (8, 8),  -- Gym for VacationRentalID 8
    (9, 9),  -- Pet Friendly for VacationRentalID 9
    (10, 10), -- Breakfast for VacationRentalID 10
    (11, 11), -- Balcony for VacationRentalID 11
    (12, 12), -- Terrace for VacationRentalID 12
    (13, 13), -- Sea View for VacationRentalID 13
    (14, 14), -- Fireplace for VacationRentalID 14
    (15, 15), -- TV for VacationRentalID 15
    (16, 16), -- Garden for VacationRentalID 16
    (17, 17), -- Hot Tub for VacationRentalID 17
    (18, 18), -- Sauna for VacationRentalID 18
    (19, 19), -- Barbecue for VacationRentalID 19
    (20, 20); -- Bicycle Rental for VacationRentalID 20

--------------------------------------------------
-- Insert test data into the Booking table
-- Bookings link Guests to Rooms and store critical booking details
--------------------------------------------------
INSERT INTO Booking (GuestID, RoomID, BookingDate, CheckInDate, CheckOutDate, TotalPrice, PaymentStatus, LengthOfStay, CancellationDeadline, CancellationRefund, DateOfCancellation, HostPayout, EventName, StartDate, EndDate, Description)
VALUES
    (1, 1, NOW(), '2024-09-01', '2024-09-07', 900.00, 'Pending', 6, '2024-08-29', 800.00, NULL, 850.00, 'Berlin Marathon', '2024-09-01', '2024-09-07', 'Running event in Berlin'),
    (2, 2, NOW(), '2024-09-05', '2024-09-10', 600.00, 'Paid', 5, '2024-09-03', 550.00, NULL, 580.00, 'Stockholm Music Festival', '2024-09-05', '2024-09-10', 'Music festival in Stockholm'),
    (3, 3, NOW(), '2024-09-10', '2024-09-15', 750.00, 'Pending', 5, '2024-09-08', 700.00, NULL, 725.00, 'Paris Fashion Week', '2024-09-10', '2024-09-15', 'Fashion event in Paris'),
    (4, 4, NOW(), '2024-09-12', '2024-09-18', 1500.00, 'Pending', 6, '2024-09-10', 1400.00, NULL, 1450.00, 'Rome Film Festival', '2024-09-12', '2024-09-18', 'Film festival in Rome'),
    (5, 5, NOW(), '2024-09-15', '2024-09-20', 450.00, 'Paid', 5, '2024-09-13', 400.00, NULL, 425.00, 'Seoul Food Festival', '2024-09-15', '2024-09-20', 'Food festival in Seoul'),
    (6, 6, NOW(), '2024-09-18', '2024-09-22', 560.00, 'Cancelled', 4, '2024-09-16', 500.00, '2024-09-18', 530.00, 'Tokyo Game Show', '2024-09-18', '2024-09-22', 'Gaming event in Tokyo'),
    (7, 7, NOW(), '2024-09-20', '2024-09-25', 650.00, 'Paid', 5, '2024-09-18', 600.00, NULL, 620.00, 'Gothenburg Book Fair', '2024-09-20', '2024-09-25', 'Book fair in Gothenburg'),
    (8, 8, NOW(), '2024-09-25', '2024-09-30', 700.00, 'Pending', 5, '2024-09-23', 650.00, NULL, 680.00, 'Munich Oktoberfest', '2024-09-25', '2024-09-30', 'Festival in Munich'),
    (9, 9, NOW(), '2024-09-28', '2024-10-03', 800.00, 'Paid', 5, '2024-09-26', 750.00, NULL, 780.00, 'Lyon Lights Festival', '2024-09-28', '2024-10-03', 'Light festival in Lyon'),
    (10, 10, NOW(), '2024-10-01', '2024-10-05', 480.00, 'Pending', 4, '2024-09-29', 400.00, NULL, 450.00, 'Milan Fashion Week', '2024-10-01', '2024-10-05', 'Fashion event in Milan'),
    (11, 11, NOW(), '2024-10-03', '2024-10-08', 425.00, 'Paid', 5, '2024-10-01', 380.00, NULL, 410.00, 'Cairo Film Festival', '2024-10-03', '2024-10-08', 'Film festival in Cairo'),
    (12, 12, NOW(), '2024-10-07', '2024-10-12', 1000.00, 'Pending', 5, '2024-10-05', 950.00, NULL, 975.00, 'London Literature Festival', '2024-10-07', '2024-10-12', 'Literature festival in London'),
    (13, 13, NOW(), '2024-10-10', '2024-10-15', 1500.00, 'Paid', 5, '2024-10-08', 1400.00, NULL, 1450.00, 'Sydney Opera Festival', '2024-10-10', '2024-10-15', 'Opera festival in Sydney'),
    (14, 14, NOW(), '2024-10-12', '2024-10-17', 800.00, 'Pending', 5, '2024-10-10', 750.00, NULL, 780.00, 'New York Film Festival', '2024-10-12', '2024-10-17', 'Film festival in New York'),
    (15, 15, NOW(), '2024-10-15', '2024-10-20', 500.00, 'Paid', 5, '2024-10-13', 450.00, NULL, 475.00, 'Toronto Beer Festival', '2024-10-15', '2024-10-20', 'Beer festival in Toronto'),
    (16, 16, NOW(), '2024-10-18', '2024-10-22', 1200.00, 'Cancelled', 4, '2024-10-16', 1100.00, '2024-10-18', 1150.00, 'Zurich International Film Festival', '2024-10-18', '2024-10-22', 'Film festival in Zurich'),
    (17, 17, NOW(), '2024-10-20', '2024-10-25', 650.00, 'Pending', 5, '2024-10-18', 600.00, NULL, 620.00, 'Malmö Food Fair', '2024-10-20', '2024-10-25', 'Food festival in Malmö'),
    (18, 18, NOW(), '2024-10-25', '2024-10-30', 350.00, 'Paid', 5, '2024-10-23', 300.00, NULL, 330.00, 'Hamburg Jazz Festival', '2024-10-25', '2024-10-30', 'Jazz festival in Hamburg'),
    (19, 19, NOW(), '2024-10-28', '2024-11-02', 1680.00, 'Pending', 5, '2024-10-26', 1600.00, NULL, 1650.00, 'Florence Art Exhibition', '2024-10-28', '2024-11-02', 'Art exhibition in Florence'),
    (20, 20, NOW(), '2024-11-01', '2024-11-05', 525.00, 'Paid', 4, '2024-10-30', 500.00, NULL, 510.00, 'Nice Film Festival', '2024-11-01', '2024-11-05', 'Film festival in Nice');

--------------------------------------------------
-- Insert test data into the Transaction table
-- Transactions (payments and refunds) linked to bookings
--------------------------------------------------
INSERT INTO Transaction (GuestID, BookingID, Amount, TransactionDate, PaymentMethod, TransactionType, RefundProcessedDate, Description)
VALUES 
    (1, 1, 900.00, '2024-09-01', 'CreditCard_Visa', 'Payment', NULL, 'Booking for vacation rental'),
    (2, 2, 600.00, '2024-09-05', 'PayPal', 'Payment', NULL, 'Booking for vacation rental'),
    (3, 3, 750.00, '2024-09-10', 'CreditCard_MasterCard', 'Payment', NULL, 'Booking for vacation rental'),
    (4, 4, 1500.00, '2024-09-12', 'BankTransfer', 'Payment', NULL, 'Booking for vacation rental'),
    (5, 5, 450.00, '2024-09-15', 'CreditCard_AMEX', 'Payment', NULL, 'Booking for vacation rental'),
    (6, 6, 560.00, '2024-09-18', 'ApplePay', 'Payment', NULL, 'Booking for vacation rental'),
    (7, 7, 650.00, '2024-09-20', 'CreditCard_Visa', 'Payment', NULL, 'Booking for vacation rental'),
    (8, 8, 700.00, '2024-09-25', 'GPay', 'Payment', NULL, 'Booking for vacation rental'),
    (9, 9, 800.00, '2024-09-28', 'Maestro', 'Payment', NULL, 'Booking for vacation rental'),
    (10, 10, 480.00, '2024-10-01', 'PayPal', 'Payment', NULL, 'Booking for vacation rental'),
    (11, 11, 200.00, '2024-09-02', 'CreditCard_Visa', 'Refund', '2024-09-02 10:00:00', 'Partial refund for early cancellation'),
    (12, 12, 150.00, '2024-09-06', 'PayPal', 'Refund', '2024-09-06 14:00:00', 'Refund due to service issues'),
    (13, 13, 100.00, '2024-09-11', 'CreditCard_MasterCard', 'Refund', '2024-09-11 16:30:00', 'Refund for service issues'),
    (14, 14, 1500.00, '2024-09-13', 'BankTransfer', 'Refund', '2024-09-13 12:00:00', 'Full refund for booking cancellation'),
    (15, 15, 450.00, '2024-09-16', 'CreditCard_AMEX', 'Refund', '2024-09-16 10:00:00', 'Full refund for booking cancellation'),
    (16, 16, 560.00, '2024-09-18', 'ApplePay', 'Refund', '2024-09-18 12:00:00', 'Refund for booking cancellation'),
    (17, 17, 650.00, '2024-09-20', 'CreditCard_Visa', 'Refund', '2024-09-20 09:00:00', 'Refund due to service issues'),
    (18, 18, 700.00, '2024-09-25', 'GPay', 'Refund', '2024-09-25 15:00:00', 'Partial refund for service issues'),
    (19, 19, 800.00, '2024-09-28', 'Maestro', 'Refund', '2024-09-28 17:00:00', 'Refund for booking cancellation'),
    (20, 20, 525.00, '2024-10-01', 'PayPal', 'Refund', '2024-10-01 11:30:00', 'Full refund for booking cancellation');

--------------------------------------------------
-- Insert test data into the TravelAdmin table
-- Admin users responsible for handling reservations and policies
--------------------------------------------------
INSERT INTO TravelAdmin (Name, Email, PhoneNumber, GuestID)
VALUES
    ('Hans Müller', 'hans.mueller@example.de', '+49 491523456789', 1),
    ('Emma Karlsson', 'emma.karlsson@example.se', '+46 467021234567', 2),
    ('Jean Dupont', 'jean.dupont@example.fr', '+33 33122334455', 3),
    ('Giovanni Rossi', 'giovanni.rossi@example.it', '+39 390123456789', 4),
    ('Seo-jun Lee', 'seo.jun.lee@example.kr', '+82 821012345678', 5),
    ('Sakura Tanaka', 'sakura.tanaka@example.jp', '+81 819012345678', 6),
    ('Anna Svensson', 'anna.svensson@example.se', '+46 46709876543', 7),
    ('Friedrich Becker', 'friedrich.becker@example.de', '+49 491523456789', 8),
    ('Pierre Martin', 'pierre.martin@example.fr', '+33 33122334455', 9),
    ('Alessandro Bianchi', 'alessandro.bianchi@example.it', '+39 390223344556', 10),
    ('Ahmed El-Sayed', 'ahmed.el-sayed@example.eg', '+20 201234567890', 11),
    ('John Smith', 'john.smith@example.co.uk', '+44 441234567890', 12),
    ('Olivia Brown', 'olivia.brown@example.au', '+61 611234567890', 13),
    ('Michael Johnson', 'michael.johnson@example.ca', '+1 11234567890', 14),
    ('Emma Williams', 'emma.williams@example.ca', '+1 11234567890', 15),
    ('Chloe Dubois', 'chloe.dubois@example.ch', '+41 46709876543', 16),
    ('Mats Andersson', 'mats.andersson@example.se', '+46 46709876544', 17),
    ('Sophie Schmidt', 'sophie.schmidt@example.de', '+49 491523456789', 18),
    ('Luca Bruni', 'luca.bruni@example.it', '+39 390234567890', 19),
    ('Isabelle Laurent', 'isabelle.laurent@example.fr', '+33 33122334455', 20);

--------------------------------------------------
-- Insert test data into the CancellationPolicy table
-- Policies regarding booking cancellations
--------------------------------------------------
INSERT INTO CancellationPolicy (PolicyName, Description)
VALUES 
    ('Flexible', 'Full refund up to 1 day before arrival'),
    ('Moderate', 'Full refund up to 5 days before arrival'),
    ('Strict', '50% refund up to 7 days before arrival'),
    ('Super Strict', '50% refund up to 14 days before arrival'),
    ('Non-refundable', 'No refund after booking'),
    ('Relaxed', 'Full refund up to 3 days before arrival'),
    ('Firm', '75% refund up to 2 days before arrival'),
    ('Standard', '50% refund up to 4 days before arrival'),
    ('Special', 'Full refund up to 10 days before arrival'),
    ('Custom', 'Refund terms are set by the host'),
    ('Partial Refund', '30% refund up to 3 days before arrival'),
    ('Full Refund', '100% refund up to 7 days before arrival'),
    ('Weekend Special', 'No refund on weekends'),
    ('Holiday Refund', 'Full refund on holidays'),
    ('Seasonal Refund', 'Partial refund depending on the season'),
    ('Last Minute', 'No refund for last-minute bookings'),
    ('High Season', 'Strict refund policy during high season'),
    ('Event Special', 'No refund during special events'),
    ('Flexible Plus', 'Full refund up to 2 days before arrival'),
    ('Summer Special', 'Full refund up to 7 days before arrival');

--------------------------------------------------
-- Insert test data into the VacationRentalPolicy table
-- Associating cancellation policies with vacation rentals
--------------------------------------------------
INSERT INTO VacationRentalPolicy (VacationRentalID, PolicyID)
VALUES 
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 9),
    (10, 10),
    (11, 11),
    (12, 12),
    (13, 13),
    (14, 14),
    (15, 15),
    (16, 16),
    (17, 17),
    (18, 18),
    (19, 19),
    (20, 20);

--------------------------------------------------
-- Insert test data into the Reservation table
-- Admin-handled reservation details
--------------------------------------------------
INSERT INTO Reservation (BookingID, AdminID, DateOfReservation, PaymentStatus, LengthOfStay, CancellationPolicy, RefundPolicy)
VALUES 
    (1, 1, '2024-09-01', 'Pending', 7, 'Flexible', 'Full refund up to 1 day before arrival'),
    (2, 2, '2024-09-05', 'Paid', 5, 'Moderate', 'Full refund up to 5 days before arrival'),
    (3, 3, '2024-09-10', 'Cancelled', 5, 'Strict', '50% refund up to 7 days before arrival'),
    (4, 4, '2024-09-12', 'Pending', 6, 'Super Strict', '50% refund up to 14 days before arrival'),
    (5, 5, '2024-09-15', 'Paid', 5, 'Non-refundable', 'No refund after booking'),
    (6, 6, '2024-09-18', 'Cancelled', 4, 'Relaxed', 'Full refund up to 3 days before arrival'),
    (7, 7, '2024-09-20', 'Paid', 5, 'Firm', '75% refund up to 2 days before arrival'),
    (8, 8, '2024-09-25', 'Pending', 5, 'Standard', '50% refund up to 4 days before arrival'),
    (9, 9, '2024-09-28', 'Paid', 5, 'Special', 'Full refund up to 10 days before arrival'),
    (10, 10, '2024-10-01', 'Pending', 4, 'Custom', 'Refund terms are set by the host'),
    (11, 11, '2024-10-03', 'Paid', 5, 'Partial Refund', '30% refund up to 3 days before arrival'),
    (12, 12, '2024-10-07', 'Pending', 5, 'Full Refund', '100% refund up to 7 days before arrival'),
    (13, 13, '2024-10-10', 'Paid', 5, 'Weekend Special', 'No refund on weekends'),
    (14, 14, '2024-10-12', 'Pending', 5, 'Holiday Refund', 'Full refund on holidays'),
    (15, 15, '2024-10-15', 'Paid', 5, 'Seasonal Refund', 'Partial refund depending on the season'),
    (16, 16, '2024-10-18', 'Cancelled', 4, 'Last Minute', 'No refund for last-minute bookings'),
    (17, 17, '2024-10-20', 'Pending', 5, 'High Season', 'Strict refund policy during high season'),
    (18, 18, '2024-10-25', 'Paid', 5, 'Event Special', 'No refund during special events'),
    (19, 19, '2024-10-28', 'Pending', 5, 'Flexible Plus', 'Full refund up to 2 days before arrival'),
    (20, 20, '2024-11-01', 'Paid', 4, 'Summer Special', 'Full refund up to 7 days before arrival');

--------------------------------------------------
-- Insert test data into the Review table
-- Reviews from guests and hosts
--------------------------------------------------
INSERT INTO Review (BookingID, ReviewerID, ReviewerType, Rating, Comment, ReviewDate)
VALUES
    (1, 1, 'Guest', 5, 'Fantastisches Erlebnis, werde definitiv zurückkommen!', '2024-09-01'), 
    (2, 2, 'Host', 4, 'Bra gäst, men lite bullrigt ibland.', '2024-09-02'), 
    (3, 3, 'Guest', 5, 'Expérience merveilleuse, très propre!', '2024-09-03'), 
    (4, 4, 'Host', 3, 'Buon soggiorno, ma il Wi-Fi era un po\' lento.', '2024-09-04'), 
    (5, 5, 'Guest', 4, '훌륭한 숙박이었어요!', '2024-09-05'), 
    (6, 6, 'Host', 5, '最高の滞在！また利用したいです。', '2024-09-06'), 
    (7, 7, 'Guest', 2, 'La habitación era más pequeña de lo esperado.', '2024-09-07'), 
    (8, 8, 'Host', 4, 'Локация отличная, хорошие гости.', '2024-09-08'), 
    (9, 9, 'Guest', 5, 'Wonderful stay, highly recommended!', '2024-09-09'), 
    (10, 10, 'Host', 3, 'Valor razonable, pero con algunos problemas de mantenimiento.', '2024-09-10'), 
    (11, 11, 'Guest', 5, 'Ottima esperienza!', '2024-09-11'), 
    (12, 12, 'Host', 4, 'Le client était respectueux et courtois.', '2024-09-12'), 
    (13, 13, 'Guest', 5, 'Great stay, the place was spotless!', '2024-09-13'), 
    (14, 14, 'Host', 3, 'L\'invitato è arrivato in ritardo.', '2024-09-14'), 
    (15, 15, 'Guest', 4, 'Gästvänligt ställe, men något bullrigt.', '2024-09-15'), 
    (16, 16, 'Host', 5, 'Excelente huésped, muy comunicativo.', '2024-09-16'), 
    (17, 17, 'Guest', 2, 'El apartamento no cumplió con mis expectativas.', '2024-09-17'), 
    (18, 18, 'Host', 4, 'Great guest, very tidy and respectful.', '2024-09-18'), 
    (19, 19, 'Guest', 5, 'حجز رائع، سأعود مرة أخرى!', '2024-09-19'), 
    (20, 20, 'Host', 3, 'L\'invité aurait pu être plus réactif.', '2024-09-20'); 


--------------------------------------------------
-- Insert test data into the CustomerService table
-- Customer service issues related to bookings
--------------------------------------------------
INSERT INTO CustomerService (BookingID, IssueDescription, Resolution, ContactMethod, ResolutionDate)
VALUES 
    (1, 'Late check-in', 'Offered late check-in', 'Phone', '2024-09-02'),
    (2, 'WiFi not working', 'Fixed WiFi issue', 'Email', '2024-09-06'),
    (3, 'Room not clean', 'Sent cleaning staff', 'Chat', '2024-09-11'),
    (4, 'No hot water', 'Repaired hot water system', 'Phone', '2024-09-13'),
    (5, 'Key not working', 'Provided new key', 'Email', '2024-09-16'),
    (6, 'Noise complaint', 'Offered room change', 'Chat', '2024-09-19'),
    (7, 'Room too cold', 'Adjusted thermostat', 'Phone', '2024-09-21'),
    (8, 'TV not working', 'Replaced TV', 'Email', '2024-09-26'),
    (9, 'No parking space', 'Arranged alternative parking', 'Chat', '2024-09-29'),
    (10, 'No towels in room', 'Delivered towels', 'Phone', '2024-10-02'),
    (11, 'Noisy neighbors', 'Spoke to neighbors', 'Email', '2024-10-04'),
    (12, 'Internet slow', 'Upgraded WiFi', 'Chat', '2024-10-08'),
    (13, 'Broken chair', 'Replaced chair', 'Phone', '2024-10-11'),
    (14, 'Shower not draining', 'Unclogged drain', 'Email', '2024-10-13'),
    (15, 'No hot water', 'Repaired hot water system', 'Chat', '2024-10-17'),
    (16, 'Air conditioning not working', 'Fixed AC', 'Phone', '2024-10-20'),
    (17, 'No blankets', 'Delivered blankets', 'Email', '2024-10-23'),
    (18, 'Broken lock', 'Fixed lock', 'Chat', '2024-10-27'),
    (19, 'Water leak', 'Repaired leak', 'Phone', '2024-10-30'),
    (20, 'Loud construction noise', 'Offered room change', 'Email', '2024-11-03');

--------------------------------------------------
-- Insert test data into the Event table
-- Event details linked to specific bookings
--------------------------------------------------
INSERT INTO Event (BookingID, EventName, StartDate, EndDate, Description)
VALUES 
    (1, 'Berlin Marathon', '2024-09-08', '2024-09-10', 'Annual marathon event'),
    (2, 'Stockholm Music Festival', '2024-09-11', '2024-09-13', 'Music festival in Stockholm'),
    (3, 'Paris Fashion Week', '2024-09-14', '2024-09-20', 'Fashion event in Paris'),
    (4, 'Rome Film Festival', '2024-09-21', '2024-09-25', 'Film festival in Rome'),
    (5, 'Seoul Food Festival', '2024-09-26', '2024-09-28', 'Food festival in Seoul'),
    (6, 'Tokyo Game Show', '2024-09-29', '2024-10-01', 'Gaming event in Tokyo'),
    (7, 'Gothenburg Book Fair', '2024-10-02', '2024-10-05', 'Book fair in Gothenburg'),
    (8, 'Munich Oktoberfest', '2024-10-06', '2024-10-10', 'Beer festival in Munich'),
    (9, 'Lyon Lights Festival', '2024-10-11', '2024-10-13', 'Light festival in Lyon'),
    (10, 'Milan Fashion Week', '2024-10-14', '2024-10-18', 'Fashion event in Milan'),
    (11, 'Cairo Film Festival', '2024-10-19', '2024-10-22', 'Film festival in Cairo'),
    (12, 'London Literature Festival', '2024-10-23', '2024-10-27', 'Literature festival in London'),
    (13, 'Sydney Opera Festival', '2024-10-28', '2024-11-01', 'Opera festival in Sydney'),
    (14, 'New York Comic Con', '2024-11-02', '2024-11-05', 'Comic convention in New York'),
    (15, 'Toronto Film Festival', '2024-11-06', '2024-11-10', 'Film festival in Toronto'),
    (16, 'Zurich Art Festival', '2024-11-11', '2024-11-14', 'Art festival in Zurich'),
    (17, 'Malmo Music Festival', '2024-11-15', '2024-11-17', 'Music festival in Malmo'),
    (18, 'Hamburg Christmas Market', '2024-11-18', '2024-11-20', 'Christmas market in Hamburg'),
    (19, 'Florence Food Festival', '2024-11-21', '2024-11-24', 'Food festival in Florence'),
    (20, 'Nice Jazz Festival', '2024-11-25', '2024-11-27', 'Jazz festival in Nice');
    
--------------------------------------------------
-- Insert test data into the Promotion table
-- Promotional offers for vacation rentals
--------------------------------------------------
INSERT INTO Promotion (VacationRentalID, DiscountPercentage, StartDate, EndDate)
VALUES
    (1, 10.0, '2024-09-01', '2024-09-07'),  -- Hans Müller
    (2, 15.0, '2024-09-05', '2024-09-10'),  -- Emma Karlsson
    (3, 12.5, '2024-09-10', '2024-09-15'),  -- Jean Dupont
    (4, 20.0, '2024-09-12', '2024-09-18'),  -- Giovanni Rossi
    (5, 8.0, '2024-09-15', '2024-09-20'),   -- Seo-jun Lee
    (6, 10.0, '2024-09-18', '2024-09-22'),  -- Sakura Tanaka
    (7, 7.5, '2024-09-20', '2024-09-25'),   -- Anna Svensson
    (8, 18.0, '2024-09-25', '2024-09-30'),  -- Friedrich Becker
    (9, 12.0, '2024-09-28', '2024-10-03'),  -- Pierre Martin
    (10, 14.0, '2024-10-01', '2024-10-05'), -- Alessandro Bianchi
    (11, 9.5, '2024-10-03', '2024-10-08'),  -- Ahmed El-Sayed
    (12, 11.0, '2024-10-07', '2024-10-12'), -- John Smith
    (13, 25.0, '2024-10-10', '2024-10-15'), -- Olivia Brown
    (14, 19.0, '2024-10-12', '2024-10-17'), -- Michael Johnson
    (15, 15.0, '2024-10-15', '2024-10-20'), -- Emma Williams
    (16, 17.5, '2024-10-18', '2024-10-22'), -- Chloe Dubois
    (17, 20.0, '2024-10-20', '2024-10-25'), -- Mats Andersson
    (18, 5.0, '2024-10-25', '2024-10-30'),  -- Sophie Schmidt
    (19, 22.0, '2024-10-28', '2024-11-02'), -- Luca Bruni
    (20, 10.0, '2024-11-01', '2024-11-05'); -- Isabelle Laurent

-- Enable foreign key checks after all tables are created and data inserted
SET FOREIGN_KEY_CHECKS = 1;

-- Verify data by selecting from the Guest table
SELECT * FROM Guest;

-- Verify data by selecting from the Host table
SELECT * FROM Host;

-- Verify data by selecting from the VacationRental table
SELECT * FROM VacationRental;

-- Verify data by selecting from the Room table
SELECT * FROM Room;

-- Verify data by selecting from the Amenity table
SELECT * FROM Amenity;

-- Verify data by selecting from the VacationRentalAmenity table
SELECT * FROM VacationRentalAmenity;

-- Verify data by selecting from the CancellationPolicy table
SELECT * FROM CancellationPolicy;

-- Verify data by selecting from the VacationRentalPolicy table
SELECT * FROM VacationRentalPolicy;

-- Verify data by selecting from the Booking table
SELECT * FROM Booking;

-- Verify data by selecting from the Transaction table
SELECT * FROM Transaction;

-- Verify data by selecting from the Review table
SELECT * FROM Review;

-- Verify data by selecting from the CustomerService table
SELECT * FROM CustomerService;

-- Verify data by selecting from the Event table
SELECT * FROM Event;

-- Verify data by selecting from the Promotion table
SELECT * FROM Promotion;

-- Verify data by selecting from the Notification table
SELECT * FROM Notification;

-- Verify data by selecting from the LoginHistory table
SELECT * FROM LoginHistory;

-- Verify data by selecting from the SocialNetwork table
SELECT * FROM SocialNetwork;

-- Verify data by selecting from the GuestSocialNetwork table
SELECT * FROM GuestSocialNetwork;

-- Verify data by selecting from the City table
SELECT * FROM City;

-- Verify data by selecting from the Location table
SELECT * FROM Location;

-- Verify data by selecting from the TravelAdmin table
SELECT * FROM TravelAdmin;

-- Verify data by selecting from the Reservation table
SELECT * FROM Reservation;

--------------------------------------------------
-- Data Integrity Check: Orphaned Bookings
-- This query checks for bookings that are not linked to any guest.
--------------------------------------------------
SELECT b.BookingID, b.GuestID, g.Name
FROM Booking b
LEFT JOIN Guest g ON b.GuestID = g.GuestID
WHERE g.GuestID IS NULL;

-- Test Case 1: Retrieve guest booking details, host details, and vacation rental details.
-- Verifies if the join across Booking, Guest, Room, VacationRental, and Host is working as expected.
SELECT 
    g.Name AS GuestName,
    b.BookingDate,
    b.CheckInDate,
    b.CheckOutDate,
    b.TotalPrice,
    vr.PropertyType,
    h.HostID,
    h.Rating AS HostRating
FROM Booking b
JOIN Guest g ON b.GuestID = g.GuestID
JOIN Room r ON b.RoomID = r.RoomID
JOIN VacationRental vr ON r.VacationRentalID = vr.VacationRentalID
JOIN Host h ON vr.HostID = h.HostID
ORDER BY b.BookingDate DESC;

--------------------------------------------------
-- Test Case 2: Retrieve payment and refund details for each booking, along with guest information.
-- Tests the Transaction-Booking-Guest relationship.
--------------------------------------------------
SELECT 
    g.Name AS GuestName,
    b.BookingDate,
    t.Amount AS TransactionAmount,
    t.TransactionDate,
    t.TransactionType,
    t.RefundProcessedDate,
    t.Description AS TransactionDescription
FROM Transaction t
JOIN Booking b ON t.BookingID = b.BookingID
JOIN Guest g ON t.GuestID = g.GuestID
ORDER BY t.TransactionDate DESC;

--------------------------------------------------
-- Test Case 3: Retrieve guest reviews, customer service details, and property information.
-- Tests the Review and CustomerService tables along with Booking, Guest, and VacationRental.
--------------------------------------------------
SELECT 
    g.Name AS GuestName,
    vr.PropertyType,
    r.Rating AS ReviewRating,
    r.Comment AS ReviewComment,
    cs.IssueDescription AS CustomerServiceIssue,
    cs.Resolution AS CustomerServiceResolution,
    cs.ContactMethod AS CustomerServiceContact
FROM Guest g
JOIN Booking b ON g.GuestID = b.GuestID
JOIN Review r ON b.BookingID = r.BookingID
LEFT JOIN CustomerService cs ON b.BookingID = cs.BookingID
JOIN Room rm ON b.RoomID = rm.RoomID
JOIN VacationRental vr ON rm.VacationRentalID = vr.VacationRentalID
JOIN Host h ON vr.HostID = h.HostID
ORDER BY g.Name ASC;

--------------------------------------------------
-- Test Case 4: Retrieve details for cancelled bookings along with guest information
--------------------------------------------------
SELECT 
    b.BookingID,
    g.Name AS GuestName,
    b.RoomID,
    b.TotalPrice,
    b.CancellationRefund,
    b.DateOfCancellation
FROM 
    Booking b
JOIN 
    Guest g ON b.GuestID = g.GuestID
WHERE 
    b.PaymentStatus = 'Cancelled'
ORDER BY 
    b.DateOfCancellation DESC;

--------------------------------------------------
-- Test Case 5: VacationRental Location and City
--------------------------------------------------
SELECT 
    vr.VacationRentalID,
    vr.PropertyType,
    l.PartOfCity,
    c.CityName,
    c.Country
FROM VacationRental vr
JOIN Location l ON vr.LocationID = l.LocationID
JOIN City c ON l.CityID = c.CityID
ORDER BY vr.VacationRentalID;

--------------------------------------------------
-- Test Case 6: Promotions for Vacation Rentals
-------------------------------------------------- 
SELECT 
    vr.PropertyType,
    p.DiscountPercentage,
    p.StartDate,
    p.EndDate
FROM VacationRental vr
JOIN Promotion p ON vr.VacationRentalID = p.VacationRentalID
ORDER BY p.StartDate;


-- Enable foreign key checks after all tables are created and data inserted
SET FOREIGN_KEY_CHECKS = 1;
