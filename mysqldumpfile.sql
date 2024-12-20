-- MySQL dump 10.13  Distrib 8.4.3, for Linux (x86_64)
--
-- Host: localhost    Database: resta
-- ------------------------------------------------------
-- Server version	8.4.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Predictions`
--

DROP TABLE IF EXISTS `Predictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Predictions` (
  `restaurant_id` int NOT NULL,
  `dish_id` int NOT NULL,
  `predicted_sales` int NOT NULL,
  PRIMARY KEY (`restaurant_id`,`dish_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Predictions`
--

LOCK TABLES `Predictions` WRITE;
/*!40000 ALTER TABLE `Predictions` DISABLE KEYS */;
INSERT INTO `Predictions` VALUES (1,1,278),(1,2,163),(1,3,130),(1,4,137),(1,5,95),(1,6,116),(1,7,147),(1,8,85),(1,9,102),(1,10,116),(1,11,79),(1,13,69),(1,14,111),(1,15,116),(1,16,131),(1,17,147),(1,18,117),(1,19,106),(1,20,100),(1,21,90),(2,1,140),(2,2,115),(2,3,197),(2,4,159),(2,5,154),(2,6,101),(2,7,83),(2,8,169),(2,9,168),(2,10,153),(2,11,97),(2,13,90),(2,14,109),(2,15,128),(2,16,136),(2,17,112),(2,18,174),(2,19,86),(2,20,211),(2,21,166),(3,1,117),(3,2,78),(3,3,159),(3,4,54),(3,5,190),(3,6,55),(3,7,57),(3,8,53),(3,9,85),(3,10,87),(3,11,162),(3,13,139),(3,14,168),(3,15,110),(3,16,130),(3,17,134),(3,18,190),(3,19,134),(3,20,202),(3,21,181);
/*!40000 ALTER TABLE `Predictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Restaurant`
--

DROP TABLE IF EXISTS `Restaurant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Restaurant` (
  `restaurant_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `Messages` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`restaurant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Restaurant`
--

