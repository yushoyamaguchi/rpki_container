import sys
import os

def generate_yaml(nodes):
    data = "nodes:\n"
    for i in range(1, nodes + 1):
        data += f"""
- name: R{i}
  image: frrouting/frr:latest
  docker_run_extra_args: --entrypoint bash
  interfaces:
  - {{ name: net0, type: direct, args: R{(i % nodes) + 1}#net1 }}
  - {{ name: net1, type: direct, args: R{((i + 1) % nodes) + 1}#net0 }}
  sysctls:
  - sysctl: net.ipv4.ip_forward=1
"""
    data += "\nnode_configs:\n"
    for i in range(1, nodes + 1):
        data += f"""
- name: R{i}
  cmds:
  - cmd: sed -i -e 's/bgpd=no/bgpd=yes/g' /etc/frr/daemons
  - cmd: /usr/lib/frr/frrinit.sh start
  - cmd: ip addr add 10.0.{i}.1/24 dev net0
  - cmd: ip addr add 10.0.{((i + 1) % nodes) + 1}.2/24 dev net1
  - cmd: >-
      vtysh -c "conf t"
      -c "router bgp {i}"
      -c "no bgp ebgp-requires-policy"
      -c ' bgp router-id 1.1.1.{i}'
      -c "neighbor 10.0.{i}.2 remote-as {(i % nodes) + 1}"
      -c "neighbor 10.0.{((i + 1) % nodes) + 1}.1 remote-as {((i + 1) % nodes) + 1}"
      -c ' address-family ipv4 unicast'
      -c '  redistribute connected'
      -c ' exit-address-family'
      -c '!'
"""
    return data


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python <script.py> <number of nodes>")
        exit(1)

    nodes = int(sys.argv[1])
    if nodes < 3:
        print("Number of nodes must be greater than 3")
        exit(1)
    elif nodes > 254:
        print("Number of nodes must be less than 254")
        exit(1)

    data = generate_yaml(nodes)

    dir_name = 'test_{}'.format(nodes)
    if not os.path.exists(dir_name):
        os.makedirs(dir_name)
    with open(f"test_{nodes}/spec.yaml", 'w') as file:
        file.write(data)
