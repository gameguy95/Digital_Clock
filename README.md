# COMPE470L Digital Clock Lab for Basys 3

<details>
	<summary> Teacher's Project Instructions </summary>
This lab is to create a digital clock of your own design.  As a minimum, it must display the time on the 7 segment LED display using multiplexing of the digits at a rate of exactly 50Hz (1/50Hz= 20 mS for all 4 digits and each digit must be on for 5 mS = 20 mS/4). You must demonstrate the timing accuracy using the scope or the logic analyzer.  

The minimum design for a C grade must display the time and blink the minutes' digit decimal point once per second (on for 0.5 sec, off for 0.5 sec). You must also allow setting the time using the push buttons and switches. The push buttons and DIP switches may be used however you like, but you must be able to set the hours and minutes.  That represents the  minimum required for a C grade on this lab.  

Other things to add for a grade better than C: push buttons and switches can be used to select optional display of seconds, date, alarm time, snooze, enable/disable features, stopwatch, kitchen countdown timer, audio beep output, or anything else you can think of.

NOTE: This is an individual, one-student per project effort, so you must design and implement this project on your own. You may work with others on debugging.  You may help each other out, but the design and code must be your own, or from your previous lab assignments (and identified as such).   You must also write up this lab in a document, so you should keep written notes as you progress because you will have to include them in your report.
</details>

<details>
	<summary> Current Progress </summary>
	The basic clock features work correctly, at the proper speed.
	Extra Credit features:

	+  AM/PM mode  

	+  Toggle AM/PM mode

</details>

<details>
	<summary> How to Use  </summary>

+ Push center button to swap between Clock mode and Set Time mode.  

+ When in set time mode:  

	+ Push left/right buttons to swap between setting minutes and hours.  

	+ Push up/down buttons to increment and decrement time, respectively.  

+ When Switch SW0 is up, the clock will display in military time (00:00 to 23:59). When the switch is down, the clock will display in AM/PM time (12:00 AM to 11:59 PM).  

	+ LED LD0 is the AM/PM indicator. If LED 0 is on, then the current time is HH:YY PM.  
</details>
