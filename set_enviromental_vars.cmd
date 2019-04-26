@echo off
setlocal EnableDelayedExpansion

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Create symlink to latest java 8 version
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

c:
cd "C:\Program Files\Java\"
mklink /d "jdk1.8.0_latest" "jdk1.8.0_211"

setx JAVA_HOME "C:\Program Files\Java\jdk1.8.0_latest"
setx MAVEN_HOME "D:\tools\apache-maven-3.2.5"
setx WAS_HOME "D:\tools\IBM\WebSphere\85\AppServer"

setx PATH !PATH!;%MAVEN_HOME%\bin;%WAS_HOME%\bin



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::Install Eclipse IDE
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

mkdir "D:\tools\eclipse"
mkdir "D:\workspaces\ECLP"


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Install DB2 drivers
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

copy /y ^
    "D:\tools\IBM\WebSphere\85\AppServer\deploytool\itp\plugins\com.ibm.datatools.db2_2.1.110.v20121008_1514\driver\*" ^
    "D:\tools\IBM\WebSphere\85\AppServer\java\lib"

mkdir "D:\usr\apps\type4\db2\standard"


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Install certificates
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

c:
cd "c:\Program Files\Java\jdk1.6.0_45\jre\bin"

echo Enter "changeit" as password
echo Then click yes for "Trust this certificate?"

keytool -import -keystore ../lib/security/cacerts -file C:\Temp\digi.cer


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Add repo.forge.lmig.com certificate to local eclipse VM
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

d:
cd "D:\tools\eclipse\binary\com.sun.java.jdk8.win32.x86_64_1.8.0.u66\jre\bin"

echo Enter "changeit" as password
echo Then click yes for "Trust this certificate?"

keytool -import -keystore ../lib/security/cacerts -file c:\Temp\RepoLibertyForge_cert.cer


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Update hosts file
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

copy /y hosts "C:\Windows\System32\drivers\etc"
::del /f /q "C:\Windows\System32\drivers\etc\hosts"
::mklink "C:\Windows\System32\drivers\etc\hosts" hosts


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Create logging folders
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

mkdir "D:\opt\was_logs\cl-dial"

