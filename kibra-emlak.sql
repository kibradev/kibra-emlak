REATE TABLE `kibra_emlak` (
  `id` int(1) NOT NULL,
  `sifre` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `kibra_emlak` (`id`, `sifre`) VALUES
(1, 11);

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`, `type`, `unique`, `description`, `image`, `shouldClose`, `combinable`) VALUES
('emlak_key', 'Emlakçı Depo Anahtar', 0.01, 0, 1, 'item', 'false', 'Emlakçı Depo Anahtarı', 'motel_key.png', '0', NULL)
;
