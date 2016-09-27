# caracalla
candlepin server test utilities

currently this repository hosts jmeter tests and supporting utilities to run performance tests on candlepin server REST APIs.

to run test via command line:
* tweak candlepin-throughput.properties as needed
* generate following input files in a folder "input_data":
  * consumers_uuid_certs_ser.csv : consumer uuid
  * consumers_uuid.csv : consumer uuid
  * consumer_uuids-serials.csv : consumer_uuid, serials
  * get_owners_ownerkey_consumers.csv : ownerkey
  * hypervisors.csv : ownerkey, numVirtHosts, numVirtGuests
  * owners_account.csv : ownerkey
  * owners_account_info.csv : ownerkey
  * owners_account_pools.csv : ownerkey
  * owners_account_subs.csv : ownerkey
  * pools_owner_id.csv : owner id
  * post_consumers_uuid_entitlements.csv : ownerkey, poolid, sku, totalAvailable, expires
* execute the test:
  * jmeter -n -t candlepin-throughput.jmx -l results.jtl -p candlepin-throughput.properties
