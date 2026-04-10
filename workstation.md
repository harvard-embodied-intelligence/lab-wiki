# 🧠 Lab Workstation Access Guide

## 💻 Workstations
Two high-performance workstations are available for lab members:

| Location | Hostname / IP | GPU Configuration |
|-----------|----------------|-------------------|
| 4.430     | `10.250.238.108` | 2 × RTX 5090 |
| 4.432     | `10.251.13.215`  | 2 × RTX 5090 |

---

## 🔐 Connecting via SSH (on Harvard Secure WiFi)

If you are on campus and connected to Harvard Secure WiFi,
you can directly SSH into the workstations using:
```
ssh [username]@10.250.238.108
ssh [username]@10.251.13.215
```
📍 Note: Usernames and passwords are shared privately in the lab Slack channel. You must be on Harvard Secure WiFi for these IPs to work.


## 🌐 Connecting via Tailscale (Off-Campus SSH Access)

When you’re off-campus or not on Harvard Secure WiFi, use Tailscale for secure SSH access.

### 🪜 Setup Steps
1. Install Tailscale
   * Download [Tailscale]((https://tailscale.com/)) for your platform
3. Join the Lab Tailnet
   * Ask Heng/Sarah/Haonan/Chaoqi to add your account (your email address) to the lab’s tailnet.
4. Log In & Switch to Lab Tailnet
   * Open Tailscale on your computer, log in, and select the lab tailnet (not your personal one).
5. SSH into a Lab Workstation
   * Once connected, you can SSH into lab workstations using their Tailscale IPs or names:
   * `ssh [username]@[tailscale-ip]`
   * These IPs can be found in your Tailscale app under the device list.
  
### 🔒 Security and Privacy
Tailscale enforces strict access control for our lab network:

* ✅ Lab members → Lab workstations: allowed
* ✅ Lab workstation → Lab workstation: allowed
* ✅ Your own devices: can SSH each other
* ❌ Lab member A’s devices → Lab member B’s devices: not allowed
* ❌ Lab workstations → Lab members: not allowed
  
This ensures everyone’s privacy and safety — no one can accidentally or intentionally access another member’s personal machine.
  

## 🖥️ Remote Desktop Access (AnyDesk)
For users who prefer a graphical interface:
1. Install [AnyDesk](https://anydesk.com/download).
2. Send your AnyDesk ID to the workstation admin to be added under Global Settings → Security → Access Control List.
3. You can then connect to the workstation’s AnyDesk ID remotely.


## 🪟 VNC Access (4.430 Workstation Only)
The workstation at `10.250.238.108` supports VNC for virtual desktops.

1. Start a VNC Session
  * On the workstation run `sudo vncserver`
  * This will start a VNC desktop with ID `:[id]`.
  * You can list active sessions with `sudo vncserver -list`
2. Connect from Your Computer
  * Create an SSH tunnel with `ssh [username]@10.250.238.108 -L 5900:localhost:590[id]`
  * Then, use a VNC viewer (e.g., RealVNC, TigerVNC) and connect to: `localhost::5900`

