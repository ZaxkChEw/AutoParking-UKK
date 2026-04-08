-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Apr 08, 2026 at 11:21 AM
-- Server version: 8.4.3
-- PHP Version: 8.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `parkir`
--

-- --------------------------------------------------------

--
-- Table structure for table `area_parkir`
--

CREATE TABLE `area_parkir` (
  `kd_area` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_area` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `kapasitas` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `area_parkir`
--

INSERT INTO `area_parkir` (`kd_area`, `nama_area`, `kapasitas`) VALUES
('BSP', 'KOL', 50),
('LKW', 'DOR', 50),
('SPD', 'VFT', 30),
('TXS', 'WEW', 50);

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 3, 'add_permission'),
(6, 'Can change permission', 3, 'change_permission'),
(7, 'Can delete permission', 3, 'delete_permission'),
(8, 'Can view permission', 3, 'view_permission'),
(9, 'Can add group', 2, 'add_group'),
(10, 'Can change group', 2, 'change_group'),
(11, 'Can delete group', 2, 'delete_group'),
(12, 'Can view group', 2, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add user', 9, 'add_user'),
(26, 'Can change user', 9, 'change_user'),
(27, 'Can delete user', 9, 'delete_user'),
(28, 'Can view user', 9, 'view_user'),
(29, 'Can add area parkir', 7, 'add_areaparkir'),
(30, 'Can change area parkir', 7, 'change_areaparkir'),
(31, 'Can delete area parkir', 7, 'delete_areaparkir'),
(32, 'Can view area parkir', 7, 'view_areaparkir'),
(33, 'Can add transaksi parkir', 8, 'add_transaksiparkir'),
(34, 'Can change transaksi parkir', 8, 'change_transaksiparkir'),
(35, 'Can delete transaksi parkir', 8, 'delete_transaksiparkir'),
(36, 'Can view transaksi parkir', 8, 'view_transaksiparkir'),
(37, 'Can add parking session', 10, 'add_parkingsession'),
(38, 'Can change parking session', 10, 'change_parkingsession'),
(39, 'Can delete parking session', 10, 'delete_parkingsession'),
(40, 'Can view parking session', 10, 'view_parkingsession'),
(41, 'Can add struk queue', 11, 'add_strukqueue'),
(42, 'Can change struk queue', 11, 'change_strukqueue'),
(43, 'Can delete struk queue', 11, 'delete_strukqueue'),
(44, 'Can view struk queue', 11, 'view_strukqueue');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint UNSIGNED NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(2, 'auth', 'group'),
(3, 'auth', 'permission'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(7, 'parkir', 'areaparkir'),
(10, 'parkir', 'parkingsession'),
(11, 'parkir', 'strukqueue'),
(8, 'parkir', 'transaksiparkir'),
(9, 'parkir', 'user'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2026-02-12 01:31:53.274886'),
(2, 'auth', '0001_initial', '2026-02-12 01:31:58.222521'),
(3, 'admin', '0001_initial', '2026-02-12 01:31:59.019278'),
(4, 'admin', '0002_logentry_remove_auto_add', '2026-02-12 01:31:59.034904'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2026-02-12 01:31:59.050524'),
(6, 'contenttypes', '0002_remove_content_type_name', '2026-02-12 01:31:59.566264'),
(7, 'auth', '0002_alter_permission_name_max_length', '2026-02-12 01:31:59.753645'),
(8, 'auth', '0003_alter_user_email_max_length', '2026-02-12 01:31:59.922418'),
(9, 'auth', '0004_alter_user_username_opts', '2026-02-12 01:31:59.937929'),
(10, 'auth', '0005_alter_user_last_login_null', '2026-02-12 01:32:00.109901'),
(11, 'auth', '0006_require_contenttypes_0002', '2026-02-12 01:32:00.125432'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2026-02-12 01:32:00.141052'),
(13, 'auth', '0008_alter_user_username_max_length', '2026-02-12 01:32:00.359797'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2026-02-12 01:32:00.609804'),
(15, 'auth', '0010_alter_group_name_max_length', '2026-02-12 01:32:00.656672'),
(16, 'auth', '0011_update_proxy_permissions', '2026-02-12 01:32:00.672299'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2026-02-12 01:32:00.875469'),
(18, 'sessions', '0001_initial', '2026-02-12 01:32:01.020951'),
(19, 'parkir', '0001_initial', '2026-03-10 21:48:35.043449'),
(20, 'parkir', '0002_strukqueue_alter_transaksiparkir_kd_transaksi_and_more', '2026-03-18 00:47:40.085469');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('4t0lgcapqhkuakrdbj7efm1vqdpwnoht', 'eyJ1c2VybmFtZSI6ImVyaWsxIiwibGV2ZWwiOiJwZXR1Z2FzIn0:1vzuaR:bemDatIDK39hi0APtP9CKB58VdpXUY_QOgpMofG-FmY', '2026-03-24 10:45:15.097742'),
('mp3l7td5oql21t42ye37e4pm90tn97ry', 'eyJ1c2VybmFtZSI6ImVyaWsxIiwibGV2ZWwiOiJwZXR1Z2FzIn0:1vv3QQ:QLHGG_RXQ32JtgVI_ml2auJcSV-vw8FbeJb2CjLNWrs', '2026-03-11 01:10:50.062878');

-- --------------------------------------------------------

--
-- Table structure for table `struk_queue`
--

CREATE TABLE `struk_queue` (
  `id` bigint NOT NULL,
  `kd_transaksi` varchar(10) NOT NULL,
  `struk` longtext NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `sudah_diambil` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `struk_queue`
--

INSERT INTO `struk_queue` (`id`, `kd_transaksi`, `struk`, `created_at`, `sudah_diambil`) VALUES
(1, 'TEST1', 'ini struk test', '2026-03-18 00:59:06.648706', 1),
(2, 'TEST1', 'ini struk test', '2026-03-18 01:00:29.805905', 1),
(3, 'TEST1', 'ini struk test', '2026-03-18 01:15:34.271425', 1),
(4, 'N32', 'STRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : N32\nID Transaksi    : 0nfLw3GY\nID Card         : RFID_FED0536\nArea Parkir     : KOL\nMasuk           : 2026-03-18 00:34:46\nKeluar          : 2026-03-18 01:17:53\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-03-18 01:17:54.479710', 1),
(5, 'N32', 'STRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : N32\nID Transaksi    : 0nfLw3GY\nID Card         : RFID_FED0536\nArea Parkir     : KOL\nMasuk           : 2026-03-18 00:34:46\nKeluar          : 2026-03-18 01:17:53\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-03-18 01:17:54.479809', 1),
(6, 'T54', 'STRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : T54\nID Transaksi    : e2RZQq1T\nID Card         : RFID_SHJ9317\nArea Parkir     : KOL\nMasuk           : 2026-03-18 00:22:53\nKeluar          : 2026-03-18 01:20:01\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-03-18 01:20:02.289596', 1),
(7, 'T54', 'STRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : T54\nID Transaksi    : e2RZQq1T\nID Card         : RFID_SHJ9317\nArea Parkir     : KOL\nMasuk           : 2026-03-18 00:22:53\nKeluar          : 2026-03-18 01:20:01\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-03-18 01:20:02.299551', 1),
(8, 'J51', 'STRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : J51\nID Transaksi    : zud6lZiz\nID Card         : RFID_PRW3507\nArea Parkir     : KOL\nMasuk           : 2026-03-18 00:35:00\nKeluar          : 2026-03-18 01:20:52\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-03-18 01:20:53.310247', 1),
(9, 'J51', 'STRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : J51\nID Transaksi    : zud6lZiz\nID Card         : RFID_PRW3507\nArea Parkir     : KOL\nMasuk           : 2026-03-18 00:35:00\nKeluar          : 2026-03-18 01:20:52\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-03-18 01:20:53.336774', 1),
(10, 'T53', 'STRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : T53\nID Transaksi    : 79Ao2XmL\nID Card         : RFID_GBB6749\nArea Parkir     : KOL\nMasuk           : 2026-03-18 00:34:26\nKeluar          : 2026-03-18 01:21:51\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-03-18 01:21:51.808073', 1),
(11, 'T53', 'STRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : T53\nID Transaksi    : 79Ao2XmL\nID Card         : RFID_GBB6749\nArea Parkir     : KOL\nMasuk           : 2026-03-18 00:34:26\nKeluar          : 2026-03-18 01:21:51\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-03-18 01:21:51.808003', 1),
(12, 'Q43', 'STRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : Q43\nID Transaksi    : kFFjVwMy\nID Card         : RFID_YXW9216\nArea Parkir     : KOL\nMasuk           : 2026-03-18 00:17:49\nKeluar          : 2026-03-18 01:33:40\nLama Parkir     : 2 jam\nBiaya Parkir    : Rp 4.000\n---------------------------------------------\n', '2026-03-18 01:33:40.605697', 1),
(13, 'Q43', 'STRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : Q43\nID Transaksi    : kFFjVwMy\nID Card         : RFID_YXW9216\nArea Parkir     : KOL\nMasuk           : 2026-03-18 00:17:49\nKeluar          : 2026-03-18 01:33:40\nLama Parkir     : 2 jam\nBiaya Parkir    : Rp 4.000\n---------------------------------------------\n', '2026-03-18 01:33:40.687407', 1),
(14, 'M67', 'STRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : M67\nID Transaksi    : ti4CQQtq\nID Card         : RFID_IJE0264\nArea Parkir     : KOL\nMasuk           : 2026-03-18 01:30:09\nKeluar          : 2026-03-18 01:37:54\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-03-18 01:37:55.259499', 1),
(15, 'M67', 'STRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : M67\nID Transaksi    : ti4CQQtq\nID Card         : RFID_IJE0264\nArea Parkir     : KOL\nMasuk           : 2026-03-18 01:30:09\nKeluar          : 2026-03-18 01:37:54\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-03-18 01:37:55.447257', 1),
(16, 'W31', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : W31\nID Transaksi    : vqP6lLny\nID Card         : 36100207\nArea Parkir     : KOL\nMasuk           : 2026-04-02 04:30:22\nKeluar          : 2026-04-02 04:30:35\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 04:30:37.379875', 1),
(17, 'N49', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : N49\nID Transaksi    : ssmGgoTv\nID Card         : E9BF6806\nArea Parkir     : KOL\nMasuk           : 2026-04-02 04:32:13\nKeluar          : 2026-04-02 04:32:28\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 04:32:28.910511', 1),
(18, 'N49', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : N49\nID Transaksi    : ssmGgoTv\nID Card         : E9BF6806\nArea Parkir     : KOL\nMasuk           : 2026-04-02 04:32:13\nKeluar          : 2026-04-02 04:32:28\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 04:32:31.050252', 1),
(19, 'A73', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : A73\nID Transaksi    : fCitHB73\nID Card         : 0E250307\nArea Parkir     : KOL\nMasuk           : 2026-04-02 04:33:55\nKeluar          : 2026-04-02 04:34:09\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 04:34:09.810503', 1),
(20, 'A73', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : A73\nID Transaksi    : fCitHB73\nID Card         : 0E250307\nArea Parkir     : KOL\nMasuk           : 2026-04-02 04:33:55\nKeluar          : 2026-04-02 04:34:09\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 04:34:09.917751', 1),
(21, 'O25', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : O25\nID Transaksi    : 1ZAT7L9v\nID Card         : 36100207\nArea Parkir     : KOL\nMasuk           : 2026-04-02 04:33:40\nKeluar          : 2026-04-02 04:34:20\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 04:34:20.933871', 1),
(22, 'O25', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : O25\nID Transaksi    : 1ZAT7L9v\nID Card         : 36100207\nArea Parkir     : KOL\nMasuk           : 2026-04-02 04:33:40\nKeluar          : 2026-04-02 04:34:20\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 04:34:20.935370', 1),
(23, 'Q26', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : Q26\nID Transaksi    : Ej7Elxcq\nID Card         : 36100207\nArea Parkir     : KOL\nMasuk           : 2026-04-02 04:33:40\nKeluar          : 2026-04-02 04:34:31\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 04:34:31.246720', 1),
(24, 'Q26', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : Q26\nID Transaksi    : Ej7Elxcq\nID Card         : 36100207\nArea Parkir     : KOL\nMasuk           : 2026-04-02 04:33:40\nKeluar          : 2026-04-02 04:34:31\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 04:34:31.327721', 1),
(25, 'S30', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : S30\nID Transaksi    : D5WWWwlR\nID Card         : 0E250307\nArea Parkir     : KOL\nMasuk           : 2026-04-02 04:33:55\nKeluar          : 2026-04-02 04:34:41\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 04:34:41.573943', 1),
(26, 'S30', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : S30\nID Transaksi    : D5WWWwlR\nID Card         : 0E250307\nArea Parkir     : KOL\nMasuk           : 2026-04-02 04:33:55\nKeluar          : 2026-04-02 04:34:41\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 04:34:41.602867', 1),
(27, 'R8', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : R8\nID Transaksi    : AIITEdr0\nID Card         : 0E250307\nArea Parkir     : KOL\nMasuk           : 2026-04-02 04:35:46\nKeluar          : 2026-04-02 04:36:31\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 04:36:32.035824', 1),
(28, 'R8', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : R8\nID Transaksi    : AIITEdr0\nID Card         : 0E250307\nArea Parkir     : KOL\nMasuk           : 2026-04-02 04:35:46\nKeluar          : 2026-04-02 04:36:31\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 04:36:32.035803', 1),
(29, 'Y26', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : Y26\nID Transaksi    : puGGIhHQ\nID Card         : 0E250307\nArea Parkir     : KOL\nMasuk           : 2026-04-02 04:35:46\nKeluar          : 2026-04-02 04:36:46\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 04:36:46.795763', 1),
(30, 'Y26', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : Y26\nID Transaksi    : puGGIhHQ\nID Card         : 0E250307\nArea Parkir     : KOL\nMasuk           : 2026-04-02 04:35:46\nKeluar          : 2026-04-02 04:36:46\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 04:36:46.795761', 1),
(31, 'W6', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : W6\nID Transaksi    : LjIYTLdr\nID Card         : 36100207\nArea Parkir     : KOL\nMasuk           : 2026-04-02 05:35:54\nKeluar          : 2026-04-02 05:36:29\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 05:36:30.051643', 1),
(32, 'G41', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : G41\nID Transaksi    : AAWZ8OVP\nID Card         : 53063956\nArea Parkir     : KOL\nMasuk           : 2026-04-02 05:37:01\nKeluar          : 2026-04-02 05:37:12\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 05:37:12.823528', 1),
(33, 'D93', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : D93\nID Transaksi    : 26kOn39H\nID Card         : 53063956\nArea Parkir     : KOL\nMasuk           : 2026-04-02 05:39:32\nKeluar          : 2026-04-02 05:39:48\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 05:39:48.267062', 1),
(34, 'N67', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : N67\nID Transaksi    : ITc2aFcj\nID Card         : 53063956\nArea Parkir     : KOL\nMasuk           : 2026-04-02 05:41:18\nKeluar          : 2026-04-02 05:41:27\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 05:41:27.341094', 1),
(35, 'L89', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : L89\nID Transaksi    : 71kC1XwH\nID Card         : FEA66A06\nArea Parkir     : KOL\nMasuk           : 2026-04-02 05:36:12\nKeluar          : 2026-04-02 06:01:51\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 06:01:52.461393', 1),
(36, 'Q47', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : Q47\nID Transaksi    : 3DdYqlch\nID Card         : 53063956\nArea Parkir     : KOL\nMasuk           : 2026-04-02 06:03:42\nKeluar          : 2026-04-02 06:03:57\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 06:03:57.618204', 1),
(37, 'K52', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : K52\nID Transaksi    : wTo5HxPV\nID Card         : 53063956\nArea Parkir     : KOL\nMasuk           : 2026-04-02 06:09:02\nKeluar          : 2026-04-02 06:09:16\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 06:09:16.427213', 1),
(38, 'V87', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : V87\nID Transaksi    : p0wfmfHg\nID Card         : 36100207\nArea Parkir     : KOL\nMasuk           : 2026-04-02 06:10:45\nKeluar          : 2026-04-02 06:10:54\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 06:10:54.780491', 1),
(39, 'B42', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : B42\nID Transaksi    : oryXPMtd\nID Card         : 53063956\nArea Parkir     : KOL\nMasuk           : 2026-04-02 06:10:27\nKeluar          : 2026-04-02 06:11:12\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 06:11:12.227778', 1),
(40, 'O88', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : O88\nID Transaksi    : gfW72qsz\nID Card         : FEA66A06\nArea Parkir     : KOL\nMasuk           : 2026-04-02 06:10:36\nKeluar          : 2026-04-02 06:11:20\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 06:11:20.564627', 1),
(41, 'X59', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : X59\nID Transaksi    : mpQRe2HA\nID Card         : 36100207\nArea Parkir     : KOL\nMasuk           : 2026-04-02 06:15:49\nKeluar          : 2026-04-02 06:16:03\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-02 06:16:03.743307', 1),
(42, 'B38', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : B38\nID Transaksi    : V5HnS3lI\nID Card         : 36100207\nArea Parkir     : KOL\nMasuk           : 2026-04-02 06:16:39\nKeluar          : 2026-04-08 11:55:14\nLama Parkir     : 150 jam\nBiaya Parkir    : Rp 300.000\n---------------------------------------------\n', '2026-04-08 11:55:15.542822', 1),
(43, 'Q93', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : Q93\nID Transaksi    : lId8EEnP\nID Card         : 36100207\nArea Parkir     : KOL\nMasuk           : 2026-04-08 11:56:24\nKeluar          : 2026-04-08 11:56:32\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-08 11:56:32.989557', 1),
(44, 'S4', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : S4\nID Transaksi    : EYt8WWFD\nID Card         : 36100207\nArea Parkir     : KOL\nMasuk           : 2026-04-08 12:33:23\nKeluar          : 2026-04-08 12:33:52\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-08 12:33:52.739853', 1),
(45, 'S4', '\nSTRUK AUTOPARKING\n---------------------------------------------\nKode Transaksi  : S4\nID Transaksi    : EYt8WWFD\nID Card         : 36100207\nArea Parkir     : KOL\nMasuk           : 2026-04-08 12:33:23\nKeluar          : 2026-04-08 12:36:09\nLama Parkir     : 1 jam\nBiaya Parkir    : Rp 2.000\n---------------------------------------------\n', '2026-04-08 12:36:09.574780', 1);

-- --------------------------------------------------------

--
-- Table structure for table `transaksi_parkir`
--

CREATE TABLE `transaksi_parkir` (
  `kd_transaksi` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `waktu_masuk` datetime NOT NULL,
  `waktu_keluar` datetime DEFAULT NULL,
  `biaya` int DEFAULT NULL,
  `jenis_kendaraan` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `kd_area` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '''IN'', ''OUT'', ''DONE''',
  `id_transaksi` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `noPlat` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `card_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transaksi_parkir`
--

INSERT INTO `transaksi_parkir` (`kd_transaksi`, `waktu_masuk`, `waktu_keluar`, `biaya`, `jenis_kendaraan`, `kd_area`, `status`, `id_transaksi`, `noPlat`, `card_id`) VALUES
('B38', '2026-04-02 06:16:39', '2026-04-08 11:55:14', 300000, 'Motor', 'BSP', 'DONE', 'V5HnS3lI', 'T 9235 TS', '36100207'),
('B42', '2026-04-02 06:10:27', '2026-04-02 06:11:12', 2000, 'Motor', 'BSP', 'DONE', 'oryXPMtd', 'I 9601 JG', '53063956'),
('C50', '2026-03-17 23:41:13', '2026-03-17 23:46:47', 2000, 'Motor', 'BSP', 'DONE', 'RjA4aKK0', 'E 9098 DF', 'RFID_BQP9264'),
('D93', '2026-04-02 05:39:32', '2026-04-02 05:39:48', 2000, 'Motor', 'BSP', 'DONE', '26kOn39H', 'C 1742 PM', '53063956'),
('F27', '2026-03-17 23:52:41', '2026-03-18 00:06:21', 2000, 'Motor', 'BSP', 'DONE', 'mtuxxRHp', 'G 6959 WH', 'RFID_LZE3750'),
('G41', '2026-04-02 05:37:01', '2026-04-02 05:37:12', 2000, 'Motor', 'BSP', 'DONE', 'AAWZ8OVP', 'R 2819 QV', '53063956'),
('K37', '2026-03-17 23:52:57', '2026-03-18 00:24:33', 2000, 'Motor', 'BSP', 'DONE', 'zDlIVhWZ', 'F 4616 ME', 'RFID_RGM7591'),
('K52', '2026-04-02 06:09:02', '2026-04-02 06:09:16', 2000, 'Motor', 'BSP', 'DONE', 'wTo5HxPV', 'C 721 JG', '53063956'),
('L89', '2026-04-02 05:36:12', '2026-04-02 06:01:52', 2000, 'Motor', 'BSP', 'DONE', '71kC1XwH', 'D 8483 XP', 'FEA66A06'),
('M72', '2026-03-18 00:23:39', '2026-03-18 00:55:29', 2000, 'Motor', 'BSP', 'DONE', 'fv5Xys5N', 'C 5589 LE', 'RFID_KTM6295'),
('N67', '2026-04-02 05:41:18', '2026-04-02 05:41:27', 2000, 'Motor', 'BSP', 'DONE', 'ITc2aFcj', 'F 6084 TR', '53063956'),
('O88', '2026-04-02 06:10:36', '2026-04-02 06:11:20', 2000, 'Motor', 'BSP', 'DONE', 'gfW72qsz', 'M 7627 SK', 'FEA66A06'),
('Q47', '2026-04-02 06:03:42', '2026-04-02 06:03:58', 2000, 'Motor', 'BSP', 'DONE', '3DdYqlch', 'M 206 VF', '53063956'),
('Q93', '2026-04-08 11:56:24', '2026-04-08 11:56:33', 2000, 'Motor', 'BSP', 'DONE', 'lId8EEnP', 'K 7619 BN', '36100207'),
('S4', '2026-04-08 12:33:23', '2026-04-08 12:36:09', 2000, 'Motor', 'BSP', 'OUT', 'EYt8WWFD', 'R 3938 IL', '36100207'),
('U98', '2026-03-17 23:43:43', '2026-03-18 00:21:12', 2000, 'Motor', 'BSP', 'DONE', 'L1afA1MC', 'J 8069 VK', 'RFID_JZP2854'),
('V87', '2026-04-02 06:10:45', '2026-04-02 06:10:55', 2000, 'Motor', 'BSP', 'DONE', 'p0wfmfHg', 'I 356 FN', '36100207'),
('W6', '2026-04-02 05:35:54', '2026-04-02 05:36:30', 2000, 'Motor', 'BSP', 'DONE', 'LjIYTLdr', 'W 4785 VX', '36100207'),
('X59', '2026-04-02 06:15:49', '2026-04-02 06:16:04', 2000, 'Motor', 'BSP', 'DONE', 'mpQRe2HA', 'D 1121 PA', '36100207'),
('Z17', '2026-04-02 06:13:32', NULL, 0, 'Motor', 'BSP', 'IN', 'h2q4EPH0', 'A 6514 JW', 'FEA66A06');

--
-- Triggers `transaksi_parkir`
--
DELIMITER $$
CREATE TRIGGER `kurangi_kapasitas` AFTER INSERT ON `transaksi_parkir` FOR EACH ROW BEGIN
    IF NEW.status = 'masuk' THEN
        UPDATE area_parkir
        SET kapasitas = GREATEST(kapasitas - 1, 0)  -- Kurangi 1, tapi tidak kurang dari 0
        WHERE kd_area = NEW.kd_area;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tambah_kapasitas` AFTER UPDATE ON `transaksi_parkir` FOR EACH ROW BEGIN
    IF OLD.status = 'keluar' AND NEW.status = 'done' THEN
        UPDATE area_parkir
        SET kapasitas = kapasitas + 1
        WHERE kd_area = NEW.kd_area;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int NOT NULL,
  `namaLengkap` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '''petugas'''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `namaLengkap`, `username`, `password`, `level`) VALUES
