
:: create symlink to latest java 8 version
c:
cd "C:\Program Files\Java\"
mklink /d "jdk1.8.0_latest" "jdk1.8.0_211"

setx JAVA_HOME "C:\Program Files\Java\jdk1.8.0_latest"
setx MAVEN_HOME "D:\tools\apache-maven-3.2.5"
setx WAS_HOME "D:\tools\IBM\WebSphere\85\AppServer"

%MAVEN_HOME%\bin;%WAS_HOME%\bin;

:: install certificates
c:
cd "c:\Program Files\Java\jdk1.6.0_45\jre\bin"

echo Enter "changeit" as password
echo Then click yes for "Trust this certificate?"

keytool -import -keystore ../lib/security/cacerts -file C:\Temp\digi.cer

:: Add repo.forge.lmig.com certificate to local eclipse VM
d:
cd D:\tools\eclipse\binary\com.sun.java.jdk8.win32.x86_64_1.8.0.u66\jre\bin

echo Enter "changeit" as password
echo Then click yes for "Trust this certificate?"

keytool -import -keystore ../lib/security/cacerts -file c:\Temp\RepoLibertyForge_cert.cer


:: create logging folders
mkdir D:\opt\was_logs\cl-dial
