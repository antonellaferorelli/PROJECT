CREATE TABLE hotels (

    hotel_id INT AUTO_INCREMENT PRIMARY KEY,

    hotel_name VARCHAR(255) NOT NULL,

    hotel_address TEXT NOT NULL,

    lat DECIMAL(10,7),

    lng DECIMAL(10,7)

);

CREATE TABLE reviewers (

    reviewer_id INT AUTO_INCREMENT PRIMARY KEY,

    reviewer_nationality VARCHAR(100),

    total_number_of_reviews_reviewer_has_given INT

);

CREATE TABLE hotel_stats (

    hotel_id INT PRIMARY KEY ,

    average_score DECIMAL(3,1),

    total_number_of_reviews INT,

    additional_number_of_scoring INT,

    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)

);

CREATE TABLE reviews (

    review_id INT PRIMARY KEY,

    hotel_id INT NOT NULL,

    reviewer_id INT NOT NULL,

    review_date DATE,

    review_year INT,

    review_month INT,

    reviewer_score DECIMAL(3,1),

    negative_review TEXT,

    positive_review TEXT,

    review_total_negative_word_counts INT,

    review_total_positive_word_counts INT,

    tags TEXT,

    days_since_review VARCHAR(50),

    stay_nights INT,

    total_review_length INT,

    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id),

    FOREIGN KEY (reviewer_id) REFERENCES reviewers(reviewer_id));


