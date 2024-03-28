rsync --progress --stats -ruzath -e "ssh -i /home/liuyao/.ssh/id_rsa_vir" "ec2-user@18.223.7.31:/mnt/sharedfs" /home/liuyao/AWS-Results

# rsync --progress --stats -ruzath -e "ssh -i /home/liuyao/.ssh/id_rsa_vir" "ec2-user@18.223.7.31:/mnt/sharedfs/ly-experiments/experiments_output_lyd" /home/liuyao/scratch/deps/aws-setup-lyd/results_32_H100


# --exclude /mnt/sharedfs/hao