(1, 'erik', 'erik1', 'f12537e9605b2b1bf3122bb12a0e24f7', 'petugas'),
(2, 'fred', 'fred2', '77064f5bd13e417f564e7d880dc7a536', 'petugas'),
(3, 'rex', 'rex3', '69e16d5e9c5cfa291bc52dd0732a5cec', 'admin'),
(4, 'max', 'max4', 'd1696816bc1a7afe92f1c8787ac222c3', 'admin'),
(8, 'gege', 'gege5', '829afc47bd44402b0581011d1602c1fc', 'owner'),
(10, 'pol7', 'pol7', '7c8843a8c304bb888a8e7770356b0ed5', 'owner');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `area_parkir`
--
ALTER TABLE `area_parkir`
  ADD PRIMARY KEY (`kd_area`);

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- Indexes for table `struk_queue`
--
ALTER TABLE `struk_queue`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transaksi_parkir`
--
ALTER TABLE `transaksi_parkir`
  ADD PRIMARY KEY (`kd_transaksi`),
  ADD KEY `kd_area` (`kd_area`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `struk_queue`
--
ALTER TABLE `struk_queue`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `transaksi_parkir`
--
ALTER TABLE `transaksi_parkir`
  ADD CONSTRAINT `transaksi_parkir_ibfk_1` FOREIGN KEY (`kd_area`) REFERENCES `area_parkir` (`kd_area`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
