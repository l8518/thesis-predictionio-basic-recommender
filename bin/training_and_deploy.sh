if [ -d "$BASIC_REC_HOME/target" ]; then
    # retrieve current counter
    export $(grep -v '^#' /etc/basic_rec_td_counter | xargs)
    export $(grep -v '^#'  /etc/basic_rec_training | xargs)
    echo "T&D check"
    date
    export BASIC_REC_TD_COUNTER=$(($BASIC_REC_TD_COUNTER - 1))
    # store current step counter for consecutive jobs
    printenv | grep "BASIC_REC_TD_COUNTER" > /etc/basic_rec_td_counter
    # traind and deploy if: counter reached zero, and no model is currently training
    if [ "$BASIC_REC_TD_COUNTER" -le 0 ] && [ "$BASIC_REC_IS_TRAINING" != "running" ]; then
        echo "T&D required"
        cd $BASIC_REC_HOME

        echo BASIC_REC_TD_COUNTER=$(($BASIC_REC_TRAIN_DEPLOY_STEPS_SKIPPED)) > /etc/basic_rec_td_counter
        echo BASIC_REC_IS_TRAINING="running" > /etc/basic_rec_training
        # TODO check if --master $BASIC_REC_SPARK_MASTER set, currently removed
        # due to error (obviously spark is started by pio train)
        pio train -- --driver-memory $BASIC_REC_DRIVER_MEM --executor-memory $BASIC_REC_EXECUTOR_MEM
        echo BASIC_REC_IS_TRAINING="ran" > /etc/basic_rec_training
        
        # deploy the trained model
        pio deploy -- --driver-memory $BASIC_REC_DRIVER_MEM
    else
        echo "T&D skipped"
    fi
else
    echo "Waiting for build..."
fi
