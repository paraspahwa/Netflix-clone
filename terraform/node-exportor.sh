#!/bin/bash
sudo useradd --system --no-create-home --shell /bin/false node_exporter
sudo usermod -aG docker node_exporter
sudo usermod -aG node_exporter node_exporter
sudo usermod -aG node_exporter jenkins
sudo usermod -aG node_exporter jenkins
# download node exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
# extract downloaded file of node exporter
tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz

sudo mv node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin/

rm -rf node_exporter*

sudo vim /etc/systemd/system/node_exporter.service

[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter \
    --collector.logind

[Install]
WantedBy=multi-user.target

sudo systemctl enable node_exporter
sudo systemctl start node_exporter
sudo systemctl status node_exporter

sudo vim /etc/prometheus/prometheus.yml
# add this is prometheus.yml and follow the intentions
  - job_name: node_export
    static_configs:
      - targets: ["localhost:9100"]

# check if configuration is correct
promtool check config /etc/prometheus/prometheus.yml

# reload the config of node_exporter
curl -X POST http://localhost:9090/-/reload



