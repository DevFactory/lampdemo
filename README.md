# LAMP stack DevSpaces demo

## Instructions for running in DevSpaces

1. Navigate to `devspace` directory
2. Run `devspaces create` command
3. Once DevSpace is ready, start it using command `devspaces start lamp-demo`
4. Once DevSpace is running, you can sync the source code to DevSpace. For this navigate to the root of the repository `cd ..`, then run `devspaces bind lamp-demo` command.
5. Now connect to DevSpace by running `devspaces exec lamp-demo` command.
6. From your DevSpace run startup script `./start.sh`
