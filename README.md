Basic docker image for working from the command line within a GAE at UCLH.

To use this setup:
	1.	Save the shell script as ⁠devenv.sh in your home directory
	2.	Make it executable:
```
chmod +x ~/dsdo.sh
```
	3.	Add an alias to your ⁠.bashrc or ⁠.zshrc:
```
alias dsdo='~/dsdo.sh'
```
	4.	Use it like this:
```
# First time or when you need to rebuild:
dsdo build

# To run the container:
dsdo run
```

This setup will:
	•	Pass through all the necessary proxy settings during build and run
	•	Set the correct UID/GID for file permissions
	•	Mount your current directory as the workspace
	•	Provide all the tools you requested (Python, Julia, Visidata, psql, Neovim)
	•	Handle the proxy configuration both during build and runtime
The script handles all the complexity of the proxy settings and UID/GID mapping while keeping the usage simple. You can also easily modify the Dockerfile to add more tools or configurations as needed.