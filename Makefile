all: run

vehlib:
	javac -d bin -classpath bin/ -sourcepath src/ src/Vehlib.java

run: vehlib
	java -classpath bin:bin/ojdbc7.jar Vehlib

.PHONY: doc run
