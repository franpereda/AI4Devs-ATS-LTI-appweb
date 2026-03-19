@REM ----------------------------------------------------------------------------
@REM Licensed to the Apache Software Foundation (ASF) under one
@REM or more contributor license agreements.  See the NOTICE file
@REM distributed with this work for additional information
@REM regarding copyright ownership.  The ASF licenses this file
@REM to you under the Apache License, Version 2.0 (the
@REM "License"); you may not use this file except in compliance
@REM with the License.  You may obtain a copy of the License at
@REM
@REM   http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing,
@REM software distributed under the License is distributed on an
@REM "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
@REM KIND, either express or implied.  See the License for the
@REM specific language governing permissions and limitations
@REM under the License.
@REM ----------------------------------------------------------------------------

@REM ----------------------------------------------------------------------------
@REM Apache Maven Wrapper startup batch script, version 3.3.2
@REM ----------------------------------------------------------------------------

@IF "%__MVNW_ARG0_NAME__%"=="" (SET "BASE_DIR=%~dp0") ELSE SET "BASE_DIR=%__MVNW_ARG0_NAME__%"

@SET MAVEN_PROJECTBASEDIR=%BASE_DIR%
@IF NOT "%MAVEN_BASEDIR_OVERRIDE%"=="" SET "MAVEN_PROJECTBASEDIR=%MAVEN_BASEDIR_OVERRIDE%"

@SET WRAPPER_PROPERTIES=%MAVEN_PROJECTBASEDIR%.mvn\wrapper\maven-wrapper.properties

@FOR /F "usebackq tokens=1,2 delims==" %%A IN ("%WRAPPER_PROPERTIES%") DO (
    @IF "%%A"=="distributionUrl" SET "DISTRIBUTION_URL=%%B"
    @IF "%%A"=="wrapperVersion" SET "WRAPPER_VERSION=%%B"
)

@SET MAVEN_WRAPPER_JAR=%MAVEN_PROJECTBASEDIR%.mvn\wrapper\maven-wrapper.jar
@SET WRAPPER_JAR_URL=https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/%WRAPPER_VERSION%/maven-wrapper-%WRAPPER_VERSION%.jar

@IF NOT EXIST "%MAVEN_WRAPPER_JAR%" (
    @ECHO Downloading Maven Wrapper JAR...
    @IF EXIST "%JAVA_HOME%\bin\java.exe" (
        @SET JAVA_CMD="%JAVA_HOME%\bin\java.exe"
    ) ELSE (
        @SET JAVA_CMD=java
    )
    @powershell -NoProfile -Command "Invoke-WebRequest -Uri '%WRAPPER_JAR_URL%' -OutFile '%MAVEN_WRAPPER_JAR%'" || GOTO error
)

@SET JAVA_HOME_CANDIDATES=^
    "%JAVA_HOME%" ^
    "C:\Program Files\Eclipse Adoptium\jdk-21*" ^
    "C:\Program Files\Microsoft\jdk-21*" ^
    "C:\Program Files\Java\jdk-21*"

@IF NOT "%JAVA_HOME%"=="" GOTO findJavaDone
@FOR %%I IN (%JAVA_HOME_CANDIDATES%) DO (
    @IF EXIST "%%~I\bin\java.exe" (
        @SET "JAVA_HOME=%%~I"
        @GOTO findJavaDone
    )
)
:findJavaDone

@IF NOT "%JAVA_HOME%"=="" (
    @SET "JAVA_CMD=%JAVA_HOME%\bin\java.exe"
) ELSE (
    @SET "JAVA_CMD=java"
)

@"%JAVA_CMD%" ^
    -classpath "%MAVEN_WRAPPER_JAR%" ^
    "-Dmaven.multiModuleProjectDirectory=%MAVEN_PROJECTBASEDIR%" ^
    org.apache.maven.wrapper.MavenWrapperMain ^
    %*

@IF %ERRORLEVEL% NEQ 0 GOTO error
@GOTO end

:error
SET ERROR_CODE=%ERRORLEVEL%

:end
EXIT /B %ERROR_CODE%
