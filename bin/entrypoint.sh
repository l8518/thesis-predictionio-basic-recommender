# setup env for traind and deploy
export BASIC_REC_TD_COUNTER=0
echo BASIC_REC_TD_COUNTER=0 > /etc/basic_rec_td_counter
echo BASIC_REC_IS_TRAINING="ran" > /etc/basic_rec_training
# Copy Enviroment Docker Container
printenv | grep -v "no_proxy" >> /etc/environment
sleep $BASIC_REC_WARM_UP_DELAY # wait a bit, for eveythin to be ready, before app creation
# Start the eventserver
pio eventserver &

# Start cron daemon to allow training and deployment, after eventserver online
cron &

if pio app show BasicRecommender; then
    echo "BasicRecommender already created, skipping creation \n"
else
    # Setup the app
    pio app new BasicRecommender
    pio accesskey new --key $BASIC_REC_DEFAULT_ACCESSKEY BasicRecommender    
fi

# Start bash 
/bin/bash -c 'trap : TERM INT; sleep infinity & wait'