## Awesome Dump ##
Awesome Dump is Ruby library that dumps Ruby objects as nested hashes/arrays, exposing their internal structure in a form safe for conversion to JSON, YAML, or other data formats.

Notes:

*	Makes sure recursive object graphs are ellipse'd and all relevant data is outputted cleanly (i.e. advantages over just using a plain to_json).
*	Awesome Dump'ed data looks awesome when converted to_json, then viewed with a JSON viewer (e.g. JSONView (https://addons.mozilla.org/en-US/firefox/addon/10869/), FirePHP/FireConsole (http://www.firephp.org/), or json2html (http://json.bloople.net/)).
*	This library is very much not-done. It's inconsistent at times and subject to lots of improvement.

### Installation ###
	# Installing as Rails plugin
	$ ruby script/plugin install git://github.com/slippyd/awesome_dump.git

	# Installing as a Ruby library
	$ git clone git://github.com/slippyd/awesome_dump.git lib/awesome_dump

	# Installing as a Ruby library, with Git submodules
	$ git submodule add git://github.com/slippyd/awesome_dump.git lib/awesome_dump
	$ git submodule init
	$ git submodule update

	# Cloning the repository
	$ git clone git://github.com/slippyd/awesome_dump.git

### Usage ###

	require 'ad'
	some_object.ad

	require 'ad', 'json'
	some_object.ad(:escape => :safe).to_json

	require 'ad', 'yaml'
	some_object.ad(:escape => :quote).to_yaml

Supported options:

*	":escape => :safe": Quotes constructs that probably won't translate well into languages other than Ruby (e.g. symbols, classes). Can result in ambigious or lossy results if naming conflicts occur.
*	":escape => :quote": Quotes every piece of data that's dumped (i.e. numbers become strings and Strings become strings that start and end with a quote). Theoretically, this conversion should be reversible back into the original data.

### Examples ###

Ruby:
	
	require 'rubygems'
	require 'json'
	require 'awesome_dump/init'
	
	class Cow
	  def initialize
	    @moo = true
	  end
	end
	
	data = [false, 42, %w(forty two), {:how => 'now', 'brown' => Cow.new}]
	puts "inspect:\n\t" + data.inspect
	puts "ad.inspect:\n\t" + data.ad.inspect
	puts "to_json:\n\t" + data.to_json
	puts "ad(:escape => :safe).to_json:\n\t" + data.ad(:escape => :safe).to_json

Output:
	
	inspect:
		[false, 42, ["forty", "two"], {:how=>"now", "brown"=>#<Cow:0x101069210 @moo=true>}]
	ad.inspect:
		[false, 42, ["forty", "two"], {:how=>"now", "brown"=>{:@moo=>true, :class=>Cow, :object_id=>2156087560}}]
	to_json:
		[false,42,["forty","two"],{"how":"now","brown":"#<Cow:0x101069210>"}]
	ad(:escape => :safe).to_json:
		[false,42,["forty","two"],{":how":"now","brown":{"class":"Cow","@moo":true,"object_id":2156087560}}]


### Setting Custom Defaults ###
You can set your own default options by creating ``.adrc`` file in your home
directory. Within that file assign your	 defaults to ``AwesomeDump.defaults``.
For example:

	# ~/.adrc file.
	AwesomeDump.defaults = {
	  :escape => :quote
	}

### Note on Patches/Pull Requests ###
* Fork the project on Github.
* Make your feature addition or bug fix.
* Add specs for it, making sure $ rake spec is all green.
* Commit, do not mess with rakefile, version, or history.
* Send me a pull request.

### Contributors ###

awesome_print:

* Michael Dvorkin -- http://github.com/michaeldv
* Daniel Bretoi -- http://github.com/danielb2
* eregon -- http://github.com/eregon
* Tobias Crawley -- http://github.com/tobias

### License ###
Copyright (c) 2010 Slippy Douglas
	'awesome_dump' + 64.chr + 'slippyd.com'

Based on awesome_print, Copyright (c) 2010 Michael Dvorkin
	%w(mike dvorkin.net) * "@" || %w(mike fatfreecrm.com) * "@"

Released under the MIT license. See LICENSE file for details.