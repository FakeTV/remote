# Setup a USB Remote with PseudoChannel
**Installation and setup of Remote Control Keybinds and PseudoChannel**

**[Original Blog Post @medium.com]((https://medium.com/@Fake.TV/configuring-a-usb-remote-control-for-faketv-functions-73e4caf60c20))**

![alt text](https://miro.medium.com/max/1000/1*KGvIKhjzLm_Z9-9ZtOzjnA.png)


## Before You Begin (things to note)

- You must have [pseudo-channels](https://github.com/FakeTV/pseudo-channel) ready to go in the `~/channels` directory. 
- Install this on the same Pi as the "controller" Pi, along-side your pseudo-channels "~/channels" dir.
- Your "controller" Pi must be running x-server (i.e. not be headless). 
- x-server cannot run without a display attached to your Pi (attach a display to the HDMI port or somehow spoof it).
- Open the `./channels/config.cache` file and manually edit the plex server info before beginning this. 
- Go to [the original blog post](https://medium.com/@Fake.TV/configuring-a-usb-remote-control-for-faketv-functions-73e4caf60c20) to learn more about testing/setup/configuration.
- If you are using "RasPlex" as a client device the default username/password is: `root/rasplex`
- You may have to manually edit the `lxde-pi-rc.xml` file noted in the above post if that file is not located in the `/home/pi/.config/openbox` directory (or if that dir doesn't exist). 
  - You must manually find this file by searching your OS: 

    `% sudo find / -name "lxde-pi-rc.xml"`. 

    On my install (Raspian "Buster" with Desktop), it was located here: `/etc/xdg/openbox/lxde-pi-rc.xml`. 

  - Edit the `/etc/xdg/openbox/lxde-pi-rc.xml` file by adding the output XML found in `~/remote/temp.xml` to the right place in the file as described in the blog post ("temp.xml" is generated after running the below `setup.sh` file).

    **Using vim:**

     - `% cat ~/remote/temp.xml` - then copy the XML output.

     - `% sudo vim /etc/xdg/openbox/lxde-pi-rc.xml`

     - `:/Launch Task` - search for the string "Launch Task".

     - `</keybind>` - find the closing tag and press "i" to get into "insert mode". Place your cursor right after and make a space for pasting in the new XML.

     - `shift + ins` - while in "insert mode" in vim to paste the XML from the system clipboard (`~/remote/temp.xml`).

     - `:wq` - save and quit.

     - `% sudo service lightdm restart`

## Setup

1) Clone this repository on your controller Pi along-side the pseudo-channels "~/channels" directory:

	- `% git clone https://github.com/FakeTV/remote.git`

	- `% cd remote`

2) Make the "setup.sh" script executable:

	- `% chmod +x setup.sh`

3) Run the script and follow the prompts:

	- `% ./setup.sh`