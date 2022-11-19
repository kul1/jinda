<style>code { font-size: 0.8em;}</style>

<%= File.read('README.md') %>

***

# Help (UNDER CONSTRUCTION: DUI)

<%= render :partial=>'jinda/modul.md', :collection=> Jinda::Module.all.asc(:seq) %>

***

# Admin 

## Data Structure

<%- models= @app.elements["//node[@TEXT='models']"] %>

<%= render :partial=>'jinda/model.md', :collection=> models.map {|m| m.attributes["TEXT"] } %>

***

# Contents

## markdown

This document created and edited with 
<a href="http://daringfireball.net/projects/markdown/syntax" target="_blank">markdown</a>

Contents:

* Requirement at `README.md`
* Controller Help at  `app/controllers/system.md`
* Project at  `app/views/project/<งาน>.md`
*
*
