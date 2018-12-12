#!/bin/bash

#!/bin/bash
case $1 in
    jdk6)
        export JAVA_HOME=/usr/local/java/jdk1.6.0_45
        ;;
    jdk7)
        export JAVA_HOME=/usr/local/java/jdk1.7.0_79
        ;;
    jdk8)
        export JAVA_HOME=/usr/local/java/jdk1.8.0_74
        ;;
        *)
        export JAVA_HOME=/usr/local/java/jdk1.8.0_74
        ;;
esac

export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH
export CLASSPATH=$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib

java -version
