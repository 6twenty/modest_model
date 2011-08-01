# ModestModel

## Overview

Inspired by Crafting Rails Applications by Jose Valim, ModestModel is an ActiveModel-compliant class that allows you to quickly create simple, table-less models. The intended use is to back interactions with external APIs with Ruby-friendly models rather than hashes.

## Example

    json = MyExternalApi.call('/some/path')
    attributes_hash = JSON.decode(json)
    
    # => {'name' => 'Michael', 'email' => 'michael@example.com'}

    class SampleModel < ModestModel::Base
      attributes :name, :email
    end
    
    SampleModel.new(attributes_hash)
    
    # => #<SampleModel @name="Michael"...
    
## Features

ModestModel includes the following ActiveModel modules:

* `ActiveModel::Conversion`
* `ActiveModel::Naming`
* `ActiveModel::Translation`
* `ActiveModel::Validations`
* `ActiveModel::AttributeMethods`

These allow your ModestModel models to act almost the same as an ActiveRecord model, but without the database. You can mass-assign attributes, add validations, add translations, and call familiar methods like `model_name.human`.

Please refer to chapter 2, Building Models with Active Model, from [Crafting Rails Applications](http://pragprog.com/book/jvrails/crafting-rails-applications) for an in-depth explanation of the inner workings of ModestModel.

## Credits

This code has been derived from Crafting Rails Applications by Jose Valim, so all credit goes to Jose and [Plataforma](http://blog.plataformatec.com.br/) for granting permission to release this gem.