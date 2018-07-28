Listing third party licenses
================================

We can use a maven plugin to check for the licenses of our project's library dependencies.  
An example pom is listed in `pom-licenses.xml`.  

**Maven plugin**: License Maven Plugin, by Codehaus  
**URL**: http://www.mojohaus.org/license-maven-plugin/  
**Goal for single module**: license:add-third-party  
**Goal for multi-module**: license:aggregate-add-third-party  


Configuration
----------------

The plugin is configured in the `pom.xml` file.  
If it's a multi-module maven project, this will be the parent pom.  

The plugin may try to deploy some properties files to the repo defined in your `distributionManagement` section, if you have one (and the build will fail if you don't have write permissions for the repo).  
In this case set `<useRepositoryMissingFiles>false</useRepositoryMissingFiles>`.  


Usage
----------------

Navigate to the project folder and, from the command line, run the following goal:

    mvn license:add-third-party


Output
----------------

The task generates the file `project-name/target/generated-sources/license/THIRD-PARTY.txt`.  

Resulting file structure:

    (license_name) short_description (groupId:artifactId:version - URL)

Example:

    (MIT License) SLF4J API Module (org.slf4j:slf4j-api:1.7.6 - http://www.slf4j.org)


Unknown licenses
----------------

If license information cannot be found for some dependencies, the output will be "Unknown license" instead of the license name.  

Example:  

    (Unknown license) jstl (jstl:jstl:1.2 - no url defined)

The plugin allows manual configuration of license information, so we can specify licenses by hand in a separate file.  
Add `<useMissingFile>true</useMissingFile>` to the configuration of the plugin in the `pom.xml` file.  

Running the `license:add-third-party` task now also generates `project-name/src/license/THIRD-PARTY.properties`.  
Example generated entry:

    # Please fill the missing licenses for dependencies :
    #
    #
    #Tue Jul 24 10:11:19 EEST 2018
    jstl--jstl--1.2=

The properties file can be manually filled in with the missing licenses and will be read by the maven task on next runs.  
