-- phpMyAdmin SQL Dump
-- Database: `emoboba`

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `emoboba`
--

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `moods`
--

CREATE TABLE `moods` (
  `id` int(11) NOT NULL,
  `name` varchar(20) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `color_code` varchar(7) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `moods`
--

INSERT INTO `moods` (`id`, `name`, `description`, `color_code`) VALUES
(1, 'happy', 'Celebratory and uplifting dishes for joyful moments', '#FFD93D'),
(2, 'sad', 'Comfort food for when you need a warm hug', '#6B93D6'),
(3, 'angry', 'Bold and satisfying dishes to help you decompress', '#FF6B6B'),
(4, 'fear', 'Calming and grounding dishes to ease anxiety', '#9B7EDE');

-- --------------------------------------------------------

--
-- Table structure for table `restaurants`
--

CREATE TABLE `restaurants` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `hours` varchar(100) DEFAULT NULL,
  `happy_hour` varchar(100) DEFAULT NULL,
  `price_range` varchar(20) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `restaurants`
--

INSERT INTO `restaurants` (`id`, `name`, `description`, `address`, `hours`, `happy_hour`, `price_range`, `image_url`) VALUES
(1, 'R&D', 'A trendy modern Asian restaurant perfect for small gatherings or celebrations. Lively but not overwhelming — great for dates or meeting with friends.', '112 Spadina Ave, Toronto, ON', 'Sun–Thu 11:30–22:30; Fri–Sat 11:30–00:30', 'Daily 3–6pm', '$22–38', '/static/images/1_R&D_01.jpg'),
(2, 'Rol San', 'A classic dim sum spot with tightly packed tables and a lively, shared-eating atmosphere. Great for groups who want to snack and chat.', '298 Spadina Ave, Toronto, ON', 'Mon–Thu 10:00–22:00; Fri–Sun 10:00–23:00', 'Weekdays 2–5pm (20% off on selected dim sum)', '$15–30', '/static/images/2_RolSan_01.jpg'),
(3, 'Banh Mi Nguyen Huong', 'A quick, no-frills Vietnamese sandwich shop known for fast service and satisfying flavors — perfect for a grab-and-go bite.', '225 Spadina Ave, Toronto, ON', 'Daily 10:30–19:30', NULL, '$8–15', '/static/images/3_BanhMiNguyenHuong_01.jpg'),
(4, 'Yi Ji Noodle House', 'A quiet and comforting noodle spot where you can sit alone, warm up, and reset. Simple, calm, and soothing.', '180 Dundas St W, Toronto, ON', 'Sun–Thu 11:00–21:30; Fri–Sat 11:00–22:30', 'Daily 8–9pm ($2 off sides with any noodle soup)', '$14–26', '/static/images/4_YiJiNoodleHouse_01.jpg'),
(5, 'Swatow Restaurant', 'A nostalgic Cantonese eatery known for warm, simple dishes. Great for days when you want something easy, warm, and familiar.', '309 Spadina Ave, Toronto, ON', 'Daily 11:00–23:00', 'Daily 3–5pm ($3 off congee sets)', '$18–35', '/static/images/5_SwatowRestaurant_01.jpg'),
(6, 'House of Gourmet', 'A reliable Hong Kong–style diner offering generous portions and slow, comforting meals — ideal when you want to quietly recharge.', '188 Dundas St W, Toronto, ON', 'Mon–Thu 11:00–22:00; Fri–Sun 11:00–23:00', 'Weekdays 4–6pm ($2 off rice and noodle dishes)', '$20–36', '/static/images/6_HouseofGourmet_01.jpg'),
(7, 'Famous Owl of Minerva', 'A late-night Korean eatery with bold flavors and upbeat energy. Great for venting, snacking, and shaking off irritation.', '510 Yonge St, Toronto, ON', 'Daily 11:30–02:00', 'Daily 9pm–close (discounted fried dishes & drinks)', '$22–40', '/static/images/7_FamousOwlofMinerva_01.jpg'),
(8, 'Juicy Dumpling', 'A fast, budget-friendly dumpling shop that delivers instant satisfaction. Perfect when you''re irritated and want something quick and filling.', '220 Dundas St W, Toronto, ON', 'Daily 11:00–21:00', NULL, '$10–18', '/static/images/8_JuicyDumpling_01.jpg'),
(9, 'Kung Fu Beef Chinese BBQ', 'A lively skewer spot great for late-night conversations and venting with friends. The smoky, cumin-heavy aroma feels instantly de-stressing.', '66 Baldwin St, Toronto, ON', 'Mon–Thu 12:00–23:00; Fri–Sun 12:00–00:00', 'Daily 5–7pm (second skewer half price)', '$18–34', '/static/images/9_KungFuBeefChineseBBQ_01.jpg'),
(10, 'Four Four South Village', 'A homey Taiwanese restaurant offering warm, nostalgic comfort. Ideal for moments when you need grounding and emotional reassurance.', '44 Huron St, Toronto, ON', 'Tue–Sun 11:30–21:30 (Closed Mon)', 'Tue–Fri 2–4pm ($2 off lunch sets)', '$16–28', '/static/images/10_FourFourSouthVillage_01.jpg'),
(11, 'Hong Kong Bistro Cafe', 'A cozy cha chaan teng with booth seating that makes it easy to tuck yourself away. Great for quiet moments and emotional decompression.', '311 Spadina Ave, Toronto, ON', 'Daily 09:00–22:00', 'Weekdays 3–6pm (milk tea half price for second cup)', '$18–32', '/static/images/11_HongKongBistroCafe_01.jpg'),
(12, 'Pho Hung', 'A classic Vietnamese pho spot with fast service and hot, soothing broth. Great when anxiety affects appetite or digestion.', '350 Spadina Ave, Toronto, ON', 'Daily 11:00–23:30', 'Daily 2–4pm ($1 off beverages)', '$16–28', '/static/images/12_PhoHung_01.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `restaurant_tags`
--

CREATE TABLE `restaurant_tags` (
  `id` int(11) NOT NULL,
  `restaurant_id` int(11) NOT NULL,
  `tag` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `restaurant_tags`
--

INSERT INTO `restaurant_tags` (`id`, `restaurant_id`, `tag`) VALUES
(1, 1, 'celebration meal'),
(2, 1, 'treat yourself'),
(3, 1, 'shareable'),
(4, 1, 'uplifting'),
(5, 2, 'dim sum vibes'),
(6, 2, 'friend hangouts'),
(7, 2, 'celebration'),
(8, 2, 'shareable'),
(9, 3, 'on-the-go'),
(10, 3, 'crunchy & fresh'),
(11, 3, 'quick bite'),
(12, 3, 'uplifting'),
(13, 4, 'warm comfort'),
(14, 4, 'solo-friendly'),
(15, 4, 'gentle & filling'),
(16, 4, 'quiet reset'),
(17, 5, 'food hug'),
(18, 5, 'easy to eat'),
(19, 5, 'warm & soothing'),
(20, 5, 'low effort'),
(21, 6, 'quiet meal'),
(22, 6, 'slow comfort'),
(23, 6, 'hearty rice bowl'),
(24, 6, 'recharge'),
(25, 7, 'mood reset'),
(26, 7, 'crispy & tangy'),
(27, 7, 'punchy flavors'),
(28, 7, 'blow off steam'),
(29, 8, 'stress pop'),
(30, 8, 'eat fast'),
(31, 8, 'budget-friendly'),
(32, 8, 'satisfying'),
(33, 9, 'rant with friends'),
(34, 9, 'chew away stress'),
(35, 9, 'cumin & char'),
(36, 9, 'night snack'),
(37, 10, 'home feeling'),
(38, 10, 'steady comfort'),
(39, 10, 'simple & reliable'),
(40, 10, 'grounding'),
(41, 11, 'booth comfort'),
(42, 11, 'phone & chill'),
(43, 11, 'not too heavy'),
(44, 11, 'anxiety fade'),
(45, 12, 'gentle stomach'),
(46, 12, 'light & clean'),
(47, 12, 'soothing'),
(48, 12, 'manageable');

-- --------------------------------------------------------

--
-- Table structure for table `dishes`
--

CREATE TABLE `dishes` (
  `id` int(11) NOT NULL,
  `restaurant_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `hook` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `mood_id` int(11) NOT NULL,
  `price` decimal(6,2) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dishes`
--

INSERT INTO `dishes` (`id`, `restaurant_id`, `name`, `hook`, `description`, `mood_id`, `price`, `image_url`) VALUES
(1, 1, 'Truffle Fried Rice', 'Celebrate your win with a bowl of fancy comfort.', 'A homestyle dish elevated into a small luxury — truffle aroma and crispy toppings make it perfect for days when you''re in a good mood and want to treat yourself.', 1, 28.00, '/static/images/1_R&D_Dish.jpg'),
(2, 2, 'Shrimp Dumplings (Har Gow)', 'Dim sum party — one more basket won''t hurt.', 'Thin, translucent wrappers with bouncy shrimp filling. The kind of dish you keep reordering when you''re having a fun time with friends.', 1, 8.00, '/static/images/2_RolSan_Dish.jpg'),
(3, 3, 'Grilled Pork Banh Mi', 'Take a crunchy bite of happiness on the go.', 'A crispy baguette filled with juicy grilled pork, pickled veggies, and herbs — a fresh, uplifting bite you can enjoy while walking.', 1, 9.00, '/static/images/3_BanhMiNguyenHuong_Dish.jpg'),
(4, 4, 'Wonton Noodle Soup', 'A warm bowl to hold you together.', 'A gentle combination of clear broth, egg noodles, and shrimp-pork wontons — perfect when you feel low and want something comforting.', 2, 16.00, '/static/images/4_YiJiNoodleHouse_Dish.jpg'),
(5, 5, 'Cantonese Congee w/ Fish & Lettuce', 'Soft, warm, and low effort — like a food hug.', 'Silky congee with tender fish slices and crisp lettuce. Easy, warm, and soothing — perfect for emotionally low days.', 2, 14.00, '/static/images/5_SwatowRestaurant_Dish.jpg'),
(6, 6, 'Tomato Beef Brisket on Rice', 'Sweet tomato broth, slow comfort.', 'Tender tomato-braised brisket served over rice. Gentle, warm, and perfect for quiet emotional recovery.', 2, 18.00, '/static/images/6_HouseofGourmet_Dish.jpg'),
(7, 7, 'Yuzu Chicken', 'Sour enough to distract you from your rage.', 'Crispy fried chicken coated in a bright, tangy yuzu glaze — a palate punch that helps reset your mood.', 3, 24.00, '/static/images/7_FamousOwlofMinerva_Dish.jpg'),
(8, 8, 'Soup Dumplings (Xiao Long Bao)', 'Bite, burst, and feel the stress pop.', 'Juicy dumplings that burst with broth — a quick, satisfying way to release tension and frustration.', 3, 12.00, '/static/images/8_JuicyDumpling_Dish.jpg'),
(9, 9, 'Grilled Lamb Skewers', 'What you''re grilling isn''t just meat — it''s your bad mood.', 'Charred, cumin-spiced lamb skewers that are satisfying to chew — perfect for releasing built-up stress.', 3, 22.00, '/static/images/9_KungFuBeefChineseBBQ_Dish.jpg'),
(10, 10, 'Braised Pork Rice (Lu Rou Fan)', 'When life feels uncertain, trust a bowl of lu rou fan.', 'Soy-braised pork over rice with pickles and a soy egg — a reliable and familiar comfort for anxious days.', 4, 14.00, '/static/images/10_FourFourSouthVillage_Dish.jpg'),
(11, 11, 'HK Milk Tea & Satay Beef Noodles', 'Hide from your worries in a cha chaan teng booth.', 'Creamy milk tea paired with savory satay noodles — flavorful but not overwhelming, perfect for calming the mind.', 4, 18.00, '/static/images/11_HongKongBistroCafe_Dish.jpg'),
(12, 12, 'Chicken Pho', 'Gentle on the stomach, kind to the mind.', 'A clean, comforting chicken broth that''s easy to digest — ideal for stressful days when you need something soft and soothing.', 4, 16.00, '/static/images/12_PhoHung_Dish.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `favourites`
--

CREATE TABLE `favourites` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `dish_id` int(11) DEFAULT NULL,
  `restaurant_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Indexes for dumped tables
--

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `moods`
--
ALTER TABLE `moods`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `restaurants`
--
ALTER TABLE `restaurants`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `restaurant_tags`
--
ALTER TABLE `restaurant_tags`
  ADD PRIMARY KEY (`id`),
  ADD KEY `restaurant_id` (`restaurant_id`);

--
-- Indexes for table `dishes`
--
ALTER TABLE `dishes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `restaurant_id` (`restaurant_id`),
  ADD KEY `mood_id` (`mood_id`);

--
-- Indexes for table `favourites`
--
ALTER TABLE `favourites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `dish_id` (`dish_id`),
  ADD KEY `restaurant_id` (`restaurant_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `moods`
--
ALTER TABLE `moods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `restaurants`
--
ALTER TABLE `restaurants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `restaurant_tags`
--
ALTER TABLE `restaurant_tags`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `dishes`
--
ALTER TABLE `dishes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `favourites`
--
ALTER TABLE `favourites`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `restaurant_tags`
--
ALTER TABLE `restaurant_tags`
  ADD CONSTRAINT `restaurant_tags_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `dishes`
--
ALTER TABLE `dishes`
  ADD CONSTRAINT `dishes_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `dishes_ibfk_2` FOREIGN KEY (`mood_id`) REFERENCES `moods` (`id`);

--
-- Constraints for table `favourites`
--
ALTER TABLE `favourites`
  ADD CONSTRAINT `favourites_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `favourites_ibfk_2` FOREIGN KEY (`dish_id`) REFERENCES `dishes` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `favourites_ibfk_3` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
