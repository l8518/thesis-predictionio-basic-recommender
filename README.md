# BasicRecommender - A Basic Recommender System used for EFARS

This is a basic recommender system based on the Apache Prediction IO ML Server, that is dedicated specifically for my thesis *Performance Benchmark for Recommender System Architectures*.

## What does this image include?

This image is inspired by the *Quick Start - E-Commerce Recommendation Engine Template* from predictionio.apache.org. It's is build on their example Scala Engine with little customizations. Check https://github.com/l8518/predictionio-template-recommender.git.

## How does this image work?

This image basically contains a ready-to-go BasicRecommender, that is started intially and then trained and deployed every two minutes. You can change this behaviour by updating the following enviroment variables:
- `BASIC_REC_WARM_UP_DELAY` (warm up time in seconds to allow other components booting up, default to 30 seconds)
- `BASIC_REC_TRAIN_DEPLOY_STEPS_SKIPPED` (cron job executes every two minutes, the steps skipped definies how many steps are skipped after each train and deploy)

## Security

As this image is required to be ready-to-go default-secret keys are provided. You can, and should override this default secret, which can be down by the following enviroment var: `BASIC_REC_DEFAULT_ACCESSKEY`

## Usage / License

Feel free to use this image for your own purposes, an orientation on how to encapsulate a ready to deploy PrecidtionIo engine (possibly not for production use recommended) or other topics (e.g. crontab in Docker).