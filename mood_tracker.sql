-- Users Table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password TEXT NOT NULL
);

-- Mood Data Table
CREATE TABLE user_data (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id) ON DELETE CASCADE,
  daily_resume TEXT,
  hours_slept INT,
  exercise_time INT,
  day_emotion VARCHAR(255),
  person VARCHAR(255),
  weather VARCHAR(255),
  emotions TEXT[]
);