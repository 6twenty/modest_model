# ModestModel [![Build Status](https://secure.travis-ci.org/6twenty/modest_model.png)](https://secure.travis-ci.org/6twenty/modest_model.png])

## Overview

Inspired by [Crafting Rails Applications](http://pragprog.com/book/jvrails/crafting-rails-applications), ModestModel makes working with structured data (like hashes) friendlier and more flexible. ModestModel models mimic ActiveRecord models to make them familiar to most developers and provide a base from which to build custom models should you need to.

## Generic Example

In it's most basic form, ModestModel simply works like a hash:

    mm = ModestModel.new
    mm[:name] = 'Michael'
    mm[:name]
    # => 'Michael'
    
But maybe you have a hash of attributes already? No problem!

    hash = { 'name' => 'Michael', 'email' => 'michael@example.com' }
    mm = ModestModel.new(hash)
    mm[:name]
    # => 'Michael'
    
    mm.delete('name')
    # => 'Michael'
    
    mm[:name]
    # => NoMethodError: undefined method 'name'
    
Perhaps you prefer the JSON style of working with objects?

    mm = ModestModel.new
    mm.name = 'Michael'
    mm.name
    # => 'Michael'
    
`ModestModel.new` creates a brand new class for you, which makes it easy to extend on the fly. The class inherits from `ModestModel::Generic`, which adds a few helper methods (providing the hash and JSON functionality) and in turn inherits from `ModestModel::Base` (see below).

## Structured Example

If you're like me, you prefer a more structured approach of defining your models beforehand. ModestModel was created to support an external API which returns JSON data:

    json = MyExternalApi.call('/some/path.json')
    attributes_hash = JSON.decode(json)
    # => {'name' => 'Michael', 'email' => 'michael@example.com'}

    class SampleModel < ModestModel::Base
      attributes :name, :email
    end
    
    sm = SampleModel.new(attributes_hash)
    # => #<SampleModel @name="Michael"...
    
    sm.name
    # => 'Michael'
    
But there's much more to it than that! ModestModel includes a great deal of functionality provided by ActiveModel, and then some!

### Validations

    class SampleModel < ModestModel::Base
      attributes :name, :email
      validates :name, :presence => true
    end
    
    sm = SampleModel.new
    sm.valid?
    # => false
    
    sm.name = 'Michael'
    sm.valid?
    # => true
    
### Associations

    class Parent < ModestModel::Base
      attributes :name
      has_many :children
    end
    
    class Child < ModestModel::Base
      attributes :name
      belongs_to :parent
    end
    
    p = Parent.new(:name => 'Michael')
    c = Child.new(:name => 'Isla')
    
    p.children << c
    p.children
    # => [#<Child @name="Isla"...>]
    
    c.parent
    # => #<Parent @name="Michael"...>
    
    # Associations are validated, too!
    
    class Uncle < ModestModel::Base
      attributes :name
    end
    
    u = Uncle.new(:name => 'Gary')
    
    p.children << u
    # => AssociationTypeMismatch: expected Child, got Uncle
    
    p.children = [u]
    # => AssociationTypeMismatch: expected Child, got Uncle
    
## Installation

ModestModel has been tested on MRI 1.8.7 and 1.9.2.

### Rubygems

    gem install modest_model
    
### Bundler

    gem 'modest_model'

## Features

Your ModestModel models act almost the same as an ActiveRecord model, but without the database. You can mass-assign attributes, add validations, add translations, and call familiar methods like `model_name.human` and `to_json`.

ModestModel began by extracting the Mail Form gem from chapter 2, "Building Models with Active Model", of [Crafting Rails Applications](http://pragprog.com/book/jvrails/crafting-rails-applications) by Jose Valim. This chapter therefore provides an excellent in-depth explanation of some of the inner workings of ModestModel.

## Credits

The core code has been derived from [Crafting Rails Applications](http://pragprog.com/book/jvrails/crafting-rails-applications) by Jose Valim, so all credit goes to Jose and [Plataforma](http://blog.plataformatec.com.br/) for granting permission to release this gem.