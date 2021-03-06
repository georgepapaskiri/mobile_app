CREATE ALGORITHM=TEMPTABLE DEFINER='root'@'%' SQL SECURITY DEFINER VIEW `view_tariff_groups`
AS
select
  distinct `AH_TARIFF_GROUPS`.`tariff_group_id` AS `tariff_group_id`,
  `AH_TARIFF_GROUPS`.`tariff_group_name` AS `tariff_group_name`
from
  `AH_TARIFF_GROUPS`
order by
  `AH_TARIFF_GROUPS`.`tariff_group_id`;