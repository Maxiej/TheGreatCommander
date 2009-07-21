CREATE TABLE `actions` (
  `id` int(11) NOT NULL auto_increment,
  `player_id` int(11) default NULL,
  `action` varchar(255) default NULL,
  `player_unit_id` int(11) default NULL,
  `unit_attacked_id` int(11) default NULL,
  `hp_taken` int(11) default NULL,
  `hp_received` int(11) default NULL,
  `result` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `games` (
  `id` int(11) NOT NULL auto_increment,
  `map_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `password` varchar(255) default NULL,
  `started_at` datetime default NULL,
  `whose_turn` int(11) default NULL,
  `is_finished` tinyint(1) default NULL,
  `security_no` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=63 DEFAULT CHARSET=latin1;

CREATE TABLE `map_terrain_positions` (
  `id` int(11) NOT NULL auto_increment,
  `x` int(11) default NULL,
  `y` int(11) default NULL,
  `map_id` int(11) default NULL,
  `terrain_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3001 DEFAULT CHARSET=latin1;

CREATE TABLE `maps` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `size_x` int(11) default NULL,
  `size_y` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `messages` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `to` varchar(11) default NULL,
  `content` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `is_read` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=45 DEFAULT CHARSET=latin1;

CREATE TABLE `news` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `content` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `publication_date` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `online_players` (
  `id` int(11) NOT NULL auto_increment,
  `player_id` int(11) default NULL,
  `last_time_online` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `last_time_updated` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

CREATE TABLE `player_units` (
  `id` int(11) NOT NULL auto_increment,
  `x` int(11) default NULL,
  `y` int(11) default NULL,
  `unit_id` int(11) default NULL,
  `player_id` int(11) default NULL,
  `hp_left` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `is_turn` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=280 DEFAULT CHARSET=latin1;

CREATE TABLE `players` (
  `id` int(11) NOT NULL auto_increment,
  `game_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `color` varchar(255) default NULL,
  `gold` int(11) default NULL,
  `no_of_mines` int(11) default NULL,
  `online_player_id` int(11) default NULL,
  `is_ready` tinyint(1) default NULL,
  `is_owner` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=102 DEFAULT CHARSET=latin1;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `terrain_properties` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `can_move` tinyint(1) default '1',
  `move_ratio` float default '1',
  `defend_rate` float default NULL,
  `is_mine` tinyint(1) default '0',
  `gold_per_turn` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `terrains` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `short_name` varchar(255) default NULL,
  `image` blob,
  `terrain_property_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;

CREATE TABLE `unit_properties` (
  `id` int(11) NOT NULL auto_increment,
  `strength` int(11) default '1',
  `range_strength` int(11) default '1',
  `range_attack` int(11) default '1',
  `range_move` int(11) default '1',
  `armor` int(11) default '1',
  `price` int(11) default '50',
  `hp` int(11) default '1',
  `is_flying` tinyint(1) default '0',
  `is_shooting` tinyint(1) default '0',
  `unit_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

CREATE TABLE `units` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `image` blob,
  `unit_property_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `image_blocked` blob,
  `image_checked` blob,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `gender` varchar(255) character set latin1 collate latin1_general_ci default NULL,
  `no_of_wins` int(11) default NULL,
  `no_of_losses` int(11) default NULL,
  `scores` int(11) default NULL,
  `avatar` longblob,
  `avatar_content_type` varchar(255) default NULL,
  `date_of_birth` date default NULL,
  `last_time_online` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=67 DEFAULT CHARSET=latin1;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('10');

INSERT INTO schema_migrations (version) VALUES ('11');

INSERT INTO schema_migrations (version) VALUES ('12');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20080706113103');

INSERT INTO schema_migrations (version) VALUES ('20080706130728');

INSERT INTO schema_migrations (version) VALUES ('20080711102717');

INSERT INTO schema_migrations (version) VALUES ('20080712113726');

INSERT INTO schema_migrations (version) VALUES ('20080712114448');

INSERT INTO schema_migrations (version) VALUES ('20080713102736');

INSERT INTO schema_migrations (version) VALUES ('20080714105708');

INSERT INTO schema_migrations (version) VALUES ('20080718113401');

INSERT INTO schema_migrations (version) VALUES ('20080719090527');

INSERT INTO schema_migrations (version) VALUES ('20080719193636');

INSERT INTO schema_migrations (version) VALUES ('20080720095709');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('8');