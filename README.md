Mobile Automation boilerplate
==============

Here you can find some explanations about this framework
-----------------

To run tests you need to navigate in to platform directory i.e. 'android'

    cd android/

And than execute specific spec with following:

    rspec spec/example_spec.rb

Optionally you can use `--tag` (or `-t`) option to specify which tests you want to run according tags defined in spec. i.e.

    rspec spec/example_spec.rb --tag depth:shallow

Will run all `:shallow` tests

###TODO:

  * Review $driver usage
  * framework structure
  * allure reporter explanation
  * DEBUG mode
  * framework usage tutorial from scratch
  * use mobile proxy + pcaprub for traffic monitoring
