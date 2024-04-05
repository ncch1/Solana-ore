#!/bin/bash

# Update package
sudo apt update && sudo apt update -y

sudo apt install cargo -y

sh -c "$(curl -sSfL https://release.solana.com/v1.18.4/install)"

cargo install ore-cli

sudo tee /etc/systemd/system/solanaore.service > /dev/null <<EOF
[Unit]
Description=Solana ore Farmer
After=network.target
StartLimitIntervalSec=0
[Service]
User=root
ExecStart=/root/.cargo/bin/ore --rpc https://api.mainnet-beta.solana.com --keypair /root/.config/solana/id.json --priority-fee 200000 mine --threads 4
Restart=always
RestartSec=120
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

sudo systemctl enable solanaore.service
sudo systemctl start solanaore.service

echo "Setup complete."
