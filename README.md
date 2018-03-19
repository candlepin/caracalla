# Caracalla

### What is caracalla?
Currently caracalla houses utilities to performance test candlepin/server.

### Infrastructure
 * For each run of the performance test, the infrastructure requires two hypervisors, each with a snapshotted vm, one for deploying candlepin and another for deploying the database.
 * The test shuts down all vms on the hypervisors at the beginning of the test and resets the test vms to their snapshots.
 * This [example ansible hosts file](ansible#example-inventory) shows the needed variables required by the ansible script

### Code organization
 *  Each test and it's resources are housed in its own folder. for example, throughput test against hosted mode are in [candlepin-throughput](candlepin-throughput)
 *  The test is run by ansible, all the ansible scripts and its resources are in the [ansible](ansible) folder
 *  There are some additional utilities in the root folder that support each test. for example:
    * [parse-jtl.py](parse-jtl.py): helps parse all test results.
    * [generate-csv.py](generate-csv.py): generates the csvs which act as input to each test.

### How to add a new test

 * For each test, we need:
   * a new folder for the test's jmx file and all its resources
   * a csv_config.json file which is parsed by generate-csv.py to create csvs for a test against a database
   * a baseline.dict file to track master's perfomance on the same test
   * an expected.dict file where we control our success criteria for each API
   * a properties file where we control test parameters and override values of variables we may not want to opensource
   * A jmeter test file.
   * lastly, we need to add the details about the above files in the `jmeter_test_details` variable [here](ansible/roles/candlepin-user/defaults/main.yml)
   * If you would like the test to run by default, please add the test name to the `jmeter_tests` variable as well
   * We will also need to add a new drop down option in the jenkins job to trigger this new test from jenkins.


### How to run tests?

 * Ensure you have the hosts file and are able to talk to all the hypervisors and vms.
 * Select what tests you want to run, the candlepin branch you want to test and run the test. you can do this in three ways:
   1. by overriding the `jmeter_tests` and `candlepin_branch` variable via command line:
      * ```ansible-playbook ansible/candlepin.yml "--extra-vars=candlepin_branch=my_candlepin_branch jmeter_tests=candlepin-throughput"```
   2. by tweaking the same variables [here](ansible/roles/candlepin-user/defaults/main.yml), and running:
      * ```ansible-playbook ansible/candlepin.yml```
   3. not recommended for when you are working on a new test itself, but you can run the jenkins job too.

### How to evaluate a test result

 * To evaluate the result, run the following command, and if it does not print any thing or does not error out, our test result was successful:
    * ```./parse-jtl.py -c my_result_file.jtl -b my_base_line.dict -e my_expected_dict```
 * If there are any success critieria that we do not meet, the script will error out highlighting the specific error condition.

### What does a failed test mean?

* If a test fails on jenkins, it is not necessarily an issue.
* The author of the PR needs to investigate why the test fails.
  * if it fails at the last step where we evaluate the results, it may not be an issue. please copy the results to the google doc and compare the results with master. if its okay with the reviewer, it may be merged.
  * if it fails before that step, we have either a test setup issue or an issue in the candlepin branch itself, we need to investigate.


### Specific Test notes:

 * bind.jmx
   * This test is a basic test that allows to measure performance of multiple consumers binding against one pool.
   * Steps:
     * Deploy candlepin server ( ./server/bin/deploy -gat )
     * Select a pool generated from the above step and ensure it has a quantity of atleast 100
     * Open the jmx file in jmeter 3.0(+)
     * Select the node marked Entitlement creation and override the variables to point to your local candlepin
     * Consumers are created only once , if you wish to create consumers again , then please change the value of the User Defined Variable "ForceCreateConsumerFile"  to true 
     * run the jmeter test and observe the results.

### Manual Test notes:
All tests in the "manual" subdirectory are designed for use against a manually deployed candlepin in the candlepin vagrant environment. 
These tests do not require the performance VM environment to run. 

 * manual/auto_bind_one_consumer_with_1k_custom_subscriptions_available.jmx
 
   This is a script to create, auto-attach, and then delete of a single consumer in an owner that has 1,000 custom subscriptions.
     Environment set up by the script:
     * Owner named foo
     * Engineering product (71) with a single content set (fooServer)
     * Marketing product "FooProduct"
     * 1k subscriptions of FooProduct that provide the engineering product 71
   * Each pool will have a source subscription but will not have stacking
