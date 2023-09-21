sudo apt-get update -y
sudo apt-get install -y openssh-client rsync
echo "test"

echo $INSTANCE_IP
echo $AWS_CLI_TOKEN
echo $AWS_SECRET_TOKEN

eval $(ssh-agent -s)
echo "$POOCHIE_TOKEN" | tr -d '\r' | ssh-add -
mkdir -p ~/.ssh
chmod 700 ~/.ssh


# we should probably avoid hardcoding this, in case
# the IP changes
rsync -av -e "ssh -o StrictHostKeyChecking=no" ./* ec2-user@$INSTANCE_IP:/var/poochie-pals/
rsync -av -e "ssh -o StrictHostKeyChecking=no" ./* ec2-user@$INSTANCE_IP_TWO:/var/poochie-pals/

echo "rsync finished"
ssh -o StrictHostKeyChecking=no ec2-user@$INSTANCE_IP "sudo systemctl restart poochie-pals"
ssh -o StrictHostKeyChecking=no ec2-user@$INSTANCE_IP_TWO "sudo systemctl restart poochie-pals"
echo "reload finished"

