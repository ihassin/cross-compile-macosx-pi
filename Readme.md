# Introduction

The Pi is great, but, alas, it's slow. Also, I configured mine to be headless, so no IDE for me while working on it.
I used this little "hello world" project to set up my environment for cross compiling, running and debugging arbitrary code from my Mac on to the Pi.

The development workflow is:

- Use the Mac to write code. You don't have to use NetBeans as the IDE, although I suggest you do, since we will be using it to debug on the target.
- Use the makefile to transfer the binary to the pi.
- Use NetBeans to debug the code running on the Pi (remotely)

# Cross compiling

It took me a long time to find a cross compiler. Most of the Googles came back with set up from Linux, and required a VM to connect to. This, of course, is an overkill, and I opted for the solution presented [here](https://www.jaredwolff.com/toolchains/).
Thank you [Jared Wolff](https://www.jaredwolff.com/)!

I used Jared's DMG that he created, and since I am running my Mac case-insensitive, I could not copy the toochain locally, and quickly got used to referencing the cross-compiler toolchain off a mounted volume.

Using the command line, it looks like this:

```
/Volumes/xtools/armv8-rpi3-linux-gnueabihf/bin/armv8-rpi3-linux-gnueabihf-g++ welcome.cc
```
To test that it works, scp it to your Pi and run it there.

# Setting up NetBeans

[NetBeans](https://netbeans.org/downloads/) is the only IDE that I could get to configure for cross-platform development. [XCode](https://developer.apple.com/xcode/) is a horror to work with when it comes to general, non-iOS or Mac development. [CLion](https://www.jetbrains.com/clion/download/) is awesome, but does not lend itself to such configurations and is based on CMAKE, which is an overkill for my needs.
So NetBeans it is:

Create your project, or use the one in github.
Select preferences (Command+,), select the "C/C++" tab at the top of the pane.
There, click on the "Build tools" tab and hit click on "Add" at the bottom.
Fill in the pane like so:
![Build tools setup](/docs/build-tools.png "Build tools setup")

## Beware The Gotcha

As you can see, NetBeans asks for the "Base Directory". I thought that supplying the tool names would suffice, based on the base dir.
For me at least, this did not work and Make complained about finding the tools.
To solve it, I put the full path of the tools in the dialog _and_ added them again in the project's properties page.
If you encounter the same problem, right click the project's root and select "properties".
There, select "Build" and then "C Compiler" etc to add in the full paths:

![Build tools paths](/docs/build-tools-paths.png "Build tools paths")

# Running on a Pi

Once you have some code worthy of being run on the Pi, you transfer the executable to it and run it remotely:

```bash
echo "Copying file"
scp "dist/Debug/GNU-Pi-MacOSX/welcome_1" pi@pi:~
echo "Running file"
ssh pi@pi -C "./welcome_1"

```

# Remote debugging using NetBeans

Step-debugging the code in NetBeans is a treat.

## On the Pi

Run the remote debugger:

```bash
gdbserver :1234 welcome_1
```

Here you're telling gdbserer to run the welcome app on port 1234.

## In NetBeans

From the menu, select "Debug"/"Attach debugger" and fill in the form:

- For debugger, select "remote debugger"
- For target, type "remote pi :1234"
'pi' is the pi's host name (I put mine in /etc/hosts)
':1234' is the port with which NetBeans will communicate on your Pi. This has to be the same port number that you selected in the `gdbserver` command above.

![GDB server setup](/docs/gdbserver.png "GDB server setup")

Hit OK, and a few seconds later, you will see NetBeans's debugger interface.
Step through the exanple to see it in action. 

![Debugging](/docs/debugging.png "Debugging")

## Beware The Gotcha

Unless specified otherwise, gdbdebugger will exit after a single run. That means you'll have to re-issue the gdbserver command for a subsequent session.
 
# Access the example

Please feel free to use, fork and improve this snippet, posted on [github](https://github.com/ihassin/cross-compile-macosx-pi).

I hope you find the example useful!

Happy hacking!
