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

### All lab reading group 
Every week on Thursdays 12:30pm - 14:00pm, Kempner conference room (SEC 6.242)

### Diffusion special reading group 
TBD (contact David Alvarez-Melis dam@seas.harvard.edu)

