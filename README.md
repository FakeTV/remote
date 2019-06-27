# Setup a USB Remote with PseudoChannel
**Installation and setup of Remote Control Keybinds and PseudoChannel**

![alt text](https://miro.medium.com/max/1000/1*KGvIKhjzLm_Z9-9ZtOzjnA.png)


## Before You Begin (things to note)

- You must have [pseudo-channels](https://github.com/FakeTV/pseudo-channel) ready to go in the `~/channels` directory. 
- Install this on the same Pi as the "controller" Pi, along-side your pseudo-channels "~/channels" dir.
- Your "controller" Pi must be running x-server (i.e. not be headless). 
- x-server cannot run without a display attached to your Pi (attach a display to the HDMI port).
- Open the `./channels/config.cache` file and manually edit the plex server info before beginning this. 

## Setup

1) Clone this repository on your controller Pi along-side the pseudo-channels "~/channels" directory:

`% git clone https://github.com/FakeTV/remote.git`
`% cd remote`

2) Make the "setup.sh" script executable:

`% sudo chmod +x setup.sh`

3) Run the script and follow the promts:

`% ./setup.sh`