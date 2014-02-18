## tweetpin

tweetpin is a daemon that reads messages from a beanstalk queue and 
post them to twitter.

The daemon developed for http://board.gr that requires to post some info for new blog posts 
on twitter.

If you find this script useful please feel free to modify it according to your needs. 

## Usage

Before you use the script you need to have installed the following gems

  * beanstalk-client
  * twitter
  * daemons

All the required parameters for the daemon are stored in the config.yaml file.
Please, have a look at the example config file and modify it accordingly.

The default path for the configuration file is /etc/tweetpin/config.yaml

## How it works

Suppose you have a rails blog application and you want to post all new blog posts on twitter.
You can create an ActiveRecord Observer for the post model (or whatever is called), and publish 
the post title and the string returned from the to_param() method of the post to the beanstalk 
queue.

The following example sets the string to return from the to_param() method in the post model.

    def to_param
      "#{id}-#{title.parameterize}"
    end

Observer example code:

For the rails application you can use the [ActiveMessaging](http://code.google.com/p/activemessaging/ "ActiveMessaging") framework.

    require 'activemessaging/processor'

    class PostObserver < ActiveRecord::Observer
      include ActiveMessaging::MessageSender
  
      publishes_to :tweets_queue
  
      def after_create(post)
        tweet = YAML.dump(:path => "#{post.to_param}", :title => post.title)
        publish :tweets_queue, tweet
      end
    end
    
As you can see in the above example the observer just publishes the title and string (the string 
will be used by INU to construct the URL) in YAML.

The twitter update then collects the message from the beanstalk queue, constructs the post URL,
shorts the URL using bit.ly and finally post the message to twitter.

