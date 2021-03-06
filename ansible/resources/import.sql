ALTER DATABASE candlepin CHARACTER SET utf8 COLLATE utf8_general_ci;
delete from cp_job;
update QRTZ_TRIGGERS set next_fire_time = (select unix_timestamp(date_add(now(), interval 1 year)) * 1000);
SET FOREIGN_KEY_CHECKS=0;
delete from QRTZ_BLOB_TRIGGERS;
delete from QRTZ_CRON_TRIGGERS;
delete from QRTZ_FIRED_TRIGGERS;
delete from QRTZ_PAUSED_TRIGGER_GRPS;
delete from QRTZ_SIMPLE_TRIGGERS;
delete from QRTZ_SIMPROP_TRIGGERS;
delete from QRTZ_TRIGGERS;
delete from QRTZ_JOB_DETAILS;
SET FOREIGN_KEY_CHECKS=1;
update cp_pool set enddate = NOW() + INTERVAL 1 YEAR  where  product_uuid in (  select uuid from cp2_products where product_id = 'MCT3295');
update cp_pool set enddate = NOW() + INTERVAL 1 YEAR  where  product_uuid in (  select uuid from cp2_products where product_id = 'ES0113909');
