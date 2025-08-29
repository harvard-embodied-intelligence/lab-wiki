# Lab Wiki

## Starting Computing Environment

You can ssh into the cluster using the following command:

```
ssh <username>@login.rc.fas.harvard.edu
```

To request a FASRC account, please fill out the form [here](https://portal.rc.fas.harvard.edu/request/account/new). 

To get access to the Kempner cluster, please additionally fill out the google doc [here](https://forms.gle/drDyBweFshM697vf6).


## Storage Locations

Temporary Scratch Storage (Will get deleted). We have 50TB
of storage here

```
/n/netscratch/ydu_lab/
```

Larger Persistent Memory Storage (4TB of storage)

```
/n/holylabs/LABS/ydu_lab
```

Larger Persistent Memory Storage (30TB of storage)

```
/net/holy-isilon/ifs/rc_labs/ydu_lab
```

## Compute Resources

There are several allocation GPU partitions (kempner, kempner_h100, kempner_requeue, gpu_requeue). 

More details can be found [here](https://handbook.eng.kempnerinstitute.harvard.edu/intro.html)

- The kempner_h100 partition allows high priority allocations of H100s
- The kempner partition allow allocations of A100s
- The kempner_requeue partition allows for lower priority allocation of both H100s and A100s. This is the recommended partition to you
- The gpu_requeue partition allows for lower priority allocations of SEAS GPUs. This partition has less resources.

For larger cluster allocations, please fill out the form [here](https://docs.google.com/forms/d/e/1FAIpQLSflr2ksP44isrgqpahRQCUD3mw8AKwUaLM0fU0aMDtVzoACVQ/viewform)

## Conda Configuration for Cluster

When using conda on the cluster, you may need to configure channels for better package resolution:

```bash
# Remove nodefaults from the channel list
conda config --remove channels nodefaults

# Switch channel priority to flexible (so conda can mix channels)
conda config --set channel_priority flexible

# Add defaults channel back
conda config --add channels defaults
```
## Kempner-Wide Meetings
### All lab lunch
Every week at Wednesday 12:30pm-14:00pm, Kempner conference room (SEC 6.242)

### All lab ML reading group 
Every week on Thursdays 12:30pm - 14:00pm, Kempner conference room (SEC 6.242)

### Diffusion special reading group 
TBD (contact David Alvarez-Melis dam@seas.harvard.edu)

## Workstations
Two workstations are set up in 4.430 and 4.432, each with two RTX5090.
### Connect to workstations with SSH
```bash
ssh [user]@10.250.238.108
ssh [user]@10.250.91.122
```
Please check Slack for details of usernames and passwords.
### Connect to workstations through Remote Desktop
If you want to use the remote desktop, please install AnyDesk first. Then you need to add your AnyDesk ID to the "Global Setting -> Security -> Access Control List" to enable remote desktop.
### VNC support
The workstation `10.250.238.108` has VNC support. If you want to start a virtual desktop, follow the instructions below:
1. On the workstation, run the following commands:
```bash
sudo vncserver
```
It will start a remote desktop with ID `:[id]`. Generally, the VNC will listen on port `590[id]`. You can use `sudo vncserver -list` to check detailed information.

2. On your personal computer, run:
```bash
ssh [user]@10.250.238.108 -L 5900:localhost:590[id]
```
This command will build a tunnel from your `5900` port to the workstation's `590[id]` port. 
Then you can use an arbitrary VNC viewer (such as RealVNC or TigerVNC) and connect to `localhost::5900` to access the virtual desktop.


