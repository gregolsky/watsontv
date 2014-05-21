#!/bin/bash
yes | sudo gem uninstall watsontv 
rm watsontv*.gem
gem build watsontv.gemspec && sudo gem install watsontv*.gem
