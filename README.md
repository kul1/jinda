# Sample Jinda app in docker

Jinda: a rails engine gem to create Rails Workflow & Application Generator using Freemind

Jinda: a tools for Ruby on Rails developer. (Required: basic Ruby on Rails )

## Jinda use the following technologies:

- JQuery Mobile and Bootstrap as Javascript front-end development framework
- Rails Engine as Jinda core for router, helper
- Workflow using Freemind design as XML to control Rails flow.
- User authentication for login and role for each activity
- Support Social authentication: Facebook, Google
- Polymorphic Association in mongodb
- Dynamic role for user and group
- Rails concern & mixins for rails modules and class
- Sample app: Articles, API Note, Document
- Support themes: Jinda_adminlte, Jinda_adminBSB
- Support HTML, HAML, SCSS
- Rails Engine
  <br />

### Installation 

- git clone git@github.com:kul1/jinda-docker.git
- docker-compose up #(wait until rails start)
- browse at port 3000

### Requirement

- Docker install

### What you can expected:

<br />
![Screen Shot 2021-09-06 at 6 37 18 PM](https://user-images.githubusercontent.com/3953832/132274112-e7604bb4-bf40-4dad-be6c-81b570b24033.png)
<br />

# [Jinda](https://github.com/kul1/jinda) 


![Screen Shot 2019-09-07 at 1 00 03 PM](https://user-images.githubusercontent.com/3953832/64478408-f5feb500-d175-11e9-9d07-8b41f3c47924.png)

<br />

## Additional Extension themes also available at

[jinda_adminlte](https://github.com/kul1/jinda_adminlte)

![j18-screen](https://user-images.githubusercontent.com/3953832/34298172-faa7e962-e6e1-11e7-93e2-19dfd4ab42af.png)

[jinda_adminbsb](https://github.com/kul1/jinda_adminbsb)

![jinda-bsb](https://user-images.githubusercontent.com/3953832/34320779-bb0980d2-e7c6-11e7-855c-fafc23487ba5.png)

## Prerequisites

These versions works for sure but others may do.

- Ruby 3.0.0
- Rails 6.1.4
- MongoDB 6
- Freemind 1.0.1

## Convention

- database is MongoDB
- images stored in upload directory, unset IMAGE_LOCATION in `initializer/jinda.rb` to use Cloudinary
- mail use Gmail SMTP, config in `config/application.rb`
- authentication use omniauth-identity


### Screen shot install Jinda

[![yt_logo_rgb_light](https://user-images.githubusercontent.com/3953832/110579381-4fa9bc00-812c-11eb-973e-da9d0f2a8109.png)](https://www.youtube.com/watch?v=XUXv7Yrskjk&feature=youtu.be)
<br />
[![ Jinda Install](https://i9.ytimg.com/vi/XUXv7Yrskjk/mq3.jpg?sqp=CPjUoIIG&rs=AOn4CLBfMkmMtOGz3OfUp2zyhMs3Dy9xrw)](https://www.youtube.com/watch?v=XUXv7Yrskjk&feature=youtu.be)



