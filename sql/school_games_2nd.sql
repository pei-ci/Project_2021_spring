-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- 主機： 127.0.0.1
-- 產生時間： 2021-03-31 13:13:06
-- 伺服器版本： 10.4.17-MariaDB
-- PHP 版本： 8.0.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `school_games_2nd`
--

-- --------------------------------------------------------

--
-- 資料表結構 `activity`
--

CREATE TABLE `activity` (
  `no` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `title` text NOT NULL,
  `number` text NOT NULL,
  `point` int(11) NOT NULL,
  `time` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `log`
--

CREATE TABLE `log` (
  `userid` int(11) NOT NULL,
  `login_time` text NOT NULL DEFAULT '0000000000',
  `login_count` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 資料表結構 `map`
--

CREATE TABLE `map` (
  `userid` int(11) NOT NULL,
  `unused1` int(11) NOT NULL DEFAULT 0,
  `unused2` int(11) NOT NULL DEFAULT 0,
  `unused3` int(11) NOT NULL DEFAULT 0,
  `unused4` int(11) NOT NULL DEFAULT 0,
  `unused5` int(11) NOT NULL DEFAULT 0,
  `unused6` int(11) NOT NULL DEFAULT 0,
  `used` int(11) NOT NULL DEFAULT 0,
  `pos` text NOT NULL DEFAULT '',
  `val` text NOT NULL DEFAULT '',
  `emergency_finish` int(11) NOT NULL DEFAULT 0,
  `emergency_best` int(11) NOT NULL DEFAULT 0,
  `emergency_time` text NOT NULL DEFAULT '00000000000',
  `emergency_list` text NOT NULL DEFAULT '0000000000000000000000000000',
  `place_click` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `team`
--

CREATE TABLE `team` (
  `teamid` int(11) NOT NULL,
  `name` text NOT NULL,
  `members` int(11) NOT NULL DEFAULT 1,
  `mem1` int(11) NOT NULL,
  `mem2` int(11) DEFAULT NULL,
  `mem3` int(11) DEFAULT NULL,
  `mem4` int(11) DEFAULT NULL,
  `mem5` int(11) DEFAULT NULL,
  `mem6` int(11) DEFAULT NULL,
  `mem7` int(11) DEFAULT NULL,
  `mem8` int(11) DEFAULT NULL,
  `mem9` int(11) DEFAULT NULL,
  `mem10` int(11) DEFAULT NULL,
  `point` int(11) NOT NULL,
  `rank` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- 資料表結構 `user`
--

CREATE TABLE `user` (
  `userid` int(11) NOT NULL,
  `ban` tinyint(1) NOT NULL DEFAULT 0,
  `name` text NOT NULL,
  `nickname` text NOT NULL DEFAULT '',
  `title` text NOT NULL DEFAULT '000000000000000000000',
  `title_use` int(11) NOT NULL DEFAULT -1,
  `department` int(11) NOT NULL,
  `number` text NOT NULL,
  `password` text NOT NULL,
  `validation` text NOT NULL DEFAULT '0000000000000000000',
  `teamid` int(11) DEFAULT NULL,
  `rank` int(11) NOT NULL DEFAULT -1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `activity`
--
ALTER TABLE `activity`
  ADD PRIMARY KEY (`no`),
  ADD KEY `userid` (`userid`);

--
-- 資料表索引 `log`
--
ALTER TABLE `log`
  ADD PRIMARY KEY (`userid`);

--
-- 資料表索引 `map`
--
ALTER TABLE `map`
  ADD PRIMARY KEY (`userid`);

--
-- 資料表索引 `team`
--
ALTER TABLE `team`
  ADD PRIMARY KEY (`teamid`),
  ADD KEY `mem1` (`mem1`),
  ADD KEY `mem2` (`mem2`),
  ADD KEY `mem3` (`mem3`),
  ADD KEY `mem4` (`mem4`),
  ADD KEY `mem5` (`mem5`),
  ADD KEY `mem6` (`mem6`),
  ADD KEY `mem7` (`mem7`),
  ADD KEY `mem8` (`mem8`),
  ADD KEY `mem9` (`mem9`),
  ADD KEY `mem10` (`mem10`);

--
-- 資料表索引 `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`userid`),
  ADD KEY `teamid` (`teamid`);

--
-- 在傾印的資料表使用自動遞增(AUTO_INCREMENT)
--

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `activity`
--
ALTER TABLE `activity`
  MODIFY `no` int(11) NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `user`
--
ALTER TABLE `user`
  MODIFY `userid` int(11) NOT NULL AUTO_INCREMENT;

--
-- 已傾印資料表的限制式
--

--
-- 資料表的限制式 `activity`
--
ALTER TABLE `activity`
  ADD CONSTRAINT `activity_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 資料表的限制式 `log`
--
ALTER TABLE `log`
  ADD CONSTRAINT `log_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 資料表的限制式 `map`
--
ALTER TABLE `map`
  ADD CONSTRAINT `map_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 資料表的限制式 `team`
--
ALTER TABLE `team`
  ADD CONSTRAINT `team_ibfk_1` FOREIGN KEY (`mem3`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `team_ibfk_2` FOREIGN KEY (`mem4`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `team_ibfk_3` FOREIGN KEY (`mem5`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `team_ibfk_4` FOREIGN KEY (`mem6`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `team_ibfk_5` FOREIGN KEY (`mem7`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `team_ibfk_6` FOREIGN KEY (`mem8`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `team_ibfk_7` FOREIGN KEY (`mem9`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `team_ibfk_8` FOREIGN KEY (`mem10`) REFERENCES `user` (`userid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- 資料表的限制式 `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`teamid`) REFERENCES `team` (`teamid`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