LOCK TABLES `Restaurant` WRITE;
/*!40000 ALTER TABLE `Restaurant` DISABLE KEYS */;
INSERT INTO `Restaurant` VALUES (1,'McDonalds','Hebbal',NULL),(2,'McDonalds','HSR','80.00 units of ingredient 5 needed by Restaurant ID 1'),(3,'McDonalds','Koramangala','80.00 units of ingredient 5 needed by Restaurant ID 1');
/*!40000 ALTER TABLE `Restaurant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Restaurant_Ingredients`
--

DROP TABLE IF EXISTS `Restaurant_Ingredients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Restaurant_Ingredients` (
  `restaurant_id` int NOT NULL,
  `ingredient_id` int NOT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`restaurant_id`,`ingredient_id`),
  KEY `ingredient_id` (`ingredient_id`),
  CONSTRAINT `Restaurant_Ingredients_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `Restaurant` (`restaurant_id`),
  CONSTRAINT `Restaurant_Ingredients_ibfk_2` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredient` (`ingredient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Restaurant_Ingredients`
--

LOCK TABLES `Restaurant_Ingredients` WRITE;
/*!40000 ALTER TABLE `Restaurant_Ingredients` DISABLE KEYS */;
INSERT INTO `Restaurant_Ingredients` VALUES (1,1,465),(1,2,410),(1,3,200),(1,4,500),(1,5,0),(1,6,305),(1,7,325),(1,8,260),(1,9,360),(1,10,305),(1,11,500),(1,12,500),(1,13,470),(1,14,350),(1,15,350),(1,16,500),(1,17,500),(1,18,500),(1,19,500),(1,20,500),(2,1,500),(2,2,500),(2,3,440),(2,4,500),(2,5,200),(2,6,500),(2,7,500),(2,8,500),(2,9,500),(2,10,500),(2,11,500),(2,12,500),(2,13,500),(2,14,500),(2,15,500),(2,16,500),(2,17,500),(2,18,500),(2,19,500),(2,20,500),(3,1,500),(3,2,500),(3,3,500),(3,4,500),(3,5,500),(3,6,500),(3,7,500),(3,8,500),(3,9,500),(3,10,500),(3,11,500),(3,12,500),(3,13,500),(3,14,500),(3,15,500),(3,16,500),(3,17,500),(3,18,500),(3,19,500),(3,20,500);
/*!40000 ALTER TABLE `Restaurant_Ingredients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Sales`
--

DROP TABLE IF EXISTS `Sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Sales` (
  `restaurant_id` int NOT NULL,
  `dish_id` int NOT NULL,
  `sales_count` int DEFAULT '0',
  `rating` int DEFAULT NULL,
  PRIMARY KEY (`restaurant_id`,`dish_id`),
  KEY `dish_id` (`dish_id`),
  CONSTRAINT `Sales_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `Restaurant` (`restaurant_id`),
  CONSTRAINT `Sales_ibfk_2` FOREIGN KEY (`dish_id`) REFERENCES `dish` (`Dish_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sales`
--

LOCK TABLES `Sales` WRITE;
/*!40000 ALTER TABLE `Sales` DISABLE KEYS */;
INSERT INTO `Sales` VALUES (1,1,262,5),(1,2,153,4),(1,3,123,4),(1,4,130,4),(1,5,90,5),(1,6,110,4),(1,7,140,4),(1,8,80,4),(1,9,97,5),(1,10,110,4),(1,11,75,4),(1,13,65,4),(1,14,105,4),(1,15,110,5),(1,16,125,4),(1,17,140,4),(1,18,111,4),(1,19,100,4),(1,20,95,5),(1,21,86,4),(2,1,131,4),(2,2,107,3),(2,3,183,4),(2,4,148,3),(2,5,143,5),(2,6,94,4),(2,7,77,3),(2,8,158,4),(2,9,157,3),(2,10,142,4),(2,11,90,5),(2,13,84,4),(2,14,101,4),(2,15,119,4),(2,16,126,4),(2,17,104,5),(2,18,162,3),(2,19,80,3),(2,20,196,5),(2,21,154,5),(3,1,111,5),(3,2,74,5),(3,3,151,5),(3,4,52,3),(3,5,181,4),(3,6,53,3),(3,7,55,4),(3,8,51,4),(3,9,81,4),(3,10,83,4),(3,11,154,4),(3,13,132,4),(3,14,160,3),(3,15,105,5),(3,16,124,4),(3,17,128,3),(3,18,180,5),(3,19,128,4),(3,20,193,4),(3,21,173,3);
/*!40000 ALTER TABLE `Sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dish`
--

DROP TABLE IF EXISTS `dish`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dish` (
  `Dish_ID` int NOT NULL AUTO_INCREMENT,
  `dish_name` varchar(255) DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Dish_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dish`
--

LOCK TABLES `dish` WRITE;
/*!40000 ALTER TABLE `dish` DISABLE KEYS */;
INSERT INTO `dish` VALUES (1,'McAloo Tikki Burger','50.00'),(2,'Chicken Maharaja Mac','120.00'),(3,'McSpicy Paneer Burger','100.00'),(4,'McSpicy Chicken Wrap','150.00'),(5,'Filet-O-Fish','130.00'),(6,'Chicken Kebab Burger','110.00'),(7,'Veg Maharaja Mac','120.00'),(8,'Masala Wedges','70.00'),(9,'Chicken McWings','90.00'),(10,'Fries','60.00'),(11,'Veg Pizza McPuff','40.00'),(13,'Hashbrown','30.00'),(14,'Chatpata Naan','50.00'),(15,'McFlurry (Oreo)','100.00'),(16,'Choco Hazelnut Shake','120.00'),(17,'Soft Serve Cone','25.00'),(18,'Strawberry Shake','90.00'),(19,'Coke Float','80.00'),(20,'Mango Smoothie','95.00'),(21,'Hot Chocolate Fudge','110.00');
/*!40000 ALTER TABLE `dish` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dish_ingredient`
--

DROP TABLE IF EXISTS `dish_ingredient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dish_ingredient` (
  `Dish_id` int NOT NULL,
  `ingredient_id` int NOT NULL,
  `quantity_required` decimal(10,2) NOT NULL,
  PRIMARY KEY (`Dish_id`,`ingredient_id`),
  KEY `ingredient_id` (`ingredient_id`),
  CONSTRAINT `dish_ingredient_ibfk_1` FOREIGN KEY (`Dish_id`) REFERENCES `dish` (`Dish_ID`) ON DELETE CASCADE,
  CONSTRAINT `dish_ingredient_ibfk_2` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredient` (`ingredient_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dish_ingredient`
--

LOCK TABLES `dish_ingredient` WRITE;
/*!40000 ALTER TABLE `dish_ingredient` DISABLE KEYS */;
INSERT INTO `dish_ingredient` VALUES (1,1,2.00),(1,5,80.00),(1,6,10.00),(1,7,10.00),(1,8,15.00),(1,10,10.00),(2,1,3.00),(2,3,120.00),(2,6,20.00),(2,7,15.00),(2,8,20.00),(2,9,40.00),(2,10,20.00),(2,13,10.00),(3,1,2.00),(3,2,90.00),(3,6,15.00),(3,7,10.00),(3,9,20.00),(3,10,15.00),(4,3,80.00),(4,6,15.00),(4,8,15.00),(4,10,15.00),(5,1,2.00),(5,4,80.00),(5,9,20.00),(5,13,10.00),(6,1,2.00),(6,3,80.00),(6,6,10.00),(6,7,10.00),(6,10,15.00),(7,1,3.00),(7,2,90.00),(7,6,20.00),(7,7,15.00),(7,8,20.00),(7,9,40.00),(7,10,20.00),(7,13,10.00),(8,11,10.00),(8,17,120.00),(8,18,20.00),(9,18,20.00),(9,19,120.00),(10,12,10.00),(10,17,120.00),(10,18,20.00),(11,11,5.00),(11,20,60.00),(11,21,40.00),(11,22,30.00),(13,17,80.00),(13,18,20.00),(14,11,10.00),(14,23,70.00),(14,24,5.00),(15,14,100.00),(15,15,150.00),(15,25,25.00),(16,14,150.00),(16,15,150.00),(16,16,20.00),(17,15,100.00),(18,14,150.00),(18,15,150.00),(18,26,20.00),(19,15,100.00),(19,28,200.00),(20,14,100.00),(20,15,100.00),(20,27,100.00),(21,14,150.00),(21,15,100.00),(21,16,25.00);
/*!40000 ALTER TABLE `dish_ingredient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingredient`
--

DROP TABLE IF EXISTS `ingredient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingredient` (
  `ingredient_id` int NOT NULL AUTO_INCREMENT,
  `ingredient_name` varchar(255) NOT NULL,
  `expiry_days` int DEFAULT NULL,
  `restock_threshold` int NOT NULL,
  PRIMARY KEY (`ingredient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredient`
--

LOCK TABLES `ingredient` WRITE;
/*!40000 ALTER TABLE `ingredient` DISABLE KEYS */;
INSERT INTO `ingredient` VALUES (1,'Sesame-Seeded Buns',7,10),(2,'Paneer (Cottage Cheese)',5,5),(3,'Chicken Patties',10,10),(4,'Fish Patties',7,8),(5,'Potato Patties',10,10),(6,'Lettuce',5,20),(7,'Onions',15,15),(8,'Tomatoes',7,10),(9,'Cheddar or Processed Cheese',15,15),(10,'Mayonnaise (Regular or Spiced)',30,20),(11,'Indian Spice Mixes (Masala)',90,10),(12,'Piri-Piri Spice',90,5),(13,'Mustard',60,10),(14,'Milk',5,25),(15,'Ice Cream Base',30,15),(16,'Cocoa Powder',365,10),(17,'Potatoes',30,30),(18,'Cooking Oils',180,25),(19,'Chicken Wings',7,7),(20,'Pastry Shell',10,10),(21,'Potato Filling',5,5),(22,'Mixed Vegetables',7,15),(23,'Naan Base',7,10),(24,'Butter',30,10),(25,'Crushed Oreo',90,20),(26,'Strawberry Syrup',60,10),(27,'Mango Puree',30,10),(28,'Coca-Cola',365,20);
/*!40000 ALTER TABLE `ingredient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_name` varchar(100) NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_item`
--

DROP TABLE IF EXISTS `menu_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `price` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_item`
--

LOCK TABLES `menu_item` WRITE;
/*!40000 ALTER TABLE `menu_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `menu_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order`
--

DROP TABLE IF EXISTS `order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dish_name` varchar(100) NOT NULL,
  `total_price` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order`
--

LOCK TABLES `order` WRITE;
/*!40000 ALTER TABLE `order` DISABLE KEYS */;
/*!40000 ALTER TABLE `order` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-20 21:34:48
