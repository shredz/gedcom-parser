GedcomParser
================

Ruby on Rails
-------------

This application requires:

- Ruby 2.1.2
- Rails 4.2.1

Setup Guide
-----------
- Clone the application

- To install gem dependencies run:
  'bundle'

- Configure database.yml file

- Setup DB using:
  'rake db:create'
  'rake db:migrate'

- Visit localhost:3000 and upload file to be converted.

Assumptions
-----------
This parser works only for utf-8 encoded files. If any other format is upload there could be data loss.

Notes
-----
Stack class has been added in initializers to keep code clean and use some of its utility methods.


License
-------
Neosoft
