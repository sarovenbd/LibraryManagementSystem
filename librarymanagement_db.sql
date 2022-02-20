-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 12, 2021 at 06:31 PM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 8.0.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `librarymanagement_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `author` varchar(50) DEFAULT NULL,
  `publication` varchar(50) NOT NULL,
  `copies` int(11) NOT NULL,
  `dateListed` datetime DEFAULT current_timestamp(),
  `price` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`id`, `title`, `author`, `publication`, `copies`, `dateListed`, `price`, `status`) VALUES
(1, 'Life of a CSE Student', 'Mohammad Shah Alam', 'GUB', 100, '2021-09-12 13:50:01', 99, 1),
(2, 'How to hack NASA', 'Mohammad Shah Alam', 'GUCC', 199, '2021-09-12 13:50:01', 999, 1);

-- --------------------------------------------------------

--
-- Table structure for table `issue_book`
--

CREATE TABLE `issue_book` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `issue_date` date DEFAULT curdate(),
  `return_date` date NOT NULL,
  `book_id` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `issue_book`
--

INSERT INTO `issue_book` (`id`, `user_id`, `issue_date`, `return_date`, `book_id`, `status`) VALUES
(1, 1, '0000-00-00', '2021-09-16', 1, 0),
(2, 1, '2021-09-12', '2021-09-16', 1, 0),
(3, 1, '2021-09-12', '0000-00-00', 1, 0),
(4, 1, '2021-09-12', '2010-05-20', 1, 1),
(5, 1, '2021-09-02', '2021-09-16', 1, 1),
(6, 1, '2021-09-15', '2021-09-16', 1, 1),
(7, 2, '2021-09-12', '2021-09-18', 2, 0),
(8, 2, '2021-09-17', '2021-09-18', 1, 1);

--
-- Triggers `issue_book`
--
DELIMITER $$
CREATE TRIGGER `after_issue_book` AFTER INSERT ON `issue_book` FOR EACH ROW UPDATE users SET read_book = read_book + 1 WHERE id = new.user_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_issue_book_update_copies` AFTER INSERT ON `issue_book` FOR EACH ROW UPDATE books SET copies = copies - 1 WHERE id = new.book_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `lost_book`
--

CREATE TABLE `lost_book` (
  `id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `lost_date` date NOT NULL DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `lost_book`
--

INSERT INTO `lost_book` (`id`, `book_id`, `lost_date`) VALUES
(2, 1, '0000-00-00'),
(3, 1, '2021-09-12'),
(4, 2, '2021-09-09'),
(5, 2, '2021-09-02'),
(6, 2, '2021-09-12');

--
-- Triggers `lost_book`
--
DELIMITER $$
CREATE TRIGGER `after_lost_book` AFTER INSERT ON `lost_book` FOR EACH ROW UPDATE books SET copies = copies - 1 WHERE id = new.book_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `return_book`
--

CREATE TABLE `return_book` (
  `id` int(11) NOT NULL,
  `issue_id` int(11) NOT NULL,
  `return_date` date DEFAULT curdate(),
  `comment` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `return_book`
--

INSERT INTO `return_book` (`id`, `issue_id`, `return_date`, `comment`) VALUES
(2, 1, '0000-00-00', 'good'),
(3, 1, '2021-09-12', 'good'),
(4, 7, '2020-12-15', 'book condition is good'),
(5, 3, '2021-09-12', '');

--
-- Triggers `return_book`
--
DELIMITER $$
CREATE TRIGGER `after_return_book` AFTER INSERT ON `return_book` FOR EACH ROW UPDATE issue_book SET status = '0' WHERE id = new.issue_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_return_book_update_copies` AFTER INSERT ON `return_book` FOR EACH ROW UPDATE books SET copies = copies + 1 WHERE id = (SELECT book_id FROM issue_book WHERE id = new.issue_id)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `title` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `title`) VALUES
(1, 'student'),
(2, 'teacher'),
(3, 'management');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `address` varchar(150) DEFAULT NULL,
  `role_id` int(11) NOT NULL,
  `read_book` int(11) NOT NULL DEFAULT 0,
  `joinDate` datetime DEFAULT current_timestamp(),
  `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `gender`, `address`, `role_id`, `read_book`, `joinDate`, `status`) VALUES
(1, 'roven', 'saroven@yahoo.com', 'male', 'dhaka', 1, 2, '2021-09-12 13:52:55', 1),
(2, 'Badhan Saha', 'badhan@gmai.com', 'male', 'cumilla', 2, 2, '2021-09-12 21:58:10', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `issue_book`
--
ALTER TABLE `issue_book`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `book_id` (`book_id`);

--
-- Indexes for table `lost_book`
--
ALTER TABLE `lost_book`
  ADD PRIMARY KEY (`id`),
  ADD KEY `book_id` (`book_id`);

--
-- Indexes for table `return_book`
--
ALTER TABLE `return_book`
  ADD PRIMARY KEY (`id`),
  ADD KEY `issue_id` (`issue_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `role_id` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `issue_book`
--
ALTER TABLE `issue_book`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `lost_book`
--
ALTER TABLE `lost_book`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `return_book`
--
ALTER TABLE `return_book`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `issue_book`
--
ALTER TABLE `issue_book`
  ADD CONSTRAINT `issue_book_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `issue_book_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`);

--
-- Constraints for table `lost_book`
--
ALTER TABLE `lost_book`
  ADD CONSTRAINT `lost_book_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`);

--
-- Constraints for table `return_book`
--
ALTER TABLE `return_book`
  ADD CONSTRAINT `return_book_ibfk_1` FOREIGN KEY (`issue_id`) REFERENCES `issue_book` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
