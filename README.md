# DiskChecker
Script created for users due to constant problems with network drives.
By design, it supports 3 different SMB servers, including 2 different domains to which computers are connected.

General informations:

- One of the domains does not share any resources, but uses the shared resources.
- x.x.x.x is the main hosting server in Warsaw.
- x.x.z.z is a server in the office in Poznań, which only hosts two network resources.
- x.x.x.y is a separate SMB server for designated contract purposes.
- Access data to the x.x.z.z and x.x.x.y servers are unchanged for users.
- Access data to resources of each server is different.
- Users in the x.x.z.z subnetwork also use x.x.x.x resources
- Users on the x.x.z.z subnetwork are working in a different domain
- Computers only use two language versions of the system: Polish and English.

Functional assumptions:
- Users choose in which office they work and in what mode of operation (remote / stationary).
- Each user can either manually or automatically connect the drives.
- In case of an error, the user will be informed what to do.
