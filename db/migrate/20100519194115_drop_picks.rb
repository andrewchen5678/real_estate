class DropPicks < ActiveRecord::Migration
  def self.up
	drop_table :picks
  end

  def self.down
	execute <<oef
CREATE TABLE IF NOT EXISTS `picks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `pickable_id` int(11) NOT NULL,
  `pickable_type` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;
oef
  end
end
