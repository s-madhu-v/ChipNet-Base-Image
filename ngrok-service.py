from pyngrok import conf, ngrok
import os

conf.get_default().region = "in"

ngrok_auth = ""
directory = "/"
filename = "access-link.txt"

with open(os.path.join(directory, "ngrok_auth.txt"), mode='r') as f:
    for line in f:
        print(f"Line: {line[:-1]}")
        ngrok_auth = line[:-1]

ngrok.set_auth_token(ngrok_auth)

if not os.path.exists(directory):
    os.makedirs(directory)

ssh_tunnel = ngrok.connect(22, "tcp")
print(ssh_tunnel.public_url)

with open(os.path.join(directory, filename), mode='w') as f:
    f.write(ssh_tunnel.public_url)

ngrok_process = ngrok.get_ngrok_process()

try:
    # Block until CTRL-C or some other terminating event
    ngrok_process.proc.wait()
except KeyboardInterrupt:
    print(" Shutting down server.")

    ngrok.kill()
